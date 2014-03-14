/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
*
*/
public class PreSaleMDRptAction extends ReportBaseAction {
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
			String FromDate = request.getParameter("dateStart");
			String EndDate = request.getParameter("dateEnd");
			if (project == null) project = "";
			if (FromDate==null) FromDate=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-10));
			if (EndDate==null) EndDate=Date_formater.format(nowDate);
			if (action == null) action = "view";
					
			if (action.equals("QueryForList")) {
				SQLResults sr = findQueryResult(request,FromDate,EndDate,project);
				request.setAttribute("QryList",sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response,FromDate,EndDate,project);
			}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private SQLResults findQueryResult(HttpServletRequest request,String FromDate, String ToDate, String project) throws Exception {
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		String SqlStr = "select sum(ptd.ts_hrs_confirm) as actualhrs, pm.proj_name as pname, ul.name, p.description, ptd.ts_proj_id as pid";
		SqlStr = SqlStr + " from projevent as pe inner join proj_ts_det as ptd on ptd.ts_projevent = pe.pevent_code";
		SqlStr = SqlStr + " inner join proj_ts_mstr as ptm on ptm.tsm_id =ptd.tsm_id and pm.proj_status = 'WIP'";
		
		SqlStr = SqlStr + " inner join user_login as ul on ptm.tsm_userlogin = ul.user_login_id";
		
		SqlStr = SqlStr + " inner join proj_mstr as pm on pm.proj_id = ptd.ts_proj_id";
		SqlStr = SqlStr + " inner join party as p on p.party_id = pm.cust_id";
					
		SqlStr = SqlStr + " where pe.pevent_code = '14' and ptd.ts_status = 'approved' ";
		
		if (!project.trim().equals("")) {
			SqlStr = SqlStr + " and ptd.ts_proj_id like '%"+project.trim()+"%' or pm.proj_name like '%"+project.trim()+"%'";
		}
		SqlStr = SqlStr + " and ptd.ts_date between '"+FromDate+"' and '"+ToDate+"'";
		SqlStr = SqlStr + "group by ptd.ts_proj_id, pm.proj_name, ul.name, p.description,ptd.ts_proj_id";	
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		return sr;
	}
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,String FromDate, String ToDate,String project){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sr = findQueryResult(request,FromDate,ToDate, project);
			if (sr== null || sr.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			int fromYear = 0;
			int fromMonth = 0;
			int fromDay = 0;
			int toYear = 0;
			int toMonth = 0;
			int toDay = 0;
			Calendar fromCalendar = Calendar.getInstance();
			if (FromDate != null && FromDate.trim().length() > 9) {
			    fromYear = Integer.parseInt(FromDate.substring(0, 4));
			    fromMonth = Integer.parseInt(FromDate.substring(5, 7));
			    fromDay = Integer.parseInt(FromDate.substring(8, 10));
			    fromCalendar.set(Calendar.YEAR, fromYear);
			    fromCalendar.set(Calendar.MONTH, fromMonth - 1);
			    fromCalendar.set(Calendar.DATE, fromDay);
			}
			Date fromDate = fromCalendar.getTime();
			Calendar toCalendar = Calendar.getInstance();
			if (ToDate != null && ToDate.trim().length() > 9) {
			    toYear = Integer.parseInt(ToDate.substring(0, 4));
			    toMonth = Integer.parseInt(ToDate.substring(5, 7));
			    toDay = Integer.parseInt(ToDate.substring(8, 10));
			    toCalendar.set(Calendar.YEAR, toYear);
			    toCalendar.set(Calendar.MONTH, toMonth - 1);
			    toCalendar.set(Calendar.DATE, toDay);
			}
			Date toDate = toCalendar.getTime();
			DateFormat df = new SimpleDateFormat("dd-MMM-yy", Locale.ENGLISH);
			HSSFCell cell = null;
			cell = sheet.getRow(1).getCell((short)4);
			cell.setCellValue(df.format(fromDate) + " ~ " + df.format(toDate));
			//List
			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle normalStyle = sheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
			
			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			for (int row =0; row < sr.getRowCount(); row++) {
			
			HRow = sheet.createRow(ExcelRow);
			cell = HRow.createCell((short)0);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//??cell????????????
			cell.setCellValue(sr.getString(row,"pid"));
			cell.setCellStyle(boldTextStyle);
			
		    cell = HRow.createCell((short)1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//??cell????????????
			cell.setCellValue(sr.getString(row,"pname"));
			cell.setCellStyle(boldTextStyle);
			
			cell = HRow.createCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//??cell????????????
			cell.setCellValue(sr.getString(row,"description"));
			cell.setCellStyle(boldTextStyle);
						
			cell = HRow.createCell((short)3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//??cell????????????
			cell.setCellValue(sr.getString(row,"name"));
			cell.setCellStyle(boldTextStyle);
						
			cell = HRow.createCell((short)4);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//??cell????????????
			cell.setCellValue(sr.getDouble(row,"actualhrs"));
			cell.setCellStyle(normalStyle);
			
			
			ExcelRow++;
			}
						
			//??Excel???
			wb.write(response.getOutputStream());
			//??Excel?????
			response.getOutputStream().close();
			response.setStatus( HttpServletResponse.SC_OK );
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	private final static String ExcelTemplate="PreSaleMDRpt.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Pre-Sale Man-Day report.xls";
	private final int ListStartRow = 5;
}