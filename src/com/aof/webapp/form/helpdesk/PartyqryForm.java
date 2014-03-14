//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.form.helpdesk;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/** 
 * MyEclipse Struts
 * Creation date: 11-15-2004
 * 
 * XDoclet definition:
 * @struts:form name="PartyqryForm"
 */
public class PartyqryForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables
	private String desc;
	private String relation;
	private String address;
	
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

        ActionErrors errors = new ActionErrors();
        if (((desc == null) || (desc.length() < 1))&& ((relation == null) || (relation.length() < 1))&& ((address == null) || (address.length() < 1)))
            errors.add("emptyvalue", new ActionError("desc,relation and address.required"));

        return errors;
	}

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		address="";
		relation="";
		desc="";
	}
	
	/**
	 * @return Returns the address.
	 */
	public String getAddress() {
		return address;
	}
	/**
	 * @param address The address to set.
	 */
	public void setAddress(String address) {
		this.address = address;
	}
	/**
	 * @return Returns the desc.
	 */
	public String getDesc() {
		return desc;
	}
	/**
	 * @param desc The desc to set.
	 */
	public void setDesc(String desc) {
		this.desc = desc;
	}
	/**
	 * @return Returns the relation.
	 */
	public String getRelation() {
		return relation;
	}
	/**
	 * @param relation The relation to set.
	 */
	public void setRelation(String relation) {
		this.relation = relation;
	}
}