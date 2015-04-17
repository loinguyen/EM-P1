package vn.com.lco.webapp.service;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;

import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.models.User;
import vn.com.lco.webapp.utils.DateUtils;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.api.representation.Form;

public class RestUserDetailService implements UserDetailsService {

    private Map<String, Date> sessionValidity = new HashMap<String, Date>();
    private Map<String, String> cookiesToUsers = new HashMap<String, String>();
    private Map<String, String> usersToCookies = new HashMap<String, String>();
    private User currentUser;
	@Override
	public UserDetails loadUserByUsername(String userName)
			throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		ClientConfig config = new DefaultClientConfig();
        Client client = Client.create(config);
        WebResource service = client.resource(UriBuilder.fromUri(Constants.API_URL).build());
        
        Form form = new Form();
        form.add(Constants.USER_ID, userName);
		String response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_USER_AUTHORITY_ID)
						 .type(MediaType.APPLICATION_FORM_URLENCODED).accept(MediaType.APPLICATION_JSON).post(String.class,form);
		
		try {
		ObjectMapper obj = new ObjectMapper();
		Map resource = obj.readValue(response, Map.class);
		String userId =(String) resource.get("id");
		String userPassword = (String) resource.get("password");
		String userRole = (String) resource.get("role");
		
		if (userId.equals("wrongUser")) {
			throw new UsernameNotFoundException("user not found");
		} else if (userId.equals("bannedUser")) {
			String bannedReason = (String)resource.get("bannedReason");
        	Long expiredDate = (Long)resource.get("expiredDate");
        	Date expriedDateValue = DateUtils.obtainDateFromAPI(expiredDate.toString());
        	String formatedDate = DateUtils.formatDate("dd/MM/yyyy", expriedDateValue);
        	
        	throw new UsernameNotFoundException("user banned until " + formatedDate + "<br/>reason: " + bannedReason);
		}
		User user = new User();
		user.setId(userId);
		user.setPassword(userPassword);
		user.setRole(userRole);
		setCurrentUser(user);
		return user;
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch(JsonParseException e) {
			e.printStackTrace();
		} catch (IOException io) {
			io.printStackTrace();
		}
		return null;
	}
	
	public void removeSSOSession(String cookie)
    {
        if (cookie != null)
        {
            String username = cookiesToUsers.get(cookie);
            if (username != null)
                usersToCookies.remove(username);
            cookiesToUsers.remove(cookie);
            sessionValidity.remove(cookie);
        }
    }
	
	public UserDetails loadUserByCookie(String cookie) throws UsernameNotFoundException, DataAccessException
    {
        Date sessionValidUntil = sessionValidity.get(cookie);
        Date now = new Date();
        if (sessionValidUntil == null || now.after(sessionValidUntil))
        {
            cookie = null;
        }
        return loadUserByUsername(cookiesToUsers.get(cookie));
    }

	public User getCurrentUser() {
		return currentUser;
	}

	public void setCurrentUser(User currentUser) {
		this.currentUser = currentUser;
	}

}
