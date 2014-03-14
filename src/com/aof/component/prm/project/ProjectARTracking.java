/**
 * Atos Origin China * All Right Reserved.
 */
package com.aof.component.prm.project;

import java.util.Date;

import com.aof.component.domain.party.UserLogin;

/**
 * @author Stanley
 *
 */
public class ProjectARTracking {
	
	private Long id;
	private ProjectMaster project;
	private String description;
	private Date createDate;
	private UserLogin createUser;
	
	/**
	 * @return Returns the createDate.
	 */
	public Date getCreateDate() {
		return createDate;
	}
	/**
	 * @param createDate The createDate to set.
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	/**
	 * @return Returns the createUser.
	 */
	public UserLogin getCreateUser() {
		return createUser;
	}
	/**
	 * @param createUser The createUser to set.
	 */
	public void setCreateUser(UserLogin createUser) {
		this.createUser = createUser;
	}
	/**
	 * @return Returns the description.
	 */
	public String getDescription() {
		return description;
	}
	/**
	 * @param description The description to set.
	 */
	public void setDescription(String description) {
		this.description = description;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the project.
	 */
	public ProjectMaster getProject() {
		return project;
	}
	/**
	 * @param project The project to set.
	 */
	public void setProject(ProjectMaster project) {
		this.project = project;
	}
	
}
