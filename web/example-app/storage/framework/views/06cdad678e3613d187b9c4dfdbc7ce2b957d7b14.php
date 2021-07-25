<!DOCTYPE html>
<html>
  <head>
    <title>Driver</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <style>
     #map {
        height: 100%;
      }
        html, body {
        margin-left: 100px;
        padding: 0%;
        height: 720px;
        width: 1280px;
      }

    </style>
        <script>
            function initMap() {
                var map = new google.maps.Map(document.getElementById('map'), {
                center: {  lat: 19.030800, lng: 99.924088 },
                 zoom: 16,
                });
                var infoWindow = new google.maps.InfoWindow({map: map});
                // Try HTML5 geolocation.
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function(position) {
                    const pos = {
                        lat: position.coords.latitude,
                        lng: position.coords.longitude
                    };
                    map.setCenter(pos);
                    marker = new google.maps.Marker({
                    position: pos,map,
                    draggable: true,
                    animation: google.maps.Animation.DROP,
                    });
                    infoWindow.setPosition(pos);
                    infoWindow.setContent("เข้า/ออก");
                    infoWindow.open(map,marker);
                    map.setCenter(pos);
                    }, function() {
                    handleLocationError(true, infoWindow, map.getCenter());
                });
                } else {
                // Browser doesn't support Geolocation
                handleLocationError(false, infoWindow, map.getCenter());
                }
            }
        </script>
    </head>
    <body>
        <h1>สวัสดีท่านคนขับรถ</h1>
        <a href="<?php echo e(url('/')); ?>">Home</a>
        <a href="<?php echo e(url('userlocate')); ?>">Users</a>
        <a href="<?php echo e(url('driverlocate')); ?>">Driver</a>
        <div id="map"></div>
        <div id="map"></div>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBSaaROLQQlFY4xMlTf9plC925bsdnbDGg&signed_in=true&callback=initMap"
        async defer>
        </script>
    </body>
</html>
<?php /**PATH C:\xampp\htdocs\61020908\example-app\resources\views/driver/locate.blade.php ENDPATH**/ ?>