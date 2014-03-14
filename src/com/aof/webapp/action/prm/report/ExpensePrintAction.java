/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Query;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.expense.ExpenseComments;
import com.aof.component.prm.expense.ExpenseDetail;
import com.aof.component.prm.expense.ExpenseMaster;
import com.aof.component.prm.project.ExpenseType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
/**
 * @author Jeffrey Liang 
 * @version 2005-1-12
 *
 */
public class ExpensePrintAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		return ExportToExcel(mapping, form, request, response);
	}
	private ActionForward ExportToExcel (ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			String DataId = request.getParameter("DataId");
			if ((DataId == null) || (DataId.length() < 1))
				actionDebug.addGlobalError(errors,"error.context.required");
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			//Fetch related Data
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			ExpenseMaster findmaster = (ExpenseMaster)hs.load(ExpenseMaster.class, new Long(DataId));
			if (findmaster == null) return null;
			UserLogin ul = findmaster.getExpenseUser();
			List ExpList = hs.createQuery("select et from ExpenseType as et order by et.expSeq ASC").list();
			Iterator itExpType = ExpList.iterator();
			Date dayStart = findmaster.getExpenseDate();
			ArrayList DateList = new ArrayList();
			for (int i = 0; i < 14; i++) {
				DateList.add(UtilDateTime.getDiffDay(dayStart, i));
			}
			Iterator itDate = DateList.iterator();
			Query q=hs.createQuery("select ed from ExpenseDetail as ed inner join ed.ExpMaster as em inner join ed.ExpType as et where em.Id =:DataId order by ed.ExpenseDate, et.expSeq ASC");
			q.setParameter("DataId", DataId);
			List detailList = q.list();
			q=hs.createQuery("select ec from ExpenseComments as ec inner join ec.ExpMaster as em where em.Id =:DataId order by ec.ExpenseDate");
			q.setParameter("DataId", DataId);
			List CmtsList = q.list();
			Iterator itDetail = detailList.iterator();
			Iterator itCmts = CmtsList.iterator();
			ExpenseDetail ed = null;
			if (itDetail.hasNext()) {
				ed = (ExpenseDetail)itDetail.next();
			} else {
				return null;
			}
			ExpenseComments ec = null;
			if (itCmts.hasNext()) {
				ec = (ExpenseComments)itCmts.next();
			}
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"Expense"+ findmaster.getFormCode() + ".xls\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName); 
			
			//Header
			HSSFRow row = sheet.getRow(5);
			HSSFCell cell = row.getCell((short)1);				//ER No.
			cell.setCellValue(findmaster.getFormCode());
			cell = row.getCell((short)4);	//Department
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(ul.getParty().getDescription());
			cell = row.getCell((short)8);		// User Name
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(ul.getName());
			cell = row.getCell((short)12);				//Customer
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(findmaster.getProject().getCustomer().getPartyId()+":"+findmaster.getProject().getCustomer().getDescription());

			if (findmaster.getClaimType().equals("CY")) {		//Paid by
				cell = sheet.getRow(1).getCell((short)12);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(findmaster.getProject().getBillTo().getPartyId()+":"+findmaster.getProject().getBillTo().getDescription()+"("+findmaster.getProject().getBillTo().getChineseName()+")");
			}
			
			cell = sheet.getRow(2).getCell((short)12);
			cell.setCellValue(findmaster.getExpenseCurrency().getCurrId());
			cell = sheet.getRow(3).getCell((short)12);
			cell.setCellValue(findmaster.getCurrencyRate().floatValue());
			cell = sheet.getRow(4).getCell((short)12);  //Project Information
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(findmaster.getProject().getProjId()+":"+findmaster.getProject().getProjName()+" ( "+findmaster.getProject().getDepartment().getDescription()+" )");
			
			cell = sheet.getRow(25).getCell((short)3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue("Employee ("+ul.getName()+")");
			cell = sheet.getRow(27).getCell((short)3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue("Confirmed By ("+findmaster.getProject().getProjectManager().getName()+")");
			
			//List Header
			int ExcelRow = 0;
			int ExcelCol = 0;
			
			//List
			boolean NullData = true;
			ExcelRow = ListStartRow;
			while (itDate.hasNext()) {
				Date fd = (Date)itDate.next();
				row = sheet.getRow(ExcelRow);
				cell = row.getCell((short)0);
				cell.setCellValue(fd);
				ExcelCol = ListStartCol;
				itExpType = ExpList.iterator();
				while(itExpType.hasNext()){
					ExpenseType et = (ExpenseType)itExpType.next();
					NullData = false;
					ExcelCol++;
					if (ed != null) {
						if (ed.getExpenseDate().equals(fd) && ed.getExpType().equals(et)) {
							cell = row.getCell((short)ExcelCol);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(ed.getUserAmount().doubleValue());
							if (itDetail.hasNext()) {
								ed = (ExpenseDetail)itDetail.next();
							}
						}
					} 
				}
				if (ec != null) {
					if (ec.getExpenseDate().equals(fd)) {
						cell = row.getCell((short)1);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(ec.getComments());
						if (itCmts.hasNext()) {
							ec = (ExpenseComments)itCmts.next();
						}
					}
				} 
				ExcelRow++;
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
	private final static String ExcelTemplate="ExpenseTemplate.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Expense Claim.xls";
	private final int ListStartRow = 7;
	private final int ListStartCol = 5;
}