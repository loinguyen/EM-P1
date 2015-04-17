package vn.com.lco.webapp.action.event;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.ws.rs.core.MediaType;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.BaseAction;
import vn.com.lco.webapp.models.Event;
import vn.com.lco.webapp.models.Notification;
import vn.com.lco.webapp.models.StringNotify;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.sun.jersey.api.client.ClientHandlerException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.representation.Form;

/**
 * created by LoiNguyen
 * 19/7/2013
 */
public class EventHomeAction extends BaseAction {


	private static final long serialVersionUID = 1L;
	private String category;
	private Date   formDateFence;//search event occur before this date
	private List<Event> listEvent;
	private int listEventSize;
	private String userId;
	private List<StringNotify> listStringNotify = new ArrayList<StringNotify>();
	
	
	@Override
	public String execute(){
//		loadAllEventByCondition();
		userId = getCurrentUserId();
		return SUCCESS;
	}
	
	public String loadAllEventByCondition(){		
		try {
		Form form = new Form();
		form.add("categoryCondition", category);
		form.add("dateCondition", "");
		WebResource service = connectService();
		String serviceResponse = service.path(Constants.REST_PATH)
				.path(Constants.RESOURCE_PATH_SEARCH_ALL_EVENT_CONDITION)
				.type(MediaType.APPLICATION_FORM_URLENCODED)
				.accept(MediaType.APPLICATION_JSON).post(String.class, form);
		
		Gson gson = getCustomizeDateGson();
		listEvent = gson.fromJson(serviceResponse, new TypeToken<List<Event>>() {}.getType());
		
		userId = getCurrentUserId();
		
		if(!userId.equals(Constants.ANONYMOUS_USER)) {
			
		}
		
//		listEventSize = listEvent.size();
		} catch (ClientHandlerException ex) {
			addActionError("Cannot connect to server");
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return SUCCESS;
	}
	
	/**
	 * function use to load all BookMark and notification of a user
	 * @return
	 */
	public String loadAllBookMark() {
		
		try {
			userId = getCurrentUserId();
			Form form = new Form();
			form.add(Constants.Notification.USER_ID, userId);
			WebResource service = connectService();
			String serviceResponse = service.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_BOOKMARK_GET_EVENTS)
					.type(MediaType.APPLICATION_FORM_URLENCODED)
					.accept(MediaType.APPLICATION_JSON).post(String.class, form);
			
			Gson gson = getCustomizeDateGson();
			listEvent = gson.fromJson(serviceResponse, new TypeToken<List<Event>>() {}.getType());
			
			form = new Form();
			form.add(Constants.Notification.USER_ID, userId);
			serviceResponse = service.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_BOOKMARK_NOTIFY)
					.type(MediaType.APPLICATION_FORM_URLENCODED)
					.accept(MediaType.APPLICATION_JSON).post(String.class, form);
			List<Notification> listNotify = new ArrayList<Notification>();
			listNotify = gson.fromJson(serviceResponse, new TypeToken<List<Notification>>() {}.getType() );
			for (int i = 0; i < listNotify.size() ; i++) {
				Notification notify = listNotify.get(i);
				StringNotify stringNotify = new StringNotify();
				stringNotify.setNotificationId(notify.getId());
				stringNotify.setEventId(notify.getEventId());
				
				//build comment notify
				if (notify.getUserCommentList() != null && notify.getUserCommentList().size() > 0) {
					int commentSize = notify.getUserCommentList().size();
					StringBuffer paramList = new StringBuffer();
					paramList.append("%s");
					String commentNotify ;
					if (commentSize > 1) {
						paramList.append(" và %d người khác");
						paramList.append(Constants.Notification.COMMENT_NOTIFY_TEMP);
						commentNotify = String.format(paramList.toString(),
																		notify.getUserCommentList().get(commentSize-1),
																		commentSize-1);
					} else {
						paramList.append(Constants.Notification.COMMENT_NOTIFY_TEMP);
					commentNotify = String.format(paramList.toString(),
																		notify.getUserCommentList().get(commentSize-1));
					}
					
					stringNotify.setCommentNotify(commentNotify);
				}
				if (notify.getUserUpdateList() != null && notify.getUserUpdateList().size() > 0) {
					StringBuilder paramList = new StringBuilder();
					paramList.append("%s").append(Constants.Notification.UPDATE_NOTIFY_TEMP);
					String updateNotify = String.format(paramList.toString(), notify.getUserUpdateList().get(notify.getUserUpdateList().size()-1));
					stringNotify.setUpdateNotify(updateNotify);
					
				}
				stringNotify.setStatus(notify.getStatus());
				listStringNotify.add(stringNotify);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return SUCCESS;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public Date getFormDateFence() {
		return formDateFence;
	}

	public void setFormDateFence(Date formDateFence) {
		this.formDateFence = formDateFence;
	}

	public List<Event> getListEvent() {
		return listEvent;
	}

	public void setListEvent(List<Event> listEvent) {
		this.listEvent = listEvent;
	}

	public int getListEventSize() {
		return listEventSize;
	}

	public void setListEventSize(int listEventSize) {
		this.listEventSize = listEventSize;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public List<StringNotify> getListStringNotify() {
		return listStringNotify;
	}

	public void setListStringNotify(List<StringNotify> listStringNotify) {
		this.listStringNotify = listStringNotify;
	}
}
