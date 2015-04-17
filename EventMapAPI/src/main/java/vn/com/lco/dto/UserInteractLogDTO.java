/**
 * Legend Company
 */
package vn.com.lco.dto;

import java.util.Date;

/**
 * @author OaiPanda
 *
 * UserInteractLogDTO.java
 */
public class UserInteractLogDTO {

	private String id;
	
	private String operation;
	
	private String eventId;
	
	private Date timeLog;

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
	 * @return the operation
	 */
	public String getOperation() {
		return operation;
	}

	/**
	 * @param operation the operation to set
	 */
	public void setOperation(String operation) {
		this.operation = operation;
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
	 * @return the timeLog
	 */
	public Date getTimeLog() {
		return timeLog;
	}

	/**
	 * @param timeLog the timeLog to set
	 */
	public void setTimeLog(Date timeLog) {
		this.timeLog = timeLog;
	}
}
