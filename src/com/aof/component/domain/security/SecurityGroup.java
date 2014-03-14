/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.security;


import java.util.Set;
import java.io.Serializable;

/**
 * @author xxp 
 * @version 2003-6-16
 *
 */
public class SecurityGroup implements Serializable {

	private String groupId;
	private String description;
	
	private Set securityPermissions;
	
	/**
	 * @return
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @return
	 */
	public String getGroupId() {
		return groupId;
	}

	/**
	 * @param string
	 */
	public void setDescription(String string) {
		description = string;
	}

	/**
	 * @param string
	 */
	public void setGroupId(String string) {
		groupId = string;
	}

	/**
	 * @return
	 */
	public Set getSecurityPermissions() {
		return securityPermissions;
	}

	/**
	 * @param set
	 */
	public void setSecurityPermissions(Set set) {
		securityPermissions = set;
	}


}
