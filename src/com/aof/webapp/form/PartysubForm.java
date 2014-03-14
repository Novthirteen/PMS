//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/** 
 * MyEclipse Struts
 * Creation date: 11-17-2004
 * 
 * XDoclet definition:
 * @struts:form name="PartysubForm"
 */
public class PartysubForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	/** address property */
	private String address;

	/** relation property */
	private String relation;

	/** desc property */
	private String desc;
	private String type;
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
		desc="";
		relation="";
		address="";
	}

	/** 
	 * Returns the address.
	 * @return String
	 */
	public String getAddress() {
		return address;
	}

	/** 
	 * Set the address.
	 * @param address The address to set
	 */
	public void setAddress(String address) {
		this.address = address;
	}

	/** 
	 * Returns the relation.
	 * @return String
	 */
	public String getRelation() {
		return relation;
	}

	/** 
	 * Set the relation.
	 * @param relation The relation to set
	 */
	public void setRelation(String relation) {
		this.relation = relation;
	}

	/** 
	 * Returns the desc.
	 * @return String
	 */
	public String getDesc() {
		return desc;
	}

	/** 
	 * Set the desc.
	 * @param desc The desc to set
	 */
	public void setDesc(String desc) {
		this.desc = desc;
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
}