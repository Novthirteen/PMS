/*
 * Created on 2005-5-8
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.bill;

import java.sql.Date;

import com.aof.webapp.form.BaseForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindLostRecordForm extends BaseForm {
	private String formAction;
	private String qryBillCode;
	private String qryProject;
	//private Date qryDateFrom;
	//private Date qryDateTo;
	private String qryDepartment;
	/**
	 * @return Returns the formAction.
	 */
	public String getFormAction() {
		return formAction;
	}
	/**
	 * @param formAction The formAction to set.
	 */
	public void setFormAction(String formAction) {
		this.formAction = formAction;
	}
	/**
	 * @return Returns the qryBillCode.
	 */
	public String getQryBillCode() {
		return qryBillCode;
	}
	/**
	 * @param qryBillCode The qryBillCode to set.
	 */
	public void setQryBillCode(String qryBillCode) {
		this.qryBillCode = qryBillCode;
	}
	/**
	 * @return Returns the qryDateFrom.
	 */
	//public Date getQryDateFrom() {
		//return qryDateFrom;
	//}
	/**
	 * @param qryDateFrom The qryDateFrom to set.
	 */
	//public void setQryDateFrom(Date qryDateFrom) {
		//this.qryDateFrom = qryDateFrom;
	//}
	/**
	 * @return Returns the qryDateTo.
	 */
	//public Date getQryDateTo() {
		//return qryDateTo;
	//}
	/**
	 * @param qryDateTo The qryDateTo to set.
	 */
	//public void setQryDateTo(Date qryDateTo) {
		//this.qryDateTo = qryDateTo;
	//}
	/**
	 * @return Returns the qryDepartment.
	 */
	public String getQryDepartment() {
		return qryDepartment;
	}
	/**
	 * @param qryDepartment The qryDepartment to set.
	 */
	public void setQryDepartment(String qryDepartment) {
		this.qryDepartment = qryDepartment;
	}
	/**
	 * @return Returns the qryProject.
	 */
	public String getQryProject() {
		return qryProject;
	}
	/**
	 * @param qryProject The qryProject to set.
	 */
	public void setQryProject(String qryProject) {
		this.qryProject = qryProject;
	}
}
