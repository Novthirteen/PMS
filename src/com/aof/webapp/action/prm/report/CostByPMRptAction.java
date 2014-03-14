/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.text.DateFormat;
import java.text.NumberFormat;
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
import org.apache.poi.hssf.usermodel.HSSFFont;
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
 * @author Jeffrey Liang
 * @version 2005-1-12
 *  
 */
public class CostByPMRptAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward execute(ActionMapping mapping, ActionForm form,
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
			String customerId = request.getParameter("customerId");
			String departmentId = request.getParameter("departmentId");
			if (customerId == null)
				customerId = "";
			if (departmentId == null)
				departmentId = "";
			if (FromDate == null)
				FromDate = Date_formater.format(UtilDateTime.getDiffDay(
						nowDate, -30));
			if (EndDate == null)
				EndDate = Date_formater.format(nowDate);
			if (action == null)
				action = "view";
			EndDate = EndDate + " 23:59";

			boolean detailflag = false;
			if (request.getParameter("detailflag") != null)
				detailflag = true;

			if (action.equals("QueryForList")) {
				SQLResults sr = findQueryResult(request, detailflag, FromDate,
						EndDate, customerId, departmentId);
				request.setAttribute("QryList", sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping, request, detailflag, response,
						FromDate, EndDate, customerId, departmentId);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}

	private SQLResults findQueryResult(HttpServletRequest request,
			boolean detailflag, String FromDate, String ToDate,
			String customerId, String departmentId) throws Exception {
		UserLogin ul = (UserLogin) request.getSession().getAttribute(
				Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
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
		SQLExecutor sqlExec = new SQLExecutor(Persistencer
				.getSQLExecutorConnection(EntityUtil
						.getConnectionByName("jdbc/aofdb")));
		
		String SqlStr = "";
		
		if (!detailflag) {
			SqlStr = SqlStr
	                 + "select ul.user_login_id, ul.name, p.description, proj.proj_id as proj_id, proj.proj_name, detres.user_id as user_id, detres.membername as membername, ";
			SqlStr = SqlStr
            		 + " detres.Rate as Rate, sum(detres.totalHrs) as totalHrs, sum(detres.PSC) as PSC, sum(detres.Expense) as Expense";
			SqlStr = SqlStr
					 + " from proj_mstr as proj inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
			SqlStr = SqlStr + " inner join party as p on proj.dep_id = p.party_id ";
			SqlStr = SqlStr + " inner join ( ";
		}
		
		SqlStr = SqlStr
		        + "select proj.proj_linknote, ul.user_login_id, ul.name, p.description, proj.proj_id, proj.proj_name,isnull(res.user_id,'') as user_id, isnull(member.name,'') as membername, ";
		SqlStr = SqlStr
				+ " res.costrate as Rate, sum(res.totalHrs) as totalHrs,sum(case when res.CostType = 'PSC' then res.totalAmt else 0 end) as PSC, ";
		SqlStr = SqlStr
				+ " sum(case when res.CostType = 'Expense' then res.totalAmt else 0 end) as Expense";
		SqlStr = SqlStr
				+ " from proj_mstr as proj inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
		SqlStr = SqlStr + " inner join party as p on proj.dep_id = p.party_id";

		// Down was deleted by Jackey Ding 2005-03-09
		//if (!detailflag) {
			//SqlStr = SqlStr
					//+ " inner join proj_mstr as subproj on left(subproj.proj_linknote,CHARINDEX(':',subproj.proj_linknote)-1) = proj.proj_id";
		//}
		// Up was deleted by Jackey Ding 2005-03-09
		
		SqlStr = SqlStr
				+ " right join (select tsd.ts_proj_id as proj_id, tsm.tsm_userlogin as user_id, 'PSC' as CostType,";
		SqlStr = SqlStr + " tsd.ts_user_rate as costrate,";
		SqlStr = SqlStr
				+ " sum(tsd.ts_hrs_user) as totalHrs, sum(tsd.ts_hrs_user * tsd.ts_user_rate) as totalAmt";
		SqlStr = SqlStr
				+ " from proj_ts_det as tsd inner join proj_ts_mstr as tsm on tsd.tsm_id = tsm.tsm_id ";
		SqlStr = SqlStr
				+ " inner join proj_mstr as proj on tsd.ts_proj_id = proj.proj_id";

		// Down was added by Jackey Ding 2005-03-04
		SqlStr = SqlStr
				+ " inner join user_login as user_login on (tsm.tsm_userlogin = user_login.user_login_id and user_login.note <>'EXT')";
		// Up was added by Jackey Ding 2005-03-04

		// Down was editd by Jackey Ding 2005-03-09
	    if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr
					+ " inner join party as dep on proj.dep_id = dep.party_id";
		} else {
			SqlStr = SqlStr
					+ " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
		}
		if (!customerId.trim().equals("")) {
			SqlStr = SqlStr
					+ " inner join party as cust on proj.cust_id = cust.party_id";
		} 	
		SqlStr = SqlStr
				+ " where tsd.ts_status = 'Approved' and (tsd.ts_date between '"
				+ FromDate + "' and '" + ToDate + "')";
		if (!customerId.trim().equals("")) {
			SqlStr = SqlStr + " and (cust.party_id like '%" + customerId.trim()
					+ "%' or cust.description like '%" + customerId.trim() + "%')";
		}
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " and dep.party_id in (" + PartyListStr + ")";
		} else {
			SqlStr = SqlStr + " and ul.user_login_id ='" + ul.getUserLoginId()
					+ "'";
		}
		SqlStr = SqlStr
				+ " group by tsd.ts_proj_id, tsm.tsm_userlogin, tsd.ts_user_rate";
		SqlStr = SqlStr + " union";
		SqlStr = SqlStr
				+ " select em.em_proj_id as proj_id, em.em_userlogin as user_id, 'Expense' as CostType,";
		SqlStr = SqlStr
				+ " 0 as costrate, 0 as totalHrs, sum(ea.ea_amt_user * em.em_Curr_Rate) as totalAmt";
		SqlStr = SqlStr
				+ " from Proj_Exp_Amt as ea inner join proj_exp_mstr as em on ea.em_id = em.em_id ";
		SqlStr = SqlStr
				+ " inner join proj_mstr as proj on em.em_proj_id = proj.proj_id";
	    if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr
					+ " inner join party as dep on proj.dep_id = dep.party_id";
		} else {
			SqlStr = SqlStr
					+ " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
		}
		if (!customerId.trim().equals("")) {
			SqlStr = SqlStr
					+ " inner join party as cust on proj.cust_id = cust.party_id";
		} 

		SqlStr = SqlStr
				+ " where em.em_claimtype='CN' and (em.em_approval_date between '"
				+ FromDate + "' and '" + ToDate + "')";
		if (!customerId.trim().equals("")) {
			SqlStr = SqlStr + " and (cust.party_id like '%" + customerId.trim()
					+ "%' or cust.description like '%" + customerId.trim() + "%')";
		}
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " and dep.party_id in (" + PartyListStr + ")";
		} else {
			SqlStr = SqlStr + " and ul.user_login_id ='" + ul.getUserLoginId()
					+ "'";
		}
		SqlStr = SqlStr + " group by em.em_proj_id, em.em_userlogin";
		SqlStr = SqlStr + " union";
		SqlStr = SqlStr
				+ " select pcd.proj_Id as proj_id, pcd.user_login_id as user_id, 'Expense' as CostType,";
		SqlStr = SqlStr
				+ " 0 as costrate, 0 as totalHrs, sum(pcd.percentage * pcm.totalvalue * pcm.exchangerate)/100 as totalAmt ";
		SqlStr = SqlStr
				+ " from proj_cost_det as pcd inner join proj_cost_mstr as pcm on pcd.costcode = pcm.costcode";
		//SqlStr = SqlStr
				//+ " inner join Proj_Cost_Type as pct on pct.typeid=pcm.type";

		SqlStr = SqlStr
				+ " inner join proj_mstr as proj on pcd.proj_Id = proj.proj_id";
	    if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr
					+ " inner join party as dep on proj.dep_id = dep.party_id";
		} else {
			SqlStr = SqlStr
					+ " inner join user_login as ul on proj.proj_pm_user = ul.user_login_id";
		}
		if (!customerId.trim().equals("")) {
			SqlStr = SqlStr
					+ " inner join party as cust on proj.cust_id = cust.party_id";
		} 	
		SqlStr = SqlStr
				+ " where pcm.claimtype='CN' " +
						//"and pct.typeaccount ='Expense' " +
						"and (pcm.approvalDate between '"
				+ FromDate + "' and '" + ToDate + "')";
		if (!customerId.trim().equals("")) {
			SqlStr = SqlStr + " and (cust.party_id like '%" + customerId.trim()
					+ "%' or cust.description like '%" + customerId.trim() + "%')";
		}
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " and dep.party_id in (" + PartyListStr + ")";
		} else {
			SqlStr = SqlStr + " and ul.user_login_id ='" + ul.getUserLoginId()
					+ "'";
		}
		SqlStr = SqlStr + " group by pcd.proj_Id, pcd.user_login_id";
		//if (detailflag) {
			SqlStr = SqlStr + " ) as res on proj.proj_id = res.proj_id";
		//} else {
			//SqlStr = SqlStr + " ) as res on subproj.proj_id = res.proj_id";
		//}
		// Up was editd by Jackey Ding 2005-03-09
		SqlStr = SqlStr
				+ " left join user_login as member on res.user_id = member.user_login_id";
		SqlStr = SqlStr
				+ " group by proj.proj_linknote, ul.user_login_id, ul.name, p.description, proj.proj_id, proj.proj_name,res.user_id, member.name ,res.costrate";
		if (detailflag) {
			SqlStr = SqlStr
					+ " order by proj.proj_linknote, ul.user_login_id, ul.name, p.description, proj.proj_id, proj.proj_name,res.user_id, member.name";
		} else {
			SqlStr = SqlStr
					+ ") as detres on proj.proj_id = LEFT(detres.proj_linknote,CHARINDEX(':', detres.proj_linknote)-1)";
			//SqlStr = SqlStr+" where detres.totalHrs>0"
			SqlStr = SqlStr		+ " group by ul.user_login_id, ul.name, p.description, proj.proj_id, proj.proj_name, detres.user_id, detres.membername ,detres.Rate";
			SqlStr = SqlStr
					+ " order by ul.user_login_id, ul.name, p.description, proj.proj_id, proj.proj_name, detres.user_id, detres.membername ";
		}
		System.out.println("\n"+SqlStr+"\n");
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		return sr;
	}

	private ActionForward ExportToExcel(ActionMapping mapping,
			HttpServletRequest request, boolean detailflag,
			HttpServletResponse response, String FromDate, String ToDate,
			String customerId, String departmentId) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return (mapping.findForward("Export"));
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			SQLResults sr = findQueryResult(request, detailflag, FromDate,
					ToDate, customerId, departmentId);
			if (sr == null || sr.getRowCount() == 0)
				return null;

			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""
					+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");

			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath
					+ "\\" + ExcelTemplate));
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
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

			HSSFCell cell = null;
			cell = sheet.getRow(0).getCell((short) 4);
			cell.setCellValue(df.format(fromDate) + " ~ " + df.format(toDate));

			//List
			HSSFCellStyle FormatStyle = sheet.getRow(ListStartRow).getCell(
					(short) 1).getCellStyle();
			HSSFCellStyle NumberFormatStyle = sheet.getRow(ListStartRow)
					.getCell((short) 3).getCellStyle();
			HSSFCellStyle BoldFormatStyle = sheet.getRow(ListStartRow).getCell(
					(short) 0).getCellStyle();
			HSSFCellStyle BoldNumberFormatStyle = sheet.getRow(ListStartRow)
					.getCell((short) 2).getCellStyle();
			HSSFCellStyle LeftBoldFormatStyle = sheet.getRow(ListStartRow)
					.getCell((short) 4).getCellStyle();
			NumberFormatStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
			BoldNumberFormatStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
			FormatStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			BoldFormatStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);

			String OldPM = "";
			String OldProject = "";
			String NewPM = "";
			String NewProject = "";
			String NewDep = "";
			double PMHrsTotal = 0;
			double PMPSCTotal = 0;
			double PMExpTotal = 0;
			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;

			for (int row = 0; row < sr.getRowCount(); row++) {
				NewPM = sr.getString(row, "user_login_id");
				NewProject = sr.getString(row, "proj_id");
				if (!OldProject.equals(NewProject)) {
					if (!OldProject.equals("")) {
						HRow = sheet.createRow(ExcelRow);

						cell = HRow.createCell((short) 0);
						cell.setCellStyle(BoldFormatStyle);

						cell = HRow.createCell((short) 1);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue("Project Total:");
						cell.setCellStyle(LeftBoldFormatStyle);

						cell = HRow.createCell((short) 2);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(PMHrsTotal);
						cell.setCellStyle(BoldNumberFormatStyle);

						cell = HRow.createCell((short) 3);
						cell.setCellStyle(BoldNumberFormatStyle);

						cell = HRow.createCell((short) 4);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(PMPSCTotal);
						cell.setCellStyle(BoldNumberFormatStyle);

						cell = HRow.createCell((short) 5);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(PMExpTotal);
						cell.setCellStyle(BoldNumberFormatStyle);

						ExcelRow++;
					}
					HRow = sheet.createRow(ExcelRow);
					cell = HRow.createCell((short) 0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Project Manager:"
							+ sr.getString(row, "name"));
					cell.setCellStyle(BoldFormatStyle);

					cell = HRow.createCell((short) 1);
					cell.setCellStyle(FormatStyle);

					cell = HRow.createCell((short) 2);
					cell.setCellStyle(BoldNumberFormatStyle);

					cell = HRow.createCell((short) 3);
					cell.setCellStyle(NumberFormatStyle);

					cell = HRow.createCell((short) 4);
					cell.setCellStyle(LeftBoldFormatStyle);

					cell = HRow.createCell((short) 5);
					cell.setCellStyle(NumberFormatStyle);

					ExcelRow++;

					HRow = sheet.createRow(ExcelRow);
					cell = HRow.createCell((short) 0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row, "description")+" -- "+sr.getString(row, "proj_id") + ":"
							+ sr.getString(row, "proj_name"));
					cell.setCellStyle(BoldFormatStyle);

					cell = HRow.createCell((short) 1);
					cell.setCellStyle(FormatStyle);

					cell = HRow.createCell((short) 2);
					cell.setCellStyle(BoldNumberFormatStyle);

					cell = HRow.createCell((short) 3);
					cell.setCellStyle(NumberFormatStyle);

					cell = HRow.createCell((short) 4);
					cell.setCellStyle(NumberFormatStyle);

					cell = HRow.createCell((short) 5);
					cell.setCellStyle(NumberFormatStyle);

					ExcelRow++;
					PMHrsTotal = 0;
					PMPSCTotal = 0;
					PMExpTotal = 0;
					OldProject = NewProject;
				} else {
					NewProject = "&nbsp;";
					NewDep = "&nbsp;";
				}
				PMHrsTotal = PMHrsTotal + sr.getDouble(row, "totalHrs");
				PMPSCTotal = PMPSCTotal + sr.getDouble(row, "PSC");
				PMExpTotal = PMExpTotal + sr.getDouble(row, "Expense");
				HRow = sheet.createRow(ExcelRow);

				cell = HRow.createCell((short) 0);
				cell.setCellStyle(FormatStyle);

				cell = HRow.createCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row, "membername"));
				cell.setCellStyle(FormatStyle);

				cell = HRow.createCell((short) 2);
				cell.setCellValue(sr.getDouble(row, "totalHrs"));
				cell.setCellStyle(NumberFormatStyle);

				cell = HRow.createCell((short) 3);
				cell.setCellValue(sr.getDouble(row, "Rate"));
				cell.setCellStyle(NumberFormatStyle);

				cell = HRow.createCell((short) 4);
				cell.setCellValue(sr.getDouble(row, "PSC"));
				cell.setCellStyle(NumberFormatStyle);

				cell = HRow.createCell((short) 5);
				cell.setCellValue(sr.getDouble(row, "Expense"));
				cell.setCellStyle(NumberFormatStyle);

				ExcelRow++;
			}
			HRow = sheet.createRow(ExcelRow);

			cell = HRow.createCell((short) 0);
			cell.setCellStyle(BoldFormatStyle);
			cell = HRow.createCell((short) 1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue("Project Total:");
			cell.setCellStyle(LeftBoldFormatStyle);
			cell = HRow.createCell((short) 2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(PMHrsTotal);
			cell.setCellStyle(BoldNumberFormatStyle);
			cell = HRow.createCell((short) 3);
			cell.setCellStyle(BoldFormatStyle);
			cell = HRow.createCell((short) 4);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(PMPSCTotal);
			cell.setCellStyle(BoldNumberFormatStyle);
			cell = HRow.createCell((short) 5);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(PMExpTotal);
			cell.setCellStyle(BoldNumberFormatStyle);
			ExcelRow++;
			//写入Excel工作表
			wb.write(response.getOutputStream());
			//关闭Excel工作薄对象
			response.getOutputStream().close();
			response.setStatus(HttpServletResponse.SC_OK);
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private final static String ExcelTemplate = "CostsByPM.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Costs By Project Manager.xls";

	private final int ListStartRow = 5;
}