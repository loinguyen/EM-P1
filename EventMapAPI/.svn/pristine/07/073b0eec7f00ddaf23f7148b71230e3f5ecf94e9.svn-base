/**
 * Legend Company
 */
package vn.com.lco.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import vn.com.lco.model.User;

/**
 * @author OaiPanda
 *
 * UserRepository.java
 */
public interface UserRepository extends MongoRepository<User, String> {

	/**
	 * Find user by Id(User name)
	 * 
	 * @return User
	 */
	User findById(String id);
	
	@Query("{'subcribedEvents' : ?0}")
	List<User> findBySubcribedEvents(String subcribedEvents);
	
	User findByEmail(String email);
}
