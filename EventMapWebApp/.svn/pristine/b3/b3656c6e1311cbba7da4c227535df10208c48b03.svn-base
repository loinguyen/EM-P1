<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Trang cá nhân | Bản đồ sự kiện | EventMap</title>
		<meta property="og:title" content="Trang cá nhân | Bản đồ sự kiện | EventMap" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
		<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
		<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/jquery-ui.css" />
		<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/userProfile.css" />
		<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/demo_table.css" />
		<link href="<%=getServletContext().getContextPath()%>/css/normalize.css" rel="stylesheet" type="text/css"/>
		<link href="<%=getServletContext().getContextPath()%>/css/component.css" rel="stylesheet" type="text/css"/>
		<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/datepicker.css" />
		<link rel="stylesheet" href="<%=getServletContext().getContextPath()%>/css/reset.css" media="screen">
		<link href="<%=getServletContext().getContextPath()%>/css/jquery.mCustomScrollbar.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/fancybox/jquery.fancybox.css?v=2.1.5" media="screen" />
	
		<script src="<%=getServletContext().getContextPath()%>/js/jquery-2.0.2.js"></script>
		<script src="<%=getServletContext().getContextPath()%>/js/jquery.mCustomScrollbar.js"></script>
		<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/datepicker.js"></script>
		<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/userProfile.js"></script>
		<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/jquery.pajinate.js"></script>
		<script src="<%=getServletContext().getContextPath()%>/js/modernizr.custom.js"></script>
		<script src="<%=getServletContext().getContextPath()%>/js/jquery.iframe-post-form.js"></script>
		<script type="text/javascript">
		var loggedUserId = '<s:property value="loggedUserId"/>';
		function updateUserProfile() {
			if (!validPro5Email()) return;
			$("#user-dob").val(getDateTime($("#dob").val()));
			$.ajax ({
				type: "POST",
			    url: "<%=getServletContext().getContextPath()%>/user/updateUser", 
				data: $("#userProfileForm").serialize(),
				success: function(data) {
// 				    	$("#sidebar").replaceWith($(data).find("#sidebar"));
					    	//googleInitialize();
					return false;
				    }
			});
			
			
		}
		</script>
	</head>
	<body>
		<div id="header">
			<jsp:include page="/WEB-INF/page/Header.jsp" />
		</div>
