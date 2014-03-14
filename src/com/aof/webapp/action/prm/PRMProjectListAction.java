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
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.PageBean;
/**
 * @author Paige Li 
 * @version 2004-12-19
 */
public class PRMProjectListAction extends BaseAction {

	private static final int MAXPAGE = 10;

	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(PRMProjectListAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		DynaValidatorForm actionForm = (DynaValidatorForm) form;
		HttpSession session = request.getSession();
		List projectSelectArr = new ArrayList();
		List result = new ArrayList();
		List pageNumberList = new ArrayList();
		PageBean pageBean = new PageBean();

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

		String pageNumber = request.getParameter("pageNumber");
		if(pageNumber == null ) pageNumber = "";
/*		if (!pageNumber.equals("")) {
			pageBean =
				(PageBean) session.getAttribute("ProjectPageBean");
			pageBean.setCurrentPage(new Integer(pageNumber).intValue());
			pageNumberList = getPageNumberList(pageBean);
		} else {
*/			//			init display
			try {
				net.sf.hibernate.Session hs =
					Hibernate2Session.currentSession();
				Transaction tx = null;
				String lStrOpt=request.getParameter("rad");
				String srchproj=request.getParameter("srchproj");

				if(lStrOpt == null ) lStrOpt = "2";
				if(srchproj == null ) srchproj = "";
				String QryStr = "";
				if (!srchproj.equals("")) {
					if (lStrOpt.equals("2")) {
						QryStr = QryStr + " and (p.projId like '%" + srchproj +"%' or p.projName like '%" + srchproj +"%')";
					} else {
						QryStr = QryStr + " and (p.projId = '" + srchproj +"' or p.projName = '" + srchproj +"')";
					}
				}
				
				result = initSelect(UserId, DateStart, QryStr);
//				pageBean.setItemList(result);
//				int recCount = result.size();
//				pageBean.setPage(MAXPAGE, recCount);
//				pageNumberList = getPageNumberList(pageBean);

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
//		}

//		session.setAttribute("ProjectPageBean", pageBean);
//		request.setAttribute("PageNumberList", pageNumberList);
			request.setAttribute("resultList",result);
		return (mapping.findForward("success"));
	}

	private List initSelect(String UserId, String DateStart, String AddCondition) {
		List result =  null;
		Date dayStart = UtilDateTime.getThisWeekDay(UtilDateTime.toDate2(DateStart),1);
		Date dayEnd = UtilDateTime.getDiffDay(dayStart, 6);
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			UserLogin ul = (UserLogin)hs.load(UserLogin.class,UserId);
			PartyHelper ph =new PartyHelper();
			String QryStr = "select  p from ProjectMaster as p inner join p.department as dep where p.projStatus = 'WIP'";
			if (!AddCondition.trim().equals("")) 
				QryStr = QryStr + AddCondition;
			QryStr = QryStr+" and ((p.PublicFlag = 'Y' and dep.partyId in "+ph.getParentPartyQryStrByPartyId(hs,ul.getParty().getPartyId())+")";
			QryStr = QryStr+" or (p.projId in (select pm.projId from ProjectAssignment as assign inner join assign.Project as pm inner join assign.User as ul";
			QryStr = QryStr+"  where pm.projStatus = 'WIP' and ul.userLoginId = :UserId";
			QryStr = QryStr+" and (assign.DateStart <= :dayEnd and assign.DateEnd >= :dayStart))) ";
			QryStr = QryStr+" or (p.ProjectManager.userLoginId = :UserId))";
			QryStr = QryStr+" and p.projName not like '%%HRM%'	";
			QryStr = QryStr +" order by p.customer.description asc"; 
			ProjectMaster pm = new ProjectMaster();

			
			Query q = hs.createQuery(QryStr);
			q.setParameter("UserId", UserId);
			q.setParameter("dayStart", dayStart);
			q.setParameter("dayEnd", dayEnd);
			result = q.list();
			
		} catch (Exception e) {
			e.printStackTrace();
			//return (mapping.findForward("success"));
		} 
		return result;
	}
}
