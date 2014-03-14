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
public class EditCustProjectEventAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditCustProjectEventAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String action = request.getParameter("FormAction");
			
			ProjectService ps = new ProjectService();
			
			log.info("action="+action);
			try{
				String DataStr = request.getParameter("DataId");
				Integer DataId = null;
				if (DataStr == null || DataStr.length()<1) {
					
				} else {
					DataId = new Integer(DataStr);					
				}
				
				String EName=request.getParameter("eName");
				String description = request.getParameter("description");
				String billable=request.getParameter("billable");
				String ProTypeId=request.getParameter("proType");
				log.info("bill"+billable);	
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				if(action == null)
					action = "view";
				
				if(billable == null)
					action = "No";
				
				if(action.equals("view")){
		
					ProjectEvent pe = (ProjectEvent)hs.load(ProjectEvent.class,DataId);
					
					request.setAttribute("datainfo",pe);
					return (mapping.findForward("view"));
				}
				if(action.equals("create")){
					
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					try{
						log.info("create");
						tx = hs.beginTransaction();
						log.info("create fun");
						ProjectEvent pe = new ProjectEvent();
						ProjectType pt=(ProjectType)hs.load(ProjectType.class,ProTypeId);
						//pe.setPeventId(DataId);
					//	pe.setPeventCode(EName);
						pe.setPeventCode(ps.genMaxEventCode(hs));
						pe.setPeventName(description);
						pe.setBillable(billable);
						pe.setPt(pt);
						hs.save(pe);
						tx.commit();
						
						request.setAttribute("datainfo",pe);
						log.info("go to >>>>>>>>>>>>>>>>. view forward");
					}catch(Exception e){
						e.printStackTrace();
					}
					
					return (mapping.findForward("list"));
				}
				
				if(action.equals("update")){ 
					if ((DataId == null) )
						actionDebug.addGlobalError(errors,"error.context.required");		

					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}

					tx = hs.beginTransaction();
					ProjectEvent pe = (ProjectEvent)hs.load(ProjectEvent.class,DataId);
					ProjectType pt=(ProjectType)hs.load(ProjectType.class,ProTypeId);
					
					pe.setPeventCode(EName);
					pe.setPeventName(description);
					pe.setBillable(billable);
					pe.setPt(pt);
					
					hs.update(pe);
					tx.commit();
					
					request.setAttribute("datainfo",pe);
					return (mapping.findForward("view"));
				}
				
				if(action.equals("delete")){
					if ((DataId == null))
						actionDebug.addGlobalError(errors,"error.context.required");
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					tx = hs.beginTransaction();
					log.info("del,id"+DataId);
					ProjectEvent pe = (ProjectEvent)hs.load(ProjectEvent.class,DataId);
					

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
