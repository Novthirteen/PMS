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
import com.aof.util.UtilFormat;
import com.aof.util.UtilString;
import com.aof.webapp.form.prm.report.ARAgingRptForm;

/**
 * cn01446 password
 * 
 * @author CN01458
 * @version 2005-5-30
 */
public class ARAgingRptAction extends ReportBaseAction {

	private final static String ExcelTemplate = "ARAgingReport.xls";

	private final static String SummarizedExcelTemplate = "SARAgingReport.xls";

	private final static String ProjectTrackingExcelTemplate = "PTARAgingReport.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "AR Aging Report.xls";

	private final static String SaveToFileName2 = "Summarized AR Aging Report.xls";

	private final static String SaveToFileName3 = "Project-Tracking AR Aging Report.xls";

	private final int ListStartRow = 7;

	private Log log = LogFactory.getLog(ARAgingRptAction.class);

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		ARAgingRptForm aaForm = (ARAgingRptForm) form;

		try {
			if ("QueryForList".equals(aaForm.getFormAction())) {
				request.setAttribute("QryList", findQueryResult(aaForm, request));
			}

			if ("ExportToExcel".equals(aaForm.getFormAction())) {
				return ExportToExcel(aaForm, request, response);
			}
			if ("ExportToSummarizedExcel".equals(aaForm.getFormAction())) {
				return ExportToSummarizedExcel(aaForm, request, response);
			}
			if ("ExportToPTExcel".equals(aaForm.getFormAction())) {
				return ExportToPTExcel(aaForm, request, response);
			}
			List partyList = null;
			PartyHelper ph = new PartyHelper();
			UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			partyList = ph
					.getAllSubPartysByPartyId(Hibernate2Session.currentSession(), ul.getParty().getPartyId());
			if (partyList == null)
				partyList = new ArrayList();
			partyList.add(0, ul.getParty());
			request.setAttribute("PartyList", partyList);

			return (mapping.findForward("success"));

		} catch (Exception e) {
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

	private SQLResults findQueryResult(ARAgingRptForm aaForm, HttpServletRequest request)
			throws HibernateException, GeneralException {
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));

		StringBuffer statement = new StringBuffer("");
		statement.append(" select branch.acc_desc as customerBranch, ");
		statement.append("        billto.description as billTo, ");
		statement.append("        customer.description as customer, ");
		statement.append("        project.proj_id as projectId, ");
		statement.append("        project.proj_name as projectName, ");
		statement.append("        department.description as department, ");
		statement.append("        invoice.inv_id as invoiceID, ");
		statement.append("        invoice.inv_code as inoviceCode, ");
		statement.append("        (invoice.inv_amount * invoice.inv_curr_rate) as invoiceAmount, ");
		statement.append("        sum(isnull(receipt.receive_Amount, 0)) as receiveAmount, ");
		statement.append("        dateadd(day, ?, invoice.inv_invoicedate) as dueDate ");
		statement.append("   from proj_invoice as invoice ");
		statement.append("  inner join party as billto on invoice.inv_billaddr = billto.party_id ");
		statement.append("  inner join custprofile as cp on billto.party_id = cp.party_id ");
		statement.append("  inner join customer_account as branch on cp.cust_account = branch.acc_id ");
		statement.append("  inner join proj_mstr as project on invoice.inv_proj_id = project.proj_id ");
		statement.append("  inner join party as customer on project.cust_id = customer.party_id ");
		statement.append("  inner join party as department on project.dep_id = department.party_id ");
		statement.append("   left join proj_receipt as receipt on invoice.inv_id = receipt.invoice_id ");
		statement.append("  where dateadd(day, ?, invoice.inv_invoicedate) <= ? ");
		statement.append("    and (receipt.receive_date <= ? or receipt.receive_date is null) ");
		statement.append("    and invoice.inv_status <> ? ");
		statement.append("    and invoice.inv_type = ? ");

