package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.text.NumberFormat;

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

import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.webapp.action.ActionErrorLog;

public class ExpenseDetailRptAction extends ReportBaseAction {

	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		try {
			
			String action = request.getParameter("formAction");
			String year = request.getParameter("year");
			String strMonthStart = request.getParameter("monthStart");
			String strMonthEnd = request.getParameter("monthEnd");
			String expStatus = request.getParameter("expStatus");
			String strMonth = request.getParameter("month");
			String deptId = request.getParameter("deptId");
			
			if (action == null){
				action = "view";
			}
			if(year == null){
				year = "";
			}
			if(strMonthStart == null){
				strMonthStart = "";
			}
			if(strMonthEnd == null){
				strMonthEnd = "";
			}
			if(expStatus == null){
				expStatus = "";
			}
			if(strMonth == null){
				strMonth = "";
			}
			if(deptId == null){
				deptId = "";
			}
			
			int monthStart = 0;
			int monthEnd = 0;
			
			if(strMonthStart != null && !(strMonthStart.equals(""))){
				monthStart = Integer.parseInt(strMonthStart);
			}
			
			if(strMonthEnd != null && !(strMonthEnd.equals(""))){
				monthEnd = Integer.parseInt(strMonthEnd);
			}
			
			if (action.equals("query")) {
				
				SQLResults detail = null;
				
				SQLResults summary = findSummaryResult(year, monthStart, monthEnd, expStatus, deptId);
				
				if(strMonth == null || strMonth.equals("")){
					detail = findDetailResult(year, monthStart, expStatus, deptId);
					request.setAttribute("mFlag",strMonthStart);
				} else {
					int month = Integer.parseInt(strMonth);
					detail = findDetailResult(year, month, expStatus, deptId);
					request.setAttribute("mFlag",strMonth);
				}
				
				request.setAttribute("summary",summary);
				request.setAttribute("detail",detail);
				
			}
			
			if(action.equals("export")){
				return exportExcel(request, response, year, monthStart, monthEnd, expStatus,deptId);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}

	private SQLResults findSummaryResult(String year, int monthStart, int monthEnd, String expStatus, String deptId) throws Exception {

		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));
			
		String strSQL = "select p.party_id as p_id, p.description as p_desc,";
		
		if(expStatus.equals("Submitted")){
			for(int i = monthStart; i <= monthEnd; i++){
				if(i==12){
					strSQL += " isnull(sum(case when((em.em_claimtype='CN') and (em.em_exp_date >= '" + year + "-" + i + "-01' and em.em_exp_date <= '" + year + "-" + i + "-31' )) then ed.ed_amt_user end), 0) as exp_comp" + i + ",";
					strSQL += " isnull(sum(case when((em.em_claimtype='CY') and (em.em_exp_date >= '" + year + "-" + i + "-01' and em.em_exp_date <= '" + year + "-" + i + "-31' )) then ed.ed_amt_user end), 0) as exp_cust" + i + ",";
				}else{
					strSQL += " isnull(sum(case when((em.em_claimtype='CN') and (em.em_exp_date >= '" + year + "-" + i + "-01' and em.em_exp_date < '" + year + "-" + (i + 1) + "-01' )) then ed.ed_amt_user end), 0) as exp_comp"+i+",";
					strSQL += " isnull(sum(case when((em.em_claimtype='CY') and (em.em_exp_date >= '" + year + "-" + i + "-01' and em.em_exp_date < '" + year + "-" + (i + 1) + "-01' )) then ed.ed_amt_user end), 0) as exp_cust"+i+",";
				}
			}
		}
		
