/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.master;


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


import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.component.prm.project.*;
import com.aof.core.persistence.hibernate.*;
/**
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class EditCurrencyTypeAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditCurrencyTypeAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String action = request.getParameter("FormAction");
			
			log.info("action="+action);
			try{
				if(action == null)
					action = "view";
				
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				
				if (action.equals("batchUpdate")) {
					String[] currId = request.getParameterValues("currId");
					String[] currName = request.getParameterValues("currName");
					String[] currRate = request.getParameterValues("currRate");
					
					List result = new ArrayList();
					
					try {
						tx = hs.beginTransaction();
						for (int i0= 0; currId != null && i0 < currId.length; i0++) {
							CurrencyType ct = new CurrencyType();
							ct.setCurrId(currId[i0]);
							ct.setCurrName(currName[i0]);
							ct.setCurrRate(new Float(currRate[i0]));
							hs.update(ct);
							
							result.add(ct);
						}
						tx.commit();
					} catch(Exception ex) {
						ex.printStackTrace();
						tx.rollback();
						
						Criteria crit = hs.createCriteria(CurrencyType.class);
						result = crit.list();
					}
					
					request.setAttribute("QryList",result);
					return (mapping.findForward("list"));
				} else {
					String DataId = request.getParameter("DataId");
					String ctName = request.getParameter("description");
				    String ctRateStr = request.getParameter("rate");
				    if (ctRateStr == null) ctRateStr = "0";
					Float ctRate = new Float(ctRateStr);	
					
					if(action.equals("view")){
						log.info(action);
						CurrencyType pt = (CurrencyType)hs.load(Currency.class,DataId);
						
						request.setAttribute("datainfo",pt);
						return (mapping.findForward("view"));
					}
					if(action.equals("create")){
						
						if ((DataId == null) || (DataId.length() < 1))
							actionDebug.addGlobalError(errors,"error.context.required");		
						
						if (!errors.empty()) {
							saveErrors(request, errors);
							return (new ActionForward(mapping.getInput()));
						}
						try{
							tx = hs.beginTransaction();
							
							CurrencyType ct = new CurrencyType();
							ct.setCurrId(DataId);
							ct.setCurrName(ctName);
							ct.setCurrRate(ctRate);
							hs.save(ct);
							tx.commit();
							
							request.setAttribute("datainfo",ct);
							log.info("go to >>>>>>>>>>>>>>>>. view forward");
						}catch(Exception e){
							e.printStackTrace();
						}
						
						return (mapping.findForward("view"));
					}
					
					if(action.equals("update")){ 
						if ((DataId == null) || (DataId.length() < 1))
							actionDebug.addGlobalError(errors,"error.context.required");		
	
						if (!errors.empty()) {
							saveErrors(request, errors);
							return (new ActionForward(mapping.getInput()));
						}
	
						tx = hs.beginTransaction();
						CurrencyType ct = (CurrencyType)hs.load(CurrencyType.class,DataId);
						ct.setCurrId(DataId);
						ct.setCurrName(ctName);
						ct.setCurrRate(ctRate);
					    hs.update(ct);
						tx.commit();
						
						request.setAttribute("datainfo",ct);
						return (mapping.findForward("view"));
					}
					
					if(action.equals("delete")){
						if ((DataId == null) || (DataId.length() < 1))
							actionDebug.addGlobalError(errors,"error.context.required");
						if (!errors.empty()) {
							saveErrors(request, errors);
							return (new ActionForward(mapping.getInput()));
						}
						tx = hs.beginTransaction();
						CurrencyType ct = (CurrencyType)hs.load(CurrencyType.class,DataId);
						
	
						hs.delete(ct);
						tx.commit();
	
						return (mapping.findForward("list"));
																		
					}
	
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					return (mapping.findForward("view"));
				}
			}catch(Exception e){
				e.printStackTrace();
				log.error(e.getMessage());
				if (action.equals("batchUpdate")) {
					return (mapping.findForward("list"));	
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