		sqlExec.addParam(0);
		sqlExec.addParam(0);
		sqlExec.addParam(new Date(UtilDateTime.toDate2(aaForm.getDate() + " 00:00:00.000").getTime()));
		sqlExec.addParam(new Date(UtilDateTime.toDate2(aaForm.getDate() + " 23:59:59.999").getTime()));
		sqlExec.addParam(Constants.INVOICE_STATUS_CANCELED);
		sqlExec.addParam(Constants.INVOICE_TYPE_NORMAL);

		if (aaForm.getCustomerBranch() != null && aaForm.getCustomerBranch().trim().length() != 0) {
			statement.append("    and (branch.acc_id like ? or branch.acc_desc like ?) ");

			sqlExec.addParam("%" + aaForm.getCustomerBranch() + "%");
			sqlExec.addParam("%" + aaForm.getCustomerBranch() + "%");
		}

		if (aaForm.getBillTo() != null && aaForm.getBillTo().trim().length() != 0) {
			statement.append("    and (billto.party_id like ? or billto.description like ?) ");

			sqlExec.addParam("%" + aaForm.getBillTo() + "%");
			sqlExec.addParam("%" + aaForm.getBillTo() + "%");
		}

		if (aaForm.getCustomer() != null && aaForm.getCustomer().trim().length() != 0) {
			statement.append("    and (customer.party_id like ? or customer.description like ?) ");

			sqlExec.addParam("%" + aaForm.getCustomer() + "%");
			sqlExec.addParam("%" + aaForm.getCustomer() + "%");
		}

		if (aaForm.getProject() != null && aaForm.getProject().trim().length() != 0) {
			statement.append("    and (project.proj_id like ? or project.proj_name like ?) ");

			sqlExec.addParam("%" + aaForm.getProject() + "%");
			sqlExec.addParam("%" + aaForm.getProject() + "%");
		}

		if (aaForm.getDepartment() != null && aaForm.getDepartment().trim().length() != 0) {
			PartyHelper ph = new PartyHelper();
			String PartyListStr = "''";
			if (!aaForm.getDepartment().trim().equals("")) {
				List partyList_dep = ph.getAllSubPartysByPartyId(Hibernate2Session.currentSession(), aaForm
						.getDepartment());
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'" + aaForm.getDepartment() + "'";
				while (itdep.hasNext()) {
					Party p = (Party) itdep.next();
					PartyListStr = PartyListStr + ", '" + p.getPartyId() + "'";
				}
			}
			statement.append(" and project.dep_id in (" + PartyListStr + ") ");
		} else {
			UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			statement.append(" and project.proj_pm_user = ? ");
			sqlExec.addParam(ul.getUserLoginId());
		}

		statement.append("  group by branch.acc_desc, ");
		statement.append("           billto.description, ");
		statement.append("           customer.description, ");
		statement.append("           project.proj_id, ");
		statement.append("           project.proj_name, ");
		statement.append("           department.description, ");
		statement.append("           invoice.Inv_id, ");
		statement.append("           invoice.inv_code, ");
		statement.append("           invoice.inv_amount, ");
		statement.append("           invoice.inv_curr_rate, ");
		statement.append("           invoice.inv_invoicedate ");
		statement
				.append("    having (invoice.inv_amount * invoice.inv_curr_rate) <> sum(isnull(receipt.receive_Amount, 0) * isnull(receipt.curr_rate, 1)) ");
		statement.append("  order by branch.acc_desc, ");
		statement.append("           billto.description, ");
		statement.append("           customer.description, ");
		statement.append("           project.proj_id, ");
		statement.append("           project.proj_name, ");
		statement.append("           department.description, ");
		statement.append("           invoice.inv_code ");

		log.info(statement.toString());

