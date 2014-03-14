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
* @author angus 
*
*/
public class TSDetailRptAction extends ReportBaseAction {
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
			String FromDate = request.getParameter("dateStart");
			String EndDate = request.getParameter("dateEnd");
			String EmployeeId = request.getParameter("EmployeeId");
			String departmentId = request.getParameter("departmentId");
			String project = request.getParameter("project");
			if (EmployeeId == null) EmployeeId = "";
			if (departmentId == null) departmentId = "";
			if (FromDate==null) FromDate=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
			if (EndDate==null) EndDate=Date_formater.format(nowDate);
			if (project == null) project = "";
			if (action == null) action = "view";
			EndDate = EndDate + " 23:59";
			
			if (action.equals("QueryForList")) {
				SQLResults sr = findQueryResult(request,FromDate,EndDate,EmployeeId,departmentId,project );
				request.setAttribute("QryList",sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response,FromDate,EndDate,EmployeeId,departmentId, project);
			}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private SQLResults findQueryResult(HttpServletRequest request,String FromDate, String ToDate,String EmployeeId,String departmentId, String project) throws Exception {
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
		
		String SqlStr = "select tsd.ts_proj_id as tpid, tsm.tsm_userlogin as tuserid, sum (tsd.ts_hrs_user) as staff_hour, te.pevent_name as desp, pm.proj_name as pname, ul.name as uname, ";
		SqlStr = SqlStr + " sum (case when tsd.ts_status ='Approved' then tsd.ts_hrs_user else 0 end) as approved_hour";
		SqlStr = SqlStr + " from proj_ts_det as tsd";
		SqlStr = SqlStr + " inner join proj_mstr as pm  on  pm.proj_id = tsd.ts_proj_id";
		SqlStr = SqlStr + " inner join Projevent AS te ON te.pevent_id = tsd.ts_projevent";
		SqlStr = SqlStr + " inner join proj_ts_mstr as tsm on tsd.tsm_id = tsm.tsm_id";
		SqlStr = SqlStr + " inner join user_login AS ul ON ul.user_login_id = tsm.tsm_userlogin";
		SqlStr = SqlStr + " inner join party AS p ON p.party_id = ul.party_id";
		SqlStr = SqlStr + " where ";

		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " p.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " pm.proj_pm_user ='"+ul.getUserLoginId()+"'";
		}
		if (!EmployeeId.trim().equals("")) {
			SqlStr = SqlStr + " and (ul.user_login_id like '%"+EmployeeId.trim()+"%' or ul.name like '%"+EmployeeId.trim()+"%')";
		}
		if (!project.trim().equals("")) {
			SqlStr = SqlStr + " and (tsd.ts_proj_id like '%"+project.trim()+"%' or pm.proj_name like '%"+project.trim()+"%')";
		}
		//SqlStr = SqlStr +" and tsd.ts_status ='Approved'";
		
		SqlStr = SqlStr + " and tsd.ts_date between '"+FromDate+"' and '"+ToDate+"' AND tsd.ts_status <> 'Draft' and  tsd.ts_status <> 'Rejected' ";
		SqlStr = SqlStr + " group by tsd.ts_proj_id, tsm.tsm_userlogin, te.pevent_name, pm.proj_name, ul.name";
		SqlStr = SqlStr + " having  sum (tsd.ts_hrs_user) <>0";
		SqlStr = SqlStr + " order by tsd.ts_proj_id";
				
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		return sr;
	}
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,String FromDate, String ToDate,String EmployeeId,String departmentId, String project){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sr = findQueryResult(request,FromDate,ToDate,EmployeeId,departmentId, project);
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
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

			HSSFCell cell = null;
			cell = sheet.getRow(0).getCell((short)5);
			cell.setCellValue(df.format(fromDate) + " ~ " + df.format(toDate));
			
			//List
			HSSFCellStyle boldTextStyle     = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow).getCell((short)3).getCellStyle();
			
			int ExcelRow = ListStartRow;
			
			HSSFRow HRow = null;
			for (int row =0; row < sr.getRowCount(); row++) {
			HRow = sheet.createRow(ExcelRow);
			cell = HRow.createCell((short)0);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getString(row,"tpid"));
			cell.setCellStyle(boldTextStyle);
			
		        cell = HRow.createCell((short)1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getString(row,"pname"));
			cell.setCellStyle(boldTextStyle);
			
			cell = HRow.createCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getString(row,"tuserid"));
			cell.setCellStyle(boldTextStyle);
						
			cell = HRow.createCell((short)3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getString(row,"uname"));
			cell.setCellStyle(boldTextStyle);
						
			cell = HRow.createCell((short)4);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(df.format(fromDate) + " ~ " + df.format(toDate));
			cell.setCellStyle(boldTextStyle);
			
			cell = HRow.createCell((short)5);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getDouble(row,"staff_hour"));
			cell.setCellStyle(numberFormatStyle);
						
			cell = HRow.createCell((short)6);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getDouble(row,"approved_hour"));
			cell.setCellStyle(numberFormatStyle);
			
			cell = HRow.createCell((short)7);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getString(row,"desp"));
			cell.setCellStyle(boldTextStyle);
			
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
	private final static String ExcelTemplate="DetailedTSQuery.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Detailed TS Query.xls";
	private final int ListStartRow = 5;
}