<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Bản đồ sự kiện | EventMap</title>
	<meta property="og:title" content="Bản đồ sự kiện | EventMap" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
	<link rel="shortcut icon" href="<%=getServletContext().getContextPath()%>/images/favicon.ico">
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/jquery-ui.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/createEvent.css" />
	<link rel="stylesheet" href="<%=getServletContext().getContextPath()%>/css/dropzone/general.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/datepicker.css" />
	<link rel="stylesheet" href="<%=getServletContext().getContextPath()%>/css/reset.css" media="screen">
	<link href="<%=getServletContext().getContextPath()%>/css/jquery.mCustomScrollbar.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/fancybox/jquery.fancybox.css?v=2.1.5" media="screen" />
	
	<script src="http://maps.googleapis.com/maps/api/js?v=3.15&key=AIzaSyCHnyEC72jDRA5AR2FqEzcIgnGi35KkJE4&sensor=true&language=vi&libraries=places"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery-2.0.2.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery.mCustomScrollbar.js"></script>
	<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/jquery-ui.js"></script>
	<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/datepicker.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/dropzone/build.js"></script>
	<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/createEvent.js"></script>
	<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/tinymce/tinymce.min.js"></script>
	<script>
// 	var confirmOnPageExit = function (e) 
// 	{
// 	    // If we haven't been passed the event get the window.event
// 	    e = e || window.event;
		
// 	    var message = 'Any text will block the navigation and display a prompt';

// 	    // For IE6-8 and Firefox prior to version 4
// 	    if (e) 
// 	    {
// 	        e.returnValue = message;
// 	    }
	 
// 	    e = confirm("12345");
	    
// 	    // For Chrome, Safari, IE8+ and Opera 12+
// 	    return message;
// 	};
	
// 	window.onbeforeunload = confirmOnPageExit;
	
	var contextPath = "<%=getServletContext().getContextPath()%>";
	var mod = '<s:property value="mod"/>';
	
	require("boot");
	$(function() {
		
	});

	// update position
	function updateMarkerPosition(latLng) {
		var pos = [
			latLng.lat(),
			latLng.lng()
		].join(', ');
		$('#geolocation').val(pos);
	}

	function codeAddress() {
		var address = $('#event-address').val();
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
				markerCreateEvent.setPosition(results[0].geometry.location);
				map.setCenter(results[0].geometry.location);
				getMakerLocation(results[0].geometry.location);
				$("#address-error").text("");
			} else {
				if(status=='ZERO_RESULTS') {
					$("#address-error").text("*Địa chỉ không tồn tại");
					return;
				}
				alert('Geocode was not successful for the following reason: ' + status);
			}
		});
	}
	
	google.maps.visualRefresh = true;
	var map;
	var markerCreateEvent;
	var onMarkerClick;
	var myCenter = new google.maps.LatLng(21.028676,105.848786);
	var lat = '<s:property value = "event.location.lat"/>';
	var lon = '<s:property value = "event.location.lon"/>';
	var googleLocation = new google.maps.LatLng(lat, lon);
	
	// initialize
	google.maps.event.addDomListener(window, 'load', function() {
		map = new google.maps.Map(document.getElementById('mapCanvas'), {
			zoom: 16,
			center: myCenter,
			disableDoubleClickZoom: true,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		});

		var infoWindow = new google.maps.InfoWindow;

		google.maps.event.addListener(map, 'click', function() {
			infoWindow.close();
		});
		
		// double click to create event
		markerCreateEvent = new google.maps.Marker({
			map: map,
			draggable: true,
			visible: true
		});
		
		if (mod == 'edit') {
			markerCreateEvent.setPosition(googleLocation);
			map.setCenter(googleLocation);
		}
		
		google.maps.event.addListener(map, 'dblclick', function(event) {
			markerCreateEvent.setPosition(event.latLng);
			updateMarkerPosition(markerCreateEvent.getPosition());
		});
		
		google.maps.event.addListener(markerCreateEvent, 'dragend', function() {
			updateMarkerPosition(markerCreateEvent.getPosition());
		});
		
		google.maps.event.addListener(markerCreateEvent, 'drag', function() {
			updateMarkerPosition(markerCreateEvent.getPosition());
		});
		
	});
	
	function getMakerLocation(latLng) {
		var pos = [
			latLng.lat(),
			latLng.lng()
		].join(', ');
		$('#geolocation').val(pos);
	}
	
	function removeImage(image,albumImage, obj) {
		$(obj).css({"background-color":"white"});
		$(obj).next().show();
		$.ajax ({
			type: "POST",
		    url: "<%=request.getContextPath()%>/removeFile", 
		    data: {fileFileName: image, album: albumImage, updateEvent: true },
		    success: function(data) {
		    	if (data.actionErrors.length > 0) {
		    	}
		    	$(obj).prev().hide();
		    	$(obj).hide();
				$(obj).next().hide();
		    }
		});
	}
	
	function openAlbum() {
		$('#updateEvent').prop('checked', true);
		$.fancybox({
// 	        width: '30%',
// 	        height: '60%',
	        autoScale: true,
	        transitionIn: 'fade',
	        transitionOut: 'fade',
	    	autoSize:true,
	    	content: $( "#album-popup" )
	 	});
	}
	</script>
