<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html">
<html>
<head>
	<title>Bản đồ sự kiện | EventMap</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta property="og:title" content=" Bản đồ sự kiện | EventMap" />
	<script src="<%=getServletContext().getContextPath()%>/js/jquery-2.0.2.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/detailsBase.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/reset.css" />
	<script>
	$(document).ready(function(){
		var login = false; 
		var text = $("#back2home").html();
		var timeout = 5;
		setInterval(function(){
			 $("#back2home").html(text + "(" + timeout + ")");
			timeout--;
			if (timeout == 0) {
				if (login) return;
				$(location).attr('href', '<%=request.getContextPath()%>/');
			}
		},1000);
	});
	function login() {
		login = true;
		toggleLogin();
	};
	</script>
</head>
<body>
<div id="header">
	<jsp:include page="/WEB-INF/page/Header.jsp" />
</div>
<s:hidden name="type" id="type"></s:hidden>
<div id="wrapper" style="margin-top: 45px;">
	<h2>Thông báo</h2>
	<s:if test="%{type == 'activate'}">
		<div id="activate" style="margin: 1em;">
			Tài khoản của bạn đã được xác nhận!<br /> Vui lòng <a href="#" onclick="login(); return false;">Đăng nhập</a> hoặc <a href="<%=getServletContext().getContextPath()%>/"><span id="back2home">Quay về trang chủ </span></a>
		</div>
	</s:if>
	<s:if test="%{type == 'resetpwd'}">
		<div id="resetpwd" style="margin: 1em;">
			Mật khẩu mới đã được gửi đến email của bạn.<br /><a href="<%=getServletContext().getContextPath()%>/"><span id="back2home">Quay về trang chủ </span></a>
		</div>
	</s:if>
	<s:if test="%{type == null || type == ''}">
		<div style="margin: 1em;">
			Email này đã được xử lý.<br /><a href="<%=getServletContext().getContextPath()%>/"><span id="back2home">Quay về trang chủ </span></a>
		</div>
	</s:if>
</div>
</body>
</html>