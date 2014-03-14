//Created by MyEclipse Struts
//XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.form;

import org.apache.struts.action.ActionForm;
import org.apache.struts.upload.FormFile;

/** 
* MyEclipse Struts
* Creation date: 11-18-2004
* 
* XDoclet definition:
* @struts:form name="uploadFormForm"
*/
public class UploadForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	/** file property */
	private FormFile file;

	/** groupID property */
	private String groupID;

	// --------------------------------------------------------- Methods

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
	 * Returns the groupID.
	 * @return String
	 */
	public String getGroupID() {
		return groupID;
	}

	/** 
	 * Set the groupID.
	 * @param groupID The groupID to set
	 */
	public void setGroupID(String attachGroupID) {
		this.groupID = attachGroupID;
	}

}