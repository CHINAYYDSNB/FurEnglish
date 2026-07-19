// Unified CORS reverse proxy — all FurEnglish APIs go through localhost:3000
import http from 'node:http';
import https from 'node:https';

const ROUTES = {
  '/dict/':      'api.lanxis.top',
  '/translate/': 'lingva.lanxis.top',
  '/words/':     'datamuse.lanxis.top',
};

http.createServer((req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }

  const route = Object.entries(ROUTES).find(([prefix]) => req.url.startsWith(prefix));
  if (!route) { res.writeHead(404); res.end('Unknown route'); return; }

  const [prefix, host] = route;
  const path = req.url.slice(prefix.length - 1); // keep leading /

  const proxy = https.request({ host, path, method: req.method, headers: {...req.headers, host} }, pr => {
    res.writeHead(pr.statusCode, pr.headers);
    pr.pipe(res);
  });
  proxy.on('error', e => { res.writeHead(502); res.end(e.message); });
  req.pipe(proxy);
}).listen(3000, () => console.log('FurEnglish proxy → http://localhost:3000'));
