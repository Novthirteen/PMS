/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import org.apache.struts.validator.DynaValidatorForm;

import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.ProjectEvent;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ServiceType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *  update time 2004-12-2
 */
public class ProjectSelectAction extends BaseAction {
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(ProjectSelectAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		DynaValidatorForm projectSelectForm = (DynaValidatorForm) form;
		ArrayList projectSelectArr = new ArrayList();
		ArrayList eventSelectArr = new ArrayList();
		ArrayList eventBillable = new ArrayList();
		ArrayList ServiceTypeSelectArr = new ArrayList();
		List result = new ArrayList();
		
		String UserId = request.getParameter("UserId");
		String DataPeriod = request.getParameter("DataPeriod");
		String nowTimestampString = UtilDateTime.nowTimestamp().toString();
		String DateStart = "";
		if (UserId == null) UserId = "";
		if (DataPeriod == null) {
			DateStart = nowTimestampString;
		} else {
			DateStart = DataPeriod + " 00:00:00.000";
		}

		if (action != null && action.equals("projectSelect")) {

			String projId = (String) projectSelectForm.get("projectSelect");
			try {
				net.sf.hibernate.Session hs =
					Hibernate2Session.currentSession();
				Transaction tx = null;
				Query q =
					hs.createQuery(
						"select projectMaster from ProjectMaster as projectMaster inner join projectMaster.projectType as projectType where projectMaster.projId = :projId");
				q.setParameter("projId", projId);
				result = q.list();
				Iterator itMstr = result.iterator();
				if (itMstr.hasNext()) {
					log.info("has event");
					ProjectMaster ProjectMaster = (ProjectMaster) itMstr.next();
					//if category of project is "internal" , then billable event is invisible
					Query sql = null;
					if(ProjectMaster.getProjectCategory().getName().trim().equals("Internal")){
						sql =
							hs.createQuery(
								"select projectEvent from ProjectEvent as projectEvent inner join projectEvent.pt as projectType where projectType.ptId = :projType and projectEvent.billable <> :isBill");
						sql.setParameter(
							"projType",
							ProjectMaster.getProjectType());
						sql.setParameter(
								"isBill",
								"Yes");
						result = sql.list();

						
						if(ProjectMaster.getProjId().startsWith("IB") && ProjectMaster.getContractGroup()!= null)
						{
							if(ProjectMaster.getContractGroup().equalsIgnoreCase("presale")){
								sql =
									hs.createQuery(
										"select projectEvent from ProjectEvent as projectEvent  where projectEvent.peventName = :Name and projectEvent.billable <> :isBill");
								sql.setParameter(
									"Name",
									"Pre-sales");
								sql.setParameter(
										"isBill",
										"Yes");
								if(sql.list()!=null)
								{
									result.add(0,sql.list().get(0));
								}				
							}
										
						}
					}else{
						sql =
							hs.createQuery(
								"select projectEvent from ProjectEvent as projectEvent inner join projectEvent.pt as projectType where projectType.ptId = :projType");
						sql.setParameter(
							"projType",
							ProjectMaster.getProjectType());
						result = sql.list();
					}
					Iterator itEvent = result.iterator();
					while (itEvent.hasNext()) {
						ProjectEvent projectEvent = (ProjectEvent) itEvent.next();
						HashMap eventSelectmap = new HashMap();
						eventSelectmap.put("key", projectEvent.getPeventId());
						eventSelectmap.put("value",projectEvent.getPeventName());
						eventSelectArr.add(eventSelectmap);
						HashMap eventBillablemap = new HashMap();
						eventBillablemap.put("key", projectEvent.getPeventId());
						eventBillablemap.put("value",projectEvent.getBillable());
						eventBillable.add(eventBillablemap);
					}
					sql = hs.createQuery(
							"select st from ServiceType as st inner join st.Project as p where p.projId = :projId");
					sql.setParameter("projId", projId);
					result = sql.list();
					Iterator itST = result.iterator();
					while (itST.hasNext()) {
						ServiceType st = (ServiceType) itST.next();
						HashMap ServiceTypeSelectmap = new HashMap();
						ServiceTypeSelectmap.put("key", st.getId());
						ServiceTypeSelectmap.put("value",st.getDescription());
						ServiceTypeSelectArr.add(ServiceTypeSelectmap);
					}
				}
				initSelect(result,projectSelectArr,UserId, DateStart);
			} catch (Exception e) {
				e.printStackTrace();
				log.error(e.getMessage());
				return (mapping.findForward("success"));
			} finally {
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
			//init display
		} else {
			initSelect(result,projectSelectArr,UserId, DateStart);
		}

		request.setAttribute("projectSelectArr", projectSelectArr);
		request.setAttribute("eventSelectArr", eventSelectArr);
		request.setAttribute("ServiceTypeSelectArr", ServiceTypeSelectArr);
		request.setAttribute("eventBillable", eventBillable);

		return (mapping.findForward("success"));
	}
	/**
	 * init the projectSelect
	 * @param result list
	 * @param projectSelectArr ArrayList
	 */
	private void initSelect(List result,ArrayList projectSelectArr, String UserId, String DateStart) {
		Date dayStart = UtilDateTime.getThisWeekDay(UtilDateTime.toDate2(DateStart),1);
		Date dayEnd = UtilDateTime.getDiffDay(dayStart, 6);
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			UserLogin ul = (UserLogin)hs.load(UserLogin.class,UserId);
			PartyHelper ph =new PartyHelper();
			String QryStr = "select distinct p from ProjectMaster as p inner join p.department as dep where p.projStatus = 'WIP'";
			QryStr = QryStr+" and ((p.PublicFlag = 'Y' and dep.partyId in "+ph.getParentPartyQryStrByPartyId(hs,ul.getParty().getPartyId())+")";
			QryStr = QryStr+" or (p.projId in (select pm.projId from ProjectAssignment as assign inner join assign.Project as pm inner join assign.User as ul";
			QryStr = QryStr+"  where p.PublicFlag = 'N' and pm.projStatus = 'WIP' and ul.userLoginId = :UserId";
			QryStr = QryStr+" and (assign.DateStart <= :dayEnd and assign.DateEnd >= :dayStart)))";
			QryStr = QryStr+" or (p.ProjectManager.userLoginId = :UserId))";
			// no general expense claim project
			QryStr = QryStr+" and p.category <>  ('general expense') 	";

			
			Query q = hs.createQuery(QryStr);
			q.setParameter("UserId", UserId);
			q.setParameter("dayStart", dayStart);
			q.setParameter("dayEnd", dayEnd);
			result = q.list();
			Iterator itMstr = result.iterator();
			while (itMstr.hasNext()) {
				ProjectMaster projectMaster = (ProjectMaster) itMstr.next();
				HashMap projectselectmap = new HashMap();
				projectselectmap.put("key", projectMaster.getProjId());
				projectselectmap.put("value", projectMaster.getProjId()+":"+projectMaster.getProjName()+"("+projectMaster.getCustomer().getDescription()+")-"+projectMaster.getProjectManager().getName());
				projectSelectArr.add(projectselectmap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			//return (mapping.findForward("success"));
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
	
	}
}

