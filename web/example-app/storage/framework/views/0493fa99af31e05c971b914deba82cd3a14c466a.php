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
        const locationButton = document.createElement("button");
        locationButton.textContent = "แสดงตำแหน่งปัจจุบัน";
        locationButton.classList.add("custom-map-control-button");
        map.controls[google.maps.ControlPosition.TOP_CENTER].push(
          locationButton
        );
        locationButton.addEventListener("click", () => {
          // Try HTML5 geolocation.
          if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
              (position) => {
                const pos = {
                  lat: position.coords.latitude,
                  lng: position.coords.longitude,
                };
                marker = new google.maps.Marker({
                position: pos,map,
                draggable: true,
                animation: google.maps.Animation.DROP,
                });
                infoWindow.setPosition(pos);
                infoWindow.setContent("เข้า/ออก");
                infoWindow.open(map,marker);
                map.setCenter(pos);
              },
              () => {
                handleLocationError(true, infoWindow, map.getCenter());
              }
            );
          } else {
            // Browser doesn't support Geolocation
            handleLocationError(false, infoWindow, map.getCenter());
          }
        });
      }

      function handleLocationError(browserHasGeolocation, infoWindow, pos) {
        infoWindow.setPosition(pos);
        infoWindow.setContent(
          browserHasGeolocation
            ? "Error: The Geolocation service failed."
            : "Error: Your browser doesn't support geolocation."
        );
        infoWindow.open(map);

      }
    </script>
  </head>
  <body>
    <h1>สวัสดีท่านสมาชิก</h1>
    <a href="<?php echo e(url('/')); ?>">Home</a>
    <a href="<?php echo e(url('userlocate')); ?>">Users</a>
    <a href="<?php echo e(url('driverlocate')); ?>">Driver</a>
    <div id="map"></div>

    <!-- Async script executes immediately and must be after any DOM elements used in callback. -->
    <script
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBSaaROLQQlFY4xMlTf9plC925bsdnbDGg&callback=initMap&libraries=&v=weekly"
      async
    ></script>
  </body>
</html>
<?php /**PATH C:\xampp\htdocs\61020908\example-app\resources\views/user/locate.blade.php ENDPATH**/ ?>