FROM alpine:3.19

ENV RUNNER="runner"

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

RUN apk add --no-cache \
  python3=~3 \
  py3-yaml=~6 \
  py3-toml=~0 \
  py3-xmltodict=~0 \
  py3-hjson=~3 \
  jinja2-cli=~0 \
&& rm -rf /var/cache/apk/* \
&& ( getent passwd "${RUNNER}" || adduser -D "${RUNNER}" )

USER "${RUNNER}"
ENTRYPOINT ["jinja2"]

