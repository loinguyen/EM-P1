package vn.com.lco.api;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import vn.com.lco.constants.EventConstants;
import vn.com.lco.dto.CommentDTO;
import vn.com.lco.dto.EventDTO;
import vn.com.lco.dto.EventPromotionLogDTO;
import vn.com.lco.dto.EventSearchDTO;
import vn.com.lco.dto.NotificationContentDTO;
import vn.com.lco.dto.NotificationDTO;
import vn.com.lco.dto.TempEventDTO;
import vn.com.lco.manager.EventManager;
import vn.com.lco.model.Comment;
import vn.com.lco.model.Event;
import vn.com.lco.model.EventReport;
import vn.com.lco.model.Report;
import vn.com.lco.model.TempEvent;
import vn.com.lco.model.TrendingHotEvent;
import vn.com.lco.utility.DateUtils;

import com.google.gson.Gson;

/**
 * @author LoiNM
 * 
 *         AdministrativeAPI.java
 */

@Controller
@RequestMapping("/event")
public class EventManageAPI {

	@Autowired
	private EventManager eventManager;

	/*------------------------ Manage event menu ----------------------------*/

	@RequestMapping(value = "/allBookMarkEvent", method= RequestMethod.POST)
	public @ResponseBody List<Event> findAllBookMarkEvent(@RequestParam String userId) {
		List<Event> listReturnEvent = new ArrayList<Event>();
		
		EventSearchDTO requestDTO = new EventSearchDTO();
		requestDTO.setUid(userId);
		listReturnEvent = eventManager.findAllBookMarkEvent(requestDTO);
		
		return listReturnEvent;
	}
	/**
	 * Find all events are valid
	 * 
	 * @param categoryCondition String
	 * @param dateCondition String
	 * @return List<Event>
	 */
	@RequestMapping(value = "/allValid", method = RequestMethod.POST)
	public @ResponseBody List<Event> findAllValidEvent(
									@RequestParam String categoryCondition,
									@RequestParam String dateCondition) {
		List<Event> listReturnEvent = new ArrayList<Event>();
		
		//build requestDTO
		EventSearchDTO requestDTO = new EventSearchDTO();
		requestDTO.setCategory(categoryCondition);
		Date dateFence = DateUtils.converDatefromString(dateCondition);
		requestDTO.setDate(dateFence);
		
		listReturnEvent = eventManager.findEventsByCondition(requestDTO);
		return listReturnEvent;
	}
	
	/**
	 * Find all events
	 * 
	 * @return List<Event>
	 */
	@RequestMapping(value = "/all", method = RequestMethod.GET)
	public @ResponseBody List<Event> findAllEvents() {

		List<Event> events = eventManager.findAllEvents();

		return events;
	}

	/**
	 * Find event by eventId
	 * 
	 * @param eId String
	 * @return Event
	 */
	@RequestMapping(value = "/find/id", method = RequestMethod.POST, consumes = "application/x-www-form-urlencoded;charset=UTF-8")
	public @ResponseBody
	Event findEventById(@RequestParam String eId) {

		return eventManager.findEventById(eId);
	}

	/**
	 * Create event full properties
	 * 
	 * @param id String
	 * @param password String
	 * @return User
	 */
	@RequestMapping(value="/create", method=RequestMethod.POST)
	public @ResponseBody Event createEvent(@RequestBody Event event) {

		// create eventDTO to transfer data to lower layer
		EventDTO eventDTO = new EventDTO();
		eventDTO.setTitle(event.getTitle());
		eventDTO.setCategory(event.getCategory());
		eventDTO.setLocation(event.getLocation());
		eventDTO.setAddress(event.getAddress());
		eventDTO.setContact(event.getContact());
		eventDTO.setShortDes(event.getShortDes());
		eventDTO.setFullDes(event.getFullDes());
		eventDTO.setAlbum(event.getAlbum());
		eventDTO.setRank(EventConstants.EVENT_DEFAULT_RANK); 
		eventDTO.setFromDate(event.getFromDate());
		eventDTO.setToDate(event.getToDate());
		eventDTO.setCreatedDate(new Date());
		eventDTO.setUserId(event.getUserId());
		eventDTO.setType(event.getType());
		eventDTO.setModDate(new Date());
		eventDTO.setTag("");

		// call Manager
		Event newEvent = eventManager.saveEvent(eventDTO);

		return newEvent;
	}
	
