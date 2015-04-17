/**
 * Legend Company
 */
package vn.com.lco.repository;

import org.springframework.data.mongodb.repository.MongoRepository;

import vn.com.lco.model.UserInteractLog;

/**
 * @author OaiPanda
 *
 * UserInteractLogRepository.java
 */
public interface UserInteractLogRepository extends MongoRepository<UserInteractLog, String> {

}
