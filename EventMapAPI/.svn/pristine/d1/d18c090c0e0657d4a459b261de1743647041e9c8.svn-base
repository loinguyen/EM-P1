/**
 * Legend Company
 */
package vn.com.lco.repository;

import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.MongoRepository;

import vn.com.lco.model.UserChangeLog;

/**
 * @author OaiPanda
 *
 * UserChangeLogRepository.java
 */
public interface UserChangeLogRepository extends MongoRepository<UserChangeLog, String> {

	public List<UserChangeLog> findByAffectedUIdAndExpiredDateNotNull(String userId,Sort sort);
}
