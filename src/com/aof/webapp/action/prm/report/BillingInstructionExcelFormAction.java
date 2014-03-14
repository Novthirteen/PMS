/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.text.*;
import java.text.SimpleDateFormat;
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

import com.aof.component.prm.Bill.ProjectBill;
import com.aof.component.prm.Bill.BillInstructionService;
import com.aof.component.prm.Bill.BillTransactionDetail;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionErrorLog;
/**
* @author angus chen 
*
*/
public class BillingInstructionExcelFormAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		return ExportToExcel(mapping, form, request, response);
	}
	private ActionForward ExportToExcel (ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			String billId = request.getParameter("billId");
			String category = request.getParameter("category");
			if ((billId == null) || (billId.length() < 1))
				actionDebug.addGlobalError(errors,"error.context.required");
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			DateFormat df = new SimpleDateFormat("dd-MMM-yy", Locale.ENGLISH);
			NumberFormat numFormater = NumberFormat.getInstance();
			numFormater.setMaximumFractionDigits(2);
			numFormater.setMinimumFractionDigits(2);
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			//Fetch related Data
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			ProjectBill pb = (ProjectBill)hs.load(ProjectBill.class, new Long(billId));
			if (pb == null) return null;
			
			List CAFList  = pb.getCAFDetails();
			List AllowanceList = pb.getAllowanceDetails();
			List ExpenseList = pb.getExpenseDetails();
			List AcceptanceList = pb.getBillingDetails();
			List CreditDownPaymentList = pb.getCreditDownPaymentDetails();
			List DownPaymentList = pb.getDownPaymentDetails();
			
			double CAFAmt = pb.getCAFAmount();
			double AllowanceAmt = pb.getAllowanceAmount();
			double ExpenseAmt = pb.getExpenseAmount();
			double AcceptanceAmt = pb.getBillingAmount();
			double CreditDownPaymentAmt = pb.getCreditDownPaymentAmount();
			double DownPaymentAmt = pb.getDownPaymentAmount();
			//for downpayment
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = null;
			
			//Select the first worksheet
			String ct = "";
			if (pb.getProject().getContractType().equals("F"))
			{
				ct = "Fixed Price";
			}else{
				ct = "Time & Material";
			}
			if (category.equals("Down-Payment")) {
				wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+DownPayExcelTemplate));
				int ExcelRow4 = ListStartRow - 1 ;
				if (DownPaymentAmt!=0){
					HSSFSheet DownPaymentsheet = wb.getSheet(FormSheetDownPayment); 
					HSSFCell DownPaymentCell = null;
					
					DownPaymentsheet.addMergedRegion(new Region(2, (short) 1, 2, (short) 5));
					DownPaymentCell = DownPaymentsheet.getRow(2).getCell((short)1);
					DownPaymentCell.setCellValue(pb.getProject().getProjId() + " : " +pb.getProject().getProjName());
					
					DownPaymentsheet.addMergedRegion(new Region(2, (short) 7, 2, (short) 9));
					DownPaymentCell = DownPaymentsheet.getRow(2).getCell((short)7);
					DownPaymentCell.setCellValue(pb.getBillCode());
					
					DownPaymentsheet.addMergedRegion(new Region(3, (short) 1, 3, (short) 3));
					DownPaymentCell = DownPaymentsheet.getRow(3).getCell((short)1);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getBillAddress().getChineseName());
					
					DownPaymentsheet.addMergedRegion(new Region(3, (short) 6, 3, (short) 9));
					DownPaymentCell = DownPaymentsheet.getRow(3).getCell((short)6);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getProject().getCustomer().getChineseName());
					
					DownPaymentsheet.addMergedRegion(new Region(4, (short) 1, 4, (short) 5));
					DownPaymentCell = DownPaymentsheet.getRow(4).getCell((short)1);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getProject().getContact());
					
					DownPaymentsheet.addMergedRegion(new Region(4, (short) 7, 4, (short) 9));
					DownPaymentCell = DownPaymentsheet.getRow(4).getCell((short)7);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getBillAddress().getTeleCode());
					
					DownPaymentsheet.addMergedRegion(new Region(5, (short) 1, 5, (short) 8));				//	7
					DownPaymentCell = DownPaymentsheet.getRow(5).getCell((short)1);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getBillAddress().getAddress());
					
					DownPaymentsheet.addMergedRegion(new Region(6, (short) 1, 6, (short) 2));				//	8
					DownPaymentCell = DownPaymentsheet.getRow(6).getCell((short)1);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getBillAddress().getPostCode());
					
					DownPaymentsheet.addMergedRegion(new Region(6, (short) 7, 6, (short) 9));				//	9
					DownPaymentCell = DownPaymentsheet.getRow(6).getCell((short)7);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(ct);
					
					HSSFRow DownPaymentHRow = null;
					if (DownPaymentList != null && DownPaymentList.size() > 0) {
						//HSSFCellStyle Style1 = CAFsheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
						//HSSFCellStyle Style2 = CAFsheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
						//HSSFCellStyle Style3 = CAFsheet.getRow(ListStartRow).getCell((short)7).getCellStyle();
						//HSSFCellStyle Style4 = CAFsheet.getRow(ListStartRow).getCell((short)8).getCellStyle();
						int DownPaymentCount = 0;
						double DownPaymentTotal = 0;
						for (int i0 = 0; i0 < DownPaymentList.size(); i0++) {
							/*
							BillTransactionDetail btd = (BillTransactionDetail)AcceptanceList.get(i0);
							AcceptanceHRow = Acceptancesheet.createRow(ExcelRow3);
							Acceptancesheet.addMergedRegion(new Region(ExcelRow3, (short)0, ExcelRow3, (short)2 ));
							AcceptanceCell = AcceptanceHRow.createCell((short)0);
							AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AcceptanceCell.setCellValue(btd.getDesc1() != null ? btd.getDesc1() : "");
							AcceptanceCell.setCellStyle(Ss1);
							AcceptanceCell = AcceptanceHRow.createCell((short)1);
							AcceptanceCell.setCellStyle(Ss1);
							AcceptanceCell = AcceptanceHRow.createCell((short)2);
							AcceptanceCell.setCellStyle(Ss2);
							*/
							
							BillTransactionDetail btd = (BillTransactionDetail)DownPaymentList.get(i0);
							DownPaymentHRow = DownPaymentsheet.createRow(ExcelRow4);
							DownPaymentsheet.addMergedRegion(new Region(ExcelRow4, (short)0, ExcelRow4, (short)5 ));
							DownPaymentCell = DownPaymentHRow.createCell((short)0);
							DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							DownPaymentCell.setCellValue("DownPayment");
							//DownPaymentCell.setCellStyle(Style1);
							//DownPaymentCell = DownPaymentHRow.createCell((short)1);
							//DownPaymentCell.setCellStyle(Style1);
							
							
							DownPaymentCell = DownPaymentHRow.createCell((short)6);
							DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							DownPaymentCell.setCellValue("Amount : ");
							//DownPaymentCell.setCellStyle(Style1);
							//DownPaymentCell = DownPaymentHRow.createCell((short)3);
							//DownPaymentCell.setCellStyle(Style1);
							
							DownPaymentsheet.addMergedRegion(new Region(ExcelRow4, (short)7, ExcelRow4, (short)9 ));
							DownPaymentCell = DownPaymentHRow.createCell((short)7);
							DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							DownPaymentCell.setCellValue(btd.getAmount().doubleValue());
							//DownPaymentCell.setCellStyle(Style1);
							//DownPaymentCell = DownPaymentHRow.createCell((short)5);
							//DownPaymentCell.setCellStyle(Style1);
							
			
							double total1 = btd.getAmount().doubleValue();
							DownPaymentTotal = total1 + DownPaymentTotal;
							DownPaymentCount = i0+1;			
							ExcelRow4++;
						}
						DownPaymentHRow = DownPaymentsheet.createRow(ExcelRow4);
						DownPaymentCell = DownPaymentHRow.createCell((short)8);
						DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						DownPaymentCell.setCellValue("Total :");
						//DownPaymentCell.setCellStyle(Style1);
						
						DownPaymentCell = DownPaymentHRow.createCell((short)9);
						DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						DownPaymentCell.setCellValue(DownPaymentTotal);
						//DownPaymentCell.setCellStyle(Style4);
					}
				}
			} else {
				wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
				
				
				int ExcelRow = ListStartRow;
				int ExcelRow1 = ListStartRow;
				int ExcelRow2 = ListStartRow;
				int ExcelRow3 = ListStartRow;
				int ExcelRow4 = ListStartRow - 1 ;
				
//				DownPayment	---------------------------------------------------------------------------	
				if (CreditDownPaymentAmt!=0){
					HSSFSheet DownPaymentsheet = wb.getSheet(FormSheetDownPayment); 
					HSSFCell DownPaymentCell = null;
					
					DownPaymentsheet.addMergedRegion(new Region(2, (short) 1, 2, (short) 5));
					DownPaymentCell = DownPaymentsheet.getRow(2).getCell((short)1);
					DownPaymentCell.setCellValue(pb.getProject().getProjId() + " : " +pb.getProject().getProjName());
					
					DownPaymentsheet.addMergedRegion(new Region(2, (short) 7, 2, (short) 9));
					DownPaymentCell = DownPaymentsheet.getRow(2).getCell((short)7);
					DownPaymentCell.setCellValue(pb.getBillCode());
					
					DownPaymentsheet.addMergedRegion(new Region(3, (short) 1, 3, (short) 3));
					DownPaymentCell = DownPaymentsheet.getRow(3).getCell((short)1);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getBillAddress().getChineseName());
					
					DownPaymentsheet.addMergedRegion(new Region(3, (short) 6, 3, (short) 9));
					DownPaymentCell = DownPaymentsheet.getRow(3).getCell((short)6);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getProject().getCustomer().getChineseName());
					
					DownPaymentsheet.addMergedRegion(new Region(4, (short) 1, 4, (short) 5));
					DownPaymentCell = DownPaymentsheet.getRow(4).getCell((short)1);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getProject().getContact());
					
					DownPaymentsheet.addMergedRegion(new Region(4, (short) 7, 4, (short) 9));
					DownPaymentCell = DownPaymentsheet.getRow(4).getCell((short)7);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getBillAddress().getTeleCode());
					
					DownPaymentsheet.addMergedRegion(new Region(5, (short) 1, 5, (short) 8));				//	7
					DownPaymentCell = DownPaymentsheet.getRow(5).getCell((short)1);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getBillAddress().getAddress());
					
					DownPaymentsheet.addMergedRegion(new Region(6, (short) 1, 6, (short) 2));				//	8
					DownPaymentCell = DownPaymentsheet.getRow(6).getCell((short)1);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(pb.getBillAddress().getPostCode());
					
					DownPaymentsheet.addMergedRegion(new Region(6, (short) 7, 6, (short) 9));				//	9
					DownPaymentCell = DownPaymentsheet.getRow(6).getCell((short)7);
					DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					DownPaymentCell.setCellValue(ct);
					
					HSSFRow DownPaymentHRow = null;
					if (CreditDownPaymentList != null && CreditDownPaymentList.size() > 0) {
						//HSSFCellStyle Style1 = CAFsheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
						//HSSFCellStyle Style2 = CAFsheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
						//HSSFCellStyle Style3 = CAFsheet.getRow(ListStartRow).getCell((short)7).getCellStyle();
						//HSSFCellStyle Style4 = CAFsheet.getRow(ListStartRow).getCell((short)8).getCellStyle();
						int DownPaymentCount = 0;
						double DownPaymentTotal = 0;
						for (int i0 = 0; i0 < CreditDownPaymentList.size(); i0++) {
							/*
							BillTransactionDetail btd = (BillTransactionDetail)AcceptanceList.get(i0);
							AcceptanceHRow = Acceptancesheet.createRow(ExcelRow3);
							Acceptancesheet.addMergedRegion(new Region(ExcelRow3, (short)0, ExcelRow3, (short)2 ));
							AcceptanceCell = AcceptanceHRow.createCell((short)0);
							AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AcceptanceCell.setCellValue(btd.getDesc1() != null ? btd.getDesc1() : "");
							AcceptanceCell.setCellStyle(Ss1);
							AcceptanceCell = AcceptanceHRow.createCell((short)1);
							AcceptanceCell.setCellStyle(Ss1);
							AcceptanceCell = AcceptanceHRow.createCell((short)2);
							AcceptanceCell.setCellStyle(Ss2);
							*/
							
							BillTransactionDetail btd = (BillTransactionDetail)CreditDownPaymentList.get(i0);
							DownPaymentHRow = DownPaymentsheet.createRow(ExcelRow4);
							DownPaymentsheet.addMergedRegion(new Region(ExcelRow4, (short)0, ExcelRow4, (short)5 ));
							DownPaymentCell = DownPaymentHRow.createCell((short)0);
							DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							DownPaymentCell.setCellValue("DownPayment");
							//DownPaymentCell.setCellStyle(Style1);
							//DownPaymentCell = DownPaymentHRow.createCell((short)1);
							//DownPaymentCell.setCellStyle(Style1);
							
							
							DownPaymentCell = DownPaymentHRow.createCell((short)6);
							DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							DownPaymentCell.setCellValue("Amount : ");
							//DownPaymentCell.setCellStyle(Style1);
							//DownPaymentCell = DownPaymentHRow.createCell((short)3);
							//DownPaymentCell.setCellStyle(Style1);
							
							DownPaymentsheet.addMergedRegion(new Region(ExcelRow4, (short)7, ExcelRow4, (short)9 ));
							DownPaymentCell = DownPaymentHRow.createCell((short)7);
							DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							DownPaymentCell.setCellValue(btd.getAmount().doubleValue());
							//DownPaymentCell.setCellStyle(Style1);
							//DownPaymentCell = DownPaymentHRow.createCell((short)5);
							//DownPaymentCell.setCellStyle(Style1);
							
			
							double total1 = btd.getAmount().doubleValue();
							DownPaymentTotal = total1 + DownPaymentTotal;
							DownPaymentCount = i0+1;			
							ExcelRow4++;
						}
						DownPaymentHRow = DownPaymentsheet.createRow(ExcelRow4);
						DownPaymentCell = DownPaymentHRow.createCell((short)8);
						DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						DownPaymentCell.setCellValue("Total :");
						//DownPaymentCell.setCellStyle(Style1);
						
						DownPaymentCell = DownPaymentHRow.createCell((short)9);
						DownPaymentCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						DownPaymentCell.setCellValue(DownPaymentTotal);
						//DownPaymentCell.setCellStyle(Style4);
					}
				}else{
					wb.removeSheetAt(4);
				}
				
				//	Acceptance	---------------------------------------------------------------------------------
				if(AcceptanceAmt!=0){
					HSSFSheet Acceptancesheet = wb.getSheet(FormSheetAcceptance);
					HSSFCell AcceptanceCell = null;
					
					Acceptancesheet.addMergedRegion(new Region(2, (short) 1, 2, (short) 5));
					AcceptanceCell = Acceptancesheet.getRow(2).getCell((short)1);
					AcceptanceCell.setCellValue(pb.getProject().getProjId() + " : " +pb.getProject().getProjName());
					
					Acceptancesheet.addMergedRegion(new Region(2, (short) 7, 2, (short) 9));
					AcceptanceCell = Acceptancesheet.getRow(2).getCell((short)7);
					AcceptanceCell.setCellValue(pb.getBillCode());
					
					Acceptancesheet.addMergedRegion(new Region(3, (short) 1, 3, (short) 3));
					AcceptanceCell = Acceptancesheet.getRow(3).getCell((short)1);
					AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AcceptanceCell.setCellValue(pb.getBillAddress().getChineseName());
					
					Acceptancesheet.addMergedRegion(new Region(3, (short) 6, 3, (short) 9));
					AcceptanceCell = Acceptancesheet.getRow(3).getCell((short)6);
					AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AcceptanceCell.setCellValue(pb.getProject().getCustomer().getChineseName());
					
					Acceptancesheet.addMergedRegion(new Region(4, (short) 1, 4, (short) 5));
					AcceptanceCell = Acceptancesheet.getRow(4).getCell((short)1);
					AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AcceptanceCell.setCellValue(pb.getProject().getContact());
					
					Acceptancesheet.addMergedRegion(new Region(4, (short) 7, 4, (short) 9));
					AcceptanceCell = Acceptancesheet.getRow(4).getCell((short)7);
					AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AcceptanceCell.setCellValue(pb.getBillAddress().getTeleCode());
					
					Acceptancesheet.addMergedRegion(new Region(5, (short) 1, 5, (short) 8));				//	7
					AcceptanceCell = Acceptancesheet.getRow(5).getCell((short)1);
					AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AcceptanceCell.setCellValue(pb.getBillAddress().getAddress());
					
					Acceptancesheet.addMergedRegion(new Region(6, (short) 1, 6, (short) 2));				//	8
					AcceptanceCell = Acceptancesheet.getRow(6).getCell((short)1);
					AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AcceptanceCell.setCellValue(pb.getBillAddress().getPostCode());
					
					Acceptancesheet.addMergedRegion(new Region(6, (short) 7, 6, (short) 9));				//	9
					AcceptanceCell = Acceptancesheet.getRow(6).getCell((short)7);
					AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AcceptanceCell.setCellValue(ct);
					
					HSSFRow AcceptanceHRow = null;	
					if (AcceptanceList != null && AcceptanceList.size() > 0) {
						HSSFCellStyle Ss1 = Acceptancesheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
						HSSFCellStyle Ss2 = Acceptancesheet.getRow(ListStartRow).getCell((short)2).getCellStyle();
						HSSFCellStyle Ss3 = Acceptancesheet.getRow(ListStartRow).getCell((short)3).getCellStyle();
						HSSFCellStyle Ss4 = Acceptancesheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
						HSSFCellStyle Ss5 = Acceptancesheet.getRow(ListStartRow).getCell((short)5).getCellStyle();
						HSSFCellStyle Ss6 = Acceptancesheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
						HSSFCellStyle Ss7 = Acceptancesheet.getRow(ListStartRow).getCell((short)7).getCellStyle();
						HSSFCellStyle Ss8 = Acceptancesheet.getRow(ListStartRow).getCell((short)9).getCellStyle();
						
						
						int AllowanceCount = 0;
						double AllowanceTotal = 0;
						for (int i0 = 0; i0 < AcceptanceList.size(); i0++) {
							BillTransactionDetail btd = (BillTransactionDetail)AcceptanceList.get(i0);
							AcceptanceHRow = Acceptancesheet.createRow(ExcelRow3);
							Acceptancesheet.addMergedRegion(new Region(ExcelRow3, (short)0, ExcelRow3, (short)2 ));
							AcceptanceCell = AcceptanceHRow.createCell((short)0);
							AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AcceptanceCell.setCellValue(btd.getDesc1() != null ? btd.getDesc1() : "");
							AcceptanceCell.setCellStyle(Ss1);
							AcceptanceCell = AcceptanceHRow.createCell((short)1);
							AcceptanceCell.setCellStyle(Ss1);
							AcceptanceCell = AcceptanceHRow.createCell((short)2);
							AcceptanceCell.setCellStyle(Ss2);
							
							Acceptancesheet.addMergedRegion(new Region(ExcelRow3, (short)3, ExcelRow3, (short)4 ));
							AcceptanceCell = AcceptanceHRow.createCell((short)3);
							AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AcceptanceCell.setCellValue(btd.getTransactionDate() != null ? df.format(btd.getTransactionDate()) : "");
							AcceptanceCell.setCellStyle(Ss3);
							AcceptanceCell = AcceptanceHRow.createCell((short)4);
							AcceptanceCell.setCellStyle(Ss4);
							
							Acceptancesheet.addMergedRegion(new Region(ExcelRow3, (short)5, ExcelRow3, (short)6 ));
							AcceptanceCell = AcceptanceHRow.createCell((short)5);
							AcceptanceCell.setCellStyle(Ss5);
							AcceptanceCell = AcceptanceHRow.createCell((short)6);
							AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AcceptanceCell.setCellValue(btd.getTransactionNum2() != null ? numFormater.format(btd.getTransactionNum2()) : "");
							AcceptanceCell.setCellStyle(Ss6);
							
							Acceptancesheet.addMergedRegion(new Region(ExcelRow3, (short)7, ExcelRow3, (short)9 ));
							AcceptanceCell = AcceptanceHRow.createCell((short)7);
							AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AcceptanceCell.setCellValue(btd.getAmount() != null ? numFormater.format(btd.getAmount()) : "");
							AcceptanceCell.setCellStyle(Ss7);
							AcceptanceCell = AcceptanceHRow.createCell((short)8);
							AcceptanceCell.setCellStyle(Ss7);
							AcceptanceCell = AcceptanceHRow.createCell((short)9);
							AcceptanceCell.setCellStyle(Ss8);
							
							double total4 = btd.getAmount().doubleValue();
							AllowanceTotal = total4 + AllowanceTotal;
							AllowanceCount = i0+1;			
							ExcelRow3++;
						}
						AcceptanceHRow = Acceptancesheet.createRow(ListStartRow+AllowanceCount);
						Acceptancesheet.addMergedRegion(new Region((ListStartRow+AllowanceCount), (short)5, (ListStartRow+AllowanceCount), (short)6 ));
						AcceptanceCell = AcceptanceHRow.createCell((short)5);
						AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						AcceptanceCell.setCellStyle(Ss5);
						AcceptanceCell = AcceptanceHRow.createCell((short)6);
						AcceptanceCell.setCellValue("Total :");
						AcceptanceCell.setCellStyle(Ss6);
						
						
						Acceptancesheet.addMergedRegion(new Region((ListStartRow+AllowanceCount), (short)7, (ListStartRow+AllowanceCount), (short)9 ));
						AcceptanceCell = AcceptanceHRow.createCell((short)7);
						AcceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						AcceptanceCell.setCellValue(AllowanceTotal);
						AcceptanceCell.setCellStyle(Ss7);
						AcceptanceCell = AcceptanceHRow.createCell((short)8);
						AcceptanceCell.setCellStyle(Ss7);
						AcceptanceCell = AcceptanceHRow.createCell((short)9);
						AcceptanceCell.setCellStyle(Ss8);
					}
				}else{
					wb.removeSheetAt(3);
				}
				
		
				
		//	Expense	--------------------------------------------------------------------------
				if(ExpenseAmt!=0){
					HSSFSheet Expensesheet = wb.getSheet(FormSheetExpense); 
					HSSFCell ExpenseCell = null;
					
					Expensesheet.addMergedRegion(new Region(2, (short) 1, 2, (short) 5));
					ExpenseCell = Expensesheet.getRow(2).getCell((short)1);
					ExpenseCell.setCellValue(pb.getProject().getProjId() + " : " +pb.getProject().getProjName());
					
					Expensesheet.addMergedRegion(new Region(2, (short) 7, 2, (short) 9));
					ExpenseCell = Expensesheet.getRow(2).getCell((short)7);
					ExpenseCell.setCellValue(pb.getBillCode());
					
					Expensesheet.addMergedRegion(new Region(3, (short) 1, 3, (short) 3));
					ExpenseCell = Expensesheet.getRow(3).getCell((short)1);
					ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					ExpenseCell.setCellValue(pb.getBillAddress().getChineseName());
					
					Expensesheet.addMergedRegion(new Region(3, (short) 6, 3, (short) 9));
					ExpenseCell = Expensesheet.getRow(3).getCell((short)6);
					ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					ExpenseCell.setCellValue(pb.getProject().getCustomer().getChineseName());
					
					Expensesheet.addMergedRegion(new Region(4, (short) 1, 4, (short) 5));
					ExpenseCell = Expensesheet.getRow(4).getCell((short)1);
					ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					ExpenseCell.setCellValue(pb.getProject().getContact());
					
					Expensesheet.addMergedRegion(new Region(4, (short) 7, 4, (short) 9));
					ExpenseCell = Expensesheet.getRow(4).getCell((short)7);
					ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					ExpenseCell.setCellValue(pb.getBillAddress().getTeleCode());
					
					Expensesheet.addMergedRegion(new Region(5, (short) 1, 5, (short) 8));				//	7
					ExpenseCell = Expensesheet.getRow(5).getCell((short)1);
					ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					ExpenseCell.setCellValue(pb.getBillAddress().getAddress());
					
					Expensesheet.addMergedRegion(new Region(6, (short) 1, 6, (short) 2));				//	8
					ExpenseCell = Expensesheet.getRow(6).getCell((short)1);
					ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					ExpenseCell.setCellValue(pb.getBillAddress().getPostCode());
					
					Expensesheet.addMergedRegion(new Region(6, (short) 7, 6, (short) 9));				//	9
					ExpenseCell = Expensesheet.getRow(6).getCell((short)7);
					ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					ExpenseCell.setCellValue(ct);
					
					HSSFRow	ExpenseHRow = null;
					if (ExpenseList != null && ExpenseList.size() > 0) {
						HSSFCellStyle Ss1 = Expensesheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
						HSSFCellStyle Ss2 = Expensesheet.getRow(ListStartRow).getCell((short)4).getCellStyle();
						HSSFCellStyle Ss3 = Expensesheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
						
						int ExpenseCount = 0;
						double ExpenseTotal = 0;
						for (int i0 = 0; i0 < ExpenseList.size(); i0++) {
							BillTransactionDetail btd = (BillTransactionDetail)ExpenseList.get(i0);
							ExpenseHRow = Expensesheet.createRow(ExcelRow2);
							Expensesheet.addMergedRegion(new Region(ExcelRow2, (short) 0, ExcelRow2, (short) 1));
							ExpenseCell = ExpenseHRow.createCell((short)0);
							ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							ExpenseCell.setCellValue(btd.getDesc1() != null ? btd.getDesc1() : "");
							ExpenseCell.setCellStyle(Ss1);
							ExpenseCell = ExpenseHRow.createCell((short)1);
							ExpenseCell.setCellStyle(Ss1);
							
							Expensesheet.addMergedRegion(new Region(ExcelRow2, (short) 2, ExcelRow2, (short) 3));
							ExpenseCell = ExpenseHRow.createCell((short)2);
							ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							ExpenseCell.setCellValue(btd.getTransactionUser() != null ? btd.getTransactionUser().getName() : "");
							ExpenseCell.setCellStyle(Ss1);
							ExpenseCell = ExpenseHRow.createCell((short)3);
							ExpenseCell.setCellStyle(Ss1);
							
							Expensesheet.addMergedRegion(new Region(ExcelRow2, (short) 4, ExcelRow2, (short) 5));
							ExpenseCell = ExpenseHRow.createCell((short)4);
							ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							ExpenseCell.setCellValue(btd.getTransactionDate() != null ? df.format(btd.getTransactionDate()) : "");
							ExpenseCell.setCellStyle(Ss2);
							ExpenseCell = ExpenseHRow.createCell((short)5);
							ExpenseCell.setCellStyle(Ss2);
							
							ExpenseCell = ExpenseHRow.createCell((short)6);
							ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							ExpenseCell.setCellValue(btd.getAmount() != null ? numFormater.format(btd.getAmount()) : "");
							ExpenseCell.setCellStyle(Ss3);
							
							Expensesheet.addMergedRegion(new Region(ExcelRow2, (short) 7, ExcelRow2, (short) 9));
							ExpenseCell = ExpenseHRow.createCell((short)7);
							ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							ExpenseCell.setCellValue(btd.getTransactionDate1() != null ? df.format(btd.getTransactionDate1()) : "");
							ExpenseCell.setCellStyle(Ss2);
							ExpenseCell = ExpenseHRow.createCell((short)8);
							ExpenseCell.setCellStyle(Ss2);
							ExpenseCell = ExpenseHRow.createCell((short)9);
							ExpenseCell.setCellStyle(Ss2);
							
							double total3 = btd.getAmount().doubleValue();
							ExpenseTotal = total3 + ExpenseTotal;
							ExpenseCount = i0+1;			
							ExcelRow2++;
						}
						ExpenseHRow = Expensesheet.createRow(ListStartRow+ExpenseCount);
						Expensesheet.addMergedRegion(new Region((ListStartRow+ExpenseCount), (short) 4, (ListStartRow+ExpenseCount), (short) 5));
						ExpenseCell = ExpenseHRow.createCell((short)4);
						ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						ExpenseCell.setCellValue("Total :");
						ExpenseCell.setCellStyle(Ss1);
						ExpenseCell = ExpenseHRow.createCell((short)5);
						ExpenseCell.setCellStyle(Ss1);
						
						ExpenseCell = ExpenseHRow.createCell((short)6);
						ExpenseCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						ExpenseCell.setCellValue(ExpenseTotal);
						ExpenseCell.setCellStyle(Ss3);
					}
				}else{
					wb.removeSheetAt(2);
				}
				

