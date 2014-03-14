/*
 * Created on 2005-8-30
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.RowSetDynaClass;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
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
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ExpenseSummaryRptAction extends ReportBaseAction {


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
			String project = request.getParameter("project");
			String departmentId = request.getParameter("departmentId");
			//String textcode = request.getParameter("textcode");
			String FromDate = request.getParameter("dateStart");
			String EndDate = request.getParameter("dateEnd");
			String user = request.getParameter("user");
			//String textpm = request.getParameter("textpm");
			//String textcust = request.getParameter("textcust");
			//if (projType == null) projType = "";
			if (FromDate==null) FromDate=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-10));
			if (EndDate==null) EndDate=Date_formater.format(nowDate);
			if (departmentId == null) departmentId = "";
			if (user == null) user = "";
			//if (textcode == null) textcode = "";
			//if (textpm == null) textpm = "";
			//if (textcust == null) textcust = "";
			if (action == null) action = "view";
			if (action.equals("QueryForList")) {
				ResultSet sr = findQueryResult(request,  departmentId, project,user, FromDate, EndDate );
				//request.setAttribute("QryList",sr);
				return (mapping.findForward("success"));
			}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private ResultSet findQueryResult(HttpServletRequest request, String departmentId, String project, String user,
			String FromDate, String ToDate) throws Exception {
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String PartyListStr = "''";
	
		if (!departmentId.trim().equals("")) {
			List partyList_dep=ph.getAllSubPartysByPartyId(session,departmentId);
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'"+departmentId+"'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
		}
 
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		String SqlStr = " select pem.em_proj_id, pm.proj_name,pem.em_code, ul.name as expenseUser, pm.dep_id, p.description,";
		SqlStr = SqlStr + "	convert(varchar,cast(SUM(pet.ed_amt_user)as money),1) as amt, pem.em_curr_id, pem.em_claimtype, pm.proj_pm_user,pem.em_userlogin,";
		SqlStr = SqlStr + "	pem.em_status, convert(varchar(10), pem.em_entry_date , (126))as entryDate, convert(varchar(10), pem.em_exp_date , (126))as expDate,";
		SqlStr = SqlStr + "	convert(varchar(10), pem.em_approval_date , (126)) as appDate,  convert(varchar(10), pem.em_receipt_date , (126)) as payDate, ";
		SqlStr = SqlStr + " paidby = CASE pem.em_claimtype WHEN  'CY' THEN 'Customer' WHEN  'CN' THEN 'Company'	end ";
		SqlStr = SqlStr + " from proj_exp_mstr as pem ";
		SqlStr = SqlStr + " inner join proj_exp_det as pet on pet.em_id = pem.em_id ";
		SqlStr = SqlStr + " inner join proj_mstr as pm on pm.proj_id = pem.em_proj_id ";
		SqlStr = SqlStr + " inner join user_login as ul on ul.user_login_id= pem.em_userlogin ";
		SqlStr = SqlStr + " inner join party as p on p.party_id= pm.dep_id ";
		
		SqlStr = SqlStr + " where ";
		SqlStr = SqlStr + " pem.em_exp_date between '"+FromDate+"' and '"+ToDate+"'";
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " and pm.dep_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " and pm.proj_pm_user ='"+ul.getUserLoginId()+"'";
		}
		if (!project.trim().equals("")) {
			SqlStr = SqlStr + " and (pm.proj_name like '%"+project.trim()+"%' or pem.em_proj_id like '%"+project.trim()+"%')";
		} 
		if (!user.trim().equals("")) {
			SqlStr = SqlStr + " and (ul.name like '%"+user.trim()+"%' or pem.em_userlogin like '%"+user.trim()+"%')";
		}
		
	//	if (!textcode.trim().equals("")) {
	//		SqlStr = SqlStr + " and ((pm.proj_id like '%"+ textcode.trim() +"%') or (pm.proj_name like '%"+ textcode.trim() +"%'))";
	//	}


		SqlStr = SqlStr + " group by pem.em_proj_id, pem.em_code, ul.name, pm.dep_id, p.description, pm.proj_name,";
		SqlStr = SqlStr + " pem.em_curr_id, pem.em_claimtype, pem.em_status, pem.em_entry_date, pm.proj_pm_user,";
		SqlStr = SqlStr + " pem.em_exp_date, pem.em_approval_date, pem.em_receipt_date,pem.em_userlogin";
		SqlStr = SqlStr + "	having sum(pet.ed_amt_user)<>'0' ";
		SqlStr = SqlStr + " order by pem.em_exp_date";
		ResultSet result = sqlExec.runQueryStreamResults(SqlStr);
		//SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		RowSetDynaClass resultSet = new RowSetDynaClass(result,false);
		sqlExec.closeConnection();
		request.setAttribute("QryList",resultSet);
		return result;
	}
	
}
