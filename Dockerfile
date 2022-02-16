FROM alpine:3.15
COPY ./requirements.txt apk.txt /tmp/

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

RUN grep -Eve '^[[:space:]]*#' < / tmp/apk.txt | xargs apk add \
&& pip3 install --no-cache-dir -r /tmp/requirements.txt

ENTRYPOINT ["jinja2"]
