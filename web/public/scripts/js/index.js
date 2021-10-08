// const { route } = require("../../../routes/auth-routes");

var lat
var lng
var beachMarker
var connection = new WebSocket('ws://localhost:34000')

var current_lat;
var current_lng;
var user_email
var driver_id
var score
var comment
connection.onopen = function () {
    // จะทำงานเมื่อเชื่อมต่อสำเร็จ
    console.log("connect webSocket");
    // connection.send("Hello ESUS"); // ส่ง Data ไปที่ Server
};
connection.onerror = function (error) {
    console.error('WebSocket Error ' + error);
};


var maps;
// var position = { lat: current_lat, lng: current_lng};

function geocoderAddress(geocoder, resultsMap) {
    var address = document.getElementById('address').value;
    geocoder.geocode({ 'address': address }, function (results, status) {
        if (status === 'OK') {
            resultsMap.setCenter(results[0].geometry.location);
            var marker = new google.maps.Marker({
                map: resultsMap,
                position: results[0].geometry.location,
            });
        } else {
            alert('Geocode was not successful for the following reason: ' + status);
        }
    });
}



function getLocation() {
    console.log('hi')
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
    } else {
        alert("Geolocation is not supported by this browser.");
    }
}

function showPosition(position) {
    current_lat = position.coords.latitude
    current_lng = position.coords.longitude;
}

$(document).ready(function () {
    getemail()
    getLocation();
    setInterval(checksendrequest, 1000); //ทำทุก 1 วินาที

    $('#eiei').click(function () {
        $('.popup_box').css({
            "opacity": "1",
            "pointer-events": "auto"
        });
    });
    $('.btn1').click(function () {
        $('.popup_box').css({
            "opacity": "0",
            "pointer-events": "none"
        });
        requesttodb(1)
        checksendrequest ()
    });
    $('.btn2').click(function () {
        $('.popup_box').css({
            "opacity": "0",
            "pointer-events": "none"
        });
        requesttodb(0)
        checksendrequest()
    });
    $("#Logout").click(function (e) {
        e.preventDefault();
        window.location.replace('/auth/logout')
    });
    $('#sendinfo').click(function () {
        score = $('.fa-star').val()
        var point = document.getElementsByName('rate');
        for (let i = 0; i < point.length; i++) {
            if (point[i].checked) {
                score = point[i].value
            }
           comment =$('.getdata').val();

        }
       
        $.ajax({
            type: "POST",
            url: "/review",
            data: { user_email: user_email, driver_id: driver_id, point: score, report: comment },
            success: function(response) {
                Swal.fire({
                    title: 'Add request success',
                    text: "Request success✔✔✔ Please wait",
                    icon: 'success',
                    showCancelButton: false,
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'Yes'
                }).then((result) => {
                    if (result.isConfirmed) {
                        sessionStorage.setItem("requestid",response)
                        var x = document.getElementById("review");
                        var y = document.getElementById("eiei");
                        x.style.display = 'none'
                        y.style.display = 'block'
                        sessionStorage.removeItem("requestid")
                        checksendrequest()
                        window.location.reload()
                    }
                })
            },
            error: function(xhr) {
                Swal.fire({
                    icon: "error",
                    title: xhr.responseText,
                });
            }
        });
    })

})

