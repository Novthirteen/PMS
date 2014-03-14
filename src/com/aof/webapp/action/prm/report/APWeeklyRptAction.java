package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
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
import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;

public class APWeeklyRptAction extends ReportBaseAction {

	private Log log = LogFactory.getLog(APWeeklyRptAction.class);

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		String action = request.getParameter("formAction");
		String strYear = request.getParameter("year");
		String strWeek = request.getParameter("week");
		String deptId = request.getParameter("deptId");
		String tcvRange = request.getParameter("tcvRange");
		String status = request.getParameter("status");
		String col = request.getParameter("col");

		if (action == null) {
			action = "";
		}
		if (strYear == null) {
			strYear = "";
		}
		if (strWeek == null) {
			strWeek = "";
		}
		if (deptId == null) {
			deptId = "";
		}
		if (tcvRange == null) {
			tcvRange = "";
		}
		if (status == null) {
			status = "";
		}
		if (col == null || col.equals("")) {
			col = "Q1";
		}

		try {
			SQLResults statusResult = null;
			SQLResults detailResult = null;

			Session hs = Hibernate2Session.currentSession();

			PartyHelper ph = new PartyHelper();

			List deptList = null;
			UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			deptList = ph.getAllSubPartysByPartyId(hs, ul.getParty().getPartyId());
			if (deptList == null) {
				deptList = new ArrayList();
			}
			deptList.add(0, ul.getParty());
			request.setAttribute("deptList", deptList);

			String strDeptList = "";
			if (deptId != null && !deptId.trim().equals("")) {
				List partyList_dep = ph.getAllSubPartysByPartyId(hs, deptId);
				Iterator itdep = partyList_dep.iterator();
				strDeptList = "'" + deptId + "'";
				while (itdep.hasNext()) {
					Party p = (Party) itdep.next();
					strDeptList = strDeptList + ", '" + p.getPartyId() + "'";
				}
			}
			if (action == null || action.equals("")) {

				Calendar c = Calendar.getInstance();

				if (strYear == null || strYear.equals("")) {
					strYear = String.valueOf(c.get(Calendar.YEAR));
				}

				if (strWeek == null || strWeek.equals("")) {
					strWeek = String.valueOf(c.get(Calendar.WEEK_OF_YEAR));
				}
			}

			statusResult = findStatusResult(strYear, strWeek, strDeptList, tcvRange, status);
			if (!action.equals("export")) {
				detailResult = findDetailResult(strYear, col, strDeptList, tcvRange, status);
			}

			if (action.equals("export")) {
				return ExportToExcel(mapping, request, response, statusResult, strWeek, strYear, strDeptList,
						tcvRange, status);
			}

			request.setAttribute("statusResult", statusResult);
			request.setAttribute("detailResult", detailResult);

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

	private SQLResults findStatusResult(String strYear, String strWeek, String strDeptList, String tcvRange,
			String status) throws Exception {

		int week = Integer.parseInt(strWeek);

		Date dayYearStart1 = UtilDateTime.toDate("1", "1", strYear, "0", "0", "0");
		Date dayYearStart2 = UtilDateTime.getThisWeekDay(dayYearStart1, 1);

		Date fromDate = UtilDateTime.getDiffDay(dayYearStart2, 7 * (week - 1));
		Date toDate = UtilDateTime.getDiffDay(fromDate, 7);

		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));

		String strSQL = "";

		strSQL += "select cust.description as cust_desc, bm.bid_description as bid_desc, ul.name as sales,"
				+ " dept.description as dept_desc, bm.bid_est_amt as tcv_value, rev.value as rev_value,"
				+ " bm.bid_status as status, bmh.reason as reason from bid_mstr as bm"
				+ " inner join bid_mstr_history as bmh on bmh.bid_id = bm.bid_id"
				+ " inner join party as cust on cust.party_id = bm.bid_prospect_company_id"
				+ " inner join user_login as ul on ul.user_login_id = bm.bid_sales_person"
				+ " inner join party as dept on dept.party_id = bm.bid_dep_id"
				+ " inner join bid_unweighted_value as rev on rev.bid_no = bm.bid_id"
				+ " where bmh_id in ( select max(bmh_id) from bid_mstr_history where modify_date >= '"
				+ df.format(fromDate) + "' and modify_date < '" + df.format(toDate)
				+ "' group by bid_id) and rev.bid_year =" + strYear;

