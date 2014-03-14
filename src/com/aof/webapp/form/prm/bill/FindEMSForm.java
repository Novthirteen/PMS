/*
 * Created on 2005-4-6
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.bill;

import java.util.Date;

import com.aof.webapp.form.BaseForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindEMSForm extends BaseForm {
	
	String formAction;
	
	String qryEMSType;
	
	String qryEMSNo;
	
	//String qryEMSDateStart;
	
	//String qryEMSDateEnd;
	
	String qryDepartment;
	
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
	 * @return Returns the qryEMSDateEnd.
	 */
	//public String getQryEMSDateEnd() {
		//return qryEMSDateEnd;
	//}
	/**
	 * @param qryEMSDateEnd The qryEMSDateEnd to set.
	 */
	//public void setQryEMSDateEnd(String qryEMSDateEnd) {
		//this.qryEMSDateEnd = qryEMSDateEnd;
	//}
	/**
	 * @return Returns the qryEMSDateStart.
	 */
	//public String getQryEMSDateStart() {
		//return qryEMSDateStart;
	//}
	/**
	 * @param qryEMSDateStart The qryEMSDateStart to set.
	 */
	//public void setQryEMSDateStart(String qryEMSDateStart) {
		//this.qryEMSDateStart = qryEMSDateStart;
	//}
	/**
	 * @return Returns the qryEMSNo.
	 */
	public String getQryEMSNo() {
		return qryEMSNo;
	}
	/**
	 * @param qryEMSNo The qryEMSNo to set.
	 */
	public void setQryEMSNo(String qryEMSNo) {
		this.qryEMSNo = qryEMSNo;
	}
	/**
	 * @return Returns the qryEMSType.
	 */
	public String getQryEMSType() {
		return qryEMSType;
	}
	/**
	 * @param qryEMSType The qryEMSType to set.
	 */
	public void setQryEMSType(String qryEMSType) {
		this.qryEMSType = qryEMSType;
	}
}
