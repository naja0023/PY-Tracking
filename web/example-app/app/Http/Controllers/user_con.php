<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class user_con extends Controller
{
    function index(){
        return view('user.locate');
    }
}
