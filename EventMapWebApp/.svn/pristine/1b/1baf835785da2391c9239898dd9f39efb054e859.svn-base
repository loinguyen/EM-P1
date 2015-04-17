// Page easing
$(function() {
	$('#nav ul a').bind('click',function(event){
		var $anchor = $(this);
		
		$('html, body').stop().animate({
			scrollTop: $($anchor.attr('href')).offset().top
		}, 1500, 'easeInOutExpo');
		
		event.preventDefault();
	});
});
var category;
var $node;

$(document).ready(function() {	
		
	$("#nav ul li a").click(function(){	
		if($(this).attr('class') != 'active'){
			$("#loadingImg").show();
			$('#nav ul a').removeClass('active');
			$(this).addClass('active');
		
			category = $(this).attr("category");
			$node = $(this);
			var data = {					
				query: {
					bool : {
						must : [{
							match : {
									category: category
								}
						},	
						{
							match : {
								type: "public"
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
			
			$.ajax({
				url: eSearchUri + ':9200/eventmap/_search?search_type=query_and_fetch',
				type: 'POST',
				contentType: 'application/json; charset=UTF-8',
				crossDomain: true,
				dataType: 'json',
				data: JSON.stringify(data),							
				success: function(response) {
					buildListEvents(response.hits.hits);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					var jso = jQuery.parseJSON(jqXHR.responseText);
					alert('(' + jqXHR.status + ') ' + errorThrown + ' --<br />' + jso.error);
				}
			});		
		};
	});
	$(".container").hide();
	$("#loadingImg").hide();
	$('#nav ul li a').first().click();
});

function buildListEvents(eList) {
	var htmlCat; 
	if (eList.length == 0) {
		htmlCat = "<div class='no-event'>Chưa có sự kiện.</div>";						
	} else {
		htmlCat = "<div id='search-box'><input id='search-input' type='text' placeholder='Tìm kiếm...'></div>";
		htmlCat += "<section><ul class='da-thumbs'>";
		for (var i = 0; i < eList.length; i++) {
			var event = eList[i]._source;
			var cover = "";
			if (event.album == "") {
				cover = contextPath + '/images/default/cover.jpg';
			} else {
				cover = contextPath + '/images/usersImages/'+ event.userId + '/' + event.album + '/cover/cover.jpg';
			}
			var itemHtml = "<li><a href='" + contextPath + "/event/eventDetail?id=" + event._id + "'>"
							+ "<img src='" + cover + "'/>"
							+ "<div><span class='title'>" + event.title + "</span>"
							+ "<span class='fulllist-item-info'>"
							+ dateToYMD(new Date(event.fromDate)) + "-" + dateToYMD(new Date(event.toDate))
							+ "<br />" + event.address											
							+" </span></div></a></li>";
			htmlCat +=  itemHtml;
		}
		htmlCat += "</ul></section>";
	}
	var catId = $node.attr("href");
	$(".container").html("");
	$(".container").fadeOut();
	$(catId).html(htmlCat);
	$(catId).fadeIn();
	$(' .da-thumbs li ').each( function() { $(this).hoverdir(); } );
	$("#loadingImg").hide();
	$(".da-thumbs").mCustomScrollbar({
		scrollInertia: 250,
		mouseWheelPixels: "300",
		scrollButtons:{
			enable:true
		}						
	});
	$("#search-input").keyup(function(event) {
		$("#loadingImg").show();
	    if (event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 40 || event.keyCode == 38) {
	    	event.preventDefault();
	    } else {
	    	var keyword = $("#search-input").val();
	    	var data;
	    	if (keyword == '') {
	    		data = {					
	    				query: {
	    					bool : {
	    						must : [{
	    							match_phrase : {
	    									category: category
	    								}
	    						},	
								{
	    							match_phrase : {
										type: "public"
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
	    	} else {
		    	data = {					
						query: {
							bool : {
								must : [{
										multi_match : {
											query : keyword,
											fields: [ "title^4", "address" ],
											type: "phrase_prefix"
										}
									},
									{
										match_phrase : {
											category: category
										}
								},	
								{
									match_phrase : {
										type: "public"
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
		    	}
				$.ajax({
					url: eSearchUri + ':9200/eventmap/_search?search_type=query_and_fetch',
					type: 'POST',
					contentType: 'application/json; charset=UTF-8',
					crossDomain: true,
					dataType: 'json',
					data: JSON.stringify(data),							
					success: function(response) {
						buildListEventsForSearch(response.hits.hits);
						
					},
					error: function(jqXHR, textStatus, errorThrown) {
						var jso = jQuery.parseJSON(jqXHR.responseText);
						alert('(' + jqXHR.status + ') ' + errorThrown + ' --<br />' + jso.error);
					}
				});	
		}
   });
};

function buildListEventsForSearch(eList) {
	var htmlCat = ""; 
	if (eList.length == 0) {
		htmlCat = "Không có sự kiện nào.";						
	} else {
		for (var i = 0; i < eList.length; i++) {
			var event = eList[i]._source;
			var cover = "";
			if (event.album == "") {
				cover = contextPath + '/images/default/cover.jpg';
			} else {
				cover = contextPath + '/images/usersImages/'+ event.userId + '/' + event.album + '/cover/cover.jpg';
			}
			var itemHtml = "<li><a href='" + contextPath + "/event/eventDetail?id=" + event._id + "'>"
							+ "<img src='" + cover + "'/>"
							+ "<div><span class='title'>" + event.title + "</span>"
							+ "<span class='fulllist-item-info'>"
							+ dateToYMD(new Date(event.fromDate)) + "-" + dateToYMD(new Date(event.toDate))
							+ "<br />" + event.address											
							+" </span></div></a></li>";
			htmlCat +=  itemHtml;
		}
	}
	var catId = $node.attr("href");
	$(catId + " ul").html(htmlCat);
	//$(catId).fadeIn();
	$(' .da-thumbs li ').each( function() { $(this).hoverdir(); } );
	$("#loadingImg").hide();
	$(".da-thumbs").mCustomScrollbar({
		scrollInertia: 250,
		mouseWheelPixels: "300",
		scrollButtons:{
			enable:true
		}						
	});
}