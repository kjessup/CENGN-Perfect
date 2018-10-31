var express = require('express');
var router = express.Router();

var s2048 = 'A'.repeat(2048)

router.post('/', function(req, res, next) {
  var prefix = "abc";
  for(var ch = 'a'.charCodeAt(0); ch <= 'z'.charCodeAt(0); ch++ ) {
    var key = prefix + String.fromCharCode(ch);
    var v = req.body[key];
  }
  res.send(s2048);
});

module.exports = router;
