/*
 * Created on 2005-7-8
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.webapp.action.prm.bid;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import org.apache.commons.beanutils.RowSetDynaClass;
import org.apache.log4j.Logger;
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

/**
 * @author CN01512
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class FindBidMasterAction extends ReportBaseAction {

	private Logger log = Logger.getLogger(FindStepGroupAction.class);

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			long timeStart = System.currentTimeMillis(); // for performance
			// test

			Session session = Hibernate2Session.currentSession();
			PartyHelper ph = new PartyHelper();
			SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
					.getConnectionByName("jdbc/aofdb")));
			String formAction = request.getParameter("formAction");
			String departmentId = request.getParameter("qryDepartmentId");
			String salesPerson = request.getParameter("qrySalesPerson");
			String description = request.getParameter("desc");
			String status = request.getParameter("status");
			String bno = request.getParameter("bno");
			String pros = request.getParameter("pros");

			if (formAction == null) {
				formAction = "query";
			}

			if (departmentId == null || departmentId.equals("null")) {
				departmentId = "self";
			}
			
			if(status == null)status = "active";

			List partyList = null;
			UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			partyList = ph.getAllSubPartysByPartyId(session, ul.getParty().getPartyId());
			if (partyList == null)
				partyList = new ArrayList();
			partyList.add(0, ul.getParty());
			request.setAttribute("PartyList", partyList);

			String PartyListStr = "''";
			if (departmentId != null && !departmentId.trim().equals("")) {
				List partyList_dep = ph.getAllSubPartysByPartyId(session, departmentId);
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'" + departmentId + "'";
				while (itdep.hasNext()) {
					Party p = (Party) itdep.next();
					PartyListStr = PartyListStr + ", '" + p.getPartyId() + "'";
				}
			}

			/*
			 * String userPartyListStr = ""; String userPartyId =
			 * ul.getParty().getPartyId(); if (userPartyId != null &&
			 * !userPartyId.trim().equals("")) { List userpartyList_dep =
			 * ph.getAllSubPartysByPartyId(session, userPartyId); Iterator itdep =
			 * userpartyList_dep.iterator(); userPartyListStr = "'" +
			 * userPartyId + "'"; while (itdep.hasNext()) { Party p = (Party)
			 * itdep.next(); userPartyListStr = userPartyListStr + ", '" +
			 * p.getPartyId() + "'"; } }
			 */
			if (formAction == null)
				formAction = "";
			if (formAction.equals("query") || formAction.equals("dialogView")
					|| formAction.equals("export")) {
				// SQLExecutor sqlExec = new
				// SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));

				String SqlStr = " select bm.bid_id as id, bm.bid_no, bm.bid_description,p.party_id as dep_id, p.description as dep,	";

				SqlStr = SqlStr
						+ (" ul1.user_login_id as sales_id, ul1.name as sales, ul2.user_login_id as second_sales_id, ul2.name as second_sales, bm.bid_est_amt as bid_est_amt, ");
				SqlStr = SqlStr
						+ (" bm.bid_exchange_rate as exchange_rate, convert(varchar(10), bm.bid_est_start_date, (126)) as start_date, convert(varchar(10), bm.bid_est_end_date, (126)) as end_date, ");
				SqlStr = SqlStr
						+ (" cur.curr_id as currency_id, cur.curr_name as currency_name, bm.bid_contract_type as contract_type, ");
				SqlStr = SqlStr
						+ (" convert(varchar(10), bm.expected_end_date , (126)) as expected_end_date, bm.bid_status, p1.party_id as custId, p1.description as prospect,	st.step_percentage ");
				SqlStr = SqlStr + (" from bid_mstr as bm	");
				SqlStr = SqlStr + (" inner join party as p on bm.bid_dep_id =p.party_id	");
				SqlStr = SqlStr
						+ (" inner join user_login as ul1 on ul1.user_login_id = bm.bid_sales_person	");
				SqlStr = SqlStr
						+ (" left join user_login as ul2 on ul2.user_login_id = secondary_sales	");
				SqlStr = SqlStr
						+ (" inner join party as p1 on p1.party_id= bm.bid_prospect_company_id ");
				SqlStr = SqlStr + (" inner join party as p2 on p2.party_id= ul1.party_id");
				SqlStr = SqlStr + (" inner join currency as cur on bm.bid_currency = cur.curr_id");
				SqlStr = SqlStr
						+ (" left join sales_step as st on st.step_id = bm.bid_curr_step_id	");

				SqlStr = SqlStr + (" Where ");
				if (departmentId != null && !departmentId.trim().equals("")) {
					if (departmentId.equals("self")) {
						SqlStr = SqlStr
								+ (" (ul1.user_login_id = '" + ul.getUserLoginId()
										+ "' or ul2.user_login_id = '" + ul.getUserLoginId() + "')");
					} else {
						if (ul.getParty().getIsSales() != null
								&& ul.getParty().getIsSales().equals("Y")) {
							SqlStr = SqlStr
									+ (" (ul1.party_id = '" + ul.getParty().getPartyId()
											+ "' or ul2.party_id = '" + ul.getParty().getPartyId() + "')");
						}
						if (ul.getParty().getIsSales() != null
								&& ul.getParty().getIsSales().equals("N")) {
							SqlStr = SqlStr + ("  p.party_id in (" + PartyListStr + ")");
						}

					}
				}

				if (description != null && !description.trim().equals("")) {
					SqlStr = SqlStr + (" and bm.bid_description like '%" + description + "%' ");
				}

				if (bno != null && !bno.trim().equals("")) {
					SqlStr = SqlStr + (" and bm.bid_no like '%" + bno + "%' ");
				}

				if (pros != null && !pros.trim().equals("")) {
					SqlStr = SqlStr
							+ (" and (( p1.party_id like '%" + pros
									+ "%') or (p1.description like '%" + pros + "%')) ");
				}

				if (status != null && status.trim().length() != 0) {
					if (status.equalsIgnoreCase("abl")) {
						SqlStr = SqlStr + ("  and bm.bid_status not in ('Lost/Drop', 'deleted' ) ");
					} else {
						SqlStr = SqlStr + ("  and bm.bid_status = '" + status + "' ");
					}
				}

				if (salesPerson != null && !salesPerson.trim().equals("")) {
					SqlStr = SqlStr
							+ (" and (ul1.user_login_id like '%" + salesPerson
									+ "%' or ul2.user_login_id like '%" + salesPerson
									+ "%' or ul2.name like '%" + salesPerson
									+ "%' or ul1.name like '%" + salesPerson + "%')");
				}
				SqlStr = SqlStr + (" and bm.bid_status <>'deleted' order by bm.bid_no, ul1.name	");
				
				if(formAction != null && formAction.equals("dialogView")){
					SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
					request.setAttribute("QryList", sr);
				} else {
					ResultSet result = sqlExec.runQueryStreamResults(SqlStr);
					RowSetDynaClass resultSet = new RowSetDynaClass(result, false);
					request.setAttribute("QryList", resultSet);
					sqlExec.closeConnection();
				}

				long timeEnd = System.currentTimeMillis(); // for performance
				// test
				log.info("it takes " + (timeEnd - timeStart) + " ms to excute the query...");

				// if (formAction.equals("export")) {
				// return exportToExcel(response, result);
				// }

			}
			if (formAction != null && formAction.equals("dialogView")) {
				return (mapping.findForward("dialogView"));
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
		return mapping.findForward("view");
	}
	/*
	 * private ActionForward exportToExcel(HttpServletResponse response,
	 * SQLResults result) {
	 * 
	 * try { // Get Excel Template Path String TemplatePath =
	 * GetTemplateFolder(); if (TemplatePath == null) { return null; }
	 *  // Start to output the excel file response.reset();
	 * response.setHeader("Content-Disposition", "attachment;filename=\"" +
	 * SaveToFileName + "\"");
	 * response.setContentType("application/octet-stream");
	 *  // Use POI to read the selected Excel Spreadsheet HSSFWorkbook wb = new
	 * HSSFWorkbook(new FileInputStream(TemplatePath + "\\" + ExcelTemplate)); //
	 * Select the first worksheet HSSFSheet sheet = wb.getSheet(FormSheetName);
	 *  // Header HSSFRow row = null; HSSFCell cell = null;
	 *  // List int excelRow = ListStartRow;
	 *  // Style HSSFCellStyle textStyle =
	 * sheet.getRow(ListStartRow).getCell((short) 0).getCellStyle();
	 * HSSFCellStyle numberStyle = sheet.getRow(ListStartRow).getCell((short) 6)
	 * .getCellStyle();
	 * 
	 * for (int i = 0; i < result.getRowCount(); i++) {
	 * 
	 * row = sheet.getRow(excelRow);
	 * 
	 * cell = row.createCell((short) 0);
	 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	 * cell.setCellValue(result.getString(i, "bid_no") == null ? "" :
	 * result.getString(i, "bid_no")); cell.setCellStyle(textStyle);
	 * 
	 * cell = row.createCell((short) 1);
	 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	 * cell.setCellValue(result.getString(i, "prospect") == null ? "" :
	 * result.getString( i, "prospect")); cell.setCellStyle(textStyle);
	 * 
	 * cell = row.createCell((short) 2);
	 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	 * cell.setCellValue(result.getString(i, "bid_description") == null ? "" :
	 * result .getString(i, "bid_description")); cell.setCellStyle(textStyle);
	 * 
	 * cell = row.createCell((short) 3);
	 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	 * cell.setCellValue(result.getString(i, "dep") == null ? "" :
	 * result.getString(i, "dep")); cell.setCellStyle(textStyle);
	 * 
	 * cell = row.createCell((short) 4);
	 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	 * cell.setCellValue(result.getString(i, "sales") == null ? "" :
	 * result.getString(i, "sales")); cell.setCellStyle(textStyle);
	 * 
	 * cell = row.createCell((short) 5);
	 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	 * cell.setCellValue(result.getString(i, "second_sales") == null ? "" :
	 * result .getString(i, "second_sales")); cell.setCellStyle(textStyle);
	 * 
	 * cell = row.createCell((short) 6);
	 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	 * cell.setCellValue(result.getString(i, "bid_est_amt") == null ? "" :
	 * result .getString(i, "bid_est_amt")); cell.setCellStyle(numberStyle);
	 * 
	 * cell = row.createCell((short) 7);
	 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	 * cell.setCellValue(result.getString(i, "expected_end_date") == null ? "" :
	 * result .getString(i, "expected_end_date")); cell.setCellStyle(textStyle);
	 * 
	 * cell = row.createCell((short) 8);
	 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	 * cell.setCellValue(result.getString(i, "bid_status") == null ? "" : result
	 * .getString(i, "bid_status")); cell.setCellStyle(textStyle);
	 * 
	 * cell = row.createCell((short) 9);
	 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	 * cell.setCellValue(result.getString(i, "step_percentage") == null ? "" :
	 * result .getString(i, "step_percentage")); cell.setCellStyle(textStyle);
	 * 
	 * excelRow++; } // 写入Excel工作表 wb.write(response.getOutputStream()); //
	 * 关闭Excel工作薄对象 response.getOutputStream().close(); response.flushBuffer(); }
	 * catch (Exception e) { e.printStackTrace(); } return null; }
	 * 
	 * private final static String FormSheetName = "Form";
	 * 
	 * private final static String ExcelTemplate = "SalesBidReport.xls";
	 * 
	 * private final static String SaveToFileName = "Sales Bid Report.xls";
	 * 
	 * private final int ListStartRow = 4;
	 * 
	 */
}
