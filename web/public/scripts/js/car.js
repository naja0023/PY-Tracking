$(document).ready(function () {
    var mode = "";
    var car_id = 0;
    $(".closes").click(function(){
        $("#exampleModal").modal("toggle");  
    })

    $(".close2").click(function(){
        $("#exampleModal2").modal("toggle");  
    })

    $(".btnDelete").click(function () {
        car_id = $(this).attr("blogID");
        $("#exampleModal2").modal("toggle");
    })

    $("#btnModalSave").click(function () {
        // close modal
        $("#exampleModal").modal("toggle");

        // add       
        let data = {
            License_plate: $("#editer").val(),
            seat: $("#seat").val(),
            

        };
        let method = "POST";
        let url = "/addcar";

        // edit
        if (mode == "edit") {
            data = {
                name: $("#name").val(),
                lastname: $("#editer").val(),
                tell: $("#tel").val(),
                idcard:$("#card").val(),
                email: $("#email").val(),
                role: $("#selectrole").val(),
                id: car_id
            };
            method = "PUT";
            url = "/adminse/edit";
        }

        $.ajax({
            type: method,
            url: url,
            data: data,
            success: function (response) {
                alert("Success")
                window.location.replace(response);
            },
            error: function (xhr) {
                Swal.fire({
                    icon: "error",
                    title: xhr.responseText,
                });
            }
        });
    });

    $("#adduser").click(function () {
        mode = "add";
        // change the modal title
        // change the modal title
        $("#exampleModalLabel").text("Add Car");
        // console.log(postData);
        $("#editer").val('');
        $("#seat").val('');
        // show modal
        $("#exampleModal").modal("toggle");

    });

    // Edit button
    $(".btnEdit").click(function () {
        mode = "edit";
        // change the modal title
        $("#exampleModalLabel").text("Edit User");
        // show modal
        $("#exampleModal").modal("toggle");
        // get selected post data
        const postData = JSON.parse($(this).attr("blogData"));
         console.log(postData);
        $("#name").val(postData.name);
        $("#email").val(postData.email);
        $("#tel").val(postData.tell);
        $("#selectrole").val('');
        car_id = postData.driver_id;
        
    });

    // $("#deletekiki").click(function () {
    //     $.ajax({
    //         type: "DELETE",
    //         url: "/deletecar",
    //         data: { car_id: car_id },
    //     }).done(function (data, state, xhr) {
    //         alert("delete success")
    //             window.location.replace(data)
    //     })
    // })

});

