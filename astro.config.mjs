import { defineConfig } from 'astro/config';
import node from '@astrojs/node';
import mdx from '@astrojs/mdx';

export default defineConfig({
  output: 'server',
  adapter: node({
    mode: 'standalone',
  }),
  integrations: [mdx()],
  // ADD THIS SECTION:
  server: {
    host: '0.0.0.0',
    port: 4000
  }
});