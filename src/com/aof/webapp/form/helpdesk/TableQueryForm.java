//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.form.helpdesk;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/** 
 * MyEclipse Struts
 * Creation date: 12-21-2004
 * 
 * XDoclet definition:
 * @struts:form name="tableQueryForm"
 */
public class TableQueryForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	/** company_id property */
	private String company;

	// --------------------------------------------------------- Methods


	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {

	}

	/** 
	 * Returns the company_id.
	 * @return String
	 */
	public String getCompany() {
		return company;
	}

	/** 
	 * Set the company_id.
	 * @param company_id The company_id to set
	 */
	public void setCompany(String company_id) {
		this.company = company_id;
	}

}