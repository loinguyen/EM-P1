<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Eventmap Administration</title>
	<link rel="stylesheet" href="<%=getServletContext().getContextPath()%>/css/reset.css" media="screen">
	<link rel="stylesheet" href="<%=getServletContext().getContextPath()%>/css/admin.login.css" media="screen">
	<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/jquery-2.0.2.min.js"></script>
	<script type="text/javascript">
	$(document).ready(function() {
		$("li").click(function () {
			$("li.current").toggleClass("current");
			$(this).toggleClass("current");
		});
	} );
	</script>
</head>
<body>
	<s:actionerror />
		<div id="panel">
	        <div id="container" class="logincontainer" style="height: 675px;">
				<header>
					<!-- Logo -->
					<h1 id="logo"><fmt:message key="label.admincp" /></h1>
				</header>
	        
				<!-- The application "window" -->
	            <div id="application">
					<nav id="secondary">
					  <ul>
						<li class="current"><a href="#"><fmt:message key="label.common.login" /></a></li>
					  </ul>
					</nav>
				  
					<!-- The content -->
					<section id="content">
						<c:if test="${param.error != null}">
							<div class="errorblock">
								${sessionScope["SPRING_SECURITY_LAST_EXCEPTION"].message}
							</div>
						</c:if>
						<br><br>
						<form id="loginForm" action="<c:url value='j_spring_security_check' />" method="post">
						  <section>
							<label for="username"><fmt:message key="label.common.username" /></label>							
							<div>
							  <input type="text" name="j_username" id="j_username" placeholder="<fmt:message key="label.common.username" />" class="required">
							</div>
						  </section>
						  
						  <section>
							<label for="password"><fmt:message key="label.common.password" /></label>
							
							<div>
							  <input type="password" name="j_password" id="j_password" placeholder="<fmt:message key="label.common.password" />" class="required">
							  <br><br>
							  <input type="submit" value="<fmt:message key="label.common.login" />" class="button">
							</div>
							<div>
								<input type="checkbox" name="_spring_security_remember_me" id="_spring_security_remember_me"/>
								<fmt:message key="label.common.rememberme"/>	 
							</div>
						  </section>
						</form>
					</section>
				</div>
	        </div>
		</div>
</body>
</html>