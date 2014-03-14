/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.form;

import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.upload.FormFile;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
/**
 * @author xxp 
 * @version 2003-9-23
 *
 */
public class ContentForm extends ActionForm {

	/**
	 * The file that the user has uploaded
	 */
	protected FormFile theFile;
	
	protected String DESCRIPTION = null;
	protected String CONTENT_NAME = null;
	/**
	 * Retrieve a representation of the file the user has uploaded
	 */
	public FormFile getTheFile() {
			return theFile;
	}

	/**
	 * Set a representation of the file the user has uploaded
	 */
	public void setTheFile(FormFile theFile) {
			this.theFile = theFile;
	}

	/**
	 * @return
	 */
	public String getCONTENT_NAME() {
			if(CONTENT_NAME!=null){
				return new String(CONTENT_NAME);
			}else{
				return CONTENT_NAME;				
			}
	}

	/**
	 * @return
	 */
	public String getDESCRIPTION() {
			if(DESCRIPTION!=null){
				return new String(DESCRIPTION);
			}else{
				return DESCRIPTION;
			}
	}

	/**
	 * @param string
	 */
	public void setCONTENT_NAME(String string) {
		CONTENT_NAME = string;
	}

	/**
	 * @param string
	 */
	public void setDESCRIPTION(String string) {
		DESCRIPTION = string;
	}
	

	/**
	 * Reset all properties to their default values.
	 *
	 * @param mapping The mapping used to select this instance
	 * @param request The servlet request we are processing
	 */
	public void reset() {

		this.CONTENT_NAME = "";
		this.DESCRIPTION = "";
		this.theFile = null;

	}

}
