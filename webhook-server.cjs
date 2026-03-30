const express = require('express');
const { exec } = require('child_process');
const crypto = require('crypto');

const app = express();
const PORT = 4001; // apurba.me runs on 4000, shopify on 3000, so we use 4001 for this webhook
const WEBHOOK_SECRET = process.env.WEBHOOK_SECRET || 'apurba-me-secret';

app.use(express.json());

// Verify GitHub webhook signature
function verifySignature(payload, signature) {
    const hmac = crypto.createHmac('sha256', WEBHOOK_SECRET);
    const digest = 'sha256=' + hmac.update(payload).digest('hex');
    return crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(digest));
}

// Webhook endpoint
app.post('/webhook/deploy', (req, res) => {
    const signature = req.headers['x-hub-signature-256'];

    // Verify signature
    if (signature && !verifySignature(JSON.stringify(req.body), signature)) {
        console.log('⚠️  Invalid webhook signature');
        return res.status(401).send('Invalid signature');
    }

    // Monitor 'main' branch for apurba.me
    if (req.body.ref === 'refs/heads/main') {
        console.log('📥 Push to main branch detected!');
        
        // Trigger deploy script
        exec('bash /home/apurba/htdocs/www.apurba.me/deploy.sh >> /home/apurba/htdocs/www.apurba.me/deploy.log 2>&1 &', (error) => {
            if (error) {
                console.error(`❌ Deploy error: ${error}`);
                return res.status(500).send('Deployment failed');
            }
            console.log('✅ Deploy script started in background');
            res.status(200).send('Deployment started');
        });
    } else {
        console.log(`ℹ️  Ignoring push to branch: ${req.body.ref}`);
        res.status(200).send('Branch not monitored');
    }
});

// Health check
app.get('/webhook/health', (req, res) => {
    res.json({ status: 'OK', service: 'apurba-me-webhook', timestamp: new Date().toISOString() });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`🎣 Webhook server listening on port ${PORT}`);
    console.log(`🔗 Webhook URL: http://107.172.168.113:${PORT}/webhook/deploy`);
});
