<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html">
<html>
<head>
	<title>Bản đồ sự kiện | EventMap</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta property="og:title" content=" Bản đồ sự kiện | EventMap" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/detailsBase.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/reset.css" />
	<script src="<%=getServletContext().getContextPath()%>/js/common.js"></script>
	<style>
		.register-err {
			font-size: 11px;
			color: red;
			font-style: italic;
			font-weight: bold;
		}
		.register-err span{
			color: blue;
		}
	</style>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery-2.0.2.js"></script>
	<script>
	$(document).ready(function(){
		var ready = true;
		$("#resetpwd").click(function(){
			if (!ready) return;
			ready = false;
			var email = $("#email").val();
			if (!validateEmail(email)) {
				$("#email_err").html("Email không hợp lệ.<br /><span>Vui lòng nhập lại.</span>");
				return;
			};
			
			$("#email_err").hide();
			$("#resetpwd").hide();
			$("#loadinggif").show();
			
			$.ajax ({
				type: "POST",
			    url: contextPath + "/user/resetpwd", 
				data: {email : email},
				success: function(data) {
					ready = true;
					if (data.userName == "") {
						$("#email_err").html("Không tìm thấy email đã nhập.<br /><span>Vui lòng kiểm tra lại.</span>");
						$("#email_err").show();
						$("#resetpwd").show();
						$("#loadinggif").hide();
						return;
					} else {
						$("#wrapper").html("Chào " + data.userName + ",<br/>Vui lòng kiếm tra địa chỉ email " + email + " và làm theo hướng dẫn để lấy lại mật khẩu.<br /><a href='#' onclick='toggleLogin(); return false;'>Đăng nhập</a> hoặc <a href='<%=getServletContext().getContextPath()%>'><span id='back2home'>Quay về trang chủ </span></a>");
						var text = $("#back2home").html();
						var timeout = 5;
						setInterval(function(){
							 $("#back2home").html(text + "(" + timeout + ")");
							timeout--;
							if (timeout == 0) {
								$(location).attr('href', '<%=request.getContextPath()%>');
							}
						},1000);
					}
			    }
			});
		});
	});
	</script>
</head>
<body>
<div id="header">
	<jsp:include page="/WEB-INF/page/Header.jsp" />
</div>
<div id="wrapper" style="margin-top: 45px;">
	<h2>Yêu cầu mật khẩu mới</h2>
	<p style="margin-left: 2em;">Hãy nhập email bạn đã dùng để đăng ký tài khoản, chúng tôi sẽ gửi cho bạn mật khẩu truy cập mới thông qua email đó.</p>
	<table style="margin:1em; border-spacing: 15px 15px; border-collapse: separate;">
		<tr>
			<th style="vertical-align: middle;">Email đăng ký tài khoản</th>
			<td>
				<input type="text" id="email" />
				<div id="email_err" class="register-err"></div>
			</td>
		</tr>
		<tr align="right">
			<td colspan="2">
				<img id="loadinggif" alt="" src="<%=getServletContext().getContextPath()%>/images/FBLoading.gif" style="display: none;float: right;margin-right: -20px;">
				<input type="button" class="btn-light" id="resetpwd" value="Gửi yêu cầu" style="float: right;margin-right: 0;">
			</td>
		</tr>
	</table>
</div>
</body>
</html>