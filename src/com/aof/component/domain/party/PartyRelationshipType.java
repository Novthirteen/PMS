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
 * @version 2003-6-23
 *
 */
public class PartyRelationshipType implements Serializable {
	private String relationshipTypeId;
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
	public String getRelationshipTypeId() {
		return relationshipTypeId;
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
	public void setRelationshipTypeId(String string) {
		relationshipTypeId = string;
	}

}
