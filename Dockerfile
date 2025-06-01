FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Upgrade pip, setuptools, and wheel
RUN pip install --upgrade pip setuptools wheel

# Install Python dependencies with verbose output
RUN pip install --no-cache-dir -v -r requirements.txt && \
    pip list  # Show installed packages for debugging

# Copy application code
COPY . .

# Verify SQLAlchemy installation
RUN python -c "import sqlalchemy; print(f'SQLAlchemy version: {sqlalchemy.__version__}')"

# Expose the port
EXPOSE 8000

# Default command - using $PORT for Render compatibility
CMD uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000} 