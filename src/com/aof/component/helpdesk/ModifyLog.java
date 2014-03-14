/*
 * Created on 2004-11-13
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

import com.aof.component.domain.party.UserLogin;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ModifyLog implements Serializable{
	/*
	 <property name="createDate" column="CM_CDate" type="java.util.Date" />
	 <property name="modifyDate" column="CM_MDate" type="java.util.Date" />
	 <many-to-one name="createUser" column="CM_CUser" class="com.aof.component.domain.party.UserLogin" />
 	 <many-to-one name="modifyUser" column="CM_MUser" class="com.aof.component.domain.party.UserLogin" />
	*/
	private java.util.Date createDate;
	private java.util.Date modifyDate;
	private UserLogin createUser;
	private UserLogin modifyUser;
	
	
	/**
	 * 
	 */
	public ModifyLog() {
		
	}
	/**
	 * @param createDate
	 * @param modifyDate
	 * @param createUser
	 * @param modifyUser
	 */
	public ModifyLog(java.util.Date createDate, java.util.Date modifyDate,
			UserLogin createUser, UserLogin modifyUser) {
		super();
		this.createDate = createDate;
		this.modifyDate = modifyDate;
		this.createUser = createUser;
		this.modifyUser = modifyUser;
	}
	/**
	 * @return Returns the createDate.
	 */
	public java.util.Date getCreateDate() {
		return createDate;
	}
	/**
	 * @param createDate The createDate to set.
	 */
	public void setCreateDate(java.util.Date createDate) {
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
	 * @return Returns the modifyDate.
	 */
	public java.util.Date getModifyDate() {
		return modifyDate;
	}
	/**
	 * @param modifyDate The modifyDate to set.
	 */
	public void setModifyDate(java.util.Date modifyDate) {
		this.modifyDate = modifyDate;
	}
	/**
	 * @return Returns the modifyUser.
	 */
	public UserLogin getModifyUser() {
		return modifyUser;
	}
	/**
	 * @param modifyUser The modifyUser to set.
	 */
	public void setModifyUser(UserLogin modifyUser) {
		this.modifyUser = modifyUser;
	}
}
