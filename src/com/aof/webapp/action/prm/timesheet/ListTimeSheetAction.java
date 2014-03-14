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

import com.aof.component.prm.TimeSheet.TimeSheetMaster;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 * update time 2004-12-2
 */
public class ListTimeSheetAction extends BaseAction {
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(ListTimeSheetAction.class.getName());
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
		Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
		Date dayYearStart1 = UtilDateTime.toDate("1", "1", sltYR, "0", "0", "0");
		Date dayYearStart2 = UtilDateTime.getThisWeekDay(dayYearStart1, 1);
		Date dayYearEnd1 = UtilDateTime.toDate("12", "31", sltYR, "0", "0", "0");
		Date dayYearEnd2 = UtilDateTime.getThisWeekDay(dayYearEnd1, 7);
		String dayYearStart = Date_formater.format(dayYearStart2);
		String dayYearEnd = Date_formater.format(dayYearEnd2);
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
			
			List result = new ArrayList();
			
			//query
			
			/*
			String QryStr = "select tsm.Period, tsm.UpdateDate , sum(ts.TsHoursUser) from TimeSheetDetail as ts inner join ts.Project as p";
			QryStr = QryStr + " inner join ts.TimeSheetMaster as tsm inner join tsm.TsmUser as tUser";
			QryStr = QryStr + " where (ts.TsDate between :dayYearStart and :dayYearEnd) and tUser.userLoginId = :DataUser";
			QryStr = QryStr + " group by tsm.Period, tsm.UpdateDate order by tsm.Period";
			
			Query q = hs.createQuery(QryStr);
			
			q.setParameter("dayYearStart", dayYearStart2);
			q.setParameter("dayYearEnd", dayYearEnd2);
			
			q.setParameter("DataUser", UserId);
			result = q.list();
			*/
			SQLExecutor sqlExec = new SQLExecutor(
							Persistencer.getSQLExecutorConnection(
									EntityUtil.getConnectionByName("jdbc/aofdb")));
									
			String QryStr =   " select ptm.ts_period, " 
							+ " sum(case when ptd.ts_status <> 'Draft' then ptd.ts_hrs_user else 0 end), " 
							+ " sum(case when (ptd.ts_status <> 'Draft' and pm.proj_category = 'C' and pe.Billable = 'YES') then ptd.ts_hrs_user else 0 end) - sum(case when (pm.proj_category = 'C' and pe.Billable = 'YES' and ptd.ts_status = 'Approved') then ptd.ts_hrs_user else 0 end), " 
							+ " sum(case when ptd.ts_status = 'Rejected' then ptd.ts_hrs_user else 0 end) ," 
							+ " sum(case when (ptd.ts_status <> 'Draft' and pm.proj_category = 'C' and pe.Billable = 'YES' and pm.proj_caf_flag = 'Y' and ptd.ts_cafstatus_confirm = 'N') then ptd.ts_hrs_user else 0 end)"
							+ " from  proj_ts_det as ptd " 
							+ " inner join proj_mstr as pm on ptd.ts_proj_id = pm.proj_id" 
							+ " inner join proj_ts_mstr as ptm on ptd.tsm_id = ptm.tsm_id" 
							+ " inner join user_login on ptm.tsm_userlogin = user_login.user_login_id"
							+ " inner join party as p on p.party_id = pm.cust_id"
							+ " inner join proj_servicetype as ps on ps.st_id = ptd.ts_servicetype"
							+ " inner join projevent as pe on pe.pevent_id = ptd.ts_projevent"
							+ " where (ptd.ts_date between '" + dayYearStart.toString() + "' and '" + dayYearEnd.toString() + "')" 
							+ " and ptm.tsm_userlogin = '" + UserId + "'" 
							+ " and ptd.ts_hrs_user <> 0 " 
							+ " group by ptm.ts_period" 
							+ " order by ptm.ts_period"
							;
			
			com.aof.core.persistence.jdbc.SQLResults sqlResults = sqlExec.runQueryCloseCon(QryStr);
			result = sqlResults.toList();
			
			// set attribute of query result 
			
			ArrayList MstrResult = new ArrayList();
			java.util.Iterator ir = result.iterator();
			while(ir.hasNext()){
				ArrayList al = new ArrayList();
				for(int count = 0; count < 5; count++)
					al.add(ir.next());
				MstrResult.add(al);
			}
			
			/*	
			SQLExecutor sqlExec2 = new SQLExecutor(Persistencer.getSQLExecutorConnection(
												EntityUtil.getConnectionByName("jdbc/aofdb")));	
			QryStr = " select ptm.ts_period, "
				   + " 8.00 * (case when ( cast ('" + Date_formater.format(nowDate) + "' -  cast(cast(( ptm.ts_period) as datetime) +7  as datetime) as integer) >=0 and pm.proj_caf_flag = 'y' and ptd.ts_cafstatus_confirm = 'N' and pm.proj_category = 'C' and pe.Billable <> 'No') then cast ('"+Date_formater.format(nowDate)+"' -  cast(cast(( ptm.ts_period) as datetime) +7  as datetime) as integer) else 0 end) as dc"
				   + " from  proj_ts_det as ptd " 
				   + " inner join proj_mstr as pm on ptd.ts_proj_id = pm.proj_id" 
				   + " inner join proj_ts_mstr as ptm on ptd.tsm_id = ptm.tsm_id" 
				   + " inner join user_login on ptm.tsm_userlogin = user_login.user_login_id"
				   + " inner join party as p on p.party_id = pm.cust_id"
				   + " inner join proj_servicetype as ps on ps.st_id = ptd.ts_servicetype"
				   + " inner join projevent as pe on pe.pevent_id = ptd.ts_projevent"
				   + " where (ptd.ts_date between '" + dayYearStart.toString() + "' and '" + dayYearEnd.toString() + "')" 
				   + " and ptm.tsm_userlogin = '" + UserId + "'" 
				   + " and pm.proj_caf_flag = 'y' and ptd.ts_cafstatus_confirm = 'N' and ptd.ts_hrs_user <> 0 and pm.proj_category = 'C' and pe.Billable <> 'No'" 					      
			       + " order by ptm.ts_period"
			       ;
			
			sqlResults = sqlExec2.runQueryCloseCon(QryStr);
			result = sqlResults.toList();
			if(result.size() != 0){        
				for(int i1 = 0, i2 = 0; i1 < MstrResult.size(); i1++){
					ArrayList al = (ArrayList)MstrResult.get(i1);
					if((al).get(0).equals(result.get(i2))){
						al.add(result.get(i2+1));
						i2 += 2;
						MstrResult.set(i1,al);
					}
					else{
						al.add(new Float(0.00));
						MstrResult.set(i1,al);
					}
				}	
			}
			else{
				for(int j = 0; j < MstrResult.size(); j++){
					ArrayList al = (ArrayList)MstrResult.get(j);
					al.add(new Float(0.00));
					MstrResult.set(j,al);
				}
			}
			*/
			
			request.setAttribute("QryMaster", MstrResult);
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
