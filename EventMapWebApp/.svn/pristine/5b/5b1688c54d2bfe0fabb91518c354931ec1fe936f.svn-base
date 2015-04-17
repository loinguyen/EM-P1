<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class=" js no-touch cssanimations csstransforms csstransforms3d csstransitions">
<head>
<sx:head />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/tinymce/tinymce.min.js"></script>
<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/jquery-2.0.2.min.js"></script>
<script type="text/javascript" charset="utf-8">
	tinymce.init({
	    selector: "textarea",
	    theme: "modern",
	    plugins: [
	        "advlist autolink lists link image charmap print preview hr anchor pagebreak",
	        "searchreplace wordcount visualblocks visualchars code fullscreen",
	        "insertdatetime media nonbreaking save table contextmenu directionality",
	        "emoticons template paste textcolor"
	    ],
	    toolbar1: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image",
	    toolbar2: "print preview media | forecolor backcolor emoticons",
	    image_advtab: true
	});
	function saveEvent() {
		tinymce.triggerSave();
		$.ajax ({
			type: "POST",
		    url: "<%=request.getContextPath()%>/event/saveEvent", 
		    data: $('#eventDetailsForm').serialize(),
		    success: function(data) {
		    	if (data.event == null) {
		    		$("#returnPic").attr("src","<%=getServletContext().getContextPath()%>/images/notOk.jpg");
		    	} else {
		    		$("#returnPic").attr("src","<%=getServletContext().getContextPath()%>/images/ok.jpg");
		    	}
		    	$("#returnPic").show();
		    	setTimeout(function(){$("#returnPic").hide();}, 3000);
		    }
		});
	}
	function updateEvent() {
		tinymce.triggerSave();
		$.ajax ({
			type: "POST",
		    url: "<%=request.getContextPath()%>/event/updateEvent", 
		    data: $('#eventDetailsForm').serialize(),
		    success: function(data) {
		    	if (data.event == null) {
		    		$("#returnPic").attr("src","<%=getServletContext().getContextPath()%>/images/notOk.jpg");
		    	} else {
		    		$("#returnPic").attr("src","<%=getServletContext().getContextPath()%>/images/ok.jpg");
		    	}
		    	$("#returnPic").show();
		    	setTimeout(function(){$("#returnPic").hide();}, 3000);
		    }
		});
	}
</script>
</head>
<body>
	<div style="color: blue; font-weight: ;">Đây là form tạo data nên không có validation gì cả nhé ;) Đội test tạo data thì điền hết vào các trường bắt buộc như yêu cầu, tránh gây lỗi không đáng có.</div>
	<form name="demoform" id="eventDetailsForm">
		<s:hidden name="event.id"/>
		<s:hidden name="event.createdDate"/>
		<s:hidden name="event.rank"/>
		<s:hidden name="event.tag"/>
		<div style="float: left; width: 30%">
			<table>
				<tr>
					<td>
						<s:textfield name="event.userId" label="User" readonly="true" />
					</td>
				</tr>
				<tr>
					<td>
						<s:textfield name="event.title" label="Title"/>
					</td>
				</tr>
				<tr>
					<td>
						<s:textfield name="event.category" label="Category" />
					</td>
				</tr>
				<tr>
					<td>
						<s:textfield name="location" label="Location" />
					</td>
				</tr>
				<tr>
					<td>
						<s:textfield name="event.address" label="Address" />
					</td>
				</tr>
				<tr>
					<td>
						<s:textfield name="event.contact" label="Contact" />
					</td>
				</tr>
				<tr>
					<td>
						<s:textfield name="event.album" label="Album" />
					</td>
				</tr>
				<tr>
					<td>
						<sx:datetimepicker name="event.fromDate" displayFormat="dd-MM-yyyy" label="Date from" required="true"/>
					</td>
				</tr>
				<tr>
					<td>
							<sx:datetimepicker name="event.toDate" displayFormat="dd-MM-yyyy" label="Date to" required="true"/>
					</td>
				</tr>
				<tr>
					<td>
						<s:select name="event.type" list="eventTypeList" listKey="value" listValue="description" label="Type" />
					</td>
				</tr>
			</table>
			
			<s:if test="%{event.id != null}">
				<input type="button" value="Update" onclick="updateEvent()" />
			</s:if> <s:else>
				<input type="button" value="Add" onclick="saveEvent()" />
			</s:else>
			<input type="reset" value="Clear form"/>
			<a href="<%=getServletContext().getContextPath()%>/event/listEvents">List events</a>
			<br />
			<img id="returnPic" width="250px" />
		</div>
		<div style="float: left; width: 70%">
			<table>
				<tr>
					<td>
						<s:textarea rows="8" cols="100" name="event.shortDes" id="shortDes" label="Short Des" />
					</td>
				</tr>
				<tr>
					<td>
						<s:textarea rows="12" cols="100" name="event.fullDes" id="fullDes" label="Full Des" />
					</td>
				</tr>
			</table>
		</div>
	</form>
	
	<img src="<%=getServletContext().getContextPath()%>/images/ok.jpg" style="display: none;"/>
	<img src="<%=getServletContext().getContextPath()%>/images/notOk.jpg" style="display: none;"/>
</body>
</html>