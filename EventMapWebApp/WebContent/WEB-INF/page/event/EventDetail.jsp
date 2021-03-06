<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>${event.title}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta property="og:title" content="${event.title}" />
	<link rel="shortcut icon" href="<%=getServletContext().getContextPath()%>/images/favicon.ico">
	<link href="<%=getServletContext().getContextPath()%>/css/eventDetail.css" rel="stylesheet" type="text/css">
	<link href="<%=getServletContext().getContextPath()%>/css/jquery.mCustomScrollbar.css" rel="stylesheet" type="text/css" />
	<link href="<%=getServletContext().getContextPath()%>/css/reset.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/fancybox/jquery.fancybox.css?v=2.1.5" media="screen" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/fancybox/helpers/jquery.fancybox-buttons.css?v=1.0.5" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/fancybox/helpers/jquery.fancybox-thumbs.css?v=1.0.7" />
	<link href="<%=getServletContext().getContextPath()%>/css/eventDetail/slider/slide.css" rel="stylesheet" type="text/css">
	<script src="http://maps.googleapis.com/maps/api/js?v=3.15&key=AIzaSyCHnyEC72jDRA5AR2FqEzcIgnGi35KkJE4&sensor=true&language=vi&libraries=places"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery-1.7.2.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery.mCustomScrollbar.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/realtime/jquery.atmosphere.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery.mousewheel-3.0.6.pack.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery.fancybox.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/css/fancybox/helpers/jquery.fancybox-buttons.js?v=1.0.5"></script>
	<script src="<%=getServletContext().getContextPath()%>/css/fancybox/helpers/jquery.fancybox-thumbs.js?v=1.0.7"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/event-detail/eventDetail.js"></script>
	<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/tinymce/tinymce.min.js"></script>
	<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/highslide/highslide-full.js" type="text/javascript"></script>
	<link href="<%=getServletContext().getContextPath()%>/js/highslide/highslide.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" charset="utf-8">
	var directionsDisplay;
	var directionsService = new google.maps.DirectionsService();
	var yourLocation;
	var myLatlng;
	var mapRoute;
	var onBookMarkProcess = false;
	var onLikeProcess = false;
	
	hs.graphicsDir = '<%=request.getContextPath()%>/js/highslide/graphics/';
	hs.align = 'center';
	hs.transitions = ['expand', 'crossfade'];
	hs.fadeInOut = true;
	hs.dimmingOpacity = 0.8;
	hs.outlineType = 'rounded-white';
	hs.captionEval = 'this.thumb.alt';
	hs.marginBottom = 105; // make room for the thumbstrip and the controls
	hs.numberPosition = 'caption';

	// Add the slideshow providing the controlbar and the thumbstrip
	hs.addSlideshow({
		//slideshowGroup: 'group1',
		interval: 5000,
		repeat: false,
		useControls: true,
		overlayOptions: {
			className: 'text-controls',
			position: 'bottom center',
			relativeTo: 'viewport',
			offsetY: -60
		},
		thumbstrip: {
			position: 'bottom center',
			mode: 'horizontal',
			relativeTo: 'viewport'
		}
	});
	
	function subscribeEvent() {
		var eventIdVal = $("#event-id").val();
		
		if(userId == "anonymousUser") {
			return toggleLogin();
		} else {
			if (onBookMarkProcess) {
				return
			}
			onBookMarkProcess = true;
				$.ajax ({
					type: "POST",
				    url: "<%=request.getContextPath()%>/event/createBookMark", 
				    data: {eventId: eventIdVal},
				    success: function(data) {
				    	onBookMarkProcess = false;
				    	if(data.actionErrors.length > 0) {
				    		alert (data.actionErrors);
				    	} else {
				    		if($('#btn-bookmark').hasClass('activated')) {
				    			$('#btn-bookmark').removeClass('activated');
				    		} else {
				    			$('#btn-bookmark').addClass('activated');
				    		}
				    	}
		    		}
				});
			}
	}
	
	function deleteEvent() {
		if (confirm('Bạn có chắc chắn muốn xóa sự kiện này?')) {
			var user = '<s:property value="event.userId" />';
			var likeList = new Array();
			var like = '<s:property value="listLike" />';
			var likeList = like.replace("[","").replace("]","");
			var eventIdVal = $("#event-id").val();
			$.ajax ({
				type: "POST",
			    url: "<%=request.getContextPath()%>/event/deleteEvent", 
			    data: {eventId: eventIdVal,
			    		userId: user,
			    		likeValue : likeList
			    	   },
			    success: function(data) {
			    	if(data.actionErrors.length > 0) {
			    		alert (data.actionErrors);
			    	}else {
			    		window.location.replace("<%=request.getContextPath()%>/home");
			    	}
			    }
			});
		}
	}
	function likeEvent() {
		var eventIdVal = $("#event-id").val();		
		if(onLikeProcess) {
			return;
		}
		onLikeProcess = true;
		if (userId != "anonymousUser") {
			$.ajax ({
				type: "POST",
			    url: "<%=request.getContextPath()%>/event/likeEvent", 
			    data: {eventId: eventIdVal
			    	   },
			    success: function(data) {
			    	if(data.actionErrors.length > 0) {
			    		alert (data.actionErrors);
			    	} else {
			    		var noOfLike = data.noOfLike;
			    		$("#no-like").text(noOfLike);
		    			if($('#btn-like').hasClass('activated')) {
		    				$('#btn-like').removeClass('activated');
		    			} else {
		    				$('#btn-like').addClass('activated');
		    			};
			    	}
			    	onLikeProcess = false;
			    }
			});
		} else {
			return toggleLogin();
		}
	}
	
	var eventTitle = '${event.title}';
	$(document).ready(function() {
		buildtinymce();
		function initialize() {
			//initial like and bookmark
			var inLikeList = '<s:property value="inLikeList" />';
			if (inLikeList == 'true') {
				$("#btn-like").addClass('activated');
			}
			var inBookMarkList = '<s:property value="inSubList" />';
			if(inBookMarkList == 'true') {
				$("#btn-bookmark").addClass('activated');
			}
			//initila google
			directionsDisplay = new google.maps.DirectionsRenderer();
			google.maps.visualRefresh = true;
			var location = $("#event-location").val().split(",", 2);
		  	myLatlng = new google.maps.LatLng(parseFloat(location[0]), parseFloat(location[1]));
		  	var mapOptions = {
		    	zoom: 16,
		    	center: myLatlng,
		    	mapTypeId: google.maps.MapTypeId.ROADMAP
		    };
		    var map = new google.maps.Map(document.getElementById('map-box'), mapOptions);
		    mapRoute = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
		
		    directionsDisplay.setMap(mapRoute);
		    directionsDisplay.setPanel(document.getElementById('directions-panel'));
		    
			var marker = new google.maps.Marker({
				position: myLatlng,
				map: map,
				title: eventTitle
			});
			
			// detect your location
			prepareGeolocation();
			doGeolocation();
		}
		
		google.maps.event.addDomListener(window, 'load', initialize);
		
		$('.fancybox').fancybox({
			closeClick : true,
			helpers: {
				title : {
					type : 'outside'
				},
				overlay : {
					speedOut : 0
				},
				thumbs : {
					width  : 50,
					height : 50
				}
			}
		});
		
		$("#btn-report button").click(function(){
			if (userId == 'anonymousUser') {
				return toggleLogin();
			}
			$.fancybox({
	            autoScale: true,
	            transitionIn: 'fade',
	            transitionOut: 'fade',
	        	autoSize:true,
	        	content: $( "#report-form" )
		 	});
		});
		$("#btn-edit").click(gotoEdit);
		
		$('#find-router').fancybox({
			width:1000,
			height:600,
			autoSize:false,
			closeBtn:true,
			content:$('#map-direction'),
			onCleanup:function(){
                $('#map-direction-hider').append($('#map-direction'));
            }
		});
		$('#find-router').click(function() {
			if (yourLocation != undefined || yourLocation != "") {
				var start = yourLocation;
			    var end = myLatlng;
				calcRoute(start, end);
			}
		});
	});
	function gotoEdit() {
<%-- 		$(location).attr('href', '<%=request.getContextPath()%>/event/editEvent?event.id=' + $("#event-id").val()); --%>
		var eId = $("#event-id").val();
	    $('#submitEdtiForm').html('<form action="<%=request.getContextPath()%>/event/editEvent" name="editForm" method="post" style="display:none;"><input type="text" name="event.id" value="'+ eId +'" /></form>');
	    document.forms['editForm'].submit();
	}
	function buildtinymce() {
		tinymce.init({
			mode: "exact",
			menubar:false,
			 plugins: ["emoticons textcolor autolink link image media"
				    ],
		    statusbar: false,
		    elements: "comment-content",
		    toolbar1: "forecolor backcolor emoticons image media",
		});
	}
	function submitReport() {
		if ($("textarea#reportcontent").val() == "") {
			alert('Bạn chưa nhập nội dung báo cáo.');
			$("textarea#reportcontent").focus();
			return;
		}
		$.ajax ({
			type: "POST",
		    url: "<%=request.getContextPath()%>/event/reportEvent", 
		    data: $('#reportFrom').serialize(),
		    success: function(data) {
		    	if (data.event == null) {
		    		alert('Không thể gửi báo cáo!');
		    	} else {
		    		$('.fancybox-close').click();
		    	}
		    }
		});
	}
	
