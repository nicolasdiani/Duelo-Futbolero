/* Service worker de Duelo Futbolero (v312).
   Existe para que Chrome ofrezca instalar el juego en el inicio del teléfono.
   NO guarda nada en caché a propósito: cada versión nueva se ve apenas se
   publica, igual que antes de tener acceso directo. Lo único que agrega es un
   aviso claro cuando se abre el juego sin conexión. */
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));
self.addEventListener('fetch', e => {
  if(e.request.mode !== 'navigate') return;
  e.respondWith(fetch(e.request).catch(() => new Response(
    '<!DOCTYPE html><html lang="es"><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">' +
    '<title>Duelo Futbolero</title><body style="margin:0;min-height:100vh;display:grid;place-items:center;background:#000;color:#e8f1ec;font:16px/1.5 system-ui,sans-serif;text-align:center;padding:24px;box-sizing:border-box">' +
    '<div><p style="font-weight:800;font-size:20px;color:#ffb21a;margin:0 0 8px">SIN CONEXIÓN</p>' +
    '<p style="margin:0 0 20px">Duelo Futbolero necesita internet para jugar.</p>' +
    '<button onclick="location.reload()" style="font:700 15px system-ui;padding:12px 24px;border:0;border-radius:4px;background:#ffb21a;color:#140c00">REINTENTAR</button></div></body></html>',
    { headers:{ 'Content-Type':'text/html; charset=utf-8' } }
  )));
});
