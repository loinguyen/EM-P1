/**
 * 
 */
package vn.com.lco.model;

import java.io.Serializable;

/**
 * @author Huy
 *
 */
public class Comment implements Serializable {

	private static final long serialVersionUID = 1L;
	private String userId;
	private String content;
	/**
	 * @param userId
	 * @param content
	 * @param createdDate
	 */
	public Comment(String userId, String content, long createdDate) {
		super();
		this.userId = userId;
		this.content = content;
		this.createdDate = createdDate;
	}
	private long createdDate;
	
	/**
	 * @return the createdDate
	 */
	public long getCreatedDate() {
		return createdDate;
	}
	/**
	 * @param createdDate the createdDate to set
	 */
	public void setCreatedDate(long createdDate) {
		this.createdDate = createdDate;
	}
	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}
	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}
	/**
	 * @return the content
	 */
	public String getContent() {
		return content;
	}
	/**
	 * @param content the content to set
	 */
	public void setContent(String content) {
		this.content = content;
	}
}
