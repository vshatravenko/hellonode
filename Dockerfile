FROM node:8.0-alpine

COPY server.js .

EXPOSE 8080
CMD node server.js
