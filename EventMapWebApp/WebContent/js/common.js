var eSearchMode = {onmap: 1, suggest: 2, search: 3, relate: 4, post : 5, hot : 6};

function callESearchAPI(data, mode) {
	$.ajax({
		url: eSearchUri + ':9200/eventmap/_search?search_type=query_and_fetch',
		type: 'POST',
		contentType: 'application/json; charset=UTF-8',
		crossDomain: true,
		dataType: 'json',
		data: JSON.stringify(data),							
		success: function(response) {
			var result = response.hits.hits;
			switch(mode) {
				case eSearchMode.onmap:
					buildMiniList(result, true);
					break;
				case eSearchMode.suggest:
					buildSuggestList(result);
					break;
				case eSearchMode.search:
					$('.minilist-btn div').removeClass('active');
					buildMiniList(result, true);
					break;
				case eSearchMode.relate:
					buildRelatedEventSuggest(result);
					break;
				case eSearchMode.post:
					builPostedEventsList(result);
					break;
				case eSearchMode.hot:
					builHotEventsList(result);
					break;
			}
			
		},
		error: function(jqXHR, textStatus, errorThrown) {
			var jso = jQuery.parseJSON(jqXHR.responseText);
			console.log('(' + jqXHR.status + ') ' + errorThrown + ' --<br />' + jso.error);
			alert("Error");
		}
	});
}
function toggleLogin() {
	$('a#login').click();
	return false;
}
function validateEmail(email) { 
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}
function validateId(id) { 
	var re = /^[A-Za-z0-9_-]{3,20}$/;
	return re.test(id);
}

function dateToYMD(date) {
    var d = date.getDate();
    var m = date.getMonth() + 1;
    var y = date.getFullYear();
    return ''+ (d <= 9 ? '0' + d : d)+ "/"+ (m<=9 ? '0' + m : m) + "/" + y;
}
function dateToMD(date) {
    var d = date.getDate();
    var m = date.getMonth() + 1;
    return ''+ (d <= 9 ? '0' + d : d)+ "/"+ (m<=9 ? '0' + m : m);
}
function getDateTime(date) {
	var dateArr = date.split("-");
	return dateArr[2] + "-" + dateArr[1] + "-" + dateArr[0] + "T" + getTime() + "+07:00";
}
function getDateAsString(date) {
	var d = date.getDate();
    var m = date.getMonth() + 1;
    var y = date.getFullYear();
    return ''+ (d <= 9 ? '0' + d : d)+ "-"+ (m<=9 ? '0' + m : m) + "-" + y;
}
/*-- show date picker dialog in edit user dialog --*/
function getTime()
{
	var date_obj = new Date();
	var date_obj_hours = date_obj.getHours();
	var date_obj_mins = date_obj.getMinutes();
	var date_obj_second = date_obj.getSeconds();

	var date_obj_time = date_obj_hours+":"+date_obj_mins+":"+date_obj_second;
	return date_obj_time;
}
function objToString (obj) {
    var str = '';
    for (var p in obj) {
        if (obj.hasOwnProperty(p)) {
            str += p + '::' + obj[p] + '\n';
        }
    }
    return str;
}
function getFirstTimeOfDate(date) {
	return new Date(date.getFullYear(), date.getMonth(), date.getDate(), 0, 0, 0, 0).getTime();
}
function getLastTimeOfDate(date) {
	return new Date(date.getFullYear(), date.getMonth(), date.getDate(), 23, 59, 59, 59).getTime();
}
function normalizeTitle(title, max) {
	if (title.length > max) {
		title = title.substring(0,max) + "...";
	}
	
	return title;
}