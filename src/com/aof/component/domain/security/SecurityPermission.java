/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.security;

import java.io.Serializable;

/**
 * @author xxp 
 * @version 2003-6-18
 *
 */
public class SecurityPermission implements Serializable {

	private String permissionId;
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
	public String getPermissionId() {
		return permissionId;
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
	public void setPermissionId(String string) {
		permissionId = string;
	}


}
