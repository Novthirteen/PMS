/*
 * Created on 2005-10-19
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.commons.beanutils.RowSetDynaClass;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ResourceOTTrackingRptAction extends ReportBaseAction {
	
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	public ActionForward perform (ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		try {
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
			String action = request.getParameter("FormAction");
			String proj = request.getParameter("proj");
			String cust = request.getParameter("cust");
			String user = request.getParameter("user");
			String date_begin = request.getParameter("date_begin");
			String date_end = request.getParameter("date_end");
			String departmentId = request.getParameter("departmentId");
			if (departmentId == null) departmentId = "";
			if (proj == null) proj = "";
			if (cust == null) cust = "";
			if (user == null) user = "";
			if (date_begin == null) {
				date_begin = Date_formater.format(UtilDateTime.toDate(01,01,2005,0,0,0));
			}

			if (date_end == null) {
				date_end = Date_formater.format(new Date());
			}
			if (action == null) action = "view";
			if (action.equals("QueryForList")) {
				ResultSet sr = findQueryResult(request,proj, cust, user, date_begin, date_end, departmentId);
				return (mapping.findForward("success"));
			}
		//	if (action.equals("ExportToExcel")) {
		//		return ExportToExcel(mapping,request, response,projType,departmentId, textcode, textpm,textcust);
		//	}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private ResultSet findQueryResult(HttpServletRequest request,String proj, String cust, String user, String date_begin, String date_end, String departmentId) throws Exception {
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		String SqlStr = "	";
		SqlStr = SqlStr + " select proj.proj_id as proj_id,	";
		SqlStr = SqlStr + " 		proj.proj_name as proj_name,	";
		SqlStr = SqlStr + " 		p.DESCRIPTION as customer,	";
		SqlStr = SqlStr + " 		ul.NAME as name,	";
		SqlStr = SqlStr + " 		convert(varchar(10),ts_det.ts_date,(126)) as ts_date,	";
		SqlStr = SqlStr + " 		ts_det.ts_hrs_user as hrs,	";
		SqlStr = SqlStr + " 		event.PEvent_Name as event	";
	
		SqlStr = SqlStr + " 	from Proj_TS_Det as ts_det	"; 
		SqlStr = SqlStr + " 		inner join Proj_Mstr as proj on proj.proj_id=ts_det.ts_proj_id	"; 
		SqlStr = SqlStr + " 		inner join PARTY as p on p.PARTY_ID=proj.cust_id	";
		SqlStr = SqlStr + " 		inner join Proj_TS_Mstr as ts_mst on ts_mst.tsm_id=ts_det.tsm_id	";
		SqlStr = SqlStr + " 		inner join USER_LOGIN as ul on ul.USER_LOGIN_ID=ts_mst.tsm_userlogin	";
		SqlStr = SqlStr + " 		inner join ProjEvent as event on event.PEvent_Id=ts_det.ts_projevent	";
		
		SqlStr = SqlStr + " 	where ";
		SqlStr = SqlStr + "			ts_det.ts_hrs_user>8 ";
		SqlStr = SqlStr + "			and (ts_det.ts_status='Approved' or ts_det.ts_status='Submitted')	";
		
		if (!proj.trim().equals("")) {
			SqlStr = SqlStr + " and ((proj_id like '%"+ proj.trim() +"%') or (proj_name like '%"+ proj.trim() +"%')) ";
		}
		if (!cust.trim().equals("")) {
			SqlStr = SqlStr + " and ((p.DESCRIPTION like '%"+ cust.trim() +"%') or (p.PARTY_ID like '%"+ cust.trim() +"%'))";
		}
		if (!user.trim().equals("")) {
			SqlStr = SqlStr + " and ((name like '%"+ user.trim() +"%') or (ul.USER_LOGIN_ID like '%"+ user.trim() +"%'))";
		}
		if (!date_begin.trim().equals("") && !date_end.trim().equals("")) {
			SqlStr = SqlStr + " and convert(varchar(10),ts_date,(126))>'" + date_begin.trim() + "' ";
			SqlStr = SqlStr + " and convert(varchar(10),ts_date,(126))<'" + date_end.trim() + "' ";
		}
		if (departmentId.trim().equals("")) {
			SqlStr = SqlStr + " and (proj.proj_pm_user = '"+ ul.getUserLoginId() +"')";
			
		} else {
			PartyHelper ph = new PartyHelper();
			List partyList_dep=ph.getAllSubPartysByPartyId(session,departmentId);
			String PartyListStr = "''";
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'"+departmentId+"'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
			SqlStr = SqlStr + " and (proj.dep_id in ("+PartyListStr+"))";
		}
		
		SqlStr = SqlStr + " 	order by proj_id,	";
		SqlStr = SqlStr + " 		customer,	";
		SqlStr = SqlStr + " 		name,	";
		SqlStr = SqlStr + " 		event,	";
		SqlStr = SqlStr + " 		ts_date	";
		
		System.out.println(SqlStr);
		
		ResultSet result = sqlExec.runQueryStreamResults(SqlStr.toString());			
		RowSetDynaClass resultSet = new RowSetDynaClass(result,false);
		sqlExec.closeConnection();
		request.setAttribute("QryList",resultSet);
		
		return result;
	}	
}
