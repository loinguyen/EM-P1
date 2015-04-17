//google.maps.visualRefresh = true;
var gmarkers = [];
var map;
var myCenter = new google.maps.LatLng(21.028676,105.848786);
var strictBounds = new google.maps.LatLngBounds(
     new google.maps.LatLng(20.76, 105.76), 
     new google.maps.LatLng(21.30, 105.90)
);
var filterCat = "all";

/*-------------------------- create icon for category and ranks --------------------------------*/
var iconShadow = new google.maps.MarkerImage('http://www.google.com/mapfiles/shadow50.png',
	      // The shadow image is larger in the horizontal dimension
	      // while the position and offset are the same as for the main image.
	      new google.maps.Size(37, 34),
	      new google.maps.Point(0,0),
	      new google.maps.Point(9, 34));

// filter all markers of a particular category
function filterCategory(category) {
	
	var cate = "";
	switch (category.toLowerCase()) {
		case "music":
			cate = music;
			break;
		case "fair":
			cate = fair;
			break;
		case "sport":
			cate = sport;
			break;
		case "art":
			cate = art;
			break;
		case "film":
			cate = film;
			break;
		case "offline":
			cate = offline;
			break;
		case "saleoff":
			cate = saleoff;
			break;
		case "other":
			cate = other;
			break;
		case "all":
			cate = "all";
			break;
		default:
			cate = category;
			break;
	}
	
	filterCat = cate;
//	searchOnMap(map);
		
	// hide or show maker
	for (var i=0; i < gmarkers.length; i++) {
		if (gmarkers[i].mycategory.toLowerCase() == cate || cate == "all") {
			gmarkers[i].setVisible(true);
		} else {
			gmarkers[i].setVisible(false);
		}
	}
    
    // hide or show item in mini-list
    var divs = $(".item");
    for (var i=0; i < divs.length; i++) {
    	if ($(divs[i]).attr("category") != undefined) {
	    	if ($(divs[i]).attr("category").toLowerCase() == cate || cate == "all") {
	    		$(divs[i]).show();
			} else {
				$(divs[i]).hide();
			}
    	}
    }

    $("#sidebar").mCustomScrollbar("destroy");
    $("#sidebar").mCustomScrollbar({
		scrollButtons:{
			enable:true
		},
		mouseWheelPixels: "500"
	});
    
	// == close the info window, in case its open on a marker that we just hid
//    infoWindow.close();
}

function getMarkerImage(icon) {
   
   var markerImg = new google.maps.MarkerImage(
		   contextPath + "/images/mapIcons/" + icon,
		  // This marker is 20 pixels wide by 34 pixels tall.
		  new google.maps.Size(60, 70),
		  // The origin for this image is 0,0.
		  new google.maps.Point(0,0),
		  // The anchor for this image is at 6,20.
		  new google.maps.Point(30, 70));
   
   return markerImg;
}

function catRank2img(category, rank) {
	var img = "";
	var imgRank = rank2img(rank);
	switch(category.toLowerCase()) {
		case music:
			img = "music-" + imgRank + ".png";
			break;
		case fair:
			img = "fair-" + imgRank + ".png";
			break;
		case sport:
			img = "sport-" + imgRank + ".png";
			break;
		case art:
			img = "art-" + imgRank + ".png";
			break;
		case film:
			img = "film-" + imgRank + ".png";
			break;
		case offline:
			img = "offline-" + imgRank + ".png";
			break;
		case saleoff:
			img = "saleoff-" + imgRank + ".png";
			break;
		case other:
			img = "other-" + imgRank + ".png";
			break;
	}
	
   return img;
}

function rank2img(rank) {
	var img = "";
	switch (rank) {
		case 1:
			img = "0star";
			break;
		case 2:
			img = "0star";
			break;
		case 3:
			img = "1star";
			break;
		case 4:
			img = "1star";
			break;		
		case 5:
			img = "3star";
			break;		
	}
	
	return img;
}

