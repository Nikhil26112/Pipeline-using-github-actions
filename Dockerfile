FROM node:14-alpine

WORKDIR /app

RUN npm install express

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]