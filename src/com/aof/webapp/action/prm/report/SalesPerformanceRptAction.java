/*
 * Created on 2005-6-23
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
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
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SalesPerformanceRptAction extends ReportBaseAction {

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
			String SalesId = request.getParameter("SalesId");
			String project = request.getParameter("project");
			String FromDate = request.getParameter("dateStart");
			String EndDate = request.getParameter("dateEnd");
			String departmentId = request.getParameter("departmentId");
			boolean signedflag = false;
			if (request.getParameter("signedflag") != null) signedflag = true;
			
			if (SalesId == null) SalesId = "";
			if (departmentId == null) departmentId = "";
			if (FromDate==null) FromDate=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-10));
			if (EndDate==null) EndDate=Date_formater.format(nowDate);
			if (action == null) action = "view";
					
			if (action.equals("QueryForList")) {
				SQLResults sr = findQueryResult(request,SalesId,project, departmentId, signedflag);
				request.setAttribute("QryList",sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response,SalesId,project, departmentId, signedflag);
			}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private SQLResults findQueryResult(HttpServletRequest request, String SalesId, String project, String departmentId, boolean signedflag) throws Exception {
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
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
		String SqlStr="";
		
		SqlStr = SqlStr + "select pm.proj_id as projCode, sul.name as salesperson, p.description as dep, cp.cp_signed_date as signdate, ";
		SqlStr = SqlStr + " pm.proj_contract_no as contractno, pp.description as cust, paul.name as paname, pmul.name as pmname, pm.proj_name as pdesc,";
		SqlStr = SqlStr + " pm.start_date as startdate, pm.end_date as end_date, pm.total_service_value as conAmt, sum (prc.receive_amount) as receiveAmt";
		SqlStr = SqlStr + " from contract_profile as cp inner join proj_mstr as pm on cp.cp_no = pm.proj_contract_no";
		SqlStr = SqlStr + " inner join user_login as sul on cp.cp_account_manager = sul.user_login_id";
		SqlStr = SqlStr + " inner join user_login as paul on pm.proj_pa_id = paul.user_login_id";
		SqlStr = SqlStr + " inner join user_login as pmul on pm.proj_pm_user = pmul.user_login_id";
		SqlStr = SqlStr + " inner join party as p on p.party_id = pm.dep_id";
		SqlStr = SqlStr + " inner join party as pp on pp.party_id = pm.cust_id";
		if (signedflag) {
			SqlStr = SqlStr + " left join ";
		}else {
			SqlStr = SqlStr + " inner join ";
		}
		SqlStr = SqlStr + " proj_invoice as pin on pin.inv_proj_id = pm.proj_id";
		if (signedflag) {
			SqlStr = SqlStr + " left join ";
		}else {
			SqlStr = SqlStr + " inner join ";
		}
		SqlStr = SqlStr + " proj_receipt as prc on prc.invoice_id = pin.inv_id";
		
		SqlStr = SqlStr + " where ";
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + "  pm.dep_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + "  pm.proj_pm_user ='"+ul.getUserLoginId()+"'";
		}
		if (!SalesId.trim().equals("")) {
			SqlStr = SqlStr + " and (sul.user_login_id like '%"+SalesId.trim()+"%' or sul.name like '%"+SalesId.trim()+"%')";
		}
		if (!project.trim().equals("")) {
			SqlStr = SqlStr + " and pm.proj_name like '%"+project.trim()+"%' or pm.proj_id like '%"+project.trim()+"%'";
		} 
		
		SqlStr = SqlStr + " group by sul.name, p.description, cp.cp_signed_date, pm.proj_id, pm.proj_contract_no, ";
		SqlStr = SqlStr + " pp.description, paul.name, pmul.name, pm.start_date, pm.end_date, pm.total_service_value, pm.proj_name";

		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		return sr;
	}
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,String SalesId,String project, String departmentId, boolean signedflag){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
			
			SQLResults sr = findQueryResult(request,SalesId, project, departmentId, signedflag);
			if (sr== null || sr.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			
			HSSFCell cell = null;
			
			//List
			HSSFCellStyle textStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle dateStyle = sheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
			HSSFCellStyle numStyle = sheet.getRow(ListStartRow).getCell((short)10).getCellStyle();
			
			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			HSSFRow HRow1 = null;
			for (int row =0; row < sr.getRowCount(); row++) {
				//daytotal=daytotal+sr.getInt(row,"dc");
				HRow = sheet.createRow(ExcelRow);
				cell = HRow.createCell((short)0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"salesperson"));
				cell.setCellStyle(textStyle);
				
			    cell = HRow.createCell((short)1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"contractno"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell((short)2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"pdesc"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell((short)3);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"cust"));
				cell.setCellStyle(textStyle);
							
				cell = HRow.createCell((short)4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue((sr.getDate(row,"signdate")== null ? "":Date_formater.format(sr.getDate(row,"signdate"))));
				cell.setCellStyle(dateStyle);

				cell = HRow.createCell((short)5);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"dep"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell((short)6);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"pmname"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell((short)7);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"paname"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell((short)8);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getDate(row,"startdate"));
				cell.setCellStyle(dateStyle);
				
				cell = HRow.createCell((short)9);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getDate(row,"end_date"));
				cell.setCellStyle(dateStyle);
				
				cell = HRow.createCell((short)10);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getDouble(row,"conAmt"));
				cell.setCellStyle(numStyle);
				
				cell = HRow.createCell((short)11);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getDouble(row,"receiveAmt"));
				cell.setCellStyle(numStyle);
				ExcelRow ++;
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
	private final static String ExcelTemplate="SalesPerformanceRpt.xls";
	private final static String FormSheetName="Sales Performance";
	private final static String SaveToFileName="Sales Performance Report.xls";
	private final int ListStartRow = 4;

}
