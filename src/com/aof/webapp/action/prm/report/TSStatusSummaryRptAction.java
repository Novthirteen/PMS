/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
 * @author angus chen
 * @version 2005-1-12
 * 
 */
public class TSStatusSummaryRptAction extends ReportBaseAction {
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
			String FromDate = request.getParameter("dateStart");
			String EndDate = request.getParameter("dateEnd");
			String EmployeeId = request.getParameter("EmployeeId");
			String departmentId = request.getParameter("departmentId");

			if (EmployeeId == null)
				EmployeeId = "";
			if (departmentId == null)
				departmentId = "";
			if (FromDate == null)
				FromDate = Date_formater.format(UtilDateTime.getDiffDay(
						nowDate, -30));
			if (EndDate == null)
				EndDate = Date_formater.format(nowDate);
			if (action == null)
				action = "view";
			String strEndDate = EndDate;
			EndDate = EndDate + " 23:59";
			System.out.println("fromdata:" + FromDate + "\n");
			System.out.println("EndDate:" + EndDate + "\n");

			boolean InternFlag = false;
			if (request.getParameter("InternFlag") != null)
				InternFlag = true;

			if (action.equals("QueryForList")) {
				SQLResults sr = findQueryResult(request, FromDate, EndDate,
						EmployeeId, departmentId, InternFlag);
				request.setAttribute("QryList", sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping, request, response, FromDate,
						EndDate, EmployeeId, departmentId, InternFlag);
			}

