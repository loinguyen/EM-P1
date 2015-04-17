/**
 * Legend Company
 */
package vn.com.lco.comment;

import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

import org.atmosphere.annotation.Broadcast;
import org.atmosphere.cpr.Broadcaster;
import org.atmosphere.jersey.Broadcastable;
import org.atmosphere.jersey.SuspendResponse;

import vn.com.lco.model.Comment;

import com.google.gson.Gson;

/**
 * @author OaiPanda
 *
 * JQueryPubSub.java
 */
@Path("/comment/{event}")
public class CommentPubSub {

	private
	@PathParam("event")
    Broadcaster event;
	
    @GET
    public SuspendResponse<String> subscribe() {
    	
        return new SuspendResponse.SuspendResponseBuilder<String>()
                .broadcaster(event)
                .outputComments(true)
                .addListener(new EventsLogger())
                .build();
    }

    @POST
    @Broadcast
    @Produces("text/html;charset=UTF-8")
    public Broadcastable publish(@FormParam("userId") String userId,
    							 @FormParam("content") String content,
    							 @FormParam("createdDate") long createdDate) {
//    	System.out.println(createdDate);
    	//long time = Long.parseLong(createdDate);
    	//System.out.println(time);
    	
    	Comment cmt = new Comment(userId, content, createdDate);
//    	String comment = "{ \"userId\" : \"" + userId + "\", \"content\" : \"" + content + "\" , \"createdDate\" : " + createdDate + " }";
    	String comment = new Gson().toJson(cmt);
    	return new Broadcastable(comment, "", event);
    }
}