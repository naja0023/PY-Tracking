$(document).ready(function () {
    $("#btnregister").click(function () { 
        window.location.href = "/register";
        
    });
    $("#btnlogin").click(function () { 
        window.location.href = "/auth/google";
        
    });
    
})