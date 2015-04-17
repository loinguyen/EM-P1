/**
 * Legend Company
 */
package vn.com.lco.utility;

import vn.com.lco.model.UserInteractLog;
import vn.com.lco.repository.UserInteractLogRepository;

/**
 * @author OaiPanda
 *
 * CommonUtils.java
 */
public class CommonUtils {

	/**
	 * Save user interact with system when user view, like, subscribe and comment an event.
	 * @param userInteractLogDTO UserInteractLogDTO
	 * @return UserInteractLog
	 */
	public static UserInteractLog saveUserInteractLog(UserInteractLogRepository userInteractLogRepository, UserInteractLog userInteractLog) {
		
		return userInteractLogRepository.save(userInteractLog);
	}
}
