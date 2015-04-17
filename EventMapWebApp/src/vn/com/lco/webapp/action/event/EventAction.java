/**
 * 
 */
package vn.com.lco.webapp.action.event;

import javax.ws.rs.core.MediaType;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.BaseAction;
import vn.com.lco.webapp.models.Notification;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.representation.Form;

/**
 * @author Tùng
 *
 */
public class EventAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String eventId;
	private Notification notification;
	private String userId = getCurrentUserId();

	@Override
	public String execute() {
		return SUCCESS;
	}
	
	/**
	 * action use to create new bookmark
	 * @return
	 */
	public String bookMark() {
		
		try {
		Form form = new Form();
		form.add(Constants.Notification.EVENT_ID, eventId);
		form.add(Constants.Notification.USER_ID, userId );
		form.add(Constants.Notification.LAST_VIEW_COMMENT, "");
		WebResource service = connectService();
		String serviceResponse = service.path(Constants.REST_PATH)
				.path(Constants.RESOURCE_PATH_BOOKMARK_CREATE)
				.type(MediaType.APPLICATION_FORM_URLENCODED)
				.accept(MediaType.APPLICATION_JSON).post(String.class, form);
		
		Gson gson = getCustomizeDateGson();
		notification = gson.fromJson(serviceResponse, new TypeToken<Notification>() {}.getType());
		} catch(UniformInterfaceException e) {
			if (e.getMessage().contains("500 Internal Server Error")) {
				addActionError("cannot create new book mark");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return SUCCESS;
	}
	
	public String unBookMark(){
		try {
			Form form = new Form();
			form.add(Constants.Notification.EVENT_ID, eventId);
			form.add(Constants.Notification.USER_ID, userId );
			WebResource service = connectService();
			service.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_BOOKMARK_DESTROY)
					.type(MediaType.APPLICATION_FORM_URLENCODED)
					.accept(MediaType.APPLICATION_JSON).post(String.class, form);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return SUCCESS;
	}
	
	public String updateNotificationStatus() {
		try {
			Form form = new Form();
			form.add(Constants.Notification.EVENT_ID, eventId);
			form.add(Constants.Notification.USER_ID, userId );
			WebResource service = connectService();
			service.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_BOOKMARK_STATUS_UPDATE)
					.type(MediaType.APPLICATION_FORM_URLENCODED)
					.accept(MediaType.APPLICATION_JSON).post(String.class, form);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return SUCCESS;
	}

	public String getEventId() {
		return eventId;
	}

	public void setEventId(String eventId) {
		this.eventId = eventId;
	}

	public Notification getNotification() {
		return notification;
	}

	public void setNotification(Notification notification) {
		this.notification = notification;
	}

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
}
