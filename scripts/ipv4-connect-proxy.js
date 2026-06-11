const http = require("http");
const net = require("net");
const dns = require("dns");

const PORT = Number(process.env.PROXY_PORT || 8877);

const server = http.createServer((req, res) => {
  res.writeHead(501, { "Content-Type": "text/plain" });
  res.end("CONNECT only\n");
});

server.on("connect", (req, clientSocket, head) => {
  const [host, portString] = req.url.split(":");
  const port = Number(portString || 443);

  dns.lookup(host, { family: 4 }, (lookupErr, address) => {
    if (lookupErr) {
      clientSocket.end("HTTP/1.1 502 Bad Gateway\r\n\r\n");
      return;
    }

    const upstream = net.connect({ host: address, port }, () => {
      clientSocket.write("HTTP/1.1 200 Connection Established\r\n\r\n");
      if (head && head.length) upstream.write(head);
      upstream.pipe(clientSocket);
      clientSocket.pipe(upstream);
    });

    upstream.on("error", () => clientSocket.end("HTTP/1.1 502 Bad Gateway\r\n\r\n"));
  });
});

server.listen(PORT, "127.0.0.1", () => {
  process.stdout.write(`proxy listening on 127.0.0.1:${PORT}\n`);
});
