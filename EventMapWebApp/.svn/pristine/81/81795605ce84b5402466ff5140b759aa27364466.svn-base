/**
 * 
 */
package vn.com.lco.webapp.action.event;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.ws.rs.core.MediaType;

import org.apache.commons.io.FileUtils;
import org.apache.struts2.ServletActionContext;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.BaseAction;
import vn.com.lco.webapp.bean.DropDownList;
import vn.com.lco.webapp.models.Event;
import vn.com.lco.webapp.models.Location;
import vn.com.lco.webapp.models.Report;
import vn.com.lco.webapp.models.TempEvent;

import com.google.gson.Gson;
import com.sun.jersey.api.client.ClientHandlerException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.representation.Form;

/**
 * @author Tùng Kun
 * 
 */
public class CreateEventAction extends BaseAction {

	private static final long serialVersionUID = 1L;
	private String reason;
	private Event event;
	private Report report;
	private TempEvent tmpEvent;
	private String location;
	private List<DropDownList> listCategory = buildListCategory();
	private List<DropDownList> listType = buildEventTypeList();
	private String mod;
	private List<String> listImage ;
	private String userId = getCurrentUserId();
	private static String imgRoot = new StringBuilder(ServletActionContext.getServletContext().getRealPath(Constants.File_Dir.IMAGE_DIR))
										.append(File.separator).append(Constants.File_Dir.USR_IMAGE_DIR).toString();

	@Override
	public String execute() {
		mod = Constants.MOD_CREATE;
		event = new Event();
		event.setUserId(userId);
		return SUCCESS;
	}

	public String saveEvent() {
		try {
			
			if(event.getContact() == null || location == null || event.getTitle() == null 
					|| event.getContact().equals("") || location.equals("") || event.getTitle().equals("")) {
				addActionError(getText("error.event.create.requiredField"));
				
			}
			//getlocation
			event.setLocation(new Location(location.split(",")));
			//create Album
			WebResource resource = connectService();
			String response = resource.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_CREATE_EVENT)
					.type(MediaType.APPLICATION_JSON)
					.accept(MediaType.APPLICATION_JSON)
					.post(String.class, event);
			Gson gson = getCustomizeDateGson();
			event = gson.fromJson(response, Event.class);
			String eventAlbum = event.getAlbum();
			if (eventAlbum != null && !eventAlbum.isEmpty()) {
				String pathsrc = new StringBuilder()
							.append(imgRoot).append(File.separator).append("tmp")
								.append(File.separator).append(eventAlbum).toString();
				String pathdes = new StringBuilder()
				.append(imgRoot).append(File.separator).append(getCurrentUserId())
					.append(File.separator).append(eventAlbum).toString();
				
				File srcDir = new File(pathsrc);
				File desDir = new File(pathdes);
				FileUtils.copyDirectory(srcDir, desDir);
				FileUtils.forceDelete(srcDir);
			}
			
		} catch (Exception ex) {
			event = null;
			ex.printStackTrace();
		}
		return SUCCESS;
	}

	public String editEvent() {
		
		if (event == null) {
			return ERROR;
		}
		
		String eventId = event.getId();
		if (eventId == null || eventId.isEmpty()) {
			return ERROR;
		}
		
		try {
			mod = Constants.MOD_EDIT;
			Form form = new Form();
			form.add("eId", eventId);
			WebResource resource = connectService();
			String serviceRespone = resource.path(Constants.REST_PATH)
					.path(Constants.RESOURCE_PATH_SEARCH_EVENT_BY_ID)
					.type(MediaType.APPLICATION_FORM_URLENCODED)
					.accept(MediaType.APPLICATION_JSON)
					.post(String.class, form);

			Gson gson = getCustomizeDateGson();

			event = gson.fromJson(serviceRespone, Event.class);
			
			//load image
			if (event.getAlbum() != null && !event.getAlbum().isEmpty()) {
				String imgRoot = ServletActionContext.getServletContext().getRealPath(Constants.File_Dir.IMAGE_DIR);
				
				 String uploadDir = new StringBuilder()
					.append(imgRoot).append(File.separator).append(Constants.File_Dir.USR_IMAGE_DIR).append(File.separator).append(getCurrentUserId())
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
			location = event.getLocation().toString();

		} catch (Exception ex) {
			event = null;
			ex.printStackTrace();
		}

		return SUCCESS;
	}

	public String updateEvent() {
		try {
			if(event.getContact() == null || location == null || event.getTitle() == null 
					|| event.getContact() == "" || location == "" || event.getTitle() == "") {
				addActionError(getText("error.event.create.requiredField"));
				
			}
			
			Gson gson = new Gson();
			Form form = new Form();
			event.setLocation(new Location(location.split(",")));
			String eventJson = gson.toJson(event);

			form.add("userId", userId);
			form.add("event", eventJson);
			WebResource resource = connectService();
			String response = resource.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_UPDATE_EVENT)
							.type(MediaType.APPLICATION_FORM_URLENCODED)
							.accept(MediaType.APPLICATION_JSON)
							.post(String.class, form);
			gson = getCustomizeDateGson();
			event = gson.fromJson(response, Event.class);
		} catch (Exception ex) {
			event = null;
			ex.printStackTrace();
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
	
	protected List<DropDownList> buildEventTypeList() {
		List<DropDownList> ddls = new ArrayList<DropDownList>();
		ddls.add(new DropDownList(Constants.Event.EVENT_TYPE_PUBLIC, "Công khai"));
		ddls.add(new DropDownList(Constants.Event.EVENT_TYPE_PRIVATE, "Riêng tư"));
		return ddls;
	}
	
	/**
	 * function use to get list Category
	 * @return list category
	 */
	private List<DropDownList> buildListCategory() {
		List<DropDownList> ddls = new ArrayList<DropDownList>();
		ddls.add(new DropDownList(Constants.Event.EVENT_CAT_MUSIC, Constants.Event.EVENT_CAT_MUSIC));
		ddls.add(new DropDownList(Constants.Event.EVENT_CAT_FAIR, Constants.Event.EVENT_CAT_FAIR));
		ddls.add(new DropDownList(Constants.Event.EVENT_CAT_SPORT, Constants.Event.EVENT_CAT_SPORT));
		ddls.add(new DropDownList(Constants.Event.EVENT_CAT_ART, Constants.Event.EVENT_CAT_ART));
		ddls.add(new DropDownList(Constants.Event.EVENT_CAT_FILM, Constants.Event.EVENT_CAT_FILM));
		ddls.add(new DropDownList(Constants.Event.EVENT_CAT_SALE, Constants.Event.EVENT_CAT_SALE));
		ddls.add(new DropDownList(Constants.Event.EVENT_CAT_OFFLINE, Constants.Event.EVENT_CAT_OFFLINE));
		ddls.add(new DropDownList(Constants.Event.EVENT_CAT_OTHER, Constants.Event.EVENT_CAT_OTHER));
		
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

	/**
	 * @return the listCategory
	 */
	public List<DropDownList> getListCategory() {
		return listCategory;
	}

	/**
	 * @param listCategory the listCategory to set
	 */
	public void setListCategory(List<DropDownList> listCategory) {
		this.listCategory = listCategory;
	}

	/**
	 * @return the listType
	 */
	public List<DropDownList> getListType() {
		return listType;
	}

	/**
	 * @param listType the listType to set
	 */
	public void setListType(List<DropDownList> listType) {
		this.listType = listType;
	}

	/**
	 * @return the mod
	 */
	public String getMod() {
		return mod;
	}

	/**
	 * @param mod the mod to set
	 */
	public void setMod(String mod) {
		this.mod = mod;
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
