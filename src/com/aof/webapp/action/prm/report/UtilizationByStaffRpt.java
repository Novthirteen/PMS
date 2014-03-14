package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

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
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;

public class UtilizationByStaffRpt extends ReportBaseAction {

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		try {

			String action = request.getParameter("formAction");
			String employeeId = request.getParameter("employeeId");
			String year = request.getParameter("iYear");
			String departmentId = request.getParameter("departmentId");

			if (employeeId == null) {
				employeeId = "";
			}

			if (action == null) {
				action = "";
			}

			if (departmentId == null) {
				departmentId = "";
			}

			if (action.equals("view")) {

				Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;

				tx = hs.beginTransaction();

				UserLogin employee = new UserLogin();
				employee = (UserLogin) hs.load(UserLogin.class, employeeId);

				tx.commit();

				List result = findViewResult(year, employeeId);

				request.setAttribute("employee", employee);
				request.setAttribute("result", result);

				return (mapping.findForward("view-success"));
			}

			if (action.equals("list")) {
				SQLResults result = findListResult(year, employeeId, departmentId);
				request.setAttribute("result", result);
				return (mapping.findForward("list-success"));
			}

			if (action.equals("export")) {
				return exportExcel(request, response, employeeId, year, departmentId);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return (mapping.findForward("list-success"));
	}

	private SQLResults findListResult(String year, String employeeId, String departmentId)
			throws Exception {

		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));

		String strSQL = "select ul.user_login_id as cn, ul.name as name,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-01-01 00:00' and td.ts_date < '"
				+ year
				+ "-02-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-01-01 00:00' and pc_date < '"
				+ year
				+ "-02-01 00:00') as m0,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-02-01 00:00' and td.ts_date < '"
				+ year
				+ "-03-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-02-01 00:00' and pc_date < '"
				+ year
				+ "-03-01 00:00') as m1,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-03-01 00:00' and td.ts_date < '"
				+ year
				+ "-04-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-03-01 00:00' and pc_date < '"
				+ year
				+ "-04-01 00:00') as m2,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-04-01 00:00' and td.ts_date < '"
				+ year
				+ "-05-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-04-01 00:00' and pc_date < '"
				+ year
				+ "-05-01 00:00') as m3,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-05-01 00:00' and td.ts_date < '"
				+ year
				+ "-06-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-05-01 00:00' and pc_date < '"
				+ year
				+ "-06-01 00:00') as m4,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-06-01 00:00' and td.ts_date < '"
				+ year
				+ "-07-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-06-01 00:00' and pc_date < '"
				+ year
				+ "-07-01 00:00') as m5,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-07-01 00:00' and td.ts_date < '"
				+ year
				+ "-08-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-07-01 00:00' and pc_date < '"
				+ year
				+ "-08-01 00:00') as m6,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-08-01 00:00' and td.ts_date < '"
				+ year
				+ "-09-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-08-01 00:00' and pc_date < '"
				+ year
				+ "-09-01 00:00') as m7,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-09-01 00:00' and td.ts_date < '"
				+ year
				+ "-10-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-09-01 00:00' and pc_date < '"
				+ year
				+ "-10-01 00:00') as m8,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-10-01 00:00' and td.ts_date < '"
				+ year
				+ "-11-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-10-01 00:00' and pc_date < '"
				+ year
				+ "-11-01 00:00') as m9,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-11-01 00:00' and td.ts_date < '"
				+ year
				+ "-12-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-11-01 00:00' and pc_date < '"
				+ year
				+ "-12-01 00:00') as m10,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-12-01 00:00' and td.ts_date <= '"
				+ year
				+ "-12-31 23:59')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year + "-12-01 00:00' and pc_date <= '" + year + "-12-31 23:59') as m11";

		strSQL += " from proj_ts_det as td"
				+ " inner join proj_mstr as pm on pm.proj_id = td.ts_proj_id"
				+ " inner join proj_ts_mstr as tm on tm.tsm_id = td.tsm_id"
				+ " inner join user_login as ul on ul.user_login_id = tm.tsm_userlogin";

		String whereSQL = "";

		whereSQL += " where  td.ts_date >= '" + year + "-01-01 00:00:00'" + " and td.ts_date <= '"
				+ year + "-12-31 23:59'";

		if (employeeId != null && !(employeeId.equals(""))) {
			whereSQL += " and ul.user_login_id ='" + employeeId + "'";
		} else {
			if (departmentId != null && !(departmentId.equals(""))) {
				whereSQL += " and ul.party_id='" + departmentId + "'";
			}
		}

