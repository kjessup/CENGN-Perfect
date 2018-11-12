
var express = require('express');
var router = express.Router();

var s2048 = 'A'.repeat(2048)

var multer  = require('multer')
var upload = multer()

router.post('/', upload.none(), function(req, res, next) {
  var prefix = "abc";
  for(var ch = 'a'.charCodeAt(0); ch <= 'z'.charCodeAt(0); ch++ ) {
    var key = prefix + String.fromCharCode(ch);
    var v = req.body[key];
    //console.log(v);
  }
  res.send(s2048);
});

module.exports = router;
