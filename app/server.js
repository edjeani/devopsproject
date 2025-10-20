const http = require('http');
const port = process.env.PORT || 3000;
const server = http.createServer((_, res) => {
  res.writeHead(200, {'Content-Type':'text/plain'});
  res.end('OK: secure-app\n');
});
server.listen(port, () => console.log(`Listening on ${port}`));
