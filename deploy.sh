#!/bin/bash

# Auto-deploy script for apurba.me
# Location: /home/apurba/htdocs/www.apurba.me/deploy.sh

cd /home/apurba/htdocs/www.apurba.me

DEPLOY_LOG="/home/apurba/htdocs/www.apurba.me/deploy.log"

echo "===========================================" >> "$DEPLOY_LOG"
echo "$(date): Deployment started" >> "$DEPLOY_LOG"
echo "Triggered by: GitHub webhook" >> "$DEPLOY_LOG"

# Pull latest changes
echo "Pulling from origin/main..." >> "$DEPLOY_LOG"
git fetch origin main >> "$DEPLOY_LOG" 2>&1
git reset --hard origin/main >> "$DEPLOY_LOG" 2>&1

# Install dependencies if package.json changed
if git diff HEAD@{1} HEAD --name-only | grep -q "package.json"; then
    echo "package.json changed, installing dependencies..." >> "$DEPLOY_LOG"
    npm install >> "$DEPLOY_LOG" 2>&1
fi

# Build project
echo "Building project..." >> "$DEPLOY_LOG"
if npm run build >> "$DEPLOY_LOG" 2>&1; then
    echo "Build successful, restarting PM2..." >> "$DEPLOY_LOG"
    # Restart PM2 process
    pm2 restart apurba-portfolio >> "$DEPLOY_LOG" 2>&1
else
    echo "❌ Build failed! Not restarting PM2 to keep existing version online." >> "$DEPLOY_LOG"
fi

echo "Deployment completed at $(date)" >> "$DEPLOY_LOG"
echo "===========================================" >> "$DEPLOY_LOG"
echo "" >> "$DEPLOY_LOG"