//Build hot List

	function getHotList() {
		$.ajax({
			type: "POST",
		    url: "<%=request.getContextPath()%>/event/hotEvent", 
		    data: {},
		    success: function(data) {
		    	if (data.event == null) {
		    		alert('Không thể gửi báo cáo!');
		    	} else {
		    		$('.fancybox-close').click();
		    	}
		    }
		})
	}
	function buildMiniList(listEventInfo) {
			var divSpanContent="";
			var count = 0; // count for bookMarkList
			var eId;
			for (var i = 0; i < listEventInfo.length; i++) {
				var eventInfo = listEventInfo[i];
				eId = eventInfo.id;
				var divHeader;
				if (eventInfo.album == "") {
					divHeader = "<div id='ml_"+ eId +"' class='item revealUpFull' style='background: url(\"" + contextPath + "/images/default/cover.jpg\") 100%; background-size: cover;'>";
				} else {
					divHeader = "<div id='ml_"+ eId + "' class='item revealUpFull' style='background: url(\"" + contextPath + "/images/usersImages/"+ eventInfo.userId + "/" + eventInfo.album +"/cover.jpg\") 100%; background-size: cover;'>";
				}
				var fromDate = dateToYMD(new Date(eventInfo.fromDate));
				var toDate 	 = dateToYMD(new Date(eventInfo.toDate));
				var divContent = "<span class='info' onclick='clickme("+eventInfo.location.lat+","+eventInfo.location.lon+",\""+eId+"\");'>"
													+"<label class='title' id='et_"+eId+"'><a href='<%=getServletContext().getContextPath()%>/event/eventDetail?id="+ eId +"'>"+eventInfo.title+"</a></label><br /><br />"
				 										+"<label class='time' id='ed_"+eId+"' style='border-top: 1px solid white;' >" + fromDate 
				 																									+"- "+ toDate +"</label><br />"
				     									+"<label class='location'>"+eventInfo.address+"</label>"
				     									+"<span class='category' id='ec_"+eId+"'>"+eventInfo.category+"</span>"
				 										+"</span>"
				 										+"</div>";
			}
	}

	//Build hot List
	</script>
	<script src="<%=getServletContext().getContextPath()%>/js/realtime/comment.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/event-detail/eventDetail-mapDirection.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/event-detail/geometa.js" type="text/javascript"></script>
