var http = require('http');

var handleRequest = function(request, response) {
  console.log('Received request for URL: ' + request.url);
  response.writeHead(200);
  response.end('<h1 style="font-size:75px;color:#2b1f0c">Hello World!</h1>');
};

console.log('Started to serve 8080...')
var www = http.createServer(handleRequest);
www.listen(8080);
