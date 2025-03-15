# Dockerfile (ubicado en ./flask_app/Dockerfile)
FROM python:3.10-slim

WORKDIR /app

# Copiar el archivo requirements.txt y instalar las dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar todo el código de la aplicación
COPY . .

# Asegúrate de que FLASK_APP apunte a tu archivo `app.py`
ENV FLASK_APP=app.py

CMD ["flask", "run", "--host=0.0.0.0"]
