$(document).ready(function(){
	var isValidUserName = false, isValidEmail = false, isValidPassword = false, ready = true;
	$("#r_cfpassword").attr("disabled","disabled");
	$("#r_username").blur(function(event){
		event.preventDefault;
		var username = $("#r_username").val();
		if (!validateId(username)) {
			$("#r_username_err").html("Tên đăng nhập không hợp lệ.<br /><span>Tên đăng nhập giới hạn từ 3 đến 20 kí tự, chỉ chứa chữ cái, chữ số và các kí tự \"-\" \"_\"<br />Vui lòng nhập lại.</span>");
			$("#r_username_err").show();
			isValidUserName = false;
			$('.fancybox-inner').height('');
			return;
		}
		$.ajax ({
			type: "POST",
		    url: contextPath + "/user/findbyUsername", 
			data: {userName : username},
			success: function(data) {
				if (data.user == null) {
					$("#r_username_err").hide();
					isValidUserName = true;
				} else {
					$("#r_username_err").html("Tên đăng nhập này đã được sử dụng.<br /><span>Vui lòng chọn tên đăng nhập khác.</span>");
					$("#r_username_err").show();
					isValidUserName = false;
				}
				$('.fancybox-inner').height('');
		    }
		});
	});
	$("#r_email").blur(function(event){
		event.preventDefault;
		var email = $("#r_email").val();
		if (email == "") {
			return;
		}
		if (!validateEmail(email)) {
			$("#r_email_err").html("Email không hợp lệ.<br /><span>Vui lòng nhập lại.</span>");
			$("#r_email_err").show();
			isValidEmail = false;
			$('.fancybox-inner').height('');
			return;
		}
		$.ajax ({
			type: "POST",
			url: contextPath + "/user/findByEmail", 
			data: {email : email},
			success: function(data) {
				if (data.user == null) {
					$("#r_email_err").hide();
					isValidEmail = true;
				} else {
					$("#r_email_err").html("Email này đã được sử dụng.<br /><span>Vui lòng sử dụng email khác.</span>");
					$("#r_email_err").show();
					isValidEmail = false;
				}
				$('.fancybox-inner').height('');
			}
		});
	});
	$("#r_password").keyup(function(event){
		event.preventDefault;
		if ($("#r_password").val().length > 7) {
			$("#r_cfpassword").removeAttr("disabled");
			$("#r_password_err").hide();
		} else {
			$("#r_password_err").html("Độ dài mật khẩu tối thiểu là 8 ký tự.");
			$("#r_cfpassword").attr("disabled","disabled");
			isValidPassword = false;
		}
		$('.fancybox-inner').height('');
	});
	$("#r_cfpassword").keyup(function(event){
		event.preventDefault;
		if ($("#r_cfpassword").val() == $("#r_password").val()) {
			$("#r_cfpassword_err").hide();
			isValidPassword = true;
		} else {
			$("#r_cfpassword_err").html("Mật khẩu không khớp!<br /><span>Vui lòng nhập lại</span>");
			$("#r_cfpassword_err").show();
			isValidPassword = false;
		}
		$('.fancybox-inner').height('');
	});
	
	$("#r_register").click(function(event){
		event.preventDefault;
		if (!ready) return;
		if ( isValidUserName && isValidEmail && isValidPassword) {
			ready = false;
			$("#r_register").hide();
			$("#loadingimg").show();
			$('.fancybox-inner').height('');
			$.ajax ({
				type: "POST",
			    url: contextPath + "/user/signup", 
				data: $("#signup-form").serialize(),
				success: function(data) {
					if (data.actionErrors.length > 0) {
						var html="";
						for (var i = 0; i < data.actionErrors.length; i++) {
							html += data.actionErrors[i] + "< br />";
						}
						$("#r_cfpassword_err").html(html);
						$("#r_cfpassword_err").show();
						$('.fancybox-inner').height('');
						$("#loadingimg").hide();
						$("#r_register").hide();
						return;
					}
					if (data.user == null) {
						$("#r_cfpassword_err").html("Có lỗi xảy ra trong quá trình đăng ký.<br/><span>Vui lòng thử lại.</span>");
						$("#r_cfpassword_err").show();
						$('.fancybox-inner').height('');
						$("#loadingimg").hide();
						$("#r_register").hide();
					} else {
						$("#register-result").html("Đăng ký tài khoản thành công!<br/>Vui lòng kiểm tra địa chỉ email " + data.user.email + " và làm theo hướng dẫn để kích hoạt tài khoản.<br />Xin cảm ơn.<br />* Nếu không thấy email trong hộp thư đến, vui lòng kiểm tra hòm thư rác (spam).");
//						$("#register-result").html("Đăng ký tài khoản thành công!");
						$("#login-wrapper").hide();
						$("#register-result").show();
						$('.fancybox-inner').height('');
						$("#loadingimg").hide();
						setTimeout(function(){
							$('.fancybox-close').click();
							$("#register-result").hide();
							$("#login-wrapper").show();
							$("#r_register").show();
							$('.fancybox-inner').height('');
						}, 5000);
					}
					ready = true;
			    }
			});
		} else {
			if ($("#r_password").val() == "" || $("#r_email").val() == "" || $("#r_username").val() == "") {
				$("#r_cfpassword_err").html("Bạn cần nhập tất cả các trường<br /><span>Vui lòng kiếm tra lại</span>");
				$("#r_cfpassword_err").show();
				$('.fancybox-inner').height('');
			}
		}
	});
});