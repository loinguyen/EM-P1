/**
 * Legend Company
 */
package vn.com.lco.api;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.converter.HttpMessageNotWritableException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import vn.com.lco.constants.AdminConstants;
import vn.com.lco.constants.EventConstants;
import vn.com.lco.dto.EventDTO;
import vn.com.lco.dto.EventPromotionLogDTO;
import vn.com.lco.dto.EventReportDTO;
import vn.com.lco.dto.TempEventDTO;
import vn.com.lco.dto.UserChangeLogDTO;
import vn.com.lco.dto.UserDTO;
import vn.com.lco.manager.EventManager;
import vn.com.lco.manager.UserManager;
import vn.com.lco.model.Event;
import vn.com.lco.model.EventReport;
import vn.com.lco.model.TempEvent;
import vn.com.lco.model.User;

/**
 * @author OaiPanda
 *
 * AdministrativeAPI.java
 */

@Controller
@RequestMapping("/admin")
public class AdministrativeAPI {
	
	@Autowired
	private UserManager userManager;
	
	@Autowired
	private EventManager eventManager;
	
	private static final Logger logger = LoggerFactory.getLogger(AdministrativeAPI.class);
	
	/*------------------------ Manage user menu ----------------------------*/
	/**
	 * Search list users by id(user name)
	 * 
	 * @return List<User>
	 */
	@RequestMapping(value="/users/all", method=RequestMethod.GET)
	public @ResponseBody List<User> findAllUsers() {
		
		List<User> listUser = userManager.findAllUsers();
				
		return listUser;
	}
	
	/**
	 * Create user by id(user name), password
	 * @param id String
	 * @param password String
	 * @return User
	 */
	@RequestMapping(value="/users/create", method=RequestMethod.POST, consumes = "application/x-www-form-urlencoded;charset=UTF-8")
	public @ResponseBody User createUser(
			@RequestParam String id,
			@RequestParam String password) {

		UserDTO userDTO = new UserDTO();
		userDTO.setId(id);
		userDTO.setPassword(password);
		userDTO.setRole(AdminConstants.ROLE_MEMBER);
		userDTO.setJoinedDate(new Date());
		User createdUser = userManager.create(userDTO);
		
		return createdUser;
	}
	
	/**
	 * Update user and create user change log
	 * @param changeUid String
	 * @param affectedUid String
	 * @param affectedRole String
	 * @param dateBan String
	 * @param reasonUpdate String
	 * @return User
	 */
	@RequestMapping(value="/users/update", method=RequestMethod.POST)
	public @ResponseBody User updateUser(
			@RequestParam String changeUid,
			@RequestParam String affectedUid,
			@RequestParam String affectedRole,
			@RequestParam String dateBan,
			@RequestParam String reasonUpdate) {

		try {
			// update user
			UserDTO userAffectedDTO = new UserDTO();
			userAffectedDTO.setId(affectedUid);
			userAffectedDTO.setRole(affectedRole);
			
			// create user change log field
			UserChangeLogDTO userChangeLogDTO = new UserChangeLogDTO();
			userChangeLogDTO.setChangeUid(changeUid);
			userChangeLogDTO.setAffectedUid(affectedUid);
			userChangeLogDTO.setCreatedDate(new Date());
			userChangeLogDTO.setReason(reasonUpdate);
			if (!dateBan.isEmpty()) {
				
				DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
				Date expriedDate = formatter.parse(dateBan);
				userChangeLogDTO.setExpriedDate(expriedDate);
			}
			
			return userManager.update(userAffectedDTO, userChangeLogDTO);
		} catch(Exception e) {
			logger.info("Exception of updateUser(): " + e.getMessage());
			if (e instanceof HttpMessageNotWritableException) {
				throw new HttpMessageNotWritableException(e.getMessage());
			}
		}
		
		return null;
	}
		
	/*------------------------ Manage update event menu ----------------------------*/
    /**
     * Search all temporary event which has status is null
     * @return List<TempEvent>
     */
    @RequestMapping(value="/tempEvents/all", method=RequestMethod.GET)
    public @ResponseBody List<TempEvent> findAllTempEvents() {
    	
    	return eventManager.findAllTempEvents();
    }
    
