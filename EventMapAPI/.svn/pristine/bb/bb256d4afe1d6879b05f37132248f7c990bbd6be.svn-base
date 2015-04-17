/**
 * Legend Company
 */
package vn.com.lco.manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.apache.commons.lang.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.BasicQuery;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.http.converter.HttpMessageNotWritableException;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.stereotype.Service;

import vn.com.lco.constants.AdminConstants;
import vn.com.lco.constants.Constants;
import vn.com.lco.dto.BookmarkDTO;
import vn.com.lco.dto.MessageDTO;
import vn.com.lco.dto.UserChangeLogDTO;
import vn.com.lco.dto.UserDTO;
import vn.com.lco.model.Conversation;
import vn.com.lco.model.EmailInteraction;
import vn.com.lco.model.Event;
import vn.com.lco.model.Notification;
import vn.com.lco.model.User;
import vn.com.lco.model.UserChangeLog;
import vn.com.lco.model.UserInteractLog;
import vn.com.lco.repository.ConversationRepository;
import vn.com.lco.repository.EmailInteractionRepository;
import vn.com.lco.repository.EventRepository;
import vn.com.lco.repository.NotificationRepository;
import vn.com.lco.repository.UserChangeLogRepository;
import vn.com.lco.repository.UserInteractLogRepository;
import vn.com.lco.repository.UserRepository;
import vn.com.lco.utility.CommonUtils;
import vn.com.lco.utility.EmailUtils;

import com.mongodb.BasicDBObject;

/**
 * @author OaiPanda
 *
 * UserManager.java
 */

@Service
public class UserManager {
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private UserChangeLogRepository userChangeLogRepository;
	
	@Autowired
	private MongoOperations mongoOperation;
	
	@Autowired
	private ConversationRepository conversationRepository;
	
	@Autowired
	private EventRepository eventRepository;
	
	@Autowired
	private NotificationRepository notificationRepository;
	
	@Autowired
	private EmailInteractionRepository emailInteractionRepository;
	
	@Autowired
	private UserInteractLogRepository userInteractLogRepository;
	
	/**
	 * Find all users and will return id, email, noOfLikes, role, sort by joinedDate 
	 * @return List<User>
	 */
	public List<User> findAllUsers() {
		
//		List<User> listUser = userRepository.findAll();
//		
//		return listUser;
		BasicQuery query = new BasicQuery("{}", "{ email : '1', noOfLikes: '1', role : '1' }");
		BasicDBObject sortObject = new BasicDBObject();
		sortObject.put("joinedDate", -1);
		query.setSortObject(sortObject);
		List<User> users = mongoOperation.find(query, User.class);
		
		return users;
	}
	
	/**
	 * Create user from id, password
	 * 
	 * @return User
	 */
	public User create(UserDTO userDTO) {
		// check User is exist or not
		User checkUser = userRepository.findById(userDTO.getId());
		//if user doesn't exist then create new user
		if (checkUser == null) {
			// Set user data
			Md5PasswordEncoder encoder = new Md5PasswordEncoder();
		    String hashedPass = encoder.encodePassword(userDTO.getPassword(), null).toUpperCase();
			//encode password to MD5. 
			User user = new User();
			user.setId(userDTO.getId().toLowerCase().trim());
			user.setPassword(hashedPass);
			user.setRole(userDTO.getRole());
			user.setJoinedDate(userDTO.getJoinedDate());
			
			user.setAddress(userDTO.getAddress());
			user.setDob(userDTO.getDob());
			user.setEmail(userDTO.getEmail());
			user.setJob(userDTO.getJob());
			
			return userRepository.save(user);
		
		//if user does exist then return null
		} else {
			throw new HttpMessageNotReadableException("user is already exist");
		}
	}
	
	public User signup(UserDTO userDTO) {

			// Set user data
			Md5PasswordEncoder encoder = new Md5PasswordEncoder();
			String hashedPass = encoder.encodePassword(userDTO.getPassword(), null).toUpperCase();
			//encode password to MD5. 
			User user = new User();
			user.setId(userDTO.getId().toLowerCase().trim());
			user.setPassword(hashedPass);
			user.setRole(userDTO.getRole());
			user.setJoinedDate(userDTO.getJoinedDate());
			
			user.setAddress(userDTO.getAddress());
			user.setDob(userDTO.getDob());
			user.setEmail(userDTO.getEmail().toLowerCase());
			user.setJob(userDTO.getJob());
			
			User returnUser = userRepository.save(user);
			
			EmailInteraction interaction = new EmailInteraction();
			interaction.setUserId(returnUser.getId());;
			interaction.setType(Constants.EmailInteraction.TYPE_ACTIVATE);
			interaction =  emailInteractionRepository.save(interaction);
			
			EmailUtils.sendActivationEmail(user.getEmail(), user.getId(), interaction.getId());
			
			return returnUser;
	}
	