function requesttodb(direction) {
    $.ajax({
        type: "POST",
        url: "/request",
        data: { user_email: user_email, lat: current_lat, lng: current_lng, route: direction },
        success: function (response) {
            Swal.fire({
                title: 'Add request success',
                text: "Request success✔✔✔ Please wait",
                icon: 'success',
                showCancelButton: false,
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'Yes'
            }).then((result) => {
                if (result.isConfirmed) {
                    sessionStorage.setItem("requestid", response)
                    window.location.replace('/mapping')
                }
            })
        },
        error: function (xhr) {
            Swal.fire({
                icon: "error",
                title: xhr.responseText,
            });
        }
    });
}
function check_request() {
    $.ajax({
        type: "POST",
        url: "/request",
        data: { user_email: user_email, lat: current_lat, lng: current_lng, route: direction },
        success: function (response) {
            Swal.fire({
                title: 'Add request success',
                text: "Request success✔✔✔ Please wait",
                icon: 'success',
                showCancelButton: false,
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'Yes'
            }).then((result) => {
                if (result.isConfirmed) {
                    sessionStorage.setItem("requestid", response)
                    window.location.replace('/mapping')
                }
            })
        },
        error: function (xhr) {
            Swal.fire({
                icon: "error",
                title: xhr.responseText,
            });
        }
    });
}

function checksendrequest() {
    var request = sessionStorage.getItem("requestid")
    if (request) {
        var x = document.getElementById("review");
        var y = document.getElementById("eiei");
        x.style.display = 'none'
        y.style.display = 'none'

        $.ajax({
            type: "POST",
            url: "/requestinfo",
            data: { requestdata: request },
            success: function (response) {
                if (response[0].res_driver) {
                    driver_id = response[0].res_driver
                    x.style.display = 'block'
                }

            },
            error: function (xhr) {
                Swal.fire({
                    icon: "error",
                    title: xhr.responseText,
                });
            }
        });
    } else {
        var x = document.getElementById("review");
        var y = document.getElementById("eiei");
        y.style.display = 'block'
        x.style.display = 'none'
    }
}

function getemail() {
    $.ajax({
        type: "GET",
        url: "/verify",
        success: function (response) {
            user_email = response.email
        },
        error: function (xhr) {
            Swal.fire({
                icon: "error",
                title: xhr.responseText,
            });
        }
    });
}
// This example creates a 2-pixel-wide red polyline showing the path of
// the first trans-Pacific flight between Oakland, CA, and Brisbane,
// Australia which was made by Charles Kingsford Smith.
function initMap() {
    const directionsService = new google.maps.DirectionsService();
    const directionsRenderer = new google.maps.DirectionsRenderer();
    const map = new google.maps.Map(document.getElementById("map"), {

    });

    directionsRenderer.setMap(map);
    calculateAndDisplayRoute(directionsService, directionsRenderer);


    var image = '/image/car_13260.png';
    var myLatLng = new google.maps.LatLng(19.024647, 99.943809); //or wherever you want the marker placed
    beachMarker = new google.maps.Marker({
        position: myLatLng,
        map: map,
        icon: image

    });


}

function calculateAndDisplayRoute(directionsService, directionsRenderer) {
    directionsService
        .route({
            origin: "19.031459,99.926547",
            destination: "19.172379, 99.898241",
            travelMode: google.maps.TravelMode.DRIVING,
        })
        .then((response) => {
            directionsRenderer.setDirections(response);
        })
        .catch((e) => window.alert("Directions request failed due to " + status));
}

function calculateAndDisplayRoute(directionsService, directionsRenderer) {
    directionsService
        .route({
            origin: "19.172379, 99.898241",
            destination: "19.031459,99.926547",
            travelMode: google.maps.TravelMode.DRIVING,
        })
        .then((response) => {
            directionsRenderer.setDirections(response);
        })
        .catch((e) => window.alert("Directions request failed due to " + status));
}

connection.onmessage = function (e) {
    var yourString = e.data;
    var array = [];
    yourString.split(':').forEach(function (value) {
        array.push(value.split(' '));
    });
    // log ค่าที่ถูกส่งมาจาก server
    // console.log("message from server: ", e.data);
    // const map = new google.maps.Map(document.getElementById("map"), {
    //   zoom: 18,
    //   center: { lat: 19.024647, lng: 99.943809 },
    // });

    lat = parseFloat(array[2])
    lng = parseFloat(array[4])
    var latlng = new google.maps.LatLng(lat, lng);
    beachMarker.setPosition(latlng);

};