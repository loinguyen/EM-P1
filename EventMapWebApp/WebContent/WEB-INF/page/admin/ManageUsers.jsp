<%@page import="vn.com.lco.webapp.Constants"%>
<%@page import="vn.com.lco.webapp.action.admin.AdminLoginAction"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class=" js no-touch cssanimations csstransforms csstransforms3d csstransitions">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Eventmap Administration</title>
	<link rel="stylesheet" href="<%=getServletContext().getContextPath()%>/css/reset.css" media="screen">
	<link rel="stylesheet" href="<%=getServletContext().getContextPath()%>/css/admin.style.css" media="screen">
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/admin.nav.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/jquery-ui.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/demo_page.css" />
	<link rel="stylesheet" type="text/css" href="<%=getServletContext().getContextPath()%>/css/demo_table_jui.css" />
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
		table tfoot {display: none}
		div#rank-table_paginate {margin-top: 10px !important;}
		div#user-table_paginate {margin-top: 10px !important;}
	</style>
	<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/jquery-2.0.2.min.js"></script>
	<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/jquery-ui.js"></script>
	<script type="text/javascript" src="<%=getServletContext().getContextPath()%>/js/common.js"></script>
	<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="<%=getServletContext().getContextPath()%>/js/jquery.dataTables.columnFilter.js"></script>
	<script src="<%=getServletContext().getContextPath()%>/js/jquery.fancybox.js"></script>
	<script type="text/javascript" charset="utf-8">
	/*-- Return an array of table values from a particular column. --*/
	(function($) {
		/*
		 * Function: fnGetColumnData
		 * Purpose:  Return an array of table values from a particular column.
		 * Returns:  array string: 1d data array 
		 * Inputs:   object:oSettings - dataTable settings object. This is always the last argument past to the function
		 *           int:iColumn - the id of the column to extract the data from
		 *           bool:bUnique - optional - if set to false duplicated values are not filtered out
		 *           bool:bFiltered - optional - if set to false all the table data is used (not only the filtered)
		 *           bool:bIgnoreEmpty - optional - if set to false empty values are not filtered from the result array
		 * Author:   Benedikt Forchhammer <b.forchhammer /AT\ mind2.de>
		 */
		$.fn.dataTableExt.oApi.fnGetColumnData = function ( oSettings, iColumn, bUnique, bFiltered, bIgnoreEmpty ) {
			// check that we have a column id
			if ( typeof iColumn == "undefined" ) return new Array();
			
			// by default we only want unique data
			if ( typeof bUnique == "undefined" ) bUnique = true;
			
			// by default we do want to only look at filtered data
			if ( typeof bFiltered == "undefined" ) bFiltered = true;
			
			// by default we do not want to include empty values
			if ( typeof bIgnoreEmpty == "undefined" ) bIgnoreEmpty = true;
			
			// list of rows which we're going to loop through
			var aiRows;
			
			// use only filtered rows
			if (bFiltered == true) aiRows = oSettings.aiDisplay; 
			// use all rows
			else aiRows = oSettings.aiDisplayMaster; // all row numbers
		
			// set up data array	
			var asResultData = new Array();
			
			for (var i=0,c=aiRows.length; i<c; i++) {
				iRow = aiRows[i];
				var aData = this.fnGetData(iRow);
				var sValue = aData[iColumn];
				
				// ignore empty values?
				if (bIgnoreEmpty == true && sValue.length == 0) continue;
		
				// ignore unique values?
				else if (bUnique == true && jQuery.inArray(sValue, asResultData) > -1) continue;
				
				// else push the value onto the result data array
				else asResultData.push(sValue);
			}
			
			return asResultData;
		}
	}(jQuery));
	
	/*-- Create event report detail div---*/
	function fnCreateEventReportDetail(id) {
		if (id == "") {
			$("#no-event-warnning").prop("hidden","");
			document.getElementById("done-report").disabled = true;
			document.getElementById("create-message").disabled = true;
		} else {
			$("#event-title").html("<img src='<%=request.getContextPath()%>/images/admin/loading.gif' />");
			$.ajax ({
				type: "POST",
			    url: "<%=request.getContextPath()%>/admin/adminCreateEventReportDetail", 
			    data: {reportId: id},
			    success: function(data) {
			    	if (data.actionErrors.length > 0) {
			    		alert(data.actionErrors);
			    	} else {
				    	$("#event-title").html(data.eventTitle).attr("eId", data.eventId);
				    	$("#event-creator").html(data.eventUid);
				    	$("#listReport").html(data.reports);
				    	$("#reportId").val(data.reportId);
				    	document.getElementById("done-report").disabled = false;
						document.getElementById("create-message").disabled = false;
			    	}
			    }
			});
		}	
	}
	
	/*-- Create element select for filter --*/
	function fnCreateSelect( aData, id ) {
		var r='<select id="' + id + '"><option value="">Danh mục</option>', i, iLen=aData.length;
		for ( i=0 ; i<iLen ; i++ )
		{
			r += '<option value="'+aData[i]+'">'+aData[i]+'</option>';
		}
		return r+'</select>';
	}
	
	function loadUsers() {
		$.getJSON("<%=request.getContextPath()%>/admin/loadListUser", 
			function(json) {
			
				// define configuration table
				var oTable_user = $('#user-table').dataTable( {
					"sDom": 'R<"H"lr>t<"F"ip>',
						"aaData": json.aaData,
					"bAutoWidth": false,
					"aoColumns": [
						{ "sWidth": "30%" },
						{ "sWidth": "30%" },
						{ "sWidth": "15%", "sClass": "center" },
						{ "sWidth": "15%", "sClass": "center" },
						{ "sWidth": "10%", "sClass": "center" },
					],
// 					"bStateSave": true,
					"bDestroy": true,
					"bProcessing": true,
					"bDeferRender": true,
					"bLengthChange": false,
					"sPaginationType": "full_numbers",
					"iDisplayLength": 17,
					"fnInitComplete": function() {
						setEditButton( $('#user-table').dataTable());
					}
				} );
				
				// define filter table
				// filter by textbox
				var asInitVals_user = new Array();
				$("#user-table thead input[type='text']").keyup( function () {
					/* Filter on the column (the index) of this element */
					oTable_user.fnFilter( this.value, $("#user-table thead input[type='text']").index(this) );
				} );
				
				$("#user-table thead input[type='text']").each( function (i) {
					asInitVals_user[i] = this.value;
				} );
				
				$("#user-table thead input[type='text']").focus( function () {
					if ( this.className == "search_init" )
					{
						this.className = "";
						this.value = "";
					}
				} );
				
				$("#user-table thead input[type='text']").blur( function (i) {
					if ( this.value == "" )
					{
						this.className = "search_init";
						this.value = asInitVals_user[$("#user-table thead input[type='text']").index(this)];
					}
				} );
				$(oTable_user).bind( 'draw', function(){setEditButton( $('#user-table').dataTable());} );
			}
		);
	}
	function setEditButton(oTable) {
		$( ".edit-user" ).click(function() {
			$( "#edit-user-form" ).dialog( "open" );
		});
		/*-- when edit user --*/
		$(".edit-user").click( function () {
			var rowIndex = oTable.fnGetPosition( $(this).closest('tr')[0] );
			var data = oTable.fnGetData( rowIndex );
			var newOptions;
			$("#editname").val(data[0]);
			if(data[3]=='<%=Constants.UserRoles.ROLE_BAN%>') {
				newOptions = {"<%=Constants.UserRoles.ROLE_MEMBER%>": "<fmt:message key='label.common.role.member' />",
						"<%=Constants.UserRoles.ROLE_BAN%>": "<fmt:message key='label.common.role.banned' />"
						};
			} else {
				newOptions = {"<%=Constants.UserRoles.ROLE_INACTIVE%>": "<fmt:message key='label.common.role.inactive' />",
						"<%=Constants.UserRoles.ROLE_MEMBER%>": "<fmt:message key='label.common.role.member' />",
						"<%=Constants.UserRoles.ROLE_BAN%>": "<fmt:message key='label.common.role.banned' />",
						"<%=Constants.UserRoles.ROLE_MOD%>": "<fmt:message key='label.common.role.mod' />",
						"<%=Constants.UserRoles.ROLE_ADMIN%>": "<fmt:message key='label.common.role.admin' />"
				};

				
				/*-- when click ban checkbox in edit user dialog --*/
			}
			
			$("#role").empty();
			$.each(newOptions, function(value, key) {
				$("#role").append($("<option></option>")
				     .attr("value", value).text(key));
			});
			$("#role").val(data[3]);
			$("#role").change(function() {
				if ($("#role").val() == "<%=Constants.UserRoles.ROLE_BAN%>") {
					$("#edit-toDate").show();
				}
			});
		});
	}

	// define configuration table
	function loadListReport(){
		$.getJSON("<%=request.getContextPath()%>/admin/loadListReport",
				function(json) {
					var populate = true;
					var oTable_report = $('#report-table').dataTable( {
						"sDom": 'R<"H"lr>t<"F"ip>',
						"aaData": json.aaData,
						"bAutoWidth": false,
						"aoColumns": [
							{ "fnRender": function(oObj) {
								 if (populate) {
									 fnCreateEventReportDetail(oObj.aData[3]);
									 populate = false;
								 }
			               		 return oObj.aData[0];	 
			               	 }, "sWidth": "60%" },
							{ "sWidth": "15%", "sClass": "center" },
							{ "sWidth": "15%", "sClass": "center" }
						],
// 						"bStateSave": true,
						"bDestroy": true,
						"bProcessing": true,
						"bDeferRender": true,
						"bLengthChange": false,
						"sPaginationType": "full_numbers",
						"iDisplayLength": 17
					} );
					
					// filter by category event
					$("th#event_report").html(fnCreateSelect( oTable_report.fnGetColumnData(1), "cat_event_report" ));
					$("th#event_report #cat_event_report").change( function () {
						oTable_report.fnFilter( $("th#event_report #cat_event_report").val(), 1 );
					} );
					// define filter table
					// filter by title event has report
					var asInitVals_report = new Array();
					$("#report-table thead input[type='text']").keyup( function () {
						/* Filter on the column (the index) of this element */
						oTable_report.fnFilter( this.value, $("#report-table thead input[type='text']").index(this) );
					} );
					
					$("#report-table thead input[type='text']").each( function (i) {
						asInitVals_report[i] = this.value;
					} );
					
					$("#report-table thead input[type='text']").focus( function () {
						if ( this.className == "search_init" )
						{
							this.className = "";
							this.value = "";
						}
					} );
					
					$("#report-table thead input[type='text']").blur( function (i) {
						if ( this.value == "" )
						{
							this.className = "search_init";
							this.value = asInitVals_report[$("#report-table thead input[type='text']").index(this)];
						}
					} );
			}
		);
	}
	
	function loadTempEvent() {
		$.getJSON("<%=request.getContextPath()%>/event/getTmpEvents", 
			function(json) {
			var populate = true;
			// define configuration table
			  var oTable_event = $('#event-table').dataTable( {
				"sDom": 'R<"H"lr>t<"F"ip>',
				"aaData": json.aaData,
				"bAutoWidth": false,
				"aoColumns": [
					{ "fnRender": function(oObj) {
							 if (populate) {
								 reviewTempEvent(oObj.aData[4]);
								 populate = false;
							 }
		               		 return "<a href='javascript://' onclick='javascript:reviewTempEvent(\"" + oObj.aData[4] + "\")'>" + oObj.aData[0] + "</a>";	 
		               	 },
		              "sWidth": "55%" },
					{ "sWidth": "15%" },
					{ "sWidth": "15%", "sClass": "center" },
					{ "sWidth": "15%", "sClass": "center" }
				],
// 				"bStateSave": true,
				"bDestroy": true,
				"bProcessing": true,
				"bDeferRender": true,
				"bLengthChange": false,
				"sPaginationType": "full_numbers",
				"iDisplayLength": 17,
				"fnInitComplete": function() {
// 					oTable_event.fnSort([[3, "asc"]]);
				}
			} );
		  
		// filter by category event
		$("th#event").html(fnCreateSelect( oTable_event.fnGetColumnData(2), "cat_event" ));
		$("th#event #cat_event").change( function () {
			oTable_event.fnFilter( $("th#event #cat_event").val(), 2 );
		} );
		
		// filter by title event
		var asInitVals_event = new Array();
		$("#event-table thead input[type='text']").keyup( function () {
			/* Filter on the column (the index) of this element */
			oTable_event.fnFilter( this.value, $("#event-table thead input[type='text']").index(this) );
		} );
		
		$("#event-table thead input[type='text']").each( function (i) {
			asInitVals_event[i] = this.value;
		} );
		
		$("#event-table thead input[type='text']").focus( function () {
			if ( this.className == "search_init" )
			{
				this.className = "";
				this.value = "";
			}
		} );
		
		$("#event-table thead input[type='text']").blur( function (i) {
			if ( this.value == "" )
			{
				this.className = "search_init";
				this.value = asInitVals_event[$("#event-table thead input[type='text']").index(this)];
			}
		} );
		
		});
	}
	
	function loadEventRank() {
		/*-- show rank table --*/
		$.getJSON("<%=request.getContextPath()%>/event/loadListEvents",
			function(json) {
				// define configuration table
				var oTable_rank = $('#rank-table').dataTable( {
					"sDom": 'R<"H"lr>t<"F"ip>',
					"aaData": json.aaData,
					"bAutoWidth": false,
					"aoColumns": [
						{ "sWidth": "50%" },
						{ "sWidth": "15%" },
						{ "fnRender": function(oObj) {return oObj.aData[6];}, 
				 		   "sWidth": "15%", "sClass": "center" },
						{ "fnRender": function(oObj) {return oObj.aData[12];},
                  		  "sWidth": "10%", "sClass": "center" },
						{ "fnRender": function(oObj) {
					                   		 return "<a href='javascript://' onclick='javascript:promoteEvent(\"" + oObj.aData[11] + "\"," + oObj.aData[12] + ")'>Promote</a>";	 
					                    },
                   	 	 "sWidth": "10%", "sClass": "center" },
					],
// 					"bStateSave": true,
					"bDestroy": true,
					"bProcessing": true,
					"bDeferRender": true,
					"bLengthChange": false,
					"sPaginationType": "full_numbers",
					"iDisplayLength": 17,
				} );
				
				// filter by category event
				$("th#event_rank").html(fnCreateSelect( oTable_rank.fnGetColumnData(1), "cat_event_rank" ));
				$("th#event_rank #cat_event_rank").change( function () {
					oTable_rank.fnFilter( $("th#event_rank #cat_event_rank").val(), 1 );
				} );
				
				// define filter table
				// filter by title event
				var asInitVals_rank = new Array();
				$("#rank-table thead input[type='text']").keyup( function () {
					/* Filter on the column (the index) of this element */
					oTable_rank.fnFilter( this.value, $("#rank-table thead input[type='text']").index(this) );
				} );
				
				$("#rank-table thead input[type='text']").each( function (i) {
					asInitVals_rank[i] = this.value;
				} );
				
				$("#rank-table thead input[type='text']").focus( function () {
					if ( this.className == "search_init" )
					{
						this.className = "";
						this.value = "";
					}
				} );
				
				$("#rank-table thead input[type='text']").blur( function (i) {
					if ( this.value == "" )
					{
						this.className = "search_init";
						this.value = asInitVals_rank[$("#rank-table thead input[type='text']").index(this)];
					}
				} );
		});
	}
	
	function promoteEvent(id, currRank) {
		$("#rank").val(currRank);
		$("#eventid4promote").val(id);
		$( "#rank-form" ).dialog( "open" );
	}
	
	function reviewTempEvent(id) {
		clearTmpEventDetail();
		$("#tempTitle").html("<img src='<%=request.getContextPath()%>/images/admin/loading.gif' />");
		$.ajax ({
			type: "POST",
		    url: "<%=request.getContextPath()%>/event/getTempEvent", 
		    data: {"tmpEvent.id": id},
		    success: function(data) {
		    	if (data.tmpEvent == null) {
		    		alert('Error');
		    	} else {
		    		var titlehtml = "<a href='javascript:showEvent(\"" + data.tmpEvent.eventId + "\")'>" + data.tmpEvent.title + "</a>";
		    		$("#tempTitle").html(titlehtml);
		    		$("#tempUser").html(data.tmpEvent.userId);
		    		$("#tempAddress").val(data.tmpEvent.address);
		    		$("#tempId").val(data.tmpEvent.id);
		    		$("#tempCat").val(data.tmpEvent.category);
		    		$("#tempDate").val(data.tmpEvent.fromDate + " - " + data.tmpEvent.toDate);
		    		$("#tempShortDes").html(data.tmpEvent.shortDes);
		    		$("#tempFullDes").html(data.tmpEvent.fullDes);
		    	}
		    }
		});
	}
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
	function reviewTempEventAction(status) {
		$.ajax ({
			type: "POST",
		    url: "<%=request.getContextPath()%>/event/updateTempEvent", 
		    data: {"tmpEvent.id": $("#tempId").val(), "tmpEvent.status": status},
		    success: function(data) {
		    	if (data.event == null) {
		    		alert('Error');
		    	} else {
		    		loadTempEvent();
		    		clearTmpEventDetail();
		    	}
		    }
		});
	}
	
	function clearTmpEventDetail() {
		$("#tempTitle").html("");
		$("#tempUser").html("");
		$("#tempAddress").val("");
		$("#tempId").val("");
		$("#tempCat").val("");
		$("#tempDate").val("");
		$("#tempShortDes").html("");
		$("#tempFullDes").html("");
	}
	
	/*-- Init element --*/
	$(document).ready( function () {
		/*-- show/hide for animation of site  --*/
		$(".user").show();
		$(".report").hide();
		$(".event").hide();
		$(".rank").hide();
		$("#toDate").hide();
		$("#edit-toDate").hide();
		$("#create-message").hide();
		
		loadUsers();
// 		loadListReport();
// 		loadTempEvent();
// 		loadEventRank();
		
		/*-- when click menu Manage User --*/
		$(".ca-menu li#liUser").click(function(){
			$("#titleBar").html("<h1>Manage User</h1>");
			$(".user").show("slow", "swing");
			$(".report").hide("slow", "swing");
			$(".event").hide("slow", "swing");
			$(".rank").hide("slow", "swing");			
			loadUsers();
		});
		
		/*-- when click menu Manage Report --*/
		$(".ca-menu li#liReport").click(function(){
			$("#titleBar").html("<h1>Manage Report</h1>");
			$(".user").hide("slow", "swing");
			$(".report").show("slow", "swing");
			$(".event").hide("slow", "swing");
			$(".rank").hide("slow", "swing");
			document.getElementById("done-report").disabled = true;
			document.getElementById("create-message").disabled = true;
			$("#event-title").html("No Event Selected");
			loadListReport();
			clearReportDetailForm();
			
		});
		
		/*-- when click menu Manage Event --*/
		$(".ca-menu li#liEvent").click(function(){
			$("#titleBar").html("<h1>Manage Event</h1>");
			$(".user").hide("slow", "swing");
			$(".report").hide("slow", "swing");
			$(".event").show("slow", "swing");
			$(".rank").hide("slow", "swing");
			clearTmpEventDetail();
			loadTempEvent();
		});
		
		/*-- when click menu Manage Rank --*/
		$(".ca-menu li#liRank").click(function(){
			$("#titleBar").html("<h1>Manage Rank</h1>");
			$(".user").hide("slow", "swing");
			$(".report").hide("slow", "swing");
			$(".event").hide("slow", "swing");
			$(".rank").show("slow", "swing");
			loadEventRank();
		});
		
		/*-- when click ban checkbox in send message dialog --*/
		$("#ban").click(function(){
			if ($( this ).is (':checked')) {
				$("#toDate").show();
			} else {
				$("#toDate").hide();
			}
		});
		
		/*-- when click to screen without dialog, then dialog will be closed --*/
		$(document.body).on("click", ".ui-widget-overlay", function(){
			$.each($(".ui-dialog"), function()
			{
				var $dialog;
				$dialog = $(this).children(".ui-dialog-content");
				if($dialog.dialog("option", "modal"))
				{
					$dialog.dialog("close");
				}
			});
		});;
		
		$("#event-title").click(function(obj){
			 $.fancybox({
		            width: '100%',
		            height: '100%',
		            'autoScale': true,
		            transitionIn: 'fade',
		            transitionOut: 'fade',
		            type: 'iframe',
		        	autoSize:false, 
		            href: '<%=request.getContextPath()%>/event/eventDetail?id=' + $("#event-title").attr("eId")
			});
		});
	});
	
	/*-- Update text tips --*/
	function updateTips( tp, t ) {
		tp
			.text( t )
			.addClass( "ui-state-highlight" );
		setTimeout(function() {
			tp.removeClass( "ui-state-highlight", 1500 );
		}, 500 );
	}

	/*-- check length for fields --*/
	function checkLength( tp, o, n, min, max ) {
		if ( o.val().length > max || o.val().length < min ) {
			o.addClass( "ui-state-error" );
			updateTips( tp, "Length of " + n + " must be between " +
				min + " and " + max + "." );
			return false;
		} else {
			return true;
		}
	}

	/*-- check regular expression for fields --*/
	function checkRegexp( tp, o, regexp, n ) {
		if ( !( regexp.test( o.val() ) ) ) {
			o.addClass( "ui-state-error" );
			updateTips( tp, n );
			return false;
		} else {
			return true;
		}
	}
	
	/*-- check value of drop down list, if null or blank then return false --*/
	function checkNullOrBlank( tp, o, n ) {
		if( o.val() == null || o.val().length <= 0) {
			o.addClass( "ui-state-error" );
			updateTips( tp, n );
			return false;
		} else {
			return true;
		}
	}
	
	/*-- show dialog create new user --*/
	$(function() {
		$('#create-user-error').text("");
		var name = $( "#name" ),
			password = $( "#password" ),
			allFields = $( [] ).add( name ).add( password ),
			tips = $( ".validateTips" );

		$( "#creat-user-form" ).dialog({
			autoOpen: false,
			height: 400,
			width: 350,
			modal: true,
			buttons: {
				"Create an account": function() {
					var bValid = true;
					allFields.removeClass( "ui-state-error" );

					bValid = bValid && checkLength( tips, name, "username", 3, 16 );
					bValid = bValid && checkLength( tips, password, "password", 5, 16 );

					bValid = bValid && checkRegexp( tips, name, /^[a-z]([0-9a-z_])+$/i, "Username may consist of a-z, 0-9, underscores, begin with a letter." );
					//From jquery.validate.js (by joern), contributed by Scott Gonzalez: http://projects.scottsplayground.com/email_address_validation/
					bValid = bValid && checkRegexp( tips, password, /^([0-9a-zA-Z])+$/, "Password field only allow : a-z 0-9" );

					if ( bValid ) {
						$.ajax ({
							type: "POST",
						    url: "<%=request.getContextPath()%>/admin/adminCreateUser", 
						    data: $('#createUserForm').serialize(),
						    success: function(data) {
						    	if (data.actionErrors.length > 0) {
						    		$('#create-user-error').text(data.actionErrors);
						    	} else {
							    	loadUsers();
							    	$( "#creat-user-form" ).dialog( "close" );
						    	}
						    }
						});
						
					}
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {
				tips.text( "All form fields are required." );
				clear_form_elements($(".dialog-form"));
				allFields.val( "" ).removeClass( "ui-state-error" );
			}
		});

		$( "#create-user" )
			.button()
			.click(function() {
				$( "#creat-user-form" ).dialog( "open" );
			});
	});
	
	/*-- show dialog edit user --*/
	$(function() {
		var editname = $( "#editname" ),
			role = $( "#role" ),
			editDatepicker = $( "#edit-datepicker" ),
			reasonEditUser = $( "#reason-edit-user" ),
			allFields = $( [] ).add( editname ).add( reasonEditUser ).add( role ),
			tips = $( ".validateTips" );

		$( "#edit-user-form" ).dialog({
			autoOpen: false,
// 			height: 400,
			width: 400,
			modal: true,
			buttons: {
				"Save": function() {
					var bValid = true;
					allFields.removeClass( "ui-state-error" );

					bValid = bValid && checkLength( tips, editname, "edit name", 3, 16 );
					bValid = bValid && checkNullOrBlank( tips, role, "Must be choose role.");
					bValid = bValid && checkLength( tips, reasonEditUser, "reason edit user", 5, 400 );
					
					bValid = bValid && checkRegexp( tips, editname, /^[a-z]([0-9a-z_])+$/i, "Username may consist of a-z, 0-9, underscores, begin with a letter." );
					
					if ( bValid ) {
						
						$.ajax ({
							type: "POST",
						    url: "<%=request.getContextPath()%>/admin/adminEditUser", 
						    data: $('#editUserForm').serialize(),
						    success: function(data) {
						    	if (data.actionErrors.length > 0) {
						    		alert(data.actionErrors);
						    	} else {
							    	loadUsers();
							    	$( "#edit-user-form" ).dialog( "close" );
						    	}
						    }
						});
						$( this ).dialog( "close" );
					}
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {
				tips.text( "Some form fields are required." );
				clear_form_elements($(".dialog-form"));
				allFields.val( "" ).removeClass( "ui-state-error" );
			}
		});
	});
	
	/*-- show dialog set rank event --*/
	$(function() {
		var rank = $( "#rank" ),
			reason = $( "#reason" ),
			allFields = $( [] ).add( rank ).add( reason ),
			tips = $( ".validateTips" );

		$( "#rank-form" ).dialog({
			autoOpen: false,
			height: 350,
			width: 400,
			modal: true,
			buttons: {
				"OK": function() {
					var bValid = true;
					allFields.removeClass( "ui-state-error" );

					bValid = bValid && checkNullOrBlank( tips, rank, "Must be choose rank.");
					bValid = bValid && checkLength( tips, reason, "reason", 5, 400 );

					if ( bValid ) {
						$.ajax ({
							type: "POST",
						    url: "<%=request.getContextPath()%>/event/promoteEvent", 
						    data: $("#eventpromoteform").serialize(),
						    success: function(data) {
						    	if (data.actionErrors.length > 0) {
						    		alert(data.actionErrors);
						    	} else {
						    		loadEventRank();
							    	$( "#rank-form" ).dialog( "close" );
						    	}
						    }
						});
					}
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {
				tips.text( "Some form fields are required." );
				clear_form_elements($(".dialog-form"));
				allFields.val( "" ).removeClass( "ui-state-error" );
			}
		});
	});
	
	/*-- show dialog send message to user --*/
	$(function() {
		var toUser = $( "#toUser" ),
			subject = $( "#subject" ),
			datepicker = $( "#datepicker" ),
			mess_content = $( "#mess-content" ),
			allFields = $( [] ).add( toUser ).add( subject ).add( mess_content ),
			tips = $( ".validateTips" );

		$( "#send-form" ).dialog({
			autoOpen: false,
// 			height: 480,
			width: 420,
			modal: true,
			buttons: {
				"Send": function() {
					var bValid = true;
					allFields.removeClass( "ui-state-error" );

					bValid = bValid && checkLength( tips, toUser, "user name", 3, 16 );
					if($("#ban").val()== false){
						bValid = bValid && checkLength( tips, subject, "subject", 3, 16 );
						bValid = bValid && checkRegexp( tips, subject, /^[a-z]([0-9a-z_])+$/i, "Subject may consist of a-z, 0-9, underscores, begin with a letter." );
					}
					bValid = bValid && checkLength( tips, mess_content, "content", 5, 400 );
					
					bValid = bValid && checkRegexp( tips, toUser, /^[a-z]([0-9a-z_])+$/i, "To user may consist of a-z, 0-9, underscores, begin with a letter." );
					
					
					if ( bValid ) {
						$.ajax ({
							type: "POST",
						    url: "<%=request.getContextPath()%>/admin/reportSendMessage", 
						    data: $("#messageForm").serialize(),
						    success: function(data) {
						    	if (data.actionErrors.length > 0) {
						    		alert(data.actionErrors);
						    	} else {
						    		$( "#send-form" ).dialog( "close" );
						    	}
						    }
						});
						
					}
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {
				tips.text( "Some form fields are required." );
				clear_form_elements($(".dialog-form"));
				allFields.val( "" ).removeClass( "ui-state-error" );
			}
		});
			
		$( "#create-message" )
			.button()
			.click(function() {
				$( "#send-form" ).dialog( "open" );
				$("#toUser").val($("#event-creator").html());
			});
		$( "#done-report" )
			.button()
			.click(function() {
				done_report();
			});
		$( "#reject-update" ).button().click(function() {
			reviewTempEventAction('rejected');
		});
		$( "#approve-update" ).button().click(function() {
			reviewTempEventAction('approved');
		});
	});
	
	/*-- show date picker dialog in send message dialog --*/
	$(function() {
		$( "#datepicker" ).datepicker();
		$( "#datepicker" ).datepicker("option", "dateFormat", "dd/mm/yy" );
	});
	
	/*-- show date picker dialog in edit user dialog --*/
	$(function() {
		$( "#edit-datepicker" ).datepicker();
		$( "#edit-datepicker" ).datepicker("option", "dateFormat", "dd/mm/yy" );
	});
	
	/*-- when report was resolved --*/
	function done_report() {
		$.ajax ({
			type: "POST",
		    url: "<%=request.getContextPath()%>/admin/handleReport", 
		    data: {reportId: $("#reportId").val()},
		    success: function(data) {
		    	if (data.actionErrors.length > 0) {
		    		alert(data.actionErrors);
		    	} else {
		    		loadListReport();
		    		clearReportDetailForm();
// 			    	$( "#rank-form" ).dialog( "close" );
		    	}
		    }
		});
	}
	
	function clearReportDetailForm(){
		$("#event-title").html("No event is selected");
		$("#event-creator").html("");
    	$("#listReport").html("");
    	$("#reportId").val("");
    	document.getElementById("done-report").disabled = true;
		document.getElementById("create-message").disabled = true;
	}
	
	/*-- Reset fields of form --*/
	function clear_form_elements( form ) {
		$("#toDate").hide();
		$("#edit-toDate").hide();
		
		form.find(':input').each(function() {
			switch(this.type) {
				case 'password':
				case 'select-multiple':
				case 'select-one':
				case 'text':
				case 'textarea':
					$(this).val('');
					break;
				case 'checkbox':
				case 'radio':
					this.checked = false;
			}
		});

	}
	</script>
</head>
<body>
	<!-- Header -->
    <div id="header">
		<div id="logo">
			<a href="<%=getServletContext().getContextPath()%>">
				<div id="img"><img style="max-height: 90px;" src="<%=getServletContext().getContextPath()%>/images/logo.png"></div>
			</a>
			<a href="<%=getServletContext().getContextPath()%>">
				<div id="text"><fmt:message key="label.common.webname" /></div>
			</a>
			<a href="<c:url value='<%=getServletContext().getContextPath()+"/j_spring_security_logout"%>' />" title="Logout" >
				<div id="close-project"><img style="max-height: 70px;margin-top: 4px;" src="<%=getServletContext().getContextPath()%>/images/admin/close.png"/></div>
			</a>
			<div id="userLogin">
				<p><a href="<%=getServletContext().getContextPath()%>/user/userProfile?userId=<sec:authentication property="principal.id" />" style="color: #20FFF6;font-weight: bold;font-size: 12pt;"><sec:authentication property="principal.id" /></a></p>
				<p style="font: 0.6em arial,helvetica,clean,sans-serif;text-align:right;"><sec:authentication property="principal.role" /></p>
			</div>
		</div>
	</div>
	<!-- Content Page -->
	<div id="content">
		<!-- Title -->
		<div id="titleBar"><h1><fmt:message key="label.admin.manage.user" /></h1></div>
		<!-- Left menu -->
		<div id="pageLeft">
			<ul class="ca-menu">
				<li id="liUser">
					<a href="#">
						<span class="ca-icon">&#85;</span>
						<div class="ca-content">
							<h2 class="ca-main"><fmt:message key="label.admin.manage.user" /></h2>
							<h3 class="ca-sub"><fmt:message key="label.admin.manage.user.desc" /></h3>
						</div>
					</a>
				</li>
				<li id="liReport">
					<a href="#">
						<span class="ca-icon">&#70;</span>
						<div class="ca-content">
							<h2 class="ca-main"><fmt:message key="label.admin.manage.report" /></h2>
							<h3 class="ca-sub"><fmt:message key="label.admin.manage.report.desc" /></h3>
						</div>
					</a>
				</li>
				<li id="liEvent">
					<a href="#">
						<span class="ca-icon">&#63;</span>
						<div class="ca-content">
							<h2 class="ca-main"><fmt:message key="label.admin.manage.event" /></h2>
							<h3 class="ca-sub"><fmt:message key="label.admin.manage.event.desc" /></h3>
						</div>
					</a>
				</li>
				<li id="liRank">
					<a href="#">
						<span class="ca-icon">&#126;</span>
						<div class="ca-content">
							<h2 class="ca-main"><fmt:message key="label.admin.manage.rank" /></h2>
							<h3 class="ca-sub"><fmt:message key="label.admin.manage.rank.desc" /></h3>
						</div>
					</a>
				</li>
				<li id="liAll">
					<a href="<%=request.getContextPath()%>/event/listEvents">
						<span class="ca-icon">&#132;</span>
						<div class="ca-content">
							<h2 class="ca-main">List Events</h2>
							<h3 class="ca-sub">List all available events</h3>
						</div>
					</a>
				</li>
			</ul>
		</div>
		<!-- Right page -->
		<div class="pageRight user">
			<!-- Table -->
			<div class="right2">
				<button id="create-user" style="float: right;"><fmt:message key="label.admin.create.new.user" /></button>
				<div id="creat-user-form" title="<fmt:message key="label.admin.create.new.user" />">
					<p class="validateTips"><fmt:message key="label.validation.require.all.msg" /></p>

					<form class="dialog-form" id="createUserForm">
						<fieldset>
							<label id="create-user-error"></label><br/>
							<label for="name"><fmt:message key="label.common.username.eng" /></label>
							<input type="text" name="id" id="name" class="text ui-widget-content ui-corner-all" />
							<label for="password"><fmt:message key="label.common.password" /></label>
							<input type="password" name="password" id="password" value="" class="text ui-widget-content ui-corner-all" />
						</fieldset>
					</form>
				</div>
				<div id="edit-user-form" title="Edit role user">
					<p class="validateTips"><fmt:message key="label.validation.require.some.msg" /></p>
					
					<form class="dialog-form" id="editUserForm">
						<fieldset>
							<label for="editname"><fmt:message key="label.common.username.eng" /></label>
							<input type="text" name="id" id="editname" class="text ui-widget-content ui-corner-all" />
							<label for="role"><fmt:message key="label.common.role" /></label>
							<select name="role" id="role">
								<option></option>
								<option value="admin"><fmt:message key="label.common.role.admin" /></option>
								<option value="mod"><fmt:message key="label.common.role.mod" /></option>
								<option value="member"><fmt:message key="label.common.role.member" /></option>
							</select>
							<br />
							<br />
							<div id="edit-toDate">
								<label for="edit-datepicker"><fmt:message key="label.admin.expiry.date" /></label>
								<input type="text" name="expiredDate" id="edit-datepicker" class="ui-widget-content ui-corner-all" />
							</div>
							<br />
							<label for="reason-edit-user"><fmt:message key="label.common.reason" /></label>
							<textarea rows="4" cols="50" name="reason" id="reason-edit-user" class="text ui-widget-content ui-corner-all"></textarea>
						</fieldset>
					</form>
				</div>
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="user-table">
					<thead>
						<tr>
							<th><input type="text" name="search_username" value="<fmt:message key="label.common.username.eng" />" class="search_init" /></th>
							<th><input type="text" name="search_username" value="Email" class="search_init" /></th>
						</tr>
						<tr>
							<th><fmt:message key="label.common.username.eng" /></th>
							<th><fmt:message key="label.common.email" /></th>
							<th><fmt:message key="label.common.like" /></th>
							<th><fmt:message key="label.common.role" /></th>
							<th></th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th><fmt:message key="label.common.username.eng" /></th>
							<th><fmt:message key="label.common.email" /></th>
							<th><fmt:message key="label.common.like" /></th>
							<th><fmt:message key="label.common.role" /></th>
							<th></th>
						</tr>
					</tfoot>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<div class="pageRight report">
			<!-- Content -->
			<div class="right1" id="report-detail">
				<!-- dialog form will display when click send button -->
				<!-- todo get report detail Value setup here -->
				<div id="send-form" title="Create new message">
					<p class="validateTips"><fmt:message key="label.validation.require.some.msg" /></p>
					
					<form class="dialog-form" id="messageForm">
						<fieldset>
							<label for="toUser"><fmt:message key="label.common.to" /></label>
							<input type="text" name="userAffectedId" id="toUser" class="text ui-widget-content ui-corner-all" />
							<label for="subject"><fmt:message key="label.common.subject" /></label>
							<input type="text" name="subject" id="subject" class="text ui-widget-content ui-corner-all" />
							<label for="ban"><fmt:message key="label.admin.ban.user" /></label>
							<s:checkbox name="editBan" id="ban"/>
							<div id="toDate">
								<label for="datepicker"><fmt:message key="label.admin.expiry.date" /></label>
								<input type="text" name="datepicker" id="datepicker" class="ui-widget-content ui-corner-all" />
							</div>
							<label for="mess-content"><fmt:message key="label.common.content" /></label>
							<textarea rows="4" cols="50" name="reason" id="mess-content" class="text ui-widget-content ui-corner-all"></textarea>
						</fieldset>
					</form>
				</div>
				<!-- List of report for each event -->
				<p>
					<a href="#" id="event-title" ></a>
					<input type="hidden" name="reportId" id="reportId"/>
				</p>
				<fmt:message key="label.admin.report.eventCreatedUserId" /><label id="event-creator" ></label>
				<br style="clear:both;">
				<section id="buttons">
					<button id="done-report"><fmt:message key="label.button.done" /></button>
					<button id="create-message" style="float:right;"><fmt:message key="label.button.send" /></button>
					<br style="clear:both;">
					<br style="clear:both;">
				</section>
				<p><fmt:message key="label.admin.report.list" /></p>
				<div id="listReport"></div>
			</div>
			<!-- Table -->
			<div class="right2">
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="report-table">
					<thead>
						<tr>
							<th><input type="text" name="search_title_event_report" value="Tiêu đề" class="search_init" /></th>
							<th id="event_report"></th>
							<th></th>
						</tr>
						<tr>
							<th><fmt:message key="label.common.title" /></th>
							<th><fmt:message key="label.common.category" /></th>
							<th><fmt:message key="label.admin.report.count" /></th>
						</tr>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th><fmt:message key="label.common.title" /></th>
							<th><fmt:message key="label.common.category" /></th>
							<th><fmt:message key="label.admin.report.count" /></th>
						</tr>
					</tfoot>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<div class="pageRight event">
			<!-- Content -->
			<div class="right1">
				<p style="margin-bottom:0.5em;">
					<a href="#" id="tempTitle"></a>
					<br />
					<a href="#" style="font-size:0.7em;" id="tempUser"></a>
				</p>
				<section id="buttons">
					<button id="approve-update"><fmt:message key="label.button.apporve" /></button>
					<button id="reject-update" style="float:right;"><fmt:message key="label.button.reject" /></button>
				</section>
				<form id="update-event">
					<fieldset>
						<input type="hidden" id="tempId" /> 
						<label for="address"><fmt:message key="lable.event.address" /></label>
						<input type="text" name="address" id="tempAddress" value="" class="text ui-widget-content ui-corner-all" readonly="readonly" />
						<div style="width: 60%; float: left;">
							<label for="date"><fmt:message key="label.event.date" /></label>
							<input type="text" name="date" id="tempDate" value="" class="text ui-widget-content ui-corner-all" readonly="readonly" />
						</div>
						<div style="width: 40%; float: left;">
							<fmt:message key="label.common.category" />
							<input type="text" name="date" id="tempCat" value="" class="text ui-widget-content ui-corner-all" readonly="readonly" style="padding-right: 0;"/>
						</div>
<!-- 						<label for="full-des">Short Des</label> -->
						<div id="tempShortDes" class="text ui-widget-content ui-corner-all" style="display: none;"></div>
						<fmt:message key="label.event.full.desc" />
						<div id="tempFullDes" class="text ui-widget-content ui-corner-all" style="height: 220px; overflow: scroll;"></div>
					</fieldset>
				</form>
			</div>
			<!-- Table -->
			<div class="right2">
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="event-table">
					<thead>
						<tr>
							<th><input type="text" name="search_title_event" value="Tiêu đề" class="search_init" /></th>
							<th><input type="text" name="search_title_event" value="Người tạo" class="search_init" /></th>
							<th id="event"></th>
							<th></th>
						</tr>
						<tr>
							<th><fmt:message key="label.common.title" /></th>
							<th><fmt:message key="label.event.user" /></th>
							<th><fmt:message key="label.common.category" /></th>
							<th><fmt:message key="label.event.date" /></th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th><fmt:message key="label.common.title" /></th>
							<th><fmt:message key="label.event.user" /></th>
							<th><fmt:message key="label.common.category" /></th>
							<th><fmt:message key="label.event.date" /></th>
						</tr>
					</tfoot>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<div class="pageRight rank">
			<!-- Table -->
			<div class="right2">
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="rank-table">
					<thead>
						<tr>
							<th><input type="text" name="search_title_event_rank" value="<fmt:message key="label.common.title" />" class="search_init" /></th>
							<th id="event_rank"></th>
							<th style="display: none;"><input type="text"/></th>
							<th><input type="text" name="search_user_post_event" value="<fmt:message key="label.event.user" />" class="search_init" /></th>
							<th></th>
						</tr>
						<tr>
							<th><fmt:message key="label.common.title" /></th>
							<th><fmt:message key="label.common.category" /></th>
							<th><fmt:message key="label.event.user" /></th>
							<th><fmt:message key="label.event.rank" /></th>
							<th></th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th><fmt:message key="label.common.title" /></th>
							<th><fmt:message key="label.common.category" /></th>
							<th><fmt:message key="label.event.user" /></th>
							<th><fmt:message key="label.event.rank" /></th>
							<th></th>
						</tr>
					</tfoot>
					<tbody>
					</tbody>
				</table>
				<!-- dialog form will display when click promote button -->
				<div id="rank-form" title="Set rank for event">
					<p class="validateTips"><fmt:message key="label.validation.require.some.msg" /></p>
					
					<form class="dialog-form" id="eventpromoteform">
						<fieldset>
							<label for="rank"><fmt:message key="label.event.rank" /></label>
							<select name="event.rank" id="rank">
								<option></option>
								<option value="1"><fmt:message key="label.event.rank.1" /></option>
								<option value="2"><fmt:message key="label.event.rank.2" /></option>
								<option value="3"><fmt:message key="label.event.rank.3" /></option>
								<option value="4"><fmt:message key="label.event.rank.4" /></option>
								<option value="5"><fmt:message key="label.event.rank.5" /></option>
							</select>
							<label for="reason"><fmt:message key="label.common.reason" /></label>
							<textarea rows="7" cols="50" name="reason" id="reason" class="text ui-widget-content ui-corner-all"></textarea>
							<s:hidden name="event.id" id="eventid4promote" />
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>