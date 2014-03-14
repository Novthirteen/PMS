/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.action.prm.bill;


import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.BillInstructionService;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.prm.report.ReportBaseAction;


public class FindBillPendingListAction extends ReportBaseAction {
	
	private final static String ExcelTemplate="BillingPendingRpt.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Billing Pending Report.xls";
	private final int ListStartRow = 8;
	private Log log = LogFactory.getLog(FindBillPendingListAction.class);
	
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());		
		// Extract attributes we will need
		Logger log = Logger.getLogger(FindBillPendingListAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		try{
			long timeStart = System.currentTimeMillis();   //for performance test
			String textcode = request.getParameter("textcode");
			String textbillto = request.getParameter("textbillto");
			String textcust = request.getParameter("textcust");
			String textdep = request.getParameter("textdep");
			String action = request.getParameter("FormAction");
			boolean detailflag = false;
			if (request.getParameter("detailflag") != null) detailflag = true;
			if (textcode == null) textcode ="";
			if (textbillto == null) textbillto ="";
			if (textcust == null) textcust ="";
			if (textdep == null) {
				UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				if (userLogin != null) {
					textdep = userLogin.getParty().getPartyId();
				}
			}
			log.info("action is "  +action);
			if (action == null) action = "view";
			if (action.equals("create")) {
				String pid  = request.getParameter("pid");
				String billId = null;
				if (pid != null) {
					billId = String.valueOf(createBillingInstruction(pid, request));
				}
					request.setAttribute("action", "view");
					request.setAttribute("billId", billId);
					return (mapping.findForward("gotoInstruction"));
			}
			
			if ("ExportToExcel".equals(action)) {
				return ExportToExcel(request, 
						response,
                        textcode, 
						textbillto, 
						textcust, 
						textdep, 
						detailflag);
			}
		//	if (action.equals("QueryForList") || action.equals("create")) {
				SQLResults sr = findQueryResult(request,textcode,textbillto,textcust,textdep,detailflag);
				request.setAttribute("QryList",sr);
				//if (action.equals("create")) {
					//SQLResults srr = findQueryResult(request,textcode,textcust,textdep,detailflag);
					//request.setAttribute("QryList",srr);
					//return (mapping.findForward("success"));
				//}
				//log.info("****** customer is "+sr.getString(0,"customer"));
				
		//	}
			long timeEnd = System.currentTimeMillis(); //for performance test
			log.info("it takes " + (timeEnd - timeStart) + " ms to excute the query...");
		} catch(Exception e){
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
		return (mapping.findForward("success"));
	}
	
	private Long createBillingInstruction(String projectId, HttpServletRequest request) throws HibernateException {
		BillInstructionService bis = new BillInstructionService();
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		Long billId = bis.newBillingInstruction(projectId, ul);
		
		return billId;
	}
	
	private SQLResults findQueryResult(HttpServletRequest request, String textcode, String textbillto, String textcust, String textdep, boolean detailflag) throws Exception {
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String JoinStr = "";
		String PartyListStr = "''";
		if (!textdep.trim().equals("")) {
			List partyList_dep=ph.getAllSubPartysByPartyId(session,textdep);
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'"+textdep+"'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
		}
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		String SqlStr = "";
		if (!detailflag) {
			SqlStr = SqlStr + "select pm.proj_id as pid, " +
			                  " sum(detres.CAFDays) as CAFDays, " +
			                  " sum(detres.CAFAmt) as CAFAmt, " +
			                  " sum(detres.AlwnceAmt) as AlwnceAmt, " +
			                  " sum(detres.AccpAmt) as AccpAmt, " +
			                  " sum(detres.ExpAmt) as ExpAmt, " +
			                  " sum(detres.CDPAmt) as CDPAmt, " +
			                  " p.description as customer, " +
			                  " pty.description as billto, " +
			                  " pm.proj_name as pname, " +
			                  " pm.contracttype, " +
			                  " b.bill_id as BillId," +
			                  " b.bill_code as BillCode, " +
							  " b.Bill_Type as BillType, " +
			                  " b.bill_Createdate as BillDate " +
			                  " from proj_mstr as pm " +
			                  //" inner join proj_tr_det as t  on pm.proj_id= t.tr_proj_id " +
			                  " inner join party as pty on pm.proj_billaddr_id = pty.party_id " +
			                  " inner join party as p on pm.cust_id = p.party_id " +
			                  " left join (select pb.bill_proj_id, " +
			                  " pb.bill_id, " +
			                  " pb.bill_code, " +
			                  " pb.bill_type, " +
			                  " pb.bill_createDate " +
			                  " from proj_bill as pb " +
			                  " inner join (select max(bill_id) as bill_id, " +
			                  " bill_proj_id " +
			                  " from proj_bill " +
			                  " group by bill_proj_id" +
			                  " ) as a on pb.bill_id = a.bill_id " +
			                  " ) as b on pm.proj_id = b.bill_proj_id " + 
			                  " inner join ( ";
		}
		
		SqlStr = SqlStr + "select t.tr_proj_id as pid," +
							" (sum(case when t.tr_category = 'CAF' then t.tr_num1 end)/8) as CAFDays," +
							" sum(case when t.tr_category = 'CAF' then t.tr_amount*t.tr_ex_rate end) as CAFAmt," +
							" sum(case when t.tr_category = 'Allowance' then t.tr_amount*t.tr_ex_rate end) as AlwnceAmt," +
							" sum(case when t.tr_category = 'ProjBill' then t.tr_amount*t.tr_ex_rate end) as AccpAmt," +
							" sum(case when (t.tr_category = 'Expense' or t.tr_category = 'OtherCost') then t.tr_amount*t.tr_ex_rate end) as ExpAmt," +
							" sum(case when t.tr_category = 'Credit-Down-Payment' then t.tr_amount end) as CDPAmt," +
							" p.description as customer, pty.description as billto, pm.proj_name as pname, pm.contracttype, " +
							" b.bill_id as BillId," +
							" b.bill_code as BillCode," +
							" b.Bill_Type as BillType," +
							" b.bill_Createdate as BillDate," +
							" pm. proj_linknote as proj_linknote ";
		SqlStr = SqlStr + " from proj_mstr  as pm  inner join proj_tr_det as t  on pm.proj_id= t.tr_proj_id";
		SqlStr = SqlStr + " inner join party as pty on pm.proj_billaddr_id = pty.party_id";
		SqlStr = SqlStr + " inner join party as p on pm.cust_id = p.party_id";
		SqlStr = SqlStr + " left join (select pb.bill_proj_id, pb.bill_id, pb.bill_code, pb.bill_type, pb.bill_createDate from proj_bill as pb " +
				"inner join (select max(bill_id) as bill_id, max(bill_code) as bill_code, bill_proj_id from proj_bill group by bill_proj_id) as a on pb.bill_id = a.bill_id) as b on pm.proj_id = b.bill_proj_id ";
		SqlStr = SqlStr + " where t.tr_type='Bill' and t.tr_mstr_id is null ";
		if (!textdep.trim().equals("")) {
			SqlStr = SqlStr + " and pm.dep_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " and pm.proj_pm_user ='"+ul.getUserLoginId()+"'";
		}
		
		if (!textcode.trim().equals("")) {
			SqlStr = SqlStr + " and (t.tr_proj_id like '%"+textcode+"%' or pm.proj_name like '%"+textcode+"%')";
		}
		
		if (!textbillto.trim().equals("")) {
			SqlStr = SqlStr + "  and pty.description like '%"+textbillto+"%'";
		}
		
		if (!textcust.trim().equals("")) {
			SqlStr = SqlStr + "  and p.description like '%"+textcust+"%'";
		}
		
		SqlStr = SqlStr + " group by  t.tr_proj_id, b.bill_id, b.bill_code, b.Bill_Type, b.bill_Createdate, p.description,pm.proj_name, pm.contracttype, pty.description, proj_linknote ";
		if (detailflag) {
			SqlStr = SqlStr + " order by pty.description, t.tr_proj_id ";
		} else {
			SqlStr = SqlStr + " ) as detres on pm.proj_id = left(detres.proj_linknote,CHARINDEX(':',detres.proj_linknote)-1) " +
	                          " group by pm.proj_id, " +
                              " p.description, " + 
                              " pty.description, " + 
	                          " pm.proj_name, " + 
	                          " pm.contracttype, " + 
							  " b.bill_id, " +
	                          " b.bill_code, " +
							  " b.Bill_Type," +
	                          " b.bill_Createdate ";
			SqlStr = SqlStr + " order by pty.description, pm.proj_id ";
		}
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		return sr;
	}
	
	private ActionForward ExportToExcel(HttpServletRequest request, 
										HttpServletResponse response,
			                            String textcode, 
										String textbillto, 
										String textcust, 
										String textdep, 
										boolean detailflag) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sqlResult = findQueryResult(request,textcode,textbillto,textcust,textdep,detailflag);
			if (sqlResult == null || sqlResult.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			HSSFCell cell = null;
			cell = sheet.getRow(0).getCell((short)8);
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
			cell.setCellValue(dateFormat.format(new Date()));
			
			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
			HSSFCellStyle normalTextStyle = sheet.getRow(ListStartRow).getCell((short)11).getCellStyle();
			HSSFCellStyle dateFormatStyle = sheet.getRow(ListStartRow).getCell((short)12).getCellStyle();
			
			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			for (int row =0; row < sqlResult.getRowCount(); row++) {
				HRow = sheet.createRow(ExcelRow++);
				
				cell = HRow.createCell((short)0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "customer"));
				cell.setCellStyle(boldTextStyle);

				cell = HRow.createCell((short)1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "billto"));
				cell.setCellStyle(boldTextStyle);
				
				cell = HRow.createCell((short)2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "pname"));
				cell.setCellStyle(boldTextStyle);
				
				cell = HRow.createCell((short)3);
				cell.setCellValue(sqlResult.getString(row, "contracttype"));
				cell.setCellStyle(boldTextStyle);
				
				cell = HRow.createCell((short)4);
				cell.setCellValue(sqlResult.getFloat(row,"CAFDays"));
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)5);
				cell.setCellValue(sqlResult.getDouble(row,"CAFAmt"));
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)6);
				cell.setCellValue(sqlResult.getDouble(row,"AlwnceAmt"));
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)7);
				cell.setCellValue(sqlResult.getDouble(row,"ExpAmt"));
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)8);
				cell.setCellValue(sqlResult.getDouble(row,"AccpAmt"));
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)9);
				cell.setCellValue(sqlResult.getDouble(row,"CDPAmt"));
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)10);
				cell.setCellValue(sqlResult.getDouble(row,"CAFAmt") + 
						sqlResult.getDouble(row,"AlwnceAmt") +
						sqlResult.getDouble(row,"ExpAmt") +
						sqlResult.getDouble(row,"AccpAmt") +
						sqlResult.getDouble(row,"CDPAmt"));
				cell.setCellStyle(numberFormatStyle);
				
				cell = HRow.createCell((short)11);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sqlResult.getString(row, "BillCode") != null ? sqlResult.getString(row, "BillCode") : "N/A");
				cell.setCellStyle(normalTextStyle);
				
				cell = HRow.createCell((short)12);
				cell.setCellValue(sqlResult.getDate(row, "BillDate") != null ? dateFormat.format(sqlResult.getDate(row, "BillDate")) : "N/A");
				cell.setCellStyle(dateFormatStyle);
			}
			
			//写入Excel工作表
			wb.write(response.getOutputStream());
			//关闭Excel工作薄对象
			response.getOutputStream().close();
			response.setStatus( HttpServletResponse.SC_OK );
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}

