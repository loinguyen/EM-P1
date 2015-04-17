/**
 * Legend Company
 */
package vn.com.lco.repository;

import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.MongoRepository;

import vn.com.lco.model.Comment;

/**
 * @author OaiPanda
 *
 * CommentRepository.java
 */
public interface CommentRepository extends MongoRepository<Comment, String> {
	public List<Comment> findByEventIdAndDeleteFlag(String eventId, boolean deleteFlag, Sort sort);

}
