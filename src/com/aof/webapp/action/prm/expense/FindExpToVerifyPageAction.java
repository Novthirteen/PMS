/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.expense;

import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.expense.ExpenseAmount;
import com.aof.component.prm.expense.ExpenseMaster;
import com.aof.component.prm.project.FMonth;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.prm.report.ReportBaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *
 */
public class FindExpToVerifyPageAction extends com.shcnc.struts.action.BaseAction {
	
	private Logger log =
		Logger.getLogger(FindExpToVerifyPageAction.class.getName());
	
	public ActionForward execute(ActionMapping mapping,ActionForm form,
		HttpServletRequest request,HttpServletResponse response) 
		throws HibernateException, IOException, IllegalAccessException, InvocationTargetException {
		// Extract attributes we will need
		
		Locale locale = getLocale(request);
		HttpSession session = request.getSession();
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		if(action == null) action = "QueryForList";
		
		if (action.equals("QueryForList")) {
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		}
		if (action.equals("VerifySelection")) {
			BatchUpdateStatus(request,"Verified");
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		}
		if (action.equals("ToFASelection")) {
			BatchUpdateStatus(request,"Posted To F&A");
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		}
		if (action.equals("ExportSelection")) {
			List result = findExportSelectionResult(request);
			if (result != null) return ExportList(request,response,result);
		}
		if (action.equals("ExportAll")) {
			List result = findQueryResult(request);
			if (result != null) return ExportList(request,response,result);
		}
		return (mapping.findForward("success"));
	}
	
