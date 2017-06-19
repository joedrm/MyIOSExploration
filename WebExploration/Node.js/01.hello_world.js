/**
 * Created by wdy on 2017/6/9.
 */


var http = require('http');
var server = http.createServer(function (req, res) {

    res.writeHead(200, {"Content-type":"text/html; chartset=UTF-8"});
    res.end('hello world!')
});

server.listen(3000, '127.0.0.1');