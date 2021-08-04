var maps; 
      var position={lat:19.024647,lng:99.943809};
      function initMap(){
        maps = new google.maps.Map(document.getElementById('map'),{
              center:position,
              zoom: 15,
        });
        var geocoder = new google.maps.Geocoder();
        document.getElementById('submit').addEventListener('click',function(){
          geocoderAddress(geocoder,maps);
        });
      }
      function geocoderAddress(geocoder,resultsMap){
        var address = document.getElementById('address').value;
        geocoder.geocode({'address':address},function(results,status){
          if (status === 'OK') {
            resultsMap.setCenter(results[0].geometry.location);
            var marker = new google.maps.Marker({
              map:resultsMap,
              position:results[0].geometry.location,
            });
          } else {
            alert('Geocode was not successful for the following reason: '+status);
          }
        });
      }
      $(document).ready(function(){
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
    zoom: 18,
    center: { lat: 19.024647, lng: 99.943809 },
  });
  directionsRenderer.setMap(map);
  calculateAndDisplayRoute(directionsService, directionsRenderer);
 
}

function calculateAndDisplayRoute(directionsService, directionsRenderer) {
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