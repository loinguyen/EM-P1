/**
 * Legend Company
 */
package vn.com.lco.dto;

/**
 * @author OaiPanda
 *
 * NotificationDTO.java
 */
public class NotificationDTO {

	private String eventId;
	
	private String userId;

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
