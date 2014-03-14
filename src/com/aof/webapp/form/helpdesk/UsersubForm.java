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
 * Creation date: 11-18-2004
 * 
 * XDoclet definition:
 * @struts:form name="UsersubForm"
 */
public class UsersubForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	/** note property */
	private String desc;
	private String note;

	/** name property */
	private String name;
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
        if (((desc == null) || (desc.length() < 1))&&((name == null) || (name.length() < 1))&& ((note == null) || (note.length() < 1)))
            errors.add("emptyvalue", new ActionError("name and note.required"));

        return errors;	
	}

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		desc="";
		note="";
		name="";
	}

	/** 
	 * Returns the note.
	 * @return String
	 */
	public String getNote() {
		return note;
	}

	/** 
	 * Set the note.
	 * @param note The note to set
	 */
	public void setNote(String note) {
		this.note = note;
	}

	/** 
	 * Returns the name.
	 * @return String
	 */
	public String getName() {
		return name;
	}

	/** 
	 * Set the name.
	 * @param name The name to set
	 */
	public void setName(String name) {
		this.name = name;
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
}