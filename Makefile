.PHONY: help install dev test clean lint format docker-build docker-up docker-down logs setup-env

# Default target
help:
	@echo "🤖 AI Image Analyzer - Available Commands"
	@echo "========================================"
	@echo ""
	@echo "📦 Installation & Setup:"
	@echo "  install        - Install all dependencies (backend + frontend)"
	@echo "  setup-env      - Create environment files from templates"
	@echo ""
	@echo "🚀 Development:"
	@echo "  dev            - Start all services with Docker Compose"
	@echo "  dev-backend    - Start only backend services"
	@echo "  dev-frontend   - Start only frontend"
	@echo "  dev-local      - Start backend/frontend locally (no Docker)"
	@echo ""
	@echo "🧪 Testing & Quality:"
	@echo "  test           - Run all tests"
	@echo "  test-backend   - Run backend tests only"
	@echo "  test-frontend  - Run frontend tests only"
	@echo "  lint           - Run linting for all code"
	@echo "  format         - Format all code"
	@echo ""
	@echo "🐳 Docker Operations:"
	@echo "  docker-build   - Build Docker containers"
	@echo "  docker-up      - Start services with Docker Compose"
	@echo "  docker-down    - Stop and remove Docker containers"
	@echo "  docker-logs    - Show logs from all containers"
	@echo "  docker-clean   - Clean Docker system (remove unused containers/images)"
	@echo ""
	@echo "📊 Monitoring:"
	@echo "  monitor-up     - Start monitoring stack (Prometheus + Grafana)"
	@echo "  monitor-down   - Stop monitoring stack"
	@echo ""
	@echo "🧹 Cleanup:"
	@echo "  clean          - Clean build artifacts and cache files"
	@echo "  clean-all      - Deep clean (including Docker volumes)"

# Installation and Setup
install:
	@echo "📦 Installing backend dependencies..."
	cd backend && pip install -r requirements.txt
	@echo "📦 Installing frontend dependencies..."
	cd frontend && npm install
	@echo "✅ Installation complete!"

setup-env:
	@echo "⚙️ Setting up environment files..."
	@if [ ! -f backend/.env ]; then \
		cp backend/.env.example backend/.env; \
		echo "Created backend/.env"; \
	else \
		echo "backend/.env already exists"; \
	fi
	@if [ ! -f frontend/.env ]; then \
		cp frontend/.env.example frontend/.env; \
		echo "Created frontend/.env"; \
	else \
		echo "frontend/.env already exists"; \
	fi
	@echo "✅ Environment files ready!"

# Development
dev: setup-env
	@echo "🚀 Starting all services with Docker Compose..."
	docker-compose up --build

dev-backend:
	@echo "🚀 Starting backend services only..."
	docker-compose up --build backend db redis celery-worker

dev-frontend:
	@echo "🚀 Starting frontend only..."
	docker-compose up --build frontend

dev-local: setup-env
	@echo "🚀 Starting services locally (requires manual database setup)..."
	@echo "Starting backend in background..."
	cd backend && python main.py &
	@echo "Starting frontend..."
	cd frontend && npm start

# Testing
test:
	@echo "🧪 Running all tests..."
	$(MAKE) test-backend
	$(MAKE) test-frontend

test-backend:
	@echo "🧪 Running backend tests..."
	cd backend && python -m pytest tests/ -v --cov=app --cov-report=html --cov-report=term

test-frontend:
	@echo "🧪 Running frontend tests..."
	cd frontend && npm test -- --coverage --watchAll=false

# Code Quality
lint:
	@echo "🔍 Running linting..."
	@echo "Backend linting..."
	cd backend && flake8 app/ tests/ --max-line-length=88 --extend-ignore=E203,W503
	cd backend && mypy app/
	@echo "Frontend linting..."
	cd frontend && npm run lint

format:
	@echo "🎨 Formatting code..."
	@echo "Backend formatting..."
	cd backend && black app/ tests/
	cd backend && isort app/ tests/
	@echo "Frontend formatting..."
	cd frontend && npm
