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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.GeneralException;
import com.aof.util.UtilDateTime;
import com.aof.webapp.form.prm.report.APAgingRptForm;

public class APAgingRptAction extends ReportBaseAction {

	private final static String ExcelTemplate="APAgingReport.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="AP Aging Report.xls";
	private final int ListStartRow = 7;
	private Log log = LogFactory.getLog(APAgingRptAction.class);
	
	public ActionForward execute (ActionMapping mapping,
						          ActionForm form,
						          HttpServletRequest request,
						          HttpServletResponse response) {

		APAgingRptForm apForm = (APAgingRptForm)form;
		
		try {
			
			if ("QueryForList".equals(apForm.getFormAction())) {
				request.setAttribute("QryList",findQueryResult(apForm, request));
			}
			
			if ("ExportToExcel".equals(apForm.getFormAction())) {
				return ExportToExcel(apForm, request, response);
			}
			
			List partyList = null;
			PartyHelper ph = new PartyHelper();
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			partyList = ph.getAllSubPartysByPartyId(
					Hibernate2Session.currentSession(), ul.getParty().getPartyId());
			if (partyList == null) partyList = new ArrayList();
			partyList.add(0, ul.getParty());
			request.setAttribute("PartyList", partyList);
			
			return (mapping.findForward("success"));
			
		} catch(Exception e) {
			e.printStackTrace();
			return null;
		} finally {
		    try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
	}
	
	private SQLResults findQueryResult(APAgingRptForm apForm, HttpServletRequest request) throws HibernateException, GeneralException {
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));

		StringBuffer statement = new StringBuffer("");
		statement.append(" select vendor.description as vendorNm, ");
		statement.append("        vendor.party_id as vendorId, ");
		statement.append("        contractProject.proj_id as contractProjectId, ");
	    statement.append("        contractProject.proj_name as contractProjectNm, ");
		statement.append("        POProject.proj_id as POProjectId, ");
		statement.append("        POProject.proj_name as POProjectNm, ");
		statement.append("        supplierInvoice.pay_code as supplierInvoiceNo, ");
		statement.append("        supplierInvoice.pay_type as supplierInvoicePayType, ");
		statement.append("        department.description as departmentNm, ");
		statement.append("        (supplierInvoice.pay_amount * supplierInvoice.exchange_rate) as supplierInvoiceAmount, ");
		statement.append("        sum(isnull(postPaymentTransaction.pay_amount * postPaymentTransaction.curr_rate, 0)) as paidAmount, ");
		statement.append("        dateadd(day, ?, supplierInvoice.pay_date) as dueDate ");
		statement.append("   from proj_payment_mstr as supplierInvoice ");
		statement.append("  inner join proj_mstr as POProject on supplierInvoice.po_proj_id = POProject.proj_id ");
		statement.append("  inner join proj_mstr as contractProject on POProject.parent_proj_id = contractProject.proj_id ");
		statement.append("  inner join party as vendor on supplierInvoice.vendor_id = vendor.party_id ");
		statement.append("  inner join party as department on POProject.dep_id = department.party_id ");
		statement.append("  left join proj_payment_transaction as postPaymentTransaction on (supplierInvoice.pay_code = postPaymentTransaction.invoice_id and postPaymentTransaction.post_status = ?) ");
		statement.append(" where dateadd(day, ?, supplierInvoice.pay_date) <= ? ");
		statement.append("   and (postPaymentTransaction.pay_date <= ? or postPaymentTransaction.pay_date is null) ");

		sqlExec.addParam(0);
		sqlExec.addParam(Constants.POST_PAYMENT_TRANSACTION_STATUS_PAID);
		sqlExec.addParam(0);
		sqlExec.addParam(new Date(UtilDateTime.toDate2(apForm.getDate() + " 00:00:00.000").getTime()));
		sqlExec.addParam(new Date(UtilDateTime.toDate2(apForm.getDate() + " 23:59:59.999").getTime()));

		if (apForm.getPayTo() != null && apForm.getPayTo().trim().length() != 0) {
			statement.append("    and (vendor.party_id like ? or vendor.description like ?) ");
			
			sqlExec.addParam("%" + apForm.getPayTo() + "%");
			sqlExec.addParam("%" + apForm.getPayTo() + "%");
		}
		
		if (apForm.getPoProject() != null && apForm.getPoProject().trim().length() != 0) {
			statement.append("    and (POProject.proj_id like ? or POProject.proj_name like ?) ");
			
			sqlExec.addParam("%" + apForm.getPoProject() + "%");
			sqlExec.addParam("%" + apForm.getPoProject() + "%");
		}
		
		if (apForm.getDepartment() != null && apForm.getDepartment().trim().length() != 0) {
			PartyHelper ph = new PartyHelper();
			String PartyListStr = "''";
			if (!apForm.getDepartment().trim().equals("")) {
				List partyList_dep=ph.getAllSubPartysByPartyId(
						Hibernate2Session.currentSession(), apForm.getDepartment());
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'"+apForm.getDepartment()+"'";
				while (itdep.hasNext()) {
					Party p =(Party)itdep.next();
					PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
				}
			}
			statement.append(" and POProject.dep_id in ("+ PartyListStr +") ");
		} else {
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			statement.append(" and POProject.proj_pm_user = ? ");
			sqlExec.addParam(ul.getUserLoginId());
		}
		
