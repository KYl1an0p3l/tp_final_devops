const http = require('http');

// On crée un serveur qui répond "OK"
const server = http.createServer((req, res) => {
  res.writeHead(200);
  res.end('API en ligne !!!');
});

// On lui dit d'écouter sur le port 3000
server.listen(3000, () => {
  console.log("L'API est prête et écoute sur le port 3000.");
});