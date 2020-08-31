FROM python:3.8-slim-buster

# USER app

ARG VENV=env
WORKDIR /usr/src/app


RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl && \
    apt-get upgrade -y && \
    apt-get clean

COPY ./requirements.txt ./
RUN python3 -m venv ${VENV} && \
    ${VENV}/bin/pip install --upgrade pip && \
    ${VENV}/bin/pip install -r requirements.txt

COPY . .

RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin \
    && trivy filesystem --exit-code 1 --severity HIGH,CRITICAL --no-progress /

EXPOSE 6543
CMD ["env/bin/python3", "app.py"]
