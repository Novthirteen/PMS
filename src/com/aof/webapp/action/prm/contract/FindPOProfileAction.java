/*
 * Created on 2005-6-21
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.webapp.action.prm.contract;

import java.io.FileInputStream;
import java.sql.SQLException;
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
import com.aof.component.prm.contract.POProfile;
/**
 * @author CN01512
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class FindPOProfileAction extends ReportBaseAction {
	public ActionForward perform(ActionMapping mapping,
			                     ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		Logger log = Logger.getLogger(FindContractProfileAction.class.getName());	

		try{
			String formAction = request.getParameter("formAction");
			String textContract = request.getParameter("textContract");
			String textContractType = request.getParameter("textContractType");
			String textVendor = request.getParameter("textVendor");
			String textStatus = request.getParameter("textStatus");
			String textHasProject = request.getParameter("textHasProject");
			String textdep = request.getParameter("textdep");
			String textSignDateFrom = request.getParameter("textSignDateFrom");
			String textSignDateTo = request.getParameter("textSignDateTo");
			String textCreateDateFrom = request.getParameter("textCreateDateFrom");
			String textCreateDateTo = request.getParameter("textCreateDateTo");
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			if (textdep == null) textdep =ul.getParty().getPartyId();
			
			Session session = Hibernate2Session.currentSession();
			
			PartyHelper ph = new PartyHelper();
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
			
			List params = new ArrayList();
			String  QryStr = " select cp from POProfile as cp " +
					         "          inner join cp.vendor as c " +
			                  " inner join cp.department as dep";
			
			String whereStr = "";
			
			if (!textdep.trim().equals("")) {
				whereStr = " where dep.partyId in (" + PartyListStr +")";
			}
			
			if (textContract != null && textContract.trim().length() != 0) {	
					if(!whereStr.equals("")){
						whereStr =whereStr + "  and ((cp.no like '%" + textContract + "%') or (cp.description like '%" + textContract + "%') )";
					}else{
						whereStr = "  where ((cp.no like '%" + textContract + "%') or (cp.description like '%" + textContract + "%') )";
					}
				
				//params.add("'%" + textContract + "%'");
				//params.add("'%" + textContract + "%'");
			}
			
			if (textContractType != null && textContractType.trim().length() != 0) {
				if (!whereStr.equals("") ) { 
					whereStr += "  and cp.contractType = '" +  textContractType + "' ";
				} else {
					whereStr = "  where cp.contractType = '" +  textContractType + "' ";
				}
				
				//params.add(textContractType);
			}
			
			if (textVendor != null && textVendor.trim().length() != 0) {
				if (!whereStr.equals("") ) { 
					whereStr += "  and ((c.partyId like '%" + textVendor + "%' )or ( c.description like '%" + textVendor + "%') )";
				} else {
					whereStr = "  where ((c.partyId like '%" + textVendor + "%') or (c.description like '%" + textVendor + "%') )";
				}
				
				//params.add("'%" + textCustomer + "%'");
				//params.add("'%" + textCustomer + "%'");
			}
			
			if (textStatus != null && textStatus.trim().length() != 0) {
				if (!whereStr.equals("")) { 
					whereStr += "  and cp.status = '" + textStatus + "' ";
				} else {
					whereStr = " where cp.status = '" + textStatus + "' ";
				}
			} else {
				if (formAction != null && formAction.equals("dialogView")) {
					if (!whereStr.equals("")) { 
						whereStr += "  and cp.status <> 'Cancel' ";
					} else {
						whereStr = " where cp.status <> 'Cancel' ";
					}
				}
			}
			
			if (formAction != null && formAction.equals("dialogView")) {
				if (textHasProject == null || textHasProject.trim().length() == 0) {
					if (!whereStr.equals("")) { 
						whereStr += "  and size(cp.projects) = 0 ";
					} else {
						whereStr = "  where size(cp.projects) = 0 ";
					}
				}
			}
			
			if (textSignDateFrom != null && textSignDateFrom.trim().length() != 0) {
				if (!whereStr.equals("")) { 
					whereStr += "  and cp.signedDate > '" + textSignDateFrom + "' ";
				} else {
					whereStr = " where cp.signedDate > '" + textSignDateFrom + "' ";
				}
			}
			
			if (textSignDateTo != null && textSignDateTo.trim().length() != 0) {
				if (!whereStr.equals("")) { 
					whereStr += "  and cp.signedDate < '" + textSignDateTo + "' ";
				} else {
					whereStr = " where cp.signedDate < '" + textSignDateTo + "' ";
				}
			}
			
			if (textCreateDateFrom != null && textCreateDateFrom.trim().length() != 0) {
				if (!whereStr.equals("")) { 
					whereStr += "  and cp.createDate > '" + textCreateDateFrom + "' ";
				} else {
					whereStr = " where cp.createDate > '" + textCreateDateFrom + "' ";
				}
			}
			
			if (textCreateDateTo != null && textCreateDateTo.trim().length() != 0) {
				if (!whereStr.equals("")) { 
					whereStr += "  and cp.createDate < '" + textCreateDateTo + "' ";
				} else {
					whereStr = " where cp.createDate < '" + textCreateDateTo + "' ";
				}
			}
			
			if (formAction != null && formAction.equals("dialogView")) {
				if (!whereStr.equals("")) { 
						whereStr += "  and size(cp.linkProfile.projects) <> 0 ";
				} else {
						whereStr = "  where size(cp.linkProfile.projects) <> 0 ";
				}
			}
			
			if (!whereStr.equals("")) {
				QryStr = QryStr + whereStr + " order by c.description, cp.no ";
			} else {
				QryStr = QryStr + " order by c.description, cp.no ";
			}
						
			Query query = session.createQuery(QryStr);
			
			//for (int i0 = 0; i0 < params.size(); i0++) {
				//query.setString(i0, (String)params.get(i0));
			//}
			
			List result = query.list();
			
			if ("exportExcel".equals(formAction)) {
				return ExportToExcel(result, response);
			}
			
			request.setAttribute("QryList",result);
			
			List partyList = null;
			
			partyList = ph.getAllSubPartysByPartyId(session,ul.getParty().getPartyId());
			if (partyList == null) partyList = new ArrayList();
			partyList.add(0, ul.getParty());
			
			request.setAttribute("PartyList", partyList);
			
			if (formAction != null && formAction.equals("dialogView")) {
				return (mapping.findForward("dialogView"));
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
			
			String newVender = "";
			
			for (int row = 0; result != null && row < result.size(); row++) {
				POProfile pp = (POProfile)result.get(row);
				newVender = pp.getVendor().getDescription();
				
				String accountManager = "";
				if(pp.getAccountManager()!=null){
					accountManager = pp.getAccountManager().getName();
				}
								
				HRow = sheet.createRow(ExcelRow);

				cell = HRow.createCell((short)0); //vender
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				
				cell.setCellValue(newVender);
				
				cell.setCellStyle(boldTextStyle);	
				
				cell = HRow.createCell((short)1); //Contract No.
				cell.setCellValue(pp.getNo());
				cell.setCellStyle(normalTextStyle);	
				
				cell = HRow.createCell((short)2); //Account Manager
				cell.setCellValue(accountManager);
				cell.setCellStyle(normalTextStyle);
								
				cell = HRow.createCell((short)3); //TCV
				cell.setCellValue(pp.getTotalContractValue() != null ? pp.getTotalContractValue().doubleValue() + "" : "");
				cell.setCellStyle(normalNumberStyle);	
				
				cell = HRow.createCell((short)4); //Sign Date
				cell.setCellValue(pp.getSignedDate() != null ? dateFormater.format(pp.getSignedDate()) : "");
				cell.setCellStyle(normalDateStyle);	
				
				cell = HRow.createCell((short)5); //Create Date
				cell.setCellValue(pp.getCreateDate() != null ? dateFormater.format(pp.getCreateDate()) : "");
				cell.setCellStyle(normalDateStyle);	
				
				cell = HRow.createCell((short)6); //Legal Review Date
				cell.setCellValue(pp.getLegalReviewDate() != null ? dateFormater.format(pp.getLegalReviewDate()) : "");
				cell.setCellStyle(normalDateStyle);	
				
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
	
	private final static String ExcelTemplate="PORpt.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Purchase Order  Report.xls";
	private final int ListStartRow = 5;
}
