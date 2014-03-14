/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.expense;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.expense.ExpenseMaster;
import com.aof.component.prm.expense.ProjectAirFareCost;
import com.aof.component.prm.expense.ProjectCostMaster;
import com.aof.component.prm.util.EmailService;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.report.ReportBaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *
 */
public class FindCostSelfPageAction extends ReportBaseAction {
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if(action == null) action = "QueryForList";
		
		if (action.equals("QueryForList")) {
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		} 
		
		if (action.equals("PAConfirm")) {
			String chk[] =request.getParameterValues("chk");
			TransactionServices ts = new TransactionServices();								

			if (chk != null) {
				try {
					net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
					Transaction tx = hs.beginTransaction();
					int RowSize = java.lang.reflect.Array.getLength(chk);
					for (int i = 0; i < RowSize; i++) {
						ProjectCostMaster pcm = (ProjectCostMaster)hs.load(ProjectCostMaster.class, new Integer(chk[i]));
						if (pcm.getPAConfirm() == null) {
							pcm.setPAConfirm(UtilDateTime.nowTimestamp());
							hs.update(pcm);
						}
						ts.insert(pcm, ul);
					}
					tx.commit();
					hs.flush();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		}
		if (action.equals("PAUNConfirm")) {
			String chk[] =request.getParameterValues("chk");
			TransactionServices ts = new TransactionServices();								

			if (chk != null) {
				try {
					net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
					Transaction tx = hs.beginTransaction();
					int RowSize = java.lang.reflect.Array.getLength(chk);
					for (int i = 0; i < RowSize; i++) {
						ProjectCostMaster pcm = (ProjectCostMaster)hs.load(ProjectCostMaster.class, new Integer(chk[i]));
						if (pcm.getPAConfirm() != null) {
							pcm.setPAConfirm(null);
							hs.update(pcm);
						}
						ts.remove(pcm);
					}
					tx.commit();
					hs.flush();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		}
		if (action.equals("Confirm")) {
			String chk[] =request.getParameterValues("chk");
			TransactionServices ts = new TransactionServices();								

			if (chk != null) {
				try {
					net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
					Transaction tx = hs.beginTransaction();
					int RowSize = java.lang.reflect.Array.getLength(chk);
					for (int i = 0; i < RowSize; i++) {
						ProjectCostMaster pcm = (ProjectCostMaster)hs.load(ProjectCostMaster.class, new Integer(chk[i]));
						if (pcm.getApprovalDate() == null) {
							pcm.setApprovalDate(UtilDateTime.nowTimestamp());
							pcm.setPayStatus("confirmed");
							hs.update(pcm);
						}
				//		ts.remove(pcm);
					}
					tx.commit();
					hs.flush();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		}
		if (action.equals("PostToFA")) {
			String chk[] =request.getParameterValues("chk");
			if (chk != null) {
				try {
					net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
	//				Transaction tx = hs.beginTransaction();
					int RowSize = java.lang.reflect.Array.getLength(chk);
					for (int i = 0; i < RowSize; i++) {
						ProjectCostMaster pcm = (ProjectCostMaster)hs.load(ProjectCostMaster.class, new Integer(chk[i]));
						ProjectAirFareCost pac = (ProjectAirFareCost)hs.load(ProjectAirFareCost.class, new Integer(chk[i]));
					//	if(pac.getReturnDate()!=null){
							pcm.setPayStatus("Posted");
							hs.save(pcm);
					//	}
					}
		//			tx.commit();
					hs.flush();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		}
		if (action.equals("ExcelPrint")) {
			String chk[] =request.getParameterValues("chk");
			
			if (chk != null) {
				try {
//					Get Excel Template Path =============================================
					net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
					
					String TemplatePath = GetTemplateFolder();
					if (TemplatePath == null) return null;
					
					int RowSize = java.lang.reflect.Array.getLength(chk);
					
					//Start to output the excel file
					response.reset();
					response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
					response.setContentType("application/octet-stream");
					
					//Use POI to read the selected Excel Spreadsheet
					HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
					//Select the first worksheet
					HSSFSheet sheet = wb.getSheet(FormSheetName);
					
					DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
					String status ="";
								
					HSSFCell cell = null;
							
					//List
					HSSFCellStyle boldTextStyle     = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
					HSSFCellStyle dateStyle     = sheet.getRow(1).getCell((short)7).getCellStyle();
					HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
					
					int ExcelRow = ListStartRow;
					
					HSSFRow HRow = null;
					HRow = sheet.createRow(1);
					cell = HRow.createCell((short)7);
					cell.setCellValue(new Date());
					cell.setCellStyle(dateStyle);
					
					//in order to make groups
					
					short cellNumber = 0;
					
					//write the titles
					HRow = sheet.createRow(titleRow);
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Ticket Code");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Project ID");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Staff Name");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Description");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Bill To");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Create Date");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Flight No.");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Paid By");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Flight Date");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Confirm Date");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Price");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("Vendor");
					cell.setCellStyle(boldTextStyle);
					

					
					//write contents
					for (int i = 0; i < RowSize; i++) {
					ProjectCostMaster pcm = (ProjectCostMaster)hs.load(ProjectCostMaster.class, new Integer(chk[i]));
					ProjectAirFareCost pac = (ProjectAirFareCost)hs.load(ProjectAirFareCost.class, new Integer(chk[i]));

						cellNumber = 0;
						
						HRow = sheet.createRow(ExcelRow);
						
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(pcm.getFormCode());
							cell.setCellStyle(boldTextStyle);	
						
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(pcm.getProjectMaster()==null ? "" : pcm.getProjectMaster().getProjId());
							cell.setCellStyle(boldTextStyle);
							
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(pcm.getUserLogin().getName());
							cell.setCellStyle(boldTextStyle);
							
						    cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(pcm.getPayType()== null? pcm.getProjectMaster().getProjName() : pcm.getPayType());
							cell.setCellStyle(boldTextStyle);
							
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(pcm.getProjectMaster().getBillTo() == null ? "" : pcm.getProjectMaster().getBillTo().getDescription());
							cell.setCellStyle(boldTextStyle);
						
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(df.format(pcm.getCreatedate()));
							cell.setCellStyle(boldTextStyle);
							
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(pcm.getRefno());
							cell.setCellStyle(boldTextStyle);
							
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(pcm.getClaimType().equals("CN") ? "Company" : "Customer");
							cell.setCellStyle(boldTextStyle);
							
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(df.format(pcm.getCostdate()));
							cell.setCellStyle(boldTextStyle);
										
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(pcm.getApprovalDate()==null? "" : df.format(pcm.getApprovalDate()));
							cell.setCellStyle(boldTextStyle);
										
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(pcm.getTotalvalue());
							cell.setCellStyle(numberFormatStyle);
							
							cell = HRow.createCell(cellNumber++);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(pcm.getVendor()==null?"":pcm.getVendor().getDescription());
							cell.setCellStyle(boldTextStyle);
							
							pcm.setExportDate(UtilDateTime.nowTimestamp());
							ExcelRow++;
					}
					
				//	writeExportDate(sr);
				//	writeExportDate(sr);
					//写入Excel工作表
					wb.write(response.getOutputStream());
					//关闭Excel工作薄对象
					response.getOutputStream().close();
					response.setStatus( HttpServletResponse.SC_OK );
					response.flushBuffer();
//------------------------------------------					
					
	//				Transaction tx = hs.beginTransaction();
					
					
					hs.flush();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else{
				return null;
			}
		//	List result = findQueryResult(request);
		//	request.setAttribute("QryList", result);
		}
		return (mapping.findForward("success"));
	}
	
	private List findQueryResult (HttpServletRequest request) {
		Logger log = Logger.getLogger(FindCostSelfPageAction.class.getName());
		List result = new ArrayList();
	try {
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();

		String textsrc = request.getParameter("textsrc");
		String texttype = request.getParameter("texttype");
		String departmentId = request.getParameter("departmentId");
		String DateStart = request.getParameter("DateStart");
		String DateEnd = request.getParameter("DateEnd");
		String textProj = request.getParameter("textProj");
		String textUser = request.getParameter("textUser");
		String textStatus = request.getParameter("textStatus");
		String textPAConfirm = request.getParameter("textPAConfirm");
		if (textStatus==null) textStatus="";
		String textPaid = request.getParameter("textPaid");
		if (textPaid==null) textPaid="";
		if (textPAConfirm==null) textPAConfirm="";
		if (textProj==null) textProj="";
		if (textUser==null) textUser="";
		if (textsrc==null) textsrc="";
		if (texttype==null) texttype="";
		if (departmentId == null) departmentId = "";
		if (DateStart==null) DateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
		if (DateEnd==null) DateEnd=Date_formater.format(nowDate);
		
		String Type = request.getParameter("Type");
		String costType = request.getParameter("CostType");
		if (costType != null && costType.trim().length() != 0) {
			texttype = costType;
		}
		
		if (Type == null) Type = "";
		

		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		String QryStr = "select pcm from ProjectCostMaster as pcm ";
		
		if (departmentId.trim().equals("")) {
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			QryStr = QryStr + "  where (pcm.createuser ='"+ul.getUserLoginId()+"' or pcm.modifyuser ='"+ul.getUserLoginId()+"')";
		} else {
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
			QryStr = QryStr + " where pcm.projectMaster.department.partyId in ("+PartyListStr+")";
		}
		QryStr = QryStr + " and (pcm.costdate between '"+DateStart+"' and '"+DateEnd+"')";
		if(!textsrc.trim().equals("")){
			QryStr = QryStr +" and (pcm.FormCode like '%"+ textsrc.trim() +"%' )";
		}
		if(!texttype.trim().equals("")){
			QryStr = QryStr +" and (pcm.projectCostType.typeid = '"+ texttype +"')";
		} else {
			QryStr = QryStr +" and (pcm.projectCostType.typeid != 'EAF')";
		}
		if(!textProj.trim().equals("")){
			QryStr = QryStr +" and (pcm.projectMaster.projId like '%"+ textProj.trim() +"%')";
		}
		if(!textUser.trim().equals("")){
			QryStr = QryStr +" and (pcm.userLogin.userLoginId like '%"+ textUser.trim() +"%' or pcm.userLogin.name like '%"+ textUser.trim() +"%')";
		}
		if(!textStatus.trim().equals("")){
			if (textStatus.trim().equals("confirmed")){
				QryStr = QryStr +" and (pcm.payStatus = 'confirmed' )";
			}else if(textStatus.trim().equals("unconfirmed")){
				QryStr = QryStr +" and (pcm.payStatus = 'unconfirmed' )";
			}else if(textStatus.trim().equals("posted")){
				QryStr = QryStr +" and (pcm.payStatus = 'posted' )";
			}else if(textStatus.trim().equals("paid")){
				QryStr = QryStr +" and (pcm.payStatus = 'paid' )";
			}
			
		}
		if(!textPAConfirm.trim().equals("")){
			if (textPAConfirm.trim().equals("confirmed")){
				QryStr = QryStr +" and (pcm.PAConfirm is not null )";
			}else if(textPAConfirm.trim().equals("unconfirmed")){
				QryStr = QryStr +" and (pcm.PAConfirm is null )";
			}
		}
		if(!textPaid.trim().equals("")){		
				QryStr = QryStr +" and (pcm.ClaimType = '"+textPaid.trim() +"' )";
		}
		QryStr = QryStr +" and pcm.projectCostType.typeaccount='"+Type+"'";
		Query q = hs.createQuery(QryStr);
		result = q.list();


	} catch (Exception e) {
		log.error(e.getMessage());
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
	return result;
	}
	
	private final static String ExcelTemplate="AirfareCostReport.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Airfare Cost Report.xls";
	private final int ListStartRow = 4;
	private final int titleRow = 3;
}
