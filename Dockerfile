# Minimal version without Ruby/Chef support for faster builds
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal system dependencies
RUN apt-get update && apt-get install -y \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone the GLITCH repository
RUN git clone https://github.com/sr-lab/GLITCH.git .

# Copy the corrected pyproject.toml
COPY pyproject.toml /app/pyproject.toml

# Install Python dependencies
RUN python -m pip install --upgrade pip setuptools wheel && \
    python -m pip install "numpy>=1.26.0" "pandas>=2.1.0" && \
    python -m pip install -e .

# Verify installation
RUN python -c "import glitch; print('GLITCH installed successfully')"

# Create a non-root user for security
RUN useradd --create-home --shell /bin/bash glitch && \
    chown -R glitch:glitch /app
USER glitch

# Set the default command
ENTRYPOINT ["glitch"]
CMD ["--help"]

# Add labels
LABEL maintainer="jahidularafat" \
      description="GLITCH - IaC Security Smell Detection (Ansible, Puppet, Terraform support)" \
      version="1.0.1-minimal"