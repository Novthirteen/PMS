/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.bill;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;
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
import com.aof.webapp.action.prm.report.ReportBaseAction;
import com.aof.webapp.form.prm.bill.FindBillingInstructionForm;

/**
 * @author Jackey Ding
 * @version 2005-03-16
 * 
 */
public class FindBillingInstructionAction extends ReportBaseAction {

	private Logger log = Logger.getLogger(FindBillingInstructionAction.class);

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		try {
			long timeStart = System.currentTimeMillis(); // for performance
			// test
			String action = request.getParameter("action");
			// String offSetStr = request.getParameter("offSet");
			// String recordPerPageStr = request.getParameter("recordPerPage");

			Session session = Hibernate2Session.currentSession();
			PartyHelper ph = new PartyHelper();

			if (action != null) {
				// int offSet = 0;
				// int recordPerPage = 10;

				// if (offSetStr != null && offSetStr.trim().length() != 0) {
				// offSet = Integer.parseInt(offSetStr);
				// }
				// if (recordPerPageStr != null &&
				// recordPerPageStr.trim().length() != 0) {
				// recordPerPage = Integer.parseInt(recordPerPageStr);
				// }

				// if (action != null) {
				FindBillingInstructionForm fbiForm = (FindBillingInstructionForm) form;

				if (fbiForm.getDepartment() == null) {
					UserLogin userLogin = (UserLogin) request.getSession().getAttribute(
							Constants.USERLOGIN_KEY);
					if (userLogin != null) {
						fbiForm.setDepartment(userLogin.getParty().getPartyId());
					}
				}

				SQLExecutor sqlExec = new SQLExecutor(Persistencer
						.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));

				StringBuffer statement = new StringBuffer("");

				// select statement
				statement.append(" select billing.bill_id as bill_id, ");
				statement.append("        billing.bill_code as bill_code, ");
				statement.append("        billing.bill_type as bill_type, ");
				statement.append("        billing.proj_id as proj_id, ");
				statement.append("        billing.proj_name as proj_name, ");
				statement.append("        billing.proj_contract_no as proj_contract_no, ");
				statement.append("        billing.contracttype as contracttype, ");
				statement.append("        billing.pmId as pmId, ");
				statement.append("        billing.pmName as pmName, ");
				statement.append("        billing.billAddrId as billAddrId, ");
				statement.append("        billing.billAddr as billAddr, ");
				statement.append("        billing.departmentId as departmentId, ");
				statement.append("        billing.department as department, ");
				statement.append("        billing.cafAmount as cafAmount, ");
				statement.append("        billing.allowanceAmount as allowanceAmount, ");
				statement.append("        billing.expenseAmount as expenseAmount, ");
				statement.append("        billing.acceptanceAmount as acceptanceAmount, ");
				statement.append("        billing.creditDownPayAmount as creditDownPayAmount, ");
				statement.append("        billing.bill_calamount as bill_calamount, ");
				statement
						.append("        case when (invoice.inv_status = 'cancelled') then 0 when (invoice.inv_status <> 'cancelled') then sum(invoice.inv_amount) end  as invoicedAmount, ");
				statement.append("        billing.bill_status as bill_status, ");
				statement.append("        billing.bill_createDate as bill_createDate ");
				statement.append("   from (");
				statement.append(" select pb.bill_id as bill_id, ");
				statement.append("        pb.bill_code as bill_code, ");
				statement.append("        pb.bill_type as bill_type, ");
				statement.append("        pm.proj_id as proj_id, ");
				statement.append("        pm.proj_name as proj_name, ");
				statement.append("        pm.proj_contract_no as proj_contract_no, ");
				statement.append("        pm.contracttype as contracttype, ");
				statement.append("        ul.user_login_id as pmId, ");
				statement.append("        ul.name as pmName, ");
				statement.append("        p1.party_id as billAddrId, ");
				statement.append("        p1.description as billAddr, ");
				statement.append("        p2.party_id as departmentId, ");
				statement.append("        p2.description as department, ");
				statement
						.append("        sum(case when ptd.tr_category = ? then ptd.tr_amount else 0 end) as cafAmount, ");
				statement
						.append("        sum(case when ptd.tr_category = ? then ptd.tr_amount else 0 end) as allowanceAmount, ");
				statement
						.append("        sum(case when (ptd.tr_category = ? or ptd.tr_category = ?) then ptd.tr_amount else 0 end) as expenseAmount, ");
				statement
						.append("        sum(case when ptd.tr_category = ? then ptd.tr_amount else 0 end) as acceptanceAmount, ");
				statement
						.append("        sum(case when ptd.tr_category = ? then ptd.tr_amount else 0 end) as creditDownPayAmount, ");
				statement.append("        pb.bill_calamount as bill_calamount, ");
				statement.append("        pb.bill_status as bill_status, ");
				statement.append("        pb.bill_createDate as bill_createDate ");

				// set parameters
				sqlExec.addParam(Constants.TRANSACATION_CATEGORY_CAF);
				sqlExec.addParam(Constants.TRANSACATION_CATEGORY_ALLOWANCE);
				sqlExec.addParam(Constants.TRANSACATION_CATEGORY_EXPENSE);
				sqlExec.addParam(Constants.TRANSACATION_CATEGORY_OTHER_COST);
				sqlExec.addParam(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE);
				sqlExec.addParam(Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);

				// from setatement
				statement.append("   from proj_bill as pb ");
				statement.append("  inner join proj_mstr as pm on pb.bill_proj_id = pm.proj_id ");
				statement
						.append("  inner join user_login as ul on ul.user_login_id = pm.proj_pm_user ");
				statement.append("  inner join party as p1 on p1.party_id = pb.bill_addr ");
				statement.append("  inner join party as p2 on p2.party_id = pm.dep_id ");
				statement.append("  inner join party as p3 on p3.party_id = pm.cust_id ");
				statement.append("   left join proj_tr_det as ptd on pb.bill_id = ptd.tr_mstr_id ");

				// where statement
				String PartyListStr = "''";
				List partyList_dep = ph.getAllSubPartysByPartyId(session, fbiForm.getDepartment());
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'" + fbiForm.getDepartment() + "'";
				while (itdep.hasNext()) {
					Party p = (Party) itdep.next();
					PartyListStr = PartyListStr + ", '" + p.getPartyId() + "'";
				}
				statement.append("  where p2.party_id in (" + PartyListStr + ") ");
				if (!"showDialog".equals(action)) {
					statement.append(" and pb.bill_type = ? ");
					if (request.getAttribute("BillingType") != null
							&& ((String) request.getAttribute("BillingType"))
									.equals(Constants.BILLING_TYPE_DOWN_PAYMENT)) {
						sqlExec.addParam(Constants.BILLING_TYPE_DOWN_PAYMENT);
					} else {
						sqlExec.addParam(Constants.BILLING_TYPE_NORMAL);
					}
				}

				if (fbiForm.getStatus() != null && fbiForm.getStatus().trim().length() != 0) {
					statement.append(" and pb.bill_status = ? ");

					sqlExec.addParam(fbiForm.getStatus());
					// } else {
					// if ("showDialog".equals(action)) {
					// statement.append(" and pb.bill_status <> ? ");

					// sqlExec.addParam(Constants.BILLING_STATUS_COMPLETED);
					// }
				}

				if (fbiForm.getBillCode() != null && fbiForm.getBillCode().trim().length() != 0) {
					statement.append(" and pb.bill_code like ? ");

					sqlExec.addParam("%" + fbiForm.getBillCode() + "%");
				}

				if (fbiForm.getCustomer() != null && fbiForm.getCustomer().trim().length() != 0) {
					statement.append(" and (p3.party_id like ? or p3.description like ?) ");

					sqlExec.addParam("%" + fbiForm.getCustomer() + "%");
					sqlExec.addParam("%" + fbiForm.getCustomer() + "%");
				}

				if (fbiForm.getBillTo() != null && fbiForm.getBillTo().trim().length() != 0) {
					statement.append(" and (p1.party_id like ? or p1.description like ?) ");

					sqlExec.addParam("%" + fbiForm.getBillTo() + "%");
					sqlExec.addParam("%" + fbiForm.getBillTo() + "%");
				}

				if (fbiForm.getProject() != null && fbiForm.getProject().trim().length() != 0) {
					statement.append(" and (pm.proj_id like ? or pm.proj_name like ?) ");

					sqlExec.addParam("%" + fbiForm.getProject() + "%");
					sqlExec.addParam("%" + fbiForm.getProject() + "%");
				}

				// group by
				statement.append("  group by pb.bill_id, ");
				statement.append("           pb.bill_code, ");
				statement.append("           pb.bill_type, ");
				statement.append("           pm.proj_id, ");
				statement.append("           pm.proj_name, ");
				statement.append("           pm.proj_contract_no, ");
				statement.append("           pm.contracttype, ");
				statement.append("           ul.user_login_id, ");
				statement.append("           ul.name, ");
				statement.append("           p1.party_id, ");
				statement.append("           p1.description, ");
				statement.append("           p2.party_id, ");
				statement.append("           p2.description, ");
				statement.append("           pb.bill_calamount, ");
				statement.append("           pb.bill_status, ");
				statement.append("           pb.bill_createDate ");
				statement.append("       ) as billing ");
				statement
						.append("   left join proj_invoice as invoice on billing.bill_id = invoice.inv_bill_id  ");
				statement.append("  group by billing.bill_id, ");
				statement.append("           billing.bill_code, ");
				statement.append("           billing.bill_type, ");
				statement.append("           billing.proj_id, ");
				statement.append("           billing.proj_name, ");
				statement.append("           billing.proj_contract_no, ");
				statement.append("           billing.contracttype, ");
				statement.append("           billing.pmId, ");
				statement.append("           billing.pmName, ");
				statement.append("           billing.billAddrId, ");
				statement.append("           billing.billAddr, ");
				statement.append("           billing.departmentId, ");
				statement.append("           billing.department, ");
				statement.append("           billing.cafAmount, ");
				statement.append("           billing.allowanceAmount, ");
				statement.append("           billing.expenseAmount, ");
				statement.append("           billing.acceptanceAmount, ");
				statement.append("           billing.creditDownPayAmount, ");
				statement.append("           billing.bill_calamount, ");
				statement.append("           billing.bill_status, ");
				statement.append("           billing.bill_createDate , invoice.Inv_Status");
				// order by
				statement.append("  order by billing.proj_id ");

				log.info(statement.toString());
				SQLResults result = null;
				result = sqlExec.runQueryCloseCon(statement.toString());
				request.setAttribute("QueryList", result);

				if (action.equals("export")) {
					if (result != null && result.getRowCount() > 0) {
						return exportExcel(request, response, result);
					}
				}
			}

