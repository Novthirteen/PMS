/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.security;

import java.io.IOException;
import java.util.Locale;

import net.sf.hibernate.HibernateException;

import org.apache.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.security.SecurityServices;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

/**
 * @author xxp 
 * @version 2003-6-26
 *
 */
public class EditSecurityGroupAction extends BaseAction {

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws IOException, ServletException {


		Logger log = Logger.getLogger(EditSecurityGroupAction.class.getName());
		
		
		// Extract attributes we will need
		Locale locale = getLocale(request);
		MessageResources messages = getResources();		
		String action = request.getParameter("action");

		String permissionId = request.getParameter("permissionId");
		String description = request.getParameter("description");

		if (action == null)
			action = "create";
			
		if (action.equals("create")){
		
			if ((permissionId == null) || (permissionId.length() < 1))
				actionDebug.addGlobalError(errors,"error.permission.required");		
			if ((description == null) || (description.length() < 1))
				actionDebug.addGlobalError(errors,"error.description.required");		


			SecurityServices ss = new SecurityServices();
		
			try {
				ss.createSecurityPermission(permissionId,description);
				log.info("Create Security Permission Success !");
			} catch (HibernateException e) {
				log.error("Error:"+e.getMessage());
				actionDebug.addGlobalError(errors,"error.edit");			
				e.printStackTrace();
			}
		
			if (!errors.empty()) {
				saveErrors(request, errors);
				return (new ActionForward(mapping.getInput()));
			}
		}
		
		if (action.equals("edit")){
			if ((permissionId == null) || (permissionId.length() < 1))
				actionDebug.addGlobalError(errors,"error.permission.required");		
			SecurityServices ss = new SecurityServices();
		
			try {
				ss.updateSecurityPermission(permissionId,description);
				log.info("Update Security Permission Success !");
			} catch (HibernateException e) {
				log.error("Error:"+e.getMessage());
				actionDebug.addGlobalError(errors,"error.update");			
				e.printStackTrace();
			}
		
			if (!errors.empty()) {
				saveErrors(request, errors);
				return (new ActionForward(mapping.getInput()));
			}			
		}
		
		if (action.equals("delete")){
			if ((permissionId == null) || (permissionId.length() < 1))
				actionDebug.addGlobalError(errors,"error.permission.required");		
			SecurityServices ss = new SecurityServices();
		
			try {
				ss.deleteSecurityPermission(permissionId);
				log.info("Delete Security Permission Success !");
			} catch (HibernateException e) {
				log.error("Error:"+e.getMessage());
				actionDebug.addGlobalError(errors,"error.delete");			
				e.printStackTrace();
			}
		
			if (!errors.empty()) {
				saveErrors(request, errors);
				return (new ActionForward(mapping.getInput()));
			}			
		}
		return (mapping.findForward("success"));						
	}
}
