<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Bản đồ sự kiện | EventMap</title>
	<meta property="og:title" content="Bản đồ sự kiện | EventMap" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
	<link href="<%=getServletContext().getContextPath()%>/css/homepage.css" rel="stylesheet" type="text/css">
	<link href="<%=getServletContext().getContextPath()%>/css/reset.css" rel="stylesheet" type="text/css">
	<link href="<%=getServletContext().getContextPath()%>/css/jquery.mCustomScrollbar.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/datepicker.css" />
	<link rel="shortcut icon" href="<%=getServletContext().getContextPath()%>/images/favicon.ico">
	
	<script src="<%=getServletContext().getContextPath()%>/js/jquery-1.9.0.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery.mCustomScrollbar.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/realtime/home/jquery.atmosphere.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/common.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/homepage.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/fancybox/jquery.fancybox.css?v=2.1.5" media="screen" />
	<script src="http://maps.googleapis.com/maps/api/js?v=3.15&key=AIzaSyCHnyEC72jDRA5AR2FqEzcIgnGi35KkJE4&sensor=true&language=vi&libraries=places"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/home-gmap.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/gmapLib/markerclusterer.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/gmapLib/markerwithlabel.js"></script>
	<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/datepicker.js"></script>
	<script>
		var map;
		var eventContents = new Array();
		var bookMarkList = new Array();
		var bookMarkEventList = new Array();
		var userId = '<s:property value="userId" />';
		var onTrending= false;
		var onProcess = false;
		var infoWindow;
		var init = false;
		var buildbmgflag = false;
		var fromDate = getFirstTimeOfDate(new Date());
		var toDate = getLastTimeOfDate(new Date());
		var curr = new Date;
		var lastdayOfWeek = new Date(curr.setDate(curr.getDate() - curr.getDay()+7));
		var fromDateValue = fromDate;
		var toDateValue = toDate;
		var datePickerChange=false;
		
		$(document).ready( function () {
			loadNewestEvent();
			 // subscribe update rank when load window
	        subUpdateRank();
	        subTrendingHotEvent();
	        
	        $('#day-select').css('background-image','url(' + contextPath + '/images/dateIcon/DayNote.png)');
		});
		
		function loadNewestEvent(){
			if (filterCat == "all") {
				filterCat == "";
			}
			onTrending = false;
			var todayFirstTime = getFirstTimeOfDate(new Date());
			var data = {					
					query: {
						bool : {
							must :
							[{
								match_phrase : {
									type: "public"
								}
							},
							{
								range : {
									"toDate" : { 
										"from" : todayFirstTime
									}
								}	
							}],
							must_not : {
									match : {
										deleteFlag: true
									}
							}						
						}					
					},
					sort: {
						 createdDate : {order : "desc"} 
					}
				};
			// The same mode with onmap that call BuildMiniList function.
			callESearchAPI(data, eSearchMode.onmap);
			filterCategory(filterCat);
			if(userId != "anonymousUser") {
				if (buildbmgflag) return;
				buildbmgflag = true;
				loadBookmarkList(false);
			}
		}
		
		//function uset to load and build bookMarkList
		function loadBookmarkList (recreate) {
			$.ajax ({
				type: "POST",
			    url: "<%=request.getContextPath()%>/event/loadListBookmark", 
				data: {},
				success: function(data) {
						builBookmarkList(data.listStringNotify,data.listEvent,recreate);
				    }
			});
		}
		
		function shortenEventTitle(title) {
			if(title.length > 20) {
				var shortenTitle = title.substring(0,20) + "...";
				return shortenTitle;
			} else {
				return title;
			}
		}
		//build list bookmark from list StringNotify
		function builBookmarkList(notifyList,eventlist,recreate){
			var notifications = notifyList;
			var divBookmark = "";
			for (var i=0; i < notifications.length; i++) {
				var notification = notifications[i];
				for (var y = 0; y < eventlist.length; y++) {
					var event =  eventlist[y];
					if (notification.eventId == event.id) {
						var fromDate = dateToYMD(new Date(event.fromDate));
						var toDate 	 = dateToYMD(new Date(event.toDate));
						var categoryImage = resolveCategoryImage(event.category);
						var hasNotify = "";
						if (notification.status != "read") {
							hasNotify = " has-notification";
							$("#expand-btn").addClass('new');
						}
						
						var index = $("#ml_"+event.id).attr("index");
						var eventTitle = shortenEventTitle(event.title);
						var newItem = "<div class=\"bookmark-item"+hasNotify+"\" index=\""+index+"\" name=\""+event.location.lat +","+event.location.lon +"\" onclick='clickme("+event.location.lat+","+event.location.lon+",\""+notification.eventId+ "\",true);' id=\"bm_"+notification.eventId+"\" style=\"background:"+categoryImage+";\" >"
			    					  	+"<span class=\"bm-title\" ><a href=\"<%=getServletContext().getContextPath()%>/event/eventDetail?id=" + notification.eventId + "\">"+eventTitle + "</a></span><br/><span>" + fromDate + " - "+ toDate +"</span>";
			    					  	if (notification.status != "read") {
			    					  		newItem +=	"<a class=\"notification-icon\"><img src=\"<%=getServletContext().getContextPath()%>/images/homepage/notification-pop.png\" width=\"25px\" height=\"25px\"></a>";
			    					  	}
			    					  	newItem +="</div>";
			    		divBookmark += newItem;
			    		
			    		//build Notify
			    		if (notification.commentNotify != null || notification.updateNotify !=null) {
			    			buildNotify(notification.commentNotify,notification.updateNotify,notification.eventId);
			    		}
			    		if(recreate != true) {
			    			subEvent(event.id, userId);
			    		}
						break;
					}
				}
			}
			$("#bookmark-bar").html(divBookmark);
			$('.bookmark-item').click(function(){
				$('.bookmark-notification').hide();
				var mtop = $(this).offset().top - 110;
				var mleft = $(this).offset().left;
				$('#noti-'+$(this).attr('id')).css('top',mtop).css('left',mleft).fadeIn(0);
			});
			$('.bookmark-item.has-notification').click(function(){
				var eventIdValue = $(this).attr("id").replace("bm_","");
				$.ajax ({
					type: "POST",
				    url: "<%=request.getContextPath()%>/event/updateBookMark", 
					data: {eventId : eventIdValue},
					success: function(data) {
						var bookMarkId = "#bm_" + eventIdValue;
					    	$(bookMarkId).find('a.notification-icon').fadeOut(250);
					    	$(bookMarkId).removeClass('has-notification');
					    }
				});
			});
			
			$('div').scroll(function(){
				$('.bookmark-notification').fadeOut(250,function(){
					$('.bookmark-notification').css('top',0).css('left',-10000);
				});
			});
			bmScrollbar();
		}
		
		//Remove bookmakr
		function removeBookMark(eventId){
			var bookMarkId = "#bm_"+eventId;
			$(bookMarkId).remove();
		}
		
		//Build Notification for BookMark
		function buildNotify(comment, update,eventId){
			var notifyMarkId = "#noti-bm_"+eventId;
			
	   		var newNotifyDivOpen = "<div class=\"bookmark-notification\" id=\"noti-bm_"+eventId+"\" >";
	   							if(comment != null && comment != "") {
	   								newNotifyDivOpen +="<span><a href='<%=getServletContext().getContextPath()%>/event/eventDetail?id="+eventId+"'>"+comment+"</a></span>";
	   							}
	   							if(update != null && update != "") {
	   								newNotifyDivOpen +="<span><a href='<%=getServletContext().getContextPath()%>/event/eventDetail?id="+eventId+"'>"+update+"</a></span>";
	   							}
	   							newNotifyDivOpen+="</div>";
	   	    $(notifyMarkId).remove();
   			$("#content").append(newNotifyDivOpen);
		}
		
		//function use to update bookMark realtime
		function buildNewBookMarkRealTime(comment,update,eventId) {
			if (userId != "anonymousUser") {
				var bookMarkId = "#bm_"+eventId;
				var bMclass = $(bookMarkId).attr("class");
				var categoryColor = $(bookMarkId).css( "background-color" );
				var bookMarkContent = $(bookMarkId).html();
				var latlonStrg = $(bookMarkId).attr("name");
				var latlonVal = latlonStrg.split(","); 
				var index = $(bookMarkId).attr("index");
				var lat = latlonVal[0];
				var lon = latlonVal[1];
				
				var newBookMarkDiv = "<div class=\"bookmark-item has-notification\" index=\""+index+"\" name=\""+ latlonStrg +"\" onclick='clickme("+lat+","+lon+",\""+eventId+ "\",true);' id=\"bm_"+eventId+"\" style=\"background:"+categoryColor+";\" >"
									+ bookMarkContent;
									if (bMclass != "bookmark-item has-notification") {
										newBookMarkDiv	+= "<a class=\"notification-icon\"><img src=\"<%=getServletContext().getContextPath()%>/images/homepage/notification-pop.png\" width=\"25px\" height=\"25px\"></a>";
									}
									newBookMarkDiv += "</div>";
									
				removeBookMark(eventId);
				var bookMarkDiv = $("#bookmark-bar").html();
			    var newBookMarkDiv = newBookMarkDiv + bookMarkDiv;
			    $("#bookmark-bar").html(newBookMarkDiv);
			    bmScrollbar();
			    
			    //build Notify
			    buildNotify(comment, update, eventId);
			    
			    //Add listen event
			  $('.bookmark-item').click(function(){
				$('.bookmark-notification').hide();
				var mtop = $(this).offset().top - 110;
				var mleft = $(this).offset().left;
				$('#noti-'+$(this).attr('id')).css('top',mtop).css('left',mleft).fadeIn(250);
				$(this).find('a.notification-icon').fadeOut(250);
			 });
			$('.bookmark-item.has-notification').click(function(){
				var eventIdValue = $(this).attr("id").replace("bm_","");
				$.ajax ({
					type: "POST",
				    url: "<%=request.getContextPath()%>/event/updateBookMark", 
					data: {eventId : eventIdValue},
					success: function(data) {
						var bookMarkId = "#bm_" + eventIdValue;
					    	$(bookMarkId).find('a.notification-icon').fadeOut(250);
					    	$(bookMarkId).removeClass('has-notification');
					    }
				});
			});
			$('div').scroll(function(){
				$('.bookmark-notification').fadeOut(250,function(){
					$('.bookmark-notification').css('top',0).css('left',-10000);
				});
			});
				$("#expand-btn").addClass('new');
			}
		}
		//BUILD BOOK MARK END
		
		//BUILD MINI LIST ON LOADING
		function buildMiniList(listEventInfo) {
			buildMiniList(listEventInfo, false);
		}
		
		function buildMiniList(listEventInfo, eSearch) {
			buildMiniList(listEventInfo,eSearch,false);
		}
		function buildMiniList(listEventInfo, eSearch, trendingTab) {
			if (!init & !trendingTab) {
				eventContents = new Array();
			}
			
			if(trendingTab == undefined) {
				$("#sidebar").html("");
			} else {
				$("#trendingResever").html("");
			}
	
			var divSpanContent="";
			var count = 0; // count for bookMarkList
			var eId;
			for (var i = 0; i < listEventInfo.length; i++) {
				var eventInfo = listEventInfo[i];
				var index = -1;
				eId = eventInfo.id;
				if (eSearch) {
					eventInfo = eventInfo._source;
					eId = eventInfo._id;
				}
				var divHeader;
				
				if(trendingTab == undefined) {
					for (var j = 0; j < eventContents.length; j++) {
						if (eId == eventContents[j][6]) {
							index = j;
							break;
						}
					}
					
					if (eventInfo.album == "") {
						divHeader = "<div id='ml_"+ eId + "' class='item revealUpFull' style='background: url(\"" + contextPath + "/images/default/cover.jpg\") 100%; background-size: cover;'>";
					} else {
						divHeader = "<div id='ml_"+ eId + "' class='item revealUpFull' style='background: url(\"" + contextPath + "/images/usersImages/"+ eventInfo.userId + "/" + eventInfo.album +"/cover/cover.jpg\") 100%; background-size: cover;'>";
					}					
				} else {
					
					for (var j = 0; j < eventContents.length; j++) {
						if (eId == eventContents[j][6]) {
							index = j;
							break;
						}
					}
					if (eventInfo.album == "") {
						divHeader = "<div id='ml_"+ eId + "' index='"+ index +"' category='"+ eventInfo.category + "' class='item revealUpFull' style='background: url(\"" + contextPath + "/images/default/cover.jpg\") 100%; background-size: cover;'>";
					} else {
						divHeader = "<div id='ml_"+ eId + "' index='"+ index +"' category='"+ eventInfo.category + "' class='item revealUpFull' style='background: url(\"" + contextPath + "/images/usersImages/"+ eventInfo.userId + "/" + eventInfo.album +"/cover/cover.jpg\") 100%; background-size: cover;'>";
					}
				}
				
				var fromDate = dateToYMD(new Date(eventInfo.fromDate));
				var toDate 	 = dateToYMD(new Date(eventInfo.toDate));
				var divContent = "<span class='info' onclick='clickme("+eventInfo.location.lat+","+eventInfo.location.lon+",\""+eId+"\");'>"
									+"<label class='title' id='et_"+eId+"'><a href='<%=getServletContext().getContextPath()%>/event/eventDetail?id="+ eId +"'>"+ normalizeTitle(eventInfo.title, 74)+"</a></label><br /><br />"
										+"<label class='time' id='ed_"+eId+"' style='border-top: 1px solid white;' >" + fromDate 
																									+"- "+ toDate +"</label><br />"
    									+"<label class='location'>"+eventInfo.address+"</label>"
    									+"<span class='category' id='ec_"+eId+"'>"+eventInfo.category+"</span>"
										+"</span>";
				var bookMarkClickedValue = "sub-unclicked";
					
				if ($.inArray(userId, eventInfo.subscribers) > -1) {
					bookMarkClickedValue = "sub-clicked";
					bookMarkEventList[count] = eventInfo;
					count++;
					
				} else {
					bookMarkClickedValue = "sub-unclicked";
				}
				var divClose = "<div class='sub-btn "+ bookMarkClickedValue +" "+ eId +"' eid='"+eId+"' onclick='subcribeEvent(\""+ eId + "\");' ></div>"
								+"</div>";
				var spanContent = divHeader + divContent + divClose;
				divSpanContent = spanContent;
				
				//build google information
				var eventData =new Array();
				var numLon = parseFloat(eventInfo.location.lon);
				var numLat = parseFloat(eventInfo.location.lat);
				eventData[0] = numLon.toFixed(6);
				eventData[1] = numLat.toFixed(6);
				
				//check image 
				if( eventInfo.album  == "") {
					eventData[2] = "images/default/cover.jpg";//default cover
				} else {
					eventData[2] = "images/usersImages/" + eventInfo.userId + "/" + eventInfo.album + "/cover/cover.jpg";
				}
				eventData[3] = eventInfo.title;
				eventData[4] = fromDate + " - " +toDate;
				eventData[5] = eventInfo.address;
				eventData[6] = eId;
				eventData[7] = eventInfo.rank;
				eventData[8] = eventInfo.category;
				eventData[9] = bookMarkClickedValue;
				if (!init & !trendingTab) {
					eventContents[i] = eventData;
				}
				if (eSearch) {
					for (var k = 0; k < eventContents.length; k++) {
						if (eId == eventContents[k][6]) {
							index = k;
							break;
						}
					}
					
					// if have new event which wasn't in eventContents
					// add it to eventContents, create marker for it
					if (index == -1) {
						index = eventContents.length;
						eventContents[index] = eventData;
						
						// create marker
						var markerEvent = new google.maps.Marker({
							map: map,
							title: eventData[3],
							icon: getMarkerImage(catRank2img(eventData[8], eventData[7])),
					        shadow: iconShadow,
							position: new google.maps.LatLng(eventData[1], eventData[0])
						});
						
						markerEvent.mycategory = eventData[8];                                 
						markerEvent.myname = eventData[6];
				        gmarkers.push(markerEvent);
				        
				     	// find marker and create infoWindow for it
						google.maps.event.addListener(markerEvent, 'click', function () {
							var latLng = this.getPosition();
							
							var midContent="";
							for (var m = 0; m < eventContents.length; m++) {
								if (eventContents[m][1] == latLng.lat().toFixed(6) && eventContents[m][0] == latLng.lng().toFixed(6)) {
									//break;
									midContent += "<a href='"+ contextPath +"/event/eventDetail?id="+  eventContents[m][6] +"'><div class='item revealUpFull'  id='ml_"+ eventContents[m][6] +"' style='background: url(\"" + eventContents[m][2] + "\") 100%; background-size: cover;'><span class='info'><label class='title'>" + normalizeTitle(eventContents[m][3], 80) + "</label><br /><br /><label class='time' style='border-top: 1px solid white;'>" + eventContents[m][4] + "</label><span class='category inforwindow' id='ec_"+ eventContents[m][6] +"'>"+ eventContents[m][8] +"</span>"+"<br /><label class='location'>" + eventContents[m][5] + "</label></span><div class='sub-btn " + eventContents[m][9] + " " + eventContents[m][6] +"' eid='" + eventContents[m][6] + "' id='item" + m + "_sub' onclick='subcribeEvent(\"" + eventContents[m][6] + "\"); reuturn false;' ></div></div></a>";
								}
							}
							var markerContent = "<div id='sidebar' style='height: 170px;'>"
								+ midContent
								+"</div>";
							infoWindow.setContent(markerContent);

							infoWindow.open(map, this);
						});
					}
					$("#sidebar").append(divSpanContent);
					$("#ml_"+ eId).attr("index", index);
			        $("#ml_"+ eId).attr("category", eventInfo.category);
				} else {
					if(trendingTab == undefined) {
						$("#sidebar").append(divSpanContent);
						$("#ml_"+ eId).attr("index", index);
				        $("#ml_"+ eId).attr("category", eventInfo.category);
					} else {
						$("#trendingResever").append(divSpanContent);
					}
				}
					/*var exist = false;
					for (var i = 0; i < eventContents.length; i++) {
						if (eventInfo.id == eventContents[i][6]) {
							exist = true;
							break;
						}
					}
					if (!exist) {
						events
					}*/
			}
			if (trendingTab == true) {
				//$("#trendingResever").html(divSpanContent);					
			} else {		
		    	miniListScroll();
		    	if (!init) {
		    		initGmap();
		    		init = true;
		    	}
		    	
			}
// 				return divSpanContent;
		}
			
			var socket = $.atmosphere;
	        var subSocket;
	        var hostRealtime = document.location.protocol + "//" + document.location.host + "/EMCometServer/";
	
	        /* subscribe trending hot event */
	        function updateTrending() {
	        		$("#sidebar").html($("#trendingResever").html());
	        		onTrending = true;
	        		 $('#sidebar').mCustomScrollbar("destroy");
                     miniListScroll();
	        }
	        function subTrendingHotEvent() {
	        	var request = {
	            		url : hostRealtime + 'event/trendinghot/home-trendinghot-event-5791',
	            		contentType : "text/html;charset=UTF-8",
	            		transport: 'long-polling',
	            		fallbackTransport: 'streaming'};
	            
	            request.onMessage = function (response) {
	                detectedTransport = response.transport;
	                if (response.status == 200) {
	                    var data = response.responseBody;
	
	                    try {
	                        var result = $.parseJSON(data);
	                        buildMiniList(result,false,true);
	                        if (onTrending == true) {
	                        	$("#sidebar").html($("#trendingResever").html());
	                        }
	                        if ($("#hot").attr('class') == 'active') {
		                        $('#sidebar').mCustomScrollbar("destroy");
		                        miniListScroll();
	                   		 }
	                        //if (result.eventId != "" & result.rank != "") {
	                        	
	                        //}
	
	                    } catch (err) {
	                        
	                    }
	                }
	            };
	
	            subSocket = socket.subscribe(request);
	        }
	        
	        /* subscirbe update rank event */
	        function subUpdateRank() {
	        	var request = {
	            		url : hostRealtime + 'updateRank/home-update-rank-5791',
	            		contentType : "text/html;charset=UTF-8",
	            		transport: 'long-polling',
	            		fallbackTransport: 'streaming'};
	            
	            request.onMessage = function (response) {
	                detectedTransport = response.transport;
	                if (response.status == 200) {
	                    var data = response.responseBody;
	
	                    try {
	                        var result = $.parseJSON(data);
	                        if (result.eventId != "" & result.rank != "") {
	                        	changeRankIcon(result.eventId, result.rank);
	                        }
	
	                    } catch (err) {
	                        
	                    }
	                }
	            };
	
	            subSocket = socket.subscribe(request);
	        }
	        
	        /* subscribe event */
	        function subEvent(eventId, userId) {
	        	var request = { 
	            		url : hostRealtime + 'notify/' + userId + "-" + eventId,
	            		contentType : "text/html;charset=UTF-8",
	            		transport: 'long-polling',
	            		fallbackTransport: 'streaming'};
	            
	            request.onMessage = function (response) {
	                detectedTransport = response.transport;
	                if (response.status == 200) {
	                    var data = response.responseBody;
	
	                    try {
	                        var result = $.parseJSON(data);
	                        if (result.notifyComment != "" || result.notifyUpdate != "") {
	                        	buildNewBookMarkRealTime(result.notifyComment, result.notifyUpdate, result.eventId);
	                        }
	
	                    } catch (err) {
	                        
	                    }
	                }
	            };
	
	            subSocket = socket.subscribe(request);
	        }
	
	        function unsubEvent(url){
	            socket.unsubscribeUrl(url);
	        }
	        
			function subcribeEvent(eid){
				if(userId == "anonymousUser") {
					return toggleLogin();
				} else {
					if (onProcess) {
						return;
					}
					onProcess = true;

						$.ajax ({
							type: "POST",
						    url: "<%=request.getContextPath()%>/event/createBookMark", 
					    data: {eventId: eid
					    	   },
					    success: function(data) {
					    	subcribe(eid);
				    		loadBookmarkList(true);
					    	if(data.notification.status == "deleted") {
					    		unsubEvent(hostRealtime + 'notify/' + userId + "-" + eid);
					    		for (var i = 0 ; i < eventContents.length; i++){
					    			if(eid == eventContents[i][6]) {
					    				eventContents[i][9] = "sub-unclicked";
					    			}
					    		}
					    	} else {
					    		subEvent(eid, userId);
					    		for (var i = 0 ; i < eventContents.length; i++){
					    			if(eid == eventContents[i][6]) {
					    				eventContents[i][9] = "sub-clicked";
					    			}
					    		}
					    	}
// 						    	unsubEvent(hostRealtime + 'notify/' + user + "-" + $(e).attr('id'));
// 						    	subEvent($(e).attr('id'), user);
					    	    onProcess = false;
					    }
					});
			}
			
		}

			function resolveCategoryImage(category) {
				var colorValue;
				
				switch(category.toLowerCase()) {
					case music:
						colorValue = "#a84c54";
						break;
					case fair:
						colorValue = "#654571";
						break;
					case sport:
						colorValue = "#325665";
						break;
					case art:
						colorValue = "#81a858";
						break;
					case offline:
						colorValue = "#de8925";
						break;
					case saleoff:
						colorValue = "#0f6a53";
						break;
					case other:
						colorValue = "#363636";
						break;
					case film:
						colorValue = "#54301a";
						break;
				}
				return colorValue;
			}
			
	</script>
