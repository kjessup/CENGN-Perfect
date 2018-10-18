var express = require('express');
var router = express.Router();

var s8192 = 'A'.repeat(8192)

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send(s8192);
});

module.exports = router;