		if(expStatus.equals("Approved")){
			for(int i = monthStart; i <= monthEnd; i++){
				if(i==12){
					strSQL += " isnull(sum(case when((em.em_claimtype='CN') and (em.em_approval_date >= '" + year + "-" + i + "-01' and em.em_approval_date <= '" + year + "-" + i + "-31' )) then ed.ed_amt_user end), 0) as exp_comp"+i+",";
					strSQL += " isnull(sum(case when((em.em_claimtype='CY') and (em.em_approval_date >= '" + year + "-" + i + "-01' and em.em_approval_date <= '" + year + "-" + i + "-31' )) then ed.ed_amt_user end), 0) as exp_cust"+i+",";
				}else{
					strSQL += " isnull(sum(case when((em.em_claimtype='CN') and (em.em_approval_date >= '" + year + "-" + i + "-01' and em.em_approval_date < '" + year + "-" + (i + 1) + "-01' )) then ed.ed_amt_user end), 0) as exp_comp"+i+",";
					strSQL += " isnull(sum(case when((em.em_claimtype='CY') and (em.em_approval_date >= '" + year + "-" + i + "-01' and em.em_approval_date < '" + year + "-" + (i + 1) + "-01' )) then ed.ed_amt_user end), 0) as exp_cust"+i+",";
				}
			}
		}
		
		if(expStatus.equals("Claimed")){
			for(int i = monthStart; i <= monthEnd; i++){
				if(i==12){
					strSQL += " isnull(sum(case when((em.em_claimtype='CN') and ((em.em_receipt_date >= '" + year + "-" + i + "-01' and em.em_receipt_date <= '" + year + "-" + i + "-31') or (em.FAConfirmDate >= '" + year + "-" + i + "-01' and em.FAConfirmDate <= '" + year + "-" + i + "-31'))) then ed.ed_amt_user end), 0) as exp_comp" + i + ",";
					strSQL += " isnull(sum(case when((em.em_claimtype='CY') and ((em.em_receipt_date >= '" + year + "-" + i + "-01' and em.em_receipt_date <= '" + year + "-" + i + "-31') or (em.FAConfirmDate >= '" + year + "-" + i + "-01' and em.FAConfirmDate <= '" + year + "-" + i + "-31'))) then ed.ed_amt_user end), 0) as exp_cust" + i + ",";
				}else{
					strSQL += " isnull(sum(case when((em.em_claimtype='CN') and ((em.em_receipt_date >= '" + year + "-" + i + "-01' and em.em_receipt_date < '" + year + "-" + (i + 1) + "-01' ) or (em.FAConfirmDate >= '" + year + "-" + i + "-01' and em.FAConfirmDate < '" + year + "-" + (i + 1) + "-01'))) then ed.ed_amt_user end), 0) as exp_comp" + i+ ",";
					strSQL += " isnull(sum(case when((em.em_claimtype='CY') and ((em.em_receipt_date >= '" + year + "-" + i + "-01' and em.em_receipt_date < '" + year + "-" + (i + 1) + "-01' ) or (em.FAConfirmDate >= '" + year + "-" + i + "-01' and em.FAConfirmDate < '" + year + "-" + (i + 1) + "-01'))) then ed.ed_amt_user end), 0) as exp_cust" + i + ",";
				}
			}
		}
		
		for(int i = monthStart; i <= monthEnd; i++){
				
			strSQL += "isnull( td.allow_cust" + i + ", 0) as allow_cust" + i;
			
			if(i != monthEnd){
				strSQL += ",";
			}
		}
		
		strSQL += " from  proj_exp_mstr as em"
			+ " inner join proj_exp_det as ed on ed.em_id = em.em_id"
			+ " inner join proj_mstr as pm on pm.proj_id = em.em_proj_id"
			+ " inner join party as p on pm.dep_id = p.party_id and p.party_id";
		
		
		if(deptId != null && !deptId.equals("")){
			strSQL += " = '" + deptId + "'";
		} else {
			strSQL +=  " in ('005', '006','007','014')";
		}
		
		strSQL += " left join("
			+ "	select dept.party_id as dept_id,";
		
