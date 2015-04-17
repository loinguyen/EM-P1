<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta property="og:title" content="title" />
	<link rel="shortcut icon" href="<%=getServletContext().getContextPath()%>/images/favicon.ico"> 
	<link href="<%=getServletContext().getContextPath()%>/css/header.css" rel="stylesheet" type="text/css"/>
	<link href="<%=getServletContext().getContextPath()%>/css/normalize.css" rel="stylesheet" type="text/css"/>
	<link href="<%=getServletContext().getContextPath()%>/css/component.css" rel="stylesheet" type="text/css"/>
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/style.css" />
	<link rel="stylesheet" href="<%=getServletContext().getContextPath()%>/css/reset.css" media="screen">
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/fancybox/jquery.fancybox.css?v=2.1.5" media="screen" />
	
	<script src="<%=getServletContext().getContextPath()%>/js/modernizr.custom.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery.fancybox.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/common.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/header.js"></script>
	<script type="text/javascript">
	var eSearchUri = "<s:text name='esearch.uri'/>";
	var userId = '<s:property value="userId"/>';
	var contextPath = "<%=getServletContext().getContextPath()%>";
	var music = "<fmt:message key="label.event.category.music" />";
	var fair =  "<fmt:message key="label.event.category.fair" />";
	var sport =  "<fmt:message key="label.event.category.sport" />";
	var art =  "<fmt:message key="label.event.category.art" />";
	var film =  "<fmt:message key="label.event.category.film" />";
	var offline =  "<fmt:message key="label.event.category.offline"/>";
	var saleoff =  "<fmt:message key="label.event.category.saleoff" />";
	var other =  "<fmt:message key="label.event.category.other" />";
	
	$(document).ready(function(){
		$('a#login').fancybox({
			width:738,
			height:260,
			autoSize:false,
			autoScale: true,
			content:$('#login-hidder'),
			afterClose: function(){
				$("#login-error").html("");
			}
		});
		$('a#login').click(function(){
			$("#signup-form .register-err").html("");
			$('#signup-form')[0].reset();
		});
		
		var error = false;
		'<c:if test="${param.error != null}">'
			error = true;
		'</c:if>'
		if (error != false) {
// 			setTimeout(toggleLogin,1000);
			var errorVal = $("#error-block").val();
			
			if(errorVal.indexOf("không chính xác") > -1) {
				$("#login-error").html(errorVal);
				$("#login-error").css({"margin-top": "-10px","margin-bottom": "10px","text-align": "center"});
				$("#login-error").show();
				$('.fancybox-inner').height('');
				toggleLogin();
			}
			if (errorVal.indexOf("khóa") > -1) {
				$("#login-error").html(errorVal);
				$.fancybox({
		            autoScale: true,
		            transitionIn: 'fade',
		            transitionOut: 'fade',
		        	autoSize:true,
		        	content: $( "#login-error" )
			 	});
			}
		} else {
			$("#login-error").hide();
		}
	});
	</script>
</head>
<body>
<div class="header">
	<div id="hit-counter">
		<!-- Histats.com  START (hidden counter)-->
		<script type="text/javascript">document.write(unescape("%3Cscript src=%27http://s10.histats.com/js15.js%27 type=%27text/javascript%27%3E%3C/script%3E"));</script>
		<a href="http://www.histats.com" target="_blank" title="counter free hit invisible" ><script  type="text/javascript" >
		try {Histats.start(1,2673110,4,0,0,0,"");
		Histats.track_hits();} catch(err){};
		</script></a>
		<noscript><a href="http://www.histats.com" target="_blank"><img  src="http://sstatic1.histats.com/0.gif?2673110&101" alt="counter free hit invisible" border="0"></a></noscript>
		<!-- Histats.com  END  -->
	</div>
	<a href="<%=getServletContext().getContextPath()%>/"><div id="logo" style="background-image:url(<%=getServletContext().getContextPath()%>/images/logo.png)"></div></a>
	<div class="menu-content">
		<nav class="cl-effect-10">
			<a href="<%=getServletContext().getContextPath()%>/" data-hover="Trang chủ" ><span>EventMap</span></a>
			<sec:authorize ifNotGranted="ROLE_ANONYMOUS">
			<a href="<%=getServletContext().getContextPath()%>/event/createEvent" data-hover="Tạo sự kiện mới" ><span><fmt:message>label.menu.create.event</fmt:message></span></a>
			</sec:authorize>
			<a href="<%=getServletContext().getContextPath()%>/event/list" data-hover="Danh sách sự kiện" ><span><fmt:message>label.menu.event.list</fmt:message></span></a>
			<sec:authorize ifAnyGranted="ROLE_MOD,ROLE_ADMIN">
			<a href="<%=getServletContext().getContextPath()%>/admin/manage" data-hover="Trang quản trị" ><span>Trang quản trị</span></a>
			</sec:authorize>
