/**
 * Legend Company
 */
package vn.com.lco.repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import vn.com.lco.model.Event;

/**
 * @author OaiPanda
 *
 * EventRepository.java
 */
public interface EventRepository extends MongoRepository<Event, String> {
	@Query("{deleteFlag : false, type : 'public',  toDate : { '$gte' : { '$date' : ?0}}, category : ?1}")
	public List<Event> findByToDateNotLessThanAndCategoryLike(String currentDate, String category, Sort sort);
	
	public List<Event> findByToDateBetweenAndCategoryLike(Date from, Date to, String category);
	
	public List<Event> findByUserId(String userId);
		
	public List<Event> findBySubscribers(String subscriberId);
	
	public Event findByIdAndDeleteFlag(String id, boolean deleteFlag);
	
	@Query("{'deleteFlag' : false, 'type' : 'public',  'toDate' : { '$gte' : { '$date' : ?0}}}")
	public Page<Event> findByToDateNotLessThanAndDeleteFlagFalse(String currentDate, Pageable page);
	
	@Query("{'deleteFlag' : false, '_id' : { '$in' : ?0}}")
	public List<Event> findByListEventId(List<String> eventsId);
	
}