			if (action.equals("sendMail")) {
				SQLResults mr = findQueryResult(request, FromDate, EndDate,
						EmployeeId, departmentId, InternFlag);

				// add by will begin. 2006-06-01
				double workHr = 0.00;
				double totalSbmHr = 0.00;
				String strEmailAddr = null;
				String strType = null;
				for (int row = 0; row < mr.getRowCount(); row++) {
					workHr = mr.getDouble(row, "working_hours");
					totalSbmHr = mr.getDouble(row, "total_Submitted_hours");
					strType = mr.getString(row,"type");
					if (totalSbmHr < workHr) {
						if(!strType.trim().equals("FTE")){
							if (strEmailAddr == null || strEmailAddr.equals("")) {
								strEmailAddr = mr.getString(row, "email_addr");
							} else {
								strEmailAddr = strEmailAddr + ";"
										+ mr.getString(row, "email_addr");
							}
						}
					}
				}
				String emailFlag = null;
				if (strEmailAddr != null && !strEmailAddr.trim().equals("")) {
					emailFlag = sendEmail(response, strEmailAddr, FromDate,
							strEndDate);
				} else {
					emailFlag = "emailEmpty";
				}
				request.setAttribute("emailFlag", emailFlag);
				return mapping.findForward("success");
			}
			// add by Will end.
		} catch (Exception e) {
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}

	private SQLResults findQueryResult(HttpServletRequest request,
			String FromDate, String ToDate, String EmployeeId,
			String departmentId, boolean InternFlag) throws Exception {
		UserLogin ul = (UserLogin) request.getSession().getAttribute(
				Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String JoinStr = "";
		String PartyListStr = "''";
		if (!departmentId.trim().equals("")) {
			List partyList_dep = ph.getAllSubPartysByPartyId(session,
					departmentId);
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'" + departmentId + "'";
			while (itdep.hasNext()) {
				Party p = (Party) itdep.next();
				PartyListStr = PartyListStr + ", '" + p.getPartyId() + "'";
			}
		}
		StringTokenizer st = new StringTokenizer(ToDate, "-");
		int year = Integer.parseInt(st.nextToken());
		int month = Integer.parseInt(st.nextToken());
		String day = st.nextToken();
		String nextToDate ="3006-12-31 23:59:59";

		SQLExecutor sqlExec = new SQLExecutor(Persistencer
				.getSQLExecutorConnection(EntityUtil
						.getConnectionByName("jdbc/aofdb")));

		String SqlStr = "select "
				+ " a.e_id as e_id, "
				+ " a.description,"
				+ " b.email_addr as email_addr,"
				+ " a.e_name as e_name, a.intern,a.type as type, "
				+ " b.pc_hours as working_hours,"
				+ " a.total_Submitted_hours as total_Submitted_hours,"
				+ " isnull(a.total_UnpaidVacation_hours,0) as total_UnpaidVacation_hours,"
				+ " isnull(a.total_AnnualLeave_hours,0) as total_AnnualLeave_hours,"
				+ " isnull(a.total_CompensationLeave_hours,0) as total_CompensationLeave_hours,"
				+ " a.total_SubmittedBillable_hours as total_SubmittedBillable_hours,"
				+ " a.total_ApprovedBillable_hours as total_ApprovedBillable_hours, "
				+ " a.total_ApprovedBillable_hours/(b.pc_hours - isnull(a.total_UnpaidVacation_hours,0) - isnull(a.total_AnnualLeave_hours,0))*100 as ApprovedUtil,"
				+ " a.total_SubmittedBillable_hours/(b.pc_hours - isnull(a.total_UnpaidVacation_hours,0) - isnull(a.total_AnnualLeave_hours,0))*100 as SubmittedUtil,"
				+ " a.total_Presales_hours as total_Presales_hours ,"
				+ " a.total_Training_hours as total_Training_hours  ,"
				+ " a.total_MeetingAndMng_hours as total_MeetingAndMng_hours ,"
				+ " a.total_RschAndDevp_hours as total_RschAndDevp_hours  ,"
				+ " a.total_Travel_hours as total_Travel_hours  ,"
				+
				// " a.total_FreeCharge_hours as total_FreeCharge_hours ,"+
				// " a.total_OtherNonBillable_hours as
				// total_OtherNonBillable_hours ,"+
				" a.total_ExcpHoliday_hours as total_ExcpHoliday_hours ,"
				+ " a.total_Sickness_hours as total_Sickness_hours  ,"
				+ " a.total_Bench_hours as total_Bench_hours  ,"
				+ " a.total_otherInactivity_hours as total_otherInactivity_hours  "
				+ " from ( "
				+ "select ul.PC_Type_Id as PC_Type_Id, ul.user_login_id as e_id, p.description, ul.name as e_name, ul.intern, ul.type as type,"
				+ "sum(case when  (tsd.ts_status <>'Draft' ) then tsd.ts_hrs_user end) as total_Submitted_hours, "
				+ "sum(case when (pe.pevent_name ='Unpaid Vacation') then tsd.ts_hrs_user end) as total_UnpaidVacation_hours ,"
				+ "sum(case when (pe.pevent_name ='Annual Leave') then tsd.ts_hrs_user end) as total_AnnualLeave_hours ,"
				+ "sum(case when (pe.pevent_name ='Compensation Leave') then tsd.ts_hrs_user end) as total_CompensationLeave_hours ,"
				+ "sum(case when  (tsd.ts_status <>'Draft' and  (pe.Billable = 'yes'))  then tsd.ts_hrs_user end) as total_SubmittedBillable_hours,  "
				+ "sum(case when  (tsd.ts_status = 'Approved'and (pe.Billable ='yes'))  then tsd.ts_hrs_user end) as total_ApprovedBillable_hours, "
				+ "sum(case when (tsd.ts_projevent ='90' or tsd.ts_projevent ='125') and (tsd.ts_status <>'Draft') then tsd.ts_hrs_user end) as total_Presales_hours ,"
				+ "sum(case when (tsd.ts_projevent ='91') and (tsd.ts_status <>'Draft') then tsd.ts_hrs_user end) as total_Training_hours ,"
				+ "sum(case when (tsd.ts_projevent ='92') and (tsd.ts_status <>'Draft') then tsd.ts_hrs_user end) as total_MeetingAndMng_hours ,"
				+ "sum(case when (tsd.ts_projevent ='93') and (tsd.ts_status <>'Draft') then tsd.ts_hrs_user end) as total_RschAndDevp_hours ,"
				+ "sum(case when (tsd.ts_projevent ='94') and (tsd.ts_status <>'Draft') then tsd.ts_hrs_user end) as total_Travel_hours ,"
				+
				// "sum(case when (tsd.ts_projevent ='120') and (tsd.ts_status
				// <>'Draft') then tsd.ts_hrs_user end) as
				// total_FreeCharge_hours ,"+
				// "sum(case when (tsd.ts_projevent ='122') and (tsd.ts_status
				// <>'Draft') then tsd.ts_hrs_user end) as
				// total_OtherNonBillable_hours ,"+
				"sum(case when (tsd.ts_projevent ='95') and (tsd.ts_status <>'Draft') then tsd.ts_hrs_user end) as total_ExcpHoliday_hours ,"
				+ "sum(case when (tsd.ts_projevent ='96') and (tsd.ts_status <>'Draft') then tsd.ts_hrs_user end) as total_Sickness_hours ,"
				+ "sum(case when (tsd.ts_projevent ='97') and (tsd.ts_status <>'Draft') then tsd.ts_hrs_user end) as total_Bench_hours ,"
				+ "sum(case when (tsd.ts_projevent ='98') and (tsd.ts_status <>'Draft') then tsd.ts_hrs_user end) as total_otherInactivity_hours "
				+ "from party as p inner join user_login as ul on (p.party_id = ul.party_id and ul.note <>'EXT') and ul.account_type='direct'";
		if (!InternFlag) {
			SqlStr = SqlStr + " and ul.intern <>'Y' ";
		}

		if (!departmentId.trim().equals("")) {
			JoinStr = " left join ";
		} else {
			JoinStr = " inner join ";
		}
		SqlStr = SqlStr
				+ JoinStr
				+ "proj_ts_mstr as ptsm on ul.user_login_id = ptsm.tsm_userlogin ";
		SqlStr = SqlStr
				+ JoinStr
				+ "proj_ts_det as tsd on (ptsm.tsm_id = tsd.tsm_id and tsd.ts_date between '"
				+ FromDate + "' and '" + ToDate + "')";
		SqlStr = SqlStr + JoinStr
				+ "projEvent as pe on (tsd.ts_projevent = pe.PEvent_Id ) ";
		SqlStr = SqlStr + JoinStr
				+ "proj_mstr as projm on tsd.ts_proj_id = projm.proj_id ";
		SqlStr = SqlStr
				+ " where( (ul.leave_day is null and ul.join_day<=convert(datetime,'"
				+ ToDate
				+ "')) "
				+ " or (ul.leave_day is not null and ul.leave_day>=convert(datetime,'"
				+ FromDate + "') and ul.join_day<=convert(datetime,'" + ToDate
				+ "')))" + " and ";
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " p.party_id in (" + PartyListStr + ")";
		} else {
			SqlStr = SqlStr + " projm.proj_pm_user ='" + ul.getUserLoginId()
					+ "'";
		}
		if (!EmployeeId.trim().equals("")) {
			SqlStr = SqlStr + " and (ul.user_login_id like '%"
					+ EmployeeId.trim() + "%' or ul.name like '%"
					+ EmployeeId.trim() + "%')";
		}
		SqlStr = SqlStr
				+ " group by p.description, ul.PC_Type_Id, ul.user_login_id, ul.name, ul.intern,ul.type) as a ";

		SqlStr = SqlStr
				+ "left join(select ul.user_login_id as user_login_id,ul.email_addr as email_addr,sum(pc.pc_hours)as pc_hours,pc.pc_type_id as pc_type_id from proj_calendar as pc,user_login as ul "
				+ " where datediff(day,pc.pc_date ,case when (DATEDIFF(DAY,ul.join_day,convert(datetime,'"
				+ FromDate
				+ "'))>=0)  "
				+ " then convert(datetime,'"
				+ FromDate
				+ "')else ul.join_day end )<=0 "
				+ " and datediff(day,pc.pc_date ,"
				+ " case when (DATEDIFF(DAY,isnull(ul.leave_day,convert(datetime,'"
				+ nextToDate + "'))," + " convert(datetime,'" + ToDate
				+ "'))<0) then convert(datetime,'" + ToDate
				+ "') else ul.leave_day  end )>=0"
				+ " and pc.pc_type_id=ul.pc_type_id "
				+ " group by ul.user_login_id,pc.pc_type_Id,ul.email_addr)as b"
				+ " on b.user_login_id=a.e_id and a.pc_type_id = b.pc_type_id "
				+

				/*
				 * " left join(select sum(PC_Hours) as pc_hours, pc_type_id as
				 * pc_type_id " + " from Proj_Calendar " + " where PC_Date
				 * between '"+FromDate+"' and '"+ToDate+"' " + " group by
				 * pc_type_id) as b on a.pc_type_id = b.pc_type_id" +
				 */
				" order by a.description, a.e_id";
		System.out.println("\n" + SqlStr + "\n");

		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);

		// SQLResults sr =null;

		return sr;
	}

	private ActionForward ExportToExcel(ActionMapping mapping,
			HttpServletRequest request, HttpServletResponse response,
			String FromDate, String ToDate, String EmployeeId,
			String departmentId, boolean InternFlag) {
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

			SQLResults sr = findQueryResult(request, FromDate, ToDate,
					EmployeeId, departmentId, InternFlag);
			if (sr == null || sr.getRowCount() == 0)
				return null;

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""
					+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath
					+ "\\" + ExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			// Header
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
			cell = sheet.getRow(1).getCell((short) 14);
			cell.setCellValue(Date_formater.format(fromDate));
			cell = sheet.getRow(1).getCell((short) 19);
			cell.setCellValue(Date_formater.format(toDate));

			// List
			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell(
					(short) 0).getCellStyle();
			HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow)
					.getCell((short) 3).getCellStyle();
			HSSFCellStyle percentageFormatStyle = sheet.getRow(ListStartRow)
					.getCell((short) 10).getCellStyle();
			HSSFCellStyle redTextStyle = sheet.getRow(ListStartRow).getCell(
					(short) 14).getCellStyle();
			HSSFCellStyle titleTextStyle = sheet.getRow(ListStartRow - 1)
					.getCell((short) 0).getCellStyle();

			int ExcelRow = ListStartRow;
			double tolSumUtil = 0.0;
			double tolAprvUtil = 0.0;
			HSSFRow HRow = null;
			for (int row = 0; row < sr.getRowCount(); row++) {
				
				double temp1 = sr.getDouble(row,"working_hours");
				double temp2 = sr.getDouble(row,"total_UnpaidVacation_hours")+sr.getDouble(row,"total_AnnualLeave_hours")+sr.getDouble(row,"total_CompensationLeave_hours");
				double total_SubmittedBillable_hours = temp1-temp2;

				HRow = sheet.createRow(ExcelRow);
				cell = HRow.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row, "description"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row, "e_id"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				String name = sr.getString(row, "e_name");
				if (sr.getString(row, "intern").equals("Y"))
					name = name + "(intern)";
				if (sr.getString(row, "type").equals("FTE"))
					name = name + "(FTE)";
				cell.setCellValue(name);
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short) 3);
				cell.setCellValue(sr.getDouble(row, "working_hours"));
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 4);
				cell.setCellValue(sr.getDouble(row, "total_Submitted_hours"));
				double wkHr = sr.getDouble(row, "working_hours");
				double tsHr = sr.getDouble(row, "total_Submitted_hours");
				if (wkHr > tsHr) {
					cell.setCellStyle(redTextStyle);
				} else
					cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 5);
				cell.setCellValue(sr.getDouble(row,
						"total_UnpaidVacation_hours"));
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 6);
				cell.setCellValue(sr.getDouble(row, "total_AnnualLeave_hours"));
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 7);
				cell.setCellValue(sr.getDouble(row,
						"total_CompensationLeave_hours"));
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 8);
				if(sr.getString(row,"type").equals("FTE"))
					cell.setCellValue(total_SubmittedBillable_hours);
				else
					cell.setCellValue(sr.getDouble(row,"total_SubmittedBillable_hours"));				
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 9);
				if(sr.getString(row,"type").equals("FTE"))
					cell.setCellValue(total_SubmittedBillable_hours);
				else
					cell.setCellValue(sr.getDouble(row,"total_ApprovedBillable_hours"));				
				cell.setCellStyle(numberFormatStyle);

				double uti = 0;
				uti = (sr.getDouble(row, "SubmittedUtil")) / 100;
				if (uti > 1)
					uti = 1;
				if (sr.getString(row, "type").equals("FTE"))
					uti = 1;

				cell = HRow.createCell((short) 10);
				cell.setCellValue(uti);
				cell.setCellStyle(percentageFormatStyle);

				double uti2 = 0;
				uti2 = (sr.getDouble(row, "ApprovedUtil")) / 100;
				if (uti2 > 1)
					uti2 = 1;
				if (sr.getString(row, "type").equals("FTE"))
					uti2 = 1;

				tolSumUtil = tolSumUtil + uti;
				tolAprvUtil = tolAprvUtil + uti2;

				cell = HRow.createCell((short) 11);
				cell.setCellValue(uti2);
				cell.setCellStyle(percentageFormatStyle);

				cell = HRow.createCell((short) 12);
				cell.setCellValue(sr.getDouble(row, "total_Presales_hours"));
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 13);
				cell.setCellValue(sr.getDouble(row, "total_Training_hours"));
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 14);
				cell.setCellValue(sr
						.getDouble(row, "total_MeetingAndMng_hours"));
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 15);
				cell.setCellValue(sr.getDouble(row, "total_RschAndDevp_hours"));
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 16);
				cell.setCellValue(sr.getDouble(row, "total_Travel_hours"));
				cell.setCellStyle(numberFormatStyle);

				// cell = HRow.createCell((short)17);
				// cell.setCellValue(sr.getDouble(row,"total_FreeCharge_hours"));
				// cell.setCellStyle(numberFormatStyle);

				// cell = HRow.createCell((short)18);
				// cell.setCellValue(sr.getDouble(row,"total_OtherNonBillable_hours"));
				// cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 17);
				cell.setCellValue(sr.getDouble(row, "total_ExcpHoliday_hours"));
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 18);
				cell.setCellValue(sr.getDouble(row, "total_Sickness_hours"));
				cell.setCellStyle(numberFormatStyle);

				cell = HRow.createCell((short) 19);
				cell.setCellValue(sr.getDouble(row, "total_Bench_hours"));
				cell.setCellStyle(numberFormatStyle);

				// cell = HRow.createCell((short) 20);
				// cell.setCellValue(sr.getDouble(row,
				// "total_otherInactivity_hours"));
				// cell.setCellStyle(numberFormatStyle);

				ExcelRow++;
			}

			HRow = sheet.createRow(ExcelRow);
			cell = HRow.createCell((short) 0);
			sheet.addMergedRegion(new Region(ExcelRow, (short) 0, ExcelRow,
					(short) 4));
			cell.setCellValue("Total Rate");
			cell.setCellStyle(titleTextStyle);

			for (int j = 1; j < 10; j++) {
				cell = HRow.createCell((short) j);
				// cell.setCellValue("");
				cell.setCellStyle(boldTextStyle);
			}

			cell = HRow.createCell((short) 10);
			cell.setCellValue(tolSumUtil / sr.getRowCount());
			cell.setCellStyle(percentageFormatStyle);

			cell = HRow.createCell((short) 11);
			cell.setCellValue(tolAprvUtil / sr.getRowCount());
			cell.setCellStyle(percentageFormatStyle);

			for (int j = 12; j < 21; j++) {
				cell = HRow.createCell((short) j);
				// cell.setCellValue("");
				cell.setCellStyle(boldTextStyle);
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

	private String sendEmail(HttpServletResponse response, String theEmailAddr,
			String theFromDate, String theEndDate) {
		String flag = "emailFalse";
		try {
			String emailAddr = theEmailAddr;
			String fromDate = theFromDate;
			String endDate = theEndDate;
			EmailService.notifyUser(emailAddr, fromDate, endDate);
			flag = "emailSucess";
		} catch (SQLException SQLEx) {
			SQLEx.printStackTrace();
			// flag = "emailFalse";
		} catch (Exception e) {
			e.printStackTrace();
			// flag = "emailFalse";
		}
		return flag;
	}

	private final static String ExcelTemplate = "UtilizationRpt.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Utilization Report.xls";

	private final int ListStartRow = 7;
}