// Created by Xslt generator for Eclipse.
// XSL :  not found (java.io.FileNotFoundException:  (Bad file descriptor))
// Default XSL used : easystruts.jar$org.easystruts.xslgen.JavaClass.xsl

package com.aof.webapp.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/** 
 * ActiontrackForm.java created by EasyStruts - XsltGen.
 * http://easystruts.sf.net
 * created on 10-20-2004
 * 
 * XDoclet definition:
 * @struts:form name="actiontrackForm"
 */
public class ActiontrackForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	/** actionDate property */
	private String actionDate;

	/** actionTypeId property */
	private int actionTypeId;

	/** actionCost property */
	private float actionCost;

	/** description property */
	private String description;

	/** subject property */
	private String subject;

	/** operator property */
	private String operator;
	
	private String requestId ;
	
	private String action ;
	private String actionId;

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
	 * Returns the actionDate.
	 * @return Date
	 */
	public String getActionDate() {
		return actionDate;
	}

	/** 
	 * Set the actionDate.
	 * @param actionDate The actionDate to set
	 */
	public void setActionDate(String actionDate) {
		this.actionDate = actionDate;
	}

	/** 
	 * Returns the actionTypeId.
	 * @return int
	 */
	public int getActionTypeId() {
		return actionTypeId;
	}

	/** 
	 * Set the actionTypeId.
	 * @param actionTypeId The actionTypeId to set
	 */
	public void setActionTypeId(int actionTypeId) {
		this.actionTypeId = actionTypeId;
	}

	/** 
	 * Returns the actionCost.
	 * @return float
	 */
	public float getActionCost() {
		return actionCost;
	}

	/** 
	 * Set the actionCost.
	 * @param actionCost The actionCost to set
	 */
	public void setActionCost(float actionCost) {
		this.actionCost = actionCost;
	}

	/** 
	 * Returns the description.
	 * @return String
	 */
	public String getDescription() {
		return description;
	}

	/** 
	 * Set the description.
	 * @param description The description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/** 
	 * Returns the subject.
	 * @return String
	 */
	public String getSubject() {
		return subject;
	}

	/** 
	 * Set the subject.
	 * @param subject The subject to set
	 */
	public void setSubject(String subject) {
		this.subject = subject;
	}

	/** 
	 * Returns the operator.
	 * @return String
	 */
	public String getOperator() {
		return operator;
	}

	/** 
	 * Set the operator.
	 * @param operator The operator to set
	 */
	public void setOperator(String operator) {
		this.operator = operator;
	}
	
	public String getRequestId() {
		return requestId;
	}
	
	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}

		
	public void setAction(String action) {
		this.action = action;
	}

	public String getAction() {
		return action;
	}
 
	public String getActionId() {
		return actionId;
	}
	
	public void setActionId(String actionId) {
		this.actionId = actionId;
	}	
	
	

}
