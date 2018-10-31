var express = require('express');
var router = express.Router();

var s2048 = 'A'.repeat(2048)

router.get('/', function(req, res, next) {
  var prefix = "abc";
  for(var ch = 'a'.charCodeAt(0); ch <= 'z'.charCodeAt(0); ch++ ) {
    var key = prefix + String.fromCharCode(ch);
    var v = req.query[key];
  }
  res.send(s2048);
});

module.exports = router;
