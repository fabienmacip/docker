FROM node:alpine

WORKDIR /app

COPY . .

RUN npm install

ENV PATH=$PATH:/app/node_modules/.bin

CMD ["nodemon", "app.js"]