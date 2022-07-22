FROM node:16.14.2-alpine
WORKDIR /app/myapp

CMD [ "yarn", "build" ]

