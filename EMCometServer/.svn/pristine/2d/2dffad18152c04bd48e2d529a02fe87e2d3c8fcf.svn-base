/**
 * Legend Company
 */
package vn.com.lco.service;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.atomic.AtomicBoolean;

import vn.com.lco.constants.Constants;

import com.mongodb.BasicDBObject;
import com.mongodb.Bytes;
import com.mongodb.DB;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoException;

/**
 * @author OaiPanda
 *
 * TailableCursorThread.java
 */
public class TailableCursorThread extends Thread {

	private final AtomicBoolean opened = new AtomicBoolean(false);
	LinkedBlockingQueue<DBObject> queue;
	String mongoCollectionName;
	DB mongoDB;
	DBObject query;

	public TailableCursorThread(LinkedBlockingQueue<DBObject> queue, DB mongoDB,
								String mongoCollectionName, DBObject query, boolean opened) {
		
		this.queue = queue;
		this.mongoDB = mongoDB;
		this.mongoCollectionName = mongoCollectionName;
		this.query = query;
		this.opened.set(opened);
	}

	@Override
	public void run() {
//		System.out.println("TailableCursorThread run");
		while(opened.get()) {
			try {
				// create the cursor
				mongoDB.requestStart();
				
				final DBCursor cursor = mongoDB.getCollection(mongoCollectionName)
											.find(query)
											.sort(new BasicDBObject("$natural", 1))
											.addOption(Bytes.QUERYOPTION_TAILABLE)
											.addOption(Bytes.QUERYOPTION_AWAITDATA)
											.addOption(Bytes.QUERYOPTION_NOTIMEOUT);

				try {
					while (opened.get() && cursor.hasNext()) {
	                    final DBObject doc = cursor.next();
	
	                    if (doc == null) break;
	
                    	// _id, operation, eventId, timeLog
            			if (doc.get("operation") != null && doc.get("eventId") != null) {

            				String operation = doc.get("operation").toString();
            	        	
            	        	if (operation.equals(Constants.userInteract.OPERATON_UPDATE_RANK)) {
//                				System.out.println("document: " + doc);
            	        		queue.put(doc);
            	        	}
            			}
	                    
//	                    System.out.println("size: " + queue.size());
	                }
				} finally {
					try { 
						if (cursor != null) cursor.close(); 
					} catch (final Throwable t) { }
                    try { 
                    	mongoDB.requestDone(); 
                    	} catch (final Throwable t) { }
                }
				
				Thread.sleep(500);
			} catch (final MongoException.CursorNotFound cnf) {
				
				// rethrow only if something went wrong while we expect the cursor to be open.
                if (opened.get()) {
                	throw cnf;
                }
            } catch (InterruptedException e) { break; }
		}
	};
}