	public String handleEmailInteraction(String id) {
		EmailInteraction emailInteraction = emailInteractionRepository.findById(id);
		String type = emailInteraction.getType();
		User user = userRepository.findById(emailInteraction.getUserId());
		
		if (Constants.EmailInteraction.TYPE_ACTIVATE.equals(type)) {
			user.setRole(AdminConstants.ROLE_MEMBER);
		} else if (Constants.EmailInteraction.TYPE_RESET_PASSWORD.equals(type)) {
			String newpwd = RandomStringUtils.randomAlphanumeric(8);
			Md5PasswordEncoder encoder = new Md5PasswordEncoder();
			String hashedPass = encoder.encodePassword(newpwd, null).toUpperCase();
			user.setPassword(hashedPass);
			EmailUtils.sendNewPwdEmail(user.getEmail(), user.getId(), newpwd);
		}
		
		user = userRepository.save(user);
		emailInteraction.setType(null);
		emailInteractionRepository.save(emailInteraction);
		return type;
	}
	public String forgotpwd(String email) {
		
		User user = userRepository.findByEmail(email);
		if (user == null) return null;
		String userId = user.getId();
		EmailInteraction emailInteraction = new EmailInteraction();
		emailInteraction.setUserId(userId);
		emailInteraction.setType(Constants.EmailInteraction.TYPE_RESET_PASSWORD);
		emailInteraction = emailInteractionRepository.save(emailInteraction);
		
		EmailUtils.sendResetPwdEmail(email, userId, emailInteraction.getId());
		
		return userId;
	}
	
	/**
	 *function use to update User Profile only 
	 * @param requestDTO contain userProfile
	 * @return User user after updated
	 */
	public User updateUserProfile(UserDTO requestDTO) {
		User findUser = userRepository.findById(requestDTO.getId());
		if (findUser != null) {
			findUser.setAddress(requestDTO.getAddress());
			findUser.setDob(requestDTO.getDob());
			findUser.setEmail(requestDTO.getEmail());
			findUser.setJob(requestDTO.getJob());
			findUser.setSex(requestDTO.getSex());
			
			return userRepository.save(findUser);
		} else {
			throw new HttpMessageNotReadableException("user doesn't exists");
		}
	}
	/**
	 * function use to update User Role by Admin
	 * @param userAffectedDTO
	 * @param userChangeLogDTO
	 * @return
	 */
	public User update(UserDTO userAffectedDTO, UserChangeLogDTO userChangeLogDTO) {
		
		// Update user
		User existingUser = userRepository.findById(userAffectedDTO.getId());
		
		//check user exist
		if (existingUser == null) {
			return null;
		}
		//check user is banned
		if(userAffectedDTO.getRole().equals(AdminConstants.ROLE_BAN)) {
			if (existingUser.getRole().equals(AdminConstants.ROLE_BAN)) {
				throw new HttpMessageNotWritableException("user is already banned");
			}
		}
		existingUser.setId(userAffectedDTO.getId());
		existingUser.setRole(userAffectedDTO.getRole());
		
		// Create user change log
		UserChangeLog userChangeLog = new UserChangeLog();
		userChangeLog.setId(UUID.randomUUID().toString());
		userChangeLog.setChangeUId(userChangeLogDTO.getChangeUid());
		userChangeLog.setAffectedUId(userChangeLogDTO.getAffectedUid());
		userChangeLog.setCreatedDate(userChangeLogDTO.getCreatedDate());
		userChangeLog.setReason(userChangeLogDTO.getReason());
		if (userChangeLogDTO.getExpriedDate() != null) {
			
			userChangeLog.setExpiredDate(userChangeLogDTO.getExpriedDate());
		}
		userChangeLogRepository.save(userChangeLog);
		
		return userRepository.save(existingUser);
	}
	
	public UserDTO findIdPassword(String userName, String password) {
		
		UserDTO createdUserDTO;
		
		Md5PasswordEncoder encoder = new Md5PasswordEncoder();
	    String hashedPass = encoder.encodePassword(password, null).toUpperCase();
	    
		User searchedUser = userRepository.findById(userName.toLowerCase().trim());
		if (searchedUser != null) {
			if (searchedUser.getPassword().equals(hashedPass)) {
				if (searchedUser.getRole().equals(AdminConstants.ROLE_BAN)) {
					List<UserChangeLog> userChangeLogList = userChangeLogRepository.findByAffectedUIdAndExpiredDateNotNull(userName, new Sort(Sort.Direction.DESC,"expiredDate"));
					UserChangeLog userChangeLog = userChangeLogList.get(0);
					User bannedUser = new User();
					bannedUser.setId("bannedUser");
					createdUserDTO = createUserDTO(bannedUser);
					createdUserDTO.setBannedReason(userChangeLog.getReason());
					createdUserDTO.setExpiredDate(userChangeLog.getExpiredDate());
					return createdUserDTO;
				} else {
					createdUserDTO = createUserDTO(searchedUser);
					return createdUserDTO;
				}
			}
		}
		
		User wrongUser = new User();
		wrongUser.setId("wrongUser");
		createdUserDTO = createUserDTO(wrongUser);
		return createdUserDTO; 
	}
	
