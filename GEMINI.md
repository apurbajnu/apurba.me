# apurba.me - Project Overview

This is an Astro-based personal website project, configured for Server-Side Rendering (SSR) with Node.js and MDX support.

## 🚀 Tech Stack

- **Framework**: [Astro 6](https://astro.build/)
- **Runtime**: Node.js (SSR Mode)
- **Adapter**: `@astrojs/node` (standalone)
- **Content**: `@astrojs/mdx` for MDX support
- **Styling**: Vanilla CSS within Astro components

## 🧞 Commands

All commands are run from the root:

| Command | Action |
| :--- | :--- |
| `npm run dev` | Starts local dev server at `0.0.0.0:4000` |
| `npm run build` | Builds the project for production |
| `npm run preview` | Previews the build locally |
| `npm run astro ...` | Run Astro CLI commands |

*Note: The dev server is configured to host on `0.0.0.0:4000` in `astro.config.mjs`.*

## 📁 Project Structure

```text
/
├── .vscode/          # VS Code configuration (SFTP, Launch settings)
├── public/           # Static assets (favicons, etc.)
├── src/
│   ├── assets/       # Images and other static media
│   ├── components/   # Reusable Astro components
│   ├── layouts/      # Page layouts (Layout.astro)
│   └── pages/        # Route handlers (index.astro, .mdx files)
├── astro.config.mjs  # Astro configuration (SSR, Adapters, Port)
└── tsconfig.json     # Strict TypeScript configuration
```

## 🚢 Deployment (SFTP & Auto-Deploy)

The project is configured for both manual and automatic deployment.

### Manual SFTP (VS Code)
- **Host**: `107.172.168.113`
- **User**: `root` (key-based SSH auth)
- **Remote Path**: `/home/apurba/htdocs/www.apurba.me`
- **Upload on Save**: Enabled (`true`)

### GitHub Webhook (Auto-Deploy)
Whenever you push to `main`, a webhook triggers the server to auto-update.
- **Webhook Port**: `4001`
- **Webhook File**: `webhook-server.cjs` (Runs with PM2)
- **Deploy Script**: `deploy.sh` (Pulls, installs, builds, restarts PM2)

To start the webhook server manually:
```bash
pm2 start /home/apurba/htdocs/www.apurba.me/webhook-server.cjs --name "apurba-me-webhook"
```

## 🛠️ Development Guidelines

- **SSR**: The project uses `output: 'server'`. Ensure any client-side scripts are properly gated if they rely on browser APIs.
- **Strict TS**: TypeScript is set to `astro/tsconfigs/strict`.
- **Port Management**: The dev server is pinned to port `4000`. If this conflicts, update `astro.config.mjs`.
