/**
 * 
 */
package vn.com.lco.webapp.action.users;

import javax.ws.rs.core.MediaType;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.BaseAction;

import com.sun.jersey.api.client.WebResource;

/**
 * @author Huy
 *
 */
public class EmailAction extends BaseAction{

	private static final long serialVersionUID = 1L;
	private String id;
	String type;
	
	public String handleEmail() {
		try {
			WebResource service = connectService();
			// getting XML data
			type = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_HANDLE_EMAIL)
					.accept(MediaType.APPLICATION_JSON).post(String.class,id);
		} catch(Exception e) {
			type = null;
		}
		return SUCCESS;
	}

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
	 * @return the type
	 */
	public String getType() {
		return type;
	}

	/**
	 * @param type the type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

}
