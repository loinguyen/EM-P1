/**
 * 
 */
package vn.com.lco.webapp;

/**
 * @author Huy
 *
 */
public class Constants {
	public static final String MODIFY_ID = "modId";
	public static final String API_URL 	 = "http://localhost:8080";
	public static final String MOD_CREATE = "create";
	public static final String MOD_EDIT = "edit";
	//-----------Common User properties---------------------------------
	public static final String USER_ID = "id";
	public static final String USER_PASSWORD="password";
	public static final String ANONYMOUS_USER= "anonymousUser";
	public static final String WRONG_USER= "wrongUser";
	
	//----------Common Report properties--------------------------------
	public static final String REPORT_ID = "id";
	/*-------------Server connect URI-----------------------------------*/
	public static final String REST_PATH = "/EventMapAPI";
	public static final String RESOURCE_PATH_SEARCH_ALL_USERS = "/admin/users/all";
	public static final String RESOURCE_PATH_ADMIN_CREAT_USER = "/admin/users/create";
	public static final String RESOURCE_PATH_ADMIN_EDIT_USER =  "/admin/users/update";
	public static final String RESOURCE_PATH_SEARCH_ALL_REPORT = "/admin/reportEvents/all";
	public static final String RESOURCE_PATH_SEARCH_DETAIL_REPORT = "/admin/reportEvents/get";
	public static final String RESOURCE_PATH_HANDLE_REPORT     = "/admin/reportEvents/resolve";
	public static final String RESOURCE_PATH_CREATE_CONVERSATION    = "";
	public static final String RESOURCE_PATH_USER_AUTHORITY = "/user/findbyIdPassword";
	public static final String RESOURCE_PATH_USER_AUTHORITY_ID = "/user/findbyId";
	public static final String RESOURCE_PATH_USER_FIND_BY_EMAIL = "/user/findbyEmail";
	public static final String RESOURCE_PATH_USER_FIND_BY_USERNAME = "/user/findbyUsername";
	public static final String RESOURCE_PATH_USER_SIGNUP = "/user/signup";
	public static final String RESOURCE_PATH_FORGOT_PWD = "/user/forgotpwd";
	public static final String RESOURCE_PATH_HANDLE_EMAIL = "/user/handleEmail";
	public static final String RESOURCE_PATH_USER_CREATE_CONVERS = "/user/createConversation";
	public static final String RESOURCE_PATH_USER_PROFILE_UPDATE = "/user/update";
	public static final String RESOURCE_PATH_USER_CHANGE_PWD = "/user/changepwd";
	
	public static final String RESOURCE_PATH_CREATE_EVENT = "/event/create";
	public static final String RESOURCE_PATH_SEARCH_ALL_EVENT = "/event/all";
	public static final String RESOURCE_PATH_SEARCH_EVENT_BY_ID = "/event/find/id";
	public static final String RESOURCE_PATH_UPDATE_EVENT = "/event/update";
	public static final String RESOURCE_PATH_GET_ALL_TEMP_EVENT = "/event/temp/all";
	public static final String RESOURCE_PATH_UPDATE_TEMP_EVENT = "/event/temp/update";
	public static final String RESOURCE_PATH_REPORT_EVENT = "/event/report/new";
	public static final String RESOURCE_PATH_PROMOTE_EVENT = "/event/promote";
	public static final String RESOURCE_PATH_GET_TMPEVENT = "/event/temp/get";
	public static final String RESOURCE_PATH_SEARCH_ALL_EVENT_CONDITION = "/event/allValid";
	
	public static final String RESOURCE_PATH_POST_COMMENT = "/event/comment/create";
	public static final String RESOURCE_PATH_GET_ALL_VALID_COMMENT = "/event/comment/getAvailabeComments";
	
	public static final String RESOURCE_PATH_BOOKMARK_CREATE = "user/createBookMark";
	public static final String RESOURCE_PATH_BOOKMARK_DESTROY = "user/unBookMark";
	public static final String RESOURCE_PATH_BOOKMARK_NOTIFY  = "user/getAllNotification";
	public static final String RESOURCE_PATH_BOOKMARK_STATUS_UPDATE = "user/updateBookMark";
	public static final String RESOURCE_PATH_BOOKMARK_GET_EVENTS = "event/allBookMarkEvent";
	
