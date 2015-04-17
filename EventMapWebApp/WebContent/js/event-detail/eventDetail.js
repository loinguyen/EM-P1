$(document).ready(function() {
	$('#slide1').prop('checked', true);
	$('#description button').click(function(event){
		event.preventDefault;
		var autoHeight = document.getElementById('full-des').scrollHeight;
		
		if($('#full-des').height() != autoHeight) {
			//$('#white-panel').css('display', 'none');
			$('#full-des').animate({height:autoHeight});
			$(this).html("Thu gọn");
		} else {
			//$('#white-panel').css('display', 'block');
			$('#full-des').animate({height:"300px"});
			$(this).html("Xem thêm");
		}
	});
	if ($("#image-box").length) {
		$("#detail-info").css({"min-height" : "764px"});
	} else {
		$("#detail-info").css({"min-height" : "941px"});
	}
});
$(window).load(function(){
	$("#image-box").mCustomScrollbar({
		horizontalScroll:true,
		scrollButtons:{
			enable:true
		},
		mouseWheelPixels: "333",
		theme:"dark"
	});
	loadHotEvents();
});
function loadHotEvents() {
	var data = getDataForSearchHotEvents();
	callESearchAPI(data, eSearchMode.hot);
}
function getDataForSearchHotEvents() {
	return  data = {
		        query: {
					bool : {					
						must_not : {
							match : {
								deleteFlag: true
							}
						}
					}					
				},
				sort: [{
						rank : "desc"						 
					 }, 
				 {
					 point : "desc"
				}]
			};
}
function builHotEventsList(eList){
	var count = eList.length;
	if (count > 9) count = 9;
	var hotListHtml="";
	for (var i = 0; i < count; i++) {
		var ind = i + 1;
		var event = eList[i]._source;
		var album="";
		if (event.album == "") {
			album = contextPath + "/images/default/cover.jpg";
		} else {
			album = contextPath + "/images/usersImages/" + event.userId + "/" + event.album +"/cover/cover.jpg";
		}
		hotListHtml += "<li><a title='" + event.title + "' href='" + contextPath + "/event/eventDetail?id=" + event._id + "'>"
							+ "<span class='counter'>" + ind + "</span>"
							+ "<img src='" + album + "'/>"
							+ "<span class='title'>" + normalizeTitle(event.title, 52) + "</span>"
							+ "<span class='creator'>" + event.userId + "</span></a></li>";
	}
	$("#hot-event ul").html(hotListHtml);
}