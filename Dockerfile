FROM python:3.10-slim
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
EXPOSE 8080

# 1) Instala Rust/Cargo si aún lo necesitas (o quítalo si ya no)
RUN apt-get update \
 && apt-get install -y build-essential curl rustc cargo \
 && rm -rf /var/lib/apt/lists/*

# 2) Copio solo lo necesario para la instalación editable:
#    setup.py, requirements.txt, README.md y la carpeta src/
COPY . /app

# 3) Instalo tu paquete en editable (-e .) y el resto de deps
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# 4) Copio el resto del código (tests, datos, scripts, etc.)


# 5) Creo usuario no-root y ajusto permisos
RUN adduser -u 5678 --disabled-password --gecos "" appuser \
 && chown -R appuser /app

USER appuser

CMD gunicorn app:app --bind 0.0.0.0:$PORT



