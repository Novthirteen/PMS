//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.form.helpdesk;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import com.shcnc.struts.form.BaseQueryForm;

/** 
 * MyEclipse Struts
 * Creation date: 11-21-2004
 * 
 * XDoclet definition:
 * @struts:form name="callQueryForm"
 */
public class CallQueryForm extends BaseQueryForm {

	// --------------------------------------------------------- Instance Variables

	private String callType="";
	
	/** contact_name property */
	private String contact_name="";
	
	private String requestType2="";

	/** user_name property */
	private String user_name="";

	/** contact_id property */
	private String contact_id="";

	/** party_id property */
	private String party_id="";

	/** party_name property */
	private String party_name="";

	/** id property */
	private String ticketNo="";

	/** user_id property */
	private String user_id="";

	/** priority_desc property */
	private String priority_desc="";

	/** priority_id property */
	private String priority_id="";

	/** company_name property */
	private String company_name="";

	/** requestType_desc property */
	private String requestType_desc="";

	/** requestType_id property */
	private String requestType_id="";

	/** company_id property */
	private String company_id="";
	
	private String status;
	
	private String responseHour="";
	
	private String solveHour="";
	
	private String closeHour="";
	
	private String requestDate1="";
	
	private String requestDate2="";
	
	private String problemType="";
	
	private String problemType_id="";
	
	private String problemType_desc="";
	// --------------------------------------------------------- Methods

