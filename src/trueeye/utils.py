"""Utility functions for processing LangFlow responses."""

from typing import Any, Optional

def extract_text_from_response(data: Any) -> Optional[str]:
    """Recursively extract a text field from an arbitrary nested response.

    LangFlow may return responses in varying structures. This helper walks
    dictionaries and lists looking for common keys such as ``text``, ``message``,
    ``result``, ``output`` or ``content``. If a string is encountered at any
    level it is returned immediately.

    Parameters
    ----------
    data:
        The JSON-like object to search.

    Returns
    -------
    Optional[str]
        The extracted text if found, otherwise ``None``.
    """
    if isinstance(data, str):
        return data

    if isinstance(data, dict):
        for key in ["text", "message", "result", "output", "content"]:
            if key in data:
                value = data[key]
                if isinstance(value, str):
                    return value
                if isinstance(value, (dict, list)):
                    result = extract_text_from_response(value)
                    if result:
                        return result

        # search nested values
        for value in data.values():
            if isinstance(value, (dict, list)):
                result = extract_text_from_response(value)
                if result:
                    return result

    elif isinstance(data, list):
        for item in data:
            result = extract_text_from_response(item)
            if result:
                return result

    return None