</head>
<body>
<div class id="full-page">
	<div id="header">
		<jsp:include page="Header.jsp" />
	</div>
    <div id="content">
    	<div id="wrapper" >
	    	<div class="searchbox" id="search-box">
				<input class="searchbox" id="search-input" type="text" placeholder="Tìm kiếm..." style="width:103%;" >

    			<div id="category-selector">
    				<span>Lọc sự kiện theo thể loại</span>
    				<a id="all" class="category-select" onclick="filterCategory(this.id);">
    					<img alt="Tất cả" src="<%=getServletContext().getContextPath()%>/images/categoryIcon/all.png">
    					<label>Tất cả</label>
    				</a>
    				<a id="music" class="category-select" onclick="filterCategory(this.id);">
    					<img alt="Âm nhạc" src="<%=getServletContext().getContextPath()%>/images/categoryIcon/music.png">
    					<label>Âm nhạc</label>
    				</a>
    				<a id="fair" class="category-select" onclick="filterCategory(this.id);">
    					<img alt="Hội thảo" src="<%=getServletContext().getContextPath()%>/images/categoryIcon/fair.png">
    					<label>Hội thảo</label>
    				</a>
    				<a id="sport" class="category-select" onclick="filterCategory(this.id);">
    					<img alt="Thể thao" src="<%=getServletContext().getContextPath()%>/images/categoryIcon/sport.png">
    					<label>Thể thao</label>
    				</a>
    				<a id="art" class="category-select" onclick="filterCategory(this.id);">
    					<img alt="Nghệ thuật" src="<%=getServletContext().getContextPath()%>/images/categoryIcon/art.png">
    					<label>Nghệ thuật</label>
    				</a>
    				<a id="film" class="category-select" onclick="filterCategory(this.id);">
    					<img alt="Điện ảnh" src="<%=getServletContext().getContextPath()%>/images/categoryIcon/film.png">
    					<label>Điện ảnh</label>
    				</a>
    				<a id="saleoff" class="category-select" onclick="filterCategory(this.id);">
    					<img alt="Khuyến mại" src="<%=getServletContext().getContextPath()%>/images/categoryIcon/saleoff.png">
    					<label>Khuyến mại</label>
    				</a>
    				<a id="offline" class="category-select" onclick="filterCategory(this.id);">
    					<img alt="Họp mặt" src="<%=getServletContext().getContextPath()%>/images/categoryIcon/offline.png">
    					<label>Họp mặt</label>
    				</a>
    				<a id="other" class="category-select" onclick="filterCategory(this.id);">
    					<img alt="Khác" src="<%=getServletContext().getContextPath()%>/images/categoryIcon/other.png">
    					<label>Khác</label>
    				</a>
    			</div>
				<div class="searchbox" id="search-result" ></div>
			</div>
	    	<div id="sidebar">