		for(int i = monthStart; i <= monthEnd; i++){
			if(i==12){
				strSQL += "isnull(sum(case when(inv.inv_invoicedate >= '" + year + "-" + i + "-01' and inv.inv_invoicedate <= '" + year + "-" + i + "-31') then tr.tr_amount end),0) as allow_cust" + i;
			}else{
				strSQL += "isnull(sum(case when(inv.inv_invoicedate >= '" + year + "-" + i + "-01' and inv.inv_invoicedate < '" + year + "-" + (i + 1) + "-01') then tr.tr_amount end),0) as allow_cust" + i;
			}
			if(i != monthEnd){
				strSQL += ",";
			}
		}

		strSQL += " from proj_tr_det as tr"
			+ " inner join proj_bill as bill on bill.bill_id = tr.tr_mstr_id"
			+ " inner join proj_invoice as inv on inv.inv_bill_id = bill.bill_id"
			+ " inner join proj_mstr as pm on tr.tr_proj_id = pm.proj_id"
			+ " inner join party as dept on dept.party_id = pm.dep_id and dept.party_id";
		
		if(deptId != null && !deptId.equals("")){
			strSQL += " = '" + deptId + "'";
		} else {
			strSQL +=  " in ('005', '006','007','014')";
		}
		
		strSQL += " where tr.tr_type='bill' and tr.tr_category='allowance' and tr.tr_mstr_id is not null"
			+ " group by dept.party_id"
			+ " ) as td on td.dept_id = p.party_id"
			+ " group by p.description, p.party_id";
		
		for(int i = monthStart; i <= monthEnd; i++){
			strSQL += ",td.allow_cust" + i;
		}
		strSQL += " order by p.party_id";
		
		System.out.println("\n" + strSQL + "\n");
		
		SQLResults result = sqlExec.runQueryCloseCon(strSQL);

