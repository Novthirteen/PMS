/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.Date;
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
import org.apache.poi.hssf.usermodel.HSSFFont;
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

/**
 * @author Jackey Ding
 *
 * @version 2005-02-23
 */
public class ExpenseAnalysisRptAction extends ReportBaseAction {

	private final static String ExcelTemplate="ExpenseAnalysis.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Expense Analysis.xls";
	private final int ListStartRow = 6;
	private Log log = LogFactory.getLog(ExpenseAnalysisRptAction.class);
	
	public ActionForward execute (ActionMapping mapping,
						          ActionForm form,
						          HttpServletRequest request,
						          HttpServletResponse response) {
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
			//String LastFMId = "";
			String CurrDataTo = "";
			//String LastDataTo = "";
			
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
			request.setAttribute("SrcYear",new Integer(srcYR).toString());
			request.setAttribute("SrcMonth",new Integer(srcM).toString());
			//SqlStr = "select max(f_fm_cd) from FMonth where f_fm_cd < " +CurrFMId;
			
			net.sf.hibernate.Session session = Hibernate2Session.currentSession();
			
			FMonthHelper fh = new FMonthHelper();
			FMonth fMonth = fh.findFiscalMonthByYearAndMonth(session, srcYR, srcM + 1);

			sqlExec.closeConnection();

			String departmentId = request.getParameter("departmentId");
			if (departmentId == null) departmentId = "";
			
			String action = request.getParameter("FormAction");
			if (action == null) action = "view";
			
			if (action.equals("QueryForList")) {
				sr = findQueryResult(request, fMonth, departmentId);
				request.setAttribute("QryList",sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request,response,fMonth,departmentId);
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
	        						   FMonth fMonth,
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
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
					EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		StringBuffer sqlStr = new StringBuffer("");
		boolean detailflag = false;
		if (request.getParameter("detailflag") != null) detailflag = true;
		
		sqlStr.append("SELECT A.Projcode AS Projcode,");
		sqlStr.append("       A.ProjName AS ProjName,");
		sqlStr.append("       A.Type AS Type,");
		sqlStr.append("       A.Name AS Name,");
		sqlStr.append("       A.EntryDate AS EntryDate,");
		sqlStr.append("       A.ExpsDate AS ExpsDate,");
		sqlStr.append("       A.Curr AS Curr,");
		sqlStr.append("       A.ClaimValue AS ClaimValue ");
		sqlStr.append("FROM (SELECT PCD.proj_id AS Projcode,");
		sqlStr.append("             PM.proj_name AS ProjName,");
		sqlStr.append("             PCT.typename AS Type,");
		sqlStr.append("             UL.Name AS Name,");
		sqlStr.append("             PCM.createdate AS EntryDate,");
		sqlStr.append("             PCM.costdate AS ExpsDate,");
		sqlStr.append("             PCM.currency AS Curr,");
		sqlStr.append("             ((PCM.totalvalue * PCD.percentage) /100) AS ClaimValue");
		sqlStr.append("         FROM Proj_Cost_Det AS PCD INNER JOIN Proj_Mstr AS PM ON PCD.proj_id = PM.proj_id ");
		sqlStr.append("                                   INNER JOIN Proj_Cost_Mstr AS PCM ON PCM.costcode = PCD.costCode");
		sqlStr.append("                                   INNER JOIN Proj_Cost_type AS PCT ON PCM.type = PCT.typeid");
		sqlStr.append("                                   INNER JOIN USER_LOGIN AS UL ON PCD.user_login_id = UL.user_login_id");
		if (!departmentId.trim().equals("")) {
			if (detailflag) {
				sqlStr.append(" INNER JOIN (SELECT PM.proj_id AS proj_id");
				sqlStr.append("               FROM Proj_Mstr AS PM INNER JOIN party AS DEP ON PM.dep_id = DEP.party_id");
				sqlStr.append("              WHERE dep.party_id IN ("+PartyListStr+")");
				sqlStr.append("             ) AS SubProj ON SubProj.proj_id = left(PM.proj_linknote,CHARINDEX(':',PM.proj_linknote)-1)");
				sqlStr.append(" WHERE '1' = '1'");
			} else {
			    sqlStr.append(" INNER JOIN party AS DEP ON PM.dep_id = DEP.party_id ");
			    sqlStr.append(" WHERE dep.party_id IN ("+PartyListStr+") ");
			}
		} else {
			if (detailflag) {
				sqlStr.append(" INNER JOIN (SELECT PM.proj_id AS proj_id");
				sqlStr.append("               FROM Proj_Mstr AS PM INNER JOIN user_login AS DEP ON PM.proj_pm_user = DEP.user_login_id");
				sqlStr.append("              WHERE DEP.user_login_id ='"+ul.getUserLoginId()+"'");
				sqlStr.append("             ) AS SubProj ON SubProj.proj_id = left(PM.proj_linknote,CHARINDEX(':',PM.proj_linknote)-1)");
				sqlStr.append(" WHERE '1' = '1'");
			} else {
			    sqlStr.append(" INNER JOIN user_login AS DEP ON PM.proj_pm_user = DEP.user_login_id ");
			    sqlStr.append(" WHERE DEP.user_login_id ='"+ul.getUserLoginId()+"' ");
			}			   
		}
		sqlStr.append("       AND PCM.approvalDate IS NOT NULL");
		sqlStr.append("       AND PCT.typeaccount = 'Expense'");
		sqlStr.append("       AND PCM.claimtype = 'CN'");
		sqlStr.append("       AND PCM.costdate BETWEEN ? AND ? ");
		sqlStr.append(" UNION ALL ");
		sqlStr.append("SELECT PEM.em_proj_id AS Projcode,");
		sqlStr.append("       PM.proj_name AS ProjName,");
		sqlStr.append("       ET.Exp_Desc AS Type,");
		sqlStr.append("       UL.Name AS Name,");
		sqlStr.append("       PEM.em_entry_date AS EntryDate,");
		sqlStr.append("       PED.ed_date AS ExpsDate,");
		sqlStr.append("       PEM.em_Curr_Id AS Curr,");
		sqlStr.append("       PED.ed_amt_user AS ClaimValue");
		sqlStr.append("  FROM Proj_Exp_Det AS PED INNER JOIN Proj_Exp_Mstr AS PEM ON PEM.em_id = PED.em_id"); 
		sqlStr.append("                           INNER JOIN Proj_Mstr AS PM ON PEM.em_proj_id = PM.proj_id");
		sqlStr.append("                           INNER JOIN ExpenseType AS ET ON PED.exp_id = ET.Exp_Id");
		sqlStr.append("                           INNER JOIN USER_LOGIN as UL on PEM.em_userlogin = UL.user_login_id");
		if (!departmentId.trim().equals("")) {
			if (detailflag) {
				sqlStr.append(" INNER JOIN (SELECT PM.proj_id AS proj_id");
				sqlStr.append("               FROM Proj_Mstr AS PM INNER JOIN party AS DEP ON PM.dep_id = DEP.party_id");
				sqlStr.append("              WHERE dep.party_id IN ("+PartyListStr+")");
				sqlStr.append("             ) AS SubProj ON SubProj.proj_id = left(PM.proj_linknote,CHARINDEX(':',PM.proj_linknote)-1)");
				sqlStr.append(" WHERE '1' = '1'");
			} else {
			    sqlStr.append("                   INNER JOIN party AS DEP ON PM.dep_id = DEP.party_id");
			    sqlStr.append("             WHERE dep.party_id IN ("+PartyListStr+")");
			}
		} else {
			if (detailflag) {
				sqlStr.append(" INNER JOIN (SELECT PM.proj_id AS proj_id");
				sqlStr.append("               FROM Proj_Mstr AS PM INNER JOIN user_login AS DEP ON PM.proj_pm_user = DEP.user_login_id");
				sqlStr.append("              WHERE DEP.user_login_id ='"+ul.getUserLoginId()+"'");
				sqlStr.append("             ) AS SubProj ON SubProj.proj_id = left(PM.proj_linknote,CHARINDEX(':',PM.proj_linknote)-1)");
				sqlStr.append(" WHERE '1' = '1'");
			} else {
			    sqlStr.append("                   INNER JOIN user_login AS DEP ON PM.proj_pm_user = DEP.user_login_id");
			    sqlStr.append("             WHERE DEP.user_login_id ='"+ul.getUserLoginId()+"'");
			}
		}
		sqlStr.append("   AND PEM.em_claimtype = 'CN'");
		sqlStr.append("   AND PEM.em_approval_date BETWEEN ? AND ?) AS A ");
		sqlStr.append(" ORDER BY A.Projcode, A.Name, A.EntryDate, A.ExpsDate ");
		
		sqlExec.addParam(fMonth.getDateFrom());
		sqlExec.addParam(fMonth.getDateTo());
		sqlExec.addParam(fMonth.getDateFrom());
		sqlExec.addParam(fMonth.getDateTo());
		
	    log.info(sqlStr.toString());
		
		SQLResults sr = sqlExec.runQueryCloseCon(sqlStr.toString());
		
		return sr;
	}

	private ActionForward ExportToExcel(ActionMapping mapping, 
			                            HttpServletRequest request, 
										HttpServletResponse response,
										FMonth fMonth,
										String departmentId){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return (mapping.findForward("Export"));
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sr = findQueryResult(request, fMonth,departmentId);
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
			HSSFCell cell = null;
			HSSFCellStyle blodTextFormatStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle normalTextFormatStyle = sheet.getRow(ListStartRow).getCell((short)1).getCellStyle();
			HSSFCellStyle normalDateFormatStyle = sheet.getRow(ListStartRow).getCell((short)3).getCellStyle();
			HSSFCellStyle blodNumberFormatStyle = sheet.getRow(ListStartRow).getCell((short)5).getCellStyle();
			HSSFCellStyle normalNumberFormatStyle = sheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
			/*
			HSSFFont font = wb.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			font.setFontHeight((short)7);
			blodTextFormatStyle.setFont(font);
			//blodNumberFormatStyle.setFont(font);
			*/
			
			HSSFRow HRow = null;
			
			//Header
			cell = sheet.getRow(0).getCell((short)3);
			Calendar calendar = Calendar.getInstance();
			calendar.set(fMonth.getYear().intValue(), fMonth.getMonthSeq(), 1);
			cell.setCellValue((new SimpleDateFormat("MMM yyyy", Locale.ENGLISH)).format(calendar.getTime()));
			
			//List
			int ExcelRow = ListStartRow;
			
			String newProject = "";
			String oldproject = "";
			SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MM/yyyy");
			
			double totalValue = 0;
			
			for (int row =0; row < sr.getRowCount(); row++) {
				
			    newProject = sr.getString(row, "Projcode");
			    String projectName = sr.getString(row, "ProjName");
			    String type = sr.getString(row, "Type");
				String name = sr.getString(row, "Name");
				java.util.Date entryDate = sr.getDate(row, "EntryDate");
				String entryDateStr = entryDate != null ? dateFormatter.format(entryDate) : "";
				java.util.Date expsDate = sr.getDate(row, "ExpsDate");
				String expsDateStr = expsDate != null ? dateFormatter.format(expsDate) : "";
				String curr = sr.getString(row, "Curr");
				double claimValue = sr.getDouble(row, "ClaimValue");
				//claimValue = Math.round(claimValue * 100) / 100;
				
				if (!oldproject.equals(newProject)) {
				    if (row != 0) {
				        HRow = sheet.createRow(ExcelRow);
				        
				        cell = HRow.createCell((short)0);
						cell.setCellStyle(blodTextFormatStyle);
						cell = HRow.createCell((short)1);
						cell.setCellStyle(normalTextFormatStyle);
						cell = HRow.createCell((short)2);
						cell.setCellStyle(normalTextFormatStyle);
						cell = HRow.createCell((short)3);
						cell.setCellStyle(normalDateFormatStyle);
						cell = HRow.createCell((short)4);
						cell.setCellStyle(normalDateFormatStyle);
						cell = HRow.createCell((short)5);
						cell.setCellStyle(blodTextFormatStyle);
						cell.setCellValue("Project Total:");
						cell = HRow.createCell((short)6);
						cell.setCellStyle(blodNumberFormatStyle);
						cell.setCellValue(totalValue);
						
						totalValue = 0;
						
				        ExcelRow++;
				    }
				    
				    HRow = sheet.createRow(ExcelRow);
					oldproject = newProject;
					cell = HRow.createCell((short)0);
					cell.setCellStyle(blodTextFormatStyle);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);	//设置cell编码解决中文高位字节截断
					cell.setCellValue(newProject + ":" + projectName);
					cell = HRow.createCell((short)1);
					cell.setCellStyle(normalTextFormatStyle);
					cell = HRow.createCell((short)2);
					cell.setCellStyle(normalTextFormatStyle);
					cell = HRow.createCell((short)3);
					cell.setCellStyle(normalDateFormatStyle);
					cell = HRow.createCell((short)4);
					cell.setCellStyle(normalDateFormatStyle);
					cell = HRow.createCell((short)5);
					cell.setCellStyle(blodNumberFormatStyle);
					cell = HRow.createCell((short)6);
					cell.setCellStyle(normalNumberFormatStyle);

					ExcelRow++;
				} 
				
				totalValue = totalValue + claimValue;
				
				HRow = sheet.createRow(ExcelRow);
				
				cell = HRow.createCell((short)0);
				cell.setCellStyle(blodTextFormatStyle);
				cell = HRow.createCell((short)1);
				cell.setCellStyle(normalTextFormatStyle);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);	//设置cell编码解决中文高位字节截断
				cell.setCellValue(type);
				cell = HRow.createCell((short)2);
				cell.setCellStyle(normalTextFormatStyle);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);	//设置cell编码解决中文高位字节截断
				cell.setCellValue(name);
				cell = HRow.createCell((short)3);
				cell.setCellStyle(normalDateFormatStyle);
				cell.setCellValue(entryDateStr);
				cell = HRow.createCell((short)4);
				cell.setCellStyle(normalDateFormatStyle);
				cell.setCellValue(expsDateStr);
				cell = HRow.createCell((short)5);
				cell.setCellStyle(normalDateFormatStyle);
				cell.setCellValue(curr);
				cell = HRow.createCell((short)6);
				cell.setCellStyle(normalNumberFormatStyle);
				cell.setCellValue(claimValue);
											
				ExcelRow++;
			}
			
			HRow = sheet.createRow(ExcelRow);
	        
	        cell = HRow.createCell((short)0);
			cell.setCellStyle(blodTextFormatStyle);
			cell = HRow.createCell((short)1);
			cell.setCellStyle(normalTextFormatStyle);
			cell = HRow.createCell((short)2);
			cell.setCellStyle(normalTextFormatStyle);
			cell = HRow.createCell((short)3);
			cell.setCellStyle(normalDateFormatStyle);
			cell = HRow.createCell((short)4);
			cell.setCellStyle(normalDateFormatStyle);
			cell = HRow.createCell((short)5);
			cell.setCellStyle(blodTextFormatStyle);
			cell.setCellValue("Project Total:");
			cell = HRow.createCell((short)6);
			cell.setCellStyle(blodNumberFormatStyle);
			cell.setCellValue(totalValue);
			
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
	
