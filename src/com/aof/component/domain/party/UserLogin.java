/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.party;

import java.util.Date;
import java.util.Set;
import java.io.Serializable;

import com.aof.component.prm.master.ProjectCalendarType;
import com.aof.component.prm.project.SalaryLevel;

/**
 * @author xxp 
 * @version 2003-6-22
 *
 */
public class UserLogin implements Serializable  {
	private Party party;
	private String userLoginId;
	private String name;
	
	private String current_password;
	private String enable;
	
	private String tele_code;
	private String mobile_code;
	private String title;
	private String email_addr;
	private String note;
	
	private Set moduleGroups;
	private Set securityGroups;
	
	private String role;
	
	private String locale;
	private ProjectCalendarType projectCalendarType;
	private SalaryLevel salaryLevel;
	private String intern;
	private String accountType;
	private String type;
	//private String reportToId;   //the cn number of the report-to-person
	private UserLogin reporToPerson;
	private Date last_update_Date;
	private Date joinDay;
	private Date leaveDay;
	
	
	public Date getLast_update_Date() {
		return last_update_Date;
	}
	public void setLast_update_Date(Date last_update_Date) {
		this.last_update_Date = last_update_Date;
	}
	public UserLogin getReporToPerson() {
		return reporToPerson;
	}
	public void setReporToPerson(UserLogin reporToPerson) {
		this.reporToPerson = reporToPerson;
	}
	public String getIntern() {
		return intern;
	}
	public void setIntern(String intern) {
		this.intern = intern;
	}
	/**
	 * @return Returns the locale.
	 */
	public String getLocale() {
		return locale;
	}
	/**
	 * @param locale The locale to set.
	 */
	public void setLocale(String locale) {
		this.locale = locale;
	}
	/**
	 * @return
	 */
	public String getCurrent_password() {
		return current_password;
	}

	/**
	 * @return
	 */
	public String getEnable() {
		return enable;
	}

	/**
	 * @return
	 */
	public Party getParty() {
		return party;
	}

	/**
	 * @return
	 */
	public String getUserLoginId() {
		return userLoginId;
	}

	/**
	 * @param string
	 */
	public void setCurrent_password(String string) {
		current_password = string;
	}

	/**
	 * @param string
	 */
	public void setEnable(String string) {
		enable = string;
	}

	/**
	 * @param party
	 */
	public void setParty(Party party) {
		this.party = party;
	}

	/**
	 * @param string
	 */
	public void setUserLoginId(String string) {
		userLoginId = string;
	}

	/**
	 * @return
	 */
	public Set getModuleGroups() {
		return moduleGroups;
	}

	/**
	 * @return
	 */
	public Set getSecurityGroups() {
		return securityGroups;
	}

	/**
	 * @param set
	 */
	public void setModuleGroups(Set set) {
		moduleGroups = set;
	}

	/**
	 * @param set
	 */
	public void setSecurityGroups(Set set) {
		securityGroups = set;
	}

	/**
	 * @return
	 */
	public String getName() {
		return name;
	}

	/**
	 * @return
	 */
	public String getRole() {
		return role;
	}

	/**
	 * @param string
	 */
	public void setName(String string) {
		name = string;
	}

	/**
	 * @param string
	 */
	public void setRole(String string) {
		role = string;
	}
	
	/*tele_code*/
	public String getTele_code() {
		return tele_code;
	}
	public void setTele_code(String string) {
		tele_code = string;
	}
	
	/*tele_code*/
	public String getMobile_code() {
		return mobile_code;
	}
	public void setMobile_code(String string) {
		mobile_code = string;
	}
	
	/*tele_code*/
	public String getTitle() {
		return title;
	}
	public void setTitle(String string) {
		title = string;
	}
	
	/*tele_code*/
	public String getEmail_addr() {
		return email_addr;
	}
	public void setEmail_addr(String string) {
		email_addr = string;
	}
	
	/*tele_code*/
	public String getNote() {
		return note;
	}
	public void setNote(String string) {
		note = string;
	}
	
	public boolean equals(Object obj) {
        if (obj == null) return false;
        if (this == obj) return true;
        if (!(obj instanceof UserLogin)) return false;
        UserLogin that = (UserLogin)obj;
        if (this != null) {
            return this.getUserLoginId().equals(that.getUserLoginId());
        }
        return that.getUserLoginId() == null;	
    }

	/**
	 * @return Returns the projectCalendarType.
	 */
	public ProjectCalendarType getProjectCalendarType() {
		return projectCalendarType;
	}
	/**
	 * @param projectCalendarType The projectCalendarType to set.
	 */
	public void setProjectCalendarType(ProjectCalendarType projectCalendarType) {
		this.projectCalendarType = projectCalendarType;
	}
	/**
	 * @return Returns the salaryLevel.
	 */
	public SalaryLevel getSalaryLevel() {
		return salaryLevel;
	}
	/**
	 * @param salaryLevel The salaryLevel to set.
	 */
	public void setSalaryLevel(SalaryLevel salaryLevel) {
		this.salaryLevel = salaryLevel;
	}
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Date getJoinDay() {
		return joinDay;
	}
	public void setJoinDay(Date joinDay) {
		this.joinDay = joinDay;
	}
	public Date getLeaveDay() {
		return leaveDay;
	}
	public void setLeaveDay(Date leaveDay) {
		this.leaveDay = leaveDay;
	}
	/**
	 * @return Returns the accountType.
	 */
	public String getAccountType() {
		return accountType;
	}
	/**
	 * @param accountType The accountType to set.
	 */
	public void setAccountType(String accountType) {
		this.accountType = accountType;
	}
}
