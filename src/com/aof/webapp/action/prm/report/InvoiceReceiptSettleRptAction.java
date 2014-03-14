/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.CallableStatement;
import java.sql.ResultSet;
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
 * @author chen yu
 * @version 2006-1-10
 *
 */
public class InvoiceReceiptSettleRptAction extends ReportBaseAction {
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
			String customer = request.getParameter("customer");
			if (customer == null) customer = "";
			if (FromDate==null) FromDate=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
			if (EndDate==null) EndDate=Date_formater.format(nowDate);
			if (action == null) action = "view";
			EndDate = EndDate + " 23:59";
			System.out.println("fromdata:"+FromDate+"\n");
			System.out.println("EndDate:"+EndDate+"\n");
			
			
			if (action.equals("QueryForList")) {
				SQLResults sr = findQueryResult(request,FromDate,EndDate,customer);
				request.setAttribute("InvoiceQryList",sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response,FromDate,EndDate,customer);
			}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private SQLResults findQueryResult(HttpServletRequest request,String FromDate, String ToDate,String customer) throws Exception {
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		String SqlStr = "select "+
						" inv.inv_code as inv_code, p1.description as description1, inv.inv_proj_id as inv_proj_id, inv.inv_invoicedate as inv_invoicedate, "+
						" inv.inv_amount as inv_amount, inv.inv_curr_id as inv_curr_id,inv.inv_status as inv_status,"+        
						" prm.receipt_no as receipt_no, prm.fa_receiptno as fa_receiptno, p.description as description, prm.receipt_amt as receipt_amt, "+  
						"prm.currency as currency,prm.receipt_date as receipt_date, pr.receive_amount as receive_amount "+
				        " from "+
						"proj_receipt as pr "+
						"inner join proj_receipt_mstr as prm on prm.receipt_no = pr.receipt_no "+
						"inner join proj_invoice as inv on inv.inv_id = pr.invoice_id "+
						"inner join party as p on p.party_id = prm.customerid "+
						"inner join party as p1 on p1.party_id = inv.inv_billaddr"+
						" where prm.receipt_type <>'lost' and (  prm.receipt_date between '"+FromDate+"' and '"+ToDate+"')";
		if (!customer.trim().equals("")){
			SqlStr = SqlStr + " and  p1.party_id= '"+customer+"'";
		}
		
		
		System.out.println("\n"+SqlStr+"\n");
		
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		
		//SQLResults sr =null;
		
		return sr;
	}
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,String FromDate, String ToDate,String customer){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			SQLResults sr = findQueryResult(request,FromDate,ToDate,customer);
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
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			HSSFCell cell = null;
			cell = sheet.getRow(1).getCell((short)9);
			cell.setCellValue(Date_formater.format(fromDate));
			cell = sheet.getRow(1).getCell((short)12);
			cell.setCellValue(Date_formater.format(toDate));
			//List
			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle boldTextStyle2 = sheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
			HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
			
			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			for (int row =0; row < sr.getRowCount(); row++) {
			HRow = sheet.createRow(ExcelRow);
			cell = HRow.createCell((short)0);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getString(row,"inv_code"));
			cell.setCellStyle(boldTextStyle);
			
		        cell = HRow.createCell((short)1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getString(row,"description1"));
			cell.setCellStyle(boldTextStyle);
			
			cell = HRow.createCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getString(row,"inv_proj_id"));
			cell.setCellStyle(boldTextStyle);
						
			cell = HRow.createCell((short)3);
			cell.setCellValue(Date_formater.format(sr.getDate(row,"inv_invoicedate")));
			cell.setCellStyle(boldTextStyle);
			
			cell = HRow.createCell((short)4);
			cell.setCellValue(sr.getDouble(row,"inv_amount"));
			cell.setCellStyle(numberFormatStyle);
						
			cell = HRow.createCell((short)5);
			cell.setCellValue(sr.getString(row,"inv_curr_id"));
			cell.setCellStyle(boldTextStyle);
			
			cell = HRow.createCell((short)6);
			cell.setCellValue(sr.getString(row,"receipt_no"));
			cell.setCellStyle(boldTextStyle2);
						
			cell = HRow.createCell((short)7);
			cell.setCellValue(sr.getString(row,"fa_receiptno"));
			cell.setCellStyle(boldTextStyle2);
			
			cell = HRow.createCell((short)8);
			cell.setCellValue(sr.getString(row,"description"));
			cell.setCellStyle(boldTextStyle2);
			
			cell = HRow.createCell((short)9);
			cell.setCellValue(sr.getDouble(row,"receipt_amt"));
			cell.setCellStyle(boldTextStyle2);
			
			
			cell = HRow.createCell((short)10);
			cell.setCellValue(sr.getString(row,"currency"));
			cell.setCellStyle(boldTextStyle2);
			
			
			cell = HRow.createCell((short)11);
			cell.setCellValue(Date_formater.format(sr.getDate(row,"receipt_date")));
			cell.setCellStyle(boldTextStyle2);
			
			cell = HRow.createCell((short)12);
			cell.setCellValue(sr.getDouble(row,"receive_amount"));
			cell.setCellStyle(numberFormatStyle);
			
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
	private final static String ExcelTemplate="InvoiceReceiptReport.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="InvoiceReceiptReport.xls";
	private final int ListStartRow = 5;
}