// initialize
google.maps.event.addDomListener(window, 'load', function() {
	
	// set options for map
	map = new google.maps.Map(document.getElementById('map-canvas'), {
		zoom: 14,
		center: myCenter,
		disableDoubleClickZoom: true,
		zoomControl: true,
		zoomControlOptions: {
			style: google.maps.ZoomControlStyle.LARGE,
			position: google.maps.ControlPosition.TOP_RIGHT
		},
		panControl: true,
	    panControlOptions: {
	        position: google.maps.ControlPosition.TOP_RIGHT
	    },
	    mapTypeControl: true,
	    mapTypeControlOptions: {
	        style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
	        position: google.maps.ControlPosition.TOP_RIGHT
	    },
		mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	
	
	 initGmap();
	 
	//can use bounds_changed event or center_changed event or dragend event
	 google.maps.event.addListener(map, 'dragend', function() {
		 if (!strictBounds.contains(map.getCenter())) {
			 var c = map.getCenter(),
	         x = c.lng(),
	         y = c.lat(),
	         maxX = strictBounds.getNorthEast().lng(),
	         maxY = strictBounds.getNorthEast().lat(),
	         minX = strictBounds.getSouthWest().lng(),
	         minY = strictBounds.getSouthWest().lat();
	
		     if (x < minX) x = minX;
		     if (x > maxX) x = maxX;
		     if (y < minY) y = minY;
		     if (y > maxY) y = maxY;
		
		     map.setCenter(new google.maps.LatLng(y, x));
		 };
		 
		 searchOnMap(map);
	 });
	 google.maps.event.addListener(map, 'zoom_changed', function() {
		 searchOnMap(map);
	 });
});

function searchOnMap(map) {
	var todayFirstTime = getFirstTimeOfDate(new Date());
	 if ($("#onmap").attr('class') == undefined || $("#onmap").attr('class') != 'active') {
		 return;
	 }
	 onTrending = false;
	 // get bounds of map
 	var bounds = map.getBounds();
 	var center = map.getCenter();
 	var data = {
 			query: {						
 				bool : {
					must : [
				        {
					        "filtered" : {
			 					"query" : {
									range : {
										"toDate" : { 
											"from" : todayFirstTime
										}
									}	
								},
			 					"filter" : {
			 						"geo_bounding_box" : {
			 							"event.location" : {
			 								"top_left" :  {
			 			                        "lat" :  bounds.ta.b,
			 			                        "lon" : bounds.ga.b
			 			                    },
			 			                    "bottom_right" : {
			 			                        "lat" : bounds.ta.d,
			 			                        "lon" : bounds.ga.d
			 			                    }
			 							}
			 						}
			 					}
			 				}
				        },	
						{
				        	match_phrase : {
								type: "public"
							}
						}
					],
					must_not : {
						match : {
							deleteFlag: true
						}
					}
				}
			},
			sort: [{
		            "_geo_distance" : {
		                "event.location" : {
		                        "lat" : center.d,
		                        "lon" : center.e
			                    },
		                "order" : "asc",
		                "unit" : "km"
		            }
		        },
		        {
				 createdDate : {order : "desc"} 
			}]					
 		}; 	
 	
 	if (filterCat!="" && filterCat != "all") {
		 data.query.bool.must.push({ match_phrase : {category: filterCat} });
	 }
 	console.log(center);
 	callESearchAPI(data, eSearchMode.onmap);
}

function initGmap() {
	
	infoWindow = new google.maps.InfoWindow;

	// when click on map, if infoWindow is open then it will be closed
	google.maps.event.addListener(map, 'click', function() {
		infoWindow.close();
	});

	// create group of marker
	var markers = [];
	
	// Create marker for event and mouse event for it
	for (var i = 0; i < eventContents.length; i++) {
		var lat = eventContents[i][1];
		var lng = eventContents[i][0];
		var title = eventContents[i][3];
		var category = eventContents[i][8];
		var rank = eventContents[i][7];
		var eventId = eventContents[i][6];
		
		// create marker
		var markerEvent = new google.maps.Marker({
			map: map,
			title: title,
			icon: getMarkerImage(catRank2img(category, rank)),
	        shadow: iconShadow,
			position: new google.maps.LatLng(lat, lng)
		});
		
		markerEvent.mycategory = category;                                 
		markerEvent.myname = eventId;
        gmarkers.push(markerEvent);
        var index = gmarkers.indexOf(markerEvent);
        $("#ml_"+ eventId).attr("index", index);
        $("#ml_"+ eventId).attr("category", category);
		
		// find marker and create infoWindow for it
		google.maps.event.addListener(markerEvent, 'click', function () {
			var latLng = this.getPosition();
			var i;
			var divMidContent = "";
			var midContents = [];

			for (i = 0; i < eventContents.length; i++) {
				if (eventContents[i][1] == latLng.lat().toFixed(6) && eventContents[i][0] == latLng.lng().toFixed(6)) {
					var midContent = new Object();
					midContent.content = "<a href='"+ contextPath +"/event/eventDetail?id="+  eventContents[i][6] +"'><div class='item revealUpFull'  id='ml_" + 
										 eventContents[i][6] +"' style='background: url(\"" + eventContents[i][2] + 
										 "\") 100%; background-size: cover;'><span class='info'><label class='title'>" + normalizeTitle(eventContents[i][3], 80) + 
										 "</label><br /><br /><label class='time' style='border-top: 1px solid white;'>" + eventContents[i][4] + 
										 "</label><span class='category inforwindow' id='ec_"+ eventContents[i][6] +"'>"+ eventContents[i][8] +"</span>" + 
										 "<br /><label class='location'>" + eventContents[i][5] + "</label></span><div class='sub-btn " + eventContents[i][9] + " " + 
										 eventContents[i][6] +"' eid='" + eventContents[i][6] + "' id='item" + i + "_sub' onclick='subcribeEvent(\"" + 
										 eventContents[i][6] + "\"); return false;' ></div></div></a>";
					midContent.id = eventContents[i][6];
					
					if (this.myname == eventContents[i][6]) {
						midContents.unshift(midContent);
					} else {
						midContents.push(midContent);
					}
				}
			}
			if (midContents.length > 1) {
				for (var j = 0; j < midContents.length; j++) {
					divMidContent += midContents[j].content;
				}
			} else if (midContents.length == 1) {
				divMidContent = midContents[0].content;
			} else {
				alert("Error. Not found marker");
			}
			var markerContent = "<div id='sidebar' style='height: 170px;'>"
				+ divMidContent
				+"</div>";
			infoWindow.setContent(markerContent);

			infoWindow.open(map, this);
		});
		
		markers.push(markerEvent);
	}
	
	// Create MarkerClusterer by library
	var markerCluster = new MarkerClusterer(map, markers);
}

// when you click a item in mini-list or bookmark, map will change centerMap to this marker (location of event)
function clickme(lat, lng, eId, fromBookMark) {
	var index = $("#ml_"+ eId).attr("index");
	 if (fromBookMark) {
		 index = $("#bm_"+ eId).attr("index");
	 }
	 map.panTo(new google.maps.LatLng(lat, lng));
	 google.maps.event.trigger(gmarkers[index],"click");
}

function changeRankIcon(eventId, rank) {
	for (var i = 0; i < eventContents.length; i++) {
		if (eventContents[i][6] == eventId) {
			var category = eventContents[i][8];
			eventContents[i][7] = rank;
			
			gmarkers[i].setIcon( getMarkerImage(catRank2img(category, rank) ));
		}
	}
}

$(document).ready( function () {
	
	/*
	// get bounds of map
	var bounds = map.getBounds();
	bounds.getSouthWest() = { bounds.ba.b (lat), bounds.fa.b (lng) }
	bounds.getNorthEast() = { bounds.ba.d (lat), bounds.fa.d (lng) }
	bounds:
		contains(latLng:LatLng)	boolean	Returns true if the given lat/lng is in this bounds.
	
	// get mapCenter
	var center = map.getCenter();
	center.jb (lat)
	center.kb (lng)
	
	if you want to know anything, plz come to https://developers.google.com/maps/documentation/javascript/reference#Map
	*/
});