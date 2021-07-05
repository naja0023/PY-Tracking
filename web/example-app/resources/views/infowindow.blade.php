<!DOCTYPE html>
<html>
  <head>
    <title>USERS</title>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    <style type="text/css">
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }

      /* Optional: Makes the sample page fill the window. */
      html,
      body {
        margin-left: 100px;
        padding: 0%;
        height: 720px;
        width: 1280px;
      }

      .custom-map-control-button {
        appearance: button;
        background-color: #fff;
        border: 0;
        border-radius: 2px;
        box-shadow: 0 1px 4px -1px rgba(0, 0, 0, 0.3);
        cursor: pointer;
        margin: 10px;
        padding: 0 0.5em;
        height: 40px;
        font: 400 18px Roboto, Arial, sans-serif;
        overflow: hidden;
      }
      .custom-map-control-button:hover {
        background: #ebebeb;
      }
    </style>
    <script>
      // Note: This example requires that you consent to location sharing when
      // prompted by your browser. If you see the error "The Geolocation service
      // failed.", it means you probably did not give permission for the browser to
      // locate you.
      let map, infoWindow;

      function initMap() {
        map = new google.maps.Map(document.getElementById("map"), {
          center: {  lat: 19.030800, lng: 99.924088 },
          zoom: 16,
        });
        infoWindow = new google.maps.InfoWindow();
        const p ={
          lat: 19.030800, lng: 99.924088,
        };
        infoWindow.setPosition(p);
        infoWindow.setContent("นี่คือการสร้าง infowindow");
        infoWindow.open(map);
        map.setCenter(p);
      }
    </script>
  </head>
  <body>
    <h1>สวัสดีท่านสมาชิก</h1>
    <a href="{{url('/')}}">Home</a>
    <a href="{{url('userlocate')}}">Users</a>
    <a href="{{url('driverlocate')}}">Driver</a>
    <div id="map"></div>

    <!-- Async script executes immediately and must be after any DOM elements used in callback. -->
    <script
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBSaaROLQQlFY4xMlTf9plC925bsdnbDGg&callback=initMap&libraries=&v=weekly"
      async
    ></script>
  </body>
</html>
