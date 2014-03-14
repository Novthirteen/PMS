/*
 * Created on 2006-5-22
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
public class OutstandingReturnAirTicketRptAction extends ReportBaseAction {

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
			String EmployeeId = request.getParameter("EmployeeId");
			String project = request.getParameter("project");
			String FromDate = request.getParameter("dateStart");
			String EndDate = request.getParameter("dateEnd");
			String departmentId = request.getParameter("departmentId");
			String category = request.getParameter("category");
			boolean zeroflag = false;
			if (request.getParameter("zeroflag") != null) zeroflag = true;
			if (EmployeeId == null) EmployeeId = "";
			if (departmentId == null) departmentId = "";
			if (category == null) category = "";
			if (FromDate==null) FromDate=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-10));
			if (EndDate==null) EndDate=Date_formater.format(nowDate);
			if (action == null) action = "view";
					
			if (action.equals("QueryForList")) {
				long timeStart = System.currentTimeMillis(); 
				SQLResults sr = findQueryResult(request,EmployeeId,project, departmentId, category);
				request.setAttribute("QryList",sr);
				long timeEnd = System.currentTimeMillis();       //for performance test
				return (mapping.findForward("success"));
			}
			
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response,EmployeeId,project, departmentId,  category);
			}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private SQLResults findQueryResult(HttpServletRequest request,String EmployeeId, String project, 
					String departmentId,  String category) throws Exception {
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
		Date current =  Calendar.getInstance().getTime();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String time = df.format(current);
		
		SqlStr = SqlStr + "select pcm.formcode, pcm.refno, pcm.totalvalue, ul.name, pcm.costdate,pcm.claimtype, p.description as vendor,";
		SqlStr = SqlStr + " p1.description as customer, datediff (day, pcm.costdate,'"+time+"')-60  as dc, dept.description as p_desc, pm.proj_id as proj_id,pm.proj_name as proj_name  ";
		SqlStr = SqlStr + " from proj_airfare_cost as pac";
		SqlStr = SqlStr + " inner join proj_cost_mstr as pcm on pcm.costcode = pac.costcode ";
		SqlStr = SqlStr + " inner join proj_mstr as pm on pm.proj_id = pcm.proj_id ";
		SqlStr = SqlStr + " inner join party as p on p.party_id =pcm.payfor";
		SqlStr = SqlStr + " inner join party as p1 on p1.party_id =pm.cust_id";
		SqlStr = SqlStr + " inner join party as dept on dept.party_id =pm.dep_id";
		SqlStr = SqlStr + " left join user_login as ul on ul.user_login_id = pcm.user_login_id";
		SqlStr = SqlStr + " where pac.return_date is null and (datediff (day, pcm.costdate,'"+time+"')-60) >0 ";
		
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " and pm.dep_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + "  and pm.proj_pm_user ='"+ul.getUserLoginId()+"'";
		}
		if (!EmployeeId.trim().equals("")) {
			SqlStr = SqlStr + " and (ul.user_login_id like '%"+EmployeeId.trim()+"%' or ul.name like '%"+EmployeeId.trim()+"%')";
		}
		if (!project.trim().equals("")) {
			SqlStr = SqlStr + " and (pm.proj_name like '%"+project.trim()+"%' or pm.proj_id like '%"+project.trim()+"%')";
		} 
		if (!category.trim().equals("")) {
			SqlStr = SqlStr + " and pcm.claimtype = '"+category+"'";
		} 
		
		SqlStr = SqlStr + " order by pcm.costdate";
		

		long startTime = System.currentTimeMillis();
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		long endTime = System.currentTimeMillis();
		
		System.out.println("It takes " + (startTime - endTime) + "ms to execute the query...");

		return sr;
	}
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,
									String EmployeeId, String project, String departmentId, String category){
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
			
			SQLResults sr = findQueryResult(request,EmployeeId, project, departmentId,  category);
			if (sr== null || sr.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
		
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
			
			HSSFCell cell = null;
			cell = sheet.getRow(1).getCell((short)8);
			cell.setCellValue(df.format(nowDate) );
			//List
			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle normalStyle = sheet.getRow(ListStartRow).getCell((short)1).getCellStyle();
			HSSFCellStyle numStyle = sheet.getRow(ListStartRow).getCell((short)2).getCellStyle();
			HSSFCellStyle dateStyle = sheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
			HSSFCellStyle numStyle1 = sheet.getRow(ListStartRow).getCell((short)8).getCellStyle();
			
			int ExcelRow = ListStartRow;
			int daytotal =0;
			
			HSSFRow HRow = null;
			HSSFRow HRow1 = null;
			for (int row =0; row < sr.getRowCount(); row++) {
				int dc = 0;
				if(sr.getInt(row,"dc")>0){
					dc = sr.getInt(row,"dc");
				}
				daytotal=daytotal+dc;
				HRow = sheet.createRow(ExcelRow);
				cell = HRow.createCell((short)0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"formcode"));
				cell.setCellStyle(boldTextStyle);
				
			    cell = HRow.createCell((short)1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"refno"));
				cell.setCellStyle(normalStyle);
				
				cell = HRow.createCell((short)2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getDouble(row,"totalvalue"));
				cell.setCellStyle(numStyle);
				
				cell = HRow.createCell((short)3);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"p_desc"));
				cell.setCellStyle(normalStyle);
				
				cell = HRow.createCell((short)4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"name"));
				cell.setCellStyle(normalStyle);
				
				
				cell = HRow.createCell((short)5);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(df.format(sr.getDate(row,"costdate")));
				cell.setCellStyle(dateStyle);
				
				cell = HRow.createCell((short)6);
				String cty = "";
				if((sr.getString(row,"claimtype")).equals("CN")){
					cty = "Company";
				}else{
					cty ="Customer";
				}
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(cty);
				cell.setCellStyle(normalStyle);
				
				cell = HRow.createCell((short)7);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"proj_id"));
				cell.setCellStyle(normalStyle);
				
				cell = HRow.createCell((short)8);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"proj_name"));
				cell.setCellStyle(normalStyle);
				
				cell = HRow.createCell((short)9);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"customer"));
				cell.setCellStyle(normalStyle);

				cell = HRow.createCell((short)10);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"vendor"));
				cell.setCellStyle(normalStyle);
				
				cell = HRow.createCell((short)11);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getInt(row,"dc")<=0 ? 0 :sr.getInt(row,"dc"));
				cell.setCellStyle(numStyle1);
	
				ExcelRow++;
			}
			HRow1 = sheet.createRow(sr.getRowCount()+ListStartRow);
			cell = HRow1.createCell((short)10);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue("Total :");
			cell.setCellStyle(boldTextStyle);
			
			cell = HRow1.createCell((short)11);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(daytotal);
			cell.setCellStyle(numStyle1);
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
	private final static String ExcelTemplate="OutstandingReturnedAirTicketReport.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Outstanding Returned Air Ticket Report.xls";
	private final int ListStartRow = 6;


}
