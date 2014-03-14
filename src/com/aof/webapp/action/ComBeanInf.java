/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */

package com.aof.webapp.action;

/**
 * @author Paige Li 
 * @version 2004-12-19
 */
public class ComBeanInf {

	private String backID = "";

	private String forwardID = "";

	public ComBeanInf() {
	}

	public void setBackID(String id) {
		this.backID = id;
		return;
	}

	public String getBackID() {
		return this.backID;
	}

	public void setForwardID(String id) {
		this.forwardID = id;
		return;
	}

	public String getForwardID() {
		return this.forwardID;
	}

	public void cloneBInf(ComBeanInf bInf) {
		bInf.setBackID(this.getBackID());
		bInf.setForwardID(bInf.getForwardID());
	}
}