//				Allowance	--------------------------------------------------------------------------------------
				if(AllowanceAmt!=0){
					HSSFSheet Allowancesheet = wb.getSheet(FormSheetAllowance); 
					HSSFCell AllowanceCell = null;
					
					Allowancesheet.addMergedRegion(new Region(2, (short) 1, 2, (short) 5));
					AllowanceCell = Allowancesheet.getRow(2).getCell((short)1);
					AllowanceCell.setCellValue(pb.getProject().getProjId() + " : " +pb.getProject().getProjName());
					
					Allowancesheet.addMergedRegion(new Region(2, (short) 7, 2, (short) 9));
					AllowanceCell = Allowancesheet.getRow(2).getCell((short)7);
					AllowanceCell.setCellValue(pb.getBillCode());
					
					Allowancesheet.addMergedRegion(new Region(3, (short) 1, 3, (short) 3));
					AllowanceCell = Allowancesheet.getRow(3).getCell((short)1);
					AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AllowanceCell.setCellValue(pb.getBillAddress().getChineseName());
					
					Allowancesheet.addMergedRegion(new Region(3, (short) 6, 3, (short) 9));
					AllowanceCell = Allowancesheet.getRow(3).getCell((short)6);
					AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AllowanceCell.setCellValue(pb.getProject().getCustomer().getChineseName());
								
					Allowancesheet.addMergedRegion(new Region(4, (short) 1, 4, (short) 5));
					AllowanceCell = Allowancesheet.getRow(4).getCell((short)1);
					AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AllowanceCell.setCellValue(pb.getProject().getContact());
					
					Allowancesheet.addMergedRegion(new Region(4, (short) 7, 4, (short) 9));
					AllowanceCell = Allowancesheet.getRow(4).getCell((short)7);
					AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AllowanceCell.setCellValue(pb.getBillAddress().getTeleCode());
					
					Allowancesheet.addMergedRegion(new Region(5, (short) 1, 5, (short) 8));				//	7
					AllowanceCell = Allowancesheet.getRow(5).getCell((short)1);
					AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AllowanceCell.setCellValue(pb.getBillAddress().getAddress());
					
					Allowancesheet.addMergedRegion(new Region(6, (short) 1, 6, (short) 2));				//	8
					AllowanceCell = Allowancesheet.getRow(6).getCell((short)1);
					AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AllowanceCell.setCellValue(pb.getBillAddress().getPostCode());
					
					Allowancesheet.addMergedRegion(new Region(6, (short) 7, 6, (short) 9));				//	9
					AllowanceCell = Allowancesheet.getRow(6).getCell((short)7);
					AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					AllowanceCell.setCellValue(ct);
					
					HSSFRow AllowanceHRow = null;
					if (AllowanceList != null && AllowanceList.size() > 0) {
						HSSFCellStyle S1 = Allowancesheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
						HSSFCellStyle S2 = Allowancesheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
						HSSFCellStyle S3 = Allowancesheet.getRow(ListStartRow).getCell((short)7).getCellStyle();
						HSSFCellStyle S4 = Allowancesheet.getRow(ListStartRow).getCell((short)8).getCellStyle();
						int AllowanceCount = 0;
						double AllowanceTotal = 0;
						for (int i0 = 0; i0 < AllowanceList.size(); i0++) {
							BillTransactionDetail btd = (BillTransactionDetail)AllowanceList.get(i0);
							AllowanceHRow = Allowancesheet.createRow(ExcelRow1);
							Allowancesheet.addMergedRegion(new Region(ExcelRow1, (short) 0, ExcelRow1, (short) 2));
							AllowanceCell = AllowanceHRow.createCell((short)0);
							AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AllowanceCell.setCellValue(btd.getTransactionUser() != null ? btd.getTransactionUser().getName() : "");
							AllowanceCell.setCellStyle(S1);
							AllowanceCell = AllowanceHRow.createCell((short)1);
							AllowanceCell.setCellStyle(S1);
							AllowanceCell = AllowanceHRow.createCell((short)2);
							AllowanceCell.setCellStyle(S1);
							
							/*
							Allowancesheet.addMergedRegion(new Region(ExcelRow1, (short) 2, ExcelRow1, (short) 3));
							AllowanceCell = AllowanceHRow.createCell((short)2);
							AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AllowanceCell.setCellValue(btd.getDesc1() != null ? btd.getDesc1() : "");
							AllowanceCell.setCellStyle(S1);
							AllowanceCell = AllowanceHRow.createCell((short)3);
							AllowanceCell.setCellStyle(S1);
							*/
							
							Allowancesheet.addMergedRegion(new Region(ExcelRow1, (short) 3, ExcelRow1, (short) 5));
							AllowanceCell = AllowanceHRow.createCell((short)3);
							AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AllowanceCell.setCellValue(btd.getDesc2() != null ? btd.getDesc2() : "");
							AllowanceCell.setCellStyle(S1);
							AllowanceCell = AllowanceHRow.createCell((short)4);
							AllowanceCell.setCellStyle(S1);
							AllowanceCell = AllowanceHRow.createCell((short)5);
							AllowanceCell.setCellStyle(S1);
							
							AllowanceCell = AllowanceHRow.createCell((short)6);
							AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AllowanceCell.setCellValue(btd.getTransactionDate() != null ? df.format(btd.getTransactionDate()) : "");
							AllowanceCell.setCellStyle(S2);
							
							AllowanceCell = AllowanceHRow.createCell((short)7);
							AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AllowanceCell.setCellValue(btd.getTransactionNum1() != null ? numFormater.format(btd.getTransactionNum1()) : "");
							AllowanceCell.setCellStyle(S3);
							
							AllowanceCell = AllowanceHRow.createCell((short)8);
							AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AllowanceCell.setCellValue(btd.getTransactionNum2() != null ? numFormater.format(btd.getTransactionNum2()) : "");
							AllowanceCell.setCellStyle(S4);
							
							AllowanceCell = AllowanceHRow.createCell((short)9);
							AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							AllowanceCell.setCellValue(btd.getAmount() != null ? numFormater.format(btd.getAmount()) : "");
							AllowanceCell.setCellStyle(S4);
							
							double total2 = btd.getAmount().doubleValue();
							AllowanceTotal = total2 + AllowanceTotal;
							AllowanceCount = i0+1;			
							ExcelRow1++;
						}
						AllowanceHRow = Allowancesheet.createRow(ListStartRow+AllowanceCount);
						AllowanceCell = AllowanceHRow.createCell((short)8);
						AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						AllowanceCell.setCellValue("Total :");
						AllowanceCell.setCellStyle(S1);
						
						AllowanceCell = AllowanceHRow.createCell((short)9);
						AllowanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						AllowanceCell.setCellValue(AllowanceTotal);
						AllowanceCell.setCellStyle(S4);
					}
				}else{
					wb.removeSheetAt(1);
				}

