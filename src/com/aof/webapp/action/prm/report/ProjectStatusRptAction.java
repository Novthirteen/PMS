/*
 * Created on 2005-2-24
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
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
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ProjectStatusRptAction extends ReportBaseAction {
	
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	private Log log = LogFactory.getLog(ProjectStatusRptAction.class);
	
	private final static String ExcelTemplate="ProjectStatus.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Project Status by Project Manager.xls";
	private final int ListStartRow = 6;
	
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
			
			net.sf.hibernate.Session session = Hibernate2Session.currentSession();
			
			FMonthHelper fh = new FMonthHelper();
			FMonth fMonth = fh.findFiscalMonthByYearAndMonth(session, srcYR, srcM + 1);
			
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
			
			String departmentId = request.getParameter("departmentId");
			if (departmentId == null) departmentId = "";
			
			String action = request.getParameter("FormAction");
			if (action == null) action = "view";
			
			if (action.equals("QueryForList")) {
				sr = findQueryResult(request,CurrFMId,CurrDataTo,LastFMId,LastDataTo,departmentId);
				request.setAttribute("QryList",sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request,response,CurrFMId,CurrDataTo,LastFMId,LastDataTo,departmentId,fMonth,MonthDate);
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
	
	private SQLResults findQueryResult(HttpServletRequest request,
			                           String CurrFMId, 
									   String CurrDataTo, 
									   String LastFMId,
									   String LastDataTo,
									   String departmentId) throws Exception {
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
			SqlStr = SqlStr + "select ul.user_login_id, ul.name, proj.proj_id, proj.proj_name,detres.DESCRIPTION";
			SqlStr = SqlStr + " ,sum(detres.total_service_value) as total_service_value,sum(detres.total_lics_value) as total_lics_value,sum(detres.PSC_Budget) as PSC_Budget, sum(detres.EXP_Budget) as EXP_Budget, sum(detres.proc_budget) as proc_budget";
			SqlStr = SqlStr + " ,sum(detres.LastCost) as LastCost, sum(detres.LastCTC) as LastCTC,sum(detres.CurrCost) as CurrCost, sum(detres.CurrCTC) as CurrCTC";
			SqlStr = SqlStr + " from proj_mstr as proj inner join user_login as ul on proj.proj_pm_user = ul.user_login_id inner join (";
		}
		
		SqlStr = SqlStr + "select ul.user_login_id, ul.name, proj.proj_id, proj.proj_linknote, proj.proj_name, res.DESCRIPTION, proj.total_service_value, proj.total_lics_value, proj.PSC_Budget, proj.EXP_Budget, proj.proc_budget ";
		SqlStr = SqlStr + " ,sum(case when res.AmtType = 'Cost' then res.CurrAmt else 0 end) as CurrCost, sum(case when res.AmtType = 'Cost' then res.LastAmt else 0 end) as LastCost";
		SqlStr = SqlStr + " ,sum(case when res.AmtType = 'CTC' then res.CurrAmt else 0 end) as CurrCTC, sum(case when res.AmtType = 'CTC' then res.LastAmt else 0 end) as LastCTC";
		SqlStr = SqlStr + " from proj_mstr as proj inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";		
		SqlStr = SqlStr + " right join (select tsd.ts_proj_id as proj_id, party.DESCRIPTION,'Cost' as AmtType, sum(tsd.ts_hrs_user * tsd.ts_user_rate) as CurrAmt,";
		SqlStr = SqlStr + " sum(case when tsd.ts_date <= '"+LastDataTo+"' then tsd.ts_hrs_user * tsd.ts_user_rate else 0 end) as LastAmt";
		SqlStr = SqlStr + " from proj_ts_det as tsd inner join proj_mstr as proj on (tsd.ts_proj_id = proj.proj_id and proj.proj_category = 'C')";
		SqlStr = SqlStr + " inner join Party as party on party.party_id = proj.cust_id";
		
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
		SqlStr = SqlStr + " group by tsd.ts_proj_id, party.DESCRIPTION";
		SqlStr = SqlStr + " union";
		SqlStr = SqlStr + " select em.em_proj_id as proj_id, party.DESCRIPTION, 'Cost' as AmtType, sum(ea.ea_amt_user * em.em_Curr_Rate) as CurrAmt";
		SqlStr = SqlStr + " ,sum(case when em.em_approval_date <= '"+LastDataTo+"' then ea.ea_amt_user * em.em_Curr_Rate else 0 end) as LastAmt";
		SqlStr = SqlStr + " from Proj_Exp_Amt as ea inner join proj_exp_mstr as em on ea.em_id = em.em_id ";
		SqlStr = SqlStr + " inner join proj_mstr as proj on (em.em_proj_id = proj.proj_id and proj.proj_category = 'C')";
		SqlStr = SqlStr + " inner join Party as party on party.party_id = proj.cust_id";
		//  Down was edited by Jackey Ding 2005-03-09
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " inner join party as dep on proj.dep_id = dep.party_id";
			SqlStr = SqlStr + " where dep.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
			SqlStr = SqlStr + " where ul.user_login_id ='"+ul.getUserLoginId()+"'";
		}
		// Up was edited by Jackey Ding 2005-03-09
		SqlStr = SqlStr + " and em.em_claimtype='CN' and em.em_approval_date <= '"+CurrDataTo+"'";
		SqlStr = SqlStr + " group by em.em_proj_id, party.DESCRIPTION";
		SqlStr = SqlStr + " union";
		SqlStr = SqlStr + " select pcd.proj_Id as proj_id, party.DESCRIPTION, 'Cost' as AmtType, sum(pcd.percentage * pcm.totalvalue * pcm.exchangerate)/100 as CurrAmt";
		SqlStr = SqlStr + " ,sum(case when pcm.approvalDate <= '"+LastDataTo+"' then pcd.percentage * pcm.totalvalue * pcm.exchangerate else 0 end)/100 as LastAmt";
		SqlStr = SqlStr + " from proj_cost_det as pcd inner join proj_cost_mstr as pcm on pcd.costcode = pcm.costcode";
		//SqlStr = SqlStr + " inner join Proj_Cost_Type as pct on pct.typeid=pcm.type";
		SqlStr = SqlStr + " inner join proj_mstr as proj on (pcd.proj_Id = proj.proj_id and proj.proj_category = 'C')";
		SqlStr = SqlStr + " inner join Party as party on party.party_id = proj.cust_id";
		//  Down was edited by Jackey Ding 2005-03-09
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " inner join party as dep on proj.dep_id = dep.party_id";
			SqlStr = SqlStr + " where dep.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
			SqlStr = SqlStr + " where ul.user_login_id ='"+ul.getUserLoginId()+"'";
		}
		// Up was edited by Jackey Ding 2005-03-09
		SqlStr = SqlStr + " and pcm.claimtype='CN' " +
				//"and pct.typeaccount ='Expense' " +
				"and pcm.approvalDate <= '"+CurrDataTo+"'";
		SqlStr = SqlStr + " group by pcd.proj_Id, party.DESCRIPTION";
		SqlStr = SqlStr + " union";
		SqlStr = SqlStr + " select ctc.ctc_proj_id as proj_id, party.DESCRIPTION, 'CTC' as AmtType";
		SqlStr = SqlStr + " ,sum(case when ctc.ctc_fm_ver = "+CurrFMId+" then ctc.ctc_amt else 0 end) as CurrAmt";
		SqlStr = SqlStr + " ,sum(case when ctc.ctc_fm_ver = "+LastFMId+" then ctc.ctc_amt else 0 end) as LastAmt";
		SqlStr = SqlStr + " from Proj_CTC as ctc inner join proj_mstr as proj on (ctc.ctc_proj_id = proj.proj_id and proj.proj_category = 'C')"; 
		SqlStr = SqlStr + " inner join Party as party on party.party_id = proj.cust_id";
		//  Down was edited by Jackey Ding 2005-03-09
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " inner join party as dep on proj.dep_id = dep.party_id";
			SqlStr = SqlStr + " where dep.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
			SqlStr = SqlStr + " where ul.user_login_id ='"+ul.getUserLoginId()+"'";
		}
		// Up was edited by Jackey Ding 2005-03-09
		SqlStr = SqlStr + " and ctc.ctc_fm_ver in ("+CurrFMId+","+LastFMId+") and ctc.ctc_type in ('PSC','Expense')";
		SqlStr = SqlStr + " group by ctc.ctc_proj_id, party.DESCRIPTION";
		SqlStr = SqlStr + " ) as res on proj.proj_id = res.proj_id";
		SqlStr = SqlStr + " group by proj.proj_linknote, ul.user_login_id, ul.name, proj.proj_id, proj.proj_name, res.DESCRIPTION, proj.total_service_value, proj.total_lics_value, proj.PSC_Budget, proj.EXP_Budget, proj.proc_budget";
		if (detailflag) {
			SqlStr = SqlStr + " order by proj.proj_linknote, ul.user_login_id, ul.name, proj.proj_id, proj.proj_name, res.DESCRIPTION, proj.total_service_value, proj.total_lics_value, proj.PSC_Budget, proj.EXP_Budget, proj.proc_budget";
		} else {
			SqlStr = SqlStr + " ) as detres on proj.proj_id = left(detres.proj_linknote,CHARINDEX(':',detres.proj_linknote)-1)";
			SqlStr = SqlStr + " group by ul.user_login_id, ul.name, proj.proj_id, proj.proj_name, detres.DESCRIPTION";
			SqlStr = SqlStr + " order by ul.user_login_id, ul.name, proj.proj_id, proj.proj_name, detres.DESCRIPTION";
		}

		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		return sr;
	}
	
	private ActionForward ExportToExcel (ActionMapping mapping, 
			                             HttpServletRequest request, 
										 HttpServletResponse response,
										 String CurrFMId, 
										 String CurrDataTo, 
										 String LastFMId,
										 String LastDataTo,
										 String departmentId,
										 FMonth fMonth,
										 String MonthDate){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return (mapping.findForward("Export"));
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sr = findQueryResult(request,CurrFMId,CurrDataTo,LastFMId,LastDataTo,departmentId);
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
			HSSFCell cell = sheet.getRow(0).getCell((short)10);
			cell.setCellValue(MonthDate);
			
			HSSFCellStyle boldUnderLineTextStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle normalTextStyle = sheet.getRow(ListStartRow).getCell((short)1).getCellStyle();
			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short)2).getCellStyle();
			HSSFCellStyle normalNumberStyle = sheet.getRow(ListStartRow).getCell((short)3).getCellStyle();
			HSSFCellStyle boldNumberStyle = sheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
			HSSFCellStyle normalPercentStyle = sheet.getRow(ListStartRow).getCell((short)5).getCellStyle();
			HSSFCellStyle boldPercentStyle = sheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
			
			HSSFRow HRow = null;
			
			//Header
			cell = sheet.getRow(0).getCell((short)5);
			Calendar calendar = Calendar.getInstance();
			calendar.set(fMonth.getYear().intValue(), fMonth.getMonthSeq(), 1);
			cell.setCellValue((new SimpleDateFormat("MMM yyyy", Locale.ENGLISH)).format(calendar.getTime()));
			//net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			
			//List
			int ExcelRow = ListStartRow;
			
			String oldPMId = "";
			String newPMId = "";
			String projectMangerNm = "";
			String projectId = "";
			String projectNm = "";
			String customerNm = "";
			double totalSalesVal = 0;
			double serviceValue = 0;
			double budget = 0;
			double costLastMth = 0;
			double costCurr = 0;
			double compLastMth = 0;
			double compCurr = 0;
			double budgetVariance = 0;
			double budgetVariancePercent = 0;
			double profitPlan = 0;
			double profitPlanPercent = 0;
			double profitActual = 0;
			double profitActualPercent = 0;
			
			double sumTotalSalesVal = 0;
			double sumServiceValue = 0;
			double sumBudget = 0;
			double sumCostLastMth = 0;
			double sumCostCurr = 0;
			double sumLastCTC = 0;
			double sumCurrCTC = 0;
			
			double totalSumTotalSalesVal = 0;
			double totalSumServiceValue = 0;
			double totalSumBudget = 0;
			double totalSumCostLastMth = 0;
			double totalSumCostCurr = 0;
			double totalSumLastCTC = 0;
			double totalSumCurrCTC = 0;
			
			for (int row =0; row < sr.getRowCount(); row++) {
				
				newPMId = sr.getString(row, "user_login_id");
				projectMangerNm = sr.getString(row, "name");
				projectId = sr.getString(row, "proj_id");
				projectNm = sr.getString(row, "proj_name");
				customerNm = sr.getString(row, "DESCRIPTION");
				totalSalesVal = sr.getDouble(row, "total_service_value") + sr.getDouble(row, "total_lics_value");
				serviceValue = sr.getDouble(row, "total_service_value");
				budget = sr.getDouble(row, "PSC_Budget") + sr.getDouble(row, "EXP_Budget") + sr.getDouble(row, "proc_budget");
				costLastMth = sr.getDouble(row, "LastCost");
				costCurr = sr.getDouble(row, "CurrCost");										
				if (costLastMth + sr.getDouble(row, "LastCTC") != 0) {
					compLastMth = (costLastMth / (costLastMth + sr.getDouble(row, "LastCTC"))) * 100;
				} else {
					compLastMth = 0;
				}
				if (costCurr + sr.getDouble(row, "CurrCTC") != 0) {
					compCurr = (costCurr / (costCurr + sr.getDouble(row, "CurrCTC"))) * 100;
				} else {
					compCurr = 0;
				}
				budgetVariance = costCurr - budget;
				
				if (budget != 0) {
					budgetVariancePercent = (budgetVariance / budget) * 100;
				} else {
					budgetVariancePercent = 0;
				}
				profitPlan = totalSalesVal - budget;
				if (totalSalesVal != 0) {
					profitPlanPercent = (profitPlan / totalSalesVal) * 100;
				} else {
					profitPlanPercent = 0;
				}
				profitActual = totalSalesVal - costCurr;
				if (totalSalesVal != 0) {
					profitActualPercent = (profitActual / totalSalesVal) * 100;
				} else {
					profitActualPercent = 0;
				}
				
				if (!oldPMId.equals(newPMId)) {
					oldPMId = newPMId;
					
					if  (row != 0) {
						HRow = sheet.createRow(ExcelRow);
						
						cell = HRow.createCell((short)0);
						cell.setCellStyle(boldUnderLineTextStyle);	
						cell = HRow.createCell((short)1);
						cell.setCellStyle(boldUnderLineTextStyle);
						
						cell = HRow.createCell((short)2);
						cell.setCellStyle(boldTextStyle);
						cell.setCellValue("Sub Total:");
						
						cell = HRow.createCell((short)3);
						cell.setCellStyle(boldNumberStyle);
						cell.setCellValue(sumTotalSalesVal);
						
						cell = HRow.createCell((short)4);
						cell.setCellStyle(boldNumberStyle);
						cell.setCellValue(sumServiceValue);
						
						cell = HRow.createCell((short)5);
						cell.setCellStyle(boldNumberStyle);
						cell.setCellValue(sumBudget);
						
						cell = HRow.createCell((short)6);
						cell.setCellStyle(boldNumberStyle);
						cell.setCellValue(sumCostLastMth);
						
						cell = HRow.createCell((short)7);
						cell.setCellStyle(boldNumberStyle);
						cell.setCellValue(sumCostCurr);
						
						cell = HRow.createCell((short)8);
						cell.setCellStyle(boldPercentStyle);
						cell.setCellValue((sumCostLastMth + sumLastCTC) != 0 ?  (sumCostLastMth / (sumCostLastMth + sumLastCTC)) * 100 : 0);
												
						cell = HRow.createCell((short)9);
						cell.setCellStyle(boldPercentStyle);
						cell.setCellValue((sumCostCurr + sumCurrCTC) != 0 ?  (sumCostCurr / (sumCostCurr + sumCurrCTC)) * 100 : 0);
						
						cell = HRow.createCell((short)10);
						cell.setCellStyle(boldNumberStyle);
						cell.setCellValue(sumCostCurr - sumBudget);
						
						cell = HRow.createCell((short)11);
						cell.setCellStyle(boldPercentStyle);
						cell.setCellValue(sumBudget != 0 ?  ((sumCostCurr - sumBudget) / sumBudget) * 100 : 0);
						
						cell = HRow.createCell((short)12);
						cell.setCellStyle(boldNumberStyle);
						cell.setCellValue(sumTotalSalesVal - sumBudget);
						
						cell = HRow.createCell((short)13);
						cell.setCellStyle(boldPercentStyle);
						cell.setCellValue((sumTotalSalesVal - sumBudget) != 0 ? ((sumTotalSalesVal - sumBudget) / sumTotalSalesVal) * 100 : 0);
						
						cell = HRow.createCell((short)14);
						cell.setCellStyle(boldNumberStyle);
						cell.setCellValue(sumTotalSalesVal - sumCostCurr);
						
						cell = HRow.createCell((short)15);
						cell.setCellStyle(boldPercentStyle);
						cell.setCellValue((sumTotalSalesVal - sumCostCurr) != 0 ? ((sumTotalSalesVal - sumCostCurr) / sumTotalSalesVal) * 100 : 0);
						ExcelRow++;
					}
					
					sumTotalSalesVal = 0;
					sumServiceValue = 0;
					sumBudget = 0;
					sumCostLastMth = 0;
					sumCostCurr = 0;
					sumLastCTC = 0;
					sumCurrCTC = 0;
					
					HRow = sheet.createRow(ExcelRow);
					cell = HRow.createCell((short)0);
					cell.setCellStyle(boldUnderLineTextStyle);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(projectMangerNm);
					
					cell = HRow.createCell((short)1);
					cell.setCellStyle(normalTextStyle);
					
					cell = HRow.createCell((short)2);
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell((short)3);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)4);
					cell.setCellStyle(boldNumberStyle);
					
					cell = HRow.createCell((short)5);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)6);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)7);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)8);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)9);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)10);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)11);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)12);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)13);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)14);
					cell.setCellStyle(normalNumberStyle);
					
					cell = HRow.createCell((short)15);
					cell.setCellStyle(normalNumberStyle);
					ExcelRow++;
				}
				
				sumTotalSalesVal += totalSalesVal;
				sumServiceValue += serviceValue;
				sumBudget += budget;
				sumCostLastMth += costLastMth;
				sumCostCurr += costCurr;
				sumLastCTC += sr.getDouble(row, "LastCTC");
				sumCurrCTC += sr.getDouble(row, "CurrCTC");
				
				totalSumTotalSalesVal += totalSalesVal;
			    totalSumServiceValue += serviceValue;
			    totalSumBudget += budget;
			    totalSumCostLastMth += costLastMth;
			    totalSumCostCurr += costCurr;
			    totalSumLastCTC += sr.getDouble(row, "LastCTC");
			    totalSumCurrCTC += sr.getDouble(row, "CurrCTC");
			    
			    HRow = sheet.createRow(ExcelRow);
			    cell = HRow.createCell((short)0);
				cell.setCellStyle(normalTextStyle);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(projectId);
				
				cell = HRow.createCell((short)1);
				cell.setCellStyle(normalTextStyle);	
				cell.setCellValue(projectNm);
				
				cell = HRow.createCell((short)2);
				cell.setCellStyle(normalTextStyle);
				cell.setCellValue(customerNm);
				
				cell = HRow.createCell((short)3);
				cell.setCellStyle(normalNumberStyle);
				cell.setCellValue(totalSalesVal);
				
				cell = HRow.createCell((short)4);
				cell.setCellStyle(normalNumberStyle);
				cell.setCellValue(serviceValue);
				
				cell = HRow.createCell((short)5);
				cell.setCellStyle(normalNumberStyle);
				cell.setCellValue(budget);
				
				cell = HRow.createCell((short)6);
				cell.setCellStyle(normalNumberStyle);
				cell.setCellValue(costLastMth);
				
				cell = HRow.createCell((short)7);
				cell.setCellStyle(normalNumberStyle);
				cell.setCellValue(costCurr);
				
				cell = HRow.createCell((short)8);
				cell.setCellStyle(normalPercentStyle);
				cell.setCellValue(compLastMth);
				
				cell = HRow.createCell((short)9);
				cell.setCellStyle(normalPercentStyle);
				cell.setCellValue(compCurr);
				
				cell = HRow.createCell((short)10);
				cell.setCellStyle(normalNumberStyle);
				cell.setCellValue(budgetVariance);
				
				cell = HRow.createCell((short)11);
				cell.setCellStyle(normalPercentStyle);
				cell.setCellValue(budgetVariancePercent);
				
				cell = HRow.createCell((short)12);
				cell.setCellStyle(normalNumberStyle);
				cell.setCellValue(profitPlan);
				
				cell = HRow.createCell((short)13);
				cell.setCellStyle(normalPercentStyle);
				cell.setCellValue(profitPlanPercent);
				
				cell = HRow.createCell((short)14);
				cell.setCellStyle(normalNumberStyle);
				cell.setCellValue(profitActual);
				
				cell = HRow.createCell((short)15);
				cell.setCellStyle(normalPercentStyle);
				cell.setCellValue(profitActualPercent);
			    
				ExcelRow++;
			/*	
				HRow = sheet.createRow(ExcelRow);
				cell = HRow.createCell((short)0);
				cell.setCellStyle(normalTextStyle);
				
				
				cell = HRow.createCell((short)1);
				cell.setCellStyle(normalTextStyle);
				
				
				cell = HRow.createCell((short)2);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)3);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)4);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)5);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)6);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)7);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)8);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)9);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)10);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)11);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)12);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)13);
				cell.setCellStyle(normalNumberStyle);
				
				cell = HRow.createCell((short)14);
				cell.setCellStyle(normalNumberStyle);
			    
				ExcelRow++;
				*/
			}
			// last summary row
			HRow = sheet.createRow(ExcelRow);
			
			cell = HRow.createCell((short)0);
			cell.setCellStyle(boldUnderLineTextStyle);	
			cell = HRow.createCell((short)1);
			cell.setCellStyle(boldUnderLineTextStyle);
			
			cell = HRow.createCell((short)2);
			cell.setCellStyle(boldTextStyle);
			cell.setCellValue("Sub Total:");
			
			cell = HRow.createCell((short)3);
			cell.setCellStyle(boldNumberStyle);
			cell.setCellValue(sumTotalSalesVal);
			
			cell = HRow.createCell((short)4);
			cell.setCellStyle(boldNumberStyle);
			cell.setCellValue(sumServiceValue);
			
			cell = HRow.createCell((short)5);
			cell.setCellStyle(boldNumberStyle);
			cell.setCellValue(sumBudget);
			
			cell = HRow.createCell((short)6);
			cell.setCellStyle(boldNumberStyle);
			cell.setCellValue(sumCostLastMth);
			
			cell = HRow.createCell((short)7);
			cell.setCellStyle(boldNumberStyle);
			cell.setCellValue(sumCostCurr);
			
			cell = HRow.createCell((short)8);
			cell.setCellStyle(boldPercentStyle);
			cell.setCellValue((sumCostLastMth + sumLastCTC) != 0 ?  (sumCostLastMth / (sumCostLastMth + sumLastCTC)) * 100 : 0);
									
			cell = HRow.createCell((short)9);
			cell.setCellStyle(boldPercentStyle);
			cell.setCellValue((sumCostCurr + sumCurrCTC) != 0 ?  (sumCostCurr / (sumCostCurr + sumCurrCTC)) * 100 : 0);
			
			cell = HRow.createCell((short)10);
			cell.setCellStyle(boldNumberStyle);
			cell.setCellValue(sumCostCurr - sumBudget);
			
			cell = HRow.createCell((short)11);
			cell.setCellStyle(boldPercentStyle);
			cell.setCellValue(sumBudget != 0 ?  ((sumCostCurr - sumBudget) / sumBudget) * 100 : 0);
			
			cell = HRow.createCell((short)12);
			cell.setCellStyle(boldNumberStyle);
			cell.setCellValue(sumTotalSalesVal - sumBudget);
			
			cell = HRow.createCell((short)13);
			cell.setCellStyle(boldPercentStyle);
			cell.setCellValue((sumTotalSalesVal - sumBudget) != 0 ? ((sumTotalSalesVal - sumBudget) / sumTotalSalesVal) * 100 : 0);
			
			cell = HRow.createCell((short)14);
			cell.setCellStyle(boldNumberStyle);
			cell.setCellValue(sumTotalSalesVal - sumCostCurr);
			
			cell = HRow.createCell((short)15);
			cell.setCellStyle(boldPercentStyle);
			cell.setCellValue((sumTotalSalesVal - sumCostCurr) != 0 ? ((sumTotalSalesVal - sumCostCurr) / sumTotalSalesVal) * 100 : 0);
			
			ExcelRow++;
			
			HRow = sheet.createRow(ExcelRow);
			
			cell = HRow.createCell((short)0);
			cell.setCellStyle(boldTextStyle);	
			cell = HRow.createCell((short)1);
			cell.setCellStyle(boldTextStyle);
			
			cell = HRow.createCell((short)2);
			cell.setCellStyle(boldTextStyle);
			cell.setCellValue("Grand Total:");
			
			cell = HRow.createCell((short)3);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(totalSumTotalSalesVal);
			
			cell = HRow.createCell((short)4);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(totalSumServiceValue);
			
			cell = HRow.createCell((short)5);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(totalSumBudget);
			
			cell = HRow.createCell((short)6);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(totalSumCostLastMth);
			
			cell = HRow.createCell((short)7);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(totalSumCostCurr);
			
			cell = HRow.createCell((short)8);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue((totalSumCostLastMth + totalSumLastCTC) != 0 ?  (totalSumCostLastMth / (totalSumCostLastMth + totalSumLastCTC)) * 100 : 0);
									
			cell = HRow.createCell((short)9);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue((totalSumCostCurr + totalSumCurrCTC) != 0 ?  (totalSumCostCurr / (totalSumCostCurr + totalSumCurrCTC)) * 100 : 0);
			
			cell = HRow.createCell((short)10);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(totalSumCostCurr - totalSumBudget);
			
			cell = HRow.createCell((short)11);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(totalSumBudget != 0 ?  ((totalSumCostCurr - totalSumBudget) / totalSumBudget) * 100 : 0);
			
			cell = HRow.createCell((short)12);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(totalSumTotalSalesVal - totalSumBudget);
			
			cell = HRow.createCell((short)13);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue((totalSumTotalSalesVal - totalSumBudget) != 0 ? ((totalSumTotalSalesVal - totalSumBudget) / totalSumTotalSalesVal) * 100 : 0);
			
			cell = HRow.createCell((short)14);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(totalSumTotalSalesVal - totalSumCostCurr);
			
			cell = HRow.createCell((short)15);
			cell.setCellStyle(boldNumberStyle);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue((totalSumTotalSalesVal - totalSumCostCurr) != 0 ? ((totalSumTotalSalesVal - totalSumCostCurr) / totalSumTotalSalesVal) * 100 : 0);
			
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
}
