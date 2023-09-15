FROM thevlang/vlang:latest

RUN apk add postgresql-dev

WORKDIR /app
COPY ./src /app/src

ENTRYPOINT ["v", "run", "src", "-prod"]