    /**
     * Find detail of a temporary event
     * @param id String
     * @return TempEvent
     */
    @RequestMapping(value="/tempEvents/get", method=RequestMethod.POST)
    public @ResponseBody TempEvent getTempEvent(@RequestParam String id) {
    	TempEventDTO tempEventUpdateDTO = new TempEventDTO();
    	tempEventUpdateDTO.setId(id);
    	
    	return eventManager.getTempEvent(tempEventUpdateDTO);
    }
    
    /**
     * Resolve(Approve, Reject) temporary event
     * @param id String
     * @param status String
     * @return TempEvent
     */
    @RequestMapping(value="/tempEvents/resolve", method=RequestMethod.PUT)
    public @ResponseBody TempEvent resolveUpdateEvent(
    				@RequestParam String id,
    				@RequestParam String status) {
    	
    	TempEventDTO tempEventUpdateDTO = new TempEventDTO();
    	tempEventUpdateDTO.setId(id);
    	tempEventUpdateDTO.setStatus(status);
    	tempEventUpdateDTO.setModDate(new Date());
    	
    	return eventManager.updateTempEventStatus(tempEventUpdateDTO);
    }

	/*------------------------ Manage report menu ----------------------------*/
	/**
	 * Get number of reports, title, category of event which has status is null
	 * @return List<EventReportDTO>
	 */
	@RequestMapping(value="/reportEvents/all", method=RequestMethod.GET)
	public @ResponseBody List<EventReportDTO> findAllReportEvents() {
		
		return eventManager.findAllReportEvents();
	}
	
	/**
	 * Get event title, list reports from id of event report
	 * @return EventReportDTO
	 */
	@RequestMapping(value="/reportEvents/get", method=RequestMethod.POST)
	public @ResponseBody EventReportDTO getListReports(@RequestParam String id) {
		
		EventReportDTO eventReportDTO = new EventReportDTO();
		eventReportDTO.setId(id);
		
		return eventManager.getListReports(eventReportDTO);
	}
	
	@RequestMapping(value="/reportEvents/resolve", method=RequestMethod.POST)
	public @ResponseBody EventReport resolveEventReport(
					@RequestParam String id,
					@RequestParam String modId) {
		
		EventReportDTO eventReportDTO = new EventReportDTO();
		eventReportDTO.setId(id);
		eventReportDTO.setModId(modId);
		eventReportDTO.setStatus(EventConstants.REPORT_DONE);
		eventReportDTO.setModDate(new Date());
		
		return eventManager.resolveEventReport(eventReportDTO);
	}
	
	/*------------------------ Manage rank menu----------------------------*/
	/**
	 * Find all rank events
	 * @return List<Event>
	 */
	@RequestMapping(value="/rankEvents/all", method=RequestMethod.GET)
	public @ResponseBody List<Event> findAllRankEvents() {
		
		return eventManager.findAllRankEvents();
	}
	
	/**
	 * Promote rank event
	 * @param eventId String
	 * @param userId String
	 * @param rank int
	 * @param reason String
	 * @return Event
	 */
	@RequestMapping(value="/rankEvents/promote", method=RequestMethod.POST)
	public @ResponseBody Event promoteEvent(
			@RequestParam String eventId,
			@RequestParam String userId,
			@RequestParam int rank,
			@RequestParam String reason) {
		
		EventDTO eventPromoteDTO = new EventDTO();
		eventPromoteDTO.setId(eventId);
		eventPromoteDTO.setRank(rank);
		
		EventPromotionLogDTO eventPromotionLogDTO = new EventPromotionLogDTO();
		eventPromotionLogDTO.setEventId(eventId);
		eventPromotionLogDTO.setUserId(userId);
		eventPromotionLogDTO.setReason(reason);
		
		return eventManager.promoteEvent(eventPromoteDTO, eventPromotionLogDTO);
	}
}
