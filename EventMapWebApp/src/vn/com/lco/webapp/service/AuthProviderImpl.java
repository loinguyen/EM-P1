package vn.com.lco.webapp.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.action.BaseAction;
import vn.com.lco.webapp.models.User;
import vn.com.lco.webapp.utils.DateUtils;

import com.google.gson.Gson;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;

@Component
public class AuthProviderImpl extends BaseAction implements AuthenticationProvider  {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	UserDetailsService userDetailService;

	@Override
	public Authentication authenticate(Authentication authentication)
			throws AuthenticationException {
		 String userName = authentication.getName().toLowerCase();
	     String password = authentication.getCredentials().toString();
	     User user = new User();
	     user.setId(userName);
	     user.setPassword(password);
	     
	     //connect to service to get authority.
		    ClientConfig config = new DefaultClientConfig();
	        Client client = Client.create(config);
	        WebResource service = client.resource(UriBuilder.fromUri(Constants.API_URL).build());
			String response = service.path(Constants.REST_PATH).path(Constants.RESOURCE_PATH_USER_AUTHORITY)
							 .type(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).post(String.class,user);
			
			Gson gson = getCustomizeDateGson();
			User searchedUser = gson.fromJson(response, User.class);
			//ArrayList reportList = (ArrayList)source.get("root");
			String searchedUserName = searchedUser.getId();
			     
	        if (searchedUserName.equals("wrongUser")) {
	            //throw new BadCredentialsException("bad username");
	            throw  new UsernameNotFoundException("Tên đăng nhập hoặc Mật khẩu không chính xác");
	        } else if(searchedUserName.equals("bannedUser")){
	        	Map source = jsonPaser(response);
	        	String bannedReason = (String)source.get("bannedReason");
	        	String expiredDate = (String)source.get("expiredDate");
	        	Date expriedDateValue = DateUtils.obtainDateFromAPI(expiredDate);
	        	String formatedDate = DateUtils.formatDate("dd/MM/yyyy", expriedDateValue);
	        	throw new DisabledException("Tài khoản của bạn bị khóa cho đến ngày "+ formatedDate + "<br /> <span>Lý do: " + bannedReason + "</span>");
	        }else {
	        	String searchedUserRole = searchedUser.getRole();
	        	String searchedPassword = searchedUser.getPassword();
	        	String searchedEmail = searchedUser.getEmail();
	        	User returnUser = new User();
	        	returnUser.setId(userName);
	        	returnUser.setPassword(searchedPassword);
	        	returnUser.setRole(searchedUserRole);
	        	returnUser.setEmail(searchedEmail);
	        	 List<GrantedAuthority> grantedAuths = new ArrayList<>();
		            grantedAuths.add(new SimpleGrantedAuthority(searchedUserRole));
		            Authentication auth = new UsernamePasswordAuthenticationToken(returnUser, searchedPassword, grantedAuths);
		            return auth;
	        }
	}

	@Override
	public boolean supports(Class<?> authentication) {
		// TODO Auto-generated method stub
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}
	


}