</head>
<body>
	<div id="header">
		<jsp:include page="/WEB-INF/page/Header.jsp" />
	</div>
	<div id="background-cover" style='background: url("<%=getServletContext().getContextPath()%>/images/default/BackGroup.jpg") 100%; background-size: cover;'></div>
	<!-- #slides -->
	<s:if test="%{event.album != null && event.album != ''}">
			<!-- The Slider -->
			<div id="highslide-gallery">
				<s:iterator value="listImage">
					<a class='highslide' href='<%=getServletContext().getContextPath()%>/images/usersImages/${event.userId}/${event.album}/<s:property />' onclick="return hs.expand(this)">
						<img src="<%=getServletContext().getContextPath()%>/images/usersImages/${event.userId}/${event.album}/<s:property />" alt="${event.title}" />
					</a>
				</s:iterator>
			</div>
	</s:if>
	<!-- #slider -->
	
	<div id="wrapper">
		<div id="left-bar" >
			<div class="content-box" id="detail-info" >
				<div id="title" ><h2><s:property value="event.title" /></h2></div>
				<input type="hidden" name="event.id" id="event-id" value="${event.id}" />
				<input type="hidden" name="event.location" id="event-location" value="${event.location}" />
				<div id="location" >
					<img src="<%=getServletContext().getContextPath()%>/images/eventDetail/pin.png" width="15px">
					<label class="text-std" ><s:property value="event.address" /></label><br />
					<button class="btn-light" id="find-router"><fmt:message key="label.eventDetail.findLocation" /></button>
				</div>
				<div id="time">
					<img src="<%=getServletContext().getContextPath()%>/images/eventDetail/time.png" width="20px">
					<label class="text-std" ><fmt:formatDate value="${event.fromDate}" pattern="dd/MM/yyyy"/>-<fmt:formatDate value="${event.toDate}" pattern="dd/MM/yyyy"/></label>
					<label class="" ><fmt:message key="label.common.category" />: <s:property value="event.category" /></label>
					<label class="" ><fmt:message key="label.event.user" />: <a href="<%=getServletContext().getContextPath()%>/user/userProfile?userId=<s:property value='event.userId' />"><span class="username" ><s:property value="event.userId" /></span></a></label>
				</div>
				<div id="time">
					<label class="" ><fmt:message key="label.common.contact" />: <s:property value="event.contact" /></label>
				</div>
				<div id="btn-area">
					<div>
						<button class="btn-light" onclick="subscribeEvent()" id="btn-bookmark"><fmt:message key="label.eventDetail.bookmark" /></button>
					</div>
					<div>
						<button class="btn-light" onclick="likeEvent()" id="btn-like"><fmt:message key="label.eventDetail.like" /> (<label id="no-like">${noOfLike}</label>)</button>
					</div>
					<s:if test="%{userId == event.userId}">
						<div id="btn-edit">
							<button class="btn-orange"><fmt:message key="label.eventDetail.btn.edit" /></button>
						</div>
					</s:if>
					<sec:authorize ifAnyGranted="ROLE_MOD,ROLE_ADMIN">
						<div id="btn-delete">
							<button class="btn-red" onclick="deleteEvent()"><fmt:message key="label.eventDetail.btn.delete" /></button>
						</div>
					</sec:authorize>
					<%-- <div id="btn-share">
						<button class="btn-light"><fmt:message key="label.eventDetail.share" /></button>
					</div> --%>
					<s:if test="%{userId != event.userId}">
						<div id="btn-report">
							<button class="btn-dark"><fmt:message key="label.eventDetail.report" /></button>
						</div>
					</s:if>
				</div>
				<div id="description">
					<label><fmt:message key="label.eventDetail.fullDes" /></label>
					<div id="full-des">${event.fullDes}</div>
					<button id="view-more"><fmt:message key="label.eventDetail.more" /></button>
				</div>
				<div id="social-area" >
					<div id="post-comment">
					<sec:authorize ifNotGranted="ROLE_ANONYMOUS">
						<div style="width: 70px; float: left;">
							<img class="avatar" src="<%=getServletContext().getContextPath()%>/images/usersImages/${userId}/avatar.jpg" >
							<img class="conversation-point" src="<%=getServletContext().getContextPath()%>/images/eventDetail/point.png" width="10px">
						</div>
						<div style="width: 87%; float: right; margin-right: 5px;">
							<textarea id="comment-content" name="commentContent" placeholder="<fmt:message key="label.eventDetail.post.placeholder" />" ></textarea>
						</div>
							<button id="comment-post" class="btn-light"><fmt:message key="label.eventDetail.post" /></button>
					</sec:authorize>
					<sec:authorize ifAnyGranted="ROLE_ANONYMOUS">
						<div>
							<a href="#" onclick="return toggleLogin();"><fmt:message key="label.eventDetail.login.to.comment" /></a>
						</div>
					</sec:authorize>
					</div>
					<div id="previous-comments">
					<s:iterator value="returnCommentList" var="comment">
						<div class="comment-item" >
							<img class="avatar" src="<%=getServletContext().getContextPath()%>/images/usersImages/${comment.userId}/avatar.jpg" >
							<div class="right-part">
								<a href="<%=getServletContext().getContextPath()%>/user/userProfile?userId=${comment.userId}"><span class="username">${comment.userId}</span></a><label class="comment-time" ><fmt:formatDate value="${comment.createdDate}" pattern="dd/MM/yyyy HH:mm:ss"/></label>
								<br>
								<label class="comment">${comment.content}</label>
								<br>
