FROM python:3.8-buster

# USER app

ARG VENV=env
WORKDIR /usr/src/app


RUN apt-get update && apt-get install \
    ca-certificates

COPY ./requirements.txt ./
RUN python3 -m venv ${VENV} && \
    ${VENV}/bin/pip install --upgrade pip && \
    ${VENV}/bin/pip install -r requirements.txt

COPY . .

EXPOSE 6543
CMD ["env/bin/python3", "app.py"]
