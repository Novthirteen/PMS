/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.SQLException;
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
import com.aof.component.prm.util.EmailService;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;

/**
 * @author Angus Chen
 * 
 */
public class CAFStatusRptAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();

		try {

			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			Date nowDate = (java.util.Date) UtilDateTime.nowTimestamp();

			String action = request.getParameter("FormAction");
			String EmployeeId = request.getParameter("EmployeeId");
			String project = request.getParameter("project");
			String FromDate = request.getParameter("dateStart");
			String EndDate = request.getParameter("dateEnd");
			String departmentId = request.getParameter("departmentId");
			String category = request.getParameter("category");
			boolean zeroflag = false;
			if (request.getParameter("zeroflag") != null)
				zeroflag = true;
			if (EmployeeId == null)
				EmployeeId = "";
			if (departmentId == null)
				departmentId = "";
			if (category == null)
				category = "";
			if (FromDate == null)
				FromDate = Date_formater.format(UtilDateTime.getDiffDay(nowDate, -10));
			if (EndDate == null)
				EndDate = Date_formater.format(nowDate);
			if (action == null)
				action = "view";

			if (action.equals("QueryForList")) {
				long timeStart = System.currentTimeMillis();
				SQLResults sr = findQueryResult(request, FromDate, EndDate, EmployeeId, project,
						departmentId, zeroflag, category);
				request.setAttribute("QryList", sr);
				long timeEnd = System.currentTimeMillis(); // for performance
				// test
				return (mapping.findForward("success"));
			}

			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping, request, response, FromDate, EndDate, EmployeeId,
						project, departmentId, zeroflag, category);
			}
			if (action.equals("email")) {

				SQLResults sr = findQueryResult(request, FromDate, EndDate, EmployeeId, project,
						departmentId, zeroflag, category);

				String emailFlag = null;
				if (sr != null && sr.getRowCount() > 0) {
					emailFlag = sendEmail(sr, FromDate, EndDate);
				} else {
					emailFlag = "emailEmpty";
				}
				request.setAttribute("emailFlag", emailFlag);
				request.setAttribute("QryList", sr);
				return (mapping.findForward("success"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}

	private SQLResults findQueryResult(HttpServletRequest request, String FromDate, String ToDate,
			String EmployeeId, String project, String departmentId, boolean zeroflag,
			String category) throws Exception {
		UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		Date nowDate = (java.util.Date) UtilDateTime.nowTimestamp();
		PartyHelper ph = new PartyHelper();
		String PartyListStr = "''";
		if (!departmentId.trim().equals("")) {
			List partyList_dep = ph.getAllSubPartysByPartyId(session, departmentId);
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'" + departmentId + "'";
			while (itdep.hasNext()) {
				Party p = (Party) itdep.next();
				PartyListStr = PartyListStr + ", '" + p.getPartyId() + "'";
			}
		}
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));
		String SqlStr = "";
		if (!zeroflag) {
			SqlStr = SqlStr
					+ "select aaa.tsm_userlogin, aaa.name, aaa.date, aaa.hrs, aaa.pid, aaa.pname, aaa.cname,";
			SqlStr = SqlStr
					+ " aaa.servicetype, aaa.event,aaa.contractType, aaa.dc, aaa.pmname, aaa.email_addr ";
			// SqlStr = SqlStr + " aaa.servicetype, aaa.event,aaa.contractType,
			// aaa.pmname ";
			SqlStr = SqlStr + "from  (";
		}

		SqlStr = SqlStr
				+ "select ptm.tsm_userlogin, ul.name, ptd.ts_date as date, ptd.ts_hrs_user as hrs, ptd.ts_proj_id as pid,";
		SqlStr = SqlStr + " pm.proj_name as pname,uul.name as pmname, p.description as cname, ";
		SqlStr = SqlStr + " ps.st_desc as servicetype, pe.pevent_name as event,pm.contractType,";
		// SqlStr = SqlStr + " ps.st_desc as servicetype, pe.pevent_name as
		// event,pm.contractType";
		// calculate the day difference between nowday and entry day period
		// SqlStr = SqlStr +" (case when cast
		// ('"+Date_formater.format(nowDate)+"' - cast(cast(( ptm.ts_period) as
		// datetime) +7 as datetime) as integer) >=0 then cast
		// ('"+Date_formater.format(nowDate)+"' - cast(cast(( ptm.ts_period) as
		// datetime) +7 as datetime) as integer) else 0 end) as dc";
		// SqlStr = SqlStr +" CASE WHEN ((datediff (day,
		// ptm.ts_period,'2005-10-20') - 7) >= 0) then (datediff (day,
		// ptm.ts_period,'2005-10-20') - 7) ELSE 0 END AS dc";
		SqlStr = SqlStr + " (datediff (day, ptm.ts_period,'" + Date_formater.format(nowDate)
				+ "') - 7) AS dc, ul.email_addr as email_addr";
		SqlStr = SqlStr
				+ " from user_login as ul inner join proj_ts_mstr as ptm on ptm.tsm_userlogin = ul.user_login_id";
		SqlStr = SqlStr
				+ " inner join proj_ts_det as ptd on ptd.tsm_id = ptm.tsm_id and ptd.ts_hrs_user <> 0 and ptd.ts_cafstatus_confirm = 'N' and ptd.ts_status <> 'draft' ";
		SqlStr = SqlStr
				+ " inner join proj_mstr as pm on pm.proj_id = ptd.ts_proj_id and pm.proj_status = 'WIP' ";
		SqlStr = SqlStr + " inner join user_login as uul on pm.proj_pm_user = uul.user_login_id";
		SqlStr = SqlStr + " inner join party as p on p.party_id = pm.cust_id";
		SqlStr = SqlStr + " inner join proj_servicetype as ps on ps.st_id =ptd.ts_servicetype";
		SqlStr = SqlStr
				+ " inner join projevent as pe on pe.pevent_id = ptd.ts_projevent and pe.Billable = 'Yes'";
		SqlStr = SqlStr + " where pm.proj_caf_flag = 'y'   and pm.proj_category = 'C' ";
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " and pm.dep_id in (" + PartyListStr + ")";
		} else {
			SqlStr = SqlStr + "  and pm.proj_pm_user ='" + ul.getUserLoginId() + "'";
		}
		if (!EmployeeId.trim().equals("")) {
			SqlStr = SqlStr + " and (ul.user_login_id like '%" + EmployeeId.trim()
					+ "%' or ul.name like '%" + EmployeeId.trim() + "%')";
		}
		if (!project.trim().equals("")) {
			SqlStr = SqlStr + " and (pm.proj_name like '%" + project.trim()
					+ "%' or pm.proj_id like '%" + project.trim() + "%')";
		}
		if (!category.trim().equals("")) {
			SqlStr = SqlStr + " and pm.contracttype like '%" + category + "%'";
		}

		SqlStr = SqlStr + " and (ptd.ts_date between '" + FromDate + "' and '" + ToDate
				+ "') and ps.st_rate<>0";

		if (!zeroflag) {
			SqlStr = SqlStr + ") as aaa where aaa.dc<>0 ";
			SqlStr = SqlStr + "group by aaa.tsm_userlogin, aaa.name, aaa.date, aaa.hrs, aaa.pid, aaa.pname, aaa.cname, aaa.servicetype, aaa.event,aaa.contractType, aaa.dc, aaa.pmname, aaa.email_addr ";
			SqlStr = SqlStr + "order by aaa.tsm_userlogin, aaa.date";
		}
		// if (!zeroflag) {
		// SqlStr = SqlStr + ") as aaa ";
		// }
		long startTime = System.currentTimeMillis();
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		long endTime = System.currentTimeMillis();

		System.out.println("It takes " + (startTime - endTime) + "ms to execute the query...");

		//System.out.println("\n\n\n"+SqlStr+"\n\n\n");

		return sr;
	}

	private ActionForward ExportToExcel(ActionMapping mapping, HttpServletRequest request,
			HttpServletResponse response, String FromDate, String ToDate, String EmployeeId,
			String project, String departmentId, boolean zeroflag, String category) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			Date nowDate = (java.util.Date) UtilDateTime.nowTimestamp();

			SQLResults sr = findQueryResult(request, FromDate, ToDate, EmployeeId, project,
					departmentId, zeroflag, category);
			if (sr == null || sr.getRowCount() == 0)
				return null;

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName
					+ "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
					+ ExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

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
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

			HSSFCell cell = null;
			cell = sheet.getRow(1).getCell((short) 5);
			cell.setCellValue(df.format(fromDate) + " ~ " + df.format(toDate));
			// List
			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short) 0)
					.getCellStyle();
			HSSFCellStyle normalStyle = sheet.getRow(ListStartRow).getCell((short) 1)
					.getCellStyle();
			HSSFCellStyle numStyle = sheet.getRow(ListStartRow).getCell((short) 2).getCellStyle();

			int ExcelRow = ListStartRow;
			double thr = 0;
			int daytotal = 0;

			HSSFRow HRow = null;
			HSSFRow HRow1 = null;
			for (int row = 0; row < sr.getRowCount(); row++) {
				int dc = 0;
				if (sr.getInt(row, "dc") > 0) {
					dc = sr.getInt(row, "dc");
				}
				daytotal = daytotal + dc;
				HRow = sheet.createRow(ExcelRow);
				cell = HRow.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row, "tsm_userlogin") + " : "
						+ sr.getString(row, "name"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row, "pid") + " : " + sr.getString(row, "pname"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 2);
				String cty = "";
				if ((sr.getString(row, "contracttype")).equals("TM")) {
					cty = "Time & Material";
				} else {
					cty = "Fixed Price";
				}
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(cty);
				cell.setCellStyle(normalStyle);

				cell = HRow.createCell((short) 3);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row, "cname"));
				cell.setCellStyle(normalStyle);

				cell = HRow.createCell((short) 4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(df.format(sr.getDate(row, "date")));
				cell.setCellStyle(normalStyle);

				cell = HRow.createCell((short) 5);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row, "servicetype"));
				cell.setCellStyle(normalStyle);

				cell = HRow.createCell((short) 6);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row, "event"));
				cell.setCellStyle(normalStyle);

				cell = HRow.createCell((short) 7);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getDouble(row, "hrs"));
				cell.setCellStyle(numStyle);

				cell = HRow.createCell((short) 8);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getInt(row, "dc") <= 0 ? 0 : sr.getInt(row, "dc"));
				cell.setCellStyle(numStyle);

				double hr = sr.getDouble(row, "hrs");
				thr = thr + hr;
				ExcelRow++;
			}
			HRow1 = sheet.createRow(sr.getRowCount() + ListStartRow);
			cell = HRow1.createCell((short) 6);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
			cell.setCellValue("Total :");
			cell.setCellStyle(boldTextStyle);

			cell = HRow1.createCell((short) 7);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
			cell.setCellValue(thr);
			cell.setCellStyle(numStyle);

			cell = HRow1.createCell((short) 8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
			cell.setCellValue(daytotal);
			cell.setCellStyle(numStyle);
			// ??Excel???
			wb.write(response.getOutputStream());
			// ??Excel?????
			response.getOutputStream().close();
			response.setStatus(HttpServletResponse.SC_OK);
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private String sendEmail(SQLResults sr, String fromDate, String endDate) {

		String flag = "emailEmpty";

		if (sr == null || sr.getRowCount() <= 0) {
			return flag;
		} else {
			try {
				EmailService.notifyUser(sr, fromDate, endDate);
				flag = "emailSucess";
			} catch (SQLException SQLEx) {
				SQLEx.printStackTrace();
				flag = "emailFalse";
			} catch (Exception e) {
				e.printStackTrace();
				flag = "emailFalse";
			}
		}
		return flag;
	}

	private final static String ExcelTemplate = "CAFStatus.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Outstanding CAF Status Report.xls";

	private final int ListStartRow = 6;
}