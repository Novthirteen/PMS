/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

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
import com.aof.component.prm.project.FMonth;
import com.aof.component.prm.project.FMonthHelper;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;

/**
 * @author Angus Chen 
 * @version 2005-2-23
 *
 */
public class ProjectOverBudgetRptAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	private Log log = LogFactory.getLog(ProjectOverBudgetRptAction.class);
	
	public ActionForward execute (ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
	ActionErrors errors = this.getActionErrors(request.getSession());
	Locale locale = getLocale(request);
	MessageResources messages = getResources();
		
	try {
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		String nowDateString = Date_formater.format((java.util.Date)UtilDateTime.nowTimestamp());
			
		String SqlStr = "";
		SQLResults sr = null;
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
			
		String SrcYear = (String)request.getParameter("SrcYear");
		String SrcMonth = (String)request.getParameter("SrcMonth");
		int srcYR = 0;
		int srcM = 0;
		
		String CurrFMId = "";
		String LastFMId = "";
		String CurrDataTo = "";
		String LastDataTo = "";
		String MonthDate = "";
			
		if (SrcYear == null || SrcMonth == null) {
			SqlStr = "select max(f_fm_cd) from FMonth where f_fmdate_to < '" +nowDateString+"'";
			sr = sqlExec.runQuery(SqlStr);
			CurrFMId = sr.getString(0,0);
			SqlStr = "select * from FMonth where f_fm_cd = " +CurrFMId;
			sr = sqlExec.runQuery(SqlStr);
			srcYR = sr.getInt(0,"f_yr");
			srcM = sr.getInt(0,"f_fmseq");
			CurrDataTo = Date_formater.format(sr.getDate(0,"f_fmdate_to"));
			
			Calendar calendar = Calendar.getInstance();
			calendar.set(srcYR, srcM, 1);
			
			MonthDate = (new SimpleDateFormat("MMM yyyy", Locale.ENGLISH)).format(calendar.getTime());
		} else {
			srcYR = new Integer(SrcYear).intValue();
			srcM = new Integer(SrcMonth).intValue();
			SqlStr = "select * from FMonth where f_yr = " +SrcYear + " and f_fmseq = "+SrcMonth;
			sr = sqlExec.runQuery(SqlStr);
			CurrFMId = sr.getString(0,"f_fm_cd");
			CurrDataTo = Date_formater.format(sr.getDate(0,"f_fmdate_to"));
			
			srcYR = sr.getInt(0,"f_yr");
			srcM = sr.getInt(0,"f_fmseq");
			Calendar calendar = Calendar.getInstance();
			calendar.set(srcYR, srcM, 1);
			
			MonthDate = (new SimpleDateFormat("MMM yyyy", Locale.ENGLISH)).format(calendar.getTime());
		}
		request.setAttribute("SrcYear",new Integer(srcYR).toString());
		request.setAttribute("SrcMonth",new Integer(srcM).toString());
		SqlStr = "select max(f_fm_cd) from FMonth where f_fm_cd < " +CurrFMId;
		sr = sqlExec.runQuery(SqlStr);
		LastFMId = sr.getString(0,0);
		SqlStr = "select * from FMonth where f_fm_cd = " +LastFMId;
		sr = sqlExec.runQueryCloseCon(SqlStr);
		LastDataTo = Date_formater.format(sr.getDate(0,"f_fmdate_to"));
		
		CurrDataTo = CurrDataTo + " 23:59";
		LastDataTo = LastDataTo + " 23:59";
		
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		
		FMonthHelper fh = new FMonthHelper();
		FMonth fMonth = fh.findFiscalMonthByYearAndMonth(session, srcYR, srcM + 1);

		String departmentId = request.getParameter("departmentId");
		if (departmentId == null) departmentId = "";
			
		String action = request.getParameter("FormAction");
		if (action == null) action = "view";
			
		if (action.equals("QueryForList")) {
			sr = findQueryResult(request,CurrFMId,CurrDataTo,LastDataTo,departmentId);
			request.setAttribute("QryList",sr);
			return (mapping.findForward("success"));
		}
		if (action.equals("ExportToExcel")) {
			return ExportToExcel(mapping,request,response,CurrFMId,CurrDataTo,MonthDate,LastDataTo,departmentId,fMonth);
		}
		
	}catch(Exception e){
		e.printStackTrace();
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
	
	private SQLResults findQueryResult(HttpServletRequest request,String CurrFMId, String CurrDataTo, String LastDataTo,String departmentId) throws Exception {
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
		String SqlStr = "";
		boolean detailflag = false;
		if (request.getParameter("detailflag") != null) detailflag = true;

		if (!detailflag) {
			SqlStr = SqlStr + "select ul.user_login_id, ul.name, proj.proc_budget, proj.proj_id, proj.proj_name, detres.c_name as c_name, sum(detres.total_sales_value) as total_sales_value,";
			SqlStr = SqlStr + " sum(detres.total_budget) as total_budget, sum(CurrCost) as CurrCost, sum(TotalCost) as TotalCost, sum(CurrCTC) as CurrCTC , sum(SubCon_CurrCost) as SubCon_CurrCost";
			SqlStr = SqlStr + " from proj_mstr as proj inner join user_login as ul on proj.proj_pm_user = ul.user_login_id inner join (";
		}
		
		SqlStr = SqlStr + "select ul.user_login_id, ul.name, proj.proc_budget, proj.proj_id, proj.proj_linknote, proj.proj_name, (proj.total_service_value + proj.total_lics_value) as total_sales_value, (proj.psc_budget + proj.exp_budget + proj.proc_budget) as total_budget, custp.description as c_name,";
		SqlStr = SqlStr + " sum(case when res.AmtType = 'Cost' then res.CurrAmt else 0 end) as CurrCost,";
		SqlStr = SqlStr + " sum(case when res.AmtType = 'Cost' then res.TotalAmt else 0 end) as TotalCost,";
		SqlStr = SqlStr + " sum(case when res.AmtType = 'ExtCost' then res.CurrAmt else 0 end) as SubCon_CurrCost,";
		SqlStr = SqlStr + " sum(case when res.AmtType = 'CTC' then res.CurrAmt else 0 end) as CurrCTC";
		SqlStr = SqlStr + " from party as custp inner join proj_mstr as proj on custp.party_id = proj.cust_id";
		SqlStr = SqlStr + " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
		SqlStr = SqlStr + " inner join (select tsd.ts_proj_id as proj_id, 'Cost' as AmtType, sum(tsd.ts_hrs_user * tsd.ts_user_rate) as TotalAmt,";
		SqlStr = SqlStr + " sum(case when tsd.ts_date > '"+LastDataTo+"' then tsd.ts_hrs_user * tsd.ts_user_rate else 0 end) as CurrAmt";
		SqlStr = SqlStr + " from proj_ts_det as tsd inner join proj_mstr as proj on (tsd.ts_proj_id = proj.proj_id and proj.proj_category = 'C') ";
		
		// Down was added by Jackey Ding 2005-03-04
		SqlStr = SqlStr + " inner join proj_ts_mstr as tsm on tsd.tsm_id = tsm.tsm_id";
		SqlStr = SqlStr + " inner join user_login as user_login on (tsm.tsm_userlogin = user_login.user_login_id and user_login.note <>'EXT')";
		// Up was added by Jackey Ding 2005-03-04 
		
		// Down was edited by Jackey Ding 2005-03-09
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " inner join party as dep on proj.dep_id = dep.party_id";
			SqlStr = SqlStr + " where dep.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
			SqlStr = SqlStr + " where ul.user_login_id ='"+ul.getUserLoginId()+"'";
		}
		// Up was edited by Jackey Ding 2005-03-09
		
		SqlStr = SqlStr + " and tsd.ts_status = 'Approved' and tsd.ts_date <= '"+CurrDataTo+"'";
		SqlStr = SqlStr + " group by tsd.ts_proj_id";
		SqlStr = SqlStr + " union";
		SqlStr = SqlStr + " select em.em_proj_id as proj_id, 'Cost' as AmtType, sum(ea.ea_amt_user * em.em_Curr_Rate) as TotalAmt";
		SqlStr = SqlStr + " , sum(case when em.em_approval_date > '"+LastDataTo+"' then ea.ea_amt_user * em.em_Curr_Rate else 0 end) as CurrAmt";
		SqlStr = SqlStr + " from Proj_Exp_Amt as ea inner join proj_exp_mstr as em on ea.em_id = em.em_id ";
		SqlStr = SqlStr + " inner join proj_mstr as proj on (em.em_proj_id = proj.proj_id and proj.proj_category = 'C') ";
		
		// Down was edited by Jackey Ding 2005-03-09
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " inner join party as dep on proj.dep_id = dep.party_id";
			SqlStr = SqlStr + " where dep.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
			SqlStr = SqlStr + " where ul.user_login_id ='"+ul.getUserLoginId()+"'";
		}
		// Up was edited by Jackey Ding 2005-03-09
		
		SqlStr = SqlStr + " and em.em_claimtype='CN' and em.em_approval_date <= '"+CurrDataTo+"'";
		SqlStr = SqlStr + " group by em.em_proj_id";
		SqlStr = SqlStr + " union";
		SqlStr = SqlStr + " select pcd.proj_Id as proj_id, 'Cost' as AmtType, sum(pcd.percentage * pcm.totalvalue * pcm.exchangerate)/100 as TotalAmt";
		SqlStr = SqlStr + " , sum(case when pcm.approvalDate > '"+LastDataTo+"' then pcd.percentage * pcm.totalvalue * pcm.exchangerate else 0 end)/100 as CurrAmt";
		SqlStr = SqlStr + " from proj_cost_det as pcd inner join proj_cost_mstr as pcm on pcd.costcode = pcm.costcode";
		SqlStr = SqlStr + " inner join Proj_Cost_Type as pct on pct.typeid=pcm.type";
		SqlStr = SqlStr + " inner join proj_mstr as proj on (pcd.proj_Id = proj.proj_id and proj.proj_category = 'C')";
		
		// Down was edited by Jackey Ding 2005-03-09
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " inner join party as dep on proj.dep_id = dep.party_id";
			SqlStr = SqlStr + " where dep.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
			SqlStr = SqlStr + " where ul.user_login_id ='"+ul.getUserLoginId()+"'";
		}
		// Up was edited by Jackey Ding 2005-03-09
		
		SqlStr = SqlStr + " and pcm.claimtype='CN' " +
				"and pct.typeaccount ='Expense' " +
				"and pcm.approvalDate <= '"+CurrDataTo+"'";
		SqlStr = SqlStr + " group by pcd.proj_Id";
		/////////----------------------------------
		SqlStr = SqlStr + " union";
		SqlStr = SqlStr + " select pcd.proj_Id as proj_id, 'ExtCost' as AmtType, sum(pcd.percentage * pcm.totalvalue * pcm.exchangerate)/100 as TotalAmt";
		SqlStr = SqlStr + " , sum(case when pcm.approvalDate > '"+LastDataTo+"' then pcd.percentage * pcm.totalvalue * pcm.exchangerate else 0 end)/100 as CurrAmt";
		SqlStr = SqlStr + " from proj_cost_det as pcd inner join proj_cost_mstr as pcm on pcd.costcode = pcm.costcode";
		SqlStr = SqlStr + " inner join Proj_Cost_Type as pct on pct.typeid=pcm.type";
		SqlStr = SqlStr + " inner join proj_mstr as proj on (pcd.proj_Id = proj.proj_id and proj.proj_category = 'C')";
		
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " inner join party as dep on proj.dep_id = dep.party_id";
			SqlStr = SqlStr + " where dep.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
			SqlStr = SqlStr + " where ul.user_login_id ='"+ul.getUserLoginId()+"'";
		}
		
		SqlStr = SqlStr + " and pcm.claimtype='CN' " +
				"and pct.typeaccount ='ExtCost' " +
				"and pcm.approvalDate <= '"+CurrDataTo+"'";
		SqlStr = SqlStr + " group by pcd.proj_Id";
		////////------------------------------------
		SqlStr = SqlStr + " union";
		SqlStr = SqlStr + " select ctc.ctc_proj_id as proj_id, 'CTC' as AmtType, 0 as TotalAmt,";

		SqlStr = SqlStr + " sum(case when ctc.ctc_fm_ver >= "+CurrFMId+" then ctc.ctc_amt else 0 end) as CurrAmt";
		SqlStr = SqlStr + " from Proj_CTC as ctc inner join proj_mstr as proj on (ctc.ctc_proj_id = proj.proj_id and proj.proj_category = 'C')"; 
		
		//  Down was edited by Jackey Ding 2005-03-09
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " inner join party as dep on proj.dep_id = dep.party_id";
			SqlStr = SqlStr + " where dep.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
			SqlStr = SqlStr + " where ul.user_login_id ='"+ul.getUserLoginId()+"'";
		}
		// Up was edited by Jackey Ding 2005-03-09
		
		SqlStr = SqlStr + " and ctc.ctc_fm_ver in ("+CurrFMId+") and ctc.ctc_type in ('PSC','Expense')";
		SqlStr = SqlStr + " group by ctc.ctc_proj_id";
		SqlStr = SqlStr + " ) as res on proj.proj_id = res.proj_id";
		SqlStr = SqlStr + " group by proj.proj_linknote, ul.user_login_id, ul.name, proj.proj_id, proj.proj_name, proj.total_service_value, proj.total_lics_value, proj.psc_budget, proj.exp_budget,proj.proc_budget, custp.description";
		if (detailflag) {
			SqlStr = SqlStr + " order by proj.proj_linknote, ul.user_login_id, ul.name, proj.proj_id, proj.proj_name, proj.total_service_value, proj.total_lics_value, proj.psc_budget, proj.exp_budget,proj.proc_budget, custp.description";
		} else {
			SqlStr = SqlStr + " ) as detres on proj.proj_id = left(detres.proj_linknote,CHARINDEX(':',detres.proj_linknote)-1)";
			SqlStr = SqlStr + " group by ul.user_login_id, ul.name, proj.proj_id, proj.proj_name, detres.c_name, proj.Proc_Budget";
		}
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		return sr;
	}
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,String CurrFMId, String CurrDataTo, String MonthDate,String LastDataTo,String departmentId,FMonth fMonth){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return (mapping.findForward("Export"));
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sr = findQueryResult(request,CurrFMId,CurrDataTo,LastDataTo,departmentId);
			if (sr== null || sr.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			//Header
			HSSFCellStyle DHStyle = sheet.getRow(0).getCell((short)7).getCellStyle();
			HSSFCell cell = sheet.getRow(0).getCell((short)7);
			cell.setCellValue(MonthDate);
			cell.setCellStyle(DHStyle);
			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle normalTextStyle = sheet.getRow(ListStartRow).getCell((short)1).getCellStyle();
			HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
			HSSFRow HRow = null;

			String OldPM = "";
			String NewPM = "";	
			//List
			int ExcelRow = ListStartRow;
			
			for (int row =0; row < sr.getRowCount(); row++) {
				HRow = sheet.createRow(ExcelRow);
				cell = HRow.createCell((short)0);			//Project Code
				cell.setCellStyle(boldTextStyle);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);	//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"proj_id"));
				
				cell = HRow.createCell((short)1);			//Project name
				cell.setCellStyle(boldTextStyle);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);	//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"proj_name"));
				
			//	NewPM = sr.getString(row,"user_login_id");
			//	if (!OldPM.equals(NewPM)) {
			//		OldPM = NewPM;
			//		NewPM = NewPM + ":" + sr.getString(row,"name");
			//		} 
			//	else {
			//		NewPM = "";
			//		}
				cell = HRow.createCell((short)2);			//Project manager
				cell.setCellStyle(boldTextStyle);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);	//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"name"));
				
				cell = HRow.createCell((short)3);			//Customer Information
				cell.setCellStyle(boldTextStyle);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);	//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"c_name"));
				
				double total_sales_value = sr.getDouble(row,"total_sales_value");
				double total_budget = sr.getDouble(row,"total_budget");
				double CurrCost = sr.getDouble(row,"CurrCost");
				double AllCost = sr.getDouble(row,"TotalCost");
				double CurrCTC = sr.getDouble(row,"CurrCTC");
				double Budget_Variance_Todate = AllCost - total_budget;
				double Budget_Variance_Toend = Budget_Variance_Todate + CurrCTC;
				double P_Comp = 0;
				if ((AllCost+CurrCTC) != 0) P_Comp = AllCost/(AllCost+CurrCTC)*100;
				double P_Forecast_OB = 0;
				if (total_budget != 0) P_Forecast_OB = Budget_Variance_Toend/total_budget*100;
				
				cell = HRow.createCell((short)4);			//Project Service Value
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(total_sales_value);
				
				cell = HRow.createCell((short)5);			//Total Budget
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(total_budget);
				
				cell = HRow.createCell((short)6);		//procu/sub budget
				//Total Costs This Month
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(sr.getDouble(row,"proc_budget"));
				
				cell = HRow.createCell((short)7);
				//Total Costs This Month
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(CurrCost);
				
				cell = HRow.createCell((short)8);		//procu/sub cost
				//Total Costs This Month
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(sr.getDouble(row,"SubCon_CurrCost"));
				
				cell = HRow.createCell((short)9);			//Total Costs To Date
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(AllCost);
				
				cell = HRow.createCell((short)10);			//Forecast to Completion
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(CurrCTC);
				
				cell = HRow.createCell((short)11);			//Budget Variance Todate
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(Budget_Variance_Todate);
				
				cell = HRow.createCell((short)12);			//% Completion
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(P_Comp);
				
				cell = HRow.createCell((short)13);			//Budget Variance To end of Project
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(Budget_Variance_Toend);
								
				cell = HRow.createCell((short)14);			//Forecasted % Over budget
				cell.setCellStyle(numberFormatStyle);
				cell.setCellValue(P_Forecast_OB);
				
				ExcelRow++;
			}
			
			//写入Excel工作表
			wb.write(response.getOutputStream());
			//关闭Excel工作薄对象
			response.getOutputStream().close();
			response.setStatus( HttpServletResponse.SC_OK );
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
		
	private final static String ExcelTemplate="ProjectvsBudget.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Project Status Report.xls";
	private final int ListStartRow = 5;
}