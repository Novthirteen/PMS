/*
 * Created on 2005-11-8
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

import com.aof.component.domain.party.UserLogin;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ConsultantAssign implements Serializable {
	
	//identifier
	private java.lang.Integer id;
	
	//consultant group
	private ConsultantGroup groupID;
	
	//consultant
	private UserLogin consultant;
	
	public UserLogin getConsultant() {
		return consultant;
	}
	public void setConsultant(UserLogin consultant) {
		this.consultant = consultant;
	}
	public ConsultantGroup getGroupID() {
		return groupID;
	}
	public void setGroupID(ConsultantGroup groupID) {
		this.groupID = groupID;
	}
	public java.lang.Integer getId() {
		return id;
	}
	public void setId(java.lang.Integer id) {
		this.id = id;
	}
}
