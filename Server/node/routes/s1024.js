var express = require('express');
var router = express.Router();

var s1024 = 'A'.repeat(1024)

router.get('/', function(req, res, next) {
  res.send(s1024);
});

module.exports = router;
