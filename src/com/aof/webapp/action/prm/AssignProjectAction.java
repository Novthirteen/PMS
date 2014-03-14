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
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class AssignProjectAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
		    HttpSession session = request.getSession();
			Logger log = Logger.getLogger(AssignProjectAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();	
			
			try{
				String action = request.getParameter("action");
				String DataId = request.getParameter("DataId");
				if (action == null) action = "";
				if (DataId == null) DataId = "";
								
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				List ProjectList = new ArrayList();
				ProjectMaster CustProject = null;
				if (!DataId.equals("")) {
					CustProject = (ProjectMaster)hs.load(ProjectMaster.class,DataId);
				}
				request.setAttribute("ProjectResult",CustProject);
				
				if (CustProject == null) {
					String textproj = request.getParameter("textproj");
					String textcust = request.getParameter("textcust");
					String textstatus = request.getParameter("textstatus");
					String departmentId = request.getParameter("departmentId");
					if (textproj == null) textproj = "";
					if (textcust == null) textcust = "";
					if (textstatus == null) textstatus = "";
					if (departmentId == null) departmentId = "";

					String QryStr = "select p from ProjectMaster as p";
					if (departmentId.trim().equals("")) {
						UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
						String UserId=ul.getUserLoginId();
						QryStr = QryStr + " where (p.ProjectManager.userLoginId = '"+ UserId +"')";
					} else {
						PartyHelper ph = new PartyHelper();
						List partyList_dep=ph.getAllSubPartysByPartyId(hs,departmentId);
						String PartyListStr = "''";
						Iterator itdep = partyList_dep.iterator();
						PartyListStr = "'"+departmentId+"'";
						while (itdep.hasNext()) {
							Party p =(Party)itdep.next();
							PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
						}
						QryStr = QryStr + " where (p.department.partyId in ("+PartyListStr+"))";
					}

					if(!textproj.trim().equals("")){
						QryStr = QryStr + " and (p.projId like '%"+ textproj +"%' or p.projName like '%"+ textproj +"%')";
					}
					if(!textcust.trim().equals("")){
						QryStr = QryStr + " and (p.customer.partyId like '%"+ textcust +"%' or p.customer.description like '%"+ textcust +"%')";
					}
					if(!textstatus.trim().equals("")){
						QryStr = QryStr + " and (p.projStatus = '"+ textstatus +"')";
					}else{
						QryStr = QryStr + " and (p.projStatus = 'WIP')";
					}
					Query q = hs.createQuery(QryStr);
					ProjectList = q.list();
				}
				
				request.setAttribute("ProjectList",ProjectList);
				return (mapping.findForward("success"));
			}catch(Exception e){
				e.printStackTrace();
				log.error(e.getMessage());
				return (mapping.findForward("success"));	
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