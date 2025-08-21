{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    fastapi
    uvicorn
    requests
    pydantic
    python-multipart
    pytest
    pytest-asyncio
    mypy
    httpx  # For testing FastAPI
  ]);

  # Script to load environment variables and run the app
  startScript = pkgs.writeShellScriptBin "trueeye-start" ''
    set -e
    
    echo "🧿 TrueEye - Intelligent Media Literacy System"
    echo "=============================================="
    
    # Check if configuration file exists
    if [ ! -f ".env" ]; then
      if [ -f ".env.example" ]; then
        echo "⚠️  No .env file found"
        echo "📋 Copying .env.example to .env..."
        cp .env.example .env
        echo "✅ .env file created. You can edit it to change the configuration."
      else
        echo "❌ .env.example not found. Creating default configuration..."
        cat > .env << 'EOF'
TE_PROVIDER=local
FLOW_API_URL=
PORT=8000
HOST=0.0.0.0
LOG_LEVEL=INFO
EOF
      fi
    fi
    
    # Load environment variables
    echo "🔧 Loading configuration from .env..."
    export $(cat .env | grep -v '^#' | grep -v '^$' | xargs)
    
    # Default values if not defined
    export PORT=''${PORT:-8000}
    export HOST=''${HOST:-0.0.0.0}
    export TE_PROVIDER=''${TE_PROVIDER:-local}
    
    echo "📡 Provider: $TE_PROVIDER"
    echo "🌐 Server: http://$HOST:$PORT"
    
    if [ "$TE_PROVIDER" = "remote" ] && [ -z "$FLOW_API_URL" ]; then
      echo "⚠️  Warning: FLOW_API_URL is not configured for remote mode"
    fi
    
    echo ""
    echo "🚀 Starting TrueEye..."
    echo "   Press Ctrl+C to stop"
    echo ""
    
    # Run the application
    exec ${pythonEnv}/bin/uvicorn trueeye.api:create_app --factory --host "$HOST" --port "$PORT" --reload
  '';

  # Development script with useful commands  
  devScript = pkgs.writeShellScriptBin "trueeye-dev" ''
    set -e
    
    echo "🧿 TrueEye - Development Mode"
    echo "============================"
    echo ""
    echo "Available commands:"
    echo "  trueeye-start    - Start the application"
    echo "  trueeye-test     - Run tests"
    echo "  trueeye-config   - Edit configuration"
    echo "  trueeye-help     - Show this help"
    echo ""
    
    # If there are arguments, execute the specific command
    if [ $# -gt 0 ]; then
      case "$1" in
        "start")
          exec trueeye-start
          ;;
        "test")
          exec trueeye-test
          ;;
        "config")
          exec trueeye-config
          ;;
        "help")
          exec trueeye-help
          ;;
        *)
          echo "❌ Unknown command: $1"
          echo "Use 'trueeye-help' to see available commands"
          exit 1
          ;;
      esac
    else
      # No arguments, start the application directly
      exec trueeye-start
    fi
  '';

  # Script to run tests
  testScript = pkgs.writeShellScriptBin "trueeye-test" ''
    set -e
    echo "🧪 Running TrueEye tests..."
    
    # Load environment variables for tests
    if [ -f ".env" ]; then
      export $(cat .env | grep -v '^#' | grep -v '^$' | xargs)
    fi
    
    cd ${toString ./.}
    ${pythonEnv}/bin/python -m pytest tests/ -v
  '';

  # Script to edit configuration
  configScript = pkgs.writeShellScriptBin "trueeye-config" ''
    set -e
    
    # Check if .env exists
    if [ ! -f ".env" ]; then
      if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "✅ .env file created from .env.example"
      else
        echo "❌ .env.example not found"
        exit 1
      fi
    fi
    
    # Try to open with available editor
    if command -v code >/dev/null 2>&1; then
      code .env
    elif command -v nano >/dev/null 2>&1; then
      nano .env
    elif command -v vim >/dev/null 2>&1; then
      vim .env
    else
      echo "📝 Current .env contents:"
      echo "========================"
      cat .env
      echo ""
      echo "⚠️  No text editor found available."
      echo "You can edit the .env file manually."
    fi
  '';

  # Help script
  helpScript = pkgs.writeShellScriptBin "trueeye-help" ''
    cat << 'EOF'
🧿 TrueEye - Intelligent Media Literacy System

AVAILABLE COMMANDS:
  trueeye-dev       - Development mode (default command)
  trueeye-start     - Start the web application
  trueeye-test      - Run test suite
  trueeye-config    - Edit configuration file (.env)
  trueeye-help      - Show this help

CONFIGURATION:
  The application is configured via the .env file
  If it doesn't exist, it will be created automatically from .env.example

OPERATION MODES:
  • local  : Test responses (no external connection)
  • remote : Connect to LangFlow API (requires FLOW_API_URL)

USAGE EXAMPLES:
  nix-shell                    # Enter shell and run app
  nix-shell --run trueeye-dev  # Run directly
  nix-shell --run trueeye-test # Just run tests

ACCESS:
  Once started, the application will be available at:
  http://localhost:8000 (by default)

For more information, check the README.md file
EOF
  '';

in
pkgs.mkShell {
  buildInputs = [
    pythonEnv
    startScript
    devScript
    testScript
    configScript
    helpScript
    pkgs.curl         # For manual API testing
    pkgs.jq           # To format JSON responses
    pkgs.gnumake      # To use Makefile
  ];

  shellHook = ''
    # Environment configuration
    export PYTHONPATH="${toString ./.}/src:$PYTHONPATH"
    
    # Create .pytest_cache directory if it doesn't exist
    mkdir -p .pytest_cache
    
    echo "🧿 TrueEye Development Shell"
    echo "============================"
    echo ""
    echo "✅ Python environment configured"
    echo "✅ FastAPI and dependencies available"  
    echo "✅ Development tools ready"
    echo ""
    echo "🚀 To start the application:"
    echo "   trueeye-dev"
    echo ""
    echo "📚 To see all commands:"
    echo "   trueeye-help"
    echo ""
    
    # Auto-run if we're not in an interactive shell
    if [ -n "$TRUEEYE_AUTO_START" ]; then
      trueeye-dev
    fi
  '';
}