<!-- 		<div id="wrapper"> -->
			<div class="main-container block">
            <!-- LEFT-CONTAINER -->
            <div class="left-container container">
				
                <div class="menu-box block"> <!-- MENU BOX (LEFT-CONTAINER) -->
                    <!--<h2 class="titular">MENU BOX</h2>-->
                    <s:if test="%{userId == loggedUserId}">
						<a id="change-avatar" class="add-button" onclick="return false;" href="#28"><span class="icon entypo-plus scnd-font-color"></span></a>
				    </s:if>
					<div class="profile"> <!-- PROFILE (MIDDLE-CONTAINER) -->
						<div class="profile-picture big-profile-picture clean">
							<img width="150px" src="<%=getServletContext().getContextPath()%>/images/usersImages/${user.id}/avatar.jpg" >
						</div>
						<s:hidden name="user.id"/>
						<h1 class="user-name"><s:property value="user.id" /></h1>
						<div class="profile-description">
							<p class="scnd-font-color">
								<label class="join-date" title="Ngày tham gia"><fmt:formatDate value="${user.joinedDate}" pattern="dd/MM/yyyy" /></label>
							</p>
						</div>
						<ul class="profile-options horizontal-list">
							<li><a id="posts" class="comments" href="#40" title="Số bài đã đăng"><p><span name="noCreateEvent" class="icon fontawesome-map-marker scnd-font-color"></span><s:property value="user.noOfCreatedEvents" /></li></p></a>
							<li><a class="views" href="#41" title="Số bài book mark"><p><span name="noBookMarkEvent" class="icon fontawesome-bookmark-empty scnd-font-color"></span><s:property value="noOfBookmark" /></li></p></a>
							<li><a class="likes" href="#42" title="Số lượt được yêu thích"><p><span name="noLike" class="icon fontawesome-heart-empty scnd-font-color"></span><s:property value="user.noOfLikes" /></li></p></a>
						</ul>
					</div>
                    <ul class="menu-box-menu">
                        <li style="display:none;">
                            <a class="menu-box-tab" href="#6"><span class="icon fontawesome-envelope scnd-font-color"></span>Tin Nhắn<div class="menu-box-number">24</div></a>                            
                        </li>
                        <li style="display:none;">
                            <a class="menu-box-tab" href="#8"><span class="icon entypo-paper-plane scnd-font-color"></span>Invites<div class="menu-box-number">3</div></a>                            
                        </li>
                        <li style="display:none;">
                            <a class="menu-box-tab" href="#10"><span class="icon entypo-calendar scnd-font-color"></span>Events<div class="menu-box-number">5</div></a>                            
                        </li>
                        <li>
                            <a id="user-infor" class="menu-box-tab" href="#12"><span class="icon entypo-cog scnd-font-color"></span>Thông Tin</a>
                        </li>                       
                    </ul>
                </div>
            </div>
            <!-- MIDDLE-CONTAINER -->
            <div id="middle-container" class="middle-container container" style="display:none">
                <div class="weather block clean" id="paging_container"> <!-- WEATHER (MIDDLE-CONTAINER) -->
                	<ul class="next-days">
	                	<li>
	                            <a href="#43">
	                                <p class="next-days-date"><span class="day" style="width: 65%;">Tên</span></p>
	                                <p class="next-days-temperature">Ngày đăng<span class="imgIcon" style="padding-left:20px"> Thể loại</span></p>
	                            </a>
	                    </li>
                    </ul>
                    <ul id="eventList-body" class="next-days">
                        <li>
                            <a href="#43">
                                <p class="next-days-date"><span class="day">SAT</span> <span class="scnd-font-color">29/06</span></p>
                                <p class="next-days-temperature">25º<span class="icon icon-cloudy scnd-font-color"></span></p>
                            </a>
                        </li>
                        <li>
                            <a href="#44">
                                <p class="next-days-date"><span class="day">SUN</span> <span class="scnd-font-color">30/06</span></p>
                                <p class="next-days-temperature">22º<span class="icon icon-cloudy2 scnd-font-color"></span></p>
                            </a>
                        </li>
                        <li>
                            <a href="#45">
                                <p class="next-days-date"><span class="day">MON</span> <span class="scnd-font-color">01/07</span></p>
                                <p class="next-days-temperature">24º<span class="icon icon-cloudy2 scnd-font-color"></span></p>
                            </a>
                        </li>
                        <li>
                            <a href="#46">
                                <p class="next-days-date"><span class="day">TUE</span> <span class="scnd-font-color">02/07</span></p>
                                <p class="next-days-temperature">26º<span class="icon icon-cloudy scnd-font-color"></span></p>
                            </a>
                        </li>
                        <li>
                            <a href="">
                                <p class="next-days-date"><span class="day">WED</span> <span class="scnd-font-color">03/07</span></p>
                                <p class="next-days-temperature">27º<span class="icon icon-sun scnd-font-color"></span></p>
                            </a>
                        </li>
                        <li>
                            <a href="">
                                <p class="next-days-date"><span class="day">THU</span></p>
                                <p class="next-days-temperature">29º<span class="icon"><img class="imgIcon" src="<%=getServletContext().getContextPath()%>/images/categoryIcon/art.png" /></span></p>
                            </a>
                        </li>
                    </ul>
                    <div class="alt_page_navigation"></div>
                </div>
