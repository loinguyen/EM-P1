/**
 * 
 */
package vn.com.lco.webapp.action.event;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.ws.rs.core.MediaType;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.SearchBaseAction;
import vn.com.lco.webapp.bean.DropDownList;
import vn.com.lco.webapp.models.Event;
import vn.com.lco.webapp.models.Location;
import vn.com.lco.webapp.models.Report;
import vn.com.lco.webapp.models.TempEvent;
import vn.com.lco.webapp.utils.DateUtils;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.sun.jersey.api.client.ClientHandlerException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.representation.Form;

/**
 * @author Huy
 * 
 */
public class ManageEventAction extends SearchBaseAction {

	private static final long serialVersionUID = 1L;
	private String reason;
	private Event event;
	private Report report;
	private List<DropDownList> eventTypeList = buildEventTypeList();
	private final String loggedUid = getCurrentUserId();
	private TempEvent tmpEvent;
	private String location;

	@Override
	public String execute() {
		event = new Event();
		event.setUserId(getCurrentUserId());
		return INPUT;
	}

	public String listEvents() {
		return SUCCESS;
	}

	public String saveEvent() {
		try {
			event.setLocation(new Location(location.split(",")));
			Form form = new Form();
			form.add("title", event.getTitle());
			form.add("category", event.getCategory());
			form.add("location", event.getLocation());
			form.add("address", event.getAddress());
			form.add("contact", event.getContact());
			form.add("shortDes", event.getShortDes());
			form.add("fullDes", event.getFullDes());
			form.add("album", event.getAlbum());
			form.add("rank", Constants.Event.EVENT_RANK_DEFAULT);
			form.add("fromDate", event.getFromDate().toString());
			form.add("toDate", event.getToDate().toString());
			form.add("userId", getCurrentUserId());
			form.add("type", event.getType());
			WebResource resource = connectService();
			resource.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_CREATE_EVENT)
					.type(MediaType.APPLICATION_JSON)
					.accept(MediaType.APPLICATION_JSON)
					.post(String.class, event);
		} catch (Exception ex) {
			event = null;
			ex.printStackTrace();
		}
		return SUCCESS;
	}

	public String loadListEvents() {
		aaData = new ArrayList<ArrayList<String>>();

		try {

			// Connect to service
			WebResource service = connectService();
			// getting XML data
			String serviceRespone = service.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_SEARCH_ALL_EVENT)
					.accept(MediaType.APPLICATION_JSON).get(String.class);

			Gson gson = getCustomizeDateGson();
			List<Event> events = gson.fromJson(serviceRespone, new TypeToken<List<Event>>() {}.getType());
			
			ArrayList<String> aData;
			
			for (Event event : events) {
				aData = new ArrayList<String>();
				aData.add(event.getTitle());
				aData.add(event.getCategory());
				aData.add(event.getLocation().toString());
				aData.add(event.getAddress());
				aData.add(event.getContact());
				aData.add(event.getAlbum());
				aData.add(event.getUserId());
				aData.add(event.getType());
				aData.add(DateUtils.formatDate(Constants.dateFormat.DD_MM_YYY, event.getFromDate()));
				aData.add(DateUtils.formatDate(Constants.dateFormat.DD_MM_YYY, event.getToDate()));
				aData.add(DateUtils.formatDate(Constants.dateFormat.YYYY_MM_DD_TIME, event.getCreatedDate()));
				aData.add(event.getId());
				aData.add(String.valueOf(event.getRank()));
				
				aaData.add(aData);
			}
			
		} catch (ClientHandlerException ex) {
			addActionError("Cannot connect to server");
		} catch (Exception e) {
			System.out.print(e.getMessage());
		}
		return SUCCESS;
	}

	public String editEvent() {

		try {
			Form form = new Form();
			form.add("eId", event.getId());
			WebResource resource = connectService();
			String serviceRespone = resource.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_SEARCH_EVENT_BY_ID)
					.type(MediaType.APPLICATION_FORM_URLENCODED)
					.accept(MediaType.APPLICATION_JSON)
					.post(String.class, form);

			Gson gson = getCustomizeDateGson();

			event = gson.fromJson(serviceRespone, Event.class);
			location = event.getLocation().toString();

		} catch (Exception ex) {
			event = null;
			ex.printStackTrace();
		}

		return SUCCESS;
	}

	public String updateEvent() {
		try {
			Gson gson = new Gson();
			Form form = new Form();
			event.setLocation(new Location(location.split(",")));
			String eventJson = gson.toJson(event);

			form.add("userId", loggedUid);
			form.add("event", eventJson);
			WebResource resource = connectService();
			resource.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_UPDATE_EVENT)
							.type(MediaType.APPLICATION_FORM_URLENCODED)
							.accept(MediaType.APPLICATION_JSON)
							.post(String.class, form);
		} catch (Exception ex) {
			event = null;
			ex.printStackTrace();
		}
		return SUCCESS;
	}

	public String getTmpEvents() {
		aaData = new ArrayList<ArrayList<String>>();

		try {

			// Connect to service
			WebResource service = connectService();
			// getting XML data
			String serviceRespone = service.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_GET_ALL_TEMP_EVENT)
					.accept(MediaType.APPLICATION_JSON).get(String.class);

			Gson gson = getCustomizeDateGson();
			List<TempEvent> events = gson.fromJson(serviceRespone, new TypeToken<List<TempEvent>>() {}.getType());
			
			ArrayList<String> aData;
			
			for (TempEvent event : events) {
				aData = new ArrayList<String>();
				aData.add(event.getTitle());
				aData.add(event.getUserId());
				aData.add(event.getCategory());
				aData.add(DateUtils.formatDate(Constants.dateFormat.DD_MM_YYY, event.getCreatedDate()));
				aData.add(event.getId());
				
				aaData.add(aData);
			}
			
		} catch (ClientHandlerException ex) {
			addActionError("Cannot connect to server");
		} catch (Exception e) {
			System.out.print(e.getMessage());
		}
		return SUCCESS;
	}
	
	public String reportEvent() {
		try {
				
				Gson gson = new Gson();
				report.setCreatedDate(new Date());
				report.setUserId(loggedUid);
				report.setId(UUID.randomUUID().toString());
				String reportJson = gson.toJson(report);

				Form form = new Form();
				form.add("report", reportJson);
				form.add("eventId", event.getId());
				
				WebResource resource = connectService();
				resource.path(Constants.REST_PATH)
						.path(Constants.RESOURCE_PATH_REPORT_EVENT)
						.type(MediaType.APPLICATION_FORM_URLENCODED)
						.accept(MediaType.APPLICATION_JSON)
						.post(String.class, form);
			} catch (ClientHandlerException ex) {
				event = null;
				addActionError("Cannot connect to server");
			} catch (Exception e) {
				event = null;
				System.out.print(e.getMessage());
			}
		return SUCCESS;
	}
	
	public String promoteEvent() {
		try {
			Form form = new Form();
			form.add("reason", reason);
			form.add("eventId", event.getId());
			form.add("rank", event.getRank());
			form.add("userId", loggedUid);
			WebResource resource = connectService();
			resource.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_PROMOTE_EVENT)
					.type(MediaType.APPLICATION_FORM_URLENCODED)
					.accept(MediaType.APPLICATION_JSON)
					.post(String.class, form);
		} catch (ClientHandlerException ex) {
			event = null;
			addActionError("Cannot connect to server");
		} catch (Exception e) {
			event = null;
			System.out.print(e.getMessage());
		}
		
		return SUCCESS;
	}
	
	public String getTempEvent() {
		try {
			Form form = new Form();
			form.add("id", tmpEvent.getId());
			WebResource resource = connectService();
			String resp = resource.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_GET_TMPEVENT)
					.type(MediaType.APPLICATION_FORM_URLENCODED)
					.accept(MediaType.APPLICATION_JSON)
					.post(String.class, form);
			Gson gson = getCustomizeDateGson();
			tmpEvent = gson.fromJson(resp, TempEvent.class);
		} catch (ClientHandlerException ex) {
			tmpEvent = null;
			addActionError("Cannot connect to server");
		} catch (Exception e) {
			tmpEvent = null;
			System.out.print(e.getMessage());
		}
		return SUCCESS;
	}
	
	public String updateTempEvent() {
		try {
			Form form = new Form();
			form.add("id", tmpEvent.getId());
			form.add("status", tmpEvent.getStatus());
			form.add("userId", loggedUid);
			WebResource resource = connectService();
			String resp = resource.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_UPDATE_TEMP_EVENT)
					.type(MediaType.APPLICATION_FORM_URLENCODED)
					.accept(MediaType.APPLICATION_JSON)
					.post(String.class, form);
			Gson gson = getCustomizeDateGson();
			event = gson.fromJson(resp, Event.class);
		} catch (ClientHandlerException ex) {
			event = null;
			addActionError("Cannot connect to server");
		} catch (Exception e) {
			event = null;
			System.out.print(e.getMessage());
		}
		return SUCCESS;
	}
	
	protected List<DropDownList> buildEventTypeList() {
		List<DropDownList> ddls = new ArrayList<DropDownList>();
		ddls.add(new DropDownList("private", "Private"));
		ddls.add(new DropDownList("public", "Public"));
		return ddls;
	}

	/**
	 * @return the event
	 */
	public Event getEvent() {
		return event;
	}

	/**
	 * @param event
	 *            the event to set
	 */
	public void setEvent(Event event) {
		this.event = event;
	}

	/**
	 * @return the eventTypeList
	 */
	public List<DropDownList> getEventTypeList() {
		return eventTypeList;
	}

	/**
	 * @param eventTypeList
	 *            the eventTypeList to set
	 */
	public void setEventTypeList(List<DropDownList> eventTypeList) {
		this.eventTypeList = eventTypeList;
	}

	/**
	 * @return the report
	 */
	public Report getReport() {
		return report;
	}

	/**
	 * @param report the report to set
	 */
	public void setReport(Report report) {
		this.report = report;
	}

	/**
	 * @return the reason
	 */
	public String getReason() {
		return reason;
	}

	/**
	 * @param reason the reason to set
	 */
	public void setReason(String reason) {
		this.reason = reason;
	}

	/**
	 * @return the tmpEvent
	 */
	public TempEvent getTmpEvent() {
		return tmpEvent;
	}

	/**
	 * @param tmpEvent the tmpEvent to set
	 */
	public void setTmpEvent(TempEvent tmpEvent) {
		this.tmpEvent = tmpEvent;
	}

	/**
	 * @return the location
	 */
	public String getLocation() {
		return location;
	}

	/**
	 * @param location the location to set
	 */
	public void setLocation(String location) {
		this.location = location;
	}
}
