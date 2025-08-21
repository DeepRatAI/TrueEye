"""
trueeye package

This package exposes the FastAPI application factory to serve the TrueEye API.

Usage::

    from trueeye import create_app
    app = create_app()
"""

from .api import create_app

__all__ = ["create_app"]