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
public class ConsultantGroup implements Serializable {
	
	//identifier
	private java.lang.Integer id;
	
	//description of the group
	private java.lang.String description;
	
	//supervisor of the group
	private UserLogin supvisor;
	
	public java.lang.String getDescription() {
		return description;
	}
	public void setDescription(java.lang.String description) {
		this.description = description;
	}
	public java.lang.Integer getId() {
		return id;
	}
	public void setId(java.lang.Integer id) {
		this.id = id;
	}
	public UserLogin getSupvisor() {
		return supvisor;
	}
	public void setSupvisor(UserLogin supvisor) {
		this.supvisor = supvisor;
	}
}
