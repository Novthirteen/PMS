/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */



package com.aof.webapp.taglibs;

import java.io.IOException;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;   
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;
import org.apache.struts.action.Action;
import org.apache.struts.util.MessageResources;

import com.aof.util.Constants;  


public final class CheckLogonTag extends TagSupport {


	// --------------------------------------------------- Instance Variables


	/**
	 * The key of the session-scope bean we look for.
	 */
	private String name = Constants.USERLOGIN_KEY;


	/**
	 * The page to which we should forward for the user to log on.
	 */
	private String page = "/checklogon.do";


	// ----------------------------------------------------------- Properties


	/**
	 * Return the bean name.
	 */
	public String getName() {

	return (this.name);

	}


	/**
	 * Set the bean name.
	 *
	 * @param name The new bean name
	 */
	public void setName(String name) {

	this.name = name;

	}


	/**
	 * Return the forward page.
	 */
	public String getPage() {

	return (this.page);

	}


	/**
	 * Set the forward page.
	 *
	 * @param page The new forward page
	 */
	public void setPage(String page) {

	this.page = page;

	}


	// ------------------------------------------------------- Public Methods


	/**
	 * Defer our checking until the end of this tag is encountered.
	 *
	 * @exception JspException if a JSP exception has occurred
	 */
	public int doStartTag() throws JspException {

	return (SKIP_BODY);

	}


	/**
	 * Perform our logged-in user check by looking for the existence of
	 * a session scope bean under the specified name.  If this bean is not
	 * present, control is forwarded to the specified logon page.
	 *
	 * @exception JspException if a JSP exception has occurred
	 */
	public int doEndTag() throws JspException {

	// Is there a valid user logged on?
	boolean valid = false;
	HttpSession session = pageContext.getSession();
	if ((session != null) && (session.getAttribute(name) != null))
		valid = true;

	// Forward control based on the results
	if (valid){
		return (EVAL_PAGE);
	}
		
	else {
		try {
		pageContext.forward(page);
		} catch (Exception e) {
		throw new JspException(e.toString());
		}
		return (SKIP_PAGE);
	}

	}


	/**
	 * Release any acquired resources.
	 */
	public void release() {

		super.release();
		//this.name = Constants.USERLOGIN_KEY;
		//this.page = "checklogon.do";
		this.name = null;
		this.page = null;
	}


}