	/** 
	 * Method validate
	 * @param mapping
	 * @param request
	 * @return ActionErrors
	 */
	public ActionErrors validate(
		ActionMapping mapping,
		HttpServletRequest request) {
		ActionErrors errors=super.validate(mapping,request);
		return errors;
	}

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
	}

	
	
	
	/**
	 * @return Returns the requestDate1.
	 */
	public String getRequestDate1() {
		return requestDate1;
	}
	/**
	 * @param requestDate1 The requestDate1 to set.
	 */
	public void setRequestDate1(String requestDate1) {
		this.requestDate1 = requestDate1;
	}
	/**
	 * @return Returns the requestDate2.
	 */
	public String getRequestDate2() {
		return requestDate2;
	}
	/**
	 * @param requestDate2 The requestDate2 to set.
	 */
	public void setRequestDate2(String requestDate2) {
		this.requestDate2 = requestDate2;
	}
	/**
	 * @return Returns the callType.
	 */
	public String getCallType() {
		return callType;
	}
	/**
	 * @param callType The callType to set.
	 */
	public void setCallType(String callType) {
		this.callType = callType;
	}
	/** 
	 * Returns the contact_name.
	 * @return String
	 */
	public String getContact_name() {
		return contact_name;
	}

	/** 
	 * Set the contact_name.
	 * @param contact_name The contact_name to set
	 */
	public void setContact_name(String contact_name) {
		this.contact_name = contact_name;
	}

	
	
	/**
	 * @return Returns the requestType2.
	 */
	public String getRequestType2() {
		return requestType2;
	}
	/**
	 * @param requestType2 The requestType2 to set.
	 */
	public void setRequestType2(String requestType2) {
		this.requestType2 = requestType2;
	}
	/** 
	 * Returns the user_name.
	 * @return String
	 */
	public String getUser_name() {
		return user_name;
	}

	/** 
	 * Set the user_name.
	 * @param user_name The user_name to set
	 */
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}

	/** 
	 * Returns the contact_id.
	 * @return String
	 */
	public String getContact_id() {
		return contact_id;
	}

	/** 
	 * Set the contact_id.
	 * @param contact_id The contact_id to set
	 */
	public void setContact_id(String contact_id) {
		this.contact_id = contact_id;
	}

	/** 
	 * Returns the party_id.
	 * @return String
	 */
	public String getParty_id() {
		return party_id;
	}

	/** 
	 * Set the party_id.
	 * @param party_id The party_id to set
	 */
	public void setParty_id(String party_id) {
		this.party_id = party_id;
	}

	/** 
	 * Returns the party_name.
	 * @return String
	 */
	public String getParty_name() {
		return party_name;
	}

	/** 
	 * Set the party_name.
	 * @param party_name The party_name to set
	 */
	public void setParty_name(String party_name) {
		this.party_name = party_name;
	}

	/** 
	 * Returns the id.
	 * @return String
	 */
	public String getTicketNo() {
		return ticketNo;
	}

	/** 
	 * Set the id.
	 * @param id The id to set
	 */
	public void setTicketNo(String ticketNo) {
		this.ticketNo = ticketNo;
	}

	/** 
	 * Returns the user_id.
	 * @return String
	 */
	public String getUser_id() {
		return user_id;
	}

	/** 
	 * Set the user_id.
	 * @param user_id The user_id to set
	 */
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	/** 
	 * Returns the priority_desc.
	 * @return String
	 */
	public String getPriority_desc() {
		return priority_desc;
	}

	/** 
	 * Set the priority_desc.
	 * @param priority_desc The priority_desc to set
	 */
	public void setPriority_desc(String priority_desc) {
		this.priority_desc = priority_desc;
	}

	/** 
	 * Returns the priority_id.
	 * @return String
	 */
	public String getPriority_id() {
		return priority_id;
	}

	/** 
	 * Set the priority_id.
	 * @param priority_id The priority_id to set
	 */
	public void setPriority_id(String priority_id) {
		this.priority_id = priority_id;
	}

	/** 
	 * Returns the company_name.
	 * @return String
	 */
	public String getCompany_name() {
		return company_name;
	}

	/** 
	 * Set the company_name.
	 * @param company_name The company_name to set
	 */
	public void setCompany_name(String company_name) {
		this.company_name = company_name;
	}

	/** 
	 * Returns the requestType_desc.
	 * @return String
	 */
	public String getRequestType_desc() {
		return requestType_desc;
	}

	/** 
	 * Set the requestType_desc.
	 * @param requestType_desc The requestType_desc to set
	 */
	public void setRequestType_desc(String requestType_desc) {
		this.requestType_desc = requestType_desc;
	}
	
	

	/**
	 * @return Returns the closeHour.
	 */
	public String getCloseHour() {
		return closeHour;
	}
	/**
	 * @param closeHour The closeHour to set.
	 */
	public void setCloseHour(String closeHour) {
		this.closeHour = closeHour;
	}
	/**
	 * @return Returns the responseHour.
	 */
	public String getResponseHour() {
		return responseHour;
	}
	/**
	 * @param responseHour The responseHour to set.
	 */
	public void setResponseHour(String responseHour) {
		this.responseHour = responseHour;
	}
	/**
	 * @return Returns the solveHour.
	 */
	public String getSolveHour() {
		return solveHour;
	}
	/**
	 * @param solveHour The solveHour to set.
	 */
	public void setSolveHour(String solveHour) {
		this.solveHour = solveHour;
	}
	/** 
	 * Returns the requestType_id.
	 * @return String
	 */
	public String getRequestType_id() {
		return requestType_id;
	}

	/** 
	 * Set the requestType_id.
	 * @param requestType_id The requestType_id to set
	 */
	public void setRequestType_id(String requestType_id) {
		this.requestType_id = requestType_id;
	}

	/** 
	 * Returns the company_id.
	 * @return String
	 */
	public String getCompany_id() {
		return company_id;
	}

	/** 
	 * Set the company_id.
	 * @param company_id The company_id to set
	 */
	public void setCompany_id(String company_id) {
		this.company_id = company_id;
	}

	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
	/**
	 * @return
	 */
	public String getProblemType_desc() {
		return problemType_desc;
	}

	/**
	 * @return
	 */
	public String getProblemType_id() {
		return problemType_id;
	}

	/**
	 * @param string
	 */
	public void setProblemType_desc(String string) {
		problemType_desc = string;
	}

	/**
	 * @param string
	 */
	public void setProblemType_id(String string) {
		problemType_id = string;
	}

	/**
	 * @return
	 */
	public String getProblemType() {
		return problemType;
	}

	/**
	 * @param string
	 */
	public void setProblemType(String string) {
		problemType = string;
	}

}