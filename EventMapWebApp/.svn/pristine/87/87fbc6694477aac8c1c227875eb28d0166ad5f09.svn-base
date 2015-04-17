package vn.com.lco.webapp.action.users;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.BaseAction;
import vn.com.lco.webapp.models.User;

import com.google.gson.Gson;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.representation.Form;

public class UserProfileAction extends BaseAction {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private User user;
	private Map<String, String> gender = buldGenderRadio();
	private List<String> genderValue = buldGenderRadioValue();
	private String loggedUserId = getCurrentUserId();
	private String userId;
	private String userSex;
	private int noOfBookmark;
	
	/**
	 * function use to get user Profile
	 */
	@Override
	public String execute() {
		
		if (userId == null || userId.isEmpty()) {
			return ERROR;
		}
		
		try {
			Form form = new Form();
	        form.add(Constants.USER_ID, userId);
	        WebResource service = connectService();
			String response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_USER_AUTHORITY_ID)
							 .type(MediaType.APPLICATION_FORM_URLENCODED).accept(MediaType.APPLICATION_JSON).post(String.class,form);
			
			Gson gson = getCustomizeDateGson();
			user = gson.fromJson(response, User.class);
			userSex = user.getSex();
			try {
				noOfBookmark = user.getSubcribedEvents().size();
			} catch (NullPointerException ex) {
				noOfBookmark = 0;
			}
			
			if(Constants.WRONG_USER.equals(user.getId())) {
				return ERROR;
		}
	
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		return SUCCESS;
	}
	
	public String saveUser() {
		try {
			
			WebResource service = connectService();
			String response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_USER_PROFILE_UPDATE)
							 .type(MediaType.APPLICATION_JSON)
							 .accept(MediaType.APPLICATION_JSON).post(String.class,user);
			
			Gson gson = getCustomizeDateGson();
			user = gson.fromJson(response, User.class);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return SUCCESS;
	}
	
	//*******************Private function**********************************//
	/**
	 * function use to map role from db to screen
	 * @param dbRole
	 * @return
	 */
	 private String resolveRoleString (String dbRole) {
		 switch(dbRole) {
		 	case Constants.UserRoles.ROLE_ADMIN: 
		 		return getText("label.common.role.admin");
		 	case Constants.UserRoles.ROLE_MOD:
		 		return getText("label.common.role.mod");
		 	case Constants.UserRoles.ROLE_MEMBER:
		 		return getText("label.common.role.member");
		 	case Constants.UserRoles.ROLE_BAN:
		 		return getText("label.common.role.banned");
		 }
		 
		 return null;
	 }
	 
	 private Map<String,String> buldGenderRadio() {
		 Map<String, String> newGenderList = new HashMap<String,String>();
		 newGenderList.put(Constants.User.USER_GEN_MALE_VAL,Constants.User.USER_GEN_MALE);
		 newGenderList.put(Constants.User.USER_GEN_FEMALE_VAL,Constants.User.USER_GEN_FEMALE);
		 
		 return newGenderList;
	 }
	 
	 private List<String> buldGenderRadioValue() {
		 List<String> newGenderList = new ArrayList<String>();
		 newGenderList.add(Constants.User.USER_GEN_MALE_VAL);
		 newGenderList.add(Constants.User.USER_GEN_FEMALE_VAL);
		 
		 return newGenderList;
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
	 * @return the genderValue
	 */
	public List<String> getGenderValue() {
		return genderValue;
	}

	/**
	 * @param genderValue the genderValue to set
	 */
	public void setGenderValue(List<String> genderValue) {
		this.genderValue = genderValue;
	}

	/**
	 * @return the gender
	 */
	public Map<String, String> getGender() {
		return gender;
	}

	/**
	 * @param gender the gender to set
	 */
	public void setGender(Map<String, String> gender) {
		this.gender = gender;
	}

	/**
	 * @return the loggedUserId
	 */
	public String getLoggedUserId() {
		return loggedUserId;
	}

	/**
	 * @param loggedUserId the loggedUserId to set
	 */
	public void setLoggedUserId(String loggedUserId) {
		this.loggedUserId = loggedUserId;
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

	public String getUserSex() {
		return userSex;
	}

	public void setUserSex(String userSex) {
		this.userSex = userSex;
	}

	public int getNoOfBookmark() {
		return noOfBookmark;
	}

	public void setNoOfBookmark(int noOfBookmark) {
		this.noOfBookmark = noOfBookmark;
	}

}
