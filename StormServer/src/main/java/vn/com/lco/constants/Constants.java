/**
 * Legend Company
 */
package vn.com.lco.constants;

/**
 * @author OaiPanda
 *
 * Constant.java
 */
public class Constants {

	/*------------------------------------- Base configuration ---------------------------------------*/
	public static final String MONGO_DB_NAME = "mongo_storm_tailable_cursor";
	public static final String MONGO_DB_EVENTMAP_NAME = "eventmap";
	public static final String MONGO_HOST = "127.0.0.1";
	public static final int MONGO_PORT = 27017;
	public static final String USER_INTERACT_LOG_COLLECTION = "userInteractLog";
	public static final String TRENDING_HOT_EVENT_COLLECTION = "trendingHotEvent";
	public static final String EVENT_COLLECTION = "event";
	public static final String API_URL = "http://localhost:8080";
	public static final String REST_PATH = "/EventMapAPI";
	public static final String RESOURCE_PATH_SEARCH_EVENT_BY_ID = "/event/storm/find/id";
	public static final String RESOURCE_PATH_SAVE_EVENT = "/event/save";
	public static final int TOP_N = 10;
	public static final int MILLIS_IN_SEC = 1000;
	
    /*-------------------------- Operation which user interact system ----------------------------*/
	public static final String OPERATON_VIEW = "VIEW";
    public static final String OPERATON_LIKE = "LIKE";
    public static final String OPERATON_SUBSCRIBE = "SUBSCRIBE";
    public static final String OPERATON_COMMENT = "COMMENT";
    public static final String OPERATON_UNLIKE = "UNLIKE";
    public static final String OPERATON_UNSUBSCRIBE = "UNSUBSCRIBE";
    public static final String OPERATON_UPDATE_RANK = "UPDATE_RANK";
    
    /*--------------------------- Setup for rank of each event ----------------------------------------*/
    public static final int MILESTONE_1 = 10;
    public static final int MILESTONE_2 = 50;
    public static final int MILESTONE_3 = 90;
    public static final int MILESTONE_4 = 170;
    
    public static interface dateFormat {
		public static final String DD_MM_YYY = "dd-MM-YYYY";
		public static final String DD_MM_YYYY_TIME = "dd-MM-YYYY-HH:mm:ss";
		public static final String YYYY_MM_DD_TIME = "YYYYMMddHHmmss";
	}
}
