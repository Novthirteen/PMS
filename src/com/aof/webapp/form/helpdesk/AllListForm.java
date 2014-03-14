//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.form.helpdesk;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/** 
 * MyEclipse Struts
 * Creation date: 12-20-2004
 * 
 * XDoclet definition:
 * @struts:form name="AllListForm"
 */
public class AllListForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	/** name property */
	private String name;

	/** desc property */
	private String desc;

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

		throw new UnsupportedOperationException(
			"Generated method 'validate(...)' not implemented.");
	}

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {

		throw new UnsupportedOperationException(
			"Generated method 'reset(...)' not implemented.");
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

}