	public UserDTO findUserById (String userName) {
		
		UserDTO createdUserDTO;
		User searchedUser = userRepository.findById(userName.toLowerCase().trim());
		if (searchedUser != null) {
				if (searchedUser.getRole().equals(AdminConstants.ROLE_BAN)) {
					List<UserChangeLog> userChangeLogList = userChangeLogRepository.findByAffectedUIdAndExpiredDateNotNull(userName, new Sort(Sort.Direction.DESC,"expiredDate"));
					UserChangeLog userChangeLog = userChangeLogList.get(0);
					User bannedUser = new User();
					bannedUser.setId("bannedUser");
					createdUserDTO = createUserDTO(bannedUser);
					createdUserDTO.setBannedReason(userChangeLog.getReason());
					createdUserDTO.setExpiredDate(userChangeLog.getExpiredDate());
					return createdUserDTO;
				} else {
					createdUserDTO = createUserDTO(searchedUser);
					return createdUserDTO;
				}
		}
		User wrongUser = new User();
		wrongUser.setId("wrongUser");
		createdUserDTO = createUserDTO(wrongUser);
		return createdUserDTO; 
	}
	
	public User findUserByUsername (String userName) {
		return userRepository.findById(userName.toLowerCase().trim());
	}
	
	
	public UserDTO findUserByEmail (String email) {
		
		User searchedUser = userRepository.findByEmail(email.toLowerCase());
		
		return searchedUser == null ? null : createUserDTO(searchedUser);  
	}
	public User changepwd (String userId, String newpwd) {
		
		User user = userRepository.findById(userId);
		Md5PasswordEncoder encoder = new Md5PasswordEncoder();
	    String hashedPass = encoder.encodePassword(newpwd, null).toUpperCase();
	    user.setPassword(hashedPass);

	    userRepository.save(user);
	    
		return user;  
	}
	
	/**
	 * function create conversation between 2 user
	 * @param requestDTO contain conservation data
	 * @return resultMessage return created conservation
	 */
	public Conversation createConservation (MessageDTO requestDTO) {
		
		Conversation newConversation = new Conversation();
		newConversation.setCreatedDate(new Date());
		newConversation.setSender(requestDTO.getSender());
		newConversation.setReceiver(requestDTO.getReceiver());
		newConversation.setUnreadUid(requestDTO.getReceiver());// receiver hasn't read the message yet.
		newConversation.setMessages(requestDTO.getMessageList());
		
		Conversation resultMessage = conversationRepository.save(newConversation);
		
		return resultMessage;
	}
	
	public Conversation createMessage (MessageDTO requestDTO) {
		Conversation newConversation = new Conversation();
		
		//find Conversation
		Conversation conversation = conversationRepository.findOne(requestDTO.getConversId());
		
		if (conversation != null) {
			conversation.setUnreadUid(requestDTO.getReceiver());// change unread uid to whom receive this message
			conversation.getMessages().add(requestDTO.getMessageList().get(0));// get the Message save in requestDTO
			newConversation = conversationRepository.save(conversation);
		}else {
			throw new HttpMessageNotReadableException("conversation not found");
		}
		return newConversation;
	}
	
