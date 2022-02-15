FROM alpine:3.15
COPY ./requirements.txt apk.txt /tmp/
RUN cat /tmp/apk.txt | grep -Eve '^[[:space:]]*#' | xargs apk add \
&& pip3 install --no-cache-dir -r /tmp/requirements.txt

ENTRYPOINT ["jinja2"]