		return sqlExec.runQueryCloseCon(statement.toString());
	}

	private ActionForward ExportToExcel(ARAgingRptForm aaForm, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return null;
			}

			java.util.Date day = UtilDateTime.toDate2(aaForm.getDate() + " 00:00:00.000");

			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			SQLResults sqlResult = findQueryResult(aaForm, request);
			if (sqlResult == null || sqlResult.getRowCount() == 0)
				return null;

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName + "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\" + ExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			HSSFCell cell = null;
			cell = sheet.getRow(0).getCell((short) 8);
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
			cell.setCellValue(dateFormat.format(day));

			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short) 0).getCellStyle();

			HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow).getCell((short) 6).getCellStyle();

			// String currProj = null;
			// String nextProj = null;

			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			double totalAmount = 0L;
			for (int row = 0; row < sqlResult.getRowCount(); row++) {
				double invoiceAmount = sqlResult.getDouble(row, "invoiceAmount");
				double receiveAmount = sqlResult.getDouble(row, "receiveAmount");
				if (Math.abs(invoiceAmount - receiveAmount) < 1)
					continue;
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
				outstandingAmt += invoiceAmount - receiveAmount;
				totalAmount += invoiceAmount - receiveAmount;
				if (dayDiff <= 30) {
					currAmt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 30 && dayDiff <= 60) {
					between31To60Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 60 && dayDiff <= 90) {
					between61To90Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 90 && dayDiff <= 120) {
					between91To120Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 120 && dayDiff <= 150) {
					between121To150Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 150 && dayDiff <= 180) {
					between151To180Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 180 && dayDiff <= 210) {
					between181To210Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 210 && dayDiff <= 360) {
					between211To360Amt += invoiceAmount - receiveAmount;
				} else {
					over360Amt += invoiceAmount - receiveAmount;
				}

				HRow = sheet.createRow(ExcelRow);
				cell = HRow.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "customerBranch"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "billTo"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "customer"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 3);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "projectId") + ":"
						+ sqlResult.getString(row, "projectName"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 4);
				cell.setCellValue(sqlResult.getString(row, "inoviceCode"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 5);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "department"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 6);
				cell.setCellValue(outstandingAmt);
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 7);
				if (currAmt != 0L) {
					cell.setCellValue(currAmt);
				}
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 8);
				if (between31To60Amt != 0L) {
					cell.setCellValue(between31To60Amt);
				}
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 9);
				if (between61To90Amt != 0L) {
					cell.setCellValue(between61To90Amt);
				}
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 10);
				if (between91To120Amt != 0L) {
					cell.setCellValue(between91To120Amt);
				}
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 11);
				if (between121To150Amt != 0L) {
					cell.setCellValue(between121To150Amt);
				}
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 12);
				if (between151To180Amt != 0L) {
					cell.setCellValue(between151To180Amt);
				}
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 13);
				if (between181To210Amt != 0L) {
					cell.setCellValue(between181To210Amt);
				}
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 14);
				if (between211To360Amt != 0L) {
					cell.setCellValue(between211To360Amt);
				}
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 15);
				if (over360Amt != 0L) {
					cell.setCellValue(over360Amt);
				}
				cell.setCellStyle(numberFormatStyle);

				ExcelRow++;
			}

			cell = sheet.getRow(3).getCell((short) 12);
			cell.setCellValue(totalAmount);

			// 写入Excel工作表
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.setStatus(HttpServletResponse.SC_OK);
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private ActionForward ExportToSummarizedExcel(ARAgingRptForm aaForm, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return null;
			}

			java.util.Date day = UtilDateTime.toDate2(aaForm.getDate() + " 00:00:00.000");

			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			SQLResults sqlResult = findQueryResult(aaForm, request);
			if (sqlResult == null || sqlResult.getRowCount() == 0)
				return null;

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName2 + "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\" + SummarizedExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			HSSFCell cell = null;
			cell = sheet.getRow(0).getCell((short) 9);
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
			cell.setCellValue(dateFormat.format(day));

			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short) 0).getCellStyle();
			HSSFCellStyle Style1 = sheet.getRow(3).getCell((short) 9).getCellStyle();
			HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow).getCell((short) 2).getCellStyle();

			// String currProj = null;
			// String nextProj = null;

			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			double totalAmount = 0L;
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
			String lastCustomerBranch = "";

			// ArrayList billtoList = new ArrayList();

			for (int row = 0; row < sqlResult.getRowCount(); row++) {

				String newCustomerBranch = sqlResult.getString(row, "customerBranch");
				String newBillTo = sqlResult.getString(row, "billTo");
				double invoiceAmount = sqlResult.getDouble(row, "invoiceAmount");
				double receiveAmount = sqlResult.getDouble(row, "receiveAmount");
				if (Math.abs(invoiceAmount - receiveAmount) < 1) {

				} else {
					Date dueDate = sqlResult.getDate(row, "dueDate");
					long dayDiff = UtilDateTime.getDayDistance(day, dueDate);

					outstandingAmt += invoiceAmount - receiveAmount;
					totalAmount += invoiceAmount - receiveAmount;
					if (dayDiff <= 30) {
						currAmt += invoiceAmount - receiveAmount;
					} else if (dayDiff > 30 && dayDiff <= 60) {
						between31To60Amt += invoiceAmount - receiveAmount;
					} else if (dayDiff > 60 && dayDiff <= 90) {
						between61To90Amt += invoiceAmount - receiveAmount;
					} else if (dayDiff > 90 && dayDiff <= 120) {
						between91To120Amt += invoiceAmount - receiveAmount;
					} else if (dayDiff > 120 && dayDiff <= 150) {
						between121To150Amt += invoiceAmount - receiveAmount;
					} else if (dayDiff > 150 && dayDiff <= 180) {
						between151To180Amt += invoiceAmount - receiveAmount;
					} else if (dayDiff > 180 && dayDiff <= 210) {
						between181To210Amt += invoiceAmount - receiveAmount;
					} else if (dayDiff > 210 && dayDiff <= 360) {
						between211To360Amt += invoiceAmount - receiveAmount;
					} else {
						over360Amt += invoiceAmount - receiveAmount;
					}

					// if (!billtoList.contains(newBillTo)) {
					// billtoList.add(newBillTo);
					//						
					// }
				}

				String nextBillTo = row + 1 < sqlResult.getRowCount() ? sqlResult.getString(row + 1, "billTo")
						: null;
				if (((nextBillTo != null && !nextBillTo.equals(newBillTo)) || nextBillTo == null) 
						&& Math.abs(invoiceAmount - receiveAmount) >= 1) {
					HRow = sheet.createRow(ExcelRow);
					cell = HRow.createCell((short) 0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					if (!lastCustomerBranch.equals(newCustomerBranch)) {
						cell.setCellValue(sqlResult.getString(row, "customerBranch"));
					}
					cell.setCellStyle(boldTextStyle);

					cell = HRow.createCell((short) 1);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellValue(sqlResult.getString(row, "billTo"));
					cell.setCellStyle(boldTextStyle);

					cell = HRow.createCell((short) 2);
					cell.setCellValue(outstandingAmt);
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 3);
					cell.setCellStyle(numberFormatStyle);
					double pendingAmount = this.getPendingAmountForSAR(sqlResult.getString(row, "billTo"));
					if (pendingAmount > 0)
						cell.setCellValue(pendingAmount);

					cell = HRow.createCell((short) 4);
					if (currAmt != 0L) {
						cell.setCellValue(currAmt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 5);
					if (between31To60Amt != 0L) {
						cell.setCellValue(between31To60Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 6);
					if (between61To90Amt != 0L) {
						cell.setCellValue(between61To90Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 7);
					if (between91To120Amt != 0L) {
						cell.setCellValue(between91To120Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 8);
					if (between121To150Amt != 0L) {
						cell.setCellValue(between121To150Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 9);
					if (between151To180Amt != 0L) {
						cell.setCellValue(between151To180Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 10);
					if (between181To210Amt != 0L) {
						cell.setCellValue(between181To210Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 11);
					if (between211To360Amt != 0L) {
						cell.setCellValue(between211To360Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 12);
					if (over360Amt != 0L) {
						cell.setCellValue(over360Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					lastCustomerBranch = newCustomerBranch;
					ExcelRow++;
					outstandingAmt = 0L;
					currAmt = 0L;
					between31To60Amt = 0L;
					between61To90Amt = 0L;
					between91To120Amt = 0L;
					between121To150Amt = 0L;
					between151To180Amt = 0L;
					between181To210Amt = 0L;
					between211To360Amt = 0L;
					over360Amt = 0L;
				}
			}

			cell = sheet.getRow(3).getCell((short) 9);
			cell.setCellValue(totalAmount);
			cell.setCellStyle(Style1);

			// 写入Excel工作表
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.setStatus(HttpServletResponse.SC_OK);
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	private ActionForward ExportToPTExcel(ARAgingRptForm aaForm, HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return null;
			}

			java.util.Date day = UtilDateTime.toDate2(aaForm.getDate() + " 00:00:00.000");

			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			SQLResults sqlResult = findQueryResult(aaForm, request);
			if (sqlResult == null || sqlResult.getRowCount() == 0)
				return null;

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName3 + "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
					+ ProjectTrackingExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			HSSFCell cell = null;
			cell = sheet.getRow(0).getCell((short) 9);
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
			cell.setCellValue(dateFormat.format(day));

			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short) 0).getCellStyle();
			HSSFCellStyle Style1 = sheet.getRow(3).getCell((short) 9).getCellStyle();
			HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow).getCell((short) 2).getCellStyle();

			// String currProj = null;
			// String nextProj = null;

			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			double totalAmount = 0L;
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
			String lastCustomer = "";
			ArrayList projectList = new ArrayList();

			for (int row = 0; row < sqlResult.getRowCount(); row++) {

				String newCustomer = sqlResult.getString(row, "customer");
				String newProject = sqlResult.getString(row, "projectId");
				double invoiceAmount = sqlResult.getDouble(row, "invoiceAmount");
				double receiveAmount = sqlResult.getDouble(row, "receiveAmount");
				if (Math.abs(invoiceAmount - receiveAmount) < 1)
					continue;
				Date dueDate = sqlResult.getDate(row, "dueDate");
				long dayDiff = UtilDateTime.getDayDistance(day, dueDate);

				outstandingAmt += invoiceAmount - receiveAmount;
				totalAmount += invoiceAmount - receiveAmount;
				if (dayDiff <= 30) {
					currAmt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 30 && dayDiff <= 60) {
					between31To60Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 60 && dayDiff <= 90) {
					between61To90Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 90 && dayDiff <= 120) {
					between91To120Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 120 && dayDiff <= 150) {
					between121To150Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 150 && dayDiff <= 180) {
					between151To180Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 180 && dayDiff <= 210) {
					between181To210Amt += invoiceAmount - receiveAmount;
				} else if (dayDiff > 210 && dayDiff <= 360) {
					between211To360Amt += invoiceAmount - receiveAmount;
				} else {
					over360Amt += invoiceAmount - receiveAmount;
				}

				if (!projectList.contains(newProject)) {
					projectList.add(newProject);
					HRow = sheet.createRow(ExcelRow);
				} // else{
				String info[] = this.getLatestInfoByProject(newProject);
				String nextProject = row + 1 < sqlResult.getRowCount() ? sqlResult.getString(row + 1, "projectId")
						: null;
				if ((nextProject != null && !nextProject.equals(newProject)) || nextProject == null) {

					cell = HRow.createCell((short) 0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					if (!lastCustomer.equals(newCustomer)) {
						cell.setCellValue(sqlResult.getString(row, "customer"));
					}
					cell.setCellStyle(boldTextStyle);

					cell = HRow.createCell((short) 1);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellValue(sqlResult.getString(row, "projectId") + ":"
							+ sqlResult.getString(row, "projectName"));
					cell.setCellStyle(boldTextStyle);

					cell = HRow.createCell((short) 2);
					cell.setCellValue(outstandingAmt);
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 3);
					if (currAmt != 0L) {
						cell.setCellValue(currAmt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 4);
					if (between31To60Amt != 0L) {
						cell.setCellValue(between31To60Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 5);
					if (between61To90Amt != 0L) {
						cell.setCellValue(between61To90Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 6);
					if (between91To120Amt != 0L) {
						cell.setCellValue(between91To120Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 7);
					if (between121To150Amt != 0L) {
						cell.setCellValue(between121To150Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 8);
					if (between151To180Amt != 0L) {
						cell.setCellValue(between151To180Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 9);
					if (between181To210Amt != 0L) {
						cell.setCellValue(between181To210Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 10);
					if (between211To360Amt != 0L) {
						cell.setCellValue(between211To360Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 11);
					if (over360Amt != 0L) {
						cell.setCellValue(over360Amt);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 12);
					if (info[0] != null && !info[0].equals("")) {
						cell.setCellValue(info[0]);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 13);
					if (info[1] != null && !info[1].equals("")) {
						cell.setCellValue(info[1]);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 14);
					if (info[2] != null && !info[2].equals("") && !info[2].equals("0.00")) {
						double tmpValue = Double.parseDouble(UtilString.removeSymbol(info[2], ','));
						cell.setCellValue(tmpValue);
					}
					cell.setCellStyle(numberFormatStyle);

					cell = HRow.createCell((short) 15);
					if (info[3] != null && !info[3].equals("")) {
						cell.setCellValue(info[3]);
					}
					cell.setCellStyle(numberFormatStyle);

					lastCustomer = newCustomer;
					ExcelRow++;
					outstandingAmt = 0L;
					currAmt = 0L;
					between31To60Amt = 0L;
					between61To90Amt = 0L;
					between91To120Amt = 0L;
					between121To150Amt = 0L;
					between151To180Amt = 0L;
					between181To210Amt = 0L;
					between211To360Amt = 0L;
					over360Amt = 0L;
				}
				// }
			}
			cell = sheet.getRow(3).getCell((short) 9);
			cell.setCellValue(totalAmount);
			cell.setCellStyle(Style1);

			// 写入Excel工作表
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.setStatus(HttpServletResponse.SC_OK);
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	private String[] getLatestInfoByProject(String projId) {
		String[] info = new String[4];
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));
		String statement = "";
		statement += "select proj.proj_id,table1.note1,table1.date1,table2.amount2,table2.date2 ";
		statement += "from proj_mstr as proj ";
		statement += "left join ";
		statement += "( ";
		statement += "		select temp1.pid as pid1 , part.note as note1 ,part.create_date as date1 ";
		statement += "		from proj_artracking as part ";
		statement += "		inner join ";
		statement += "		(	select ";
		statement += "				project.proj_id as pid, ";
		statement += "				max(part.id) as partid ";
		statement += "				from proj_mstr as project ";
		statement += "				inner join proj_artracking as part on project.proj_id = part.proj_id ";
		statement += "				group by project.proj_id ";
		statement += "		) as temp1 on part.id=temp1.partid ";
		statement += ")as table1 on proj.proj_id = table1.pid1 ";
		statement += "left join ";
		statement += "( ";
		statement += "		select temp2.pid as pid2, r.receive_amount as amount2, r.receive_date as date2 ";
		statement += "		from proj_receipt as r ";
		statement += "		inner join ";
		statement += "		(	select ";
		statement += "				proj_id as pid, ";
		statement += "				max(receipt.receipt_id) as rid ";
		statement += "				from proj_mstr as project ";
		statement += "				inner join proj_invoice as invoice on project.proj_id = invoice.inv_proj_id ";
		statement += "				inner join proj_receipt as receipt on invoice.inv_id = receipt.invoice_id ";
		statement += "				group by proj_id ";
		statement += "		)as temp2 on r.receipt_id=temp2.rid ";
		statement += ")as table2 on proj.proj_id = table2.pid2 ";
		statement += "where proj.proj_id=? ";

		sqlExec.addParam(projId);
		SQLResults results = sqlExec.runQueryCloseCon(statement);
		info[0] = results.getString(0, 1); // tracking description
		info[1] = UtilFormat.format(results.getDate(0, 2)); // last tracking
		// date
		info[2] = UtilFormat.format(results.getDouble(0, 3)); // receive
		// amount
		info[3] = UtilFormat.format(results.getDate(0, 4)); // last receive date
		return info;
	}

	private double getPendingAmountForSAR(String billto) {
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));
		String statement = "";
		statement += " select sum(distinct m.receipt_amt * m.exchange_rate) - sum(isnull(r.receive_amount,0))";
		statement += " from proj_receipt_mstr as m";
		statement += " left join proj_receipt as r on m.receipt_no = r.receipt_no";
		statement += " inner join party as billto on m.customerid = billto.party_id";
		statement += " where billto.description = '" + billto + "'";

		SQLResults result = sqlExec.runQueryCloseCon(statement);
		if (result == null)
			return 0;
		return result.getDouble(0, 0);
	}

}
