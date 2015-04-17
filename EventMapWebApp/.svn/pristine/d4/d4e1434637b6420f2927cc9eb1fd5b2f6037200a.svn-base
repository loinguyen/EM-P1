<%@page import="vn.com.lco.webapp.Constants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class=" js no-touch cssanimations csstransforms csstransforms3d csstransitions">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Event List</title>
	<link rel="stylesheet" href="<%=getServletContext().getContextPath()%>/css/reset.css" media="screen">
	<link rel="stylesheet" href="<%=getServletContext().getContextPath()%>/css/admin.style.css" media="screen">
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/admin.nav.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/jquery-ui.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/demo_page.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/demo_table_jui.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/basic.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/fancybox/jquery.fancybox.css?v=2.1.5" media="screen" />
	<style>
		#dialog-form label, #dialog-form input { display:block; }
		#send-form label, #send-form input { display:block; }
		#rank-form label, #rank-form input { display:block; }
		input.text { margin-bottom:12px; width:95%; padding: .4em; }
		fieldset { padding:0; border:0; margin-top:25px; }
		div#users-contain { width: 350px; margin: 20px 0; }
		div#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }
		div#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }
		.ui-dialog .ui-state-error { padding: .3em; }
		.validateTips { border: 1px solid transparent; padding: 0.3em; }
		#event-table_wrapper {width: 100% !important}
		td {padding-right: 10px;}
		.hidden{display: none;}
		.dataTables_paginate{margin-top: 20px !important}
		.dataTables_filter{padding-bottom: 20px;padding-top: 10px;float: none;}
	</style>
	<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/jquery-2.0.2.min.js"></script>
	<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/jquery-ui.js"></script>
	<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/tinymce/tinymce.min.js"></script>
	<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/jquery.dataTables.columnFilter.js"></script>
	<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/jquery.simplemodal.js"></script>
	<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/basic.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery.fancybox.js"></script>
	<script type="text/javascript" charset="utf-8">
	$.getJSON("<%=request.getContextPath()%>/event/loadListEvents", 
				function(json) {
				// define configuration table
				var oTable_user = $('#event-table').dataTable( {
// 					"oLanguage": {
<%-- 			            "sUrl": "<%=request.getContextPath()%>/js/dataTables.vi.txt" --%>
// 			        },
// 					"sDom": 'R<"H"lr>t<"F"ip>',
					"aaData": json.aaData,
					"bAutoWidth": false,
					"bStateSave": true,
					"bDestroy": true,
					"bProcessing": true,
					"bDeferRender": true,
					"bLengthChange": false,
					 "aoColumns": [ 
				                   { "fnRender": function(oObj) {
			                    		 return "<a href='javascript://' onclick='javascript:showEvent(\"" + oObj.aData[11] + "\")'>" + oObj.aData[0] + "</a>";	 
				                    	 },
				                     "bSortable": false },
				                   { 
// 			                    	 "fnRender": function(oObj) {
// 			                    		 return "<a href='javascript://' onclick='javascript:reportEvent(\"" + oObj.aData[11] + "\")'>" + oObj.aData[1] + "</a>";	 
// 			                    	 }, 
			                    	 "bSortable": false },
			                    	 { "sClass": "hidden" },
				                   { "bSortable": false },
				                   { "bSortable": false },
				                   { "sClass": "hidden" },
				                   { "bSortable": false },
				                   { "bSortable": false },
				                   { "bSortable": false },
				                   { "bSortable": false },
				                   { "sClass": "hidden" },
				                   { "bSortable": false, "sClass": "hidden" }],
					"sPaginationType": "full_numbers",
// 					"iDisplayLength": 17,
					"fnInitComplete": function() {
						oTable_user.fnSort([[10, "desc"]]);
					}
				} );
			}
	);
	
	function showEvent(eId) {
		$.fancybox({
            width: '100%',
            height: '100%',
            autoScale: true,
            transitionIn: 'fade',
            transitionOut: 'fade',
            type: 'iframe',
        	autoSize:false, 
            href: '<%=request.getContextPath()%>/event/eventDetail?id=' + eId
	 });
	}
	function reportEvent(eId) {
		$("#eventId").val(eId);
		$('#basic-modal-content').modal();
// 		tinymce.init({
// 		    selector: "textarea",
// 		    theme: "modern",
// 		    plugins: [
// 		        "advlist autolink lists link image charmap print preview hr anchor pagebreak",
// 		        "searchreplace wordcount visualblocks visualchars code fullscreen",
// 		        "insertdatetime media nonbreaking save table contextmenu directionality",
// 		        "emoticons template paste textcolor"
// 		    ],
// 		    toolbar1: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image",
// 		    toolbar2: "print preview media | forecolor backcolor emoticons",
// 		    image_advtab: true
// 		});
	}
	function submitReport() {
		$.ajax ({
			type: "POST",
		    url: "<%=request.getContextPath()%>/event/reportEvent", 
		    data: $('#reportFrom').serialize(),
		    success: function(data) {
		    	if (data.event == null) {
		    		alert('Lỗi cmn gì đó rồi nhé!');
		    	} else {
		    		alert("Reported");
		    		$('.simplemodal-close').click();
		    	}
		    }
		});
	}

	</script>
</head>
<body>
	<table id="event-table" style="width: 100% !important">
		<thead>
			<tr>
				<th>TITLE</th>
				<th>CATEGORY</th>
				<th>LOCATION</th>
				<th>ADDRESS</th>
				<th>CONTACT</th>
				<th>ALBUM</th>
				<th>USERID</th>
				<th>TYPE</th>
				<th>FROMDATE</th>
				<th>TODATE</th>
			</tr>
		</thead>

	</table>
</body>
<div id="basic-modal-content">
	<s:form name="reportForm" id="reportFrom">
		<table>
			<tr>
				<td>
					<s:hidden name="event.id" id="eventId"></s:hidden>
				</td>
			</tr>
			<tr>
				<td>
					<s:textarea rows="5" cols="40" name="report.content" label="Nội dung" />
				</td>
			</tr>
			<tr>
				<td>
					<input type="button" value="Report" onclick="submitReport()"/>
				</td>
			</tr>
		</table>
	</s:form>
</div>
</html>