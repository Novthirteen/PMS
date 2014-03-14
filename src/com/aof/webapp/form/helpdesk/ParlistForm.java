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
 * Creation date: 12-01-2004
 * 
 * XDoclet definition:
 * @struts:form name="ParlistForm"
 */
public class ParlistForm extends BaseQueryForm {

	// --------------------------------------------------------- Instance Variables
	String desc;
	String relation;
	String addr;
	String type;
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
	 * Method reset
	 * @param mapping
	 * @param request
	 */

	/**
	 * 
	 */
	public ParlistForm() {
		super();
		this.setPageSize("10");
		addr="";
		desc="";
		relation="";
	}
	/**
	 * @return Returns the addr.
	 */
	public String getAddr() {
		return addr;
	}
	/**
	 * @param addr The addr to set.
	 */
	public void setAddr(String addr) {
		this.addr = addr;
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