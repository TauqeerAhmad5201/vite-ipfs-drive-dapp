# Use an official Node runtime as a parent image
FROM node:21-alpine3.18

# Set the working directory in the container to /app
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

RUN apk add --update --no-cache python3 build-base gcc && ln -sf /usr/bin/python3 /usr/bin/python


RUN npm install punycode.js

# Install Hardhat globally and install dependencies
RUN npm install -g hardhat && npm install

# Copy the current directory contents into the container at /app
COPY . .

# # Set environment variables .env file
# https://dashboard.alchemy.com/
ENV SEPOLIA_ALCHEMY_RPC_URL=${SEPOLIA_ALCHEMY_RPC_URL}

# Note -> AlwaysUseDummyAccount|KeepKeysSecure
ENV METAMASK_PRIVATE_KEY=${METAMASK_PRIVATE_KEY}

# https://etherscan.io/apis
ENV ETHERSCAN_API_KEY=${ETHERSCAN_API_KEY} 

# https://coinmarketcap.com/api/
ENV COINMARKETCAP_API_KEY=${COINMARKETCAP_API_KEY}

RUN echo "COINMARKETCAP_API_KEY=${COINMARKETCAP_API_KEY}"

# this can be an issue
RUN npx hardhat compile

RUN npx hardhat clean

RUN npx hardhat test test/test[IPFSDriveContract_Main].js

WORKDIR /app/scripts

# Make port 8545 available to the world outside this container (optional)
EXPOSE 8545

CMD [ "node", "deploy[IPFSDriveContract_Main].js" ]