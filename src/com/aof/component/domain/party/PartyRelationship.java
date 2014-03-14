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
public class PartyRelationship implements Serializable {
	private Party partyFrom;      
	private Party partyTo;
	private RoleType roleFrom;
	private RoleType roleTo;
	private String note;
	
	private PartyRelationshipType relationshipType;
	
	/**
	 * @return
	 */
	public Party getPartyFrom() {
		return partyFrom;
	}

	/**
	 * @return
	 */
	public Party getPartyTo() {
		return partyTo;
	}

	/**
	 * @return
	 */
	public PartyRelationshipType getRelationshipType() {
		return relationshipType;
	}

	/**
	 * @return
	 */
	public RoleType getRoleFrom() {
		return roleFrom;
	}

	/**
	 * @return
	 */
	public RoleType getRoleTo() {
		return roleTo;
	}

	/**
	 * @param party
	 */
	public void setPartyFrom(Party party) {
		partyFrom = party;
	}

	/**
	 * @param party
	 */
	public void setPartyTo(Party party) {
		partyTo = party;
	}

	/**
	 * @param type
	 */
	public void setRelationshipType(PartyRelationshipType type) {
		relationshipType = type;
	}

	/**
	 * @param type
	 */
	public void setRoleFrom(RoleType type) {
		roleFrom = type;
	}

	/**
	 * @param type
	 */
	public void setRoleTo(RoleType type) {
		roleTo = type;
	} 

	/**
	 * @return
	 */
	public String getNote() {
		return note;
	}

	/**
	 * @param string
	 */
	public void setNote(String string) {
		note = string;
	}

}
