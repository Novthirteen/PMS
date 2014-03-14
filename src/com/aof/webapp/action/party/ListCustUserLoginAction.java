/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.party;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;

import net.sf.hibernate.*;
/**
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class ListCustUserLoginAction extends BaseAction {
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
				// Extract attributes we will need
				Logger log = Logger.getLogger(ListCustUserLoginAction.class.getName());
				Locale locale = getLocale(request);
				MessageResources messages = getResources();		
								
				try{
					
					List result = new ArrayList();
					net.sf.hibernate.Session session = Hibernate2Session.currentSession();
					Query q = session.createQuery("select ul from UserLogin as ul inner join ul.party as p inner join p.partyRoles as pr where pr.roleTypeId = 'CUSTOMER'");
					//q.setMaxResults(length.intValue());
					//q.setFirstResult(offset.intValue());
					result = q.list();
					//Criteria crit = session.createCriteria(UserLogin.class);
					//crit.setMaxResults(50);
					//result = crit.list();
					
					request.setAttribute("userLogins",result);
					
					
				}catch(Exception e){
					
					log.error(e.getMessage());
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
				
				return (mapping.findForward("success"));
		}
}