			List partyList = null;
			UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			partyList = ph.getAllSubPartysByPartyId(session, ul.getParty().getPartyId());
			if (partyList == null)
				partyList = new ArrayList();
			partyList.add(0, ul.getParty());

			request.setAttribute("PartyList", partyList);

			long timeEnd = System.currentTimeMillis(); // for performance test
			log.info("it takes " + (timeEnd - timeStart) + " ms to excute the query...");

			if ("showDialog".equals(action)) {
				return mapping.findForward("showDialog");
			}

		} catch (Exception e) {
			log.error(e.getMessage());
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

		return mapping.findForward("success");
	}

	private ActionForward exportExcel(HttpServletRequest request, HttpServletResponse response,
			SQLResults result) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return null;
			}

			// Get Excel Template Path
			String templatePath = GetTemplateFolder();
			if (templatePath == null) {
				return null;
			}

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName
					+ "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(templatePath + "\\"
					+ ExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			// Header
			HSSFCell cell = null;

			// Style
			HSSFCellStyle centerStyle = sheet.getRow(1).getCell((short) 0).getCellStyle();
			HSSFCellStyle textStyle = sheet.getRow(1).getCell((short) 1).getCellStyle();
			HSSFCellStyle numStyle = sheet.getRow(1).getCell((short) 8).getCellStyle();
			numStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);

			int excelRow = ListStartRow;
			HSSFRow HRow = null;

			for (int row = 0; row < result.getRowCount(); row++) {

				HRow = sheet.createRow(excelRow);

				cell = HRow.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(row + 1);
				cell.setCellStyle(centerStyle);

				cell = HRow.createCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getString(row, "bill_code") == null ? "" : result
						.getString(row, "bill_code"));
				cell.setCellStyle(textStyle);

				String projDesc = "";
				if (result.getString(row, "proj_id") != null) {
					projDesc += result.getString(row, "proj_id");
				}
				if (result.getString(row, "proj_name") != null) {
					projDesc += ":" + result.getString(row, "proj_name");
				}
				cell = HRow.createCell((short) 2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(projDesc);
				cell.setCellStyle(textStyle);

				cell = HRow.createCell((short) 3);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getString(row, "proj_contract_no") == null ? "" : result
						.getString(row, "proj_contract_no"));
				cell.setCellStyle(textStyle);

				String conType = "";
				if (result.getString(row, "contracttype").equals("FP")) {
					conType = "Fixed Price";
				} else {
					conType = "Time & Material";
				}
				cell = HRow.createCell((short) 4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(conType);
				cell.setCellStyle(textStyle);

				cell = HRow.createCell((short) 5);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getString(row, "pmName") == null ? "" : result.getString(
						row, "pmName"));
				cell.setCellStyle(textStyle);

				cell = HRow.createCell((short) 6);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getString(row, "billAddr") == null ? "" : result
						.getString(row, "billAddr"));
				cell.setCellStyle(textStyle);

				cell = HRow.createCell((short) 7);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getString(row, "department") == null ? "" : result
						.getString(row, "department"));
				cell.setCellStyle(textStyle);

				cell = HRow.createCell((short) 8);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getDouble(row, "cafAmount"));
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 9);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getDouble(row, "allowanceAmount"));
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 10);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getDouble(row, "expenseAmount"));
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 11);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getDouble(row, "acceptanceAmount"));
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 12);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getDouble(row, "creditDownPayAmount"));
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 13);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getDouble(row, "bill_calamount"));
				cell.setCellStyle(numStyle);

				double remainAmt = 0.0;
				remainAmt = result.getDouble(row, "bill_calamount")
						- result.getDouble(row, "invoicedAmount");
				cell = HRow.createCell((short) 14);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(remainAmt);
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 15);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getString(row, "bill_status") == null ? "" : result
						.getString(row, "bill_status"));
				cell.setCellStyle(centerStyle);

				cell = HRow.createCell((short) 16);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getString(row, "bill_createDate") == null ? "" : result
						.getString(row, "bill_createDate"));
				cell.setCellStyle(centerStyle);

				excelRow++;
			}

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

	private final static String ExcelTemplate = "BillingInstruction.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Billing Instruction.xls";

	private final int ListStartRow = 1;
}