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
import com.aof.util.GeneralException;
import com.aof.util.UtilDateTime;
import com.aof.webapp.form.prm.report.ARCustStatementRptForm;


/**
 * @author CN01458
 * @version 2005-6-2
 */
public class ARCustStatementRptAction extends ReportBaseAction {
	
	private final static String ExcelTemplate="Customer Statement.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Customer Statement.xls";
	private final int ListStartRow = 5;
	private Log log = LogFactory.getLog(ARCustStatementRptAction.class);
	
	public ActionForward execute (ActionMapping mapping,
	                              ActionForm form,
								  HttpServletRequest request,
								  HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();

		ARCustStatementRptForm acForm = (ARCustStatementRptForm)form;
		SQLResults sr = null;
		try {
			if ("QueryForList".equals(acForm.getFormAction())) {
				request.setAttribute("QryList",findQueryResult(acForm, request));
			}

			if ("ExportToExcel".equals(acForm.getFormAction())) {
				return ExportToExcel(acForm, request, response);
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
	
	private SQLResults findQueryResult(ARCustStatementRptForm acForm, HttpServletRequest request) throws HibernateException, GeneralException {
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		StringBuffer statement = new StringBuffer("");
		statement.append(" select total.billToId as billToId, ");
		statement.append("        total.billToName as billToName, ");
		statement.append("        total.customerName as customerName, ");
		statement.append("        total.contractNo as contractNo, ");
		statement.append("        total.invoiceID as invoiceID, ");
		statement.append("        total.invoiceDate as invoiceDate, ");
		statement.append("        total.invoiceNo as invoiceNo, ");
		statement.append("        total.amount as amount, ");
		statement.append("        total.amountOpen as amountOpen, ");
		statement.append("        total.currency as currency, ");
		statement.append("        receipt.receipt_id as receiptID, ");
		statement.append("        receipt.receipt_no as receiptNo, ");
		statement.append("        receipt.receive_amount as receiptAmount, ");
		statement.append("        receipt.receive_date as receiptdate ");
		statement.append("   from (select billto.party_id as billToId, ");
		statement.append("                billto.description as billToName, ");
		statement.append("                customer.description as customerName, ");
		statement.append("                project.proj_contract_no as contractNo, ");
		statement.append("                invoice.inv_id as invoiceID, ");
		statement.append("                invoice.inv_invoicedate as invoiceDate, ");
		statement.append("                invoice.inv_code as invoiceNo, ");
		statement.append("                invoice.inv_amount as amount, ");
		statement.append("                invoice.inv_amount - sum(isnull(receipt.receive_amount, 0)) as amountOpen, ");
		statement.append("                invoice.inv_curr_id as currency ");
		statement.append("           from proj_invoice as invoice ");
		statement.append("          inner join party as billto on invoice.inv_billaddr = billto.party_id ");
		statement.append("          inner join proj_mstr as project on invoice.inv_proj_id = project.proj_id ");
		statement.append("          inner join party as customer on project.cust_id = customer.party_id ");
		statement.append("           left join proj_receipt as receipt on invoice.inv_id = receipt.invoice_id ");
		statement.append("          where dateadd(day, ?, invoice.inv_invoicedate) < ? ");
		statement.append("            and (receipt.receive_date < ? or receipt.receive_date is null) ");
		statement.append("            and invoice.inv_status <> ? ");
		statement.append("            and invoice.inv_type = ? ");

		sqlExec.addParam(14);
		sqlExec.addParam(new Date(UtilDateTime.toDate2(acForm.getDate() + " 00:00:00.000").getTime()));
		sqlExec.addParam(new Date(UtilDateTime.toDate2(acForm.getDate() + " 23:59:59.999").getTime()));
		sqlExec.addParam(Constants.INVOICE_STATUS_CANCELED);
		sqlExec.addParam(Constants.INVOICE_TYPE_NORMAL);
		
		if (acForm.getBillTo() != null && acForm.getBillTo().trim().length() != 0) {
			statement.append("        and (billto.party_id like ? or billto.description like ?) ");
			
			sqlExec.addParam("%" + acForm.getBillTo() + "%");
			sqlExec.addParam("%" + acForm.getBillTo() + "%");
		}
		
		if (acForm.getCustomer() != null && acForm.getCustomer().trim().length() != 0) {
			statement.append("        and (customer.party_id like ? or customer.description like ?) ");
			
			sqlExec.addParam("%" + acForm.getCustomer() + "%");
			sqlExec.addParam("%" + acForm.getCustomer() + "%");
		}
		
		if (acForm.getContractNo() != null && acForm.getContractNo().trim().length() != 0) {
			statement.append("        and project.proj_contract_no like ? ");
			
			sqlExec.addParam("%" + acForm.getContractNo() + "%");
		}
		
		if (acForm.getDepartment() != null && acForm.getDepartment().trim().length() != 0) {
			PartyHelper ph = new PartyHelper();
			String PartyListStr = "''";
			if (!acForm.getDepartment().trim().equals("")) {
				List partyList_dep=ph.getAllSubPartysByPartyId(
						Hibernate2Session.currentSession(), acForm.getDepartment());
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'"+acForm.getDepartment()+"'";
				while (itdep.hasNext()) {
					Party p =(Party)itdep.next();
					PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
				}
			}
			statement.append("       and project.dep_id in ("+ PartyListStr +") ");
		} else {
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			statement.append("       and project.proj_pm_user = ? ");
			sqlExec.addParam(ul.getUserLoginId());
		}
		
		statement.append("         group by billto.party_id, ");
		statement.append("               billto.description, ");
		statement.append("               customer.description, ");
		statement.append("               project.proj_contract_no, ");
		statement.append("               invoice.inv_id, ");
		statement.append("               invoice.inv_invoicedate, ");
		statement.append("               invoice.inv_code, ");
		statement.append("               invoice.inv_amount, ");
		statement.append("               invoice.inv_curr_id ");
		if (acForm.getShow0AmtOpen() == null) {
			statement.append("        having invoice.inv_amount <> sum(isnull(receipt.receive_amount, 0)) ");
		}
		statement.append("        ) as total ");
		statement.append("   left join proj_receipt as receipt on total.invoiceID = receipt.invoice_id ");
		statement.append("  order by total.billToName, ");
		statement.append("           total.customerName, ");
		statement.append("           total.contractNo, ");
		statement.append("           total.invoiceNo, ");
		statement.append("           receipt.receipt_no ");
		//statement.append("        receipt.receipt_no ");
		
		log.info(statement.toString());
		
		return sqlExec.runQueryCloseCon(statement.toString());
	}
	
	private ActionForward ExportToExcel(ARCustStatementRptForm acForm, 
							            HttpServletRequest request, 
										HttpServletResponse response){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sqlResult = findQueryResult(acForm, request);
			if (sqlResult == null || sqlResult.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			
			HSSFCellStyle textFormatStyle = null;
			HSSFCellStyle dateFormatStyle = null;
			HSSFCellStyle numberFormatStyle = null;
			
			java.util.Date day = UtilDateTime.toDate2(acForm.getDate() + " 00:00:00.000");
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
			//HSSFSheet newsheet = wb.createSheet();
			//newsheet = wb.cloneSheet(0);
			String newBillTo = null;
			String oldBillTo = null;
			HSSFSheet sheet = null;
			HSSFRow HRow = null;
			HSSFCell cell = null;
			int sheetCount = 1;
			int ExcelRow = ListStartRow;
			String newInvoiceID = null;
			String oldInvoiceID = null;
			for (int row =0; row < sqlResult.getRowCount(); row++) {
				newBillTo = sqlResult.getString(row, "billToId");
				newInvoiceID = sqlResult.getString(row, "invoiceID");
				if (!newBillTo.equals(oldBillTo)) {
					//Clone the first worksheet
					sheet = wb.cloneSheet(0);
					
					String sheetNm = sqlResult.getString(row, "billToName");
					if (sheetNm.length() > 31) {
						sheetNm = sheetNm.substring(0, 31);
					}		
					wb.setSheetName(sheetCount++, sheetNm);
					textFormatStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
					dateFormatStyle = sheet.getRow(ListStartRow).getCell((short)2).getCellStyle();
					numberFormatStyle = sheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
					
					cell = sheet.getRow(0).getCell((short)7);
					cell.setCellValue(sqlResult.getString(row, "billToName"));
					
					cell = sheet.getRow(2).getCell((short)7);
					cell.setCellValue(dateFormat.format(day));

					ExcelRow = ListStartRow;
					oldBillTo = newBillTo;
					oldInvoiceID = null;
				}
				
				HRow = sheet.createRow(ExcelRow++);
				
				if (!newInvoiceID.equals(oldInvoiceID)) {
					oldInvoiceID = newInvoiceID;
					
					cell = HRow.createCell((short)0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sqlResult.getString(row, "customerName"));
					cell.setCellStyle(textFormatStyle);
					
					cell = HRow.createCell((short)1);
					cell.setCellValue(sqlResult.getString(row, "contractNo"));
					cell.setCellStyle(textFormatStyle);
					
					cell = HRow.createCell((short)2);
					cell.setCellValue(sqlResult.getDate(row, "invoiceDate"));
					cell.setCellStyle(dateFormatStyle);
					
					cell = HRow.createCell((short)3);
					cell.setCellValue(sqlResult.getString(row, "invoiceNo"));
					cell.setCellStyle(textFormatStyle);
					
					cell = HRow.createCell((short)4);
					cell.setCellValue(sqlResult.getDouble(row, "amount"));
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)5);
					cell.setCellValue(sqlResult.getDouble(row, "amountOpen"));
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)6);
					cell.setCellValue(sqlResult.getString(row, "currency"));
					cell.setCellStyle(textFormatStyle);
				} else {
					cell = HRow.createCell((short)0);
					cell.setCellStyle(textFormatStyle);
					
					cell = HRow.createCell((short)1);
					cell.setCellStyle(textFormatStyle);
					
					cell = HRow.createCell((short)2);
					cell.setCellStyle(dateFormatStyle);
					
					cell = HRow.createCell((short)3);
					cell.setCellStyle(textFormatStyle);
					
					cell = HRow.createCell((short)4);
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)5);
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)6);
					cell.setCellStyle(textFormatStyle);
				}
					
				if (sqlResult.getString(row, "receiptNo") != null) {
					cell = HRow.createCell((short)7);
					cell.setCellValue(sqlResult.getString(row, "receiptNo"));
					cell.setCellStyle(textFormatStyle);
					
					cell = HRow.createCell((short)8);
					cell.setCellValue(sqlResult.getDouble(row, "receiptAmount"));
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)9);
					cell.setCellValue(sqlResult.getDate(row, "receiptdate"));
					cell.setCellStyle(dateFormatStyle);
				} else {
					cell = HRow.createCell((short)7);
					//cell.setCellValue(sqlResult.getString(row, "receiptNo"));
					cell.setCellStyle(textFormatStyle);
					
					cell = HRow.createCell((short)8);
					//cell.setCellValue(sqlResult.getDouble(row, "receiptAmount"));
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)9);
					//cell.setCellValue(sqlResult.getDate(row, "receiptdate"));
					cell.setCellStyle(dateFormatStyle);
				}
			}
			//remove first sheet
			wb.removeSheetAt(0);
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
