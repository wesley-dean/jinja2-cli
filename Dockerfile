FROM python:3-slim

ENV RUNNER="runner"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN ( getent passwd "${RUNNER}" || useradd "${RUNNER}" )

COPY requirements.txt /
RUN pip3 install -r requirements.txt

HEALTHCHECK NONE

USER "${RUNNER}"
ENTRYPOINT ["jinja2"]

