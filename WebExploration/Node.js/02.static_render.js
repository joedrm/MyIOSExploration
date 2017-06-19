/**
 * Created by wdy on 2017/6/9.
 */


var http = require('http');
var fs = require('fs');


var server = http.createServer(function (req, res) {

    if (req.url=="/fang"){
        fs.readFile('./02.test1.html', function (err, data) {
            res.writeHead(200, {"Content-type":"text/html; chartset=UTF-8"});
            res.end(data);
        });
    }else if (req.url=="/yuan"){
        fs.readFile('./02.test2.html', function (err, data) {
            res.writeHead(200, {"Content-type":"text/html; chartset=UTF-8"});
            res.end(data);
        });
    }else if (req.url=="/xiaohuangren.jpg"){
        fs.readFile('./xiaohuangren.jpg', function (err, data) {
            res.writeHead(200, {"Content-type":"image/jpg"});
            res.end(data);
        });
    }else {
        res.writeHead(404, {"Content-type":"text/html; chartset=UTF-8"});
        res.end("没有这个页面!");
    }
});

server.listen(3000, '127.0.0.1');