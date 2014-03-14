/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.project;


import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

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
import com.aof.component.prm.contract.ContractProfile;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.report.ReportBaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *
 */
public class ListContractProjectAction extends ReportBaseAction{
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
				// Extract attributes we will need
				Logger log = Logger.getLogger(ListCustProjectAction.class.getName());
				Locale locale = getLocale(request);
				MessageResources messages = getResources();		

				try{
					List result = new ArrayList();
					net.sf.hibernate.Session session = Hibernate2Session.currentSession();
					PartyHelper ph = new PartyHelper();
					UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
					//List partyList_dep=ph.getAllSubPartysByPartyId(session,ul.getParty().getPartyId());
					//Iterator itdep = partyList_dep.iterator();
					//String PartyListStr = "'"+ul.getParty().getPartyId()+"'";
					//while (itdep.hasNext()) {
						//Party p =(Party)itdep.next();
						//PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
					//}
					String formAction = request.getParameter("formAction");
					String textcode = request.getParameter("textcode");
					String textdesc = request.getParameter("textdesc");
					String texttype = request.getParameter("texttype");
					String textstatus = request.getParameter("textstatus");
					String textcust = request.getParameter("textcust");
					String textcno = request.getParameter("textcno");
					String textdep = request.getParameter("textdep");
					if (textcode == null) textcode ="";
					if (textdesc == null) textdesc ="";
					if (texttype == null) texttype ="";
					if (textstatus == null) textstatus ="";
					if (textcust == null) textcust ="";
					if (textcno == null) textcno ="";
					if (textdep == null) textdep ="";
					
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
					
					String QryStr = "select p from ProjectMaster as p inner join p.projectType as pt ";
					QryStr = QryStr +"                                inner join p.customer as c";
					QryStr = QryStr +"                                inner join p.projectCategory as pc";
					
					if (!textdep.trim().equals("")) {
						QryStr = QryStr +" inner join p.department as dep";
						QryStr = QryStr +" where dep.partyId in (" + PartyListStr +")";
					} else {
						QryStr = QryStr + " inner join p.ProjectManager as pm";
						QryStr = QryStr +" where pm.userLoginId = '" + ul.getUserLoginId() + "'";
					}
					QryStr = QryStr + " and p.ContractNo like '%"+textcno+"%'";
					QryStr = QryStr + " and pc.Id = 'C'";
					QryStr = QryStr +" and ((p.projId like '%"+ textcode +"%') and (p.projName like '%"+ textdesc +"%')";
					if(!textstatus.equals("")){
						QryStr = QryStr +" and (p.projStatus like '%"+ textstatus +"%')";
					}
					QryStr = QryStr +" and ((c.partyId like '%"+ textcust +"%') or (c.description like '%"+ textcust +"%'))";
					QryStr = QryStr +" and (pt.ptId like '%"+ texttype +"%'))";
					
					Query q = session.createQuery(QryStr);
					//q.setMaxResults(20);
					result = q.list();
					
					if ("exportExcel".equals(formAction)) {
						return ExportToExcel(result, response);
					}
							
					request.setAttribute("QryList",result);
					
				}catch(Exception e){
					log.error(e.getMessage());
				}finally{
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
	private ActionForward ExportToExcel(List result, HttpServletResponse response) {
		try {
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
			NumberFormat numFormater = NumberFormat.getInstance();
			numFormater.setMaximumFractionDigits(2);
			numFormater.setMinimumFractionDigits(2);
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			
			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle normalTextStyle = sheet.getRow(ListStartRow).getCell((short)1).getCellStyle();
			HSSFCellStyle normalNumberStyle = sheet.getRow(ListStartRow).getCell((short)2).getCellStyle();
			HSSFCellStyle normalDateStyle = sheet.getRow(ListStartRow).getCell((short)8).getCellStyle();
			
			HSSFRow HRow = null;
			HSSFCell cell = null;
			
			int ExcelRow = ListStartRow;
			
			String newCustomer = "";
			
			for (int row = 0; result != null && row < result.size(); row++) {
				ProjectMaster custProject = (ProjectMaster)result.get(row);
				//newCustomer = custProject.getCustomer().getDescription();
							
				HRow = sheet.createRow(ExcelRow);

				cell = HRow.createCell((short)0); //project code
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(custProject.getProjId());
				cell.setCellStyle(boldTextStyle);	
				
				cell = HRow.createCell((short)1); //project name
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getProjName() != null ? custProject.getProjName() : "");
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)2); //contract number
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getContractNo());
				cell.setCellStyle(normalTextStyle);
				
				cell = HRow.createCell((short)3); //customer
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getCustomer().getDescription());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)4); //tcv
				cell.setCellValue(custProject.gettotalServiceValue() == null ? "" : numFormater.format(custProject.gettotalServiceValue()));
				cell.setCellStyle(normalNumberStyle);	
				
				cell = HRow.createCell((short)5); //dep.
				cell.setCellValue(custProject.getDepartment().getDescription());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)6); //contract type
				cell.setCellValue(custProject.getContractType());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)7); //parent proj
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getParentProject()==null?"":custProject.getParentProject().getProjId()+" : "+custProject.getParentProject().getProjName());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)8); //start date
				cell.setCellValue(custProject.getStartDate());
				cell.setCellStyle(normalDateStyle);	
				
				cell = HRow.createCell((short)9); //end date
				cell.setCellValue(custProject.getEndDate());
				cell.setCellStyle(normalDateStyle);	
				
				cell = HRow.createCell((short)10); //customer paid allowance
				cell.setCellValue(numFormater.format(custProject.getPaidAllowance()));
				cell.setCellStyle(normalNumberStyle);	
				
				cell = HRow.createCell((short)11); //PM
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getProjectManager().getUserLoginId()+":"+custProject.getProjectManager().getName());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)12); //PA
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getProjAssistant()==null ? "" : custProject.getProjAssistant().getUserLoginId()+":"+custProject.getProjAssistant().getName());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)13); //bill to
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getBillTo().getDescription());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)14); //contact person
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getContact()==null ? "" : custProject.getContact());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)15); //contact person tele
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getContactTele()==null ? "" : custProject.getContactTele());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)16); //customer pm
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getCustPM()==null ? "" : custProject.getCustPM());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)17); //customer pm tele
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(custProject.getCustPMTele()==null ? "" : custProject.getCustPMTele());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)18); //need caf
				cell.setCellValue(custProject.getCAFFlag());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)19); //need renew
				cell.setCellValue(custProject.getRenewFlag());
				cell.setCellStyle(normalTextStyle);	
				
	
				
				ExcelRow++;
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
	
	private final static String ExcelTemplate="ProjectProfileRpt.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Project Profile Report.xls";
	private final int ListStartRow = 5;
}