		statement.append("  group by vendor.description, ");
		statement.append("           vendor.party_id, ");
		statement.append("           contractProject.proj_id, ");
		statement.append("           contractProject.proj_name, ");
		statement.append("           POProject.proj_id, ");
		statement.append("           POProject.proj_name, ");
		statement.append("           supplierInvoice.pay_code, ");
		statement.append("           supplierInvoice.pay_type, ");
		statement.append("           department.description, ");
		statement.append("           supplierInvoice.pay_amount, ");
		statement.append("           supplierInvoice.exchange_rate, ");
		statement.append("           supplierInvoice.pay_date ");
		statement.append("    having (supplierInvoice.pay_amount * supplierInvoice.exchange_rate) <> sum(isnull(postPaymentTransaction.pay_amount * postPaymentTransaction.curr_rate, 0)) ");
		statement.append("  order by vendor.description, ");
		statement.append("           vendor.party_id, ");
		statement.append("           contractProject.proj_id, ");
		statement.append("           POProject.proj_id, ");
		statement.append("           supplierInvoice.pay_code ");
		
		log.info(statement.toString());
		
		return sqlExec.runQueryCloseCon(statement.toString());
	}
	
	private ActionForward ExportToExcel(APAgingRptForm apForm, 
			                            HttpServletRequest request, 
										HttpServletResponse response){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			
			java.util.Date day = UtilDateTime.toDate2(apForm.getDate() + " 00:00:00.000");
			
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sqlResult = findQueryResult(apForm, request);
			if (sqlResult == null || sqlResult.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			
			HSSFCell cell = null;
			cell = sheet.getRow(0).getCell((short)8);
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
			cell.setCellValue(dateFormat.format(day));

			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
			
			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			double totalAmount = 0L;
			for (int row =0; row < sqlResult.getRowCount(); row++) {
				double supplierInvoiceAmount = sqlResult.getDouble(row, "supplierInvoiceAmount");
				double paidAmount = sqlResult.getDouble(row, "paidAmount");
				
				//if(Math.abs(supplierInvoiceAmount-paidAmount)<1)	continue;
				
				Date dueDate = sqlResult.getDate(row, "dueDate");
				long dayDiff = UtilDateTime.getDayDistance(day, dueDate);
				
				double outstandingAmt = 0L;
				double currAmt = 0L;
				double between31To60Amt = 0L;
				double between61To90Amt = 0L;
				double between91To120Amt = 0L;
				double between121To150Amt = 0L;
				double between151To180Amt = 0L;
				double between181To210Amt = 0L;
				double between211To360Amt = 0L;
				double over360Amt = 0L;
				outstandingAmt += supplierInvoiceAmount - paidAmount;
				totalAmount += supplierInvoiceAmount - paidAmount;
				if (dayDiff <= 30) {
					currAmt += supplierInvoiceAmount - paidAmount;
				} else if (dayDiff > 30 && dayDiff <= 60) {
					between31To60Amt += supplierInvoiceAmount - paidAmount;
				} else if (dayDiff > 60 && dayDiff <= 90) {
					between61To90Amt += supplierInvoiceAmount - paidAmount;
				} else if (dayDiff > 90 && dayDiff <= 120) {
					between91To120Amt += supplierInvoiceAmount - paidAmount;
				} else if (dayDiff > 120 && dayDiff <= 150) {
					between121To150Amt += supplierInvoiceAmount - paidAmount;
				} else if (dayDiff > 150 && dayDiff <= 180) {
					between151To180Amt += supplierInvoiceAmount - paidAmount;
				} else if (dayDiff > 180 && dayDiff <= 210) {
					between181To210Amt += supplierInvoiceAmount - paidAmount;
				} else if (dayDiff > 210 && dayDiff <= 360) {
					between211To360Amt += supplierInvoiceAmount - paidAmount;
				} else {
					over360Amt += supplierInvoiceAmount - paidAmount;
				}
					
				HRow = sheet.createRow(ExcelRow);
				cell = HRow.createCell((short)0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "vendorNm"));
				cell.setCellStyle(boldTextStyle);
				
				cell = HRow.createCell((short)1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "contractProjectId") + ":" + sqlResult.getString(row, "contractProjectNm"));
				cell.setCellStyle(boldTextStyle);
				
				cell = HRow.createCell((short)2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "POProjectId") + ":" + sqlResult.getString(row, "POProjectNm"));
				cell.setCellStyle(boldTextStyle);
				
				cell = HRow.createCell((short)3);
				cell.setCellValue(sqlResult.getString(row, "supplierInvoiceNo"));
				cell.setCellStyle(boldTextStyle);
				
				cell = HRow.createCell((short)4);
				cell.setCellValue(sqlResult.getString(row, "supplierInvoicePayType"));
				cell.setCellStyle(boldTextStyle);
				
				cell = HRow.createCell((short)5);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "departmentNm"));
				cell.setCellStyle(boldTextStyle);
				
				cell = HRow.createCell((short)6);
				cell.setCellValue(outstandingAmt);
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)7);
				if (currAmt != 0L) {
					cell.setCellValue(currAmt);
				}
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)8);
				if (between31To60Amt != 0L) {
					cell.setCellValue(between31To60Amt);
				}
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)9);
				if (between61To90Amt != 0L) {
					cell.setCellValue(between61To90Amt);
				}
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)10);
				if (between91To120Amt != 0L) {
					cell.setCellValue(between91To120Amt);
				}
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)11);
				if (between121To150Amt != 0L) {
					cell.setCellValue(between121To150Amt);
				}
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)12);
				if (between151To180Amt != 0L) {
					cell.setCellValue(between151To180Amt);
				}
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)13);
				if (between181To210Amt != 0L) {
					cell.setCellValue(between181To210Amt);
				}
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)14);
				if (between211To360Amt != 0L) {
					cell.setCellValue(between211To360Amt);
				}
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)15);
				if (over360Amt != 0L) {
					cell.setCellValue(over360Amt);
				}
				cell.setCellStyle(numberFormatStyle);
				
				ExcelRow++;
			}
			
			cell = sheet.getRow(3).getCell((short)12);
			cell.setCellValue(totalAmount);
			
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
