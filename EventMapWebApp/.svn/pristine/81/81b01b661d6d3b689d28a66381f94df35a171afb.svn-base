package vn.com.lco.webapp.action.admin;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.SearchBaseAction;
import vn.com.lco.webapp.utils.DateUtils;

import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.representation.Form;

/**
 * LoiNM
 * 
 */
public class ManageEventAction extends SearchBaseAction {
	
	private static final long serialVersionUID = 1L;

	private String reportId;
	private boolean editBan;
	private String userAffectedId;
	private String expiredDate;
	private String reason;
	private String eventTitle;
	private String eventUid;
	private List<String> reports;
	private String userPostEventId;
	private String eventId;
	
	/**
	 * load list report
	 */
	@Override
	/**
	 * load list report 
	 */
	public String execute(){
		//load Report list
		try {
			WebResource service = connectService();
			String response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_SEARCH_ALL_REPORT)
							 .accept(MediaType.APPLICATION_JSON).get(String.class);
			
			Map source = jsonPaser(response);
			ArrayList reportList = (ArrayList)source.get("root");
	        aaData = new ArrayList<ArrayList<String>>();
			ArrayList<String> aData;
			if (reportList != null) {
				for (int i = 0; i < reportList.size(); i++) {
					aData = new ArrayList<String>();
					Map report = (Map)reportList.get(i);
					String reportId = (String)report.get(Constants.REPORT_ID);
					aData.add("<a href='#' onclick='fnCreateEventReportDetail(\""+ reportId +"\");' class='report-event'>" + (String)report.get(Constants.EventReport.EVENT_TITLE) + "</a>");
					aData.add((String)report.get(Constants.EventReport.EVENT_CATEGORY));
					aData.add((String)report.get(Constants.EventReport.EVENT_NO_REPORT));
					aData.add(reportId);
					aaData.add(aData);
				}
			}

		} catch (Exception e) {
			System.out.print(e.getMessage());
		}
		return SUCCESS;
	}
	
	/**
	 * fucntion use to load detail report to display
	 * @return
	 */
	public String loadDetailEventReport(){
		try {
			Form form = new Form();
			form.add(Constants.REPORT_ID, reportId);
			WebResource service = connectService();
			String response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_SEARCH_DETAIL_REPORT)
					 .accept(MediaType.APPLICATION_JSON).post(String.class,form);
			
			Map source = jsonPaser(response);
			
			//set properties to report details
			String searchedEventTitle = (String)source.get("eventTitle");
			String searchedEventUid = (String)source.get("eventUid");
			String searchedReportId = (String)source.get("id");
			eventId = (String)source.get("eventId");
			List<Map>    listReport = (List<Map>)source.get("listReport");
			reports = new ArrayList<String>();
			for (int i =0; i < listReport.size(); i++) {
				Map report = listReport.get(i);
				String reportContent = (String) report.get("content");
				String userReport = (String)report.get("userId");
				Date createdDate  = DateUtils.obtainDateFromAPI((String)report.get("createdDate"));
				String formatedDate = DateUtils.formatDate("dd/MM/yyyy", createdDate);
				String reportItem = "<span style='font-weight:bold;'>" + userReport + "</span>" + " (" + formatedDate + ")" + " : " + reportContent + "<br /> ";
				reports.add(reportItem);
			}
			eventTitle = searchedEventTitle;
			eventUid = searchedEventUid;
			reportId = searchedReportId;
		} catch (Exception e) {
			e.printStackTrace();
//			System.out.println(e.getMessage());
		}
		return SUCCESS;
	}
	
	public String handleReport(){
		
		try {
			
			//get User 
			String userName = getCurrentUserId();
	        
			Form form = new Form();
			form.add(Constants.REPORT_ID, reportId);
			form.add(Constants.MODIFY_ID, userName);
			WebResource service = connectService();
			String response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_HANDLE_REPORT)
							 .type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, form);
		} catch (Exception e) {
			System.out.print(e.getMessage());
		}
		
		return SUCCESS;
	}
	
	public String sendMessage(){
		
		try {
		WebResource service = connectService();
		Form form = new Form();
		//check if banned check box is tick 
		if (editBan == true){
			// ban action	
	        form.add(Constants.CHANGE_USER_ID, getCurrentUserId());	
	        form.add(Constants.AFFECTED_USER_ID, userAffectedId);
	        form.add(Constants.ROLE, Constants.UserRoles.ROLE_BAN);
	        form.add(Constants.EXPIRED_DATE, expiredDate); 
	        form.add(Constants.REASON, reason);
			String response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_ADMIN_EDIT_USER)
					 .type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, form);
		} else {
			 //send message action
			form.add(Constants.Conversation.CONVERS_SENDER, getCurrentUserId());	
	        form.add(Constants.Conversation.CONVERS_RECEIVER, userAffectedId);
	        form.add(Constants.Conversation.CONVERS_MESS_CONTENT, reason);
	        
			String response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_USER_CREATE_CONVERS)
					 .type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, form);
		}
		} catch (UniformInterfaceException  e) {
			if (e.getMessage().contains("500 Internal Server Error")) {
				addActionError(getText("error.admin.report.ban"));
			}
		}
		
		return SUCCESS;
	}

	public String getReportId() {
		return reportId;
	}

	public void setReportId(String reportId) {
		this.reportId = reportId;
	}

	public boolean isEditBan() {
		return editBan;
	}

	public void setEditBan(boolean editBan) {
		this.editBan = editBan;
	}

	public String getUserAffectedId() {
		return userAffectedId;
	}

	public void setUserAffectedId(String userAffectedId) {
		this.userAffectedId = userAffectedId;
	}

	public String getExpiredDate() {
		return expiredDate;
	}

	public void setExpiredDate(String expiredDate) {
		this.expiredDate = expiredDate;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getEventTitle() {
		return eventTitle;
	}

	public void setEventTitle(String eventTitle) {
		this.eventTitle = eventTitle;
	}

	public String getUserPostEventId() {
		return userPostEventId;
	}

	public void setUserPostEventId(String userPostEventId) {
		this.userPostEventId = userPostEventId;
	}

	public String getEventUid() {
		return eventUid;
	}

	public void setEventUid(String eventUid) {
		this.eventUid = eventUid;
	}

	public List<String> getReports() {
		return reports;
	}

	public void setReports(List<String> reports) {
		this.reports = reports;
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

}
