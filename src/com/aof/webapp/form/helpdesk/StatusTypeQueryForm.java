/*
 * Created on 2004-12-15
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.helpdesk;

import com.shcnc.struts.form.BaseQueryForm;

/**
 * @author yech
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class StatusTypeQueryForm extends BaseQueryForm {
	
	private String callType="";
	
	private String disabledStatus="";
	
	/**
	 * @return Returns the disabledStatus.
	 */
	public String getDisabledStatus() {
		return disabledStatus;
	}
	/**
	 * @param disabledStatus The disabledStatus to set.
	 */
	public void setDisabledStatus(String disabledStatus) {
		this.disabledStatus = disabledStatus;
	}
	/**
	 * @return Returns the callType.
	 */
	public String getCallType() {
		return callType;
	}
	/**
	 * @param callType The callType to set.
	 */
	public void setCallType(String callType) {
		this.callType = callType;
	}
}