		return result;
	}

	private SQLResults findDetailResult(String year, int month, String expStatus, String deptId) throws Exception {
		
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));
		
		String strSQL ="select amt.proj_code as proj_code, " +
				"amt.em_code as em_code, " +
				"amt.employee as employee, " +
				"amt.p_desc as p_desc," +
				"sum(amt.total) as total, " +
				"sum(amt.hotel) as hotel, " +
				"sum(amt.meal) as meal, " +
				"sum(amt.trans) as trans, " +
				"sum(amt.allow) as allow, " +
				"sum(amt.tel) as tel, " +
				"sum(amt.misc) as misc, " +
				"amt.curr as curr, " +
				"amt.claim_type as claim_type, " +
				"amt.status as status, " +
				"amt.entry_date as entry_date, " +
				"amt.exp_date as exp_date, " +
				"amt.app_date as app_date, " +
				"amt.claim_date as claim_date" +
				" from( ";
			
		strSQL += "select em.em_proj_id as proj_code, " +
				"em.em_code as em_code,  " +
				"ul.name as employee,  " +
				"p.description as p_desc, " +
				"isnull(sum(ea.ea_amt_user),0) as total, " +
				"isnull( (case when(ea.exp_id=1) then ea.ea_amt_user end),0) as hotel, " +
				"isnull( (case when(ea.exp_id=2) then ea.ea_amt_user end),0) as meal, " +
				"isnull( (case when(ea.exp_id=3) then ea.ea_amt_user end),0) as trans, " +
				"isnull( (case when(ea.exp_id=4) then ea.ea_amt_user end),0) as allow, " +
				"isnull( (case when(ea.exp_id=5) then ea.ea_amt_user end),0) as tel, " +
				"isnull( (case when(ea.exp_id=6) then ea.ea_amt_user end),0) as misc, " +
				"em.em_curr_id as curr, " +
				"em.em_claimtype as claim_type, " +
				"em.em_status as status, " +
				"em.em_entry_date as entry_date, " +
				"em.em_exp_date as exp_date, " +
				"em.em_approval_date as app_date, " +
				"em.em_receipt_date as claim_date " +
				"from proj_exp_mstr as em " +
				"inner join proj_exp_amt as ea on ea.em_id = em.em_id " +
				"inner join user_login as ul on em.em_userlogin = ul.user_login_id " +
				"inner join proj_mstr as pm on pm.proj_id = em.em_proj_id " +
				"inner join party as p on pm.dep_id = p.party_id and p.party_id";
		
		if(deptId != null && !deptId.equals("")){
			strSQL += " = '" + deptId + "'";
		} else {
			strSQL +=  " in ('005', '006','007','014')";
		}
		
		if(expStatus.equals("Submitted")){
			if(month == 12){
				strSQL += " where em.em_exp_date >= '" + year + "-" + month + "-01' and em.em_exp_date <= '" + year + "-" + month + "-31'";
			}else{
				strSQL += " where em.em_exp_date >= '" + year + "-" + month + "-01' and em.em_exp_date < '" + year + "-" + (month + 1) + "-01'";
			}
			
		}
		
		if(expStatus.equals("Approved")){
			if(month == 12){
				strSQL += " where em.em_approval_date >= '" + year + "-" + month + "-01' and em.em_approval_date <= '" + year + "-" + month + "-31'";
			}else{
				strSQL += " where em.em_approval_date >= '" + year + "-" + month + "-01' and em.em_approval_date < '" + year + "-" + (month + 1) + "-01'";
			}
		}
		
		if(expStatus.equals("Claimed")){
			if(month == 12){
				strSQL += " where (em.em_receipt_date >= '" + year + "-" + month + "-01' and em.em_receipt_date <= '" + year + "-" + month + "-31') or (em.FAConfirmDate >= '" + year + "-" + month + "-01' and em.FAConfirmDate <= '" + year + "-" + month + "-31')";
			}else{
				strSQL += " where (em.em_receipt_date >= '" + year + "-" + month + "-01' and em.em_receipt_date < '" + year + "-" + (month + 1) + "-01') or (em.FAConfirmDate >= '" + year + "-" + month + "-01' and em.FAConfirmDate < '" + year + "-" + (month + 1) + "-01')";
			}
		}
		
		strSQL +=" group by em.em_proj_id, em.em_code, ul.name, p.description,em.em_curr_id, em.em_claimtype, em.em_status, em.em_entry_date, em.em_exp_date, em.em_approval_date, em.em_receipt_date, ea.exp_id, ea.ea_amt_user, em.em_id,ea.ea_id";
				
		strSQL += " ) as amt " +
				"group by amt.proj_code, amt.em_code, amt.employee, amt.p_desc,amt.curr, amt.claim_type, amt.status, amt.entry_date, amt.exp_date, amt.app_date, amt.claim_date";
		
		if(expStatus.equals("Submitted")){
			strSQL += " order by amt.exp_date";
		}
		
		if(expStatus.equals("Approved")){
			strSQL += " order by amt.app_date";
		}

		if(expStatus.equals("Claimed")){
			strSQL += " order by amt.claim_date";
		}
		
		System.out.println("\n" + strSQL + "\n");
		
		SQLResults result = sqlExec.runQueryCloseCon(strSQL);

		return result;
	}
	
	private ActionForward exportExcel(HttpServletRequest request, HttpServletResponse response,
			String year, int monthStart, int monthEnd, String expStatus, String deptId) {
		try{
			
			int summaryStartRow = 6;
			
			// Get Excel Template Path
			String templatePath = GetTemplateFolder();
			if (templatePath == null) {
				return null;
			}
			
			SQLResults summary = findSummaryResult(year, monthStart, monthEnd, expStatus, deptId);
			
			if (summary == null || summary.getRowCount() <= 0) {
				return null;
			}
			
			NumberFormat numFormator = NumberFormat.getInstance();
			numFormator.setMaximumFractionDigits(2);
			numFormator.setMinimumFractionDigits(2);
			
			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName
					+ "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(templatePath + "\\"
					+ ExcelTemplate));

			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(summaryFormSheetName);
			
			// Style
			HSSFCellStyle titleStyle = sheet.getRow(3).getCell((short) 1).getCellStyle();
			HSSFCellStyle redStyle = sheet.getRow(5).getCell((short) 1).getCellStyle();
			HSSFCellStyle yellowStyle = sheet.getRow(4).getCell((short) 3).getCellStyle();
			HSSFCellStyle numStyle = sheet.getRow(6).getCell((short) 1).getCellStyle();
			HSSFCellStyle numBoldStyle = sheet.getRow(7).getCell((short) 1).getCellStyle();
			HSSFCellStyle totalStyle = sheet.getRow(11).getCell((short) 1).getCellStyle();
			
			// Header
			HSSFRow HRow = null;
			HRow = sheet.createRow(3);
			HSSFCell cell = null;
			int cellStart = 1;
			
			for (int i = monthStart; i <= monthEnd; i++) {
				
				String strM = "";
				if( i == 1) strM = "Jan";
				if( i == 2) strM = "Feb";
				if( i == 3) strM = "Mar";
				if( i == 4) strM = "Apr";
				if( i == 5) strM = "May";
				if( i == 6) strM = "Jun";
				if( i == 7) strM = "Jul";
				if( i == 8) strM = "Aug";
				if( i == 9) strM = "Sep";
				if( i == 10) strM = "Oct";
				if( i == 11) strM = "Nov";
				if( i == 12) strM = "Dec";
				
				sheet.addMergedRegion(new Region(3, (short) cellStart, 3, (short) (cellStart + 2)));
				cell = sheet.createRow(3).createCell((short)cellStart);
				cell.setCellValue(strM);
				cell.setCellStyle(titleStyle);
				
				sheet.addMergedRegion(new Region(4, (short) cellStart, 4, (short) (cellStart + 1)));
				cell = sheet.createRow(4).createCell((short)cellStart);
				cell.setCellValue("Company");
				cell.setCellStyle(redStyle);
				
				sheet.addMergedRegion(new Region(4, (short) (cellStart+2), 5, (short) (cellStart + 2)));
				cell = sheet.createRow(4).createCell((short)(cellStart+2));
				cell.setCellValue("Customer");
				cell.setCellStyle(yellowStyle);
				
				HRow = sheet.createRow(5);
				
				cell = HRow.createCell((short) cellStart);
				cell.setCellValue("Total Expense by company");
				cell.setCellStyle(redStyle);
				
				cell = HRow.createCell((short) (cellStart + 1));
				cell.setCellValue("Allowance by customer");
				cell.setCellStyle(redStyle);
				
				cellStart += 3;
			}
			
			sheet.addMergedRegion(new Region(3, (short) cellStart, 3, (short) (cellStart + 2)));
			cell = sheet.createRow(3).createCell((short)cellStart);
			cell.setCellValue("Total");
			cell.setCellStyle(titleStyle);
			
			sheet.addMergedRegion(new Region(4, (short) cellStart, 4, (short) (cellStart + 1)));
			cell = sheet.createRow(4).createCell((short)cellStart);
			cell.setCellValue("Company");
			cell.setCellStyle(redStyle);
			
			sheet.addMergedRegion(new Region(4, (short) (cellStart + 2), 5, (short) (cellStart + 2)));
			cell = sheet.createRow(4).createCell((short)(cellStart+2));
			cell.setCellValue("Customer");
			cell.setCellStyle(yellowStyle);
			
			HRow = sheet.createRow(5);
			
			cell = HRow.createCell((short) cellStart);
			cell.setCellValue("Total Expense by company");
			cell.setCellStyle(redStyle);
			
			cell = HRow.createCell((short) (cellStart + 1));
			cell.setCellValue("Allowance by customer");
			cell.setCellStyle(redStyle);
			
			cellStart = 1;
			
			double expCompSub[] = new double[12];
			double expCustSub[] = new double[12];
			double allowCustSub[] = new double[12];
			double total[] = new double[12];
			
			double allExpCompSub = 0.0;
			double allExpCustSub = 0.0;
			double allAllowCustSub = 0.0;
			
			double allTotal = 0.0;
			
			for (int row = 0; row < summary.getRowCount(); row++) {
				
				int c = 1;
				
				double expCompTotal = 0.0;
				double expCustTotal = 0.0;
				double allowCustTotal = 0.0;
				
				HRow = sheet.createRow(summaryStartRow);
				
				cell = HRow.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(summary.getString(row,"p_desc"));
				cell.setCellStyle(titleStyle);
				
				for(int i = monthStart; i <= monthEnd; i++ ){
					
					double expComp = summary.getDouble(row,"exp_comp" + i);
					double expCust = summary.getDouble(row,"exp_cust" + i);
					double allowCust = summary.getDouble(row,"allow_cust" + i);
					
					expCompTotal += expComp;
					expCustTotal += expCust;
					allowCustTotal += allowCust;
					
					expCompSub[i-1] += expComp;
					expCustSub[i-1] += expCust;
					allowCustSub[i-1] += allowCust;
					
					total[i-1] = expCompSub[i-1] - allowCustSub[i-1];
					
					cell = HRow.createCell((short) c);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(expComp == 0 ? "" : numFormator.format(expComp));
					cell.setCellStyle(numStyle);
					
					cell = HRow.createCell((short) (c+1));
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(allowCust == 0 ? "" : numFormator.format(allowCust));
					cell.setCellStyle(numStyle);
					
					cell = HRow.createCell((short) (c+2));
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(expCust == 0 ? "" : numFormator.format(expCust));
					cell.setCellStyle(numStyle);
					
					c +=3;
				}
				
				cell = HRow.createCell((short) c);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(expCompTotal == 0 ? "" : numFormator.format(expCompTotal));
				cell.setCellStyle(numStyle);
				
				cell = HRow.createCell((short) (c+1));
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(allowCustTotal == 0 ? "" : numFormator.format(allowCustTotal));
				cell.setCellStyle(numStyle);
				
				cell = HRow.createCell((short) (c+2));
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(expCustTotal == 0 ? "" : numFormator.format(expCustTotal));
				cell.setCellStyle(numStyle);
				
				allExpCompSub += expCompTotal;
				allExpCustSub += expCustTotal;
				allAllowCustSub += allowCustTotal;
				
				summaryStartRow++;
			}
			
			HRow = sheet.createRow(summaryStartRow);
			
			cell = HRow.createCell((short) 0);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("SubTotal");
			cell.setCellStyle(titleStyle);
			
			for(int i = monthStart; i<= monthEnd; i++){
				
				cell = HRow.createCell((short) cellStart);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(expCompSub[i-1] == 0 ? "" : numFormator.format(expCompSub[i-1]));
				cell.setCellStyle(numBoldStyle);
				
				cell = HRow.createCell((short) (cellStart + 1));
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(allowCustSub[i-1] == 0 ? "" : numFormator.format(allowCustSub[i-1]));
				cell.setCellStyle(numBoldStyle);
				
				cell = HRow.createCell((short) (cellStart + 2));
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(expCustSub[i-1] == 0 ? "" : numFormator.format(expCustSub[i-1]));
				cell.setCellStyle(numBoldStyle);
				
				cellStart += 3;
			}
			
			cell = HRow.createCell((short) cellStart);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(allExpCompSub == 0 ? "" : numFormator.format(allExpCompSub));
			cell.setCellStyle(numBoldStyle);
			
			cell = HRow.createCell((short) (cellStart + 1));
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(allAllowCustSub == 0 ? "" : numFormator.format(allAllowCustSub));
			cell.setCellStyle(numBoldStyle);
			
			cell = HRow.createCell((short) (cellStart + 2));
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(allExpCustSub == 0 ? "" : numFormator.format(allExpCustSub));
			cell.setCellStyle(numBoldStyle);
			
			summaryStartRow++;
			cellStart = 1;
			
			HRow = sheet.createRow(summaryStartRow);
			
			cell = HRow.createCell((short) 0);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("Total Paid By Company");
			cell.setCellStyle(titleStyle);
			
			allTotal = allExpCompSub - allAllowCustSub;	
			
			for(int i = monthStart; i<= monthEnd; i++){
				
				sheet.addMergedRegion(new Region(summaryStartRow, (short) cellStart, summaryStartRow, (short) (cellStart + 2)));
				cell = sheet.createRow(summaryStartRow).createCell((short)cellStart);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(total[i-1] == 0 ? "" : numFormator.format(total[i-1]));
				cell.setCellStyle(totalStyle);
				
				cellStart += 3;
			}
			
			sheet.addMergedRegion(new Region(summaryStartRow, (short) cellStart, summaryStartRow, (short) (cellStart + 2)));
			cell = sheet.createRow(summaryStartRow).createCell((short)cellStart);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(allTotal == 0 ? "" : numFormator.format(allTotal));
			cell.setCellStyle(totalStyle);
						
			for(int month = monthStart; month <= (monthEnd + 1); month++){
				
				SQLResults detail = null;
				
				if(month == monthStart){
					if(monthStart == monthEnd){
						detail = findDetailResult(year, monthStart, expStatus,deptId);
					} else {
						continue;
					}
				} else if(month == (monthEnd + 1)){
					detail = findDetailResult(year, monthStart, expStatus, deptId);
				}else{
					detail = findDetailResult(year, month, expStatus, deptId);
				}
				
				String tmpName = "";
				if( month == 1) tmpName = "Jan";
				if( month == 2) tmpName = "Feb";
				if( month == 3) tmpName = "Mar";
				if( month == 4) tmpName = "Apr";
				if( month == 5) tmpName = "May";
				if( month == 6) tmpName = "Jun";
				if( month == 7) tmpName = "Jul";
				if( month == 8) tmpName = "Aug";
				if( month == 9) tmpName = "Sep";
				if( month == 10) tmpName = "Oct";
				if( month == 11) tmpName = "Nov";
				if( month == 12) tmpName = "Dec";
			
				HSSFSheet detailSheet = null;
				
				if(month == monthStart){
					if(monthStart == monthEnd){
						detailSheet = wb.getSheet(detailFormSheetName);
						wb.setSheetName(1,tmpName);
					} else {
						continue;
					}
				}else if(month == (monthEnd + 1)){
					detailSheet = wb.getSheet(detailFormSheetName);
					
					String ms = "";
					if( monthStart == 1) ms = "Jan";
					if( monthStart == 2) ms = "Feb";
					if( monthStart == 3) ms = "Mar";
					if( monthStart == 4) ms = "Apr";
					if( monthStart == 5) ms = "May";
					if( monthStart == 6) ms = "Jun";
					if( monthStart == 7) ms = "Jul";
					if( monthStart == 8) ms = "Aug";
					if( monthStart == 9) ms = "Sep";
					if( monthStart == 10) ms = "Oct";
					if( monthStart == 11) ms = "Nov";
					if( monthStart == 12) ms = "Dec";
					
					wb.setSheetName(1,ms);
				}else{
					detailSheet = wb.cloneSheet(1);
					wb.setSheetName((month-monthStart+1),tmpName);
				}
				
				HSSFCellStyle textStyle = detailSheet.getRow(1).getCell((short) 0).getCellStyle();
				HSSFCellStyle numberStyle = detailSheet.getRow(1).getCell((short) 4).getCellStyle();
				
				for(int row = 0; row < detail.getRowCount(); row++){
					
					HRow = detailSheet.createRow(row + 1);
					
					cell = HRow.createCell((short) 0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getString(row,"proj_code") == null ? "" : detail.getString(row,"proj_code"));
					cell.setCellStyle(textStyle);
					
					cell = HRow.createCell((short) 1);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getString(row,"em_code") == null ? "" : detail.getString(row,"em_code"));
					cell.setCellStyle(textStyle);
					
					cell = HRow.createCell((short) 2);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getString(row,"employee") == null ? "" : detail.getString(row,"employee"));
					cell.setCellStyle(textStyle);
					
					cell = HRow.createCell((short) 3);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getString(row,"p_desc") == null ? "" : detail.getString(row,"p_desc"));
					cell.setCellStyle(textStyle);
					
					cell = HRow.createCell((short) 4);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getDouble(row,"total") == 0 ? "" : numFormator.format(detail.getDouble(row,"total")));
					cell.setCellStyle(numberStyle);
					
					cell = HRow.createCell((short) 5);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getDouble(row,"hotel") == 0 ? "" : numFormator.format(detail.getDouble(row,"hotel")));
					cell.setCellStyle(numberStyle);
					
					cell = HRow.createCell((short) 6);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getDouble(row,"meal") == 0 ? "" : numFormator.format(detail.getDouble(row,"meal")));
					cell.setCellStyle(numberStyle);
					
					cell = HRow.createCell((short) 7);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getDouble(row,"trans") == 0 ? "" : numFormator.format(detail.getDouble(row,"trans")));
					cell.setCellStyle(numberStyle);
					
					cell = HRow.createCell((short) 8);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getDouble(row,"allow") == 0 ? "" : numFormator.format(detail.getDouble(row,"allow")));
					cell.setCellStyle(numberStyle);
					
					cell = HRow.createCell((short) 9);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getDouble(row,"tel") == 0 ? "" : numFormator.format(detail.getDouble(row,"tel")));
					cell.setCellStyle(numberStyle);
					
					cell = HRow.createCell((short) 10);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getDouble(row,"misc") == 0 ? "" : numFormator.format(detail.getDouble(row,"misc")));
					cell.setCellStyle(numberStyle);
					
					cell = HRow.createCell((short) 11);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getString(row,"curr") == null ? "" : detail.getString(row,"curr"));
					cell.setCellStyle(textStyle);
					
					String paidBy = "";
					String tmp = detail.getString(row,"claim_type");
					if(tmp.equals("CN")){
						paidBy = "Company";
					}
					if(tmp.equals("CY")){
						paidBy = "Customer";
					}
					cell = HRow.createCell((short) 12);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(paidBy);
					cell.setCellStyle(textStyle);
					
					cell = HRow.createCell((short) 13);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getString(row,"status") == null ? "" : detail.getString(row,"status"));
					cell.setCellStyle(textStyle);
					
					cell = HRow.createCell((short) 14);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getString(row,"entry_date") == null ? "" : detail.getString(row,"entry_date"));
					cell.setCellStyle(textStyle);
					
					cell = HRow.createCell((short) 15);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getString(row,"exp_date") == null ? "" : detail.getString(row,"exp_date"));
					cell.setCellStyle(textStyle);
					
					cell = HRow.createCell((short) 16);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getString(row,"app_date") == null ? "" : detail.getString(row,"app_date"));
					cell.setCellStyle(textStyle);
					
					cell = HRow.createCell((short) 17);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(detail.getString(row,"claim_date") == null ? "" : detail.getString(row,"claim_date"));
					cell.setCellStyle(textStyle);
				}
			}
			
	
			// 写入Excel工作表
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.setStatus(HttpServletResponse.SC_OK);
			response.flushBuffer();
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	private final static String ExcelTemplate = "ExpenseRpt.xls";
	private final static String summaryFormSheetName="Summary";
	private final static String detailFormSheetName="Jan";
	private final static String SaveToFileName = "Expense Report.xls";
}
