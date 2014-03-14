/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.project;


import java.sql.SQLException;
import java.util.*; 

import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.*;

import org.apache.log4j.Logger;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;


import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.component.prm.project.*;
import com.aof.core.persistence.hibernate.*;
/**
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class EditCustProjectEventTypeAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditCustProjectEventTypeAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String action = request.getParameter("FormAction");
			
			log.info("action="+action);
			try{
				String DataStr = request.getParameter("DataId");
				Integer DataId = null;
			if (DataStr == null || DataStr.length()<1) {
			
			} else {
				DataId = new Integer(DataStr);					
			}	
			String description = request.getParameter("description");	
				
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				if(action == null)
					action = "view";
					
				if(action.equals("view")){
					log.info(action);
					ProjectEventType pet = (ProjectEventType)hs.load(ProjectEventType.class,DataId);
					
					request.setAttribute("datainfo",pet);
					return (mapping.findForward("view"));
				}
				if(action.equals("create")){
					
					if (DataId == null )
						actionDebug.addGlobalError(errors,"error.context.required");		
					
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					try{
						tx = hs.beginTransaction();
						
						ProjectEventType pet = new ProjectEventType();
						pet.setPetId(DataId);
						pet.setPetName(description);
						hs.save(pet);
						tx.commit();
						
						request.setAttribute("datainfo",pet);
						log.info("go to >>>>>>>>>>>>>>>>. view forward");
					}catch(Exception e){
						e.printStackTrace();
					}
					
					return (mapping.findForward("view"));
				}
				
				if(action.equals("update")){ 
					if (DataId == null)
						actionDebug.addGlobalError(errors,"error.context.required");		

					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}

					tx = hs.beginTransaction();
					ProjectEventType pet = (ProjectEventType)hs.load(ProjectEventType.class,DataId);
					pet.setPetId(DataId);
					pet.setPetName(description);
					hs.update(pet);
					tx.commit();
					
					request.setAttribute("datainfo",pet);
					return (mapping.findForward("view"));
				}
				
				if(action.equals("delete")){
					if (DataId == null)
						actionDebug.addGlobalError(errors,"error.context.required");
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					tx = hs.beginTransaction();
					ProjectEventType pe = (ProjectEventType)hs.load(ProjectEventType.class,DataId);
					

					hs.delete(pe);
					tx.commit();

					return (mapping.findForward("list"));
																	
				}

				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				return (mapping.findForward("view"));
			}catch(Exception e){
				e.printStackTrace();
				log.error(e.getMessage());
				return (mapping.findForward("view"));	
			}finally{
				try {
					Hibernate2Session.closeSession();
				} catch (HibernateException e1) {
					log.error(e1.getMessage());
					e1.printStackTrace();
				} catch (SQLException e1) {
					log.error(e1.getMessage());
					e1.printStackTrace();
				}
			}
	}
}