	@RequestMapping(value="/save", method=RequestMethod.POST)
	public @ResponseBody Event save(@RequestBody Event event) {

		// create eventDTO to transfer data to lower layer
		EventDTO eventDTO = new EventDTO();
		eventDTO.setId(event.getId());
		eventDTO.setTitle(event.getTitle());
		eventDTO.setCategory(event.getCategory());
		eventDTO.setLocation(event.getLocation());
		eventDTO.setAddress(event.getAddress());
		eventDTO.setContact(event.getContact());
		eventDTO.setShortDes(event.getShortDes());
		eventDTO.setFullDes(event.getFullDes());
		eventDTO.setAlbum(event.getAlbum());
		eventDTO.setRank(event.getRank()); 
		eventDTO.setFromDate(event.getFromDate());
		eventDTO.setToDate(event.getToDate());
		eventDTO.setCreatedDate(event.getCreatedDate());
		eventDTO.setUserId(event.getUserId());
		eventDTO.setType(event.getType());
		eventDTO.setModDate(new Date());
		eventDTO.setPoint(event.getPoint());
		eventDTO.setTag(event.getTag());

		// call Manager
		Event newEvent = eventManager.saveEvent(eventDTO);

		return newEvent;
	}

	/**
	 * Update event from user
	 * 
	 * @param userId String
	 * @param event String
	 * @return Event
	 */
	@RequestMapping(value = "/update", method = RequestMethod.POST, consumes = "application/x-www-form-urlencoded;charset=UTF-8")
	public @ResponseBody Event updateEvent(@RequestParam String userId, @RequestParam String event) {
		Date currDate = new Date();
		Gson gson = new Gson();
		Event newEvent = gson.fromJson(event, Event.class);

		if (EventConstants.EVENT_TYPE_PRIVATE.equals(newEvent.getType())) {
			newEvent.setModDate(currDate);
			newEvent = eventManager.saveEvent(newEvent);
		} else {

			TempEvent tmpEvent = eventManager
					.findUnhandledTempEventByEventId(newEvent.getId());
			if (tmpEvent == null) {
				tmpEvent = new TempEvent();
				tmpEvent.setEventId(newEvent.getId());
			}

			BeanUtils.copyProperties(newEvent, tmpEvent, new String[] { "id" });
			tmpEvent.setCreatedDate(currDate);

			tmpEvent = eventManager.saveTempEvent(tmpEvent);

		}

		return newEvent;

	}

	/**
	 * Find all unhandled temporary events
	 * 
	 * @return List<TempEvent>
	 */
	@RequestMapping(value = "/temp/all", method = RequestMethod.GET)
	public @ResponseBody List<TempEvent> findAllUnhandledTempEvents() {

		List<TempEvent> tempEvents = eventManager.findAllTempEvents();

		return tempEvents;
	}

	/**
	 * Update temporay event from user
	 * 
	 * @param id String
	 * @param status String
	 * @param userId String
	 * @return Event
	 */
	@RequestMapping(value = "/temp/update", method = RequestMethod.POST, consumes = "application/x-www-form-urlencoded;charset=UTF-8")
	public @ResponseBody Event updateTempEvent(@RequestParam String id, @RequestParam String status, @RequestParam String userId) {

		TempEvent tmpEvent = eventManager.findTempEventById(id);
		
		Event newEvent = eventManager.findEventById(tmpEvent.getEventId());

		tmpEvent.setModDate(new Date());
		tmpEvent.setModId(userId);
		tmpEvent.setStatus(status);

		eventManager.saveTempEvent(tmpEvent);

		if (EventConstants.TEMP_EVENT_STATUS_APPROVED.equals(status)) {
			newEvent.setTitle(tmpEvent.getTitle());
			newEvent.setCategory(tmpEvent.getCategory());
			newEvent.setLocation(tmpEvent.getLocation());
			newEvent.setAddress(tmpEvent.getAddress());
			newEvent.setContact(tmpEvent.getContact());
			newEvent.setShortDes(tmpEvent.getShortDes());
			newEvent.setFullDes(tmpEvent.getFullDes());
			newEvent.setFromDate(tmpEvent.getFromDate());
			newEvent.setToDate(tmpEvent.getToDate());
			newEvent.setTag(tmpEvent.getTag());
			newEvent.setModDate(tmpEvent.getModDate());
			newEvent.setAlbum(tmpEvent.getAlbum());

			newEvent = eventManager.saveEvent(newEvent);
		}

		return newEvent;
	}
	

