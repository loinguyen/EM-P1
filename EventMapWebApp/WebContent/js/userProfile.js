$(window).load(function(){
	$('.profile-content').hide();
	$('#full-info-content').show().addClass('active');
	$('#full-info').addClass('active');
	 $('#user-info-btn').find('button').hide();
	 $('#btn-edit').show();
	 $('#userProfileForm').find('input').attr('disabled','true');
	 $('#ava-upload').hide();
	 
});
$(document).ready(function(){
	var animateTime = 250, isValidPwd = false, uploading = false, postloaded = false;
	
	// Change left nav tab
	$('.profile-tab').click(function(){
		var last = $('.active').attr('id') + '-content';
		var current = $(this).attr('id') + '-content';
		if($(this).hasClass('active')) {
			return;
		} else {
			$('.profile-tab').removeClass('active');
			$(this).addClass('active');
			$('#' + last).slideUp();
			$('#' + current).slideDown();
		}
	});
	
	// prevent a tag default
	$('a.profile-tab').click(function(e){
		e.preventDefault();
	});
	
	// Click on edit button
	$('#btn-edit').click(function(event){
		event.preventDefault;
		$('#userProfileForm').find('input').removeAttr('disabled');
		$(this).fadeOut(animateTime, function(){
			$('#btn-save').fadeIn(animateTime);
			$('#btn-cancel').fadeIn(animateTime);
			$('#change-avatar').fadeIn(animateTime);
		});
	});
	
	
	$("#newpwd").keyup(function(event){
		event.preventDefault;
		if ($("#newpwd").val().length > 7) {
			$("#cfnewpwd").removeAttr("disabled");
			$("#err_newpwd").hide();
		} else {
			$("#err_newpwd").html("*Độ dài mật khẩu tối thiểu là 8 ký tự.");
			$("#cfnewpwd").attr("disabled","disabled");
			isValidPwd = false;
		}
	});
	$("#cfnewpwd").keyup(function(event){
		event.preventDefault;
		if ($("#cfnewpwd").val() == $("#newpwd").val()) {
			$("#err_cfpwd").hide();
			isValidPwd = true;
		} else {
			$("#err_cfpwd").html("*Mật khẩu không khớp!<br /><span>Vui lòng nhập lại</span>");
			$("#err_cfpwd").show();
			isValidPwd = false;
		}
	});
	$('#btn-changepwd').click(function(event){
		event.preventDefault;
		if($("#oldpwd").val() == '') isValidPwd = false;
		if (!isValidPwd) {
			$("#err_cfpwd").html("*Bạn cần nhập đầy đủ các trường.<br /><span>Vui lòng kiểm tra lại</span>");
			$("#err_cfpwd").show();
			return;
		}
		$("#changepwd-loading").show();
		$('#btn-changepwd').hide();
		$.ajax ({
			type: "POST",
		    url: contextPath + "/user/changepwd", 
		    data: $("#changepwd-form").serialize(),
		    success: function(data) {
		    	console.log(data);
		    	if(data.actionErrors.length > 0) {
//		    		$("#err_oldpwd").html(data.actionErrors);
//					$("#err_oldpwd").show();
//					$('#btn-changepwd').show();
		    		alert(data.actionErrors);
		    	} else {
		    		alert("'Đổi mật khẩu thành công.'");
		    		$("#oldpwd").val("");
		    		$("#newpwd").val("");
		    		$("#cfnewpwd").val("");
		    	}
		    	$("#changepwd-loading").hide();
    		}
		});
	});
	$('#change-avatar').click(function(event){
		event.preventDefault;
		$("#avatar").click();
	});
	
	$("#targetUpload").load(function(){
		
		var response = window.targetUpload.document.getElementsByTagName("pre")[0].innerText;
		var data = $.parseJSON(response);
		if (data.avatar) {
			$("#user-avatar").attr('src','');
			$('#loadingImg').hide();
			$("#user-avatar").attr('src', contextPath + '/images/usersImages/' + userId + '/avatar.jpg');
			$("#user-avatar").css("opacity", 1);
		};
		uploading = false;
	});
	$("#avatar").change(function(event){
		event.preventDefault;
		if (uploading) return;
		uploading = true;
		$("#user-avatar").css("opacity",0.5);
		$('#loadingImg').show();
		$('#ava-upload').submit();
	});
	
		//Click on cancel button
	$('#btn-cancel').click(function(){
		$('#userProfileForm').find('input').attr('disabled','true');
		$('#btn-save').fadeOut(animateTime);
		$(this).fadeOut(animateTime, function(){
			$('#btn-edit').fadeIn(animateTime);
		});
		$("#userProfileForm")[0].reset();
		// TODO: revert all field value.
	});
	
	//Click on save button
	$('#btn-save').click(function(){
		if (!validPro5Email()) return;
		$('#user-info').find('input').attr('disabled','true');
		$('#btn-cancel').fadeOut(animateTime);
		$('#change-avatar').fadeOut(animateTime);
		$(this).fadeOut(animateTime, function(){
			$('#btn-edit').fadeIn(animateTime);
		});
		// TODO: save data
	});
	
	//DOB date picker
	var dobPicker = $('#dob').datepicker().on('changeDate', function(ev) {
//		dobPicker.hide();
	}).data('datepicker');
	
	$("#user-infor").click(function(){
		postloaded = false;
		$("#middle-container").css("display","none");
		$("#right-container").css("display","block");
	});
	
	$("#posts").click(function(){
		if (postloaded) return;
		postloaded = true;
		var data;
		if (loggedUserId == userId) {
			data = {					
				query: {
					bool : {
						must : {
								match : {
									userId: userId
								}
						},
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
									match : {
										userId: userId
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
		callESearchAPI(data, eSearchMode.post);
		$("#middle-container").css("display","block");
		$("#right-container").css("display","none");
	});
	
	$("#user-email").blur(function(event){
		event.preventDefault;
		validPro5Email();
	});
});

//function builPostedEventsList(eList) {
//	//alert($("#data-table tbody").html()); return;
//	if (eList.length == 0) {
//		$("#data-table").html("Chưa có sự kiện nào.");
//		return;
//	}
//	var tbodyhtml = "";
//	for (var i = 0; i < eList.length; i++) {
//		var event = eList[i]._source;
//		tbodyhtml += "<tr><td><a href='" + contextPath + "/event/eventDetail?id=" + event._id + "'>" + event.title + "</a></td><td>" + dateToYMD(new Date(event.fromDate)) + "-" +dateToYMD(new Date(event.toDate)) + "</td><td>" + event.category + "</td></tr>";
//	}
//	$("#data-table tbody").html(tbodyhtml);
//	$('#data-table').dataTable({
//		 "oLanguage": {
//           "sUrl": contextPath + "/js/dataTables.vi.txt"
//		 },
//		 "aoColumns": [
//		               	{ "sWidth": "60%" },
//						{ "sWidth": "30%", "sClass": "center" },
//						{ "sWidth": "10%", "sClass": "center" }
//					],
//		"sPaginationType": "full_numbers",
//		"bLengthChange": false,
//		"iDisplayLength": 17
//	 });
//}

function builPostedEventsList(eList) {
	if (eList.length == 0) {
		$("#data-table").html("Chưa có sự kiện nào.");
		return;
	}
	var tbodyhtml = "";
	for (var i = 0; i < eList.length; i++) {
		var event = eList[i]._source;
		tbodyhtml += "<li><a href='" + contextPath + "/event/eventDetail?id=" + event._id + "'><p class='next-days-date'><span class='day'>" + normalizeTitle(event.title,40) + "</span></p><p class='next-days-temperature'>"+ dateToYMD(new Date(event.createdDate)) +"<span class='icon'><img class='imgIcon' src='"+ contextPath + "/images/categoryIcon/" + convertCategory(event.category) +".png' /></span></p></a></li>";
	}
	$("#eventList-body").html(tbodyhtml);
	pagingReulst();
}

function validPro5Email() {
	var email = $("#user-email").val();
	if (!validateEmail(email)) {
		$("#user-email-err").html("Email không hợp lệ.<br /><span>Vui lòng nhập lại.</span>");
		$("#user-email-err").show();
		return false;
	} else {
		$("#user-email-err").hide();
		return true;
	}
}

/***************Utility*************************/
function convertCategory(category) {
	
	var cate = "";
	switch (category.toLowerCase()) {
		case music:
			cate = "music";
			break;
		case fair:
			cate = "fair";
			break;
		case sport:
			cate = "sport";
			break;
		case art:
			cate = "art";
			break;
		case film:
			cate = "film";
			break;
		case offline:
			cate = "offline";
			break;
		case saleoff:
			cate = "saleoff";
			break;
		case other:
			cate = "other";
			break;
		case all:
			cate = "all";
			break;
		default:
			cate = category;
			break;
	}
	return cate;
}

function pagingReulst(){
	$('#paging_container').pajinate({
		items_per_page : 9,
		item_container_id : '#eventList-body',
		nav_panel_id : '.alt_page_navigation'
		
	});
}
//New JS
/* JS for demo only */
//var colors = ['1abc9c', '2c3e50', '2980b9', '7f8c8d', 'f1c40f', 'd35400', '27ae60'];
//
//$('.color-picker')[0].on('click', '.square', function(event, square) {
//  background = square.getStyle('background');
//  $('.custom-dropdown select').each(function (dropdown) {
//    dropdown.setStyle({'background' : background});
//  });
//});

/*
 * Original version at
 * http://red-team-design.com/making-html-dropdowns-not-suck
 */ 