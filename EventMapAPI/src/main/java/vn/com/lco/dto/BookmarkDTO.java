package vn.com.lco.dto;

public class BookmarkDTO {

	/**
	 * @param args
	 */

	private String eventId;
	private String userId;
	private String lastViewComment;
	
	public String getEventId() {
		return eventId;
	}
	public void setEventId(String eventId) {
		this.eventId = eventId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getLastViewComment() {
		return lastViewComment;
	}
	public void setLastViewComment(String lastViewComment) {
		this.lastViewComment = lastViewComment;
	}

}
