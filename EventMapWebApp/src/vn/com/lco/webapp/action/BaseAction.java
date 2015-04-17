package vn.com.lco.webapp.action;

import java.lang.reflect.Type;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.UriBuilder;

import org.apache.struts2.ServletActionContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import vn.com.lco.webapp.models.User;
import vn.com.lco.webapp.utils.DateUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.json.parsers.JSONParser;
import com.json.parsers.JsonParserFactory;
import com.opensymphony.xwork2.ActionSupport;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;

public class BaseAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Override
	public String execute() {
		return SUCCESS;
	}
	
	public WebResource connectService() {
	    ClientConfig config = new DefaultClientConfig();
        Client client = Client.create(config);
        String url = getText("api.url");
        WebResource service = client.resource(UriBuilder.fromUri(url).build());
        
        return service;
	
	}
	public Map jsonPaser(String serviceResponse) {
		try {
			JsonParserFactory factory=JsonParserFactory.getInstance();
	        JSONParser parser= factory.newJsonParser();
	        Map jsonData=parser.parseJson(serviceResponse);
	        return jsonData;
		}catch (Exception e) {
//			System.out.println(e.getMessage());
		}
		// if result is blank then return a blank map
        Map blankJson = new HashMap();
        return blankJson;
	}
	
	/**
	 * get current Logging User
	 * @return
	 */
	public String getCurrentUserId() {
		Object user = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		if (user instanceof UserDetails) {
			User tmp = (User) user;
        	return tmp.getId();
        } else if(user instanceof String) {
        	User tmp = new User();
        	tmp.setId((String)user);
        	return (String)user;
        }else {
        	return null;
        }
	}
	
	/**
	 * get httpRequest
	 * @return HttpServletRequest
	 */
    protected HttpServletRequest getRequest() {
        return ServletActionContext.getRequest();
    }
	
	protected Gson getCustomizeDateGson() {
		return new GsonBuilder().registerTypeAdapter(Date.class,
				new JsonDeserializer<Date>() {

					@Override
					public Date deserialize(JsonElement arg0, Type arg1,
							JsonDeserializationContext arg2)
							throws JsonParseException {

						return DateUtils.obtainDateFromAPI(arg0.getAsString());
					}
				}).create();
	}
}
