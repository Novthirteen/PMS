/*
 * Created on 2005-10-26
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.report;

import com.aof.webapp.form.BaseForm;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AirfareCostRptForm extends BaseForm {
	private static final long serialVersionUID = 0;
	
	private String formAction;		//form action
	private String project;			// project id or project name
	private String fli_no;     // flight number
	private String tCode;     // flight number
	private String staff;			// who is refered by this Airfare cost
	private String status;			// is this airfare cost confirmed ?
	private String last_export;	// last time exporting to excel
	private String date_begin;		// confirmation date (begin)
	private String date_end;		// confirmation date (end)
	private String vendor;			// ...
	private String flag_ctrip;		// air fee published on the internet
	private String flag_desc;		// description of this airfare cost
	private String flag_export;		// FA export flag
	
	
	/**
	 * @return Returns the flag_export.
	 */
	public String getFlag_export() {
		return flag_export;
	}
	/**
	 * @param flag_export The flag_export to set.
	 */
	public void setFlag_export(String flag_export) {
		this.flag_export = flag_export;
	}
	public String getFormAction() {
		return formAction;
	}
	public void setFormAction(String formAction) {
		this.formAction = formAction;
	}
	public String getDate_begin() {
		return date_begin;
	}
	public void setDate_begin(String date_begin) {
		this.date_begin = date_begin;
	}
	public String getDate_end() {
		return date_end;
	}
	public void setDate_end(String date_end) {
		this.date_end = date_end;
	}
	public String getFlag_ctrip() {
		return flag_ctrip;
	}
	public void setFlag_ctrip(String flag_ctrip) {
		this.flag_ctrip = flag_ctrip;
	}
	public String getFlag_desc() {
		return flag_desc;
	}
	public void setFlag_desc(String flag_desc) {
		this.flag_desc = flag_desc;
	}
	public String getFli_no() {
		return fli_no;
	}
	public void setFli_no(String fli_no) {
		this.fli_no = fli_no;
	}
	public String getLast_export() {
		return last_export;
	}
	public void setLast_export(String last_export) {
		this.last_export = last_export;
	}
	public String getProject() {
		return project;
	}
	public void setProject(String project) {
		this.project = project;
	}
	public String getStaff() {
		return staff;
	}
	public void setStaff(String staff) {
		this.staff = staff;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getVendor() {
		return vendor;
	}
	public void setVendor(String vendor) {
		this.vendor = vendor;
	}
	/**
	 * @return Returns the tCode.
	 */
	public String getTCode() {
		return tCode;
	}
	/**
	 * @param code The tCode to set.
	 */
	public void setTCode(String code) {
		tCode = code;
	}
}
