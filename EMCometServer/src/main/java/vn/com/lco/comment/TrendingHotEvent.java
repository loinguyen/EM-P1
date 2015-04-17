/**
 * Legend Company
 */
package vn.com.lco.comment;

import java.util.Iterator;
import java.util.List;
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

import vn.com.lco.constants.Constants;
import vn.com.lco.utils.CommonUtils;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.spi.resource.Singleton;

/**
 * @author OaiPanda
 *
 * TrendingHotEvent.java
 */

@Path("/event/trendinghot/{id}")
@Produces("text/html;charset=UTF-8")
@Singleton
public class TrendingHotEvent {

	private final CountDownLatch suspendLatch = new CountDownLatch(1);

    @GET
    public SuspendResponse<String> search(final @PathParam("id") Broadcaster notify,
                                          final @PathParam("id") String bcId) {

        if (bcId.isEmpty()) {
            throw new WebApplicationException();
        }
        
//        System.out.println("start schedule");        
//        System.out.println("begin search");
    	
        // Create connect to API
        ClientConfig config = new DefaultClientConfig();
        Client client = Client.create(config);
        String url = Constants.API_URL;
        WebResource service = client.resource(UriBuilder.fromUri(url).build());
        String listEventContent = "";
        
        // Search list eventID
        String listEventIdResponse = service.path(Constants.REST_PATH)
				.path(Constants.RESOURCE_PATH_EVENT_TRENDINGHOT)
				.accept(MediaType.APPLICATION_JSON).get(String.class);
        
        if (listEventIdResponse != null && !listEventIdResponse.equals("") && listEventIdResponse.length() > 0) {
	        Gson gson = CommonUtils.getCustomizeDateGson();
			List<vn.com.lco.model.TrendingHotEvent> listEvent = gson.fromJson(listEventIdResponse, new TypeToken<List<vn.com.lco.model.TrendingHotEvent>>() {}.getType());
			if (listEvent.size() > 0) {
				String listEventId = "";
				if (listEvent.size() < 2) {
					listEventId = listEvent.get(0).getEventId();
				} else {
					Iterator<vn.com.lco.model.TrendingHotEvent> iter = listEvent.iterator();
					while (iter.hasNext()) {
						vn.com.lco.model.TrendingHotEvent obj = iter.next();
						listEventId = listEventId + obj.getEventId() + ",";
					}
					listEventId = listEventId.substring(0, listEventId.length()-1);
				}
				
				// Search list event content
		        listEventContent = service.path(Constants.REST_PATH)
										 .path(Constants.RESOURCE_PATH_EVENT_CONTENT_TRENDINGHOT)
										 .accept(MediaType.APPLICATION_JSON)
										 .post(String.class, listEventId);
		        
		        notify.broadcast(listEventContent);
			}
        }
//		System.out.println("end search");

        return new SuspendResponse.SuspendResponseBuilder<String>()
        		.broadcaster(notify)
        		.entity(listEventContent)
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
