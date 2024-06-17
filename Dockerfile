FROM alpine

RUN apk add --update nodejs

COPY ./app.js /app/

CMD ["node", "/app/app.js"]

