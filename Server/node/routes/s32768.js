var express = require('express');
var router = express.Router();

var s8192 = 'A'.repeat(8192)

router.get('/', function(req, res, next) {
  res.send(s8192);
});

module.exports = router;
