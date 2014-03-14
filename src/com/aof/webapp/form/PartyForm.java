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
public class PartyForm extends BaseForm{
	private String partyId;
	private String description;
	
	
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
	 * @return Returns the partyId.
	 */
	public String getPartyId() {
		return partyId;
	}
	/**
	 * @param partyId The partyId to set.
	 */
	public void setPartyId(String partyId) {
		this.partyId = partyId;
	}
}
