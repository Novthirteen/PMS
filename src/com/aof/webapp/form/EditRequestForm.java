// Created by Xslt generator for Eclipse.
// XSL :  not found (java.io.FileNotFoundException:  (Bad file descriptor))
// Default XSL used : easystruts.jar$org.easystruts.xslgen.JavaClass.xsl

package com.aof.webapp.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;





/** 
 * EditrequestForm.java created by EasyStruts - XsltGen.
 * http://easystruts.sf.net
 * created on 10-14-2004
 * 
 * XDoclet definition:
 * @struts:form name="editrequestForm"
 */
public class EditRequestForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	/** priorityId property */
	private int priorityId;

	/** contactorId property */
	private String contactorId;

	/** callType property */
	private String callType;

	/** categoryId property */
	private int categoryId;

	/** reuqestId property */
	private int reuqestId;

	/** customerId property */
	private int customerId;

	// --------------------------------------------------------- Methods

	/** 
	 * Method validate
	 * @param ActionMapping mapping
	 * @param HttpServletRequest request
	 * @return ActionErrors
	 */
	public ActionErrors validate(
		ActionMapping mapping,
		HttpServletRequest request) {
			return null;

		
	}

	/** 
	 * Returns the priorityId.
	 * @return int
	 */
	public int getPriorityId() {
		return priorityId;
	}

	/** 
	 * Set the priorityId.
	 * @param priorityId The priorityId to set
	 */
	public void setPriorityId(int priorityId) {
		this.priorityId = priorityId;
	}

	/** 
	 * Returns the contactorId.
	 * @return String
	 */
	public String getContactorId() {
		return contactorId;
	}

	/** 
	 * Set the contactorId.
	 * @param contactorId The contactorId to set
	 */
	public void setContactorId(String contactorId) {
		this.contactorId = contactorId;
	}

	/** 
	 * Returns the callType.
	 * @return String
	 */
	public String getCallType() {
		return callType;
	}

	/** 
	 * Set the callType.
	 * @param callType The callType to set
	 */
	public void setCallType(String callType) {
		this.callType = callType;
	}

	/** 
	 * Returns the categoryId.
	 * @return int
	 */
	public int getCategoryId() {
		return categoryId;
	}

	/** 
	 * Set the categoryId.
	 * @param categoryId The categoryId to set
	 */
	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}

	/** 
	 * Returns the reuqestId.
	 * @return int
	 */
	public int getReuqestId() {
		return reuqestId;
	}

	/** 
	 * Set the reuqestId.
	 * @param reuqestId The reuqestId to set
	 */
	public void setReuqestId(int reuqestId) {
		this.reuqestId = reuqestId;
	}

	/** 
	 * Returns the customerId.
	 * @return int
	 */
	public int getCustomerId() {
		return customerId;
	}

	/** 
	 * Set the customerId.
	 * @param customerId The customerId to set
	 */
	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	


}
