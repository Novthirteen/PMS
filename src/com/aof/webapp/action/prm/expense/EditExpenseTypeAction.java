/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.expense;


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
public class EditExpenseTypeAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditExpenseTypeAction.class.getName());
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
			
			String ExpCode= request.getParameter("expCode");
			String ExpDesc=request.getParameter("expDesc");
			String ExpBillCode=request.getParameter("expBillCode");
//			String ExpAccDesc=request.getParameter("expAccDesc");
//			String ExpBillAccDesc=request.getParameter("expBillAccDesc");
				
			String seq=null;
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			if(action == null)
				action = "view";
				
			if(action.equals("view")){
				log.info(action);
				ExpenseType et = (ExpenseType)hs.load(ExpenseType.class,DataId);
				
				request.setAttribute("datainfo",et);
				return (mapping.findForward("view"));
			}
			if(action.equals("create")){
				
				
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				try{
					tx = hs.beginTransaction();
					
					ExpenseType et = new ExpenseType();
					
					et.setExpCode(ExpCode);
					et.setExpDesc(ExpDesc);
					et.setExpBillCode(ExpBillCode);
//					et.setExpAccDesc(ExpAccDesc);
//					et.setExpBillAccDesc(ExpBillAccDesc);
					hs.save(et);
					tx.commit();
					
					request.setAttribute("datainfo",et);
					log.info("go to >>>>>>>>>>>>>>>>. view forward");
				}catch(Exception e){
					e.printStackTrace();
				}
				
				return (mapping.findForward("list"));
			}
			
			if(action.equals("update")){ 
				if (DataId == null)
					actionDebug.addGlobalError(errors,"error.context.required");		

				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				tx = hs.beginTransaction();
				ExpenseType et = (ExpenseType)hs.load(ExpenseType.class,DataId);
				et.setExpCode(ExpCode);
				et.setExpDesc(ExpDesc);
				et.setExpBillCode(ExpBillCode);
//				et.setExpAccDesc(ExpAccDesc);
//				et.setExpBillAccDesc(ExpBillAccDesc);
			    hs.update(et);
				tx.commit();
				
				request.setAttribute("datainfo",et);
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
				ExpenseType et = (ExpenseType)hs.load(ExpenseType.class,DataId);
				

				hs.delete(et);
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
