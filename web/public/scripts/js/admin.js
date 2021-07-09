$(document).ready(function () {
    var mode = "";
    var blogID = 0;
    $(".closes").click(function(){
        $("#exampleModal").modal("toggle");  
    })

    $(".close").click(function(){
        $("#exampleModal2").modal("toggle");  
    })

    $(".btnDelete").click(function () {
        blogID = $(this).attr("blogID");
        $("#exampleModal2").modal("toggle");
    })

    $("#btnModalSave").click(function () {
        // close modal
        $("#exampleModal").modal("toggle");

        // add       
        let data = {
            username: $("#name").val(),
            email: $("#email").val(),
            tel: $("#tel").val(),
            role: $("#selectrole").val()

        };
        let method = "POST";
        let url = "/adminse/new";

        // edit
        if (mode == "edit") {
            data = {
                name: $("#name").val(),
                email: $("#email").val(),
                tel: $("#tel").val(),
                role: $("#selectrole").val(),
                id: blogID
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
        $("#exampleModalLabel").text("Add User");
        // console.log(postData);
        $("#name").val('');
        $("#email").val('');
        $("#tel").val('');
        $("#selectrole").val('');
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
        // console.log(postData);
        $("#name").val(postData.name);
        $("#email").val(postData.email);
        $("#tel").val(postData.tel);
        $("#selectrole").val('');
        blogID = postData.Id;
    });

    $("#deletekiki").click(function () {
        $.ajax({
            type: "DELETE",
            url: "/adminse/" + blogID,
            data: { id: blogID },
        }).done(function (data, state, xhr) {
            alert("delete success")
                window.location.replace(data)
        })
    })

});

