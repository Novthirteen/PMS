/*
 * Created on 2005-10-26
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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

import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.webapp.form.prm.report.AirfareCostRptForm;
/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AirfareCostRptAction extends ReportBaseAction {
	
	private Log log = LogFactory.getLog(AirfareCostRptAction.class);
	
	public ActionForward execute (ActionMapping mapping,
	                              ActionForm form,
								  HttpServletRequest request,
								  HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();

		AirfareCostRptForm acrForm = (AirfareCostRptForm)form;

		try {
			if(acrForm.getFormAction() != null && acrForm.getFormAction().equals("QueryForList")){
				SQLResults sr = findQueryResult(acrForm, request);
				request.setAttribute("QryList", sr);
			}
			else if(acrForm.getFormAction() != null && acrForm.getFormAction().equals("ExportToExcel")){
				return ExportToExcel(mapping, acrForm, request, response);
			}
			else if(acrForm.getFormAction() != null && acrForm.getFormAction().equals("ExportForFA")){
				return ExportForFA(mapping, acrForm, request, response);
			}
			else if(acrForm.getFormAction() != null && acrForm.getFormAction().equals("PayoutSelected")){
				SQLResults sr = findQueryResult(acrForm, request);
				writeExportDate(sr);
			}
			return (mapping.findForward("success"));
		} catch(Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
	}
	
	private SQLResults findQueryResult(AirfareCostRptForm acrForm, HttpServletRequest request) throws Exception {
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
				
		//StringBuffer statement = new StringBuffer("");	
		String sqlStr="";
		sqlStr=sqlStr+" select 	proj_cost.formcode,proj_cost.costcode as costcode,	";
		sqlStr=sqlStr+"		convert(varchar(10),proj_cost.createdate,(126)) as cre_date, ";
		sqlStr=sqlStr+" 		ul.NAME as staff, air_cost.destination, proj_cost.payment_status, ";
		sqlStr=sqlStr+" 		proj_cost.refno as fli_no, proj_cost.claimtype, curr.curr_id, curr.curr_rate, p1.party_id, custprofile.t2_code, proj_cost.payment_type,";
		sqlStr=sqlStr+" 		convert(varchar(10),proj_cost.costdate,(126)) as fli_date, ";
		sqlStr=sqlStr+"		convert(varchar(10),proj_cost.approvalDate,(126)) as confirm_date,	";
		sqlStr=sqlStr+" 		proj_cost.totalvalue as price, ";
		sqlStr=sqlStr+" 		air_cost.sameFlightPrice as c_trip_price, ";
		sqlStr=sqlStr+" 		proj.proj_id as proj_id, ";
		sqlStr=sqlStr+" 		proj.proj_name as proj_name, ";
		sqlStr=sqlStr+" 		p.DESCRIPTION as v_name, ";
		sqlStr=sqlStr+" 		proj_cost.costdescription as cost_desc, ";
		sqlStr=sqlStr+" 		convert(varchar(10),proj_cost.export_date,(126)) as ex_date ";

		sqlStr=sqlStr+" from Proj_Cost_Mstr as proj_cost ";
		sqlStr=sqlStr+" 		inner join Proj_Airfare_Cost as air_cost on air_cost.costcode=proj_cost.costcode ";
		sqlStr=sqlStr+" 		left join Proj_Mstr as proj on proj.proj_id=proj_cost.proj_id ";
		sqlStr=sqlStr+" 		inner join USER_LOGIN as ul on ul.USER_LOGIN_ID=proj_cost.user_login_id ";
		sqlStr=sqlStr+" 		inner join PARTY as p on p.PARTY_ID=proj_cost.payfor ";
		sqlStr=sqlStr+" 		inner join currency as curr on curr.curr_id = proj_cost.currency ";
		sqlStr=sqlStr+" 		inner join party as p1 on ul.party_id = p1.party_id ";
		sqlStr=sqlStr+" 		left join custprofile as custprofile on custprofile.party_id = proj.cust_id ";

		sqlStr=sqlStr+"	where	proj_cost.type='EAF'	";
		
		if(acrForm.getDate_begin() != null && acrForm.getDate_begin().trim().length() != 0){
			sqlStr=sqlStr+"		and convert(varchar(10),air_cost.bookDate,(126))>=?	";
			sqlExec.addParam(acrForm.getDate_begin());			
		}
		
		if(acrForm.getDate_end() != null && acrForm.getDate_end().trim().length() != 0){
			sqlStr=sqlStr+" and convert(varchar(10),air_cost.bookDate,(126))<=?	";
			sqlExec.addParam(acrForm.getDate_end());
		}
		
		if(acrForm.getStatus() != null & acrForm.getStatus().trim().length() != 0){
			if(acrForm.getStatus().equals("confirmed"))
				sqlStr=sqlStr+"		and proj_cost.payment_status ='confirmed'	";
			if(acrForm.getStatus().equals("unconfirmed"))
				sqlStr=sqlStr+"		and proj_cost.payment_status ='unconfirmed'	";
			if(acrForm.getStatus().equals("paid"))
				sqlStr=sqlStr+"		and proj_cost.payment_status ='paid'	";
			if(acrForm.getStatus().equals("posted"))
				sqlStr=sqlStr+"		and proj_cost.payment_status ='posted'	";
		}		
		
		if(acrForm.getProject() != null && acrForm.getProject().trim().length() != 0){
			sqlStr=sqlStr+"  and (proj.proj_id like ? or proj.proj_name like ?)	"; 
			sqlExec.addParam("%"+acrForm.getProject()+"%");
			sqlExec.addParam("%"+acrForm.getProject()+"%");
		}
		if(acrForm.getTCode() != null && acrForm.getTCode().trim().length() != 0){
			sqlStr=sqlStr+"  and (proj_cost.formcode like ? )	"; 
			sqlExec.addParam("%"+acrForm.getTCode()+"%");
		}
		
		if(acrForm.getStaff() != null && acrForm.getStaff().trim().length() != 0){
			sqlStr=sqlStr+"	and (ul.USER_LOGIN_ID like ? or ul.NAME like ?)	";
			sqlExec.addParam("%"+acrForm.getStaff()+"%");
			sqlExec.addParam("%"+acrForm.getStaff()+"%");
		}
		
		if(acrForm.getLast_export() != null && acrForm.getLast_export().trim().length() != 0){
			sqlStr=sqlStr+"	and convert(varchar(10),proj_cost.export_date,(126))=?	";
			sqlExec.addParam(acrForm.getLast_export());
		}
		
		if(acrForm.getFli_no() != null && acrForm.getFli_no().trim().length() != 0){
			sqlStr=sqlStr+"	and proj_cost.refno like ?	";
			sqlExec.addParam("%"+acrForm.getFli_no()+"%");
		}
		
		if(acrForm.getVendor() != null && acrForm.getVendor().trim().length() != 0){
			sqlStr=sqlStr+"	and p.PARTY_ID=?	";
			sqlExec.addParam(acrForm.getVendor());
		}

		if(acrForm.getFlag_export() != null && acrForm.getFlag_export().equals("Y")){
			sqlStr=sqlStr+"	and proj_cost.export_date is not null	";
			//sqlExec.addParam(acrForm.getVendor());
		}else{
			sqlStr=sqlStr+"	and proj_cost.export_date is null	";
		}

		
		String[] chk = request.getParameterValues("chk");
		if (chk != null) {
			int RowSize = java.lang.reflect.Array.getLength(chk);
			String costcodeListStr = "";
			for (int i = 0; i < RowSize; i++) {
				costcodeListStr = costcodeListStr + chk[i] +",";
			}
			costcodeListStr = costcodeListStr.substring(0,costcodeListStr.length()-1);
			sqlStr=sqlStr+"	and proj_cost.costcode in ("+costcodeListStr+")";
		}
		log.info(sqlStr);		
		SQLResults sr = sqlExec.runQueryCloseCon(sqlStr);
		return sr;
	}
	
	private ActionForward ExportToExcel (ActionMapping mapping, AirfareCostRptForm acrForm, HttpServletRequest request, HttpServletResponse response ){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			
			String flag_ctrip = request.getParameter("flag_ctrip");
			String flag_desc = request.getParameter("flag_desc");
			if(flag_ctrip == null)	flag_ctrip = "";
			if(flag_desc == null)	flag_desc = "";
			
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sr = findQueryResult(acrForm, request);
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
			String newPid = "";
			String oldPid = "";
			Object resultSet_data = null;
			
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
			cell.setCellValue("Create Date");
			cell.setCellStyle(boldTextStyle);
			
			cell = HRow.createCell(cellNumber++);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue("Flight No.");
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
			
			if(flag_ctrip.equals("Y")){
				cell = HRow.createCell(cellNumber++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue("C-trip Price");
				cell.setCellStyle(boldTextStyle);
			}
			
			cell = HRow.createCell(cellNumber++);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue("Vendor");
			cell.setCellStyle(boldTextStyle);
			
			if(flag_desc.equals("Y")){
				cell = HRow.createCell(cellNumber++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue("Description");
				cell.setCellStyle(boldTextStyle);
			}
			
		//	cell = HRow.createCell(cellNumber++);
		//	cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
		//	cell.setCellValue("Last Export Date");
		//	cell.setCellStyle(boldTextStyle);
			
			//write contents
			for (int row =0; row < sr.getRowCount(); row++) {
			
				newPid = sr.getString(row, "proj_id");
				cellNumber = 0;
				
				HRow = sheet.createRow(ExcelRow);
				
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"formcode"));
					cell.setCellStyle(boldTextStyle);	
				
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"proj_id")==null ? "" : sr.getString(row,"proj_id"));
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"staff")==null ? "" : sr.getString(row,"staff"));
					cell.setCellStyle(boldTextStyle);
					
				    cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue((sr.getString(row,"payment_type") == null) ? sr.getString(row,"proj_name") : sr.getString(row,"payment_type"));
					cell.setCellStyle(boldTextStyle);
				
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"cre_date"));
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"fli_no"));
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"fli_date"));
					cell.setCellStyle(boldTextStyle);
								
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"confirm_date"));
					cell.setCellStyle(boldTextStyle);
								
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getDouble(row,"price"));
					cell.setCellStyle(numberFormatStyle);
					
					if(flag_ctrip.equals("Y")){
						cell = HRow.createCell(cellNumber++);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(sr.getDouble(row,"c_trip_price"));
						cell.setCellStyle(numberFormatStyle);
					}
					
					cell = HRow.createCell(cellNumber++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"v_name"));
					cell.setCellStyle(boldTextStyle);
					
					if(flag_desc.equals("Y")){
						cell = HRow.createCell(cellNumber++);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						cell.setCellValue(sr.getString(row,"cost_desc"));
						cell.setCellStyle(boldTextStyle);
					}
					
	//				cell = HRow.createCell(cellNumber++);
	//				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
	//				cell.setCellValue(sr.getString(row,"ex_date"));
	//				cell.setCellStyle(boldTextStyle);					
				
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	//export for FA ---------------------------
	private ActionForward ExportForFA (ActionMapping mapping, AirfareCostRptForm acrForm, HttpServletRequest request, HttpServletResponse response ){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
		
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sr = findQueryResult(acrForm, request);
			if (sr== null || sr.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ FileNameForFA + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+FATemplate));
			
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			//Header
			HSSFCell cell = null;
			HSSFRow HRow = null;
			HSSFRow HRow2 = null;
			//cell styple
			HSSFCellStyle NumStyle = sheet.getRow(0).getCell((short)2).getCellStyle();
			HSSFCellStyle RateStyle = sheet.getRow(0).getCell((short)3).getCellStyle();
			
			HSSFCellStyle YTextStyle = sheet.getRow(4).getCell((short)0).getCellStyle();
			HSSFCellStyle NumStyle2 = sheet.getRow(4).getCell((short)3).getCellStyle();
			//HSSFCellStyle YDateStyle = sheet.getRow(4).getCell((short)4).getCellStyle();
			HSSFCellStyle YRateStyle = sheet.getRow(4).getCell((short)4).getCellStyle();
			
			
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
			DateFormat dfy = new SimpleDateFormat("yyyy", Locale.ENGLISH);
			DateFormat dfm = new SimpleDateFormat("MM", Locale.ENGLISH);
			
			int ExcelRow1 = ListStartRow;
			
			for (int row =0; row < sr.getRowCount(); row++) {
				HRow = sheet.createRow(ExcelRow1);
				
			// ----- Account code
				if(sr.getString(row, "claimtype")!= null && sr.getString(row, "claimtype").equals("CN")){
					cell = HRow.createCell((short)0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("51316251");
				}
				if(sr.getString(row, "claimtype")!= null && sr.getString(row, "claimtype").equals("CY")){
					cell = HRow.createCell((short)0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("11914480O");
				}
			//----- period
				cell = HRow.createCell((short)1);			//Period
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(dfy.format(new Date())+"0"+dfm.format(new Date()));
            //----- Transaction Date
				cell = HRow.createCell((short)2);			//Transaction Date
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(df.format(new Date()));
            //----- Base Amount
				cell = HRow.createCell((short)3);			//Base Amount
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getDouble(row,"price"));
				cell.setCellStyle(NumStyle);
				 //----- Other Amount
				cell = HRow.createCell((short)4);			//Other Amount
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getDouble(row,"price")*sr.getDouble(row,"curr_rate"));
				cell.setCellStyle(NumStyle);
				 //----- Conversion Code
				cell = HRow.createCell((short)5);			//Conversion Code
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"curr_id").toUpperCase());
//				----- Conversion Rate
				cell = HRow.createCell((short)6);			//Conversion Rate
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getDouble(row,"curr_rate"));
				cell.setCellStyle(RateStyle);
				// leave blank for transaction reference
//				----- Description
				cell = HRow.createCell((short)8);			//Description
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				String destiniation = sr.getString(row,"destination")==null ? "" : sr.getString(row,"destination");
				cell.setCellValue(sr.getString(row,"staff").toUpperCase()+":"+destiniation );
//				----- T1
				cell = HRow.createCell((short)9);			//T1
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				if (sr.getString(row,"party_id").equals("005")){
					cell.setCellValue("AS-GW");
				}
				if (sr.getString(row,"party_id").equals("006") || sr.getString(row,"party_id").equals("014") ){
					cell.setCellValue("OES-QAD1");
				}
				if (sr.getString(row,"party_id").equals("007")){
					cell.setCellValue("OES-SAP");
				}
				if (sr.getString(row,"party_id").equals("010") || sr.getString(row,"party_id").equals("21")){
					cell.setCellValue("MS-INF+SI");
				}
				if (sr.getString(row,"party_id").equals("018") || sr.getString(row,"party_id").equals("20")){
					cell.setCellValue("MS-NOPHDT");
				}
				if (sr.getString(row,"party_id").equals("019")){
					cell.setCellValue("MS-EOC");
				}
				if (sr.getString(row,"party_id").equals("22")){
					cell.setCellValue("MS-PHDT");
				}
//				----- T2
				cell = HRow.createCell((short)10);			//T2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				if (sr.getString(row, "t2_code")!=null){
					cell.setCellValue(sr.getString(row, "t2_code"));
				}else{
					cell.setCellValue("GEN");
				}
//				----- T3
				cell = HRow.createCell((short)11);			//T3
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				if (sr.getString(row, "proj_id")!=null){
					cell.setCellValue(sr.getString(row, "proj_id"));
				}
				ExcelRow1++;
				HRow2 = sheet.createRow(ExcelRow1);
//				----- Account code 2
				cell = HRow2.createCell((short)0);			//Account code 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue("1111510033");
				cell.setCellStyle(YTextStyle);
//				----- period 2
				cell = HRow2.createCell((short)1);			//Period 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(dfy.format(new Date())+"0"+dfm.format(new Date()));
				cell.setCellStyle(YTextStyle);
				 //----- Transaction Date 2
				cell = HRow2.createCell((short)2);			//Transaction Date 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(df.format(new Date()));
				cell.setCellStyle(YTextStyle);
				 //----- Base Amount 2
				cell = HRow2.createCell((short)3);			//Base Amount 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(0-sr.getDouble(row,"price"));
				cell.setCellStyle(NumStyle2);
				 //----- Other Amount 2
				cell = HRow2.createCell((short)4);			//Other Amount 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(0-sr.getDouble(row,"price")*sr.getDouble(row,"curr_rate"));
				cell.setCellStyle(NumStyle2);
				 //----- Conversion Code 2
				cell = HRow2.createCell((short)5);			//Conversion Code 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"curr_id").toUpperCase());
				cell.setCellStyle(YTextStyle);
//				----- Conversion Rate 2
				cell = HRow2.createCell((short)6);			//Conversion Rate 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getDouble(row,"curr_rate"));
				cell.setCellStyle(YRateStyle);
				// leave blank for transaction reference 2
				cell = HRow2.createCell((short)7);			//Conversion Rate 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				//cell.setCellValue(sr.getDouble(row,"curr_rate"));
				cell.setCellStyle(YTextStyle);
//				----- Description 2
				cell = HRow2.createCell((short)8);			//Description 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"staff").toUpperCase()+":"+destiniation);
				cell.setCellStyle(YTextStyle);
//				----- T1 2
				cell = HRow2.createCell((short)9);			//T1 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				if (sr.getString(row,"party_id").equals("005")){
					cell.setCellValue("AS-GW");
				}
				if (sr.getString(row,"party_id").equals("006")){
					cell.setCellValue("OES-QAD1");
				}
				if (sr.getString(row,"party_id").equals("007")){
					cell.setCellValue("OES-SAP");
				}
				if (sr.getString(row,"party_id").equals("010") || sr.getString(row,"party_id").equals("21")){
					cell.setCellValue("MS-INF+SI");
				}
				if (sr.getString(row,"party_id").equals("018") || sr.getString(row,"party_id").equals("20")){
					cell.setCellValue("MS-NOPHDT");
				}
				if (sr.getString(row,"party_id").equals("019")){
					cell.setCellValue("MS-EOC");
				}
				if (sr.getString(row,"party_id").equals("22")){
					cell.setCellValue("MS-PHDT");
				} 
				cell.setCellStyle(YTextStyle);
//				----- T2 2
				cell = HRow2.createCell((short)10);			//T2 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				if (sr.getString(row, "t2_code")!=null){
					cell.setCellValue(sr.getString(row, "t2_code"));
				}else{
					cell.setCellValue("GEN");
				}
				cell.setCellStyle(YTextStyle);
//				----- T3 2
				cell = HRow2.createCell((short)11);			//T3 2
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				if (sr.getString(row, "proj_id")!=null){
					cell.setCellValue(sr.getString(row, "proj_id"));
				}
				cell.setCellStyle(YTextStyle);
//				----- T4 
				cell = HRow2.createCell((short)12);			//T4
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue("A17");	
				cell.setCellStyle(YTextStyle);
				
				ExcelRow1++;
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
	//------------------------------
	
	public void writeExportDate(SQLResults sr){
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		
		StringBuffer statement = new StringBuffer("");		
		statement.append(" update Proj_Cost_Mstr ");
		statement.append(" set payment_status='paid', pay_date ='"+dateFormat.format(new Date())+"' ");
		statement.append(" where ");
		for(int row=0; row<sr.getRowCount(); row++){
			if(row==0){
				statement.append(" costcode="+String.valueOf(sr.getInt(row, "costcode"))+"	");
			}
			else{
				statement.append(" or costcode="+String.valueOf(sr.getInt(row, "costcode"))+"	");
			}
		}
		
		sqlExec.runQueryCloseCon(statement.toString());
	}
	
	private final static String ExcelTemplate="AirfareCostReport.xls";
	private final static String FATemplate="AirfareExpense.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Airfare Cost Report.xls";
	private final static String FileNameForFA="Airfare Expense.xls";
	private final int ListStartRow = 4;
	private final int titleRow = 3;
}
