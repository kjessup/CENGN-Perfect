<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

global $s1024;
global $s2048;
global $s4096;
global $s8192;

$s2048 = str_repeat("A", 2048);
$s8192 = str_repeat("A", 8192);
$s32768 = str_repeat("A", 32768);
	
Route::get('/empty', function () {
	return "";
});
Route::get('/2048', function () {
	global $s2048;
	return $s2048;
});
Route::get('/8192', function () {
	global $s8192;
	return $s8192;
});
Route::get('/32768', function () {
	global $s32768;
	return $s32768;
});

function read(Request $request) {
	$prefix = 'abc';
	$letter = 'a';
	foreach (range('a', 'z') as $letter) {
		$key = $prefix . $letter;
		$f = $request->get($key);
		echo "value " . $f;
	}
}

Route::get('/getArgs2048', function (Request $request) {
	read($request);
	global $s2048;
	return $s2048;
});
Route::post('/postArgs2048', function (Request $request) {
	read($request);
	global $s2048;
	return $s2048;
});
Route::post('/postArgsMulti2048', function (Request $request) {
	read($request);
	global $s2048;
	return $s2048;
});
