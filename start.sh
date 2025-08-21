#!/usr/bin/env bash

# TrueEye Quick Start Script
# Este script facilita el uso de TrueEye sin tener que recordar comandos de Nix

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

show_help() {
    cat << 'EOF'
🧿 TrueEye - Quick Start Script

USAGE:
  ./start.sh [COMMAND]

COMMANDS:
  start     - Iniciar la aplicación (por defecto)
  test      - Ejecutar tests
  config    - Editar configuración
  help      - Mostrar esta ayuda
  shell     - Abrir shell de desarrollo

EXAMPLES:
  ./start.sh          # Iniciar aplicación
  ./start.sh test     # Ejecutar tests
  ./start.sh config   # Editar .env

REQUIREMENTS:
  - NixOS o Nix package manager instalado
  - Internet para la primera vez (para descargar dependencias)

La aplicación estará disponible en http://localhost:8000
EOF
}

# Verificar si Nix está instalado
if ! command -v nix-shell >/dev/null 2>&1; then
    echo "❌ Error: nix-shell no está instalado"
    echo "📦 Instala Nix desde: https://nixos.org/download.html"
    exit 1
fi

# Verificar si estamos en el directorio correcto
if [ ! -f "shell.nix" ]; then
    echo "❌ Error: No se encontró shell.nix en el directorio actual"
    echo "📁 Asegúrate de estar en el directorio del proyecto TrueEye"
    exit 1
fi

# Procesar argumentos
case "${1:-start}" in
    "start"|"")
        echo "🚀 Iniciando TrueEye..."
        exec nix-shell --run "trueeye-dev"
        ;;
    "test")
        echo "🧪 Ejecutando tests..."
        exec nix-shell --run "trueeye-test"
        ;;
    "config")
        echo "⚙️ Editando configuración..."
        exec nix-shell --run "trueeye-config"
        ;;
    "shell")
        echo "🐚 Abriendo shell de desarrollo..."
        exec nix-shell
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo "❌ Comando desconocido: $1"
        echo "💡 Usa './start.sh help' para ver los comandos disponibles"
        exit 1
        ;;
esac
