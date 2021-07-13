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
      