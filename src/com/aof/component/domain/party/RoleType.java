/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.party;

import java.io.Serializable;

/**
 * @author xxp 
 * @version 2003-6-24
 *
 */
public class RoleType implements Serializable {
	private String roleTypeId;
	private String description;
	
	/**
	 * @return
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @return
	 */
	public String getRoleTypeId() {
		return roleTypeId;
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
	public void setRoleTypeId(String string) {
		roleTypeId = string;
	}

}
