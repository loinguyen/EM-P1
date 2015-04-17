function codeAddress() {
	var address = $('#location-search').val();
	if (address == "") return; 
	
	var geocoder = new google.maps.Geocoder();
	geocoder.geocode( { 'address': address}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			searchAddressWithinHN(address + " Hà Nội, Việt Nam");
		} else {
			if(status=='ZERO_RESULTS') {
				$("#address-error").text("*Địa chỉ không tồn tại");
				return;
			}
			alert('Geocode was not successful for the following reason: ' + status);
		}
	});
}

function searchAddressWithinHN(address) {
	var geocoder = new google.maps.Geocoder();
	geocoder.geocode( { 'address': address}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			//markerCreateEvent.setPosition(results[0].geometry.location);
			
			calcRoute(results[0].geometry.location, myLatlng);
			document.getElementById('msg-info').innerHTML = "";
		} else {
			if(status=='ZERO_RESULTS') {
				$("#address-error").text("*Địa chỉ không tồn tại");
				return;
			}
			alert('Geocode was not successful for the following reason: ' + status);
		}
	});
}

function calcRoute(start, end) {
  var request = {
    origin: start,
    destination: end,
    travelMode: google.maps.TravelMode.DRIVING
  };
  directionsService.route(request, function(response, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(response);
      mapRoute.setZoom(12);
    }
  });
}

function doGeolocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(positionSuccess, positionError);
    } else {
      positionError(-1);
    }
  }

  function positionError(err) {
    var msg;
    switch(err.code) {
      case err.UNKNOWN_ERROR:
        msg = "Unable to find your location";
        break;
      case err.PERMISSION_DENINED:
        msg = "Permission denied in finding your location";
        break;
      case err.POSITION_UNAVAILABLE:
        msg = "Your location is currently unknown";
        break;
      case err.BREAK:
        msg = "Attempt to find location took too long";
        break;
      default:
        msg = "Location detection not supported in browser";
    }
    document.getElementById('msg-info').innerHTML = msg;
  }

  function positionSuccess(position) {
    // Centre the map on the new location
    var coords = position.coords || position.coordinate || position;
    var latLng = new google.maps.LatLng(coords.latitude, coords.longitude);
	yourLocation = latLng;
	google.maps.visualRefresh = true;
	
    document.getElementById('msg-info').innerHTML = 'Looking for <b>' +
        coords.latitude + ', ' + coords.longitude + '</b>...';

    // And reverse geocode.
    (new google.maps.Geocoder()).geocode({latLng: latLng}, function(resp) {
		  var place = "You're around here somewhere!";
		  if (resp[0]) {
			  var bits = [];
			  for (var i = 0, I = resp[0].address_components.length; i < I; ++i) {
				  var component = resp[0].address_components[i];
				  if (contains(component.types, 'political')) {
					  bits.push('<b>' + component.long_name + '</b>');
					}
				}
				if (bits.length) {
					place = bits.join(' > ');
				}
			}
			document.getElementById('msg-info').innerHTML = place;
	  });
  }

  function contains(array, item) {
    for (var i = 0, I = array.length; i < I; ++i) {
	  if (array[i] == item) return true;
	}
	return false;
  }