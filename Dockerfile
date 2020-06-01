FROM alpine:latest

COPY ./entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh \
  && apk add --no-cache git openssh-client \
  && echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ENTRYPOINT ["/app/entrypoint.sh"]
