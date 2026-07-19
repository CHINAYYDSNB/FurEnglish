// CORS proxy for FurEnglish — bypasses browser cross-origin restrictions
import http from 'node:http';
import https from 'node:https';

const PORT = 3000;

http.createServer((req, res) => {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  // Preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  // Route to backend
  const url = new URL(req.url, `http://${req.headers.host}`);
  const target = url.searchParams.get('url');
  if (!target) {
    res.writeHead(400);
    res.end('Missing ?url= parameter');
    return;
  }

  const targetUrl = new URL(target);
  const client = targetUrl.protocol === 'https:' ? https : http;

  const proxyReq = client.request(target, {
    method: req.method,
    headers: {
      ...req.headers,
      host: targetUrl.host,
    },
  }, (proxyRes) => {
    res.writeHead(proxyRes.statusCode, proxyRes.headers);
    proxyRes.pipe(res);
  });

  proxyReq.on('error', (e) => {
    res.writeHead(502);
    res.end(`Proxy error: ${e.message}`);
  });

  req.pipe(proxyReq);
}).listen(PORT, () => {
  console.log(`FurEnglish CORS proxy → http://localhost:${PORT}`);
});
