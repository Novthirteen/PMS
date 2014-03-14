/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.action.prm.expense;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
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

import com.aof.component.prm.TimeSheet.TimeSheetMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.timesheet.EditTimeSheetAction;

/**
 * @author Jackey Ding 
 * @version 2005-03-01
 */
public class FindTimeSheetPageAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	public ActionForward perform(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response) {
		
		//Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditTimeSheetAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		// get parameters from ListTimeSheet page
		String UserId = request.getParameter("UserId");
		String ProjectId = request.getParameter("ProjectId");
		String DataPeriod = request.getParameter("DataId");
		if (UserId == null) UserId = "";
		if (ProjectId == null) ProjectId = "";
		if (DataPeriod == null) DataPeriod = "";

		//date of this week
		//String DayArray[];
		//DayArray = new String[7];
		//SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		String nowTimestampString = UtilDateTime.nowTimestamp().toString();
		String DateStart = "";
		//float totalCount = 0;
		if (DataPeriod == null) {
			DateStart = nowTimestampString;
		} else {
			DateStart = DataPeriod + " 00:00:00.000";
		}
		Date dayStart = UtilDateTime.toDate2(DateStart);
		
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			//Transaction tx = null;
			List result = new ArrayList();
			// query the record from TimeSheetMaster according to loginId and period
			Query q =
				hs.createQuery(
					"select tsm from TimeSheetMaster as tsm inner join tsm.TsmUser as tUser where tsm.Period = ? and tUser.userLoginId = ?");
			q.setDate(0, dayStart);
			q.setString(1, UserId);
			result = q.list();
			
			Iterator itMstr = result.iterator();
			TimeSheetMaster tsm = null;
			if (itMstr.hasNext()) {
				// set query result to request
				request.setAttribute("QryList", result);
				
				tsm = (TimeSheetMaster) itMstr.next();
			} 
			
			result = fetchTSDetail(tsm, ProjectId);
			request.setAttribute("QryDetail", result);
			
			
			q =
				hs.createQuery(
					"select tsm from TimeSheetMaster as tsm inner join tsm.TsmUser as tUser where tsm.Period = ? and tUser.userLoginId = ?");
			Date date = UtilDateTime.getNextWeekDay(dayStart);
			q.setDate(0, UtilDateTime.getNextWeekDay(dayStart));
			q.setString(1, UserId);
			result = q.list();
			
			itMstr = result.iterator();
			tsm = null;
			if (itMstr.hasNext()) {
				// set query result to request
				request.setAttribute("QryList2", result);
				
				tsm = (TimeSheetMaster) itMstr.next();
			} 
			
			result = fetchTSDetail(tsm, ProjectId);
			request.setAttribute("QryDetail2", result);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
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
		
		return (mapping.findForward("success"));
	}
	
	private List fetchTSDetail (TimeSheetMaster tsm, String ProjectId) {
		List result = null;
		if (tsm != null) {
			Transaction tx = null;
			try {
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				String QryStr = "select ts from TimeSheetDetail as ts inner join ts.TimeSheetMaster as tsm " +
						                                             "inner join ts.Project as p " +
						                                             "inner join ts.projectEvent as pe inner " +
						                                             "join ts.TSServiceType as st " +
						                                             "where tsm.tsmId = :TSMasterId " +
																	 "  and p.projId = :ProjectId " +
						                                             "order by p.projId, pe.peventId , st.Id, ts.TsDate";
				Query q = hs.createQuery(QryStr);
				q.setParameter("TSMasterId", tsm.getTsmId());
				q.setParameter("ProjectId", ProjectId);
				result = q.list();
			} catch (Exception e) {
				e.printStackTrace();
			} 
		}
		return result;
	}
}
