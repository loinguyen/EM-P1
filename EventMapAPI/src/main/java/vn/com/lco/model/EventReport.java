/**
 * Legend Company
 */
package vn.com.lco.model;

import java.util.Date;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

/**
 * @author OaiPanda
 *
 * EventReport.java
 */

@Document
public class EventReport {
	
	@Id
	private String id;
	
	private String eventId;
	
	private String eventTitle;
	
	private String eventCat;
	
	private String eventUid;
	
	private String modId;
	
	@DateTimeFormat(iso = ISO.DATE_TIME)
	private Date modDate;
	
	private String status;
	
	private List<Report> listReport;

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
	 * @return the modId
	 */
	public String getModId() {
		return modId;
	}

	/**
	 * @param modId the modId to set
	 */
	public void setModId(String modId) {
		this.modId = modId;
	}

	/**
	 * @return the modDate
	 */
	public Date getModDate() {
		return modDate;
	}

	/**
	 * @param modDate the modDate to set
	 */
	public void setModDate(Date modDate) {
		this.modDate = modDate;
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

	/**
	 * @return the listReport
	 */
	public List<Report> getListReport() {
		return listReport;
	}

	/**
	 * @param listReport the listReport to set
	 */
	public void setListReport(List<Report> listReport) {
		this.listReport = listReport;
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
	 * @return the eventTitle
	 */
	public String getEventTitle() {
		return eventTitle;
	}

	/**
	 * @param eventTitle the eventTitle to set
	 */
	public void setEventTitle(String eventTitle) {
		this.eventTitle = eventTitle;
	}

	/**
	 * @return the eventCat
	 */
	public String getEventCat() {
		return eventCat;
	}

	/**
	 * @param eventCat the eventCat to set
	 */
	public void setEventCat(String eventCat) {
		this.eventCat = eventCat;
	}

	/**
	 * @return the eventUid
	 */
	public String getEventUid() {
		return eventUid;
	}

	/**
	 * @param eventUid the eventUid to set
	 */
	public void setEventUid(String eventUid) {
		this.eventUid = eventUid;
	}
	
}
