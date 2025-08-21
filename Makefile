# TrueEye Makefile
# Comandos simples para trabajar con TrueEye

.PHONY: help start test config shell clean setup

# Comando por defecto
.DEFAULT_GOAL := help

help: ## Mostrar esta ayuda
	@echo "🧿 TrueEye - Sistema Inteligente de Alfabetización Mediática"
	@echo "=========================================================="
	@echo ""
	@echo "Comandos disponibles:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Ejemplos:"
	@echo "  make start    # Iniciar aplicación"
	@echo "  make test     # Ejecutar tests"
	@echo "  make config   # Editar configuración"

setup: ## Configuración inicial del proyecto
	@echo "🔧 Configurando TrueEye..."
	@if [ ! -f .env ]; then \
		if [ -f .env.example ]; then \
			cp .env.example .env; \
			echo "✅ Archivo .env creado desde .env.example"; \
		else \
			echo "❌ No se encontró .env.example"; \
			exit 1; \
		fi \
	else \
		echo "✅ Archivo .env ya existe"; \
	fi
	@echo "🎯 ¡Configuración completada!"

start: ## Iniciar la aplicación
	@echo "🚀 Iniciando TrueEye..."
	@nix-shell --run "trueeye-dev"

test: ## Ejecutar tests
	@echo "🧪 Ejecutando tests..."
	@nix-shell --run "trueeye-test"

config: ## Editar archivo de configuración
	@echo "⚙️ Editando configuración..."
	@nix-shell --run "trueeye-config"

shell: ## Abrir shell de desarrollo
	@echo "🐚 Abriendo shell de desarrollo..."
	@nix-shell

clean: ## Limpiar archivos temporales
	@echo "🧹 Limpiando archivos temporales..."
	@rm -rf .pytest_cache/
	@rm -rf src/trueeye/__pycache__/
	@rm -rf tests/__pycache__/
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Limpieza completada"

# Comandos adicionales para desarrollo
dev-info: ## Mostrar información del entorno de desarrollo
	@echo "📊 Información del entorno de desarrollo"
	@echo "========================================"
	@echo "Proyecto: TrueEye v0.1.0"
	@echo "Python: $(shell python3 --version 2>/dev/null || echo 'No disponible')"
	@echo "Nix: $(shell nix --version 2>/dev/null || echo 'No disponible')"
	@echo "Directorio: $(PWD)"
	@if [ -f .env ]; then \
		echo "Configuración: ✅ .env existe"; \
		echo "Proveedor: $$(grep TE_PROVIDER .env | cut -d'=' -f2)"; \
	else \
		echo "Configuración: ❌ .env no existe (ejecuta 'make setup')"; \
	fi

# Comandos de verificación
check: ## Verificar que todo esté configurado correctamente
	@echo "🔍 Verificando configuración..."
	@if ! command -v nix-shell >/dev/null 2>&1; then \
		echo "❌ nix-shell no está instalado"; \
		exit 1; \
	else \
		echo "✅ nix-shell disponible"; \
	fi
	@if [ ! -f shell.nix ]; then \
		echo "❌ shell.nix no encontrado"; \
		exit 1; \
	else \
		echo "✅ shell.nix encontrado"; \
	fi
	@if [ ! -f .env ] && [ -f .env.example ]; then \
		echo "⚠️  .env no existe, pero .env.example está disponible"; \
		echo "   Ejecuta 'make setup' para crear .env"; \
	elif [ -f .env ]; then \
		echo "✅ .env configurado"; \
	else \
		echo "❌ Ni .env ni .env.example encontrados"; \
	fi
	@echo "🎯 ¡Verificación completada!"
