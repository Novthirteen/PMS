/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.security;

import java.io.IOException;
import java.util.*;

import org.apache.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;

/**
 * @author xxp 
 * @version 2003-6-26
 *
 */
public class ListSecurityGroupAction extends BaseAction {

	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws IOException, ServletException {

		Logger log = Logger.getLogger(ListSecurityGroupAction.class.getName());
		
		// Extract attributes we will need
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		HttpSession session = request.getSession();
		String action = request.getParameter("action");
		if (action == null)
			action = "Create";
		

		List list = new ArrayList();
		net.sf.hibernate.Session hsession;
		try {
			hsession = Hibernate2Session.currentSession();
			list = hsession.find("from SecurityPermission sp");	
			Hibernate2Session.closeSession();
		} catch (Exception e) {
			log.error("Error:"+e.getMessage());
			e.printStackTrace();
		} 
		session.setAttribute("securityPermisssions",list);




		return (mapping.findForward("success"));						
	}
}
