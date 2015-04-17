/**
 * Legend Company
 */
package vn.com.lco.comment;

import java.util.concurrent.LinkedBlockingQueue;

import org.mortbay.log.Log;

import vn.com.lco.service.TailableCursorThread;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBObject;
import com.mongodb.Mongo;


/**
 * @author OaiPanda
 *
 * testTailableCursor.java
 */
public class testTailableCursor {
	
	/**
	 * @return void
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		LinkedBlockingQueue<DBObject> queue = new LinkedBlockingQueue<DBObject>(1000);
		DB mongoDB;
		
		try {
			mongoDB = new Mongo("localhost", 27017).getDB("mongo_storm_tailable_cursor");
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		TailableCursorThread listener = new TailableCursorThread(queue, mongoDB, "userInteractLog", new BasicDBObject(), true);
		listener.start();
		
		while (true) {
			DBObject dbo = queue.poll();
			if(dbo == null) {
	            try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	        } else {
	        	Log.info("next:" + dbo);
	        	
	        	// _id, operation, eventId, timeLog
	        	String id = dbo.get("_id").toString();
	        	String operation = dbo.get("operation").toString();
	        	String eventId = dbo.get("eventId").toString();
	        	String timeLog = dbo.get("timeLog").toString();
	        	
	        	Log.info("_id" + id);
	        	Log.info("operation" + operation);
	        	Log.info("eventId" + eventId);
	        	Log.info("timeLog" + timeLog);
	        }
		}
	}

}
