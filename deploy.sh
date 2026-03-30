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
npm run build >> "$DEPLOY_LOG" 2>&1

# Restart PM2 process
echo "Restarting apurba-portfolio..." >> "$DEPLOY_LOG"
pm2 restart apurba-portfolio >> "$DEPLOY_LOG" 2>&1

echo "Deployment completed at $(date)" >> "$DEPLOY_LOG"
echo "===========================================" >> "$DEPLOY_LOG"
echo "" >> "$DEPLOY_LOG"
