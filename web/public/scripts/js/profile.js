$(document).ready(function () {
    $.ajax({
        type: "GET",
        url: "/verify",
        success: function (response) {
            if(response.email != null){
                document.getElementById("avatarchange").src = response.photo
            }
            
        },
        error: function (xhr) {
          Swal.fire({
            icon: "error",
            title: xhr.responseText,
          });
        }
      });
});