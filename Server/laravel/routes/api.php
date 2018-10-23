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

	$s1024 = str_repeat("A", 1024);
	$s2048 = str_repeat("A", 2048);
	$s4096 = str_repeat("A", 4096);
	$s8192 = str_repeat("A", 8192);
	
Route::get('/empty', function () {
	return "";
});
Route::get('/s1024', function () {
   return $s1024;
});
Route::get('/s2048', function () {
   return $s2048;
});
Route::get('/s4096', function () {
	return $s4096;
});
Route::get('/s8192', function () {
   return $s8192;
});
