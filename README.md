![TrueEye Banner](banner.gif)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.68+-green.svg)](https://fastapi.tiangolo.com)
[![LangFlow Ready](https://img.shields.io/badge/LangFlow-Ready-purple.svg)](https://github.com/logspace-ai/langflow)
[![NixOS](https://img.shields.io/badge/NixOS-Reproducible-blue.svg)](https://nixos.org/)

# 🧿 TrueEye — Intelligent Media Literacy System

**TrueEye** is an AI‑powered tool designed to analyze news articles and web
content to detect narrative bias, identify the target audience and reveal
hidden intentions or manipulative rhetorical structures. In other words, it
doesn't just detect fake news — it analyzes **who** the content is written
for and **why**.

This repository provides a production‑grade Python package containing both
the REST API and a simple frontend. The code is structured under
`src/trueeye` with proper type hints, tests, continuous integration and
development tooling. A local analysis stub is provided for offline testing.

## 🚀 Demo

The previous Hugging Face Space demo is no longer maintained. You can run
your own instance locally using the instructions below.

## 🚀 Usage Options

TrueEye offers **two usage modes** depending on your needs:

### 🏗️ **Option A: Complete Application (Recommended for production)**

- ✅ **Modern web interface** with custom UI
- ✅ **Robust REST API** with FastAPI
- ✅ **Reproducible environment** with Nix/NixOS
- ✅ **Automatic setup** with a single command
- ✅ **Integrated tests** and complete documentation
- ✅ **Offline mode** for development without external APIs

👉 **Quick start**: `./start.sh` (See complete instructions below)

### ⚡ **Option B: Direct LangFlow Flow (Quick to try)**

- ✅ **5-minute setup** by importing `TrueEyeBeta.json`
- ✅ **No complex configurations** - just import and use
- ✅ **Visual playground** integrated in LangFlow
- ✅ **Easy to modify** prompts and logic from the UI
- ✅ **Cross-platform** - works on any OS

👉 **See**: [`README_FLOW.md`](README_FLOW.md) for flow instructions

---

## 🧩 What Does TrueEye Do?

When given a news article URL, **TrueEye** performs three consecutive
analyses:

1. **Bias & Narrative Tone** — Detects narrative polarity (positive,
   negative, neutral), identifies rhetorical strategies (fear, polarization,
   irony) and summarizes the content while flagging questionable claims.
2. **Audience Profiling** — Infers demographic and emotional profile of
   the target reader and identifies values, beliefs or cognitive biases being
   exploited.
3. **Intent & Risk Evaluation** — Detects manipulative discourse or hidden
   agendas and highlights information gaps and potential societal risk.

The report includes links to trustworthy sources for fact‑checking.

## ⚙️ Architecture Overview

The project consists of two main components:

- 🧠 **Backend** — A REST API built with **FastAPI** and packaged as a
  Python library. The API is created via `trueeye.create_app()` and can be
  run using `uvicorn`.
- 🧱 **Frontend** — A minimal static web interface built with TailwindCSS
  (served from the package's static directory). It allows users to input a
  URL, trigger analysis and view the result.

The heavy lifting is performed by a remote LangFlow pipeline via the
`FLOW_API_URL` environment variable. For offline testing you can set
`TE_PROVIDER=local` and the API will return a stubbed response.

## 📁 Project Structure

```
TrueEye_v1/
├── src/trueeye/
│   ├── __init__.py      # Exposes create_app()
│   ├── api.py           # FastAPI application factory and endpoints
│   ├── models.py        # Pydantic models
│   ├── utils.py         # Helper functions
│   └── static/
│       └── index.html   # Frontend UI
├── tests/               # Test suite
├── pyproject.toml       # Project metadata and dependencies
├── .pre-commit-config.yaml
├── .github/workflows/ci.yml
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── SECURITY.md
├── LICENSE.txt          # Non‑commercial license
└── README.md            # Project documentation (this file)
```

## 💻 Running on NixOS/Nix

### 🚀 Quick Start (One Command)

```bash
# Option 1: Using start.sh script (recommended)
./start.sh

# Option 2: Using Makefile
make start

# Option 3: Direct Nix command
nix-shell --run "trueeye-dev"
```

### 🔧 Initial Setup

The project includes automatic configuration. On first use:

1. An `.env` file will be automatically created from `.env.example`
2. The Python environment will be configured with all dependencies
3. The application will start in local mode (no external connection)

### ⚙️ Environment Variables Configuration

```bash
# To edit configuration:
./start.sh config
# or
make config

# For manual configuration:
cp .env.example .env
# Then edit .env with your favorite editor
```

Main variables:

- `TE_PROVIDER=local` → Test mode (no external API)
- `TE_PROVIDER=remote` → Production mode (requires `FLOW_API_URL`)
- `PORT=8000` → Server port
- `HOST=0.0.0.0` → Server host

### 🧪 Available Commands

```bash
# Commands with start.sh:
./start.sh start    # Start application (default)
./start.sh test     # Run tests
./start.sh config   # Edit configuration
./start.sh shell    # Open development shell
./start.sh help     # Show help

# Commands with Makefile:
make start         # Start application
make test          # Run tests
make config        # Edit configuration
make shell         # Open development shell
make clean         # Clean temporary files
make check         # Verify configuration
make help          # Show help
```

### 🏗️ Estructura del Proyecto

## 🐚 Nix Development Shell

The project includes a fully configured `shell.nix` that provides:

- ✅ **Python 3.10+** with all dependencies
- ✅ **FastAPI and Uvicorn** pre-configured
- ✅ **Testing tools** (pytest, httpx)
- ✅ **Development utilities** (mypy, curl, jq)
- ✅ **Custom scripts** to make usage easy
- ✅ **Automatic loading** of environment variables
- ✅ **Automatic PYTHONPATH** configuration

### 💡 Special Features

- **Automatic configuration**: Creates `.env` if it doesn't exist
- **Environment validation**: Verifies configuration at startup
- **Multiple interfaces**: Bash script, Makefile, Nix commands
- **Development mode**: Auto-reload with `--reload`
- **Integrated testing**: Test suite ready to use
- **Automatic cleanup**: Temporary file management

### 🎯 Recommended Usage for NixOS

```bash
# 1. Clone/access the project
cd /path/to/trueeye_v1

# 2. Run (everything gets configured automatically)
./start.sh

# 3. Access the application
firefox http://localhost:8000
```

## 🔍 System Verification

To verify that everything is properly configured:

```bash
# Verify dependencies and configuration
make check

# View environment information
make dev-info

# Run tests to validate functionality
./start.sh test
```

## 📚 Technologies and Tools

### Backend

- **FastAPI** — High-performance Python web framework
- **Uvicorn** — ASGI server with asyncio support
- **Pydantic** — Data validation with type hints
- **Requests** — HTTP client for API integration

### Frontend

- **HTML5/JavaScript** — Minimal and functional frontend
- **TailwindCSS** — Utility-first CSS framework
- **Marked.js** — Markdown processing for responses

### Development

- **Nix/NixOS** — Reproducible environment management
- **pytest** — Testing framework
- **mypy** — Static type checking
- **Shell Scripts** — Task automation

### Integration

- **LangFlow API** — AI analysis pipeline (remote mode)
- **Local mode** — Stub responses for offline development

## ✍️ Author

**Gonzalo Romero (DeepRat)**

AI, Software & Systems Engineer · Prompt Engineer · Full‑Stack Developer

🔗 [Web](https://deeprat.tech) | [Hugging Face](https://huggingface.co/DeepRat) | [GitHub](https://github.com/DeepRatAI) | [LinkedIn](https://www.linkedin.com/in/gonzalo-romero-b9b5b4355) | [Medium](https://medium.com/@hermmes.ia)

