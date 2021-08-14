var lat
var lng
var beachMarker
var connection = new WebSocket('ws://localhost:34000')
connection.onopen = function () {
  // จะทำงานเมื่อเชื่อมต่อสำเร็จ
  console.log("connect webSocket");
  // connection.send("Hello ESUS"); // ส่ง Data ไปที่ Server
};
connection.onerror = function (error) {
  console.error('WebSocket Error ' + error);
};

var maps;
var position = { lat: 19.024647, lng: 99.943809 };
function initMap() {
  maps = new google.maps.Map(document.getElementById('map'), {
    center: position,
    zoom: 15,
  });
  var geocoder = new google.maps.Geocoder();
  document.getElementById('submit').addEventListener('click', function () {
    geocoderAddress(geocoder, maps);
  });
}
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
$(document).ready(function () {
  $('.request').click(function () {
    $('.popup_box').css({
      "opacity": "1", "pointer-events": "auto"
    });
  });
  $('.btn1').click(function () {
    $('.popup_box').css({
      "opacity": "0", "pointer-events": "none"
    });
  });
  $('.btn2').click(function () {
    $('.popup_box').css({
      "opacity": "0", "pointer-events": "none"
    });
  });
  $("#Logout").click(function (e) {
    e.preventDefault();
    window.location.replace('/auth/logout')
  });
  $("#profile").click(function (e) {
    e.preventDefault();
    window.location.replace('/profile')
  });
})
// This example creates a 2-pixel-wide red polyline showing the path of
// the first trans-Pacific flight between Oakland, CA, and Brisbane,
// Australia which was made by Charles Kingsford Smith.
function initMap() {
  const directionsService = new google.maps.DirectionsService();
  const directionsRenderer = new google.maps.DirectionsRenderer();
  const map = new google.maps.Map(document.getElementById("map"), {
    // zoom: 18,
    // center: { lat: 19.024647, lng: 99.943809 },
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
  // var driver = '"'+lat+','+lng+'"'
  directionsService
    .route({
      origin:
        "19.024647,99.943809"
      ,
      destination:
        "19.040660, 99.931254"
      ,
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
  redraw()
  beachMarker.setPosition(latlng);

};

// var numDeltas = 100;
// var delay = 10; //milliseconds
// var i = 0;
// var deltaLat;
// var deltaLng;

// function transition(result){
//     i = 0;

//     deltaLat = (result[0] - lat)/numDeltas;
//     deltaLng = (result[1] - lng)/numDeltas;
//     moveMarker();
// }

// function moveMarker(){
//     lat += deltaLat;
//     lng += deltaLng;
//     var latlng = new google.maps.LatLng(lat, lng);
// beachMarker.setTitle("Latitude:"+lat+" | Longitude:"+lng);
//     beachMarker.setPosition(latlng);
//     if(i!=numDeltas){
//         i++;
//         setTimeout(moveMarker, delay);
//         // initMap()
//     }
// }
