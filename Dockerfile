# Base image for both frontend and backend
FROM node:21-alpine3.18 as base

# Set the working directory in the container to /app
WORKDIR /app

# Copy package.json and package-lock.json for both frontend and backend
COPY backend-hardhat/package*.json ./backend/
COPY frontend-vite/package*.json ./frontend/

# Install dependencies for backend
FROM base as backend-dependencies
RUN apk add --update --no-cache python3 build-base gcc && ln -sf python3 /usr/bin/python
WORKDIR /app/backend
COPY backend-hardhat/ .
RUN npm install

# Install dependencies for frontend
FROM base as frontend-dependencies
WORKDIR /app/frontend
COPY frontend-vite/ .
RUN npm install

# Build backend
FROM backend-dependencies as backend-build
RUN npx hardhat compile
RUN npx hardhat clean
RUN npx hardhat test test/test[IPFSDriveContract_Main].js

# Final backend image
FROM node:21-alpine3.18 as backend
COPY --from=backend-build /app/backend /app
WORKDIR /app
CMD [ "node", "deploy[IPFSDriveContract_Main].js" ]

# Build frontend
FROM frontend-dependencies as frontend-build
RUN npm run build

# Final frontend image
FROM node:21-alpine3.18 as frontend
COPY --from=frontend-build /app/frontend/dist /app
WORKDIR /app
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

EXPOSE 5173 8545