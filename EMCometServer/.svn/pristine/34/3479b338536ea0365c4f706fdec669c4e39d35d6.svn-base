/**
 * Legend Company
 */
package vn.com.lco.comment;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

import org.atmosphere.cpr.AtmosphereResourceEvent;
import org.atmosphere.cpr.Broadcaster;
import org.atmosphere.jersey.SuspendResponse;

import vn.com.lco.constants.Constants;
import vn.com.lco.service.TailableCursorThread;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.sun.jersey.spi.resource.Singleton;

/**
 * @author OaiPanda
 *
 * UpdateRankEvent.java
 */

@Path("/updateRank/{id}")
@Produces("text/html;charset=UTF-8")
@Singleton
public class UpdateRankEventNotify {
	
	private final CountDownLatch suspendLatch = new CountDownLatch(1);
	LinkedBlockingQueue<DBObject> queue = new LinkedBlockingQueue<DBObject>(1000);
	DB mongoDB;
	
	public UpdateRankEventNotify() {
		try {
			mongoDB = new Mongo(Constants.MONGO_HOST, Constants.MONGO_PORT).getDB(Constants.MONGO_DB_EVENTMAP_NAME);
			mongoDB.authenticate("eventmap", "nv.pamevent".toCharArray());
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		TailableCursorThread listener = new TailableCursorThread(queue, mongoDB, Constants.USER_INTERACT_LOG_COLLECTION, new BasicDBObject(), true);
		listener.start();
	}
	
    @GET
    public SuspendResponse<String> subscribe(final @PathParam("id") Broadcaster notify) {
    	
    	String serviceRespone = "";
//    	System.out.println("serviceRespone: " + serviceRespone);
   
//    	System.out.println("start schedule");        
//        System.out.println("begin search");

        // Wait for the connection to be suspended.
		DBObject dbo = queue.poll();
		if(dbo != null) {
        	
        	// _id, operation, eventId, timeLog
			if (dbo.get("operation") != null && dbo.get("eventId") != null) {
				String operation = dbo.get("operation").toString();
	        	String eventId = dbo.get("eventId").toString();
	        	
	        	if (operation.equals(Constants.userInteract.OPERATON_UPDATE_RANK)) {
		        	String eId = eventId.split("-")[0];
		            String rank = eventId.split("-")[1];
		            serviceRespone = "{ \"eventId\" : \"" + eId + "\", \"rank\" : " + rank + " }";
//		            System.out.println("serviceRespone: " + serviceRespone);
		            notify.broadcast(serviceRespone);
	        	}
			}
        }
        
//		System.out.println("end search");

		return new SuspendResponse.SuspendResponseBuilder<String>()
        		.broadcaster(notify)
        		.entity(serviceRespone)
        		.outputComments(true)
        		.period(2, TimeUnit.SECONDS)
                .addListener(new EventsLogger() {

                    @Override
                    public void onSuspend(
                            final AtmosphereResourceEvent event) {
                        super.onSuspend(event);

                        // OK, we can start polling Twitter!
                        suspendLatch.countDown();
                    }
                })
                .build();
    }
    
}
