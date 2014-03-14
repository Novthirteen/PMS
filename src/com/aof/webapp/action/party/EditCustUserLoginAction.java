/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.party;


import java.sql.SQLException;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.domain.party.UserLoginServices;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2003-7-2
 *
 */
public class EditCustUserLoginAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditCustUserLoginAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String action = request.getParameter("action");
			
			log.info("action="+action);
			try{
				String userLoginId = request.getParameter("userLoginId");
				String name = request.getParameter("name");
				String enable = request.getParameter("enable");
				String role = request.getParameter("role"); 
				String partyId = request.getParameter("partyId");
				String password = request.getParameter("password");
				
				String tele_code = request.getParameter("tele_code");
				String email_addr = request.getParameter("email_addr"); 
				String mobile_code = request.getParameter("mobile_code");
				String note = request.getParameter("note");
				
				if (userLoginId == null) userLoginId = "";
				if (enable == null) enable = "";
				if (role == null) role = "";
				if (partyId == null) partyId = "";
				if (password == null) password = "";
				
				if (tele_code == null) tele_code = "";
				if (email_addr == null) email_addr = "";
				if (mobile_code == null) mobile_code = "";
				if (note == null) note = "";
				
				log.info("============>"+name);

	
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				if(action == null)
					action = "view";
					
				if(action.equals("view")){
					log.info(action);
					
					UserLogin ul = null;
					if (!userLoginId.trim().equals(""))
						ul = (UserLogin)hs.load(UserLogin.class,userLoginId);
					
					request.setAttribute("userLogin",ul);
					return (mapping.findForward("view"));
				}
				if(action.equals("create")){
					if (userLoginId.trim().equals("")) {
						UserLoginServices us = new UserLoginServices();
						userLoginId = us.getCustUserID(hs);
					}
					
					if ((name == null) || (name.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		
					if ((role == null) || (name.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		
					if ((enable == null) || (name.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");	
					if ((partyId == null) || (partyId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");
					
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					try{
						tx = hs.beginTransaction();
						Party party = (Party)hs.load(Party.class,partyId);
					
						UserLogin ul = new UserLogin();
						
						ul.setUserLoginId(userLoginId);					
						ul.setName(name);
						ul.setRole(role);
						ul.setEnable(enable);
						ul.setParty(party); 
						ul.setCurrent_password(password);
						
						ul.setEmail_addr(email_addr);
						ul.setMobile_code(mobile_code);
						ul.setTele_code(tele_code);
						ul.setNote(note);
						
						hs.save(ul);
						tx.commit();
						hs.flush();
						request.setAttribute("userLogin",ul);
						return (mapping.findForward("view"));
					}catch(Exception e){
						e.printStackTrace();
					}
				}
				
				if(action.equals("update")){ 
					if (userLoginId.trim().equals(""))
						actionDebug.addGlobalError(errors,"error.context.required");		

					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}

					tx = hs.beginTransaction();
					UserLogin ul = (UserLogin)hs.load(UserLogin.class,userLoginId);
					Party party = (Party)hs.load(Party.class,partyId);
					ul.setName(name);
					ul.setRole(role);
					ul.setEnable(enable);
					ul.setParty(party); 
					ul.setCurrent_password(password);
					
					ul.setEmail_addr(email_addr);
					ul.setMobile_code(mobile_code);
					ul.setTele_code(tele_code);
					ul.setNote(note);
					
					hs.update(ul);
					tx.commit();	

					request.setAttribute("userLogin",ul);
					return (mapping.findForward("view"));
				}
				
				if(action.equals("delete")){
					if (userLoginId.trim().equals(""))
						actionDebug.addGlobalError(errors,"error.context.required");
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					tx = hs.beginTransaction();
					UserLogin ul = (UserLogin)hs.load(UserLogin.class,userLoginId);
					log.info("userloginId="+ul.getUserLoginId());
					hs.delete(ul);
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
