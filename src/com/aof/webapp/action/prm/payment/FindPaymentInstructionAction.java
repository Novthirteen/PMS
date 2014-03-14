/*
 * Created on 2005-5-23
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.payment;

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
import com.aof.webapp.form.prm.payment.FindPaymentInstructionForm;

/**
 * @author CN01446 update 7-7-2005
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class FindPaymentInstructionAction extends ReportBaseAction {

	private Logger log = Logger.getLogger(FindPaymentInstructionAction.class);

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		try {
			long timeStart = System.currentTimeMillis(); // for performance
			// test
			String action = request.getParameter("action");

			Session session = Hibernate2Session.currentSession();
			PartyHelper ph = new PartyHelper();

			if (action != null) {

				FindPaymentInstructionForm fbiForm = (FindPaymentInstructionForm) form;

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
				statement.append(" select payment.pay_id as pay_id, ");
				statement.append("        payment.pay_code as pay_code, ");
				statement.append("        payment.pay_type as pay_type, ");
				statement.append("        payment.proj_id as proj_id, ");
				statement.append("        payment.proj_name as proj_name, ");
				statement.append("        payment.proj_contract_no as proj_contract_no, ");
				statement.append("        payment.contracttype as contracttype, ");
				statement.append("        payment.pmId as pmId, ");
				statement.append("        payment.pmName as pmName, ");
				statement.append("        payment.payAddrId as payAddrId, ");
				statement.append("        payment.payAddr as payAddr, ");
				statement.append("        payment.departmentId as departmentId, ");
				statement.append("        payment.department as department, ");
				statement.append("        payment.cafAmount as cafAmount, ");
				// statement.append(" payment.allowanceAmount as
				// allowanceAmount, ");
				// statement.append(" payment.expenseAmount as expenseAmount,
				// ");
				statement.append("        payment.acceptanceAmount as acceptanceAmount, ");
				statement.append("        payment.creditDownPayAmount as creditDownPayAmount, ");
				statement.append("        payment.pay_calamount as pay_calamount, ");
				statement.append("        sum(paySettlement.pay_amount) as settledAmount, ");
				statement.append("        payment.pay_status as pay_status, ");
				statement.append("        payment.pay_createDate as pay_createDate ");
				statement.append("   from (");
				statement.append(" select pp.pay_id as pay_id, ");
				statement.append("        pp.pay_code as pay_code, ");
				statement.append("        pp.pay_type as pay_type, ");
				statement.append("        pm.proj_id as proj_id, ");
				statement.append("        pm.proj_name as proj_name, ");
				statement.append("        pm.proj_contract_no as proj_contract_no, ");
				statement.append("        pm.contracttype as contracttype, ");
				statement.append("        ul.user_login_id as pmId, ");
				statement.append("        ul.name as pmName, ");
				statement.append("        p1.party_id as payAddrId, ");
				statement.append("        p1.description as payAddr, ");
				statement.append("        p2.party_id as departmentId, ");
				statement.append("        p2.description as department, ");
				statement
						.append("        sum(case when ptd.tr_category = ? then ptd.tr_amount else 0 end) as cafAmount, ");
				// statement.append(" sum(case when ptd.tr_category = ? then
				// ptd.tr_amount else 0 end) as allowanceAmount, ");
				// statement.append(" sum(case when (ptd.tr_category = ? or
				// ptd.tr_category = ?) then ptd.tr_amount else 0 end) as
				// expenseAmount, ");
				statement
						.append("        sum(case when ptd.tr_category = ? then ptd.tr_amount else 0 end) as acceptanceAmount, ");
				statement
						.append("        sum(case when ptd.tr_category = ? then ptd.tr_amount else 0 end) as creditDownPayAmount, ");
				statement.append("        pp.pay_calamount as pay_calamount, ");
				statement.append("        pp.pay_status as pay_status, ");
				statement.append("        pp.pay_createDate as pay_createDate ");

				// set parameters
				sqlExec.addParam(Constants.TRANSACATION_CATEGORY_CAF);
				// sqlExec.addParam(Constants.TRANSACATION_CATEGORY_ALLOWANCE);
				// sqlExec.addParam(Constants.TRANSACATION_CATEGORY_EXPENSE);
				// sqlExec.addParam(Constants.TRANSACATION_CATEGORY_OTHER_COST);
				sqlExec.addParam(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE);
				sqlExec.addParam(Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);

				// from setatement
				statement.append("   from proj_payment as pp ");
				statement.append("  inner join proj_mstr as pm on pp.pay_proj_id = pm.proj_id ");
				statement
						.append("  inner join user_login as ul on ul.user_login_id = pm.proj_pm_user ");
				statement.append("  inner join party as p1 on p1.party_id = pp.pay_addr ");
				statement.append("  inner join party as p2 on p2.party_id = pm.dep_id ");
				statement.append("  inner join party as p3 on p3.party_id = pm.proj_vendaddr ");
				statement
						.append("  left join proj_tr_det as ptd on pp.pay_id = ptd.tr_mstr_id and ptd.tr_type = 'Payment'");

				// where statement
				String PartyListStr = "''";
				System.out.println(fbiForm.getDepartment());
				List partyList_dep = ph.getAllSubPartysByPartyId(session, fbiForm.getDepartment());
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'" + fbiForm.getDepartment() + "'";
				while (itdep.hasNext()) {
					Party p = (Party) itdep.next();
					PartyListStr = PartyListStr + ", '" + p.getPartyId() + "'";
				}
				statement.append("  where p2.party_id in (" + PartyListStr + ") ");
				if (!"showDialog".equals(action)) {
					statement.append(" and pp.pay_type = ? ");
					if (request.getAttribute("PaymentType") != null
							&& ((String) request.getAttribute("PaymentType"))
									.equals(Constants.PAYMENT_TYPE_DOWN_PAYMENT)) {
						sqlExec.addParam(Constants.PAYMENT_TYPE_DOWN_PAYMENT);
					} else {
						sqlExec.addParam(Constants.PAYMENT_TYPE_NORMAL);
					}
				}

				if (fbiForm.getStatus() != null && fbiForm.getStatus().trim().length() != 0) {
					statement.append(" and pp.pay_status = ? ");

					sqlExec.addParam(fbiForm.getStatus());

				}

				if (fbiForm.getPayCode() != null && fbiForm.getPayCode().trim().length() != 0) {
					statement.append(" and pp.pay_code like ? ");

					sqlExec.addParam("%" + fbiForm.getPayCode() + "%");
				}

				if (fbiForm.getSupplier() != null && fbiForm.getSupplier().trim().length() != 0) {
					statement.append(" and (p3.party_id like ? or p3.description like ?) ");

					sqlExec.addParam("%" + fbiForm.getSupplier() + "%");
					sqlExec.addParam("%" + fbiForm.getSupplier() + "%");
				}

				if (fbiForm.getPayTo() != null && fbiForm.getPayTo().trim().length() != 0) {
					statement.append(" and (p1.party_id like ? or p1.description like ?) ");

					sqlExec.addParam("%" + fbiForm.getPayTo() + "%");
					sqlExec.addParam("%" + fbiForm.getPayTo() + "%");
				}

				if (fbiForm.getProject() != null && fbiForm.getProject().trim().length() != 0) {
					statement.append(" and (pm.proj_id like ? or pm.proj_name like ?) ");

					sqlExec.addParam("%" + fbiForm.getProject() + "%");
					sqlExec.addParam("%" + fbiForm.getProject() + "%");
				}

				// group by
				statement.append("  group by pp.pay_id, ");
				statement.append("           pp.pay_code, ");
				statement.append("           pp.pay_type, ");
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
				statement.append("           pp.pay_calamount, ");
				statement.append("           pp.pay_status, ");
				statement.append("           pp.pay_createDate ");
				statement.append("       ) as payment ");
				statement
						.append("   left join proj_payment_transaction as paySettlement on payment.pay_id = paySettlement.payment_id ");
				statement.append("  group by payment.pay_id, ");
				statement.append("           payment.pay_code, ");
				statement.append("           payment.pay_type, ");
				statement.append("           payment.proj_id, ");
				statement.append("           payment.proj_name, ");
				statement.append("           payment.proj_contract_no, ");
				statement.append("           payment.contracttype, ");
				statement.append("           payment.pmId, ");
				statement.append("           payment.pmName, ");
				statement.append("           payment.payAddrId, ");
				statement.append("           payment.payAddr, ");
				statement.append("           payment.departmentId, ");
				statement.append("           payment.department, ");
				statement.append("           payment.cafAmount, ");
				// statement.append(" payment.allowanceAmount, ");
				// statement.append(" payment.expenseAmount, ");
				statement.append("           payment.acceptanceAmount, ");
				statement.append("           payment.creditDownPayAmount, ");
				statement.append("           payment.pay_calamount, ");
				statement.append("           payment.pay_status, ");
				statement.append("           payment.pay_createDate ");
				// order by
				statement.append("  order by payment.proj_id ");

				log.info(statement.toString());

				SQLResults result = sqlExec.runQueryCloseCon(statement.toString());

				request.setAttribute("QueryList", result);

				if (action.equals("export")) {
					return exportExcel(request, response, result);
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
				cell.setCellValue(result.getString(row, "pay_code") == null ? "" : result
						.getString(row, "pay_code"));
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
				cell.setCellValue(result.getString(row, "payAddr") == null ? "" : result.getString(
						row, "payAddr"));
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
				cell.setCellValue(result.getDouble(row, "acceptanceAmount"));
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 10);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getDouble(row, "creditDownPayAmount"));
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 11);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getDouble(row, "pay_calamount"));
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 12);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getDouble(row, "settledAmount"));
				cell.setCellStyle(numStyle);

				double remainAmt = 0.0;
				remainAmt = result.getDouble(row, "pay_calamount")
						- result.getDouble(row, "settledAmount");
				cell = HRow.createCell((short) 13);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(remainAmt);
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 14);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getString(row, "pay_status") == null ? "" : result
						.getString(row, "pay_status"));
				cell.setCellStyle(centerStyle);

				cell = HRow.createCell((short) 15);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(result.getString(row, "pay_createDate") == null ? "" : result
						.getString(row, "pay_createDate"));
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

	private final static String ExcelTemplate = "PaymentInstruction.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Payment Instruction.xls";

	private final int ListStartRow = 1;
}
