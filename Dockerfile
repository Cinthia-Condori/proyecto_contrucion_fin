# Dockerfile base (para instalar dependencias del sistema)
FROM ruby:3.2.2-slim

# Instalar dependencias del sistema necesarias para Ruby y gemas nativas
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libxml2-dev \
  libxslt1-dev \
  libffi-dev \
  zlib1g-dev \
  git \
  make \
  gcc \
  postgresql-client && rm -rf /var/lib/apt/lists/*