	/**
	 * find temporary event
	 * 
	 * @param id String
	 * @return TempEvent
	 */
	@RequestMapping(value = "/temp/get", method = RequestMethod.POST, consumes = "application/x-www-form-urlencoded;charset=UTF-8")
	public @ResponseBody TempEvent getTempEvent(@RequestParam String id) {
		TempEventDTO te = new TempEventDTO();
		te.setId(id);
		return eventManager.getTempEvent(te);
	}
	
	/**
	 * Create new report for an event
	 * 
	 * @param eventId String
	 * @param report String
	 * @return EventReport
	 */
	@RequestMapping(value = "/report/new", method = RequestMethod.POST, consumes = "application/x-www-form-urlencoded;charset=UTF-8")
	public @ResponseBody EventReport newReport(@RequestParam String eventId, @RequestParam String report) {
		Gson gson = new Gson();
		Report rep = gson.fromJson(report, Report.class);
		EventReport oldReport = eventManager.findUnhandledEventReportByEventId(eventId);
		
		if (oldReport == null) {
			Event event = eventManager.findEventById(eventId);
			oldReport = new EventReport();
			oldReport.setEventCat(event.getCategory());
			oldReport.setEventId(eventId);
			oldReport.setEventTitle(event.getTitle());
			oldReport.setEventUid(event.getUserId());
			oldReport.setListReport(new ArrayList<Report>());
		}
		
		oldReport.getListReport().add(rep);
		
		oldReport = eventManager.saveEventReport(oldReport);
		
		return oldReport;
	}
	
	/**
	 * Promote rank of event
	 * 
	 * @param eventId String
	 * @param reason String
	 * @param userId String
	 * @param rank integer
	 * @return Event
	 */
	@RequestMapping(value = "/promote", method = RequestMethod.POST, consumes = "application/x-www-form-urlencoded;charset=UTF-8")
	public @ResponseBody Event promoteEvent(
			@RequestParam String eventId, 
			@RequestParam String reason,
			@RequestParam String userId,
			@RequestParam int rank) {
		
		EventPromotionLogDTO epl = new EventPromotionLogDTO();
		epl.setEventId(eventId);
		epl.setReason(reason);
		epl.setUserId(userId);
		
		EventDTO ev = new EventDTO();
		ev.setId(eventId);
		ev.setRank(rank);
				
		return eventManager.promoteEvent(ev, epl);
	}
	
	/**
	 * Create comment when user comment in an event
	 * @param comment Comment
	 * @return Comment
	 */
	@RequestMapping(value="/comment/create", method=RequestMethod.POST, consumes = "application/json")
	public @ResponseBody Comment createComment(@RequestBody Comment comment) {

		// create commentDTO to transfer data to lower layer
		CommentDTO commentDTO = new CommentDTO();
		commentDTO.setUserId(comment.getUserId());
		commentDTO.setContent(comment.getContent());
		commentDTO.setCreatedDate(new Date());
		commentDTO.setEventId(comment.getEventId());

		// call Manager
		Comment cm = eventManager.createComment(commentDTO);
		
		return cm;
	}
	
	/**
	 * Find list comment by eventId from lastViewComment
	 * @return List<Comment>
	 */
	@RequestMapping(value="/comment/getAvailabeComments", method=RequestMethod.POST)
	public @ResponseBody List<Comment> findListComment(@RequestParam String eId, @RequestParam String lastViewComment){
		CommentDTO commentDTO = new CommentDTO();
		commentDTO.setEventId(eId);
		commentDTO.setLastViewComment("");
		
		List<Comment> commentlist = eventManager.findListComment(commentDTO);
		
		return commentlist;
	}
	
