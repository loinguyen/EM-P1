/**
 * Legend Company
 */
package vn.com.lco.model;

import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

/**
 * @author OaiPanda
 *
 * Notification.java
 */
@Document
public class Notification {

	@Id
	private String id;
	
	private String subscriberId;
	
	private String eventId;
	
	private List<String> userUpdateList;
	
	private List<String> userCommentList;
	
	private String status;

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the subscriberId
	 */
	public String getSubscriberId() {
		return subscriberId;
	}

	/**
	 * @param subscriberId the subscriberId to set
	 */
	public void setSubscriberId(String subscriberId) {
		this.subscriberId = subscriberId;
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
	 * @return the userUpdateList
	 */
	public List<String> getUserUpdateList() {
		return userUpdateList;
	}

	/**
	 * @param userUpdateList the userUpdateList to set
	 */
	public void setUserUpdateList(List<String> userUpdateList) {
		this.userUpdateList = userUpdateList;
	}

	/**
	 * @return the userCommentList
	 */
	public List<String> getUserCommentList() {
		return userCommentList;
	}

	/**
	 * @param userCommentList the userCommentList to set
	 */
	public void setUserCommentList(List<String> userCommentList) {
		this.userCommentList = userCommentList;
	}

	/**
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @param status the status to set
	 */
	public void setStatus(String status) {
		this.status = status;
	}
}
