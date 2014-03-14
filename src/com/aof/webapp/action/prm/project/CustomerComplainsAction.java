/*
 * Created on 2005-6-21
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.webapp.action.prm.project;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.report.ReportBaseAction;
import com.aof.component.domain.party.*;
import com.aof.component.prm.contract.ContractProfile;
/**
 * @author Chen Yu
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class CustomerComplainsAction extends ReportBaseAction {
	public ActionForward perform(ActionMapping mapping,
			                     ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		Logger log = Logger.getLogger(CustomerComplainsAction.class.getName());	

		try{
			String formAction = request.getParameter("formAction");
			String textdep = request.getParameter("textdep");
			String textCreateDateFrom = request.getParameter("textCreateDateFrom");
			String textCreateDateTo = request.getParameter("textCreateDateTo");
			String PM=request.getParameter("PM");
			//String ProjName=request.getParameter("ProjName");
			String ProjCode=request.getParameter("ProjCode");
			String type=request.getParameter("type");
			String solved=request.getParameter("solved");
			
			UserLogin userlogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			request.setAttribute("userlogin",userlogin);
			
			
			if (formAction == null ||formAction=="") formAction ="view";
			if (textdep == null) textdep ="";
			if (textCreateDateFrom == null) textCreateDateFrom ="";
			if (textCreateDateTo == null) textCreateDateTo ="";
			if (PM == null) PM ="";
			if (ProjCode == null) ProjCode ="";
			if (type == null) type ="";
			if (solved == null) solved ="";
			
			Session session = Hibernate2Session.currentSession();

			PartyHelper ph = new PartyHelper();
			List partyList_dep=ph.getAllSubPartysByPartyId(session,userlogin.getParty().getPartyId());
			if (partyList_dep == null) partyList_dep = new ArrayList();
			partyList_dep.add(0,userlogin.getParty());
			request.setAttribute("PartyList", partyList_dep);
			String PartyListStr = "''";
			if (!textdep.trim().equals("")) {
					//List partyList_dep=ph.getAllSubPartysByPartyId(session,textdep);
					Iterator itdep = partyList_dep.iterator();
					PartyListStr = "'"+textdep+"'";
					while (itdep.hasNext()) {
							Party p =(Party)itdep.next();
							PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
							}
			}
			if(formAction.equals("query")){
			String  QryStr = " select cc from CustComplain as cc " ;
			String whereStr = "";
			
			 if (!textdep.trim().equals("")) {
				whereStr = whereStr +" where cc.Dep_ID in (" + PartyListStr +")";
			   }
			 if(!PM.trim().equals("")){
				 whereStr=whereStr+" and cc.PM_ID='"+PM+"'";
				 } 
			 if(!ProjCode.trim().equals("")){
				 whereStr=whereStr+" and cc.project='"+ProjCode+"'";
				 } 
			 if(!type.trim().equals("")){
				 whereStr=whereStr+" and cc.Type='"+type+"'";
				 } 
			 if(!solved.trim().equals("")){
				 whereStr=whereStr+" and cc.Solved='"+solved+"'";
				 } 
		
			
			if (textCreateDateFrom != null && textCreateDateFrom.trim().length() != 0) {
				if (!whereStr.equals("")) { 
					whereStr += "  and cc.Create_Date > '" + textCreateDateFrom + "' ";
				} else {
					whereStr = " where cc.Create_Date > '" + textCreateDateFrom + "' ";
				}
			}
			
			if (textCreateDateTo != null && textCreateDateTo.trim().length() != 0) {
				if (!whereStr.equals("")) { 
					whereStr += "  and cc.Create_Date < '" + textCreateDateTo + "' ";
				} else {
					whereStr = " where cc.Create_Date < '" + textCreateDateTo + "' ";
				}
			}
			whereStr=whereStr+"  order by cc.project";
			QryStr=QryStr+whereStr;
			System.out.println("\n"+QryStr+"\n");
					
			Query query = session.createQuery(QryStr);
			List result = query.list();
			
			request.setAttribute("QryList",result);
			return (mapping.findForward("success"));
			}
			
			if (formAction != null && formAction.equals("view")) {
				return (mapping.findForward("success"));
			}
		
		}catch(Exception e){
			log.error(e.getMessage());
			e.printStackTrace();
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
			HSSFCellStyle normalDateStyle = sheet.getRow(ListStartRow).getCell((short)3).getCellStyle();
			
			HSSFRow HRow = null;
			HSSFCell cell = null;
			
			int ExcelRow = ListStartRow;
			
			String newCustomer = "";
			
			for (int row = 0; result != null && row < result.size(); row++) {
				ContractProfile cp = (ContractProfile)result.get(row);
				newCustomer = cp.getCustomer().getDescription();
				String accountManager = "";
				if(cp.getAccountManager()!=null){
					accountManager = cp.getAccountManager().getName();
				}
				
				HRow = sheet.createRow(ExcelRow);

				cell = HRow.createCell((short)0); //customer
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				
				cell.setCellValue(newCustomer);
				
				cell.setCellStyle(boldTextStyle);	
				
				cell = HRow.createCell((short)1); //Contract No.
				cell.setCellValue(cp.getNo());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)2); //Account Manager
				cell.setCellValue(accountManager);
				cell.setCellStyle(normalTextStyle);
				
				cell = HRow.createCell((short)3); //TCV
				cell.setCellValue(cp.getTotalContractValue() != null ? numFormater.format(cp.getTotalContractValue().doubleValue()) + "" : "");
				cell.setCellStyle(normalNumberStyle);	
				
				cell = HRow.createCell((short)4); //Sign Date
				cell.setCellValue(cp.getSignedDate() != null ? dateFormater.format(cp.getSignedDate()) : "");
				cell.setCellStyle(normalDateStyle);	
				
				cell = HRow.createCell((short)5); //Create Date
				cell.setCellValue(cp.getCreateDate() != null ? dateFormater.format(cp.getCreateDate()) : "");
				cell.setCellStyle(normalDateStyle);	
				
				cell = HRow.createCell((short)6); //Legal Review Date
				cell.setCellValue(cp.getLegalReviewDate() != null ? dateFormater.format(cp.getLegalReviewDate()) : "");
				cell.setCellStyle(normalDateStyle);	
				
				cell = HRow.createCell((short)7); //customer sat
				cell.setCellValue(cp.getCustomerSat() != null ? cp.getCustomerSat() : "");
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)8); //start date
				cell.setCellValue(cp.getStartDate() != null ? dateFormater.format(cp.getStartDate()) : "");
				cell.setCellStyle(normalDateStyle);	
				
				cell = HRow.createCell((short)9); //end date
				cell.setCellValue(cp.getEndDate() != null ? dateFormater.format(cp.getEndDate()) : "");
				cell.setCellStyle(normalDateStyle);	
				
				cell = HRow.createCell((short)10); //close status
				cell.setCellValue(cp.getStatus());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)11); //contract type
				cell.setCellValue(cp.getContractType());
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
	
	private final static String ExcelTemplate="ContractProfileRpt.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Contract Profile Report.xls";
	private final int ListStartRow = 5;
}
