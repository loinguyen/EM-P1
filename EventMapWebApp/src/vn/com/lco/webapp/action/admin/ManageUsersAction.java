/**
 * 
 */
package vn.com.lco.webapp.action.admin;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.SearchBaseAction;
import vn.com.lco.webapp.models.User;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.opensymphony.xwork2.ActionContext;
import com.sun.jersey.api.client.ClientHandlerException;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.representation.Form;

/**
 * @author Huy
 *
 */
public class ManageUsersAction extends SearchBaseAction {

	private static final long serialVersionUID = 1L;
	
	// get list user
	private String id;
	private String role;
	private String reason;
	private String expiredDate;
	private String password;
	private String email;
	private User user;
	
	@Override
	public String execute() {
		
        return INPUT;
    }
	
	public String update() {
		try {
		                
		        // get current log-in user.
		        Map session = ActionContext.getContext().getSession();
		        String changedUid = (String) session.get("userId");
		        
		        Form form = new Form();
		        form.add(Constants.CHANGE_USER_ID, "huytn");	
		        form.add(Constants.AFFECTED_USER_ID, id);
		        form.add(Constants.ROLE, role);
		        form.add(Constants.EXPIRED_DATE, expiredDate); 
		        form.add(Constants.REASON, reason);
		        
		        //Connect to server
		        WebResource service = connectService();
		        String serviceRespone = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_ADMIN_EDIT_USER)
		                  .type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class,form);
//		        System.out.println("Response " + serviceRespone);
		} catch (ClientHandlerException ex) {
			addActionError("Cannot connect to server");
		} catch (Exception ex) {
//			System.out.println(ex.getMessage());
		}
		return SUCCESS;
	}
	
	public String loadListUser() {
		 
		aaData = new ArrayList<ArrayList<String>>();
		
		try {
			         
			//Connect to service
	        WebResource service = connectService();
	        // getting XML data
	        String serviceRespone = service. path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_SEARCH_ALL_USERS)
	    		                  .accept(MediaType.APPLICATION_JSON).get(String.class);
	        
	        

			Gson gson = getCustomizeDateGson();
			List<User> users = gson.fromJson(serviceRespone, new TypeToken<List<User>>() {}.getType());
			
	        ArrayList<String> aData;
			
	        for (User user : users) {
				aData = new ArrayList<String>();
				aData.add(user.getId());
				aData.add(user.getEmail());
				aData.add(String.valueOf(user.getNoOfLikes()));
				aData.add(user.getRole());
				aData.add("<a href='#' class='edit-user'>Edit</a>");
				aaData.add(aData);
			}

	 } catch (ClientHandlerException ex) {
		 addActionError("Cannot connect to server");
	 } catch (Exception e) {
		 System.out.print(e.getMessage());
	 }
		
		
		return SUCCESS;
	}
	
	public String createUser() {
		try {
			
			Form form = new Form();
	        form.add(Constants.USER_ID,id);
	        form.add(Constants.USER_PASSWORD, password);
			WebResource service = connectService();
			// getting XML data
	        String serviceRespone = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_ADMIN_CREAT_USER)
	    		                  .accept(MediaType.APPLICATION_JSON).post(String.class,form);
			
		} catch(ClientHandlerException ex) {
			addActionError("Cannot connect to server");
		} catch (UniformInterfaceException e) {
			if (e.getMessage().contains("400 Bad Request")) {
				addActionError("this user is already exist");
			}
			System.out.print(e.getMessage());
		}
		return SUCCESS;
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getExpiredDate() {
		return expiredDate;
	}

	public void setExpiredDate(String expiredDate) {
		this.expiredDate = expiredDate;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	/**
	 * @return the email
	 */
	public String getEmail() {
		return email;
	}

	/**
	 * @param email the email to set
	 */
	public void setEmail(String email) {
		this.email = email;
	}

	/**
	 * @return the user
	 */
	public User getUser() {
		return user;
	}

	/**
	 * @param user the user to set
	 */
	public void setUser(User user) {
		this.user = user;
	}

}
