FROM node:21-alpine3.18

WORKDIR /app

COPY ./package*.json ./ 

RUN npm i

COPY . .

RUN npm run build

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]