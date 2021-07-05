<?php

use App\Http\Controllers\admin_control;
use App\Http\Controllers\driver_con;
use App\Http\Controllers\driver_control;
use App\Http\Controllers\user_con;
use App\Http\Controllers\user_control;
use App\Http\Controllers\users_control;
use Illuminate\Support\Facades\Route;
use SebastianBergmann\CodeCoverage\CrapIndex;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::get('map', function () {
    return view('marker');
});
Route::get('userlocate',[user_con::class,'index']);
Route::get('driverlocate',[driver_con::class,'index']);
Route::get('infowindow', function () {
    return view('infowindow');
});
