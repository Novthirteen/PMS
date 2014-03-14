/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.crm.customer;


import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.crm.customer.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import net.sf.hibernate.*;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *
 */
public class ListIndustryAction extends BaseAction{
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
				// Extract attributes we will need
				Logger log = Logger.getLogger(ListIndustryAction.class.getName());
				Locale locale = getLocale(request);
				MessageResources messages = getResources();		
  
				try{
					
					List result = new ArrayList();
					net.sf.hibernate.Session session = Hibernate2Session.currentSession();
					//Query q = session.createQuery("select sm from SLAMSTR as sm ");
					//q.setMaxResults(20);
					//result = q.list();
					Criteria crit = session.createCriteria(Industry.class);
					//crit.setMaxResults(50);
					result = crit.list();
					
					request.setAttribute("QryList",result);
					
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
