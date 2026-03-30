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

# 1. Move current stable dist to a backup location
mv dist dist_stable 2>/dev/null

# 2. Attempt the build
if npm run build >> "$DEPLOY_LOG" 2>&1; then
    echo "✅ Build successful!" >> "$DEPLOY_LOG"
    # 3. Build succeeded, we can remove the old stable backup
    rm -rf dist_stable
    echo "Restarting PM2..." >> "$DEPLOY_LOG"
    pm2 restart apurba-portfolio >> "$DEPLOY_LOG" 2>&1
else
    echo "❌ Build failed! Restoring previous stable version..." >> "$DEPLOY_LOG"
    # 4. Build failed, restore the stable version immediately
    rm -rf dist # remove the broken/partial dist
    mv dist_stable dist
    echo "Restoration complete. Site is still running on the previous version." >> "$DEPLOY_LOG"
fi

echo "Deployment completed at $(date)" >> "$DEPLOY_LOG"
echo "===========================================" >> "$DEPLOY_LOG"
echo "" >> "$DEPLOY_LOG"
