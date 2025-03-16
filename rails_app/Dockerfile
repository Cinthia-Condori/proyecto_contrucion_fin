# Dockerfile para Rails (rails_app)
FROM registry.docker.com/library/ruby:3.2.2-slim

# Usar la imagen base que creamos previamente
FROM base as build

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar PostgreSQL client
RUN apt-get update -qq && apt-get install -y postgresql-client

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
