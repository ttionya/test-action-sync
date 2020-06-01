FROM alpine:latest

COPY ./entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh \
  && apk add --no-cache git

ENTRYPOINT ["/app/entrypoint.sh"]
