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
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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
import com.aof.component.prm.report.ProjectCost;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.form.prm.report.ProjectCostForm;

/**
 * @author Jackey Ding
 *
 * @version 2005-02-08
 */

public class ProjectCostRptAction extends ReportBaseAction {
	
	public ActionForward execute (ActionMapping mapping,
	                              ActionForm form,
	                              HttpServletRequest request,
	                              HttpServletResponse response) {
			ActionErrors errors = this.getActionErrors(request.getSession());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();
		
			
		try {
			ProjectCostForm projCostFm = (ProjectCostForm)form;
			
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			String nowDateString = Date_formater.format((java.util.Date)UtilDateTime.nowTimestamp());
			
			String SqlStr = "";
			SQLResults sr = null;
			SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
			
			String SrcYear = projCostFm.getSrcYear();
			String SrcMonth = projCostFm.getSrcMonth();
			int srcYR = 0;
			int srcM = 0;
			String CurrFMId = "";
			String CurrDataTo = "";
			
			if (SrcYear == null || SrcMonth == null) {
				SqlStr = "select max(f_fm_cd) from FMonth where f_fmdate_to < '" +nowDateString+"'";
				sr = sqlExec.runQuery(SqlStr);
				CurrFMId = sr.getString(0,0);
				SqlStr = "select * from FMonth where f_fm_cd = " +CurrFMId;
				sr = sqlExec.runQuery(SqlStr);
				srcYR = sr.getInt(0,"f_yr");
				srcM = sr.getInt(0,"f_fmseq");
				CurrDataTo = Date_formater.format(sr.getDate(0,"f_fmdate_to"));
			} else {
				srcYR = new Integer(SrcYear).intValue();
				srcM = new Integer(SrcMonth).intValue();
				SqlStr = "select * from FMonth where f_yr = " +SrcYear + " and f_fmseq = "+SrcMonth;
				sr = sqlExec.runQuery(SqlStr);
				CurrFMId = sr.getString(0,"f_fm_cd");
				CurrDataTo = Date_formater.format(sr.getDate(0,"f_fmdate_to"));
			}
			
			sqlExec.closeConnection();
			
			projCostFm.setSrcYear(new Integer(srcYR).toString());
			projCostFm.setSrcMonth(new Integer(srcM).toString());
			
			request.setAttribute("SrcYear",new Integer(srcYR).toString());
			request.setAttribute("SrcMonth",new Integer(srcM).toString());
			
			if ("QueryForList".equals(projCostFm.getFormAction())) {
				List list = findQueryResult(request, projCostFm);
				request.setAttribute("QryList",list);
				return (mapping.findForward("success"));
			}
			if ("ExportToExcel".equals(projCostFm.getFormAction())) {
				return ExportToExcel(mapping, request, response, projCostFm);
			}
	
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
		
	private List findQueryResult(HttpServletRequest request,
	                             ProjectCostForm form) throws Exception {  
		
		List projList = null;
		
		try {
			SQLExecutor sqlExec = new SQLExecutor(
					Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
			
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			
			net.sf.hibernate.Session session = Hibernate2Session.currentSession();
			
			//get Project List String
			PartyHelper ph = new PartyHelper();
			StringBuffer partyListStr = null;
			if (form.getDepartmentId() != null && !form.getDepartmentId().trim().equals("")) {
				List partyList_dep = ph.getAllSubPartysByPartyId(session, form.getDepartmentId());
				Iterator itdep = partyList_dep.iterator();
				partyListStr = new StringBuffer("'"+form.getDepartmentId()+"'");
				while (itdep.hasNext()) {
					Party p =(Party)itdep.next();
					partyListStr.append(", '"+p.getPartyId()+"'");
				}
			}
			
			//find fiscal month
			int year = Integer.parseInt(form.getSrcYear());
			int month = Integer.parseInt(form.getSrcMonth()) + 1;
			FMonthHelper fh = new FMonthHelper();
			FMonth fMonth = fh.findFiscalMonthByYearAndMonth(session, year, month);			
			
			//process common condition
			List commonList = proecssCommonCondition(form, partyListStr != null ? partyListStr.toString() : null, ul);
		
			//Select Statement
			StringBuffer selectStatement = new StringBuffer("");

			if (!(form.getDetailFlg() != null 
					&& form.getDetailFlg().equals("Y"))) {
				selectStatement.append("select proj.proj_id AS ProjCode,");
				selectStatement.append("       proj.proj_name AS ProjName,");
				selectStatement.append("       proj.start_date AS ProjectStartDate,");
				selectStatement.append("       proj.end_date AS OrigCompDate,");
				selectStatement.append("       SUM(detres.ServiceSalesValue) AS ServiceSalesValue,");
				selectStatement.append("       SUM(detres.LicenceSalesValue) AS LicenceSalesValue,");
				selectStatement.append("       SUM(detres.DaysBudget) AS DaysBudget,");
				selectStatement.append("       SUM(detres.DaysThisMonth) AS DaysThisMonth,");
				selectStatement.append("       SUM(detres.DaysTodate) AS DaysTodate,");
				selectStatement.append("       SUM(detres.PSCBudget) AS PSCBudget,");
				selectStatement.append("       SUM(detres.PSCThisMonth) AS PSCThisMonth,");
				selectStatement.append("       SUM(detres.PSCTodate) AS PSCTodate,");
				selectStatement.append("       SUM(detres.ExpsBudget) AS ExpsBudget,");
				selectStatement.append("       SUM(detres.ExpsThisMonth) AS ExpsThisMonth,");
				selectStatement.append("       SUM(detres.ExpsTodate) AS ExpsTodate,");
				selectStatement.append("       SUM(detres.CostThisMonth) AS CostThisMonth,");
				selectStatement.append("       SUM(detres.TotalCostTodate) AS TotalCostTodate,");
				selectStatement.append("       SUM(detres.TotalBudget) AS TotalBudget,");
				selectStatement.append("       SUM(detres.PSCForecast) AS PSCForecast,");
				selectStatement.append("       SUM(detres.ExpsForecast) AS ExpsForecast,");
				selectStatement.append("       SUM(detres.ForecasttoComp) AS ForecasttoComp ");
				selectStatement.append(" From proj_mstr AS proj INNER JOIN (");
			}
			
			selectStatement.append("SELECT PM.proj_id AS ProjCode,");
			selectStatement.append("       PM.proj_linknote AS ProjLinknote,");
			selectStatement.append("       PM.proj_name AS ProjName,");
			selectStatement.append("       PM.start_date AS ProjectStartDate,");
			selectStatement.append("       PM.end_date AS OrigCompDate,");
			selectStatement.append("       PM.total_service_value AS ServiceSalesValue,");
			selectStatement.append("       PM.total_lics_value AS LicenceSalesValue,");
			selectStatement.append("       SUM(DaysBudget) AS DaysBudget,");
			selectStatement.append("       SUM(DaysThisMonth) AS DaysThisMonth,");
			selectStatement.append("       SUM(DaysTodate) AS DaysTodate,");			
			selectStatement.append("       PM.PSC_Budget AS PSCBudget,");
			selectStatement.append("       SUM(PSCThisMonth) AS PSCThisMonth,");
			selectStatement.append("       SUM(PSCTodate) AS PSCTodate,");
			selectStatement.append("       PM.EXP_Budget AS ExpsBudget,");
			selectStatement.append("       SUM(ExpsThisMonth) AS ExpsThisMonth,");
			selectStatement.append("       SUM(ExpsTodate) AS ExpsTodate,");
			selectStatement.append("       (SUM(PSCThisMonth) + SUM(ExpsThisMonth)) AS CostThisMonth,");
			selectStatement.append("       (SUM(PSCTodate) + SUM(ExpsTodate)) AS TotalCostTodate,");
			selectStatement.append("       (ISNULL(PM.PSC_Budget, 0) + ISNULL(PM.EXP_Budget, 0) + ISNULL(PM.Proc_Budget, 0)) AS TotalBudget, ");
			selectStatement.append("       SUM(PSCForecast) AS PSCForecast,");
			selectStatement.append("       SUM(ExpsForecast) AS ExpsForecast,");
			selectStatement.append("       SUM(PSCForecast + ExpsForecast) AS ForecasttoComp ");
			selectStatement.append("  FROM Proj_Mstr AS PM RIGHT JOIN (" + accessProjServiceTypeStr(sqlExec, commonList));
			selectStatement.append("                                    UNION " + accessProjTSDetStr(sqlExec, fMonth, commonList));
			selectStatement.append("                                    UNION " + accessProjExpMstrStr(sqlExec, fMonth, commonList));
			selectStatement.append("                                    UNION " + accessProjCostDetStr(sqlExec, fMonth, commonList));
			selectStatement.append("                                    UNION " + accessProjCTCStr(sqlExec, fMonth, commonList));
			selectStatement.append("                                   ) AS A ON A.ProjCode = PM.proj_id ");
			
			
			//Where Statement
			StringBuffer whereStatement = new StringBuffer("");
			/*
			whereStatement.append(" WHERE '1' = '1' ");
			
			//Add Common Select Statement
			StringBuffer commonSelect = (StringBuffer)commonList.get(0);
			if (commonSelect != null) {
				selectStatement.append(commonSelect.toString());
			}
			
			//Add Common Where Statement
			StringBuffer commonWhere = (StringBuffer)commonList.get(1);
			if (commonWhere != null) {
				whereStatement.append(commonWhere.toString());
			}
			
			//Add Common Parameters
			List commonParams = (List)commonList.get(2);
			if (commonParams != null) {
				for (int i0 = 0; i0 < commonParams.size(); i0++) {
					sqlExec.addParam(commonParams.get(i0));
				}
			}
			*/
			
			whereStatement.append(" GROUP BY PM.proj_linknote, "); 
			whereStatement.append("          PM.proj_id, ");
			whereStatement.append("          PM.proj_name, ");     
			whereStatement.append("          PM.start_date, ");       
			whereStatement.append("          PM.end_date, ");       
			whereStatement.append("          PM.total_service_value, ");       
			whereStatement.append("          PM.total_lics_value, ");
			whereStatement.append("          PM.PSC_Budget, ");
			whereStatement.append("          PM.EXP_Budget, ");
			whereStatement.append("          PM.Proc_Budget ");
			
			if (form.getDetailFlg() != null 
					&& form.getDetailFlg().equals("Y")) {
				whereStatement.append(" ORDER BY PM.proj_linknote, "); 
				whereStatement.append("          PM.proj_id, ");
				whereStatement.append("          PM.proj_name, ");     
				whereStatement.append("          PM.start_date, ");       
				whereStatement.append("          PM.end_date, ");       
				whereStatement.append("          PM.total_service_value, ");       
				whereStatement.append("          PM.total_lics_value, ");
				whereStatement.append("          PM.PSC_Budget, ");
				whereStatement.append("          PM.EXP_Budget, ");
				whereStatement.append("          PM.Proc_Budget ");
			} else {
				whereStatement.append(") AS detres ON proj.proj_id = LEFT(detres.ProjLinknote,CHARINDEX(':',detres.ProjLinknote)-1)");
				whereStatement.append(" GROUP BY proj.proj_id, proj.proj_name, proj.start_date, proj.end_date");
				whereStatement.append(" ORDER BY proj.proj_id, proj.proj_name, proj.start_date, proj.end_date");
			}
			
			log.info("findQueryResult SQL------>" + selectStatement.toString() + whereStatement.toString());
			
			SQLResults sr = sqlExec.runQueryCloseCon(selectStatement.toString() + whereStatement.toString());
			
			if (sr != null) {
				projList = new ArrayList();
				for (int i0 = 0; i0 < sr.getRowCount(); i0++) {
					
					ProjectCost projectCost = new ProjectCost();
					
					projectCost.setProjCode(sr.getString(i0, "ProjCode"));
					projectCost.setProjName(sr.getString(i0, "ProjName"));			
					projectCost.setProjectStartDate(sr.getDate(i0, "ProjectStartDate"));
					projectCost.setOrigCompDate(sr.getDate(i0, "OrigCompDate"));
					projectCost.setServiceSalesValue(sr.getDouble(i0, "ServiceSalesValue"));
					projectCost.setLicenceSalesValue(sr.getDouble(i0, "LicenceSalesValue"));
					projectCost.setDaysBudget(sr.getDouble(i0, "DaysBudget"));
					projectCost.setDaysThisMonth(sr.getDouble(i0, "DaysThisMonth"));
					projectCost.setDaysTodate(sr.getDouble(i0, "DaysTodate"));
					projectCost.setPSCBudget(sr.getDouble(i0, "PSCBudget"));
					projectCost.setPSCThisMonth(sr.getDouble(i0, "PSCThisMonth"));
					projectCost.setPSCTodate(sr.getDouble(i0, "PSCTodate"));
					projectCost.setExpsBudget(sr.getDouble(i0, "ExpsBudget"));
					projectCost.setExpsThisMonth(sr.getDouble(i0, "ExpsThisMonth"));
					projectCost.setExpsTodate(sr.getDouble(i0, "ExpsTodate"));
					projectCost.setCostThisMonth(sr.getDouble(i0, "CostThisMonth"));
					projectCost.setTotalCostTodate(sr.getDouble(i0, "TotalCostTodate"));
					projectCost.setTotalBudget(sr.getDouble(i0, "TotalBudget"));
					projectCost.setPSCForecast(sr.getDouble(i0, "PSCForecast"));
					projectCost.setExpsForecast(sr.getDouble(i0, "ExpsForecast"));
					projectCost.setForecasttoComp(sr.getDouble(i0, "ForecasttoComp"));
					
					projList.add(projectCost);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
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
			
		return projList;
	}
	
	//return element 0 selectStatement StringBuffer
	//       element 1 whereStatement StringBuffer
	//       element 2 params List
	private List proecssCommonCondition(ProjectCostForm form,
									    String partyListStr,
									    UserLogin ul) {
		List commonList = new ArrayList();
		
		StringBuffer selectStatement = new StringBuffer("");
		StringBuffer whereStatement = new StringBuffer("");
		List params = new ArrayList();
		    
		//add condition project
		if (form.getProject() != null && form.getProject().trim().length() != 0) {
			whereStatement.append(" AND (PM.proj_id like ? OR PM.proj_name like ?) ");
			params.add("%" + form.getProject() + "%");
			params.add("%" + form.getProject() + "%");
		}
		
		//add condition customer
		if (form.getCustomer() != null && form.getCustomer().trim().length() != 0) {
			selectStatement.append(" INNER JOIN party AS CUST ON PM.cust_id = CUST.party_id ");
			whereStatement.append(" AND (PM.cust_id like ? OR CUST.DESCRIPTION like ?) ");
			params.add("%" + form.getCustomer() + "%");
			params.add("%" + form.getCustomer() + "%");
		}
		
		//add condition projectManager
		if (form.getProjectManager() != null && form.getProjectManager().trim().length() != 0) {
			selectStatement.append(" INNER JOIN USER_LOGIN UL ON PM.proj_pm_user = UL.USER_LOGIN_ID ");
			whereStatement.append(" AND (PM.proj_pm_user like ? OR UL.NAME like ?) ");
			params.add("%" + form.getProjectManager() + "%");
			params.add("%" + form.getProjectManager() + "%");
		}
		
		//add condition departmentId
		if (form.getDepartmentId() != null && form.getDepartmentId().trim().length() != 0) {
			selectStatement.append(" INNER JOIN party AS DEP ON PM.dep_id = DEP.party_id ");
			whereStatement.append(" AND DEP.party_id in (" + partyListStr + ") ");
		} else {
			selectStatement.append(" INNER JOIN USER_LOGIN as DEP on PM.proj_pm_user = DEP.user_login_id ");
			whereStatement.append(" AND DEP.user_login_id = ? ");
			params.add(ul.getUserLoginId());
		}
		
		log.info("commonSelect SQL------>" + selectStatement.toString());
		log.info("commonwhere SQL------>" + whereStatement.toString());
		
		commonList.add(selectStatement);
		commonList.add(whereStatement);
		commonList.add(params);
		
		return commonList;
	}
	
	private String accessProjServiceTypeStr(SQLExecutor sqlExec, List commonList) {
		
		//Select Statement
		StringBuffer selectStatement = new StringBuffer("");
		selectStatement.append("SELECT PM.proj_id AS ProjCode,");        
		selectStatement.append("       SUM(PST.ST_EstDays) AS DaysBudget,");       
		selectStatement.append("       0 AS DaysThisMonth,");
		selectStatement.append("       0 AS DaysTodate,");
		selectStatement.append("       0 AS PSCThisMonth,");
		selectStatement.append("       0 AS PSCTodate,");
		selectStatement.append("       0 AS ExpsThisMonth,");
		selectStatement.append("       0 AS ExpsTodate,");
		selectStatement.append("       0 AS PSCForecast,");
		selectStatement.append("       0 AS ExpsForecast,");
		selectStatement.append("       0 AS ForecasttoComp");
		selectStatement.append("  FROM Proj_Mstr AS PM INNER JOIN Proj_ServiceType AS PST ON PM.proj_id = PST.ST_Proj_Id");    
		
		//Where Statement
		StringBuffer whereStatement = new StringBuffer("");
		whereStatement.append(" WHERE '1' = '1' ");
		
		//Add Common Select Statement
		StringBuffer commonSelect = (StringBuffer)commonList.get(0);
		if (commonSelect != null) {
			selectStatement.append(commonSelect.toString());
		}
		
		//Add Common Where Statement
		StringBuffer commonWhere = (StringBuffer)commonList.get(1);
		if (commonWhere != null) {
			whereStatement.append(commonWhere.toString());
		}
		
		//Add Common Parameters
		List commonParams = (List)commonList.get(2);
		if (commonParams != null) {
			for (int i0 = 0; i0 < commonParams.size(); i0++) {
				sqlExec.addParam(commonParams.get(i0));
			}
		}
		
		whereStatement.append(" GROUP BY PM.proj_id ");
		
		log.info("Proj_ServiceType SQL------>" + selectStatement.toString() + whereStatement.toString());
		
		return selectStatement.toString() + whereStatement.toString();
	}
	
	private String accessProjTSDetStr(SQLExecutor sqlExec, FMonth fMonth, List commonList) {
 
		//Select Statement
		StringBuffer selectStatement = new StringBuffer("");
		selectStatement.append("SELECT PM.proj_id AS ProjCode, ");        
		selectStatement.append("       0 AS DaysBudget, ");       
		selectStatement.append("       SUM(CASE WHEN (PTSD.ts_date BETWEEN ? AND ?) THEN PTSD.ts_hrs_user ELSE 0 END)/8 AS DaysThisMonth, ");
		selectStatement.append("       SUM(CASE WHEN PTSD.ts_date <= ? THEN PTSD.ts_hrs_user ELSE 0 END)/8 AS DaysTodate, ");
		selectStatement.append("       SUM(CASE WHEN (PTSD.ts_date BETWEEN ? AND ?) THEN (PTSD.ts_hrs_user * PTSD.ts_user_rate) ELSE 0 END) AS PSCThisMonth, ");
		selectStatement.append("       SUM(CASE WHEN PTSD.ts_date <= ? THEN (PTSD.ts_hrs_user * PTSD.ts_user_rate) ELSE 0 END) AS PSCTodate, ");                                           
		selectStatement.append("       0 AS ExpsThisMonth, ");
		selectStatement.append("       0 AS ExpsTodate, ");
		selectStatement.append("       0 AS PSCForecast, ");
		selectStatement.append("       0 AS ExpsForecast, ");
		selectStatement.append("       0 AS ForecasttoComp ");
		selectStatement.append("  FROM Proj_Mstr AS PM INNER JOIN Proj_TS_Det AS PTSD ON PM.proj_id = PTSD.ts_proj_id ");
		selectStatement.append("                       INNER JOIN Proj_TS_Mstr as PTSM on PTSD.tsm_id = PTSM.tsm_id ");
		selectStatement.append("                       INNER JOIN user_login as user_login on (PTSM.tsm_userlogin = user_login.user_login_id and user_login.note <>'EXT')" );
		
		//Where Statement
		StringBuffer whereStatement = new StringBuffer("");
		whereStatement.append(" WHERE PTSD.ts_status = 'Approved' ");
		
		//Add Parameterss
		sqlExec.addParam(fMonth.getDateFrom());
		sqlExec.addParam(fMonth.getDateTo());
		sqlExec.addParam(fMonth.getDateTo());
		sqlExec.addParam(fMonth.getDateFrom());
		sqlExec.addParam(fMonth.getDateTo());
		sqlExec.addParam(fMonth.getDateTo());
		
		//Add Common Select Statement
		StringBuffer commonSelect = (StringBuffer)commonList.get(0);
		if (commonSelect != null) {
			selectStatement.append(commonSelect.toString());
		}
		
		//Add Common Where Statement
		StringBuffer commonWhere = (StringBuffer)commonList.get(1);
		if (commonWhere != null) {
			whereStatement.append(commonWhere.toString());
		}
		
		//Add Common Parameters
		List commonParams = (List)commonList.get(2);
		if (commonParams != null) {
			for (int i0 = 0; i0 < commonParams.size(); i0++) {
				sqlExec.addParam(commonParams.get(i0));
			}
		}

		whereStatement.append(" GROUP BY PM.proj_id ");
		
		log.info("Proj_TS_Det SQL------>" + selectStatement.toString() + whereStatement.toString());
		
		return selectStatement.toString() + whereStatement.toString();
	}
	
	private String accessProjExpMstrStr(SQLExecutor sqlExec, FMonth fMonth, List commonList) {
			
		//Select Statement
		StringBuffer selectStatement = new StringBuffer("");
		selectStatement.append("SELECT PEM.em_proj_id AS ProjCode, "); 
		selectStatement.append("       0 AS DaysBudget, ");       
		selectStatement.append("       0 AS DaysThisMonth, ");
		selectStatement.append("       0 AS DaysTodate, ");
		selectStatement.append("       0 AS PSCThisMonth, ");
		selectStatement.append("       0 AS PSCTodate, ");       
		selectStatement.append("       SUM(CASE WHEN (PEM.em_approval_date BETWEEN ? AND ?) THEN (PED.ed_amt_user * PEM.em_Curr_Rate) ELSE 0 END) AS ExpsThisMonth, ");
		selectStatement.append("       SUM(CASE WHEN PEM.em_approval_date <= ? THEN (PED.ed_amt_user * PEM.em_Curr_Rate) ELSE 0 END) AS ExpsTodate, ");  
		selectStatement.append("       0 AS PSCForecast, ");
		selectStatement.append("       0 AS ExpsForecast, ");
		selectStatement.append("       0 AS ForecasttoComp ");
		selectStatement.append("       FROM Proj_Exp_Mstr AS PEM INNER JOIN Proj_Mstr AS PM ON PEM.em_proj_id = PM.proj_id ");                            
		selectStatement.append("                                 INNER JOIN Proj_Exp_Det PED ON PEM.em_id = PED.em_id ");
		
		//Where Statement
		StringBuffer whereStatement = new StringBuffer("");
		whereStatement.append(" WHERE PEM.em_claimtype = 'CN' ");
		
		//Add Parameters
		sqlExec.addParam(fMonth.getDateFrom());
		sqlExec.addParam(fMonth.getDateTo());
		sqlExec.addParam(fMonth.getDateTo());
		
		//Add Common Select Statement
		StringBuffer commonSelect = (StringBuffer)commonList.get(0);
		if (commonSelect != null) {
			selectStatement.append(commonSelect.toString());
		}
		
		//Add Common Where Statement
		StringBuffer commonWhere = (StringBuffer)commonList.get(1);
		if (commonWhere != null) {
			whereStatement.append(commonWhere.toString());
		}
		
		//Add Common Parameters
		List commonParams = (List)commonList.get(2);
		if (commonParams != null) {
			for (int i0 = 0; i0 < commonParams.size(); i0++) {
				sqlExec.addParam(commonParams.get(i0));
			}
		}
		
		whereStatement.append(" GROUP BY PEM.em_proj_id ");
		
		log.info("Proj_Exp_Mstr SQL------>" + selectStatement.toString() + whereStatement.toString());
		
		return selectStatement.toString() + whereStatement.toString();
	}
	
	private String accessProjCostDetStr(SQLExecutor sqlExec, FMonth fMonth, List commonList) {
		
		//Select Statement
		StringBuffer selectStatement = new StringBuffer("");
		selectStatement.append("SELECT PCD.proj_id AS ProjCode, ");
		selectStatement.append("       0 AS DaysBudget, ");        
		selectStatement.append("       0 AS DaysThisMonth, ");
		selectStatement.append("       0 AS DaysTodate, ");
		selectStatement.append("       0 AS PSCThisMonth, ");
		selectStatement.append("       0 AS PSCTodate, ");        
		selectStatement.append("       SUM(CASE WHEN (PCM.costdate BETWEEN ? AND ?) THEN (PCM.totalvalue * PCM.exchangerate * PCD.percentage) ELSE 0 END)/100 AS ExpsThisMonth, ");  
		selectStatement.append("       SUM(CASE WHEN PCM.costdate <= ? THEN (PCM.totalvalue * PCM.exchangerate * PCD.percentage) ELSE 0 END)/100 AS ExpsTodate, ");  
		selectStatement.append("       0 AS PSCForecast, ");
		selectStatement.append("       0 AS ExpsForecast, ");
		selectStatement.append("       0 AS ForecasttoComp ");
		selectStatement.append("  FROM Proj_Cost_Det AS PCD INNER JOIN Proj_Mstr AS PM ON PCD.proj_id = PM.proj_id ");                            
		selectStatement.append("                            INNER JOIN Proj_Cost_Mstr AS PCM ON PCM.costcode = PCD.costCode ");                             
		//selectStatement.append("                            INNER JOIN Proj_Cost_type AS PCT ON PCM.type = PCT.typeid ");
		
		//Where Statement
		StringBuffer whereStatement = new StringBuffer("");
		whereStatement.append(" WHERE PCM.claimtype = 'CN' ");
		
		//Add Parameters
		sqlExec.addParam(fMonth.getDateFrom());
		sqlExec.addParam(fMonth.getDateTo());
		sqlExec.addParam(fMonth.getDateTo());
		
		//Add Common Select Statement
		StringBuffer commonSelect = (StringBuffer)commonList.get(0);
		if (commonSelect != null) {
			selectStatement.append(commonSelect.toString());
		}
		
		//Add Common Where Statement
		StringBuffer commonWhere = (StringBuffer)commonList.get(1);
		if (commonWhere != null) {
			whereStatement.append(commonWhere.toString());
		}
		
		//Add Common Parameters
		List commonParams = (List)commonList.get(2);
		if (commonParams != null) {
			for (int i0 = 0; i0 < commonParams.size(); i0++) {
				sqlExec.addParam(commonParams.get(i0));
			}
		}
		
		whereStatement.append(" GROUP BY PCD.proj_id ");
		
		log.info("Proj_Cost_Det SQL------>" + selectStatement.toString() + whereStatement.toString());
		
		return selectStatement.toString() + whereStatement.toString();
	}
	
	private String accessProjCTCStr(SQLExecutor sqlExec, FMonth fMonth, List commonList) {
		
		//Select Statement
		StringBuffer selectStatement = new StringBuffer("");
		selectStatement.append("SELECT PCTC.ctc_proj_id AS ProjCode, ");
		selectStatement.append("       0 AS DaysBudget, ");        
		selectStatement.append("       0 AS DaysThisMonth, ");
		selectStatement.append("       0 AS DaysTodate, ");
		selectStatement.append("       0 AS PSCThisMonth, ");
		selectStatement.append("       0 AS PSCTodate, ");   
		selectStatement.append("       0 AS ExpsThisMonth, ");
		selectStatement.append("       0 AS ExpsTodate, ");        
		selectStatement.append("       SUM(case when PCTC.ctc_type = 'PSC' then PCTC.ctc_amt else 0 end) AS PSCForecast, ");
		selectStatement.append("       SUM(case when PCTC.ctc_type = 'Expense' then PCTC.ctc_amt else 0 end) AS ExpsForecast, ");
		selectStatement.append("       0 AS ForecasttoComp ");
		selectStatement.append("  FROM Proj_CTC AS PCTC INNER JOIN Proj_Mstr AS PM ON PCTC.ctc_proj_id = PM.proj_id ");
		
		//Where Statement
		StringBuffer whereStatement = new StringBuffer("");
		whereStatement.append(" WHERE PCTC.ctc_fm_ver = " + fMonth.getId() + " ");
		
		//Add Common Select Statement
		StringBuffer commonSelect = (StringBuffer)commonList.get(0);
		if (commonSelect != null) {
			selectStatement.append(commonSelect.toString());
		}
		
		//Add Common Where Statement
		StringBuffer commonWhere = (StringBuffer)commonList.get(1);
		if (commonWhere != null) {
			whereStatement.append(commonWhere.toString());
		}
		
		//Add Common Parameters
		List commonParams = (List)commonList.get(2);
		if (commonParams != null) {
			for (int i0 = 0; i0 < commonParams.size(); i0++) {
				sqlExec.addParam(commonParams.get(i0));
			}
		}
		
		whereStatement.append(" GROUP BY PCTC.ctc_proj_id ");
		                         
		log.info("Proj_CTC SQL------>" + selectStatement.toString() + whereStatement.toString());
		
		return selectStatement.toString() + whereStatement.toString();
	}

	private ActionForward ExportToExcel(ActionMapping mapping, 
	                                    HttpServletRequest request, 
	                                    HttpServletResponse response,
	                                    ProjectCostForm form) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return (mapping.findForward("Export"));
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
				
			List list = findQueryResult(request, form);
			if (list== null || list.size() == 0) return (mapping.findForward("Export"));
				
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
				
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			HSSFCell cell = null;
			HSSFCellStyle boldTextFormatStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle normalDateFormatStyle = sheet.getRow(ListStartRow).getCell((short)2).getCellStyle();
			HSSFCellStyle normalNumberFormatStyle = sheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
			HSSFRow HRow = null;
			
			//Header
			//cell = sheet.getRow(0).getCell((short)4);
			//cell.setCellValue((new SimpleDateFormat("yyyy-MM-dd")).format(new Date()));
			//net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				
			int ExcelRow = ListStartRow;

			for (int row = 0; row < list.size(); row++) {
				ProjectCost projectCost = (ProjectCost)list.get(row);
				
				HRow = sheet.createRow(ExcelRow);
				cell = HRow.createCell((short)0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(projectCost.getProjCode());
				cell.setCellStyle(boldTextFormatStyle);
					
				cell = HRow.createCell((short)1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(projectCost.getProjName());
				cell.setCellStyle(boldTextFormatStyle);
					
				cell = HRow.createCell((short)2);
				cell.setCellValue(projectCost.getProjectStartDateStr());
				cell.setCellStyle(normalDateFormatStyle);
								
				cell = HRow.createCell((short)3);
				cell.setCellValue(projectCost.getOrigCompDateStr());
				cell.setCellStyle(normalDateFormatStyle);
					
				cell = HRow.createCell((short)4);
				if (projectCost.getServiceSalesValue() != null) {
				    cell.setCellValue(projectCost.getServiceSalesValue().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
					
				cell = HRow.createCell((short)5);
				if (projectCost.getLicenceSalesValue() != null) {
				    cell.setCellValue(projectCost.getLicenceSalesValue().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
					
				cell = HRow.createCell((short)6);
				if (projectCost.getDaysBudget() != null) {
				    cell.setCellValue(projectCost.getDaysBudget().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
					
				cell = HRow.createCell((short)7);
				if (projectCost.getDaysThisMonth() != null) {
				    cell.setCellValue(projectCost.getDaysThisMonth().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
					
				cell = HRow.createCell((short)8);
				if (projectCost.getDaysTodate() != null) {
				    cell.setCellValue(projectCost.getDaysTodate().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
					
				cell = HRow.createCell((short)9);
				if (projectCost.getPSCBudget() != null) {
				    cell.setCellValue(projectCost.getPSCBudget().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)10);
				if (projectCost.getPSCThisMonth() != null) {
				    cell.setCellValue(projectCost.getPSCThisMonth().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)11);
				if (projectCost.getPSCTodate() != null) {
				    cell.setCellValue(projectCost.getPSCTodate().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)12);
				if (projectCost.getExpsBudget() != null) {	
				    cell.setCellValue(projectCost.getExpsBudget().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)13);
				if (projectCost.getExpsThisMonth() != null) {
				    cell.setCellValue(projectCost.getExpsThisMonth().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)14);
				if (projectCost.getExpsTodate() != null) {
				    cell.setCellValue(projectCost.getExpsTodate().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)15);
				if (projectCost.getTotalBudget() != null) {
				    cell.setCellValue(projectCost.getTotalBudget().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)16);
				if (projectCost.getCostThisMonth() != null) {
				    cell.setCellValue(projectCost.getCostThisMonth().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)17);
				if (projectCost.getTotalCostTodate() != null) {
				    cell.setCellValue(projectCost.getTotalCostTodate().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)18);
				if (projectCost.getPSCForecast() != null) {
				    cell.setCellValue(projectCost.getPSCForecast().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)19);
				if (projectCost.getExpsForecast() != null) {
				    cell.setCellValue(projectCost.getExpsForecast().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
				
				cell = HRow.createCell((short)20);
				if (projectCost.getForecasttoComp() != null) {
				    cell.setCellValue(projectCost.getForecasttoComp().doubleValue());
				} else {
				    cell.setCellValue(0);
				}
				cell.setCellStyle(normalNumberFormatStyle);
					
				ExcelRow++;
			}
				
			//写入Excel工作表
			wb.write(response.getOutputStream());
			//关闭Excel工作薄对象
			response.getOutputStream().close();
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return (mapping.findForward("Export"));
			
	}
		
	private final static String ExcelTemplate="ProjectCost.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Project Cost.xls";
	private final int ListStartRow = 5;
	private Log log = LogFactory.getLog(ProjectCostRptAction.class);
}
