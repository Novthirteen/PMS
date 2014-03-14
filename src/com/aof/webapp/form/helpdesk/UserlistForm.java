//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.form.helpdesk;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.aof.webapp.action.helpdesk.puquery.QueryListKeys;
import com.shcnc.struts.form.BaseQueryForm;

/** 
 * MyEclipse Struts
 * Creation date: 12-02-2004
 * 
 * XDoclet definition:
 * @struts:form name="UserlistForm"
 */
public class UserlistForm extends BaseQueryForm {

	// --------------------------------------------------------- Instance Variables
	String type;
	String partyname;
	String username;
	// --------------------------------------------------------- Methods

	/** 
	 * Method validate
	 * @param mapping
	 * @param request
	 * @return ActionErrors
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		super.reset(mapping,request);
		this.setPageSize(String.valueOf(QueryListKeys.QUERY_IN_EACH_PAGE));
	}	
	
	public ActionErrors validate(
		ActionMapping mapping,
		HttpServletRequest request) {
		ActionErrors errors = new ActionErrors();
		return errors;
	}

	/**
	 * @return Returns the partyname.
	 */
	public String getPartyname() {
		return partyname;
	}
	/**
	 * @param partyname The partyname to set.
	 */
	public void setPartyname(String partyname) {
		this.partyname = partyname;
	}
	/**
	 * @return Returns the type.
	 */
	public String getType() {
		return type;
	}
	/**
	 * @param type The type to set.
	 */
	public void setType(String type) {
		this.type = type;
	}
	/**
	 * @return Returns the username.
	 */
	public String getUsername() {
		return username;
	}
	/**
	 * @param username The username to set.
	 */
	public void setUsername(String username) {
		this.username = username;
	}
}