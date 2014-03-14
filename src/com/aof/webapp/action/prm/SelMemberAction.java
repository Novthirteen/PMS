/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm;


import java.sql.SQLException;
import java.text.DateFormat; 
import java.text.SimpleDateFormat; 
import java.util.*; 
import java.text.SimpleDateFormat;

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
import com.aof.component.domain.party.*;
import com.aof.component.prm.TimeSheet.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import net.sf.hibernate.*;
import com.aof.util.*;
/**
/**
 * @author Elaine Sun
 * @version 2004-12-3
 *
 */
public class SelMemberAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(SelMemberAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		
		String departmentId = request.getParameter("departmentId");
		String action=request.getParameter("action");
		if(action == null ) action = "";
		
		String projId=request.getParameter("hiddenDataId");
		String memberId=request.getParameter("memberId");
		String DateStart=request.getParameter("DateStart");
		String DateEnd = request.getParameter("DateEnd"); 
		
		if(departmentId == null ) departmentId = "";
		Transaction tx = null;
		try{
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			//Transaction tx = null;
			
			List memberResult = new ArrayList();
			//tx = hs.beginTransaction();
			
			Query q = hs.createQuery("select ul from UserLogin as ul inner join ul.party as p where p.partyId = :DepId  and ul.enable = 'y' order by ul.name");
			q.setParameter("DepId", departmentId);
			memberResult = q.list();
			request.setAttribute("memberResult",memberResult);
			//tx = hs.beginTransaction();
			//tx.commit();
		
			if (action.equalsIgnoreCase("edit")) {
				String id = request.getParameter("id");
				if(id != null && !id.equals("")){
					//net.sf.hibernate.Session hs1 = Hibernate2Session.currentSession();
					//Transaction tx1 = null;
					Long Id=new Long(id);
					tx = hs.beginTransaction();

					ProjectAssignment pa = (ProjectAssignment)hs.load(ProjectAssignment.class,Id);
					//hs.delete(pa);
					
					ProjectMaster project=(ProjectMaster)hs.load(ProjectMaster.class,projId);
					UserLogin member=(UserLogin)hs.load(UserLogin.class,memberId);
		
					//pa = new ProjectAssignment();

					pa.setProject(project);
					pa.setUser(member);
					pa.setDateStart(UtilDateTime.toDate2(DateStart + " 00:00:00.000"));
					pa.setDateEnd(UtilDateTime.toDate2(DateEnd + " 00:00:00.000"));
					
					hs.update(pa);
					//tx1.commit();
					
					request.setAttribute("datainfo",pa);
					log.info("go to >>>>>>>>>>>>>>>>. view forward");
				}
				
			}
			
			if(action.equalsIgnoreCase("create")){
					
				if (!errors.empty()) {
				        saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
				}
		    	try{
					//net.sf.hibernate.Session hs1 = Hibernate2Session.currentSession();
										//Transaction tx1 = null;
			
		    				tx = hs.beginTransaction();
		    				ProjectMaster project=(ProjectMaster)hs.load(ProjectMaster.class,projId);
					        UserLogin member=(UserLogin)hs.load(UserLogin.class,memberId);
							
							ProjectAssignment pa = new ProjectAssignment();
							//pa.setId(a);
							pa.setProject(project);
							pa.setUser(member);
							pa.setDateStart(UtilDateTime.toDate2(DateStart + " 00:00:00.000"));
							pa.setDateEnd(UtilDateTime.toDate2(DateEnd + " 00:00:00.000"));
							
							hs.save(pa);
							//tx1.commit();
							request.setAttribute("datainfo",pa);
							log.info("go to >>>>>>>>>>>>>>>>. view forward");
				}catch(Exception e){
						e.printStackTrace();
		    	}
				return (mapping.findForward("success"));	
								
			}	
			
			
		return (mapping.findForward("success"));
		}catch(Exception e){
						e.printStackTrace();
						log.error(e.getMessage());
						return (mapping.findForward("success"));	
					}finally{
						try {
							if (tx != null) tx.commit();
							Hibernate2Session.closeSession();
						} catch (HibernateException e1) {							
								try {
									if (tx != null) tx.rollback();
								} catch (HibernateException e2) {
									// TODO Auto-generated catch block
									e2.printStackTrace();
								}
							log.error(e1.getMessage());
							e1.printStackTrace();
						} catch (SQLException e1) {
							try {
								if (tx != null) tx.rollback();
							} catch (HibernateException e2) {
								// TODO Auto-generated catch block
								e2.printStackTrace();
							}
							log.error(e1.getMessage());
							e1.printStackTrace();
						}
					}
	}
}