<!--                 <div class="tweets block"> TWEETS (MIDDLE-CONTAINER) -->
<%--                     <h2 class="titular"><span class="icon zocial-twitter"></span>LATEST TWEETS</h2> --%>
<!--                     <div class="tweet first"> -->
<!--                         <p>Ice-cream trucks only play music when out of ice-cream. Well played dad. On <a class="tweet-link" href="#17">@Quora</a></p> -->
<!--                         <p><a class="time-ago scnd-font-color" href="#18">3 minutes ago</a></p> -->
<!--                     </div> -->
<!--                     <div class="tweet"> -->
<!--                         <p>We are in the process of pushing out all of the new CC apps! We will tweet again once they are live <a class="tweet-link" href="#19">#CreativeCloud</a></p> -->
<!--                         <p><a class="scnd-font-color" href="#20">6 hours ago</a></p> -->
<!--                     </div> -->
<!--                 </div> -->
            </div>

            <!-- RIGHT-CONTAINER -->
            <div id="right-container" class="right-container container">
            	<form id="userProfileForm">
                <div class="join-newsletter block"> <!-- JOIN NEWSLETTER (RIGHT-CONTAINER) -->
                    <h2 class="titular"><fmt:message key='label.user.profile' /></h2>
                    <div class="input-container">
                      <div>
					   <span class="input-label"><fmt:message key="label.common.email"/></span>
                       <input id="user-email" type="text" placeholder="yourname@gmail.com" class="email text-input" name="user.email" value="<s:property value="user.email"/>" >
					   </div>
					   <div>
						   <span  class="input-label"><fmt:message key="label.common.gender"/></span>
						   <span class="custom-dropdown">
								<select name= "user.sex">
								<s:if test='%{user.sex == "M"}'>
									<option value='M' selected>Nam</option>
								</s:if>
								<s:else>
									<option value='M' >Nam</option>
								</s:else>
								<s:if test='%{user.sex == "F"}'>
									<option value='F' selected>Nữ</option>
								</s:if>
								<s:else>
									<option value='F' >Nữ</option>
								</s:else>
								<s:if test='%{user.sex == "O"}'>
									<option value='O' selected>Khác</option>
								</s:if>
								<s:else>
									<option value='O' >Khác</option>
								</s:else>
								</select>
							</span>
					   </div>
					   <div>
						   <span  class="input-label"><fmt:message key="label.common.dob"/></span>
						   <input id="dob" type="text" placeholder="" class="email text-input" value="<fmt:formatDate value="${user.dob}" pattern="dd-MM-yyyy" />" >
					   </div>
					   <div>
						   <span  class="input-label"><fmt:message key="label.common.address"/></span>
						   <input type="text" placeholder="" class="email text-input" name="user.address" value="<s:property value="user.address" />">
					   </div>
					   <div>
						   <span  class="input-label"><fmt:message key="label.common.job"/></span>
						   <input type="text" placeholder="" class="email text-input" name="user.job" value="<s:property value="user.job" />">
					   </div>
                    </div>
					<s:if test="%{userId == loggedUserId}">
                    <a id="btn-save" class="subscribe button" href="#21" style="display:none;" >Lưu thay đổi</a>
                    <a id="btn-cancel" class="subscribe button" href="#21" style="display:none;" onclick="return false">Hủy</a>
                    <a id="btn-edit"  class="subscribe button" href="#21" onclick="return false">Thay đổi</a>
					</s:if>
                </div>
                </form>
				<s:if test="%{userId == loggedUserId}">
				<form id="changepwd-form">
                <div class="account block"> <!-- ACCOUNT (RIGHT-CONTAINER) -->
                    <h2 class="titular">Mật Khẩu</h2>
                    <div class="input-container">
						<span  class="input-label"><fmt:message key="label.common.password.old"/></span>
                        <input type="password" class="email text-input"  name="user.password" id="oldpwd">
						<div id="err_oldpwd" class="passr-err"></div>
                    </div>
                    <div class="input-container">
						<span  class="input-label"><fmt:message key="label.common.password.new"/></span>
                        <input class="password text-input" type="password" name="newpwd" id="newpwd">
						<div id="err_newpwd" class="pass-err"></div>
                    </div>
					<div class="input-container">
						<span  class="input-label"><fmt:message key="label.common.password.new.confirm"/></span>
                        <input class="password text-input" type="password" id="cfnewpwd" disabled="disabled"">
						<div id="err_cfpwd" class="pass-err"></div>
                    </div>
                    <a id="btn-changepwd" class="sign-in button" href="#22"><fmt:message key="label.common.edit"/></a>
					<div id="changepwd-loading" class="loadingImg" style="display: none"></div>
                </div>
				</form>
				</s:if>
            </div> <!-- end right-container -->
        </div> <!-- end main-container -->
<!-- 		</div> -->
	</body>
	<form action="<%=getServletContext().getContextPath()%>/upload" method="post" enctype="multipart/form-data" id="ava-upload" target="targetUpload" style="display: none;">
		<input type="file" name="file" id="avatar" accept="image/*" />
		<s:checkbox name="avatar" value="true"></s:checkbox>
	</form>
	<iframe id="targetUpload" name="targetUpload" style="display: none;"></iframe>
</html>