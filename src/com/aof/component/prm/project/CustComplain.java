/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.project;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.UserLogin;


public class CustComplain implements Serializable {
	private Long CC_Id;
	private ProjectMaster project;
	private String Dep_ID;
	private UserLogin PM_ID;
	private UserLogin Create_User;
	private java.util.Date Create_Date;
	private String Description;
	private String Type;
	private String Solved;
//	private String party;
	public Long getCC_Id() {
		return CC_Id;
	}
	public void setCC_Id(Long id) {
		CC_Id = id;
	}
	
	public java.util.Date getCreate_Date() {
		return Create_Date;
	}
	public void setCreate_Date(java.util.Date create_Date) {
		Create_Date = create_Date;
	}
	public UserLogin getCreate_User() {
		return Create_User;
	}
	public void setCreate_User(UserLogin create_User) {
		Create_User = create_User;
	}
	public String getDep_ID() {
		return Dep_ID;
	}
	public void setDep_ID(String dep_ID) {
		Dep_ID = dep_ID;
	}
	public String getDescription() {
		return Description;
	}
	public void setDescription(String description) {
		Description = description;
	}
	public UserLogin getPM_ID() {
		return PM_ID;
	}
	public void setPM_ID(UserLogin pm_id) {
		PM_ID = pm_id;
		//pm_id.getName()
	}
	
	public String getSolved() {
		return Solved;
	}
	public void setSolved(String solved) {
		Solved = solved;
	}
	public String getType() {
		return Type;
	}
	public void setType(String type) {
		Type = type;
	}
	public ProjectMaster getProject() {
		return project;
	}
	public void setProject(ProjectMaster project) {
		this.project = project;
		
	}
	
	public CustComplain(Long id) {
		super();
		this.CC_Id = id;
	}
	public CustComplain() {
		super();
		
	}
	
}
