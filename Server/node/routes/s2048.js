var express = require('express');
var router = express.Router();

var s2048 = 'A'.repeat(2048)

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send(s2048);
});

module.exports = router;
