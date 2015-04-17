/**
 * Legend Company
 */
package vn.com.lco.notification;

import java.util.concurrent.Callable;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;

import org.atmosphere.cpr.AtmosphereResourceEvent;
import org.atmosphere.cpr.Broadcaster;
import org.atmosphere.jersey.SuspendResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vn.com.lco.comment.EventsLogger;
import vn.com.lco.constants.Constants;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.api.representation.Form;
import com.sun.jersey.spi.resource.Singleton;

/**
 * @author OaiPanda
 *
 * NotificationSub.java
 */

@Path("/notification/{event}")
@Produces("text/html;charset=UTF-8")
@Singleton
public class NotificationSub {

    private final CountDownLatch suspendLatch = new CountDownLatch(1);

    @GET
    public SuspendResponse<String> search(final @PathParam("event") Broadcaster notify,
                                          final @PathParam("event") String bcId) {

        if (bcId.isEmpty()) {
            throw new WebApplicationException();
        }
        
        if (notify.getAtmosphereResources().size() == 0) {

            notify.scheduleFixedBroadcast(new Callable<String>() {

                public String call() throws Exception {
                	String userId = bcId.split("-")[0];
                    String eventId = bcId.split("-")[1];

                    // Wait for the connection to be suspended.
                    suspendLatch.await();
                    ClientConfig config = new DefaultClientConfig();
                    Client client = Client.create(config);
                    String url = Constants.API_URL;
                    WebResource service = client.resource(UriBuilder.fromUri(url).build());
                    Form form = new Form();
            		form.add("eventId", eventId);
            		form.add("userId", userId);
                    String serviceRespone = service.path(Constants.REST_PATH)
							 .path(Constants.RESOURCE_PATH_EVENT_NOTIFY)
							 .type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, form);
	
					
                    return serviceRespone;
                }

            }, 5, TimeUnit.SECONDS);
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
}