<!-- 								<a href="#" class="like">Like</a> -->
							</div>
						</div>
					</s:iterator>
					</div>
				</div>
			</div>
		</div>
		<div id="right-bar">
			<div class="content-box" id="map-box"></div>
			<div class="content-box" id="hot-event">
				<h2>BẢNG XẾP HẠNG</h2>
				<ul>
				</ul>
			</div>
		</div>
	</div>
<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=xa-52051fe7188b1957"></script>
<script type="text/javascript">
  addthis.layers({
    'theme' : 'transparent',
    'share' : {
      'position' : 'left',
      'numPreferredServices' : 4,
      'services' : 'facebook,twitter,email,more',
      'postShareTitle' : 'Thanks for sharing!',
      'postShareFollowMsg' : 'Follow us',
      'desktop' : true,
      'mobile' : true,
      'theme' : 'transparent'
    }   
  });
</script>
</body>
<div id="report-form" style="display: none;">
	<s:form name="reportForm" id="reportFrom">
		<s:hidden name="event.id" id="eventId"></s:hidden>
		<div><fmt:message key="label.event.report.details" /></div>
		<div>
			<textarea rows="2" cols="62" name="report.content" id="reportcontent"></textarea>
		</div>
		<div>
			<input class="btn-dark" type="button" value="<fmt:message key="label.event.report.btn.send" />" onclick="submitReport(); return false;"/>
		</div>
	</s:form>
</div>
<div id="submitEdtiForm"></div>
<div id="map-direction-hider" style="position:absolute; top:0; left: -10000px;">
	<div id="map-direction">
		<span>Địa điểm của bạn: </span>
		<input type="text" name="location-search" id="location-search" size="30" />
		<input type="button" id="button-location-search" class="btn-light" name="button-location-search" onclick="codeAddress();" value="Tìm"></input>
		<span id="msg-info"></span>
		<div id="map-canvas" style="width: 650px; height: 500px;"></div>
		<div id="directions-panel"></div>
	</div>
</div>
</html>