		if (strDeptList != null && !strDeptList.trim().equals("")) {
			strSQL += " and dept.party_id in (" + strDeptList + ")";
		}

		if (tcvRange != null && !tcvRange.trim().equals("")) {
			tcvRange = UtilString.removeSymbol(tcvRange, ',');
			strSQL += " and  bm.bid_est_amt > " + tcvRange;
		}

		if (status != null && !status.trim().equals("")) {
			if (status.equalsIgnoreCase("abl")) {
				strSQL += " and bm.bid_status not in ('Lost/Drop', 'deleted')";
			} else if (status.equalsIgnoreCase("wol")) {
				strSQL += " and bm.bid_status in ('Lost/Drop', 'Won')";
			} else {
				strSQL += " and bm.bid_status = '" + status + "'";
			}
		}

		log.info(strSQL);
		System.out.println(strSQL);
		SQLResults statusResult = sqlExec.runQueryCloseCon(strSQL);

		return statusResult;
	}

	private SQLResults findDetailResult(String strYear, String col, String strDeptList, String tcvRange,
			String status) throws Exception {

		String fromDate = "";
		String toDate = "";

		if (col.equals("Q1")) {
			fromDate = strYear + "-01-01";
			toDate = strYear + "-03-31";
		}
		if (col.equals("Q2")) {
			fromDate = strYear + "-04-01";
			toDate = strYear + "-06-30";
		}
		if (col.equals("Q3")) {
			fromDate = strYear + "-07-01";
			toDate = strYear + "-09-30";
		}
		if (col.equals("Q4")) {
			fromDate = strYear + "-10-01";
			toDate = strYear + "-12-31";
		}
		if (col == null || col.equals("")) {
			fromDate = strYear + "-01-01";
			toDate = strYear + "-12-31";
		}

		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));

		String strSQL = "";

		strSQL = "select cust.description as cust_desc, bm.bid_description as bid_desc,"
				+ " ul.name as sales, dept.description as dept_desc, bm.bid_est_amt as tcv_value,"
				+ " rev.value as rev_value, bm.bid_status as status, bm.expected_end_date as forcast_date"
				+ " from bid_mstr as bm"
				+ " inner join party as cust on cust.party_id = bm.bid_prospect_company_id"
				+ " inner join user_login as ul on ul.user_login_id = bm.bid_sales_person"
				+ " inner join party as dept on dept.party_id = bm.bid_dep_id"
				+ " inner join bid_unweighted_value as rev on rev.bid_no = bm.bid_id"
				+ " where bm.bid_status in ('Active','Suspect','Offer','Prefer Supplier')"
				+ " and bm.bid_est_start_date >= '" + fromDate + "' and bm.bid_est_start_date <= '" + toDate + "'";

		if (strDeptList != null && !strDeptList.trim().equals("")) {
			strSQL += " and dept.party_id in (" + strDeptList + ")";
		}

		if (tcvRange != null && !tcvRange.trim().equals("")) {
			tcvRange = UtilString.removeSymbol(tcvRange, ',');
			strSQL += " and  bm.bid_est_amt > " + tcvRange;
		}

		System.out.println(strSQL);
		SQLResults detailResult = sqlExec.runQueryCloseCon(strSQL);

		return detailResult;
	}

	private ActionForward ExportToExcel(ActionMapping mapping, HttpServletRequest request,
			HttpServletResponse response, SQLResults statusResult, String strWeek, String strYear,
			String strDeptList, String tcvRange, String status) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return null;
			}

			int week = Integer.parseInt(strWeek);

			Date dayYearStart1 = UtilDateTime.toDate("1", "1", strYear, "0", "0", "0");
			Date dayYearStart2 = UtilDateTime.getThisWeekDay(dayYearStart1, 1);

			Date fromDate = UtilDateTime.getDiffDay(dayYearStart2, 7 * (week - 1));

			DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

			SQLResults detailResult = null;

			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName + "-W" + strWeek
					+ ".xls" + "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\" + ExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			HSSFCell cell = null;

			// List
			HSSFCellStyle titleStyle = sheet.getRow(titleRow).getCell((short) 3).getCellStyle();

			HSSFCellStyle textStyle = sheet.getRow(5).getCell((short) 0).getCellStyle();
			HSSFCellStyle numStyle = sheet.getRow(5).getCell((short) 2).getCellStyle();
			HSSFCellStyle centerStyle = sheet.getRow(5).getCell((short) 1).getCellStyle();

			HSSFCellStyle statusHeadStyle = sheet.getRow(4).getCell((short) 0).getCellStyle();
			HSSFCellStyle statusTotalStyle = sheet.getRow(4).getCell((short) 1).getCellStyle();

			HSSFCellStyle q1HeadStyle = sheet.getRow(4).getCell((short) 2).getCellStyle();
			HSSFCellStyle q1TotalStyle = sheet.getRow(4).getCell((short) 3).getCellStyle();

			HSSFCellStyle q2HeadStyle = sheet.getRow(4).getCell((short) 4).getCellStyle();
			HSSFCellStyle q2TotalStyle = sheet.getRow(4).getCell((short) 5).getCellStyle();

			HSSFCellStyle q3HeadStyle = sheet.getRow(4).getCell((short) 6).getCellStyle();
			HSSFCellStyle q3TotalStyle = sheet.getRow(4).getCell((short) 7).getCellStyle();

			HSSFCellStyle q4HeadStyle = sheet.getRow(5).getCell((short) 3).getCellStyle();
			HSSFCellStyle q4TotalStyle = sheet.getRow(5).getCell((short) 4).getCellStyle();

			HSSFRow HRow = null;
			HRow = sheet.createRow(titleRow);
			cell = HRow.createCell((short) 2);
			cell.setCellValue("Week:" + strWeek);
			cell.setCellStyle(titleStyle);

			HRow = sheet.createRow(titleRow);
			cell = HRow.createCell((short) 4);
			cell.setCellValue(df.format(fromDate));
			cell.setCellStyle(titleStyle);

			sheet.addMergedRegion(new Region(4, (short) 0, 4, (short) 7));
			cell = sheet.createRow(4).createCell((short) 0);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("Contracts Status Change");
			cell.setCellStyle(statusHeadStyle);

			for (int o = 1; o < 8; o++) {
				cell = sheet.createRow(4).createCell((short) o);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("");
				cell.setCellStyle(statusHeadStyle);
			}

			HRow = sheet.createRow(5);

			cell = HRow.createCell((short) 0);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("Customer");
			cell.setCellStyle(statusHeadStyle);

			cell = HRow.createCell((short) 1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("Project Name");
			cell.setCellStyle(statusHeadStyle);

			cell = HRow.createCell((short) 2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("Lead Sales");
			cell.setCellStyle(statusHeadStyle);

			cell = HRow.createCell((short) 3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("Department");
			cell.setCellStyle(statusHeadStyle);

			cell = HRow.createCell((short) 4);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("TCV (Euro'K)");
			cell.setCellStyle(statusHeadStyle);

			cell = HRow.createCell((short) 5);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(strYear + "Rev (Euro'K)");
			cell.setCellStyle(statusHeadStyle);

			cell = HRow.createCell((short) 6);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("Status");
			cell.setCellStyle(statusHeadStyle);

			cell = HRow.createCell((short) 7);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("Remarks / Help Needed");
			cell.setCellStyle(statusHeadStyle);

			int excelRow = ListStartRow;

			if (statusResult != null && statusResult.getRowCount() > 0) {

				int totalTCV = 0;
				int totalRev = 0;

				for (int row = 0; row < statusResult.getRowCount(); row++) {

					int tmpTcv = (int) Math.round(statusResult.getDouble(row, "rev_value") / 10000);
					int tmpRev = (int) Math.round(statusResult.getDouble(row, "rev_value") / 10000);

					totalTCV += tmpTcv;
					totalRev += tmpRev;

					HRow = sheet.createRow(excelRow);

					cell = HRow.createCell((short) 0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(statusResult.getString(row, "cust_desc") == null ? "" : statusResult
							.getString(row, "cust_desc"));
					cell.setCellStyle(textStyle);

					cell = HRow.createCell((short) 1);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(statusResult.getString(row, "bid_desc") == null ? "" : statusResult
							.getString(row, "bid_desc"));
					cell.setCellStyle(textStyle);

					cell = HRow.createCell((short) 2);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(statusResult.getString(row, "sales") == null ? "" : statusResult.getString(
							row, "sales"));
					cell.setCellStyle(textStyle);

					cell = HRow.createCell((short) 3);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(statusResult.getString(row, "dept_desc") == null ? "" : statusResult
							.getString(row, "dept_desc"));
					cell.setCellStyle(centerStyle);

					cell = HRow.createCell((short) 4);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(tmpTcv);
					cell.setCellStyle(numStyle);

					cell = HRow.createCell((short) 5);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(tmpRev);
					cell.setCellStyle(numStyle);

					cell = HRow.createCell((short) 6);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(statusResult.getString(row, "status") == null ? "" : statusResult.getString(
							row, "status"));
					cell.setCellStyle(centerStyle);

					cell = HRow.createCell((short) 7);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(statusResult.getString(row, "reason") == null ? "" : statusResult.getString(
							row, "reason"));
					cell.setCellStyle(textStyle);

					excelRow++;
				}

				excelRow++;

				HRow = sheet.createRow(excelRow);

				cell = HRow.createCell((short) 3);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("Total");
				cell.setCellStyle(statusHeadStyle);

				cell = HRow.createCell((short) 4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(totalTCV);
				cell.setCellStyle(statusTotalStyle);

				cell = HRow.createCell((short) 5);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(totalRev);
				cell.setCellStyle(statusTotalStyle);
			}

			excelRow += 2;

			for (int i = 1; i <= 4; i++) {

				HSSFCellStyle tmpHeadStyle = null;
				HSSFCellStyle tmpTotalStyle = null;

				if (i == 1) {
					tmpHeadStyle = q1HeadStyle;
					tmpTotalStyle = q1TotalStyle;
				}
				if (i == 2) {
					tmpHeadStyle = q2HeadStyle;
					tmpTotalStyle = q2TotalStyle;
				}
				if (i == 3) {
					tmpHeadStyle = q3HeadStyle;
					tmpTotalStyle = q3TotalStyle;
				}
				if (i == 4) {
					tmpHeadStyle = q4HeadStyle;
					tmpTotalStyle = q4TotalStyle;
				}

				sheet.addMergedRegion(new Region(excelRow, (short) 0, excelRow, (short) 8));
				cell = sheet.createRow(excelRow).createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("Key Bids in Quarter " + i);
				cell.setCellStyle(tmpHeadStyle);

				for (int o = 1; o < 9; o++) {
					cell = sheet.createRow(excelRow).createCell((short) o);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue("");
					cell.setCellStyle(tmpHeadStyle);
				}

				excelRow++;

				HRow = sheet.createRow(excelRow);

				cell = HRow.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("Customer");
				cell.setCellStyle(tmpHeadStyle);

				cell = HRow.createCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("Project Name");
				cell.setCellStyle(tmpHeadStyle);

				cell = HRow.createCell((short) 2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("Lead Sales");
				cell.setCellStyle(tmpHeadStyle);

				cell = HRow.createCell((short) 3);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("Department");
				cell.setCellStyle(tmpHeadStyle);

				cell = HRow.createCell((short) 4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("TCV (Euro'K)");
				cell.setCellStyle(tmpHeadStyle);

				cell = HRow.createCell((short) 5);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(strYear + " Rev (Euro'K)");
				cell.setCellStyle(tmpHeadStyle);

				cell = HRow.createCell((short) 6);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("Status");
				cell.setCellStyle(tmpHeadStyle);

				cell = HRow.createCell((short) 7);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("Remarks / Help Needed");
				cell.setCellStyle(tmpHeadStyle);

				cell = HRow.createCell((short) 8);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("Forcast Date");
				cell.setCellStyle(tmpHeadStyle);

				excelRow++;

				detailResult = findDetailResult(strYear, "Q" + i, strDeptList, tcvRange, status);

				if (detailResult != null && detailResult.getRowCount() > 0) {

					int totalDetailTCV = 0;
					int totalDetailRev = 0;

					for (int row = 0; row < detailResult.getRowCount(); row++) {

						int tmpDetailTcv = (int) Math.round(detailResult.getDouble(row, "tcv_value") / 10000);
						int tmpDetailRev = (int) Math.round(detailResult.getDouble(row, "rev_value") / 10000);

						totalDetailTCV += tmpDetailTcv;
						totalDetailRev += tmpDetailRev;

						HRow = sheet.createRow(excelRow);

						cell = HRow.createCell((short) 0);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(detailResult.getString(row, "cust_desc") == null ? "" : detailResult
								.getString(row, "cust_desc"));
						cell.setCellStyle(textStyle);

						cell = HRow.createCell((short) 1);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(detailResult.getString(row, "bid_desc") == null ? "" : detailResult
								.getString(row, "bid_desc"));
						cell.setCellStyle(textStyle);

						cell = HRow.createCell((short) 2);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(detailResult.getString(row, "sales") == null ? "" : detailResult
								.getString(row, "sales"));
						cell.setCellStyle(textStyle);

						cell = HRow.createCell((short) 3);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(detailResult.getString(row, "dept_desc") == null ? "" : detailResult
								.getString(row, "dept_desc"));
						cell.setCellStyle(centerStyle);

						cell = HRow.createCell((short) 4);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(tmpDetailTcv);
						cell.setCellStyle(numStyle);

						cell = HRow.createCell((short) 5);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(tmpDetailRev);
						cell.setCellStyle(numStyle);

						cell = HRow.createCell((short) 6);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(detailResult.getString(row, "status") == null ? "" : detailResult
								.getString(row, "status"));
						cell.setCellStyle(centerStyle);

						cell = HRow.createCell((short) 7);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue("");
						cell.setCellStyle(textStyle);

						cell = HRow.createCell((short) 8);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(detailResult.getString(row, "cust_desc") == null ? "" : detailResult
								.getString(row, "forcast_date"));
						cell.setCellStyle(centerStyle);

						excelRow++;
					}

					excelRow++;

					HRow = sheet.createRow(excelRow);

					cell = HRow.createCell((short) 3);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue("Total");
					cell.setCellStyle(tmpHeadStyle);

					cell = HRow.createCell((short) 4);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(totalDetailTCV);
					cell.setCellStyle(tmpTotalStyle);

					cell = HRow.createCell((short) 5);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(totalDetailRev);
					cell.setCellStyle(tmpTotalStyle);
				}

				excelRow += 2;
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

	private final static String ExcelTemplate = "APWeeklyReport.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "AP Weekly Report_China";

	private final int ListStartRow = 6;

	private final int titleRow = 2;
}
