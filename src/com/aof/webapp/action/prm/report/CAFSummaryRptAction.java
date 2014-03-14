/*
 * Created on 2005-7-17
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
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
import org.apache.poi.hssf.util.Region;
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
 * @author gus
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CAFSummaryRptAction extends ReportBaseAction {

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	public ActionForward perform (ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		try {
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
			String action = request.getParameter("FormAction");
			//String projType = request.getParameter("projType");
			//String departmentId = request.getParameter("departmentId");
			String textcode = request.getParameter("textcode");
			//String textpm = request.getParameter("textpm");
			//String textcust = request.getParameter("textcust");
			//if (projType == null) projType = "";
			//if (departmentId == null) departmentId = "";
			if (textcode == null) textcode = "";
			//if (textpm == null) textpm = "";
			//if (textcust == null) textcust = "";
			if (action == null) action = "view";
			if (action.equals("QueryForList")) {
				SQLResults sr = findQueryResult(request, textcode );
				request.setAttribute("QryList",sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response, textcode );
			}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private SQLResults findQueryResult(HttpServletRequest request, String textcode) throws Exception {
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String PartyListStr = "''";
		/*
		if (!departmentId.trim().equals("")) {
			List partyList_dep=ph.getAllSubPartysByPartyId(session,departmentId);
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'"+departmentId+"'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
		}*/
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));

		String SqlStr = "select  projMstr.proj_id, projMstr.proj_name, projMstr.contracttype, custParty.description, custParty.chs_name, ";
		SqlStr = SqlStr + "	projMstr.proj_contract_no, custParty.address, projMstr.start_date, projMstr.end_date, A.st_desc, A.st_estDays,";
		SqlStr = SqlStr + "	A.st_rate, a.issued_days, tsMstr.tsm_userlogin, ul.name as username, tsDet.ts_date as tsdate, tsDet.ts_hrs_user AS tshr,";
		SqlStr = SqlStr + "	CASE WHEN (tsDet.ts_confirm = 'confirmed') THEN tsDet.ts_hrs_confirm END AS tsconfim, bill.bill_code, inv.inv_code, receipt.receipt_no";
		SqlStr = SqlStr + " from 	party as custParty inner join proj_mstr as projMstr on projMstr.cust_id = custParty.party_id inner join";
		SqlStr = SqlStr + " (select pst.st_id, pst.st_proj_id, pst.st_desc,sum(ptd.ts_hrs_user) as issued_days, pst.st_estDays, pst.st_rate";
		SqlStr = SqlStr + " from proj_servicetype as pst inner join proj_ts_det as ptd on ptd.ts_servicetype = pst.st_id INNER JOIN ProjEvent pe ON pe.PEvent_Id = ptd.ts_projevent AND pe.Billable = 'Yes'";
		SqlStr = SqlStr + "	group by pst.st_id, pst.st_proj_id, pst.st_desc, pst.st_estDays, pst.st_rate ) as A on A.st_proj_id =projMstr.proj_id inner join";
		SqlStr = SqlStr + "	proj_ts_det as tsDet on tsDet.ts_proj_id = projMstr.proj_id and tsDet.ts_servicetype = A.st_id inner join";
		SqlStr = SqlStr + "	projevent as pe on pe.pevent_id = tsDet.ts_projevent and pe.billable ='Yes' inner join";
		SqlStr = SqlStr + " proj_ts_mstr as tsMstr on tsDet.tsm_id = tsMstr.tsm_id inner join ";
		SqlStr = SqlStr + " user_login as ul on ul.user_login_id = tsMstr.tsm_userlogin left join";
		SqlStr = SqlStr + " proj_tr_det as trDet on trDet.tr_rec_id = tsDet.ts_id AND trDet.tr_category = 'CAF'  and trDet.tr_type ='bill' left join";
		SqlStr = SqlStr + "	proj_bill AS bill ON trDet.tr_mstr_id = bill.bill_id left join";
		SqlStr = SqlStr + "	proj_invoice as inv on inv.inv_bill_id = bill.bill_id left join";
		SqlStr = SqlStr + "	proj_receipt as receipt ON receipt.invoice_id = inv.inv_id";

		SqlStr = SqlStr + " where ";
		//SqlStr = SqlStr + " projMstr.proj_caf_flag = 'Y'  and projMstr.contracttype = 'TM' and (tsDet.ts_hrs_user<>'0' or tsDet.ts_hrs_confirm <> '0')";
		SqlStr = SqlStr + " projMstr.proj_caf_flag = 'Y'  and (tsDet.ts_hrs_user<>'0' or tsDet.ts_hrs_confirm <> '0')";
		if (!textcode.trim().equals("")) {
			SqlStr = SqlStr +" and ((projMstr.proj_id = '"+ textcode.trim() +"') or (projMstr.proj_name = '"+ textcode.trim() +"'))";
		}

		SqlStr = SqlStr + " order by A.st_desc, ul.name, tsDet.ts_date";
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		return sr;
	}
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,String textcode ){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sr = findQueryResult(request, textcode );
			if (sr== null || sr.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
					
			HSSFCell cell = null;
		//	cell = sheet.getRow(0).getCell((short)8);
		//	cell.setCellValue(sr.getString(0, "description"));
		//	cell = sheet.getRow(1).getCell((short)8);
		//	cell.setCellValue(status);
			
			
			//Style
			HSSFCellStyle H1 = sheet.getRow(2).getCell((short)1).getCellStyle();
			HSSFCellStyle HDate = sheet.getRow(4).getCell((short)5).getCellStyle();
			HSSFCellStyle Style1 = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle Style2 = sheet.getRow(ListStartRow).getCell((short)1).getCellStyle();
			HSSFCellStyle Style3 = sheet.getRow(ListStartRow).getCell((short)2).getCellStyle();
			HSSFCellStyle Style4 = sheet.getRow(ListStartRow).getCell((short)5).getCellStyle();
			HSSFCellStyle Style5 = sheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
			HSSFCellStyle Style6 = sheet.getRow(ListStartRow).getCell((short)8).getCellStyle();
			HSSFCellStyle Style7 = sheet.getRow(ListStartRow+1).getCell((short)4).getCellStyle();	
			HSSFCellStyle Style8 = sheet.getRow(ListStartRow+1).getCell((short)9).getCellStyle();
			HSSFCellStyle Style9 = sheet.getRow(ListStartRow+1).getCell((short)10).getCellStyle();	
			sheet.addMergedRegion(new Region(2, (short) 1, 2, (short) 3)); // header : project Id
			cell = sheet.getRow(2).getCell((short)1);
			cell.setCellValue(sr.getString(0,"proj_id"));
			cell.setCellStyle(H1);
			
			sheet.addMergedRegion(new Region(2, (short) 6, 2, (short) 11)); // header : project description
			cell = sheet.getRow(2).getCell((short)6);
			cell.setCellValue(sr.getString(0,"proj_name"));
			cell.setCellStyle(H1);

			sheet.addMergedRegion(new Region(3, (short) 1, 3, (short) 4)); // header : customer
			cell = sheet.getRow(3).getCell((short)1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getString(0,"description"));
			cell.setCellStyle(H1);

			sheet.addMergedRegion(new Region(3, (short) 6, 3, (short) 11)); // header : address
			cell = sheet.getRow(3).getCell((short)6);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(sr.getString(0,"address"));
			cell.setCellStyle(H1);

			sheet.addMergedRegion(new Region(4, (short) 1, 4, (short) 2)); // header : category
			String cate = "";
			if (sr.getString(0,"contracttype").equals("TM")){
				cate = "Time & Material";
			}else{
				cate = "Fixed Price";
			}
			cell = sheet.getRow(4).getCell((short)1);
			cell.setCellValue(cate);
			cell.setCellStyle(H1);

			sheet.addMergedRegion(new Region(4, (short) 5, 4, (short) 6)); // header : satrt date
			cell = sheet.getRow(4).getCell((short)5);
			cell.setCellValue(sr.getDate(0,"start_date"));
			cell.setCellStyle(HDate);

			sheet.addMergedRegion(new Region(4, (short) 9, 4, (short) 10)); // header : satrt date
			cell = sheet.getRow(4).getCell((short)9);
			cell.setCellValue(sr.getDate(0,"end_date"));
			cell.setCellStyle(HDate);
			
			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			HSSFRow HRow1 = null;
			String osc = "";
			String nsc = "";
			String resultSet_data = "";
			String oldReceipt="";
			String newReceipt="";
			String oldInvoice="";
			String newInvoice="";
			Date oldDate = null;
			Date newDate = null;
			double totalDys = 0;
			double totalCDys = 0;
			double totalPrice = 0;
			for (int row =0; row < sr.getRowCount(); row++) {
				double actualDay = 0;
				double budgetDay = 0;
				double remainDay = 0;
				newReceipt = (sr.getString(row, "receipt_no") == null ) ? "" : sr.getString(row, "receipt_no");
				newInvoice = (sr.getString(row, "inv_code") == null ) ? "" : sr.getString(row, "inv_code");
				newDate = sr.getDate(row,"tsdate");
				actualDay = sr.getDouble(row,"issued_days")/8;
				budgetDay = sr.getDouble(row,"st_estDays");
				remainDay = budgetDay - actualDay;
				nsc = sr.getString(row,"st_desc");
				HRow = sheet.createRow(ExcelRow);
				if (!nsc.equals(osc)){
					osc = nsc;	
	
					cell = HRow.createCell((short)0);			//Line Type
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"st_desc"));
					cell.setCellStyle(Style1);
					
				    cell = HRow.createCell((short)1);			//Plan Days
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getDouble(row,"st_estDays"));
					cell.setCellStyle(Style2);
					
					cell = HRow.createCell((short)2);			//Issued Days
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getDouble(row,"issued_days")/8);
					cell.setCellStyle(Style3);
					
					cell = HRow.createCell((short)3);			//remaining days
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(remainDay);
					cell.setCellStyle(Style3);
					
					cell = HRow.createCell((short)4);			//Conaultant
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"username"));
					cell.setCellStyle(Style1);
					
					cell = HRow.createCell((short)5);			//CAF Date
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(df.format(sr.getDate(row,"tsdate")));
					cell.setCellStyle(Style4);
								
					cell = HRow.createCell((short)6);			//Entry hrs
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getDouble(row,"tshr")/8);
					cell.setCellStyle(Style5);
								
					cell = HRow.createCell((short)7);			//confirmed hrs
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getDouble(row,"tsconfim")/8);
					cell.setCellStyle(Style5);
					
					cell = HRow.createCell((short)8);			//CAF price
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getDouble(row,"st_rate") * sr.getDouble(row,"tsconfim")/8);
					cell.setCellStyle(Style6);
					
					cell = HRow.createCell((short)9);			//Batch No.
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue((((resultSet_data = sr.getString(row,"bill_code"))==null) ? "N/A":resultSet_data));
					cell.setCellStyle(Style1);
					
					cell = HRow.createCell((short)10);			//Invoice No.
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue((((resultSet_data = sr.getString(row,"inv_code"))==null) ? "N/A":resultSet_data));
					cell.setCellStyle(Style1);
				
					cell = HRow.createCell((short)11);			//Receipt No.
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue((((resultSet_data = sr.getString(row,"receipt_no"))==null) ? "N/A":resultSet_data));
					cell.setCellStyle(Style1);
					
					oldDate = newDate;
					oldInvoice = newInvoice;
					oldReceipt = newReceipt;
					
					totalDys = totalDys + sr.getDouble(row,"tshr")/8;
					totalCDys = totalCDys + sr.getDouble(row,"tsconfim")/8;
					totalPrice = totalPrice + sr.getDouble(row,"st_rate") * sr.getDouble(row,"tsconfim")/8;
				}else{
					
					cell = HRow.createCell((short)0);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellStyle(Style1);
					cell = HRow.createCell((short)1);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellStyle(Style1);
					cell = HRow.createCell((short)2);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellStyle(Style1);
					cell = HRow.createCell((short)3);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellStyle(Style1);

					if (newInvoice.equals(oldInvoice) && (newDate.equals(oldDate)) && !newReceipt.equals(oldReceipt)){
						cell = HRow.createCell((short)4);			//Conaultant
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellStyle(Style1);
						
						cell = HRow.createCell((short)5);			//CAF Date
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellStyle(Style4);
									
						cell = HRow.createCell((short)6);			//Entry hrs
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellStyle(Style5);
									
						cell = HRow.createCell((short)7);			//confirmed hrs
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellStyle(Style5);
						
						cell = HRow.createCell((short)8);			//CAF price
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellStyle(Style6);
						
						cell = HRow.createCell((short)9);			//Batch No.
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellStyle(Style1);
						
						cell = HRow.createCell((short)10);			//Invoice No.
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellStyle(Style1);
					}else{
						cell = HRow.createCell((short)4);			//Conaultant
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(sr.getString(row,"username"));
						cell.setCellStyle(Style1);
						
						cell = HRow.createCell((short)5);			//CAF Date
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(df.format(sr.getDate(row,"tsdate")));
						cell.setCellStyle(Style4);
									
						cell = HRow.createCell((short)6);			//Entry hrs
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(sr.getDouble(row,"tshr")/8);
						cell.setCellStyle(Style5);
									
						cell = HRow.createCell((short)7);			//confirmed hrs
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(sr.getDouble(row,"tsconfim")/8);
						cell.setCellStyle(Style5);
						
						cell = HRow.createCell((short)8);			//CAF price
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(sr.getDouble(row,"st_rate") * sr.getDouble(row,"tsconfim")/8);
						cell.setCellStyle(Style6);
						
						cell = HRow.createCell((short)9);			//Batch No.
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue((((resultSet_data = sr.getString(row,"bill_code"))==null) ? "N/A":resultSet_data));
						cell.setCellStyle(Style1);
						
						cell = HRow.createCell((short)10);			//Invoice No.
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue((((resultSet_data = sr.getString(row,"inv_code"))==null) ? "N/A":resultSet_data));
						cell.setCellStyle(Style1);
						
						totalDys = totalDys + sr.getDouble(row,"tshr")/8;
						totalCDys = totalCDys + sr.getDouble(row,"tsconfim")/8;
						totalPrice = totalPrice + sr.getDouble(row,"st_rate") * sr.getDouble(row,"tsconfim")/8;
					}
					
					
					cell = HRow.createCell((short)11);			//Receipt No.
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue((((resultSet_data = sr.getString(row,"receipt_no"))==null) ? "N/A":resultSet_data));
					cell.setCellStyle(Style1);
					
					oldDate = newDate;
					oldInvoice = newInvoice;
					oldReceipt = newReceipt;
				}
					ExcelRow++;
					
			}
			HRow1 = sheet.createRow(ExcelRow);
			cell = HRow1.createCell((short)5);			
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue("Total :");
			cell.setCellStyle(Style7);
			
			cell = HRow1.createCell((short)6);			
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(totalDys);
			cell.setCellStyle(Style8);
			
			cell = HRow1.createCell((short)7);			
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(totalCDys);
			cell.setCellStyle(Style8);
			
			cell = HRow1.createCell((short)8);			
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(totalPrice);
			cell.setCellStyle(Style9);
			
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
	private final static String ExcelTemplate="CAFSummaryRpt.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="CAF Summary Report.xls";
	private final int ListStartRow = 7;

}
