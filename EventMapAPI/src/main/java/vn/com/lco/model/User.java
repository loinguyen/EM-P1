/**
 * Legend Company
 */
package vn.com.lco.model;

import java.util.Date;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

/**
 * @author OaiPanda
 *
 * User.java
 */

@Document
public class User {

	@Id
	private String id;
	
	private String password;

	private String role;
	
	private String address;
	
	private String email;
	
	private String job;
	
	private Date dob;
	
	private String sex;
	
	private int noOfLikes;
	
	private List<String> subcribedEvents;
	
	private int noOfCreatedEvents;
	
	private Date lastVisitedDate;
	
	private Date joinedDate;
	
	private boolean deleteFlag;

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the password
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * @param password the password to set
	 */
	public void setPassword(String password) {
		this.password = password;
	}

	/**
	 * @return the role
	 */
	public String getRole() {
		return role;
	}

	/**
	 * @param role the role to set
	 */
	public void setRole(String role) {
		this.role = role;
	}

	/**
	 * @return the address
	 */
	public String getAddress() {
		return address;
	}

	/**
	 * @param address the address to set
	 */
	public void setAddress(String address) {
		this.address = address;
	}

	/**
	 * @return the email
	 */
	public String getEmail() {
		return email;
	}

	/**
	 * @param email the email to set
	 */
	public void setEmail(String email) {
		this.email = email;
	}

	/**
	 * @return the job
	 */
	public String getJob() {
		return job;
	}

	/**
	 * @param job the job to set
	 */
	public void setJob(String job) {
		this.job = job;
	}

	/**
	 * @return the dob
	 */
	public Date getDob() {
		return dob;
	}

	/**
	 * @param dob the dob to set
	 */
	public void setDob(Date dob) {
		this.dob = dob;
	}

	/**
	 * @return the noOfLikes
	 */
	public int getNoOfLikes() {
		return noOfLikes;
	}

	/**
	 * @param noOfLikes the noOfLikes to set
	 */
	public void setNoOfLikes(int noOfLikes) {
		this.noOfLikes = noOfLikes;
	}

	/**
	 * @return the noOfCreatedEvents
	 */
	public int getNoOfCreatedEvents() {
		return noOfCreatedEvents;
	}

	/**
	 * @param noOfCreatedEvents the noOfCreatedEvents to set
	 */
	public void setNoOfCreatedEvents(int noOfCreatedEvents) {
		this.noOfCreatedEvents = noOfCreatedEvents;
	}

	/**
	 * @return the joinedDate
	 */
	public Date getJoinedDate() {
		return joinedDate;
	}

	/**
	 * @param joinedDate the joinedDate to set
	 */
	public void setJoinedDate(Date joinedDate) {
		this.joinedDate = joinedDate;
	}

	/**
	 * @return the deleteFlag
	 */
	public boolean isDeleteFlag() {
		return deleteFlag;
	}

	/**
	 * @param deleteFlag the deleteFlag to set
	 */
	public void setDeleteFlag(boolean deleteFlag) {
		this.deleteFlag = deleteFlag;
	}

	/**
	 * @return the lastVisitedDate
	 */
	public Date getLastVisitedDate() {
		return lastVisitedDate;
	}

	/**
	 * @param lastVisitedDate the lastVisitedDate to set
	 */
	public void setLastVisitedDate(Date lastVisitedDate) {
		this.lastVisitedDate = lastVisitedDate;
	}

	/**
	 * @return the subcribedEvents
	 */
	public List<String> getSubcribedEvents() {
		return subcribedEvents;
	}

	/**
	 * @param subcribedEvents the subcribedEvents to set
	 */
	public void setSubcribedEvents(List<String> subcribedEvents) {
		this.subcribedEvents = subcribedEvents;
	}

	/**
	 * @return the sex
	 */
	public String getSex() {
		return sex;
	}

	/**
	 * @param sex the sex to set
	 */
	public void setSex(String sex) {
		this.sex = sex;
	}
	
}