<%-- 			    		<s:iterator value="listEvent" var="event"> --%>
<%-- 			    		<s:if test='%{#event.album != "" }'><c:set var="album" value="/images/${event.album}/cover/cover.jpg"/></s:if> --%>
<%-- 			    		<s:if test='%{#event.album == "" }'><c:set var="album" value="/images/default/cover.jpg"/></s:if> --%>
<%-- 				    		<div class="item revealUpFull" style="background: url('<%=getServletContext().getContextPath()%>${album}') 100%; background-size: cover;"> --%>
<%-- 								<span class="info" onclick="clickme(${event.location.lon},${event.location.lat});"> --%>
<%-- 									<label class="title" >${event.title}</label><br /><br /> --%>
<%-- 									<input type="hidden" id="long" value="${event.location.lon}"> --%>
<%-- 									<input type="hidden" id="lat" value="${event.location.lat}"> --%>
<%-- 									<label class="time" style="border-top: 1px solid white;" ><fmt:formatDate value="${event.fromDate}" pattern="dd/MM/yyyy"/>  --%>
<%-- 																							- <fmt:formatDate value="${event.toDate}" pattern="dd/MM/yyyy"/></label><br /> --%>
<%-- 				    				<label class="location">${event.address}</label> --%>
<%-- 								</span> --%>
<!-- 								<div class="sub-btn sub-unclicked" id="item1_sub" onclick="subcribe(this);" ></div> -->
<!-- 							</div> -->
<%-- 						</s:iterator> --%>
	    	</div>
	    	<div class="minilist-btn" >
	    		<div id="hot" onclick="updateTrending()""><span>Nổi Bật</span></div>
	    		<div id="onmap" ><span>Bản Đồ</span></div>
	    		<div class="active" id="newest" onclick="loadNewestEvent()"><span>Mới Nhất</span></div>
	    	</div>
    	</div>
    	<div id="expander">
    		<div id="category-expander"></div>
    		<div id="date-expander"></div>
    	</div>
    	<div id="date-selector">
    		<span id="select-title">Lọc: </span>
	    	<a id="day-select" class="date-select" onclick="">
	    			<c:set var="now" value="<%=new java.util.Date()%>" />
	    			<span style="text-align:center" id='date-month'><fmt:formatDate type="date" pattern="MMM" value="${now}"/></span>
	    			<span style="text-align:center" id='date-day'><fmt:formatDate type="date" pattern="dd" value="${now}"/></span>
	    	</a>
    		<a id="week" class="date-select" onclick="">
    		<img alt="week" style="width: 54px;height: 65px" src="<%=getServletContext().getContextPath()%>/images/dateIcon/WeekNote.png">
