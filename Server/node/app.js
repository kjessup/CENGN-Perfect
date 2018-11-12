var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var emptyRouter = require('./routes/empty');
var s2048Router = require('./routes/s2048');
var s8192Router = require('./routes/s8192');
var s32768Router = require('./routes/s32768');

var getArgs2048 = require('./routes/getArgs2048');
var postArgs2048 = require('./routes/postArgs2048');
var postArgsMulti2048 = require('./routes/postArgsMulti2048');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

//app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/empty', emptyRouter);
app.use('/2048', s2048Router);
app.use('/8192', s8192Router);
app.use('/32768', s32768Router);

app.use('/getArgs2048', getArgs2048);
app.use('/postArgs2048', postArgs2048);
app.use('/postArgsMulti2048', postArgsMulti2048);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
