$(document).ready(function() {
    var mode = "";
    var blogID = 0;
    $(".closes").click(function() {
        $("#exampleModal").modal("toggle");
    })

    $(".close2").click(function() {
        $("#exampleModal2").modal("toggle");
    })

    $(".btnDelete").click(function() {
        blogID = $(this).attr("blogID");
        $("#exampleModal2").modal("toggle");
    })

    $("#btnModalSave").click(function() {
        // close modal
        $("#exampleModal").modal("toggle");

        // add       
        let data = {
            username: $("#username").val(),
            password: $("#password").val(),
            name: $("#name").val(),
            lastname: $("#editer").val(),
            tell: $("#tel").val(),
            email: $("#email").val(),
            id_card: $("#card").val(),
            address: $("#address").val(),
            sub: $("#sub").val(),
            dist: $("#dist").val(),
            prov: $("#prov").val(),
            zip: $("#zip").val(),
            sex: $("#sex").val(),
            role: $("#selectrole").val(),


        };
        let method = "POST";
        let url = "/adminse/new";

        // edit
        if (mode == "edit") {
            data = {
                username: $("#username").val(),
                password: $("#password").val(),
                name: $("#name").val(),
                lastname: $("#editer").val(),
                tell: $("#tel").val(),
                id_card: $("#card").val(),
                email: $("#email").val(),
                address: $("#address").val(),
                sub: $("#sub").val(),
                dist: $("#dist").val(),
                prov: $("#prov").val(),
                zip: $("#zip").val(),
                sex: $("#sex").val(),
                role: $("#selectrole").val(),
                driver_id: blogID
            };
            method = "PUT";
            url = "/adminse/edit";
        }

        $.ajax({
            type: method,
            url: url,
            data: data,
            success: function(response) {
                alert("Success")
                window.location.replace(response);
            },
            error: function(xhr) {
                Swal.fire({
                    icon: "error",
                    title: xhr.responseText,
                });
            }
        });
    });

    $("#adduser").click(function() {
        mode = "add";
        $("#btnModalSave").html("เพิ่ม")
            // change the modal title
            // change the modal title
        $("#exampleModalLabel").text("เพิ่มคนขับรถ");
        // console.log(postData);
        $("#username").val('');
        $("#password").val('');
        $("#name").val('');
        $("#editer").val('');
        $("#email").val('');
        $("#tel").val('');
        $("#card").val('');
        $("#address").val('');
        $("#sub").val('');
        $("#dist").val('');
        $("#prov").val('');
        $("#zip").val('');
        $("#sex").val('');
        $("#selectrole").val('');

        // show modal
        $("#exampleModal").modal("toggle");

    });

    // Edit button
    $(".editbut").click(function() {
        mode = "edit";
        $("#btnModalSave").html("แก้ไข")

        // change the modal title
        $("#exampleModalLabel").text("แก้ไขคนขับ");
        // show modal
        $("#exampleModal").modal("toggle");
        // get selected post data
        const postData = JSON.parse($(this).attr("blogData"));
        console.log(postData);
        $("#username").val(postData.username);
        $("#name").val(postData.name);
        $("#editer").val(postData.lastname);
        $("#email").val(postData.email);
        $("#tel").val(postData.tell);
        $("#card").val(postData.id_card);
        $("#address").val(postData.address);
        $("#sub").val(postData.sub);
        $("#dist").val(postData.dist);
        $("#prov").val(postData.prov);
        $("#zip").val(postData.zip);
        $("#sex").val(postData.sex);
        $("#selectrole").val(postData.role);
        blogID = postData.driver_id;

    });

    // $("#deletekiki").click(function () {
    //     $.ajax({
    //         type: "DELETE",
    //         url: "/adminse/" + blogID,
    //         data: { id: blogID },
    //     }).done(function (data, state, xhr) {
    //         alert("delete success")
    //             window.location.replace(data)
    //     })
    // })

});