<%--     			<span class="type-selector" style="text-aligh:center" id='type-selector'>Tuần này</span> --%>
    		</a>
    		<a id="custom" class="date-select" onclick="">
    		<img alt="custom" style="width: 54px;height: 65px" src="<%=getServletContext().getContextPath()%>/images/dateIcon/CustomNote.png">
    		</a>
    	</div>
    	<div id="custom-date-selector">
    		<a href="#" class="btn small" id="dp4" data-date-format="dd/mm">
	 			<div id="custom-date-select">
		 			Từ<br />
		 			<span id="startDate"></span>
	 			</div>
	 		</a>
	 		<a href="#" class="btn small" id="dp5" data-date-format="dd/mm">
	 			<div id="custom-date-select">
					Đến<br />
					<span id="endDate"></span>
				</div>
			</a>
    	</div>
    	<sec:authorize ifNotGranted="ROLE_ANONYMOUS">
    	<div id="bookmark-bar" >
    	</div>
    	</sec:authorize>
   		<div class="bookmark-notification" id="noti-bm1" >
   			<a href="">Sự kiện này có cập nhật mới, hãy click vào đây để xem thông tin chi tiết</a>
   		</div>
   		<sec:authorize ifNotGranted="ROLE_ANONYMOUS" >
		<div id="expand-btn" class="collapsed" title='<s:text name="label.bookmark.btn.desc"></s:text>' ><label>&raquo </label></div>
		</sec:authorize>
    	<div id="wrapper-rpl" ></div>
    	<div id="colapse-btn" title='<s:text name="label.minilist.desc"></s:text>' ><label></label></div>
        <div id="map-canvas" class="map-area"></div>
        <div id="trendingResever" style="display:none" >
        </div>
    </div>
</div>
</body>
</html>