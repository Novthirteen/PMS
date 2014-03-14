/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.timesheet;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
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

import com.aof.component.prm.TimeSheet.TimeSheetForecastMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 * update time 2004-12-2
 */
public class ListTSForecastAction extends BaseAction {
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(ListTSForecastAction.class.getName());
		Locale locale = getLocale(request);
		HttpSession session = request.getSession();
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		String sltYR = request.getParameter("sltYR");
		if (sltYR != null){
			session.setAttribute("se_sltYR",sltYR);
		}else{
			sltYR = (String)session.getAttribute("se_sltYR");
		}
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		Date dayYearStart1 = UtilDateTime.toDate("1", "1", sltYR, "0", "0", "0");
		Date dayYearStart2 = UtilDateTime.getThisWeekDay(dayYearStart1, 1);
		Date dayYearEnd1 = UtilDateTime.toDate("12", "31", sltYR, "0", "0", "0");
		Date dayYearEnd2 = UtilDateTime.getThisWeekDay(dayYearEnd1, 7);
		int i = 1;
		String UserId = request.getParameter("chkSelect");
		String DepartmentId = request.getParameter("chkParty");
		if (UserId != null){
			session.setAttribute("se_UserId",UserId);
		}else{
			UserId = (String)session.getAttribute("se_UserId");
		}
		if (DepartmentId != null){
			session.setAttribute("se_DepartmentId",DepartmentId);
		}else{
			DepartmentId = (String)session.getAttribute("se_DepartmentId");
		}
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			List result = new ArrayList();
			TimeSheetForecastMaster tsm = null;
			//query 
			String QryStr = "select tsm.Period, tsm.UpdateDate , sum(ts.TsHoursUser) " +
					"from TimeSheetForecastDetail as ts left join ts.Project as p";
			QryStr = QryStr + " inner join ts.TimeSheetForecastMaster as tsm " +
					"inner join tsm.TsmUser as tUser";
			QryStr = QryStr + " where (ts.TsDate between :dayYearStart and :dayYearEnd) and tUser.userLoginId = :DataUser";
			QryStr = QryStr + " group by tsm.Period, tsm.UpdateDate order by tsm.Period";
			
			Query q = hs.createQuery(QryStr);
			
			q.setParameter("dayYearStart", dayYearStart2);
			q.setParameter("dayYearEnd", dayYearEnd2);
			q.setParameter("DataUser", UserId);
			result = q.list();
			Iterator itMstr = result.iterator();
			// set attribute of query result 
			request.setAttribute("QryMaster", result);
			return (mapping.findForward("success"));

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
	}
}
