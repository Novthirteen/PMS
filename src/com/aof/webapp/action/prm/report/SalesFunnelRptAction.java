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
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Session;

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
import com.aof.webapp.action.ActionErrorLog;

/**
 * @author angus
 * 
 */
public class SalesFunnelRptAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		try {
			Session session = Hibernate2Session.currentSession();
			PartyHelper ph = new PartyHelper();

			String formAction = request.getParameter("formAction");
			String departmentId = request.getParameter("qryDepartmentId");
			String description = request.getParameter("description");
			String salesPerson = request.getParameter("qrySalesPerson");
			String includecheck = request.getParameter("includecheck");
			String status = request.getParameter("status");
			String viewType = request.getParameter("viewType");

			List partyList = null;
			UserLogin ul = (UserLogin) request.getSession().getAttribute(
					Constants.USERLOGIN_KEY);
			partyList = ph.getAllSubPartysByPartyId(session, ul.getParty()
					.getPartyId());
			if (partyList == null)
				partyList = new ArrayList();
			partyList.add(0, ul.getParty());
			request.setAttribute("PartyList", partyList);

			String PartyListStr = "''";
			if (departmentId != null && !departmentId.trim().equals("")) {
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
			String wherestr = "";

			SqlStr = SqlStr
					+ "select bm.bid_id as bidid,bm.bid_description as biddescription,p.description as department,ul.name as salesperson,currentstep.step_percentage as currentPercent,"
					+ "currentstep.step_id as currId,bidact.act_id as bidactId,step.step_description as stepDes,sa.act_description as actDes,"
					+ "sa.act_id as actId,step.step_id as stepId,step.step_percentage as percentage,company.description as company,bm.bid_status as status,"
					+ "bm.bid_est_amt as totalAmt,bm.bid_contract_type as contractType,bm.bid_est_start_date as startDate,bm.bid_est_end_date as endDate, bad.bidAct_id";
			SqlStr = SqlStr
					+ " from  Bid_Mstr as bm inner join user_login as ul on bm.bid_sales_person = ul.user_login_id";
			SqlStr = SqlStr
					+ " inner join Sales_Step_Group as ssg on bm.bid_sg_id = ssg.sg_id";
			SqlStr = SqlStr
					+ " inner join Sales_Step as step on step.step_sg_id = ssg.sg_id";
			SqlStr = SqlStr
					+ " inner join Sales_Activity as sa on sa.act_step_id = step.step_id";
			SqlStr = SqlStr
					+ " inner join party as p on p.party_id = bm.bid_dep_id";
			SqlStr = SqlStr
					+ " inner join party as company on company.party_id = bm.bid_prospect_company_id";
			if (includecheck != null)
				SqlStr = SqlStr + " left join";
			else
				SqlStr = SqlStr + " inner join";
			SqlStr = SqlStr
					+ " Sales_Step as currentstep on currentstep.step_id = bm.bid_curr_step_id";
			SqlStr = SqlStr
					+ " left join bid_activity as bidact on (bidact.act_id = sa.act_id and bidact.bid_id = bm.bid_id)";
			SqlStr = SqlStr
					+ " left JOIN Bid_Act_Det bad ON bad.bidAct_id = bidact.bidAct_id ";
			SqlStr += " inner join party as dept on dept.party_id = ul.party_id ";

			if (departmentId != null && !departmentId.trim().equals("")) {
				if (viewType.equals("sales")) {
					wherestr = wherestr + " where dept.is_sales = 'Y'";
				} else if (viewType.equals("bid")) {
					wherestr = wherestr + " where bm.bid_dep_id in ("
							+ PartyListStr + ")";
				}
			} else {
				wherestr = wherestr + " where bm.bid_sales_person = '"
						+ ul.getUserLoginId() + "'";
			}

			if (description != null && !description.trim().equals("")) {
				if (!wherestr.equals("")) {
					wherestr += " and company.description like '%"
							+ description + "%' or  company.CHS_Name like '%"
							+ description + "%'";
				} else {
					wherestr = " where company.description like '%"
							+ description + "%' or  company.CHS_Name like '%"
							+ description + "%'";
				}
			}
			if (salesPerson != null && !salesPerson.trim().equals("")) {
				if (!wherestr.equals("")) {
					wherestr += " and ul.user_login_id like '%" + salesPerson
							+ "%' or ul.NAME like '%" + salesPerson + "%'";
				} else {
					wherestr = " where ul.user_login_id like '%" + salesPerson
							+ "%' or ul.NAME like '%" + salesPerson + "%'";
				}
			}

			if (status != null && !status.equals("")) {
				if (!wherestr.equals("")) {
					if(status.equals("abl")){
						wherestr += " and bm.bid_status not in ('Lost/Drop', 'Deleted')";
					}else{
						wherestr += " and bm.bid_status = '" + status + "'";
					}
				} else {
					wherestr = " where bm.bid_status = '" + status + "'";
				}
			}

			if (!wherestr.equals("")) {
				SqlStr = SqlStr + wherestr
						+ " order by bm.bid_id,step.step_id,sa.act_id ";
			}
			System.out.println(SqlStr);

			SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);

