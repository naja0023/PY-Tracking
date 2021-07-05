<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class driver_con extends Controller
{
    function index(){
        return view('driver.locate');
    }
}