	/**
	 * function use to create Book mark for user.
	 * @param requestDTO
	 * @return
	 */
	public Notification createBookMark(BookmarkDTO requestDTO) {
		
		// insert to userInteractLog
		UserInteractLog userInteractLog = new UserInteractLog();
		userInteractLog.setId(UUID.randomUUID().toString());
		userInteractLog.setEventId(requestDTO.getEventId());
		userInteractLog.setTimeLog(new Date());
				
		// add event to subscribe list of user
		User user = userRepository.findById(requestDTO.getUserId());
		List<String> events = user.getSubcribedEvents();
		if (events != null) {
			int index = events.indexOf(requestDTO.getEventId());
			if (index > -1) {
				events.remove(index);
				userInteractLog.setOperation(Constants.userInteract.OPERATON_UNSUBSCRIBE);
			} else { 
				user.getSubcribedEvents().add(requestDTO.getEventId());
				userInteractLog.setOperation(Constants.userInteract.OPERATON_SUBSCRIBE);
			}
		}else {
			List<String> eventList = new ArrayList<String>();
			eventList.add(requestDTO.getEventId());
			user.setSubcribedEvents(eventList);
			userInteractLog.setOperation(Constants.userInteract.OPERATON_SUBSCRIBE);
		}
		
		userRepository.save(user);
		
		// add user to list subscriber of event
		Event event = eventRepository.findOne(requestDTO.getEventId());
		List<String> users = event.getSubscribers();
		if (users != null) { 
			int i = users.indexOf(requestDTO.getUserId());
			if (i > -1) {
				users.remove(i);
			} else {
				event.getSubscribers().add(requestDTO.getUserId());
			}
		} else {
			List<String> usersList = new ArrayList<String>();
			usersList.add(requestDTO.getUserId());
			event.setSubscribers(usersList);
		}
		
		eventRepository.save(event);
		
		// create Notification for User.
		Notification notification = notificationRepository.findByEventIdAndUserId(requestDTO.getEventId(), requestDTO.getUserId());
		if (notification != null) {
			notificationRepository.delete(notification);
			Notification newNotification = new Notification();
			newNotification.setStatus(Constants.Notify.STATUS_DELETED);
			newNotification.setSubscriberId(requestDTO.getUserId());
			newNotification.setEventId(requestDTO.getEventId());
			return newNotification;
		}
		Notification newNotification = new Notification();
		newNotification.setSubscriberId(requestDTO.getUserId());
		newNotification.setEventId(requestDTO.getEventId());
		newNotification.setUserCommentList(null);
		newNotification.setUserUpdateList(null);
		newNotification.setStatus(Constants.Notify.STATUS_READ);
		
		CommonUtils.saveUserInteractLog(userInteractLogRepository, userInteractLog);
		
		return notificationRepository.save(newNotification);
		
	}
	
	/**
	 * function use to update status of a notification
	 * @param requestDTO BookmarkDTO contain information about bookMark update status.
	 */
	public Notification updateBookMarkStatus(BookmarkDTO requestDTO){
		Notification searchedNotification = notificationRepository.findByEventIdAndUserId(requestDTO.getEventId(), requestDTO.getUserId());
		searchedNotification.setStatus(Constants.Notify.STATUS_READ);
		
		return notificationRepository.save(searchedNotification);
	}
	
	/**
	 * function use to remove bookmark and notification
	 * @param requestDTO
	 */
	public String unBookMark(BookmarkDTO requestDTO) {
		
		try {
			
			// remove subcribers List in Event
			Event event = eventRepository.findOne(requestDTO.getEventId());
			List<String> users = event.getSubscribers();
			if (users != null) {
				int i = users.indexOf(requestDTO.getUserId());
				if (i > -1) {
					users.remove(i);
					eventRepository.save(event);
				}
				
			}
			
			// remove subscribeEvent list
			User user = userRepository.findById(requestDTO.getUserId());
			List<String> eventList = user.getSubcribedEvents();
			if (eventList != null) {
				int index = eventList.indexOf(requestDTO.getEventId());
				if (index > -1) {
					eventList.remove(index);
					userRepository.save(user);
				}
			}
			// remove notification
			Notification notification = notificationRepository.findByEventIdAndUserId(requestDTO.getEventId(), requestDTO.getUserId());
			if (notification != null) {
				notificationRepository.delete(notification);
			}
			
			// insert to userInteractLog
			UserInteractLog userInteractLog = new UserInteractLog();
			userInteractLog.setId(UUID.randomUUID().toString());
			userInteractLog.setOperation(Constants.userInteract.OPERATON_UNSUBSCRIBE);
			userInteractLog.setEventId(requestDTO.getEventId());
			userInteractLog.setTimeLog(new Date());
			
			CommonUtils.saveUserInteractLog(userInteractLogRepository, userInteractLog);

			return "ok";
		} catch (Exception e) {
			
			return "fail";
		}
	}
	
	public List<Notification> getAllUserNotification (BookmarkDTO requestDTO) {
		List<Notification> listNotify = notificationRepository.findBySubscriberId(requestDTO.getUserId(), new Sort(Sort.Direction.DESC,"status"));
		return listNotify;
	}
	
	//------Private method------------------------------
	
	/**
	 * use to transfer data from user object to userDTO
	 * @param user user object contain information
	 * @return userDTo
	 */
	private UserDTO createUserDTO (User user) {
		UserDTO userDTO = new UserDTO();
		userDTO.setId(user.getId());
		userDTO.setPassword(user.getPassword());
		userDTO.setAddress(user.getAddress());
		userDTO.setDob(user.getDob());
		userDTO.setEmail(user.getEmail());
		userDTO.setRole(user.getRole());
		userDTO.setJoinedDate(user.getJoinedDate());
		userDTO.setNoOfCreatedEvents(user.getNoOfCreatedEvents());
		userDTO.setNoOfLikes(user.getNoOfLikes());
		userDTO.setSex(user.getSex());
		userDTO.setJob(user.getJob());
		
		return userDTO;
	}
}