			if ("ExportToExcel".equals(formAction)) {
				return ExportToExcel(mapping, request, response, sr);
			}
			if ("query".equals(formAction)) {
				request.setAttribute("QryList", sr);
			}
			request.setAttribute("includecheck", includecheck);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}

	private ActionForward ExportToExcel(ActionMapping mapping,
			HttpServletRequest request, HttpServletResponse response,
			SQLResults sr) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return null;
			}

			if (sr == null || sr.getRowCount() == 0)
				return null;

			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
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

			DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
			NumberFormat Num_formater = NumberFormat.getInstance();
			Num_formater.setMaximumFractionDigits(2);
			Num_formater.setMinimumFractionDigits(2);
			HSSFCell cell = null;
			int ExcelRow = ListStartRow;
			int ExcelLine = ListStartLine;
			HSSFRow HRow = null;
			HSSFRow ActivityRow = sheet.getRow(ExcelRow - 1);
			HSSFRow StepRow = sheet.getRow(ExcelRow - 2);

			HSSFCellStyle StyleTitle = sheet.getRow(ExcelRow - 2).getCell(
					(short) 1).getCellStyle();
			StyleTitle.setWrapText(true);

			HSSFCellStyle StyleTic = sheet.getRow(ExcelRow).getCell((short) 9)
					.getCellStyle();

			HSSFCellStyle StyleContent = sheet.getRow(ExcelRow).getCell(
					(short) 0).getCellStyle();
			// how many bids
			String bidid = sr.getString(0, "bidid");
			ArrayList bidList = new ArrayList();
			for (int row = 1; row < sr.getRowCount(); row++) {
				if (!bidid.equals(sr.getString(row, "bidid"))) {
					bidList.add(new Integer(row - 1));
				}
				if ((row + 1) == sr.getRowCount()) {
					bidList.add(new Integer(row));
				}
				bidid = sr.getString(row, "bidid");
			}

			String stepId = sr.getString(0, "stepId");
			ArrayList stepList = new ArrayList();
			int startTempt = 0;
			int srRow = ListStartLine;
			for (int row = 0; row <= ((Integer) bidList.get(0)).intValue(); row++) {
				if (!stepId.equals(sr.getString(row, "stepId"))) {
					String stepDes = sr.getString(row - 1, "stepDes");
					String percentage = sr.getString(row - 1, "percentage");

					stepList.add(new Integer(row - startTempt));

					cell = StepRow.createCell((short) (startTempt + srRow));
					sheet.addMergedRegion(new Region(ExcelRow - 2,
							(short) (startTempt + srRow), ExcelRow - 2,
							(short) (srRow + row - 1)));
					cell.setCellValue(percentage + "%" + "  " + stepDes);
					cell.setCellStyle(StyleTitle);
					startTempt = row;
				}
				if (row == ((Integer) bidList.get(0)).intValue()) {
					String stepDes = sr.getString(row, "stepDes");
					String percentage = sr.getString(row, "percentage");

					cell = StepRow.createCell((short) (startTempt + srRow));
					sheet.addMergedRegion(new Region(ExcelRow - 2,
							(short) (startTempt + srRow), ExcelRow - 2,
							(short) (srRow + ((Integer) bidList.get(0))
									.intValue())));
					cell.setCellValue(percentage + "%" + "  " + stepDes);
					cell.setCellStyle(StyleTitle);
					stepList.add(new Integer(((Integer) bidList.get(0))
							.intValue()
							- startTempt + 1));
				}
				stepId = sr.getString(row, "stepId");
			}

			for (int row = 0; row <= ((Integer) bidList.get(0)).intValue(); row++) {
				String actDes = sr.getString(row, "actDes");
				cell = ActivityRow.createCell((short) (srRow + row));
				cell.setCellValue(actDes);
				cell.setCellStyle(StyleTitle);
			}

			Iterator it = bidList.iterator();
			int startRow = 0;
			while (it.hasNext()) {// a bid
				HRow = sheet.createRow(ExcelRow);
				int endRow = ((Integer) it.next()).intValue();
				String deparment = sr.getString(endRow, "department");
				String salesPerson = sr.getString(endRow, "salesperson");
				String company = sr.getString(endRow, "company");
				String contractType = sr.getString(endRow, "contractType");
				Date startDate = sr.getDate(endRow, "startDate");
				Date endDate = sr.getDate(endRow, "endDate");
				double totalAmt = sr.getDouble(endRow, "totalAmt");
				int currentPercent = sr.getInt(endRow, "currentPercent");
				String status = sr.getString(endRow, "status");

				// bidAcitiviy
				int bidActRow = 0;
				for (int row = startRow; row <= endRow; row++) {
					if (sr.getString(row, "bidAct_id") != null) {
						cell = HRow.createCell((short) (ExcelLine + bidActRow));
						cell.setCellValue("a");
						cell.setCellStyle(StyleTic);
					} else {
						cell = HRow.createCell((short) (ExcelLine + bidActRow));
						cell.setCellStyle(StyleTic);
					}
					bidActRow++;
				}

				// department
				cell = HRow.createCell((short) 0);
				cell.setCellValue(deparment);
				cell.setCellStyle(StyleContent);

				// sales Person
				cell = HRow.createCell((short) 1);
				cell.setCellValue(salesPerson);
				cell.setCellStyle(StyleContent);

				// Company
				cell = HRow.createCell((short) 2);
				cell.setCellValue(company);
				cell.setCellStyle(StyleContent);

				// tcv
				cell = HRow.createCell((short) 3);
				cell.setCellValue(Num_formater.format(totalAmt));
				cell.setCellStyle(StyleContent);

				// status
				cell = HRow.createCell((short) 4);
				cell.setCellValue(status);
				cell.setCellStyle(StyleContent);

				// start date
				cell = HRow.createCell((short) 5);
				if (startDate != null && !startDate.equals("null")) {
					cell.setCellValue(df.format(startDate));
					cell.setCellStyle(StyleContent);
				} else {
					cell.setCellValue("");
				}

				// end date
				cell = HRow.createCell((short) 6);
				if (startDate != null && !startDate.equals("null")) {
					cell.setCellValue(df.format(endDate));
					cell.setCellStyle(StyleContent);
				} else {
					cell.setCellValue("");
				}

				// contract type
				cell = HRow.createCell((short) 7);
				cell.setCellValue(contractType);
				cell.setCellStyle(StyleContent);

				// Percentage
				cell = HRow.createCell((short) 8);
				cell.setCellValue(currentPercent);
				cell.setCellStyle(StyleContent);

				// bid activity

				ExcelRow++;
				startRow = endRow + 1;
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

	private final static String ExcelTemplate = "SalesFunnelRpt.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Sales Funnel Report.xls";

	private final int ListStartRow = 5;

	private final int ListStartLine = 9;
}