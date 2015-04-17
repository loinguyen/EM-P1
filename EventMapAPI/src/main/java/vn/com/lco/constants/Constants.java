/**
 * 
 */
package vn.com.lco.constants;

/**
 * @author Huy
 *
 */
public class Constants {
	public static final String DEFAULT_DATE_TIME_FORMAT = "E MMM dd HH:mm:ss Z yyyy";
	
	
	public static interface dateFormat {
		//format Date for DateUtility
		public static final String DD_MM_YYY = "dd-MM-YYYY";
		public static final String ISO_STRING_FORMAT_NO_HOUR = "yyyy-MM-dd'T00:00:00.000Z'";
		public static final String ISO_STRING_FORMAT = "yyyy-MM-dd'T'hh:mm:ss'Z'";
	}
	
	public static interface Notify {
		public static final String STATUS_UNREAD = "unread";
		public static final String STATUS_READ = "read";
		public static final String STATUS_DELETED = "deleted";
		public static final String NOTIFY_COMMENT = " đã bình luận về sự kiện";
		public static final String NOTIFY_UPDATE = " đã cập nhật sự kiện";
		public static final String NOTIFY_AND = " và ";
		public static final String NOTIFY_OTHERS = " người khác";
	}
	
	public static interface EmailInteraction {
		public static final String TYPE_ACTIVATE = "activate";
		public static final String TYPE_RESET_PASSWORD = "resetpwd";
	}
	
	public static interface userInteract {
		public static final String OPERATON_VIEW = "VIEW";
	    public static final String OPERATON_LIKE = "LIKE";
	    public static final String OPERATON_SUBSCRIBE = "SUBSCRIBE";
	    public static final String OPERATON_COMMENT = "COMMENT";
	    public static final String OPERATON_UNLIKE = "UNLIKE";
	    public static final String OPERATON_UNSUBSCRIBE = "UNSUBSCRIBE";
	    public static final String OPERATON_UPDATE_RANK = "UPDATE_RANK";
	}
	
	public static interface Event {
		public static final int NUMBER_TOP_EVENT = 10;
	}
}