	private List findQueryResult(HttpServletRequest request) {
		List result = null;
		try {
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
			HttpSession session = request.getSession();
			UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
			String UserId=ul.getUserLoginId();
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
			
			String textuser = request.getParameter("textuser");
			String textproj = request.getParameter("textproj");
			String textstatus = request.getParameter("textstatus");
			String textcode = request.getParameter("textcode");
			String departmentId = request.getParameter("departmentId");
			String DateStart = request.getParameter("DateStart");
			String DateEnd = request.getParameter("DateEnd");
			String ClaimType = request.getParameter("ClaimType");
			if (textproj==null) textproj="";
		//	if (textstatus==null) textstatus="Submitted";
			if (textstatus==null) textstatus="Approved";
			if (textuser==null) textuser="";
			if (textcode==null) textcode="";
			if (departmentId == null) departmentId = ul.getParty().getPartyId();
			if (DateStart==null) DateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
			if (DateEnd==null) DateEnd=Date_formater.format(nowDate);
			if(ClaimType == null) ClaimType = "CN";
			String ExportFlag = request.getParameter("ExportFlag");
			if (ExportFlag == null) ExportFlag = "N";
			
			PartyHelper ph = new PartyHelper();
			String PartyListStr = "''";
			if (!departmentId.trim().equals("")) {
				List partyList_dep=ph.getAllSubPartysByPartyId(hs,departmentId);
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'"+departmentId+"'";
				while (itdep.hasNext()) {
					Party p =(Party)itdep.next();
					PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
				}
			}
			
			String StatusListStr = "'Submitted','Verified','Approved','Posted To F&A','Claimed'";
			String QryStr = "select em from ExpenseMaster as em";
		//	QryStr = QryStr +" where (isnull(em.ApprovalDate,em.EntryDate) between fm.DateFrom and fm.DateTo)";
			QryStr = QryStr +" where (em.EntryDate between '"+DateStart+"' and '"+DateEnd+"')";
			if(!textstatus.trim().equals("")){
				QryStr = QryStr +" and (em.Status = '"+ textstatus +"')";
			} else{
				QryStr = QryStr +" and (em.Status in ("+ StatusListStr +"))";
			}
			if (ExportFlag.equals("N")) {
				QryStr = QryStr +" and (isnull(em.VerifyExportDate,'1990-01-01') = '1990-01-01')";
			}
			if(!textuser.trim().equals("")){
				QryStr = QryStr +" and ((em.ExpenseUser.name like '%"+ textuser.trim() +"%') or (em.ExpenseUser.userLoginId like '%"+ textuser.trim() +"%'))";
			}
			if(!textproj.trim().equals("")){
				QryStr = QryStr +" and ((em.Project.projName like '%"+ textproj.trim() +"%') or (em.Project.projId like '%"+ textproj.trim() +"%'))";
			}
			if(!textcode.trim().equals("")){
				QryStr = QryStr +" and (em.FormCode like '%"+ textcode.trim() +"%')";
			}

			QryStr = QryStr +" and em.ExpenseUser.party.partyId in ("+PartyListStr+")";
			QryStr = QryStr +" and em.ClaimType = '"+ClaimType+"'";
			QryStr = QryStr + " order by em.EntryDate DESC, em.Project.projId, em.ExpenseUser, em.FormCode";
			Query q= hs.createQuery(QryStr);
			result = q.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	private List findExportSelectionResult(HttpServletRequest request) {
		List result =  null;
		try {
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
			String QryStr = "select em from ExpenseMaster as em";
			String chk[] =request.getParameterValues("chk");
			if (chk != null) {
				int RowSize = java.lang.reflect.Array.getLength(chk);
				String emIdListStr = "";
				for (int i = 0; i < RowSize; i++) {
					emIdListStr = emIdListStr + chk[i] +",";
				}
				emIdListStr = emIdListStr.substring(0,emIdListStr.length()-1);
				QryStr = QryStr + " where em.Id in ("+emIdListStr+")";
				QryStr = QryStr + " order by em.ExpenseUser, em.FormCode";
				Query q= hs.createQuery(QryStr);
				result = q.list();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	private void BatchUpdateStatus(HttpServletRequest request,String ToStatus) {
		String chk[] =request.getParameterValues("chk");
		if (chk != null) {
			try {
				net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
				Transaction tx = hs.beginTransaction();
				int RowSize = java.lang.reflect.Array.getLength(chk);
				for (int i = 0; i < RowSize; i++) {
					ExpenseMaster findmaster = (ExpenseMaster)hs.load(ExpenseMaster.class, new Long(chk[i]));
					boolean updFlag = false;
					if (ToStatus.equals("Posted To F&A")) {
						if (findmaster.getReceiptDate() == null && findmaster.getApprovalDate() != null) {
							updFlag = true;
						}
					}
					if (ToStatus.equals("Verified")) {
						if (findmaster.getApprovalDate() == null) {
							updFlag = true;
						}
					}
					if (updFlag) {
						findmaster.setStatus(ToStatus);
						findmaster.setVerifyDate(UtilDateTime.nowTimestamp());
						hs.update(findmaster);
						Iterator itAmt =findmaster.getAmounts().iterator();
						while (itAmt.hasNext()) {
							ExpenseAmount ea = (ExpenseAmount)itAmt.next();
							if (ea.getConfirmedAmount() == null) 
								ea.setConfirmedAmount(ea.getUserAmount());
							hs.update(ea);
						}
					}
				}
				tx.commit();
				hs.flush();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	private ActionForward ExportList(HttpServletRequest request, HttpServletResponse response, List result) {
		
		Transaction tx = null;
		
		try {
			Iterator itExp = result.iterator();
			if (itExp.hasNext()) {
				net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
				tx = hs.beginTransaction();
				
				String ClaimType = request.getParameter("ClaimType");
				if((ClaimType == null)||(ClaimType.equals("CN"))) ClaimType = "Company";
				if(ClaimType.equals("CY")) ClaimType = "Customer";
				
				//Get Excel Template Path
				String TemplatePath = (new ReportBaseAction()).GetTemplateFolder();
				if (TemplatePath == null) return null;
				Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
				
				//Start to output the excel file
				response.reset();
				response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
				response.setContentType("application/octet-stream");
		
				//Use POI to read the selected Excel Spreadsheet
				HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
				//Select the first worksheet
				HSSFSheet sheet = wb.getSheet(FormSheetName);
				//Header
				HSSFCell cell = null;
				cell = sheet.getRow(0).getCell((short)8);
				cell.setCellValue(ClaimType);
				
				HSSFCellStyle FormatStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
				HSSFCellStyle DateFormatStyle = sheet.getRow(ListStartRow).getCell((short)5).getCellStyle();
				HSSFCellStyle NumberFormatStyle = sheet.getRow(ListStartRow).getCell((short)7).getCellStyle();
				HSSFRow HRow = null;
				float AmtClaim = 0;
				String CmtsValue = "";
				int ExcelRow = ListStartRow;
		//		Object[] findResult = null;
				while (itExp.hasNext()){
					ExpenseMaster findmaster = (ExpenseMaster)itExp.next();
			//		FMonth fm = (FMonth)findResult[1];
					HRow = sheet.createRow(ExcelRow);
					cell = HRow.createCell((short)0);			//Staff Name
					cell.setCellStyle(FormatStyle);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(findmaster.getExpenseUser().getName());
					cell = HRow.createCell((short)1);			//Form code
					cell.setCellStyle(FormatStyle);
					cell.setCellValue(findmaster.getFormCode());
					cell = HRow.createCell((short)2);			//Project			
					cell.setCellStyle(FormatStyle);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(findmaster.getProject().getProjId()+":"+findmaster.getProject().getProjName());
					
					cell = HRow.createCell((short)3);			//Customer			
					cell.setCellStyle(FormatStyle);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(findmaster.getProject().getBillTo().getPartyId()+":"+findmaster.getProject().getBillTo().getDescription());
					
					cell = HRow.createCell((short)4);			//Expense Date
					cell.setCellStyle(DateFormatStyle);
					cell.setCellValue(findmaster.getExpenseDate());
					
					cell = HRow.createCell((short)5);			//Approval Date
					cell.setCellStyle(DateFormatStyle);
					if (findmaster.getApprovalDate() != null) {
						cell.setCellValue(findmaster.getApprovalDate());
					}
					
					//--------------			
					float ExpAmtClaim = 0;
					float AllowanceAmtClaim = 0;
					ExpenseAmount exa = null;
					Iterator etAmt = findmaster.getAmounts().iterator();
					while (etAmt.hasNext()) {
						exa = (ExpenseAmount)etAmt.next();
						
						if (exa.getConfirmedAmount() != null) {
							if (exa.getExpType().getExpDesc().equals("Allowance")){
								AllowanceAmtClaim = AllowanceAmtClaim + exa.getConfirmedAmount().floatValue();
							}else{
								ExpAmtClaim = ExpAmtClaim + exa.getConfirmedAmount().floatValue();
							}
						} else { 
							if (exa.getExpType().getExpDesc().equals("Allowance")){
								AllowanceAmtClaim = AllowanceAmtClaim + exa.getUserAmount().floatValue();
							}else{
								ExpAmtClaim = ExpAmtClaim + exa.getUserAmount().floatValue();
							}
						}
					}
					//------------------
					
					cell = HRow.createCell((short)6);			//Alowance Amount
					if (AllowanceAmtClaim == 0){
						cell.setCellValue("");
					}else{
						cell.setCellValue(AllowanceAmtClaim);
					}
					cell.setCellStyle(NumberFormatStyle);
					
					cell = HRow.createCell((short)7);			//Expense Amount
					if (ExpAmtClaim == 0){
						cell.setCellValue("");
					}else{
						cell.setCellValue(ExpAmtClaim);
					}
					cell.setCellStyle(NumberFormatStyle);
					
					cell = HRow.createCell((short)8);			//Amount
					AmtClaim = 0;
					Iterator itAmt = findmaster.getAmounts().iterator();
					ExpenseAmount ea = null;
					while (itAmt.hasNext()) {
						ea = (ExpenseAmount)itAmt.next();
						if (ea.getConfirmedAmount() != null) {
							AmtClaim = AmtClaim + ea.getConfirmedAmount().floatValue();
						} else { 
							AmtClaim = AmtClaim + ea.getUserAmount().floatValue();
						}
					}
					cell.setCellStyle(NumberFormatStyle);
					cell.setCellValue(AmtClaim);
					
					cell = HRow.createCell((short)9);			//Exchange Rate
					cell.setCellStyle(NumberFormatStyle);
					float exRate = findmaster.getCurrencyRate().floatValue();
					cell.setCellValue(exRate);
					cell = HRow.createCell((short)10);			//Currency
					cell.setCellStyle(FormatStyle);
					cell.setCellValue(findmaster.getExpenseCurrency().getCurrId());
					cell = HRow.createCell((short)11);			//Amount RMB
					cell.setCellStyle(NumberFormatStyle);
					cell.setCellValue(AmtClaim*exRate);
					ExcelRow++;
					findmaster.setVerifyExportDate(nowDate);
					hs.update(findmaster);
				}
				//写入Excel工作表
				wb.write(response.getOutputStream());
				//关闭Excel工作薄对象
				response.getOutputStream().close();
				response.setStatus( HttpServletResponse.SC_OK );
				response.flushBuffer();
				
				//
				hs.flush();
			}
		}catch (Exception e) {
			if (tx != null) {
				try {
					tx.rollback();
				} catch (HibernateException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
			e.printStackTrace();
		}finally{
			try {
				if (tx != null) tx.commit();
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
		return null;	
	}
	private String fillPreZero(int no,int len) {
		String s=String.valueOf(no);
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<len-s.length();i++)
		{
			sb.append('0');
		}
		sb.append(s);
		return sb.toString();
	}
	private final static String ExcelTemplate="expensesummary.xls";
	private final static String FormSheetName="List";
	private final static String SaveToFileName="Expense Summary Report.xls";
	private final int ListStartRow = 3;
}
