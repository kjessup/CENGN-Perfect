var express = require('express');
var router = express.Router();

var s32768 = 'A'.repeat(32768)

router.get('/', function(req, res, next) {
  res.send(s32768);
});

module.exports = router;
