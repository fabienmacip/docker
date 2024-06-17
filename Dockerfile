FROM alpine

RUN apk add --update nodejs

COPY ./app.js /app/

WORKDIR /app

CMD ["node", "/app/app.js"]

