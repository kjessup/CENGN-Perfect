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

global $s1024, $s2048, $s4096, $s8192;
$s1024 = str_repeat("A", 1024);
$s2048 = str_repeat("A", 2048);
$s4096 = str_repeat("A", 4096);
$s8192 = str_repeat("A", 8192);
	
Route::get('/empty', function () {
	return "";
});
Route::get('/1024', function () {
	global $s1024;
	return $s1024;
});
Route::get('/2048', function () {
	global $s2048;
	return $s2048;
});
Route::get('/4096', function () {
	global $s4096;
	return $s4096;
});
Route::get('/8192', function () {
	global $s8192;
	return $s8192;
});
