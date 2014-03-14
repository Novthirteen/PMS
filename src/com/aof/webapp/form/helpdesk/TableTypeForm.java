package com.aof.webapp.form.helpdesk;
//Created by MyEclipse Struts
//XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.ValidatorForm;


/** 
* MyEclipse Struts
* Creation date: 11-25-2004
* 
* XDoclet definition:
* @struts:form name="tableTypeForm"
*/
public class TableTypeForm extends ValidatorForm {

// --------------------------------------------------------- Instance Variables

/** disabled property */
private boolean disabled;

/** name property */
private String name;

/** id property */
private String id;

private String createUser;

private String modifyUser;

private String createDate;

private String modifyDate;

private List columns=new ArrayList();

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
	this.columns.clear();
}

/** 
* Returns the disabled.
* @return String
*/
public boolean getDisabled() {
	return disabled;
}

/** 
* Set the disabled.
* @param disabled The disabled to set
*/
public void setDisabled(boolean disabled) {
	this.disabled = disabled;
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
* Returns the id.
* @return String
*/
public String getId() {
	return id;
}

/** 
* Set the id.
* @param id The id to set
*/
public void setId(String id) {
	this.id = id;
}

/**
* @return Returns the columns.
*/
public List getColumnList() {
	return columns;
}
/**
* @param columns The columns to set.
*/
public void setColumns(List columns) {
	this.columns = columns;
}

public String getColumns(int index) {
	if (columns.size()<index+1) return "";
	return (String) columns.get(index);
}

public void setColumns(int index,String columnName) {
	for (int i=columns.size();i<index+1;i++) {
		this.columns.add(null);
	}
	this.columns.set(index,columnName);
}


/**
 * @return Returns the createDate.
 */
public String getCreateDate() {
	return createDate;
}
/**
 * @param createDate The createDate to set.
 */
public void setCreateDate(String createDate) {
	this.createDate = createDate;
}
/**
 * @return Returns the createUser.
 */
public String getCreateUser() {
	return createUser;
}
/**
 * @param createUser The createUser to set.
 */
public void setCreateUser(String createUser) {
	this.createUser = createUser;
}
/**
 * @return Returns the modifyDate.
 */
public String getModifyDate() {
	return modifyDate;
}
/**
 * @param modifyDate The modifyDate to set.
 */
public void setModifyDate(String modifyDate) {
	this.modifyDate = modifyDate;
}
/**
 * @return Returns the modifyUser.
 */
public String getModifyUser() {
	return modifyUser;
}
/**
 * @param modifyUser The modifyUser to set.
 */
public void setModifyUser(String modifyUser) {
	this.modifyUser = modifyUser;
}
}

