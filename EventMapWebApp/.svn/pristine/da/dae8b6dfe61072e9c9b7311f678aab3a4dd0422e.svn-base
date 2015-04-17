$(document).ready(function() {
    var socket = $.atmosphere;
    var subSocket;
    var eventId = $("#event-id").val();
    var hostRealtime = document.location.protocol + "//" + document.location.host + "/EMCometServer/";

    /** Post comment when click post button **/
    $('#comment-post').click(postComment);
    
    /** get key press **/
    function getKeyCode(ev) {
        if (window.event) return window.event.keyCode;
        return ev.keyCode;
    }

    /** Get element by id **/ 
    function getElementById() {
        return document.getElementById(arguments[0]);
    }

    /** Get value of element **/
    function getElementByIdValue() {
        detectedTransport = null;
        return document.getElementById(arguments[0]).value;
    }

    /** Subscribe an event **/
    function subscribe() {
        var request = {
        	url : hostRealtime + 'comment/' + eventId,
        	contentType : "text/html;charset=UTF-8",
        	transport: 'long-polling',
            fallbackTransport: 'streaming'};
        
        request.onMessage = function (response) {
            if (response.status == 200) {
            	var comment;
                try {
                    comment = jQuery.parseJSON(response.responseBody);
                    
                    // insert new comment
                    var divContent = $("#previous-comments").html();
		    		var newComment = buildNewComment(comment);
		    		var newDivContent = newComment + divContent;
		    		
		    		$("#previous-comments").html(newDivContent);
		    		$("#comment-content").val("");
		    		$("#comment-content").focus();
                } catch (e) {
                    console.log('This doesn\'t look like a valid JSON: ', response.responseBody);
                    return;
                }
            }
        };
        
        subSocket = socket.subscribe(request);
    }

    /** Unsubscribe an event **/
    function unsubscribe(){
        socket.unsubscribe();
    }

    /** Connect to an event **/
    function connect() {
        unsubscribe();
        subscribe();
    }
    
    /** Auto connect when window load **/
    connect();

//    /** Post comment when press enter **/
//    if(userId != "anonymousUser") { 
//	    getElementById('comment-content').onkeyup = function(event) {
//	        var keyc = getKeyCode(event);
//	        if (keyc == 13 || keyc == 10) {
//	        	if (getElementById('comment-content').value == '') {
//	                alert("Làm ơn điền bình luận!!!");
//	                return true;
//	            }
//	        	
//	        	postComment();
//	            
//	            return false;
//	        }
//	        
//	        return true;
//	    };
//	
//	    /** Post comment when click post button **/
//	    getElementById('comment-post').onclick = function(event) {
//	        if (getElementById('comment-content').value == '') {
//	            alert("Làm ơn điền bình luận!!!");
//	            return;
//	        }
//	
//	        postComment();
//	        
//	        return false;
//	    };
//
//		/** Focus comment text box when load page **/
//	    getElementById('comment-content').focus();
//    }
//    
    /** Post comment **/
	function postComment(){
		tinymce.triggerSave();
		if ($("#comment-content").val() == "") {
			alert("Hãy nhập nội dung comment");
			tinymce.get("comment-content").focus();
			return;
		}
		$.ajax ({
			type: "POST",
		    url: contextPath + "/event/postComment", 
		    data: $("#event-id").serialize() + "&" + $("#comment-content").serialize(),
		    success: function(data) {
		    	if (data.actionErrors.length > 0) {
		    		alert(data.actionErrors);
		    	} else {
		    		var time = new Date(data.comment.createdDate+"+07:00");
		            subSocket.push({data: "userId=" + data.comment.userId + "&content=" + $("#comment-content").serialize().split("=")[1] + "&createdDate=" + time.getTime()});
		    		//subSocket.push(jQuery.stringifyJSON({ userId: data.comment.userId, content: data.comment.content, createdDate: data.comment.createdDate }));
		            $("#comment-content").val("");
		    		buildtinymce();
		    	}
		    }
		});
	}
	
	/** Append new comment **/
	function buildNewComment(comment) {

			var createdDate = dateToYMD(new Date(comment.createdDate));
			var newComment = "<div class='comment-item' >"
								+ "<img class='avatar' src=\""+ contextPath + "/images/usersImages/"+ comment.userId+"/avatar.jpg\" >"
								+ "<div class='right-part'>"
								+ "<label class='username'>"+comment.userId+"</label><label class='comment-time' >"+createdDate+"</label>"
								+ "<br>"
								+ "<label class='comment'>"+comment.content+"</label>"
								+ "<br>"
								+ "</div>"
								+ "</div>";
								
			return newComment;
	}
	
	/** Convert date to format dd/mm/yyyy h:m:s **/
	function dateToYMD(date) {
	    var d = date.getDate();
	    var M = date.getMonth() + 1;
	    var y = date.getFullYear();
	    var h= date.getHours();
	    var m= date.getMinutes();
	    var s= date.getSeconds();
	 
	    
	    m=checkTime(m);
	    s=checkTime(s);
	    h=checkTime(h);
	    
	    return ''+ (d <= 9 ? '0' + d : d)+ "/"+ (M<=9 ? '0' + M : M) + "/" + y +" "+ h+":"+m+":"+s;
	}
	
	/** add a zero in front of numbers<10 **/
	function checkTime(i) {
		if (i<10)
		  {
		  i="0" + i;
		  }
		return i;
	}

});