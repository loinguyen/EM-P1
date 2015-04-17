var titleOk = false, addressOk = false, contactOk = false, fromDateOk = false, toDateOk = false;
$(document).ready(function(){
	$('#updateEvent').hide();
	$('#coverPicture').hide();
	var nowTemp = new Date();
	$('#dateFrom').attr('placeholder', getDateAsString(nowTemp));
	$('#dateTo').attr('placeholder', getDateAsString(nowTemp));
	var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
	$('#demo-upload').insertAfter('#dropzone span');
	
	if (mod == 'edit') {
		$(document).attr('title', 'Bản đồ sự kiện | Chỉnh sửa thông tin sự kiện: ' + $("#event-title").val());
		$('#dateFrom').val($("#eventFromDate").val());
		$('#dateTo').val($("#eventToDate").val());
		titleOk = true; addressOk = true; contactOk = true; fromDateOk = true; toDateOk = true;
	} else {
		$(document).attr('title', 'Bản đồ sự kiện | Tạo sự kiện mới');
	}
	
	var checkin = $('#dateFrom').datepicker({
	  onRender: function(date) {
	    return date.valueOf() < now.valueOf() ? 'disabled' : '';
	  }
	}).on('changeDate', function(ev) {
	    var newDate = new Date(ev.date);
	    newDate.setDate(newDate.getDate());
	    //if ($('#dateTo').val() == "") {
	    	checkout.setValue(newDate);
	    //}
	    checkin.hide();
	    fromDateOk =  true;
	    $('#dateTo').val($(this).val());
	    $('#dateTo')[0].focus();
	}).data('datepicker');
	var checkout = $('#dateTo').datepicker({
	  onRender: function(date) {
	    return date.valueOf() < checkin.date.valueOf() ? 'disabled' : '';
	  }
	}).on('changeDate', function(ev) {
	  checkout.hide();
	  toDateOk = true;
	}).data('datepicker');
	
	
	$("#event-title").keyup(function(event) {
		var curr = $('#related-event-suggest').find('.current');
		 if (event.keyCode == 37 || event.keyCode == 39) {
		    	event.preventDefault();
		    } else if (event.keyCode == 40) {   
		        if(curr.length && curr.next().length) {
		                $(curr).removeClass('current');
		                $(curr).next().addClass('current');
		        } else {
		        	$(curr).removeClass('current');
		            $('#related-event-suggest .mCSB_container div:first-child').next().addClass('current');
		        }
		        $("#related-event-suggest").mCustomScrollbar("scrollTo", '.current');
		    } else if(event.keyCode==38) {                                        
		        if(curr.length && curr.prev().prev().length) {                            
		                $(curr).removeClass('current');
		                $(curr).prev().addClass('current');
		        } else {
		        	$(curr).removeClass('current');
		            $('#related-event-suggest .mCSB_container div:last-child').addClass('current');
		        }
		        $("#related-event-suggest").mCustomScrollbar("scrollTo", '.current');
		    } else if ( event.which == 13 ) {
		    	if (curr.length) {
		    		return curr.click();
		    	}
				event.preventDefault();
			} else {
				if ($("#event-title").val() == "") return;
//				var todayFirstTime = getFirstTimeOfDate(new Date());
				var data = {
						 query: {
		                       bool : {
		                           must : [
			                           {
			                        	   match_phrase_prefix: {
			                                    "title" : $("#event-title").val()
			                               }
			                           },	
										{
			                        	   filtered : {
			                        		   query : {
			                        			   match_all : {}
			                        		   },
			                        		   filter : {
			                        			   or : [{
														term : {
															type: "public"
														}
													},
													{
														term : {
															userId: userId
														}
													}]
			                        		   }  
			                        	   } 
										}
//			                           ,
//			                           {
//			                               range : {
//			                                   "toDate" : {
//			                                       "from" : todayFirstTime
//			                                   }
//			                               }
//			                           }
		                           ],
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
					callESearchAPI(data, eSearchMode.relate);
			}
	});
	
	$("#event-title").blur(function() {
		$('#related-event-suggest').slideUp();
	});
	
	var searchresultdisplayclasses = ['searchbox', 'suggestsearch odd', 'suggestsearch even'];
	$(document).click(function(event){
		if(searchresultdisplayclasses.indexOf($(event.target).attr('class'))== -1){
			$('#related-event-suggest').slideUp();
		}
	});
	
	$("#dateFrom").click(function(){
		$($(".datepicker.dropdown-menu")[0]).show();
	});
	
	// Validation
	// Event title
	$('#event-title').blur(function(){
		if ($(this).val() == '') {
			$(this).attr('placeholder', 'Tên sự kiện không thể để trống');
			$(this).css({'background-color':'rgba(255,0,0,0.1)',
						'background-image':'url(../images/accessDenie.png)',
						'background-size':'15px',
						'background-repeat':'no-repeat',
						'background-position':'99%'});
			titleOk = false;
		} else {
			titleOk = true;
		}
	});
	$('#event-title').keyup(function(){
		$(this).attr('placeholder', '');
		$(this).css({'background-color':'#FFF',
			'background-image':'none',
			'background-size':'none'});
	});
	
	// Location
	$('#event-address').blur(function(){
		if ($(this).val() == '') {
			$(this).attr('placeholder', 'Địa điểm không thể để trống');
			$(this).css({'background-color':'rgba(255,0,0,0.1)',
						'background-image':'url(../images/accessDenie.png)',
						'background-size':'15px',
						'background-repeat':'no-repeat',
						'background-position':'99%'});
			addressOk = false;
		} else {
			addressOk = true;
		}
	});
	$('#event-address').keyup(function(){
		$(this).attr('placeholder', 'VD: Đại học FPT, số 8 Tôn Thất Thuyết');
		$(this).css({'background-color':'#FFF',
			'background-image':'none',
			'background-size':'none'});
	});
	
	// Contact
	$('#event-contact').blur(function(){
		if ($(this).val() == '') {
			$(this).attr('placeholder', 'Cần ít nhất 1 thông tin liên hệ');
			$(this).css({'background-color':'rgba(255,0,0,0.1)',
						'background-image':'url(../images/accessDenie.png)',
						'background-size':'15px',
						'background-repeat':'no-repeat',
						'background-position':'99%'});
			contactOk = false; 
		} else {
			contactOk = true; 
		}
	});
	$('#event-contact').keyup(function(){
		$(this).attr('placeholder', 'VD: Số ĐT, địa chỉ email, đỉa chỉ web...');
		$(this).css({'background-color':'#FFF',
			'background-image':'none',
			'background-size':'none'});
	});
	
});

$(window).load(function(){
	$("#related-event-suggest").hide();
	tinymce.init({
	    selector: "textarea",
	    theme: "modern",
	    plugins: [
	        "advlist autolink lists link image preview hr anchor pagebreak",
	        "searchreplace wordcount visualblocks visualchars",
	        "media nonbreaking table",
	        "emoticons template paste textcolor"
	    ],
	    toolbar1: "undo redo | styleselect | bold underline italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent",
	    toolbar2: "searchreplace copy paste table | forecolor backcolor emoticons | link image media preview",
	    image_advtab: false,
	    menubar:false,
	    width: '100% !important'
	});
	
	$('.tdLabel').parent().children().css('padding-top','17px');
	$('#image-upload').parent().children().css('padding-top','10px');
	$('.tdLabel').next().css('padding-bottom','20px');
	$('.tdLabel').next().width(790);
});

function buildRelatedEventSuggest(eList) {
	if (eList.length == 0) {
		$('#related-event-suggest').html("");
		$('#related-event-suggest').slideUp();
		return;
	}
	var suggestdiv = "<div style='color:green;'>Vui lòng xem qua các sự kiện đưới đây trước khi tạo sự kiện mới.</div>";
	var _class = "odd";
	for (var i = 0; i < eList.length; i++) {
		var event = eList[i]._source;
		suggestdiv += "<div class = 'suggestsearch " + _class + "' id = '" + event._id + "'>" + event.title + "</div>";
		if (_class == "odd") {
			_class = "even";
		} else {
			_class = "odd";
		}
	}
	$('#related-event-suggest').html(suggestdiv);
	
	var resultHeight = document.getElementById('related-event-suggest').scrollHeight;
	var maxHeight = 315;
	
	if (resultHeight > maxHeight) {
		$('#related-event-suggest').height(maxHeight);
		$('#related-event-suggest').width(370);
	} else {
		$('#related-event-suggest').height("");
		$('#related-event-suggest').width(385);
	}
	
	$('#related-event-suggest').show();
	$("#related-event-suggest").mCustomScrollbar({
		scrollButtons:{
			enable:false
		},
		mouseWheelPixels: "100",
		theme:"dark-thin"
	});
	
	
	$('.suggestsearch').click(function() {
		 $.fancybox({
	            width: '100%',
	            height: '100%',
	            autoScale: true,
	            transitionIn: 'fade',
	            transitionOut: 'fade',
	            type: 'iframe',
	        	autoSize:false, 
	            href: './eventDetail?id=' + $(this).attr("id")
		 });
		 $('#related-event-suggest').slideUp();
	});
	
	$('.suggestsearch').hover(function (){            
	    $(this).addClass('current');
	}, function (){
	    $(this).removeClass('current');
	});
	
	$(".datepicker.dropdown-menu").hide();
}

//function createEvent
function saveEvent() {
	tinymce.triggerSave();
	$('#eventFromDate').val(getDateTime($('#dateFrom').val()));
	$('#eventToDate').val(getDateTime($('#dateTo').val()));
	$('#eventAlbum').val($('#album').val());
	if (!eventDetailsOK()) return;
	$("#event-loading").show();
	$("#btn-area").hide();
	$.ajax ({
		type: "POST",
	    url: contextPath + "/event/saveEvent", 
	    data: $('#eventDetailsForm').serialize(),
	    success: function(data) {
	    	if(data.actionErrors.length > 0) {
	    		alert(data.actionErrors);
	    		$("#event-loading").hide();
	    		$("#btn-area").show();
	    	}
	    	if (data.event == null) {
	    		$("#returnPic").attr("src", contextPath + "/images/notOk.jpg");
	    		$("#returnPic").show();
		    	setTimeout(function(){$("#returnPic").hide();}, 3000);
	    		$("#event-loading").hide();
	    		$("#btn-area").show();
	    	} else {
	    		$(location).attr('href', contextPath + "/event/eventDetail?id=" + data.event.id);
	    	}
	    }
	});
}

function updateEvent() {
	tinymce.triggerSave();
	$('#eventFromDate').val(getDateTime($('#dateFrom').val()));
	$('#eventToDate').val(getDateTime($('#dateTo').val()));
	$('#eventAlbum').val($('#album').val());
	if (!eventDetailsOK()) return;
	$("#event-loading").show();
	$("#btn-area").hide();
	$.ajax ({
		type: "POST",
	    url: contextPath + "/event/updateEvent", 
	    data: $('#eventDetailsForm').serialize(),
	    success: function(data) {
	    	$("#event-loading").hide();
	    	if (data.event == null) {
	    		$("#returnPic").attr("src", contextPath + "/images/notOk.jpg");
	    		$("#returnPic").show();
		    	setTimeout(function(){$("#returnPic").hide();}, 3000);
	    		$("#btn-area").show();
	    	} else {
	    		if (data.event.type == "private") {
	    			$(location).attr('href', contextPath + "/event/eventDetail?id=" + data.event.id);
	    		} else {
	    			alert("Thay đổi của bạn đã được lưu lại chờ kiểm duyệt!");
	    			$(location).attr('href', contextPath + "/");
	    		};
	    	}
	    }
	});
}

function eventDetailsOK() {
	if (titleOk && addressOk && contactOk && fromDateOk && toDateOk && $("#address-error").html()=="") {
		$("#noti-area").hide();
		return true;
	} else {
		$("#noti-area").html("Bạn cần nhập đầy đủ thông tin hợp lệ vào các trường bắt buộc<br /><span>Vui lòng kiểm tra lại</span>");
		$("#noti-area").show();
		return false;
	}
}