	public static final String RESOURCE_PATH_EVENT_DELETE = "/event/deleteEvent";
	public static final String RESOURCE_PATH_EVENT_LIKE = "/event/likeEvent";
	public static final String RESOURCE_PATH_EVENT_HOT = "/event/topRankEvent";
	/*-------------adminUpdateUser Request param properties-------------*/
	public static final String AFFECTED_USER_ID = "affectedUid";
	public static final String PASSWORD = "password";
	public static final String ROLE = "affectedRole";
	public static final String CHANGE_USER_ID = "changeUid";
	public static final String CREATED_DATE = "createdDate";
	public static final String EXPIRED_DATE = "dateBan";
	public static final String REASON = "reasonUpdate";
	
	
	/*-----------adminUpdateUser User list param -------------------------*/
	public static final String USER_EMAIL = "email";
	public static final String USER_NoLIKE = "noOfLikes";
	public static final String USER_ROLE = "role";
	
	public static interface User {
		public static final String USER_GEN_MALE = "Nam";
		public static final String USER_GEN_FEMALE = "Nữ";
		public static final String USER_GEN_MALE_VAL = "M";
		public static final String USER_GEN_FEMALE_VAL = "F";
	}
	
	/*--------------------- Temporary Event Status ----------------------------------*/
	public static final String TEMP_EVENT_APPROVE 		= "APPROVE";
	public static final String TEMP_EVENT_REJECT 		= "REJECT";
	
	public static interface UserRoles {
		public static final String ROLE_ADMIN 				= "ROLE_ADMIN";
		public static final String ROLE_MOD 				= "ROLE_MOD";
		public static final String ROLE_MEMBER				= "ROLE_MEMBER";
		public static final String ROLE_BAN 				= "ROLE_BAN";
		public static final String ROLE_INACTIVE 				= "ROLE_INACTIVE";
	}
	
	/*---------------------Event Report JSON-------------------------------*/
	public static interface EventReport {
		public static final String EVENT_TITLE      =         "eventTitle";
		public static final String EVENT_CATEGORY   =         "eventCat";
		public static final String EVENT_NO_REPORT  =         "noOfReports";
	}
	
	public static interface Conversation {
		public static final String CONVERS_ID = "id";
		public static final String CONVERS_SENDER = "sender";
		public static final String CONVERS_RECEIVER = "receiver";
		public static final String CONVERS_MESS_CONTENT = "messageContent";
		public static final String CONVERS_CREATED_DATE = "createdDate";
		public static final String CONVERS_LIST_MESS = "messages";
	}
	
	
	public static interface dateFormat {
		public static final String DD_MM_YYY = "dd-MM-YYYY";
		public static final String DD_MM_YYYY_TIME = "dd-MM-YYYY-HH:mm:ss";
		public static final String YYYY_MM_DD_TIME = "YYYYMMddHHmmss";
	}
	
	public static interface Notification {
		public static final String LAST_VIEW_COMMENT = "lastViewComment";
		public static final String EVENT_ID = "eventId";
		public static final String USER_ID = "userId";
		public static final String COMMENT_NOTIFY_TEMP = " đã bình luận ở sự kiện này.";
		public static final String UPDATE_NOTIFY_TEMP = " đã cập nhật thông tin về sự kiện.";
	}
	
	public static interface Event {
		public static final int EVENT_RANK_DEFAULT = 1;
		public static final int EVENT_RANK_VIP = 5;
		public static final String EVENT_CAT_MUSIC = "Âm nhạc";
		public static final String EVENT_CAT_FAIR = "Hội thảo";
		public static final String EVENT_CAT_SPORT = "Thể thao"; 
		public static final String EVENT_CAT_ART = "Nghệ thuật"; 
		public static final String EVENT_CAT_FILM = "Điện ảnh"; 
		public static final String EVENT_CAT_SALE = "Khuyến mại"; 
		public static final String EVENT_CAT_OFFLINE = "Họp mặt"; 
		public static final String EVENT_CAT_OTHER = "Khác";
		
		public static final String EVENT_TYPE_PUBLIC = "public";
		public static final String EVENT_TYPE_PRIVATE = "private";
				
	}
	
	public static interface File_Dir {
		public static final String IMAGE_DIR = "images";
		public static final String USR_IMAGE_DIR = "usersImages";
		public static final String THUMB = "Thumbs.db";
		public static final String COVER = "cover";
		public static final String COVER_IMG = "cover.jpg";
		public static final String AVATAR = "avatar.jpg";
	}
}