	/**
	 * Find notify for an event
	 * 
	 * @param eventId String
	 * @return String notify content
	 */
	@RequestMapping(value="/notify/get", method=RequestMethod.POST, consumes = "application/x-www-form-urlencoded;charset=UTF-8")
	public @ResponseBody NotificationContentDTO findEventNotify(@RequestParam String eventId, @RequestParam String userId) {
		NotificationDTO notifyDto = new NotificationDTO();
		notifyDto.setEventId(eventId);
		notifyDto.setUserId(userId);
		
		NotificationContentDTO notify = eventManager.findEventNotify(notifyDto);
		
		return notify;
	}
	
	/**
	 * Delete an event.
	 * @param eventId String
	 * @param userId String
	 * @param likeList List<String>
	 * @return Event
	 */
	@RequestMapping(value="/deleteEvent", method=RequestMethod.POST)
	public @ResponseBody Event deleteEventbyId(@RequestParam String eventId,
												@RequestParam String userId,
												@RequestParam List<String> likeList) {
		//set data 
		EventDTO requestDTO = new EventDTO();
		requestDTO.setId(eventId);
		requestDTO.setUserId(userId);
		requestDTO.setLike(likeList);
		
		return eventManager.deleteEvent(requestDTO);
	}
	
	/**
	 * Like an event.
	 * @param eventId String
	 * @return int
	 */
	@RequestMapping(value="/likeEvent", method=RequestMethod.POST)
	public @ResponseBody int likeEvent(@RequestParam String eventId,
										@RequestParam String userId) {
		EventDTO requestDTO = new EventDTO();
		requestDTO.setId(eventId);
		requestDTO.setUserId(userId);
		
		return eventManager.likeEvent(requestDTO);
	}
	
	@RequestMapping(value="/topRankEvent", method=RequestMethod.GET)
	public @ResponseBody List<Event> topRankingEvent() {
		List<Event> returnEvent = new ArrayList<Event>();
		returnEvent = eventManager.findAllTopRakingEvent();
		return returnEvent;
	}
	
	/**
	 * Get all trending hot event.
	 * @return List<TrendingHotEvent>
	 */
	@RequestMapping(value="/trendinghot/all", method=RequestMethod.GET)
	public @ResponseBody List<TrendingHotEvent> getAllTrendingHotEvent() {
		
		return eventManager.findAllTrendingHotEvent();
	}
	
	@RequestMapping(value="/trendinghot/findContent", method=RequestMethod.POST)
	public @ResponseBody List<Event> getAllTrendingEventInfo(@RequestBody String eventId) {
		
		List<String> eventsId = new ArrayList<String>();
		if(eventId.contains(",")) {
			
			String [] list = eventId.split(",");
			for (String item : list) {
				eventsId.add(item);
			}
		} else {
			eventsId.add(eventId);
		}
		
		return eventManager.findAllTrendingHotEventInfo(eventsId);
		
	}
	
	/**
	 * Find event by eventId from storm
	 * 
	 * @param eId String
	 * @return Event
	 */
	@RequestMapping(value = "/storm/find/id", method = RequestMethod.POST, consumes = "application/x-www-form-urlencoded;charset=UTF-8")
	public @ResponseBody
	Event findEventByIdFromStorm(@RequestParam String eId) {

		return eventManager.findEventById(eId, true);
	}
	
	
	//************************Private Method*********************************************//
	
	private EventDTO setData (Event event ) {
		EventDTO eventDTO = new EventDTO();
		eventDTO.setTitle(event.getTitle());
		eventDTO.setCategory(event.getCategory());
		eventDTO.setLocation(event.getLocation());
		eventDTO.setAddress(event.getAddress());
		eventDTO.setContact(event.getContact());
		eventDTO.setShortDes(event.getShortDes());
		eventDTO.setFullDes(event.getFullDes());
		eventDTO.setAlbum(event.getAlbum());
		eventDTO.setRank(event.getRank());
		eventDTO.setFromDate(event.getFromDate());
		eventDTO.setToDate(event.getToDate());
		eventDTO.setCreatedDate(new Date());
		eventDTO.setUserId(event.getUserId());
		eventDTO.setType(event.getType());
		eventDTO.setModDate(new Date());
		eventDTO.setTag("");
		
		return eventDTO;
	}
}