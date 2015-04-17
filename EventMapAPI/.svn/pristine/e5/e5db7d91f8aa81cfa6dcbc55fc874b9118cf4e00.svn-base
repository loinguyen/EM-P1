/**
 * Legend Company
 */
package vn.com.lco.repository;

import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import vn.com.lco.model.Notification;

/**
 * @author OaiPanda
 *
 * CommentRepository.java
 */

public interface NotificationRepository extends MongoRepository<Notification, String> {

	@Query("{ 'eventId' : ?0, 'subscriberId' : ?1 }")
	public Notification findByEventIdAndUserId(String eventId, String currentUserId);
	
	@Query("{ 'eventId' : ?0, 'subscriberId' : {'$ne' : ?1} }")
	public List<Notification> findByEventId(String eventId, String notIncludedUserId);
	
	public Notification findBySubscriberIdAndEventId(String subscriberId, String eventId);
	
	public List<Notification> findBySubscriberId(String subscriberId, Sort sort);
	
	@Query("{'eventId' : ?0}")
	public List<Notification> findByEventId(String eventId);
}
