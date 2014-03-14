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
 * Creation date: 11-17-2004
 * 
 * XDoclet definition:
 * @struts:form name="PartysubForm"
 */
public class PartysubForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	/** desc property */
	private String desc;
	private String name;
	private String type;
	private String choice;
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
//        if (((desc == null) || (desc.length() < 1))&& ((relation == null) || (relation.length() < 1))&& ((address == null) || (address.length() < 1)))
//            errors.add("emptyvalue", new ActionError("desc,relation and address.required"));
        if (1==2){
        	errors.add("emptyvalue", new ActionError(""));
        }
        return errors;		
	}

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		desc="";
		name="";
		choice="";
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
	/**
	 * @return Returns the choice.
	 */
	public String getChoice() {
		return choice;
	}
	/**
	 * @param choice The choice to set.
	 */
	public void setChoice(String choice) {
		this.choice = choice;
	}
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
}