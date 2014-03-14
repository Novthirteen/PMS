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
 * Creation date: 12-01-2004
 * 
 * XDoclet definition:
 * @struts:form name="tableTypeQueryForm"
 */
public class TableTypeQueryForm extends BaseQueryForm  {

	// --------------------------------------------------------- Instance Variables

	/** desc property */
	private String desc="";

	private String disabledTableType="";
	
	// --------------------------------------------------------- Methods

	
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
	 * @return Returns the disabledTableType.
	 */
	public String getDisabledTableType() {
		return disabledTableType;
	}
	/**
	 * @param disabledTableType The disabledTableType to set.
	 */
	public void setDisabledTableType(String disabledTableType) {
		this.disabledTableType = disabledTableType;
	}
}