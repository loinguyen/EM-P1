/**
 * Legend Company
 */
package vn.com.lco.comment;

import java.util.HashMap;
import java.util.Map;
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
import vn.com.lco.dto.NotificationContentDTO;
import vn.com.lco.utils.CommonUtils;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.api.representation.Form;
import com.sun.jersey.spi.resource.Singleton;

/**
 * @author OaiPanda
 *
 * NotifyPubSub.java
 */

@Path("/notify/{event}")
@Produces("text/html;charset=UTF-8")
@Singleton
public class NotifyPubSub {

    private final CountDownLatch suspendLatch = new CountDownLatch(1);
    
    private final Map<String, NotificationContentDTO> oldNotifies; 
    
    public NotifyPubSub() {
    	this.oldNotifies = new HashMap<String, NotificationContentDTO>();
	}

    @GET
    public SuspendResponse<String> search(final @PathParam("event") Broadcaster notify,
                                          final @PathParam("event") String bcId) {

        if (bcId.isEmpty()) {
            throw new WebApplicationException();
        }
        if (oldNotifies.get(bcId) == null) {
        	NotificationContentDTO oldNotiEvent = new NotificationContentDTO();
        	oldNotifies.put(bcId, oldNotiEvent);
        }
        
//        System.out.println("start schedule");        
//        System.out.println("begin search");
    	String userId = bcId.split("-")[0];
        String eventId = bcId.split("-")[1];

        // Wait for the connection to be suspended.
        
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
        String cometResponse = "";
        
        if (serviceRespone != null && !serviceRespone.equals("") && serviceRespone.length() > 0) {
	        Gson gson = CommonUtils.getCustomizeDateGson();
			NotificationContentDTO newNotiEvent = gson.fromJson(serviceRespone, new TypeToken<NotificationContentDTO>() {}.getType());
			String newContent = newNotiEvent.getContent();
			String newStatus = newNotiEvent.getStatus();
			String oldContent = this.oldNotifies.get(bcId).getContent();
			String oldStatus = this.oldNotifies.get(bcId).getStatus();
			
			if ( !( newNotiEvent.getStatus().equals("") || ( oldContent.equals(newContent) && oldStatus.equals(newStatus) ) ) ) {
				
				if (!oldContent.equals(newContent)) {
					if (!newStatus.equals(Constants.Notify.STATUS_READ)) {
						cometResponse = newContent;
						notify.broadcast(cometResponse);
					}
				} else {
					if (!newStatus.equals(Constants.Notify.STATUS_READ)) {
						cometResponse = newContent;
						notify.broadcast(cometResponse);
					}
				}
			}

			NotificationContentDTO oldNotiEvent = new NotificationContentDTO();
			oldNotiEvent.setContent(newContent);
			oldNotiEvent.setStatus(newStatus);
			this.oldNotifies.put(bcId, oldNotiEvent);
        }
        
        
//		System.out.println("end search");

        return new SuspendResponse.SuspendResponseBuilder<String>()
        		.broadcaster(notify)
        		.entity(cometResponse)
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
