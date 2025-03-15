# Dockerfile para Ruby (rails_app)
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
  && rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el Gemfile y Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalar bundler y las gemas de Rails
RUN gem install bundler && bundle install --jobs 4 --retry 5

# Copiar el resto de la aplicación
COPY . ./

# Exponer el puerto 3000 para la app de Rails
EXPOSE 3000

# Comando para ejecutar la aplicación Rails
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