//				CAF	---------------------------------------------------------------------------	
				if (CAFAmt!=0){
					HSSFSheet CAFsheet = wb.getSheet(FormSheetCAF); 
					HSSFCell CAFCell = null;
					
					CAFsheet.addMergedRegion(new Region(2, (short) 1, 2, (short) 5));				//	1
					CAFCell = CAFsheet.getRow(2).getCell((short)1);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(pb.getProject().getProjId() + " : " +pb.getProject().getProjName());
					
					CAFsheet.addMergedRegion(new Region(2, (short) 7, 2, (short) 9));				//	2
					CAFCell = CAFsheet.getRow(2).getCell((short)7);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(pb.getBillCode());
								
					CAFsheet.addMergedRegion(new Region(3, (short) 1, 3, (short) 3));				//	3
					CAFCell = CAFsheet.getRow(3).getCell((short)1);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(pb.getBillAddress().getChineseName());
					
					CAFsheet.addMergedRegion(new Region(3, (short) 6, 3, (short) 9));				//	4
					CAFCell = CAFsheet.getRow(3).getCell((short)6);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(pb.getProject().getCustomer().getChineseName());
								
					CAFsheet.addMergedRegion(new Region(4, (short) 1, 4, (short) 5));				//	5
					CAFCell = CAFsheet.getRow(4).getCell((short)1);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(pb.getProject().getContact());
					
					CAFsheet.addMergedRegion(new Region(4, (short) 7, 4, (short) 9));				//	6
					CAFCell = CAFsheet.getRow(4).getCell((short)7);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(pb.getBillAddress().getTeleCode());
					
					CAFsheet.addMergedRegion(new Region(5, (short) 1, 5, (short) 8));				//	7
					CAFCell = CAFsheet.getRow(5).getCell((short)1);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(pb.getBillAddress().getAddress());
					
					CAFsheet.addMergedRegion(new Region(6, (short) 1, 6, (short) 2));				//	8
					CAFCell = CAFsheet.getRow(6).getCell((short)1);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(pb.getBillAddress().getPostCode());
					
					CAFsheet.addMergedRegion(new Region(6, (short) 7, 6, (short) 9));				//	9
					CAFCell = CAFsheet.getRow(6).getCell((short)7);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(ct);
					
					HSSFRow CAFHRow = null;
					if (CAFList != null && CAFList.size() > 0) {
						HSSFCellStyle Style1 = CAFsheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
						HSSFCellStyle Style2 = CAFsheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
						HSSFCellStyle Style3 = CAFsheet.getRow(ListStartRow).getCell((short)7).getCellStyle();
						HSSFCellStyle Style4 = CAFsheet.getRow(ListStartRow).getCell((short)8).getCellStyle();
						int CAFCount = 0;
						double CAFTotal = 0;
						double dayTotal = 0;
						for (int i0 = 0; i0 < CAFList.size(); i0++) {
							BillTransactionDetail btd = (BillTransactionDetail)CAFList.get(i0);
							CAFHRow = CAFsheet.createRow(ExcelRow);
							CAFsheet.addMergedRegion(new Region(ExcelRow, (short) 0, ExcelRow, (short) 2));
							CAFCell = CAFHRow.createCell((short)0);
							CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							CAFCell.setCellValue(btd.getTransactionUser() != null ? btd.getTransactionUser().getName() : "");
							CAFCell.setCellStyle(Style1);
							CAFCell = CAFHRow.createCell((short)1);
							CAFCell.setCellStyle(Style1);
							CAFCell = CAFHRow.createCell((short)2);
							CAFCell.setCellStyle(Style1);
							
							/*
							CAFsheet.addMergedRegion(new Region(ExcelRow, (short) 2, ExcelRow, (short) 3));
							CAFCell = CAFHRow.createCell((short)2);
							CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							CAFCell.setCellValue(btd.getDesc1() != null ? btd.getDesc1() : "");
							CAFCell.setCellStyle(Style1);
							CAFCell = CAFHRow.createCell((short)3);
							CAFCell.setCellStyle(Style1);
							*/
							
							CAFsheet.addMergedRegion(new Region(ExcelRow, (short) 3, ExcelRow, (short) 5));
							CAFCell = CAFHRow.createCell((short)3);
							CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							CAFCell.setCellValue(btd.getDesc2() != null ? btd.getDesc2() : "");
							CAFCell.setCellStyle(Style1);
							CAFCell = CAFHRow.createCell((short)4);
							CAFCell.setCellStyle(Style1);
							CAFCell = CAFHRow.createCell((short)5);
							CAFCell.setCellStyle(Style1);
							
							CAFCell = CAFHRow.createCell((short)6);
							CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							CAFCell.setCellValue(btd.getTransactionDate() != null ? df.format(btd.getTransactionDate()) : "");
							CAFCell.setCellStyle(Style2);
							
							double totalDay =btd.getTransactionNum1().doubleValue();
							dayTotal = totalDay + dayTotal;
							CAFCell = CAFHRow.createCell((short)7);
							CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							CAFCell.setCellValue(btd.getTransactionNum1() != null ? numFormater.format(btd.getTransactionNum1()) : "");
							CAFCell.setCellStyle(Style3);
							
							CAFCell = CAFHRow.createCell((short)8);
							CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							CAFCell.setCellValue(btd.getTransactionNum2() != null ? numFormater.format(btd.getTransactionNum2()) : "");
							CAFCell.setCellStyle(Style4);
							
							CAFCell = CAFHRow.createCell((short)9);
							CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							CAFCell.setCellValue(btd.getAmount() != null ? numFormater.format(btd.getAmount()) : "");
							CAFCell.setCellStyle(Style4);
							
							double total1 = btd.getAmount().doubleValue();
							CAFTotal = total1 + CAFTotal;
							CAFCount = i0+1;			
							ExcelRow++;
						}
						CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount);
						CAFCell = CAFHRow.createCell((short)6);
						CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						CAFCell.setCellValue("Total :");
						CAFCell.setCellStyle(Style1);
						CAFCell = CAFHRow.createCell((short)7);
						CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						CAFCell.setCellValue(dayTotal/8 + " days");
						CAFCell.setCellStyle(Style4);
						
						CAFCell = CAFHRow.createCell((short)8);
						CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断

						CAFCell.setCellStyle(Style4);
						
						
						CAFCell = CAFHRow.createCell((short)9);
						CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						CAFCell.setCellValue(CAFTotal);
						CAFCell.setCellStyle(Style4);
					}
				}else{
					wb.removeSheetAt(0);
				}
			}
			
			
			//写入Excel工作表
			wb.write(response.getOutputStream());
			//关闭Excel工作薄对象
			response.getOutputStream().close();
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	private final static String DownPayExcelTemplate = "DownPaymentBillingInstructionExcelForm.xls";
	private final static String ExcelTemplate="BillingInstructionExcelForm.xls";
	private final static String FormSheetCAF="CAFForm";
	private final static String FormSheetAllowance="AllowanceForm";
	private final static String FormSheetExpense="ExpenseForm";
	private final static String FormSheetAcceptance="AcceptanceForm";
	private final static String FormSheetDownPayment="DownPaymentForm";
	private final static String SaveToFileName="Billing Instruction Excel Form.xls";
	private final int ListStartRow = 9;
}