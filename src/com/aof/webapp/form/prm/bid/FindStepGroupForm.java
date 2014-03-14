/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.form.prm.bid;

import org.apache.struts.action.ActionForm;

public class FindStepGroupForm extends ActionForm {
	private String qryFormAction;
	private String qryDepartmentId;
	private String qryDisableFlg;
	/**
	 * @return Returns the qryDepartmentId.
	 */
	public String getQryDepartmentId() {
		return qryDepartmentId;
	}
	/**
	 * @param qryDepartmentId The qryDepartmentId to set.
	 */
	public void setQryDepartmentId(String qryDepartmentId) {
		this.qryDepartmentId = qryDepartmentId;
	}
	/**
	 * @return Returns the qryDisableFlg.
	 */
	public String getQryDisableFlg() {
		return qryDisableFlg;
	}
	/**
	 * @param qryDisableFlg The qryDisableFlg to set.
	 */
	public void setQryDisableFlg(String qryDisableFlg) {
		this.qryDisableFlg = qryDisableFlg;
	}
	/**
	 * @return Returns the qryFormAction.
	 */
	public String getQryFormAction() {
		return qryFormAction;
	}
	/**
	 * @param qryFormAction The qryFormAction to set.
	 */
	public void setQryFormAction(String qryFormAction) {
		this.qryFormAction = qryFormAction;
	}
}