</head>
<body>
	<div id="header">
		<jsp:include page="/WEB-INF/page/Header.jsp" />
	</div>
	<form name="demoform" id="eventDetailsForm">
		<s:hidden name="event.id"/>
		<s:hidden name="event.createdDate"/>
		<s:hidden name="event.rank"/>
		<s:hidden name="event.point"/>
		<s:hidden name="event.tag"/>
		<s:hidden name="event.userId"/>
		<s:hidden name="event.album" id="eventAlbum"/>
		<div id="wrapper">
				
			<h2>
				<s:if test="%{mod == 'create'}">
					<fmt:message key='label.create.event.create.new' />
				</s:if>
				<s:if test="%{mod == 'edit'}">
					<fmt:message key='label.create.event.update.event' />
				</s:if>
			</h2>
			<table id="event-info">
				<tbody>
					<tr>
						<th><label for="event-title" >Tên sự kiện<span class="required">*</span>:</label></th>
						<td><input type="text" id="event-title" name="event.title" class="searchbox" value='<s:property value="event.title"/>'/></td>
					</tr>
					<tr>
						<td></td>
						<td>
							<div id="related-event-suggest"></div>
						</td>
					</tr>
					<tr>
						<th><label>Thời gian<span class="required">*</span>:</label></th>
						<td id="date-from-to">
							<input id="dateFrom" class="span2" size="16" type="text" data-date-format="dd-mm-yyyy" readonly>
							<input id="eventFromDate" type="hidden" name="event.fromDate" value='<s:date name="event.fromDate" format="dd-MM-yyyy"/>' />
							<b>-</b>
							<input id="dateTo" class="span2" size="16" type="text" data-date-format="dd-mm-yyyy" readonly>
							<input id="eventToDate" type="hidden" name="event.toDate" value='<s:date name="event.toDate" format="dd-MM-yyyy"/>' />
						</td>
					</tr>
					<tr>
						<th><label for="event-address" >Địa điểm<span class="required">*</span>:</label></th>
						<td>
							<input id="event-address" name="event.address" onblur="codeAddress()" placeholder="VD: Đại học FPT, số 8 Tôn Thất Thuyết" value='<s:property value="event.address"/>'></input>
							<input type="hidden" id="geolocation" name="location" value='<s:property value="location"/>'/>
							<label id="address-error" class="register-err"></label>
						</td>
						
					</tr>
					<tr>
						<th><label for="event-contact" >Liên hệ<span class="required">*</span>:</label></th>
						<td>
							<input id="event-contact" name="event.contact" placeholder="VD: Số ĐT, địa chỉ email, đỉa chỉ web..." value='<s:property value="event.contact"/>'></input>
						</td>	
					</tr>
					    <s:select name="event.category" list="listCategory" listKey="value" listValue="description" label="Thể loại" required="true"/>
						<s:select name="event.type" list="listType" listKey="value" listValue="description" label="Chế độ bảo mật" required="true"/>
					<tr>
						<th id="image-upload"><label>Đăng ảnh sự kiện:</label></th>
						<td>
						<s:set name="mod" value="mod"/>
						<s:if test="%{#mod == 'create'}">
							<div id="dropzone">
								<span></span>
							</div>
						</s:if>
						<s:if test="%{#mod == 'edit'}">
							<input type="button" class="btn-light" onclick="openAlbum()" value="Hiển thị album ảnh"/>
							<s:hidden value="listImage"/>
						</s:if>
						</td>
					</tr>
					<tr>
						<td>
							<s:textarea rows="12" cols="100" name="event.fullDes" id="full-des" label="Thông tin chi tiết" />
						</td>
					</tr>
				</tbody>
			</table>
			<div id="noti-area" class="register-err" style="margin-left: 150px;"></div>
			<div id="btn-area">
				<s:if test="%{#mod == 'edit'}">
					<input type="button" class="btn-light" value="<fmt:message key="label.common.save"/>" onclick="updateEvent()" />
				</s:if> <s:else>
					<input type="button" class="btn-light" value="<fmt:message key="label.create.event.btn.add"/>" onclick="saveEvent()" />
				</s:else>
				<a href="<%=getServletContext().getContextPath()%>"><input type="button" class="btn-dark" value="<fmt:message key="label.common.cancel"/>"/></a>
				<br />
				<img id="returnPic" width="250px" />
			</div>
			<div id="event-loading" class="loadingImg" style="display: none"></div>
			<div id="mapCanvas" class="mapArea"></div>
		</div>
	</form>
	<img src="<%=getServletContext().getContextPath()%>/images/ok.jpg" style="display: none;"/>
	<img src="<%=getServletContext().getContextPath()%>/images/notOk.jpg" style="display: none;"/>
	<form action="<%=getServletContext().getContextPath()%>/upload" class="dropzone dz-clickable" id="demo-upload">
		<input type="hidden" name="album" id="album" value="<s:property value="event.album"/>"/>
		<s:checkbox name="updateEvent"></s:checkbox>
		<s:checkbox name="coverPicture" value="true"></s:checkbox>
		<div class="dz-default dz-message">
		</div>
	</form>
	<div id="album-popup" style="display: none;">
		<div id="image-area">
			<s:iterator value="listImage">
				<img src="<%=getServletContext().getContextPath()%>/images/usersImages/<s:property value="event.userId"/>/<s:property value="event.album"/>/<s:property />">
				<a href="#" onclick="removeImage('<s:property />', '<s:property value="event.album"/>', this); return false;">Xóa</a>
				<span class="loadingImg" style="display: none;"></span>
			</s:iterator>
		</div>
		<div id="dropzone">
			<span></span>
		</div>
	</div>
</body>
</html>