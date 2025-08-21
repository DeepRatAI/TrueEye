"""FastAPI application for TrueEye.

This module defines an application factory ``create_app`` which can be used
to construct a configured ``FastAPI`` instance. The API exposes a ``/health``
endpoint for service health checks, a ``/`` endpoint which serves the static
frontend, and a ``/analyze`` endpoint which proxies analysis requests to
LangFlow or provides a local fallback based on the ``TE_PROVIDER``
environment variable.
"""

from __future__ import annotations

import json
import logging
import os
from typing import Optional

import requests
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, Response
from fastapi.staticfiles import StaticFiles

from .models import AnalyzeRequest, AnalyzeResponse
from .utils import extract_text_from_response


logger = logging.getLogger(__name__)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)


def _get_static_path() -> str:
    """Return the absolute path to the static directory packaged with this module."""
    return os.path.join(os.path.dirname(__file__), "static")


def create_app() -> FastAPI:
    """Create and configure the FastAPI application.

    Returns
    -------
    FastAPI
        A configured FastAPI application instance.
    """
    app = FastAPI(title="TrueEye API", version="0.1.0")

    # CORS middleware: allow all origins and methods for flexibility. In a
    # production environment you may wish to restrict these values.
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Mount the static files directory. This serves index.html and assets.
    static_dir = _get_static_path()
    app.mount("/static", StaticFiles(directory=static_dir), name="static")

    # Determine the analysis provider. When TE_PROVIDER is set to "local" the
    # /analyze endpoint will return a stubbed response without making a
    # network request to LangFlow. Otherwise, FLOW_API_URL must be defined.
    provider = os.getenv("TE_PROVIDER", "remote").lower()
    flow_api_url = os.getenv("FLOW_API_URL")

    if provider != "local" and not flow_api_url:
        logger.warning(
            "FLOW_API_URL is not configured; analysis requests will fail until it is set."
        )

    @app.get("/")
    async def root() -> FileResponse:
        """Serve the main HTML page for the frontend."""
        index_path = os.path.join(static_dir, "index.html")
        return FileResponse(index_path)

    @app.get("/health")
    async def health_check() -> dict[str, str | bool]:
        """Return a simple health status for the service."""
        return {
            "status": "healthy",
            "flow_configured": bool(flow_api_url),
            "service": "TrueEye Reports",
            "provider": provider,
        }

    @app.post("/analyze", response_model=AnalyzeResponse)
    async def analyze(request: AnalyzeRequest) -> AnalyzeResponse:
        """Proxy the analysis request to the configured provider.

        When running in remote mode (default), this function forwards the input URL
        to the LangFlow API defined by ``FLOW_API_URL`` and returns the result. In
        local mode it returns a simple canned response containing the URL.
        """
        url = request.url
        logger.info("Received analysis request: %s", url)

        # Local provider: echo back the URL with a placeholder message
        if provider == "local":
            result_text = (
                f"This is a local analysis stub. In remote mode, the content at {url} "
                "would be processed by the TrueEye pipeline."
            )
            return AnalyzeResponse(result=result_text, success=True)

        if not flow_api_url:
            raise HTTPException(
                status_code=503,
                detail="FLOW_API_URL is not configured; analysis cannot be performed.",
            )

        payload = {
            "input_value": url,
            "output_type": "chat",
            "input_type": "chat",
            "tweaks": {},
        }
        headers = {
            "Content-Type": "application/json",
            "User-Agent": "TrueEye/0.1.0",
        }

        try:
            response = requests.post(
                flow_api_url,
                json=payload,
                headers=headers,
                timeout=300,
            )
            response.raise_for_status()
        except requests.exceptions.Timeout:
            return AnalyzeResponse(
                result=(
                    "❌ Error: the request timed out. The analysis may be too complex or "
                    "the service is overloaded."
                ),
                success=False,
                error="timeout",
            )
        except requests.exceptions.ConnectionError as exc:
            logger.error("Connection error while contacting flow: %s", exc)
            return AnalyzeResponse(
                result=(
                    "❌ Error: cannot connect to the analysis service. Check FLOW_API_URL "
                    "configuration."
                ),
                success=False,
                error="connection",
            )
        except requests.exceptions.HTTPError as exc:
            logger.error("HTTP error from flow: %s", exc)
            status_code = getattr(exc.response, "status_code", "unknown")
            return AnalyzeResponse(
                result=f"❌ Server error: {exc}",
                success=False,
                error=f"http_{status_code}",
            )
        except Exception as exc:
            logger.exception("Unexpected error: %s", exc)
            return AnalyzeResponse(
                result=f"❌ Unexpected error: {exc}",
                success=False,
                error="unknown",
            )

        # Parse JSON response
        try:
            data = response.json()
        except json.JSONDecodeError:
            logger.warning("Received non-JSON response from flow")
            return AnalyzeResponse(
                result="⚠️ The upstream service returned a non-JSON response.",
                success=False,
                error="invalid_response",
            )

        result_text: Optional[str] = None

        if isinstance(data, dict) and "result" in data:
            result_text = data["result"]
        elif isinstance(data, dict) and "outputs" in data:
            outputs = data["outputs"]
            if isinstance(outputs, list) and outputs:
                output = outputs[0]
                for node_output in output.get("outputs", []):
                    message = node_output.get("message")
                    if isinstance(message, dict):
                        result_text = message.get("text", "")
                    else:
                        result_text = str(message)
                    if result_text:
                        break

        if not result_text:
            result_text = extract_text_from_response(data) or (
                "⚠️ The request was processed but no result could be extracted. "
                f"Response: {str(data)[:200]}"
            )

        logger.info("Analysis completed successfully")
        return AnalyzeResponse(result=result_text)

    return app