/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.crm.customer;


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
import com.aof.component.crm.customer.*;
import com.aof.core.persistence.hibernate.*;
/**
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class EditIndustryAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditIndustryAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String action = request.getParameter("FormAction");
			String openType = request.getParameter("openType");
			
			log.info("action="+action);
			try{
				String DataStr = request.getParameter("DataId");
				Long DataId = null;
				if (DataStr == null || DataStr.length()<1) {
					
				} else {
					DataId = new Long(DataStr);					
				}
				String description = request.getParameter("description");
					
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				if(action == null)
					action = "view";
				
				if(action.equals("view")){
					if (DataId != null) {
						Industry id = (Industry)hs.load(Industry.class,DataId);
						
						request.setAttribute("datainfo",id);
					}
					if ("dialogView".equals(openType)) {
						return mapping.findForward("dialogView");
					} else {
						return (mapping.findForward("view"));
					}
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
						Industry id = new Industry();
						id.setDescription(description);
						hs.save(id);
						tx.commit();
						
						request.setAttribute("datainfo",id);
						log.info("go to >>>>>>>>>>>>>>>>. view forward");
					}catch(Exception e){
						e.printStackTrace();
					}
					
					if ("dialogView".equals(openType)) {
						return mapping.findForward("dialogView");
					} else {
						return (mapping.findForward("list"));
					}
				}
				
				if(action.equals("update")){ 
					if ((DataId == null) )
						actionDebug.addGlobalError(errors,"error.context.required");		

					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}

					tx = hs.beginTransaction();
					Industry id = (Industry)hs.load(Industry.class,DataId);
					id.setDescription(description);
					hs.update(id);
					tx.commit();
					
					request.setAttribute("datainfo",id);
					if ("dialogView".equals(openType)) {
						return mapping.findForward("dialogView");
					} else {
						return (mapping.findForward("view"));
					}
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
					Industry id = (Industry)hs.load(Industry.class,DataId);
					hs.delete(id);
					tx.commit();

					return (mapping.findForward("list"));
																	
				}

				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				if ("dialogView".equals(openType)) {
					return mapping.findForward("dialogView");
				} else {
					return (mapping.findForward("view"));
				}
			}catch(Exception e){
				e.printStackTrace();
				log.error(e.getMessage());
				if ("dialogView".equals(openType)) {
					return mapping.findForward("dialogView");
				} else {
					return (mapping.findForward("view"));
				}
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
