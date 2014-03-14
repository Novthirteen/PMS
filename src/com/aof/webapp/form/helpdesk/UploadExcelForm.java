/*
 * Created on 2004-12-22
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.helpdesk;

import org.apache.struts.upload.FormFile;
import org.apache.struts.validator.ValidatorForm;

/**
 * @author yech
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class UploadExcelForm extends ValidatorForm  {
	/** file property */
	private FormFile file;
	
	private String partyId;
	
	private String importCustomer;
	
	/**
	 * @return Returns the importCustomer.
	 */
	public String getImportCustomer() {
		return importCustomer;
	}
	/**
	 * @param importCustomer The importCustomer to set.
	 */
	public void setImportCustomer(String importCustomer) {
		this.importCustomer = importCustomer;
	}
	/**
	 * @return Returns the file.
	 */
	public FormFile getFile() {
		return file;
	}
	/**
	 * @param file The file to set.
	 */
	public void setFile(FormFile file) {
		this.file = file;
	}
	/**
	 * @return Returns the partyId.
	 */
	public String getPartyId() {
		return partyId;
	}
	/**
	 * @param partyId The partyId to set.
	 */
	public void setPartyId(String partyId) {
		this.partyId = partyId;
	}
}
