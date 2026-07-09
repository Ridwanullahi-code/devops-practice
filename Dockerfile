# ─────────────────────────────────────────
#  DOCKERFILE for Grade Tracker
#  This tells Docker how to build our app
# ─────────────────────────────────────────

# Step 1 — start from an existing image
# We use Node 18 on Alpine Linux (very small, only 5MB)

FROM node:18-alpine

# Step 2 — who maintains this image (optional but good practice)
LABEL maintainer="Ridwanullahi-code"

# Step 3 — set the working directory inside the container
# All commands after this run from /app

WORKDIR /app

# Step 4 — copy package.json first (before the rest of the code)
# We do this separately for caching reasons (explained below)
COPY package*.json ./

# Step 5 — install dependencies

RUN npm install

# Step 6 — copy the rest of your application code
COPY . .

# Step 7 — tell Docker which port your app uses
EXPOSE 3000

# Step 8 — the command to start your app
CMD ["node", "app.js"]
