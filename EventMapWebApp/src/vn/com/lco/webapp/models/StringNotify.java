package vn.com.lco.webapp.models;

public class StringNotify {

	/**
	 * @param args
	 */
	private String notificationId;
	private String eventId;
	private String commentNotify;
	private String updateNotify;
	private String status;
	
	public String getNotificationId() {
		return notificationId;
	}
	public void setNotificationId(String notificationId) {
		this.notificationId = notificationId;
	}
	public String getEventId() {
		return eventId;
	}
	public void setEventId(String eventId) {
		this.eventId = eventId;
	}
	public String getCommentNotify() {
		return commentNotify;
	}
	public void setCommentNotify(String commentNotify) {
		this.commentNotify = commentNotify;
	}
	public String getUpdateNotify() {
		return updateNotify;
	}
	public void setUpdateNotify(String updateNotify) {
		this.updateNotify = updateNotify;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}
