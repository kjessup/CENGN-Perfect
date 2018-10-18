var express = require('express');
var router = express.Router();

var s4096 = 'A'.repeat(4096)

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send(s4096);
});

module.exports = router;
