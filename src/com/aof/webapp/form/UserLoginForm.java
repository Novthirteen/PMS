/*
 * Created on 2004-11-13
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class UserLoginForm extends BaseForm{
	private String userLoginId;
	private String name;
	
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return Returns the userLoginId.
	 */
	public String getUserLoginId() {
		return userLoginId;
	}
	/**
	 * @param userLoginId The userLoginId to set.
	 */
	public void setUserLoginId(String userLoginId) {
		this.userLoginId = userLoginId;
	}
}
