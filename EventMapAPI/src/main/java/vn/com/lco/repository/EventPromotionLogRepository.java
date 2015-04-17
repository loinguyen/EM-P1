/**
 * Legend Company
 */
package vn.com.lco.repository;

import org.springframework.data.mongodb.repository.MongoRepository;

import vn.com.lco.model.EventPromotionLog;

/**
 * @author OaiPanda
 *
 * EventPromotionLogRepository.java
 */
public interface EventPromotionLogRepository extends MongoRepository<EventPromotionLog, String> {

}
