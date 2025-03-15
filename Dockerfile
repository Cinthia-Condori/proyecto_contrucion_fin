# Usa una imagen oficial de Ruby como base
FROM ruby:3.2.2

# Establece el directorio de trabajo en /app
WORKDIR /app

# Copia los archivos Gemfile y Gemfile.lock (esto permite que Docker use la caché de dependencias)
COPY Gemfile Gemfile.lock ./

# Instalar dependencias del sistema necesarias para Rails
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*  # Limpiar cache de apt para reducir tamaño de la imagen

# Instalar Bundler y las gemas necesarias para la aplicación
RUN gem install bundler && bundle install --jobs 4 --retry 5

# Copiar el resto de los archivos de la aplicación
COPY . ./

# Comando por defecto para ejecutar el servidor de Rails
CMD ["rails", "server", "-b", "0.0.0.0"]
