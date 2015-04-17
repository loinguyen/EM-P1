/**
 * Legend Company
 */
package vn.com.lco.notification;

import java.util.concurrent.Callable;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;

import org.atmosphere.cpr.AtmosphereResourceEvent;
import org.atmosphere.cpr.Broadcaster;
import org.atmosphere.jersey.SuspendResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vn.com.lco.comment.EventsLogger;
import vn.com.lco.constants.Constants;

import com.ning.http.client.AsyncCompletionHandler;
import com.ning.http.client.AsyncHttpClient;
import com.ning.http.client.Response;
import com.sun.jersey.spi.resource.Singleton;

/**
 * @author OaiPanda
 *
 * NotifySub.java
 */
@Path("/notify/{event}")
@Produces("text/html;charset=UTF-8")
@Singleton
public class NotifySub {
	private static final Logger logger = LoggerFactory.getLogger(NotifySub.class);

    private final AsyncHttpClient asyncClient = new AsyncHttpClient();
    private final ConcurrentHashMap<String, Future<?>> futures = new ConcurrentHashMap<String, Future<?>>();
    private final CountDownLatch suspendLatch = new CountDownLatch(1);

    @GET
    public SuspendResponse<String> search(final @PathParam("event") Broadcaster notify,
                                          final @PathParam("event") String bcId) {

        if (bcId.isEmpty()) {
            throw new WebApplicationException();
        }
        
        if (notify.getAtmosphereResources().size() == 0) {

        	final Future<?> future = notify.scheduleFixedBroadcast(new Callable<String>() {

                public String call() throws Exception {
                	String userId = bcId.split("-")[0];
                    String eventId = bcId.split("-")[1];

                    String query = Constants.API_URL + Constants.REST_PATH + Constants.RESOURCE_PATH_EVENT_NOTIFY + 
                    			   "/" + eventId + "/" + userId;

                    // Wait for the connection to be suspended.
                    suspendLatch.await();
                    asyncClient.prepareGet(query).execute(
                            new AsyncCompletionHandler<Object>() {

                                @Override
                                public Object onCompleted(Response response) throws Exception {
                                    String result = response.getResponseBody();

                                    if (response.getStatusCode() != 200) {
                                    	notify.resumeAll();
                                    	notify.destroy();
                                        logger.info("Notification system unavaileble\n{}", result);
                                        return null;
                                    }

                                	notify.broadcast(result).get();
                                	
                                    return null;
                                }

                            });
                    return null;
                }

            }, 5, TimeUnit.SECONDS);
            
            futures.put(bcId, future);
        }

        return new SuspendResponse.SuspendResponseBuilder<String>()
        		.broadcaster(notify)
        		.outputComments(true)
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
    

    @GET
    @Path("stop")
    public String stopSearch(final @PathParam("tagid") Broadcaster feed,
                             final @PathParam("tagid") String tagid) {
        feed.resumeAll();
        if (futures.get(tagid) != null) {
            futures.get(tagid).cancel(true);
        }
        logger.info("Stopping real time update for {}", tagid);
        return "DONE";
    }
}