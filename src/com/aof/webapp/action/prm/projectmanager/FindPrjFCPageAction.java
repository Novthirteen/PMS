/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.projectmanager;


import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.prm.project.*;
import com.aof.component.domain.party.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import net.sf.hibernate.*;

import java.sql.SQLException;
import java.text.DateFormat; 
import java.text.SimpleDateFormat; 
import java.util.*; 

import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
import com.aof.component.domain.party.*;
import com.aof.component.prm.TimeSheet.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import net.sf.hibernate.*;
import com.aof.util.*;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *
 */
public class FindPrjFCPageAction extends BaseAction{
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
				// Extract attributes we will need
				Logger log = Logger.getLogger(FindPrjFCPageAction.class.getName());
				Locale locale = getLocale(request);
				MessageResources messages = getResources();	
		        HttpSession session = request.getSession();	
		        UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
				try{
					
					List result = new ArrayList();
					String UserId=ul.getUserLoginId();
				    net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
					Transaction tx = null;
					//crit.setMaxResults(50);
					tx = hs.beginTransaction();
					Query q = hs.createQuery("select p from ProjectMaster as p inner join p.ProjectManager as pm where pm.userLoginId = :UserId and p.projStatus = 'WIP'");
					q.setParameter("UserId",UserId);
					result = q.list();
							 
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
