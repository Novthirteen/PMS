package com.aof.webapp.action.crm.customer;

import java.sql.SQLException;
import java.util.Iterator;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.crm.customer.CustomerAccount;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

public class EditCustomerGroupAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditCustomerAccountAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();		
		String action = request.getParameter("FormAction");
		String openType = request.getParameter("openType");
		
		log.info("action="+action);
		try{
			String DataStr = request.getParameter("DataId");
			if (DataStr == null) DataStr ="";
			Long DataId = null;
			if (!DataStr.trim().equals("")) {
				DataId = new Long(DataStr);					
			}
			
			String description = request.getParameter("description");
			String Abbreviation = request.getParameter("Abbreviation");
			String Type = request.getParameter("Type");
			if (description == null) description = "";
			if (Abbreviation == null) Abbreviation = "";
			if (Type == null) Type = "";
				
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			if(action == null) action = "view";
			
			if (!isTokenValid(request)) {
				if (action.equals("create") || action.equals("update")) {
					action = "view";
				}
			} 
			saveToken(request);
			
			
			
			if(action.equals("view")) {
				if (DataId != null) {
					CustomerAccount id = (CustomerAccount)hs.load(CustomerAccount.class,DataId);
					request.setAttribute("EditDataInfo",id);
				}
				if ("dialogView".equals(openType)) {
					return mapping.findForward("dialogView");
				} else {
					return mapping.findForward("view");
				}
			}
			
			if(action.equals("create")){
				try{
					tx = hs.beginTransaction();
					CustomerAccount id = new CustomerAccount();
					id.setDescription(description);
					id.setAbbreviation(Abbreviation);
					id.setType(Type);
					hs.save(id);
					tx.commit();
					
					request.setAttribute("EditDataInfo",id);
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
				CustomerAccount id = (CustomerAccount)hs.load(CustomerAccount.class,DataId);
				id.setDescription(description);
				id.setAbbreviation(Abbreviation);
				id.setType(Type);
				hs.update(id);
				tx.commit();
				
				request.setAttribute("EditDataInfo",id);
				if ("dialogView".equals(openType)) {
					return (mapping.findForward("dialogView"));
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
				CustomerAccount id = (CustomerAccount)hs.load(CustomerAccount.class,DataId);
				hs.delete(id);
				tx.commit();

				return (mapping.findForward("list"));
																
			}
			
			if (!errors.empty()) {
				saveErrors(request, errors);
				return (new ActionForward(mapping.getInput()));
			}
			if ("dialogView".equals(openType)) {
				return (mapping.findForward("dialogView"));
			} else {
				return (mapping.findForward("view"));
			}
		}catch(Exception e){
			e.printStackTrace();
			log.error(e.getMessage());
			if ("dialogView".equals(openType)) {
				return (mapping.findForward("dialogView"));
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
