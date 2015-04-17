package vn.com.lco.webapp.action.event;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.MediaType;

import org.apache.struts2.ServletActionContext;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.BaseAction;
import vn.com.lco.webapp.models.Comment;
import vn.com.lco.webapp.models.Event;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.representation.Form;

/**
 * Action in event detail page
 * @author NguyenLoi
 *
 */
public class EventDetailAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Event event;
	private String userId;
	private String commentContent;
	private Comment comment;
	private List<Comment> returnCommentList;
	private String eventId;
	private List<String> listLike;
	private String likeValue;
	private int noOfLike;
	private boolean inLikeList;
	private List<String> listImage;
	private boolean inSubList;
	private List<Event> hotEvent;

	/**
	 * @param args
	 */
	@Override
	public String execute() {
		
		userId = getCurrentUserId();
		//get id of event
		HttpServletRequest request = getRequest();
		String eventId = request.getParameter("id");
		
		Form form = new Form();
		form.add("eId", eventId);
		WebResource service = connectService();
		String serviceRespone = service.path(Constants.REST_PATH)
								 .path(Constants.RESOURCE_PATH_SEARCH_EVENT_BY_ID)
								 .type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, form);
		
		Gson gson = getCustomizeDateGson();
		event = gson.fromJson(serviceRespone, Event.class);
		
		if (event == null) {
			return ERROR;
		}
		
		//get List Image 
		if (event.getAlbum() != null && !event.getAlbum().isEmpty()) {
			String imgRoot = ServletActionContext.getServletContext().getRealPath(Constants.File_Dir.IMAGE_DIR);
			
			 String uploadDir = new StringBuilder()
				.append(imgRoot).append(File.separator).append(Constants.File_Dir.USR_IMAGE_DIR).append(File.separator).append(event.getUserId())
				.append(File.separator).append(event.getAlbum()).toString();
			 
			 File dirPath = new File(uploadDir);
			  if (dirPath.exists()) { 	  
				  String[] listFile = dirPath.list();
				  List<String> imgList  = Arrays.asList(listFile);
				  listImage = new ArrayList<String>();
				  for (String img : imgList) {
					  if (Constants.File_Dir.COVER.equals(img) || Constants.File_Dir.THUMB.equals(img)) {
						  continue;
					  }
					  listImage.add(img);
				  }
			  }
		}
		
		//get Like list
		listLike = event.getLike();
		if (listLike != null) {
			noOfLike = listLike.size();
			if(!userId.equals(Constants.ANONYMOUS_USER)) {
				if (event.getLike().contains(userId)) {
					inLikeList = true;
				}
			}
		}
		
		//check if user in subscribers list
		if(event.getSubscribers() != null) {
			if(!userId.equals(Constants.ANONYMOUS_USER)) {
				if (event.getSubscribers().contains(userId)) {
					inSubList = true;
				}
			}
		}
		
		form.add("lastViewComment", "");
		String commentRespone = service.path(Constants.REST_PATH)
				 .path(Constants.RESOURCE_PATH_GET_ALL_VALID_COMMENT)
				 .type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, form);
		
		List<Comment> listComment = gson.fromJson(commentRespone, new TypeToken<List<Comment>>() {}.getType());
		returnCommentList = listComment;
		
		//get Hot Event
		String hotEventRespone = service.path(Constants.REST_PATH)
				 .path(Constants.RESOURCE_PATH_EVENT_HOT)
				 .type(MediaType.APPLICATION_FORM_URLENCODED).get(String.class);
		
		List<Event> hotEventList = gson.fromJson(hotEventRespone, new TypeToken<List<Event>>() {}.getType());
		hotEvent = hotEventList;
		
		return SUCCESS;
	}
	
	public String postComment() {
		
		try {
		Comment newComment = new Comment();
		newComment.setEventId(event.getId());
		newComment.setUserId(getCurrentUserId());
		newComment.setContent(commentContent);
		
		WebResource service = connectService();
		String serviceRespone = service.path(Constants.REST_PATH)
				 .path(Constants.RESOURCE_PATH_POST_COMMENT)
				 .type(MediaType.APPLICATION_JSON)
				 .accept(MediaType.APPLICATION_JSON)
				 .post(String.class, newComment);
		
		Gson gson = getCustomizeDateGson();
		Comment returnComment = gson.fromJson(serviceRespone, new TypeToken<Comment>() {}.getType());
		comment = returnComment;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return SUCCESS;
	}
	
	public String deleteEvent() {
		try {
			List<String> like = Arrays.asList(likeValue.split(","));
			Event eventCreate = new Event();
			userId =(String) getRequest().getAttribute("userId");
			eventCreate.setUserId(userId);
			eventCreate.setId(eventId);
			eventCreate.setLike(like);
			
			Form form = new Form();
			form.add("eventId", eventId);
			form.add("userId", userId);
			form.add("likeList", like);
			
			WebResource service = connectService();
			String serviceRespone = service.path(Constants.REST_PATH)
					 .path(Constants.RESOURCE_PATH_EVENT_DELETE)
					 .type(MediaType.APPLICATION_FORM_URLENCODED)
					 .accept(MediaType.APPLICATION_JSON)
					 .post(String.class, form);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return SUCCESS;
	}
	
	/**
	 * functio use to like an event
	 * @return number of like
	 */
	public String likeEvent() {
		try {
			
			Form form = new Form();
			form.add("eventId", eventId);
			form.add("userId", getCurrentUserId());
			
			WebResource service = connectService();
			String serviceRespone = service.path(Constants.REST_PATH)
					 .path(Constants.RESOURCE_PATH_EVENT_LIKE)
					 .type(MediaType.APPLICATION_FORM_URLENCODED)
					 .accept(MediaType.APPLICATION_JSON)
					 .post(String.class, form);
			
			Gson gson = getCustomizeDateGson();
			Integer like = gson.fromJson(serviceRespone, new TypeToken<Integer>() {}.getType());
			noOfLike = like.intValue();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return SUCCESS;
	}

	public Event getEvent() {
		return event;
	}

	public void setEvent(Event event) {
		this.event = event;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getCommentContent() {
		return commentContent;
	}

	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}

	public Comment getComment() {
		return comment;
	}

	public void setComment(Comment comment) {
		this.comment = comment;
	}

	public List<Comment> getReturnCommentList() {
		return returnCommentList;
	}

	public void setReturnCommentList(List<Comment> returnCommentList) {
		this.returnCommentList = returnCommentList;
	}

	/**
	 * @return the eventId
	 */
	public String getEventId() {
		return eventId;
	}

	/**
	 * @param eventId the eventId to set
	 */
	public void setEventId(String eventId) {
		this.eventId = eventId;
	}

	/**
	 * @return the likeValue
	 */
	public String getLikeValue() {
		return likeValue;
	}

	/**
	 * @param likeValue the likeValue to set
	 */
	public void setLikeValue(String likeValue) {
		this.likeValue = likeValue;
	}

	/**
	 * @param listLike the listLike to set
	 */
	public void setListLike(List<String> listLike) {
		this.listLike = listLike;
	}

	/**
	 * @return the listLike
	 */
	public List<String> getListLike() {
		return listLike;
	}

	/**
	 * @return the noOfLike
	 */
	public int getNoOfLike() {
		return noOfLike;
	}

	/**
	 * @param noOfLike the noOfLike to set
	 */
	public void setNoOfLike(int noOfLike) {
		this.noOfLike = noOfLike;
	}

	/**
	 * @return the inLikeList
	 */
	public boolean getInLikeList() {
		return inLikeList;
	}

	/**
	 * @param inLikeList the inLikeList to set
	 */
	public void setInLikeList(boolean inLikeList) {
		this.inLikeList = inLikeList;
	}

	/**
	 * @return the listImage
	 */
	public List<String> getListImage() {
		return listImage;
	}

	/**
	 * @param listImage the listImage to set
	 */
	public void setListImage(List<String> listImage) {
		this.listImage = listImage;
	}

	/**
	 * @return the inSubList
	 */
	public boolean getInSubList() {
		return inSubList;
	}

	/**
	 * @param inSubList the inSubList to set
	 */
	public void setInSubList(boolean inSubList) {
		this.inSubList = inSubList;
	}

	/**
	 * @return the hotEvent
	 */
	public List<Event> getHotEvent() {
		return hotEvent;
	}

	/**
	 * @param hotEvent the hotEvent to set
	 */
	public void setHotEvent(List<Event> hotEvent) {
		this.hotEvent = hotEvent;
	}

}
