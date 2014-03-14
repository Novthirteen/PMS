/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action;

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class PageNumberBean{
	
	private String pageNumber;
	private String pageLink;
	
	

	
	/**
	 * @return
	 */
	public String getPageLink() {
		return pageLink;
	}

	/**
	 * @return
	 */
	public String getPageNumber() {
		return pageNumber;
	}

	/**
	 * @param string
	 */
	public void setPageLink(String string) {
		pageLink = string;
	}

	/**
	 * @param string
	 */
	public void setPageNumber(String string) {
		pageNumber = string;
	}

}
