FROM python:3-alpine

ENV RUNNER="runner"

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

RUN ( getent passwd "${RUNNER}" || adduser -D "${RUNNER}" )

COPY requirements.txt /
RUN pip3 install -r requirements.txt

HEALTHCHECK NONE

USER "${RUNNER}"
ENTRYPOINT ["jinja2"]

