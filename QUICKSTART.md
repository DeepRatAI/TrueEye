# 🧿 TrueEye - Quick Start Guide

## 🚀 Ultra-Fast Start (One Command)

```bash
cd /path/to/trueeye_v1
./start.sh
```

And that's it! The application will be available at **http://localhost:8000**

## 📋 Execution Options

### Option 1: start.sh Script (Recommended)

```bash
./start.sh          # Start application
./start.sh test     # Run tests
./start.sh config   # Edit configuration
./start.sh help     # Show help
```

### Option 2: Makefile

```bash
make start          # Start application
make test           # Run tests
make config         # Edit configuration
make setup          # Initial setup
make help           # Show help
```

### Option 3: Direct Nix Commands

```bash
nix-shell --run "trueeye-dev"      # Start application
nix-shell --run "trueeye-test"     # Run tests
nix-shell --run "trueeye-config"   # Edit configuration
nix-shell                          # Interactive shell
```

## ⚙️ Configuration

### Automatic Configuration

- On first run, an `.env` file is automatically created from `.env.example`
- Default mode: **local** (test responses, no external connection)

### Manual Configuration

1. **Edit configuration**: `./start.sh config` or `make config`
2. **Switch to remote mode**:
   ```bash
   TE_PROVIDER=remote
   FLOW_API_URL=https://your-langflow-endpoint.com
   ```

### Main Variables

- `TE_PROVIDER=local|remote` - Operation mode
- `PORT=8000` - Server port
- `HOST=0.0.0.0` - Server host
- `FLOW_API_URL=` - LangFlow URL (remote mode only)

## 🧪 Testing

```bash
# Run tests
./start.sh test
# or
make test
# or
nix-shell --run "trueeye-test"
```

## 🔍 System Verification

```bash
make check          # Verify configuration
make dev-info       # Environment info
```

## 🌐 Using the Application

1. **Open browser**: http://localhost:8000
2. **Enter URL**: Paste the article URL to analyze
3. **Click "Analyze"**
4. **View results**: The analysis will appear formatted

### Example URLs to test (local mode):

- https://example.com/news-article
- https://www.bbc.com/news/world
- https://cnn.com/politics

## 🛠️ Development

### Enter development shell

```bash
nix-shell
# Now you have access to all commands:
trueeye-start       # Start app
trueeye-test        # Run tests
trueeye-config      # Edit config
trueeye-help        # Show help
```

### Project structure

```
trueeye_v1/
├── src/trueeye/           # Source code
│   ├── api.py            # FastAPI app
│   ├── models.py         # Pydantic models
│   ├── utils.py          # Utilities
│   └── static/           # Frontend
├── tests/                # Tests
├── .env                  # Configuration (created automatically)
├── shell.nix            # Nix environment
├── start.sh             # Start script
└── Makefile            # Make commands
```

## ❓ Troubleshooting

### Application won't start

```bash
# Verify configuration
make check

# View system information
make dev-info

# Clean temporary files
make clean
```

### Tests fail

```bash
# Clean cache and re-run
make clean
make test
```

### Nix problems

```bash
# Rebuild environment
nix-shell --pure
```

## 📞 Help

- **Script**: `./start.sh help`
- **Make**: `make help`
- **Nix**: `nix-shell --run "trueeye-help"`
- **Complete README**: See `README.md`

---

**Enjoy using TrueEye! 🧿✨**
