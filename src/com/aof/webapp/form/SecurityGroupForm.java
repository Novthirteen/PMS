/*
 * $Header: /home/cvsroot/HelpDesk/src/com/aof/webapp/form/SecurityGroupForm.java,v 1.3 2004/11/30 04:09:21 shilei Exp $
 * $Revision: 1.3 $
 * $Date: 2004/11/30 04:09:21 $
 *
 * ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ====================================================================
 */


package com.aof.webapp.form;


import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
  

/**
 * Form bean for the user profile page.  This form has the following fields,
 * with default values in square brackets:
 * <ul>
 * <li><b>password</b> - Entered password value
 * <li><b>username</b> - Entered username value
 * </ul>
 *
 * @author XingPing Xu
 * @version $Revision: 1.3 $ $Date: 2004/11/30 04:09:21 $
 */

public final class SecurityGroupForm extends ActionForm {


    /**
     * The password.
     */
    private String groupId = null;


    /**
     * The username.
     */
    private String description = null;



    // --------------------------------------------------------- Public Methods


    /**
     * Reset all properties to their default values.
     *
     * @param mapping The mapping used to select this instance
     * @param request The servlet request we are processing
     */
    public void reset(ActionMapping mapping, HttpServletRequest request) {

        this.groupId = null;
        this.description = null;

    }


    /**
     * Validate the properties that have been set from this HTTP request,
     * and return an <code>ActionErrors</code> object that encapsulates any
     * validation errors that have been found.  If no errors are found, return
     * <code>null</code> or an <code>ActionErrors</code> object with no
     * recorded error messages.
     *
     * @param mapping The mapping used to select this instance
     * @param request The servlet request we are processing
     */
    public ActionErrors validate(ActionMapping mapping,
                                 HttpServletRequest request) {

        ActionErrors errors = new ActionErrors();
        if ((description == null) || (description.length() < 1))
            errors.add("username", new ActionError("error.username.required"));
        if ((groupId == null) || (groupId.length() < 1))
            errors.add("password", new ActionError("error.password.required"));

        return errors;
 
    }


	/**
	 * @return
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @return
	 */
	public String getGroupId() {
		return groupId;
	}

	/**
	 * @param string
	 */
	public void setDescription(String string) {
		description = string;
	}

	/**
	 * @param string
	 */
	public void setGroupId(String string) {
		groupId = string;
	}

}
