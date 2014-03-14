// Created by Xslt generator for Eclipse.
// XSL :  not found (java.io.FileNotFoundException:  (Bad file descriptor))
// Default XSL used : easystruts.jar$org.easystruts.xslgen.JavaClass.xsl

package com.aof.webapp.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

/** 
 * FileuploadForm.java created by EasyStruts - XsltGen.
 * http://easystruts.sf.net
 * created on 10-25-2004
 * 
 * XDoclet definition:
 * @struts:form name="fileuploadForm"
 */
public class FileuploadForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	/** fname property */
	private String fname;

	/** file property */
	private FormFile file;

	/** size property */
	private String size;
	
	private String field ;
	
	private String id;
	
	

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
	 * Method reset
	 * @param ActionMapping mapping
	 * @param HttpServletRequest request
	 */
	
	/** 
	 * Returns the fname.
	 * @return String
	 */
	public String getFname() {
		return fname;
	}

	/** 
	 * Set the fname.
	 * @param fname The fname to set
	 */
	public void setFname(String fname) {
		this.fname = fname;
	}

	/** 
	 * Returns the file.
	 * @return FormFile
	 */
	public FormFile getFile() {
		return file;
	}

	/** 
	 * Set the file.
	 * @param file The file to set
	 */
	public void setFile(FormFile file) {
		this.file = file;
	}

	/** 
	 * Returns the size.
	 * @return String
	 */
	public String getField() {
		return field;
	}

	/** 
	 * Set the size.
	 * @param size The size to set
	 */
	public void setField(String field) {
		this.field = field;
	}
	
	public String getId() {
		return id;
	}

		/** 
		 * Set the size.
		 * @param size The size to set
		 */
	public void setId(String id) {
		this.id = id;
	}

	public String getSize() {
		return size;
	}

		/** 
		 * Set the size.
		 * @param size The size to set
		 */
	public void setSize(String size) {
		this.size = size;
	}
}
