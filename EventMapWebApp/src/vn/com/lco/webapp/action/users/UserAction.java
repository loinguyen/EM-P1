/**
 * 
 */
package vn.com.lco.webapp.action.users;

import java.io.File;

import javax.ws.rs.core.MediaType;

import org.apache.commons.io.FileUtils;
import org.apache.struts2.ServletActionContext;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.BaseAction;
import vn.com.lco.webapp.models.User;

import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.representation.Form;

/**
 * @author Huy
 *
 */
public class UserAction extends BaseAction {

	private static final long serialVersionUID = 1L;
	private String userName;
	private String email;
	private User user;
	private String newpwd;
	private static String imgRoot = new StringBuilder(ServletActionContext.getServletContext().getRealPath(Constants.File_Dir.IMAGE_DIR)).toString();
	
	public String changepwd() {
		user.setId(getCurrentUserId());
		WebResource service = connectService();
		String response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_USER_AUTHORITY)
				 .type(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).post(String.class,user);
		user = getCustomizeDateGson().fromJson(response, User.class);
		if (Constants.WRONG_USER.equals(user.getId())) {
			addActionError("Mật khẩu không chính xác");
			return SUCCESS;
		}
		user.setPassword(newpwd);
		response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_USER_CHANGE_PWD)
				 .type(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).post(String.class,user);
		user = getCustomizeDateGson().fromJson(response, User.class);
		return SUCCESS;
	}
	public String findByEmail() {
		try {
			
			Form form = new Form();
			form.add(Constants.USER_EMAIL, email);
			WebResource service = connectService();
			// getting XML data
			String serviceRespone = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_USER_FIND_BY_EMAIL)
					.accept(MediaType.APPLICATION_JSON).post(String.class,form);
			user = getCustomizeDateGson().fromJson(serviceRespone, User.class);
		} catch(Exception e) {
			user = null;
		}
		return SUCCESS;
	}
	public String findbyUsername() {
		try {
			
			Form form = new Form();
			form.add("userName", userName);
			WebResource service = connectService();
			
			String serviceRespone = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_USER_FIND_BY_USERNAME)
					.accept(MediaType.APPLICATION_JSON).post(String.class,form);
			user = getCustomizeDateGson().fromJson(serviceRespone, User.class);
		} catch(Exception e) {
			user = null;
		}
		return SUCCESS;
	}
	public String signup() {
		try {
			
			User newUser = user;
			
			userName = user.getId();
			email = user.getEmail();
			
			this.findbyUsername();
			if (user != null) {
				addActionError("Tên đăng nhập đã tồn tại");
				if (email.equals(user.getEmail())) {
					addActionError("Email đã tồn tại");
					email = null;
				}
			}
			
			if (email != null) {
				this.findByEmail();
				if (user != null) {
					addActionError("Email đã tồn tại");
				}
			}
			if (!getActionErrors().isEmpty()) return SUCCESS;
			
			
			WebResource service = connectService();
			
			String serviceRespone = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_USER_SIGNUP)
					.type(MediaType.APPLICATION_JSON)
					.accept(MediaType.APPLICATION_JSON).post(String.class, newUser);
			user = getCustomizeDateGson().fromJson(serviceRespone, User.class);
			
			 File avapath = new File(imgRoot);			
				
			 if (avapath.exists()) {
				 String toavadir =  new StringBuilder()
			 						.append(imgRoot).append(File.separator).append(Constants.File_Dir.USR_IMAGE_DIR).append(File.separator).append(user.getId()).toString();
				 File toavapath = new File(toavadir);
				 
				 if (!toavapath.exists()) {
					 toavapath.mkdir();
				 }
				 
				 File defaultava  = new File(avapath, "avatar.jpg");
				 File destFile  = new File(toavapath, "avatar.jpg");
				 
				 FileUtils.copyFile(defaultava, destFile);
			 }
			
			
		} catch(Exception e) {
			user = null;
		}
		return SUCCESS;
	}
	
	public String forgotpwd() {
		return INPUT;
	}
	
	public String resetpwd() {
		
		WebResource service = connectService();
		userName = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_FORGOT_PWD)
				.accept(MediaType.APPLICATION_JSON).post(String.class, email);
		
		return SUCCESS;
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
	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}
	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}
	/**
	 * @return the newpwd
	 */
	public String getNewpwd() {
		return newpwd;
	}
	/**
	 * @param newpwd the newpwd to set
	 */
	public void setNewpwd(String newpwd) {
		this.newpwd = newpwd;
	}
	
}
