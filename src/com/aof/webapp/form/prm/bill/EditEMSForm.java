/*
 * Created on 2005-4-7
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.bill;

import com.aof.webapp.form.BaseForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditEMSForm extends BaseForm {
	
	String formAction;
	
	Long emsId;
	
	String emsType;
	
	String emsNo;
	
	String emsDate;
	
	String emsStatus;
	
	String emsNote;
	
	String emsDepartment;
	
	Long[] invoiceId;

	/**
	 * @return Returns the emsDate.
	 */
	public String getEmsDate() {
		return emsDate;
	}
	/**
	 * @param emsDate The emsDate to set.
	 */
	public void setEmsDate(String emsDate) {
		this.emsDate = emsDate;
	}
	/**
	 * @return Returns the emsDepartment.
	 */
	public String getEmsDepartment() {
		return emsDepartment;
	}
	/**
	 * @param emsDepartment The emsDepartment to set.
	 */
	public void setEmsDepartment(String emsDepartment) {
		this.emsDepartment = emsDepartment;
	}
	/**
	 * @return Returns the emsId.
	 */
	public Long getEmsId() {
		return emsId;
	}
	/**
	 * @param emsId The emsId to set.
	 */
	public void setEmsId(Long emsId) {
		this.emsId = emsId;
	}
	/**
	 * @return Returns the emsNo.
	 */
	public String getEmsNo() {
		return emsNo;
	}
	/**
	 * @param emsNo The emsNo to set.
	 */
	public void setEmsNo(String emsNo) {
		this.emsNo = emsNo;
	}
	/**
	 * @return Returns the emsNote.
	 */
	public String getEmsNote() {
		return emsNote;
	}
	/**
	 * @param emsNote The emsNote to set.
	 */
	public void setEmsNote(String emsNote) {
		this.emsNote = emsNote;
	}
	/**
	 * @return Returns the emsStatus.
	 */
	public String getEmsStatus() {
		return emsStatus;
	}
	/**
	 * @param emsStatus The emsStatus to set.
	 */
	public void setEmsStatus(String emsStatus) {
		this.emsStatus = emsStatus;
	}
	/**
	 * @return Returns the emsType.
	 */
	public String getEmsType() {
		return emsType;
	}
	/**
	 * @param emsType The emsType to set.
	 */
	public void setEmsType(String emsType) {
		this.emsType = emsType;
	}
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
     * @return Returns the invoiceId.
     */
    public Long[] getInvoiceId() {
        return invoiceId;
    }
    /**
     * @param invoiceId The invoiceId to set.
     */
    public void setInvoiceId(Long[] invoiceId) {
        this.invoiceId = invoiceId;
    }
}
