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
 * @version 2003-6-22
 *
 */
public class PartyType implements Serializable {

	private String partyTypeId;
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
	public String getPartyTypeId() {
		return partyTypeId;
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
	public void setPartyTypeId(String string) {
		partyTypeId = string;
	}

}
