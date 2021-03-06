package vn.com.lco.api;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import vn.com.lco.constants.AdminConstants;
import vn.com.lco.dto.BookmarkDTO;
import vn.com.lco.dto.MessageDTO;
import vn.com.lco.dto.UserDTO;
import vn.com.lco.manager.UserManager;
import vn.com.lco.model.Conversation;
import vn.com.lco.model.Message;
import vn.com.lco.model.Notification;
import vn.com.lco.model.User;

@Controller
@RequestMapping("/user")
public class UserManageAPI {

	@Autowired
	private UserManager userManager;
	
	//---API-----------
	@RequestMapping(value="/findbyIdPassword", method=RequestMethod.POST)
	public @ResponseBody UserDTO getUserbyIdPassword(@RequestBody User user){
		UserDTO searchedUser = userManager.findIdPassword(user.getId(), user.getPassword());
		
		return searchedUser;
	}
	
	@RequestMapping(value="/findbyId", method=RequestMethod.POST)
	public @ResponseBody UserDTO getUserbyId(@RequestParam String id){
		UserDTO searchedUser = userManager.findUserById(id);
		
		return searchedUser;
	}
	
	@RequestMapping(value="/findbyEmail", method=RequestMethod.POST)
	public @ResponseBody UserDTO getUserbyEmail(@RequestParam String email){
		UserDTO searchedUser = userManager.findUserByEmail(email);
		
		return searchedUser;
	}
	@RequestMapping(value="/findbyUsername", method=RequestMethod.POST)
	public @ResponseBody User getUserbyUsername(@RequestParam String userName){
		
		return userManager.findUserByUsername(userName);
	}
	
	@RequestMapping(value="/signup", method=RequestMethod.POST)
	public @ResponseBody User signup(@RequestBody User user) {
		UserDTO userDto = new UserDTO();
		userDto.setId(user.getId());
		userDto.setEmail(user.getEmail());
		userDto.setPassword(user.getPassword());
		userDto.setRole(AdminConstants.ROLE_INACTIVE);
		userDto.setJoinedDate(new Date());
		
		return userManager.signup(userDto);
	}
	@RequestMapping(value="/handleEmail", method=RequestMethod.POST)
	public @ResponseBody String handleEmail(@RequestBody String id) {
		return userManager.handleEmailInteraction(id);
	}
	@RequestMapping(value="/forgotpwd", method=RequestMethod.POST)
	public @ResponseBody String forgotpwd(@RequestBody String email) {
		return userManager.forgotpwd(email);
	}
	@RequestMapping(value="/changepwd", method=RequestMethod.POST)
	public @ResponseBody User changepwd(@RequestBody User user) {
		return userManager.changepwd(user.getId(), user.getPassword());
	}
	
	@RequestMapping(value="/update", method=RequestMethod.POST)
	public @ResponseBody User updateUserProfile(@RequestBody User user) {
		UserDTO requestDTO = new UserDTO();
		requestDTO.setId(user.getId());
		requestDTO.setAddress(user.getAddress());
		requestDTO.setDob(user.getDob());
		requestDTO.setEmail(user.getEmail());
		requestDTO.setJob(user.getJob());
		requestDTO.setSex(user.getSex());
		
		return userManager.updateUserProfile(requestDTO);
	}
	
	@RequestMapping(value="/createConversation", method=RequestMethod.POST)
	public @ResponseBody Conversation createConversation(
								@RequestParam String sender,
								@RequestParam String receiver,
								@RequestParam String messageContent){
		
		MessageDTO requestDTO = new MessageDTO();
		requestDTO.setSender(sender);
		requestDTO.setReceiver(receiver);
		
		List<Message> messList = new ArrayList<Message>();
		Message newMessage = new Message();
		newMessage.setUserId(sender);
		newMessage.setContent(messageContent);
		newMessage.setCreatedDate(new Date());
		messList.add(newMessage);
		requestDTO.setMessageList(messList);
		Conversation newConversation = userManager.createConservation(requestDTO);
		return newConversation;
	}
	
	@RequestMapping(value="/sendMessage", method=RequestMethod.POST)
	public @ResponseBody Conversation sendMessage(
										@RequestParam String id,
										@RequestParam String sender,
										@RequestParam String receiver,
										@RequestParam String messageContent){
		Conversation returnConvers = new Conversation();
		MessageDTO requestDTO = new MessageDTO();
		requestDTO.setSender(sender);
		requestDTO.setReceiver(receiver);
		requestDTO.setConversId(id);
		
		List<Message> messList = new ArrayList<Message>();
		Message newMessage = new Message();
		newMessage.setUserId(sender);
		newMessage.setContent(messageContent);
		newMessage.setCreatedDate(new Date());
		messList.add(newMessage);
		requestDTO.setMessageList(messList);
		
		return returnConvers;
	}
	
	@RequestMapping(value="/createBookMark", method=RequestMethod.POST)
	public @ResponseBody Notification createBookMark(
										@RequestParam String eventId,
										@RequestParam String userId,
										@RequestParam String lastViewComment) {
		Notification returnNotification = new Notification();
		BookmarkDTO requestDTO = new BookmarkDTO();
		requestDTO.setEventId(eventId);
		requestDTO.setUserId(userId);
		requestDTO.setLastViewComment(lastViewComment);
		returnNotification = userManager.createBookMark(requestDTO);
		return returnNotification;
		
	}
	
	@RequestMapping(value="/unBookMark", method=RequestMethod.POST)
	public @ResponseBody String unBookMark(@RequestParam String eventId, @RequestParam String userId){
		
		BookmarkDTO requestDTO = new BookmarkDTO();
		requestDTO.setEventId(eventId);
		requestDTO.setUserId(userId);
		
		String result = userManager.unBookMark(requestDTO); 
		return result;
	}
	
	@RequestMapping(value="/updateBookMark", method=RequestMethod.POST)
	 public @ResponseBody Notification updateBookMarkStatus(@RequestParam String userId,
			 						  @RequestParam String eventId) {
		BookmarkDTO requestDTO = new BookmarkDTO();
		requestDTO.setUserId(userId);
		requestDTO.setEventId(eventId);
		
		return userManager.updateBookMarkStatus(requestDTO);
		 
		
	}
	
	@RequestMapping(value="/getAllNotification", method=RequestMethod.POST)
	public @ResponseBody List<Notification> getListUserNotification(@RequestParam String userId) {
		BookmarkDTO requestDTO = new BookmarkDTO();
		requestDTO.setUserId(userId);
		
		return userManager.getAllUserNotification(requestDTO);
		
	}
	
}
