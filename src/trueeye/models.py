"""Pydantic models for the TrueEye API."""

from typing import Optional

from pydantic import BaseModel, HttpUrl


class AnalyzeRequest(BaseModel):
    """Request body for the analyse endpoint.

    Attributes
    ----------
    url: The news article or web page URL to analyse.
    """

    url: HttpUrl


class AnalyzeResponse(BaseModel):
    """Response model for the analyse endpoint."""

    result: str
    success: bool = True
    error: Optional[str] = None