		whereSQL += " group by ul.user_login_id, ul.name";

		// System.out.println("\n" + strSQL + whereSQL + "\n");

		SQLResults result = sqlExec.runQueryCloseCon(strSQL + whereSQL);

		return result;
	}

	private List findViewResult(String year, String employeeId) throws Exception {

		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));

		String strSQL = "select ul.user_login_id as user_login_id, pm.proj_id as proj_id, pm.proj_name as proj_name, p.party_id as cust_id, p.description as cust_name,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-01-01 00:00' and td.ts_date < '"
				+ year
				+ "-02-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-01-01 00:00' and pc_date < '"
				+ year
				+ "-02-01 00:00') as m0,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-02-01 00:00' and td.ts_date < '"
				+ year
				+ "-03-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-02-01 00:00' and pc_date < '"
				+ year
				+ "-03-01 00:00') as m1,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-03-01 00:00' and td.ts_date < '"
				+ year
				+ "-04-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-03-01 00:00' and pc_date < '"
				+ year
				+ "-04-01 00:00') as m2,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-04-01 00:00' and td.ts_date < '"
				+ year
				+ "-05-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-04-01 00:00' and pc_date < '"
				+ year
				+ "-05-01 00:00') as m3,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-05-01 00:00' and td.ts_date < '"
				+ year
				+ "-06-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-05-01 00:00' and pc_date < '"
				+ year
				+ "-06-01 00:00') as m4,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-06-01 00:00' and td.ts_date < '"
				+ year
				+ "-07-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-06-01 00:00' and pc_date < '"
				+ year
				+ "-07-01 00:00') as m5,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-07-01 00:00' and td.ts_date < '"
				+ year
				+ "-08-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-07-01 00:00' and pc_date < '"
				+ year
				+ "-08-01 00:00') as m6,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-08-01 00:00' and td.ts_date < '"
				+ year
				+ "-09-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-08-01 00:00' and pc_date < '"
				+ year
				+ "-09-01 00:00') as m7,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-09-01 00:00' and td.ts_date < '"
				+ year
				+ "-10-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-09-01 00:00' and pc_date < '"
				+ year
				+ "-10-01 00:00') as m8,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-10-01 00:00' and td.ts_date < '"
				+ year
				+ "-11-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-10-01 00:00' and pc_date < '"
				+ year
				+ "-11-01 00:00') as m9,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-11-01 00:00' and td.ts_date < '"
				+ year
				+ "-12-01 00:00')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year
				+ "-11-01 00:00' and pc_date < '"
				+ year
				+ "-12-01 00:00') as m10,"
				+ " sum(case when ((td.ts_status <>'Draft') and (td.ts_date >= '"
				+ year
				+ "-12-01 00:00' and td.ts_date <= '"
				+ year
				+ "-12-31 23:59')) then td.ts_hrs_user end)/(select sum(pc_hours) from proj_calendar where pc_date >= '"
				+ year + "-12-01 00:00' and pc_date <= '" + year + "-12-31 23:59') as m11";

		strSQL += " from proj_ts_det as td"
				+ " inner join proj_mstr as pm on pm.proj_id = td.ts_proj_id"
				+ " inner join proj_ts_mstr as tm on tm.tsm_id = td.tsm_id"
				+ " inner join user_login as ul on ul.user_login_id = tm.tsm_userlogin"
				+ " inner join projevent as pe on pe.pevent_id = td.ts_projevent"
				+ " inner join party as p on pm.cust_id = p.party_id";

		String whereSQL = "";

		whereSQL += " where ul.user_login_id ='"
				+ employeeId
				+ "'"
				+ " and td.ts_date >= '"
				+ year
				+ "-01-01 00:00:00'"
				+ " and td.ts_date <= '"
				+ year
				+ "-12-31 23:59'"
				+ " and pe.pevent_name not like '%Presale%' and pe.pevent_name not like '%Pre-sales%'"
				+ " group by ul.user_login_id, pm.proj_id, pm.proj_name, p.party_id, p.description";

		// System.out.println("\n" + strSQL + whereSQL + "\n");

		SQLResults hrsReslut = sqlExec.runQuery(strSQL + whereSQL);

		whereSQL = " where ul.user_login_id ='" + employeeId + "'" + " and td.ts_date >= '" + year
				+ "-01-01 00:00:00'" + " and td.ts_date <= '" + year + "-12-31 23:59'"
				+ " and (pe.pevent_name like '%Presale%' or pe.pevent_name like '%Pre-sales%')"
				+ " group by ul.user_login_id, pm.proj_id, pm.proj_name, p.party_id, p.description";

		// System.out.println("\n" + strSQL + whereSQL + "\n");

		SQLResults preSaleReslut = sqlExec.runQueryCloseCon(strSQL + whereSQL);

		List result = new ArrayList();

		result.add(0, hrsReslut);
		result.add(1, preSaleReslut);

		return result;
	}

	private ActionForward exportExcel(HttpServletRequest request, HttpServletResponse response,
			String employeeId, String year, String departmentId) {
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

			SQLResults listEmloyee = findListResult(year, employeeId, departmentId);
			if (listEmloyee == null || listEmloyee.getRowCount() <= 0) {
				return null;
			}

			Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;

			tx = hs.beginTransaction();

			Party dept = new Party();
			dept = (Party) hs.load(Party.class, departmentId);
			tx.commit();

			NumberFormat numFormator = NumberFormat.getInstance();
			numFormator.setMaximumFractionDigits(1);
			numFormator.setMinimumFractionDigits(1);

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
			cell = sheet.getRow(1).getCell((short) 10);
			cell.setCellValue(dept.getDescription());
			cell = sheet.getRow(2).getCell((short) 10);
			cell.setCellValue(year);

			// Style
			HSSFCellStyle titleStyle = sheet.getRow(4).getCell((short) 0).getCellStyle();
			HSSFCellStyle textStyle = sheet.getRow(5).getCell((short) 0).getCellStyle();
			HSSFCellStyle numberStyle = sheet.getRow(5).getCell((short) 4).getCellStyle();

			HSSFCellStyle totalTextStyle = sheet.getRow(6).getCell((short) 3).getCellStyle();
			HSSFCellStyle totalNumberStyle = sheet.getRow(6).getCell((short) 4).getCellStyle();

			int excelRow = ListStartRow;
			HSSFRow HRow = null;

			HRow = sheet.createRow(excelRow);

			cell = HRow.createCell((short) 0);
			cell.setCellValue("Employee ID");
			cell.setCellStyle(titleStyle);

			cell = HRow.createCell((short) 1);
			cell.setCellValue("Employee Name");
			cell.setCellStyle(titleStyle);

			for (int i = 0; i < listEmloyee.getRowCount(); i++) {

				double total[] = new double[12];

				String tmpId = listEmloyee.getString(i, "cn");

				List result = findViewResult(year, tmpId);

				HRow = sheet.createRow(excelRow);

				cell = HRow.createCell((short) 2);
				cell.setCellValue("Project");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 3);
				cell.setCellValue("Customer");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 4);
				cell.setCellValue("Jan");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 5);
				cell.setCellValue("Feb");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 6);
				cell.setCellValue("March");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 7);
				cell.setCellValue("April");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 8);
				cell.setCellValue("May");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 9);
				cell.setCellValue("Jun");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 10);
				cell.setCellValue("Jul");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 11);
				cell.setCellValue("Aug");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 12);
				cell.setCellValue("Sep");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 13);
				cell.setCellValue("Oct");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 14);
				cell.setCellValue("Nov");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 15);
				cell.setCellValue("Dec");
				cell.setCellStyle(titleStyle);

				excelRow++;

				HRow = sheet.createRow(excelRow);

				cell = HRow.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(listEmloyee.getString(i, "cn"));
				cell.setCellStyle(textStyle);

				cell = HRow.createCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(listEmloyee.getString(i, "name"));
				cell.setCellStyle(textStyle);

				SQLResults hrsReslut = (SQLResults) result.get(0);

				if (hrsReslut == null || hrsReslut.getRowCount() <= 0) {

					HRow = sheet.createRow(excelRow);

					for (int row = 0; row < 14; row++) {
						cell = HRow.createCell((short) (row + 2));
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue("");
						cell.setCellStyle(textStyle);
					}

					excelRow++;

				} else {

					for (int row = 0; row < hrsReslut.getRowCount(); row++) {

						HRow = sheet.createRow(excelRow);

						if (row != 0) {
							cell = HRow.createCell((short) 0);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);
							cell.setCellValue("");
							cell.setCellStyle(textStyle);

							cell = HRow.createCell((short) 1);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);
							cell.setCellValue("");
							cell.setCellStyle(textStyle);
						}

						cell = HRow.createCell((short) 2);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(hrsReslut.getString(row, "proj_id") + ":"
								+ hrsReslut.getString(row, "proj_name"));
						cell.setCellStyle(textStyle);

						cell = HRow.createCell((short) 3);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(hrsReslut.getString(row, "cust_id") + ":"
								+ hrsReslut.getString(row, "cust_name"));
						cell.setCellStyle(textStyle);

						for (int j = 0; j < 12; j++) {

							String tmpHrs = "";
							double hrs = hrsReslut.getDouble(row, "m" + j);
							if (hrs != 0) {
								tmpHrs = numFormator.format(hrs * 100);
								total[j] += Double.valueOf(tmpHrs).doubleValue();
							}

							cell = HRow.createCell((short) (4 + j));
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);
							cell.setCellValue(tmpHrs.equals("") ? "" : tmpHrs + "%");
							cell.setCellStyle(numberStyle);

						}

						excelRow++;
					}
				}

				SQLResults preSaleReslut = (SQLResults) result.get(1);

				HRow = sheet.createRow(excelRow);

				cell = HRow.createCell((short) 0);
				cell.setCellValue("");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 1);
				cell.setCellValue("");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 2);
				cell.setCellValue("Pre-Sale Project");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 3);
				cell.setCellValue("Customer");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 4);
				cell.setCellValue("Jan");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 5);
				cell.setCellValue("Feb");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 6);
				cell.setCellValue("March");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 7);
				cell.setCellValue("April");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 8);
				cell.setCellValue("May");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 9);
				cell.setCellValue("Jun");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 10);
				cell.setCellValue("Jul");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 11);
				cell.setCellValue("Aug");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 12);
				cell.setCellValue("Sep");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 13);
				cell.setCellValue("Oct");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 14);
				cell.setCellValue("Nov");
				cell.setCellStyle(titleStyle);

				cell = HRow.createCell((short) 15);
				cell.setCellValue("Dec");
				cell.setCellStyle(titleStyle);

				excelRow++;

				if (preSaleReslut == null || preSaleReslut.getRowCount() <= 0) {

					HRow = sheet.createRow(excelRow);

					for (int row = 0; row < 14; row++) {
						cell = HRow.createCell((short) (row + 2));
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue("");
						cell.setCellStyle(textStyle);
					}

					excelRow++;

				} else {

					for (int row = 0; row < preSaleReslut.getRowCount(); row++) {

						HRow = sheet.createRow(excelRow);

						cell = HRow.createCell((short) 0);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue("");
						cell.setCellStyle(textStyle);

						cell = HRow.createCell((short) 1);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue("");
						cell.setCellStyle(textStyle);

						cell = HRow.createCell((short) 2);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(preSaleReslut.getString(row, "proj_id") + ":"
								+ preSaleReslut.getString(row, "proj_name"));
						cell.setCellStyle(textStyle);

						cell = HRow.createCell((short) 3);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(preSaleReslut.getString(row, "cust_id") + ":"
								+ preSaleReslut.getString(row, "cust_name"));
						cell.setCellStyle(textStyle);

						for (int j = 0; j < 12; j++) {

							String tmpPresale = "";
							double pre = preSaleReslut.getDouble(row, "m" + j);
							if (pre != 0) {
								tmpPresale = numFormator.format(preSaleReslut.getDouble(row, "m"
										+ j) * 100);
								total[j] += Double.valueOf(tmpPresale).doubleValue();
							}

							cell = HRow.createCell((short) (4 + j));
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);
							cell.setCellValue(tmpPresale.equals("") ? "" : tmpPresale + "%");
							cell.setCellStyle(numberStyle);

						}
						excelRow++;
					}
				}

				HRow = sheet.createRow(excelRow);

				for (int j = 0; j < 3; j++) {
					cell = HRow.createCell((short) j);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue("");
					cell.setCellStyle(totalTextStyle);
				}
				cell = HRow.createCell((short) 3);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("Total");
				cell.setCellStyle(totalTextStyle);

				for (int j = 0; j < 12; j++) {
					cell = HRow.createCell((short) (j + 4));
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(total[j] == 0 ? "" : numFormator.format(total[j]) + "%");
					cell.setCellStyle(totalNumberStyle);
				}
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

	private final static String ExcelTemplate = "UtilizationByStaffRpt.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Utilization Report By Staff.xls";

	private final int ListStartRow = 4;
}