<%-- 			<a href="#" onclick="return false;" data-hover="Trợ giúp" ><span><fmt:message>label.menu.help</fmt:message></span></a> --%>
			<%-- <a id="login" href="" data-hover="Đăng nhập | Đăng ký" ><span><fmt:message>label.menu.login.register</fmt:message></span></a> --%>
			<sec:authorize ifAnyGranted="ROLE_ANONYMOUS">
				<!-- If logged in == false  -->
				<a id="login" href="" data-hover="Đăng nhập | Đăng ký" ><span><fmt:message>label.menu.login.register</fmt:message></span></a>
			</sec:authorize>
			<sec:authorize ifNotGranted="ROLE_ANONYMOUS">
				<a id="loginInfo" data-hover="Trang cá nhân" href="<%=getServletContext().getContextPath()%>/user/userProfile?userId=<sec:authentication property="principal.id" />"><span><fmt:message>label.menu.login.greate</fmt:message><sec:authentication property="principal.id" /></span></a>
				<a id="logout" href="<c:url value='<%=getServletContext().getContextPath()+"/j_spring_security_logout"%>' />" data-hover="Đăng xuất" ><span><fmt:message>label.menu.logout</fmt:message></span></a>
			</sec:authorize>
		</nav>
	</div>
</div>
<div id="login-hidder" style="display:none">
	<div id="login-wrapper">
		<form action="<%=getServletContext().getContextPath()%>/j_spring_security_check" id="loginForm" method="post">
			<table>
				<tr>
					<th><label for="j_username"><fmt:message>label.common.username</fmt:message>:</label></th>
					<td><input type="text" name="j_username" id="j_username" placeholder="<fmt:message key="label.common.username" />" class="required"></td>
				</tr>
				<tr>
					<th><label for="j_password"><fmt:message>label.common.password</fmt:message>:</label></th>
					<td><input type="password" name="j_password" id="j_password" placeholder="<fmt:message key="label.common.password" />" class="required"></td>
				</tr>
				<tr>
					<td>
					</td>
					<td>
						<input type="checkbox" name="_spring_security_remember_me" id="_spring_security_remember_me"/><label for="login-remember"> Nhớ trạng thái đăng nhập</label>
					</td>
				</tr>
			</table>
			<div id="login-error" class="register-err"></div>
			<input type="submit" class="btn-light" value="Đăng nhập" />
			<a id="fotgot-password" href="<%=getServletContext().getContextPath()%>/user/forgotpwd">Quên mật khẩu?</a>
		</form>
		<form id="signup-form" autocomplete="off">
			<table id="register-table">
				<tr>
					<th><label for="r_username"><fmt:message>label.common.username</fmt:message>:</label></th>
					<td>
						<input type="text" name="user.id" id="r_username"/>
						<div id="r_username_err" class="register-err"></div>
					</td>
				</tr>
				<tr>
					<th><label for="r_email"><fmt:message>label.common.email</fmt:message>:</label></th>
					<td>
						<input type="text" name="user.email" id="r_email"/>
						<div id="r_email_err" class="register-err"></div>
					</td>
				</tr>
				<tr>
					<th><label for="r_password"><fmt:message>label.common.password</fmt:message>:</label></th>
					<td>
						<input type="password" name="user.password" id="r_password"/>
						<div id="r_password_err" class="register-err"></div>
					</td>
				</tr>
				<tr>
					<th><label for="r_cfpassword"><fmt:message>label.common.confirm.password</fmt:message>:</label></th>
					<td>
						<input type="password" id="r_cfpassword"/>
						<div id="r_cfpassword_err" class="register-err"></div>
					</td>
				</tr>
			</table>
			<input type="button" class="btn-light" value="Đăng ký" id="r_register"/>
			<div id="loadingimg" style="display: none"></div>
		</form>
	</div>
	<div id="register-result"></div>
</div>
<input type="hidden" id="error-block" value='${sessionScope["SPRING_SECURITY_LAST_EXCEPTION"].message}' />
<img alt="" src="<%=getServletContext().getContextPath()%>/images/logo.png" style="display: none;" />
</body>
</html>