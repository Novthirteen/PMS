/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
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
* @author angus 
*
*/
public class ActualVSBudgetMDRptAction extends ReportBaseAction {
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
			String projType = request.getParameter("projType");
			String departmentId = request.getParameter("departmentId");
			String textcode = request.getParameter("textcode");
			String textpm = request.getParameter("textpm");
			String textcust = request.getParameter("textcust");
			String texttype = request.getParameter("texttype");
			boolean flag = false;
			if (request.getParameter("flag") != null) flag = true;
			if (texttype == null) texttype = "";
			if (projType == null) projType = "";
			if (departmentId == null) departmentId = "";
			if (textcode == null) textcode = "";
			if (textpm == null) textpm = "";
			if (textcust == null) textcust = "";
			if (action == null) action = "view";
			if (action.equals("QueryForList")) {
				SQLResults sr = findQueryResult(request,projType,departmentId, textcode, textpm,textcust, texttype, flag);
				request.setAttribute("QryList",sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response,projType,departmentId, textcode, textpm,textcust, texttype, flag);
			}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private SQLResults findQueryResult(HttpServletRequest request,String projType,String departmentId, String textcode, String textpm, String textcust, String texttype, boolean flag) throws Exception {
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String PartyListStr = "''";
		if (!departmentId.trim().equals("")) {
			List partyList_dep=ph.getAllSubPartysByPartyId(session,departmentId);
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'"+departmentId+"'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
		}
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		String SqlStr = "	";
		SqlStr = SqlStr + " select	p.description as cust_name,	";
		SqlStr = SqlStr + " 		proj.proj_id as pid,	";
		SqlStr = SqlStr + " 		proj.proj_caf_flag as cafflag,	";
		SqlStr = SqlStr + " 		proj.proj_name as pname,	";
		SqlStr = SqlStr + " 		proj.contracttype as category,	";
		SqlStr = SqlStr + " 		ul.NAME as pm,	";
		SqlStr = SqlStr + " 		proj.proj_status as status,	";
		SqlStr = SqlStr + "			p1.DESCRIPTION as dpt_name,	";
		SqlStr = SqlStr + " 		st.ST_Desc as st_desc,	";
		SqlStr = SqlStr + " 		CONVERT(varchar(10),proj.start_date,(126)) as start_date,	";
		SqlStr = SqlStr + " 		CONVERT(varchar(10),proj.end_date,(126)) as end_date,	";
		SqlStr = SqlStr + " 		st.ST_EstDays as est_days,	";
		SqlStr = SqlStr + " 		sum(case when pe.billable = 'yes' then det.ts_hrs_user end )/8 as ts_days,	";
		SqlStr = SqlStr + " 		sum(case det.ts_status when 'Approved' then det.ts_hrs_user else NULL end)/8 as ts_confirm,	";
		SqlStr = SqlStr + " 		sum(case det.ts_confirm when 'confirmed' then det.ts_hrs_confirm else null end)/8 as caf_confirm,	";
		SqlStr = SqlStr + " 		sum(case when det.ts_cafstatus_confirm = 'N' and proj.proj_caf_flag = 'y'  and pe.billable = 'yes' then det.ts_hrs_confirm else null end)/8 as caf_pending	";
		SqlStr = SqlStr + " from	Proj_Mstr as proj	"; 
		SqlStr = SqlStr + " 		left outer join Proj_ServiceType as st on proj.proj_id=st.ST_Proj_Id	";
		SqlStr = SqlStr + " 		left outer join Proj_TS_Det as det on st.ST_Id=det.ts_servicetype	";
		SqlStr = SqlStr + " 		inner join PARTY as p on p.PARTY_ID=proj.cust_id	";
		SqlStr = SqlStr + " 		inner join PARTY as p1 on p1.PARTY_ID=proj.dep_id	";
		SqlStr = SqlStr + " 		inner join USER_LOGIN as ul on proj.proj_pm_user=ul.USER_LOGIN_ID	";		
		SqlStr = SqlStr + " 		left join projevent as pe on pe.pevent_id = det.ts_projevent	";	
		
		SqlStr = SqlStr + " where proj.proj_category <> 'I'";
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " and p1.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " and proj.proj_pm_user ='"+ul.getUserLoginId()+"'";
		}
		if (!projType.trim().equals("")) {
			SqlStr = SqlStr + " and proj.proj_status = '"+projType+"'";
		}
		if (!textcode.trim().equals("")) {
			SqlStr = SqlStr + " and ((proj.proj_id like '%"+ textcode.trim() +"%') or (proj.proj_name like '%"+ textcode.trim() +"%') or (proj.parent_proj_id like '%" + textcode.trim() + "%'))";
		}
		if (!textpm.trim().equals("")) {
			SqlStr = SqlStr + " and ((proj.proj_pm_user like '%"+ textpm.trim() +"%') or (ul.name like '%"+ textpm.trim() +"%'))";
		}
		if (!textcust.trim().equals("")) {
			SqlStr = SqlStr + " and ((proj.cust_id like '%"+ textcust.trim() +"%') or (p.description like '%"+ textcust.trim() +"%'))";
		}
		if (!texttype.trim().equals("")) {
			SqlStr = SqlStr + " and proj.contracttype = '"+texttype+"'";
		}
		if (!flag){
			SqlStr = SqlStr + " and proj.proj_category ='C'";
		}
		
		SqlStr = SqlStr + " group by	p.description,	";
		SqlStr = SqlStr + " 			proj.proj_id, proj.proj_caf_flag,	";
		SqlStr = SqlStr + " 			proj.proj_name, proj.contracttype,";
		SqlStr = SqlStr + " 			proj.proj_category,	";
		SqlStr = SqlStr + " 			ul.NAME,	";
		SqlStr = SqlStr + "				proj.proj_status,	";
		SqlStr = SqlStr + " 			p1.DESCRIPTION,	";
		SqlStr = SqlStr + " 			st.ST_Desc,	";
		SqlStr = SqlStr + " 			proj.start_date,	";
		SqlStr = SqlStr + " 			proj.end_date,	";
		SqlStr = SqlStr + " 			st.ST_EstDays	";
		SqlStr = SqlStr + " order by	p.description, proj.contracttype, proj.proj_id, st.ST_Desc";
		
		System.out.println(SqlStr);
		
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		return sr;
	}
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,String projType,String departmentId,String textcode, String textpm, String textcust, String texttype, boolean flag ){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sr = findQueryResult(request,projType,departmentId, textcode, textpm,textcust, texttype, flag);
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
			
	//////	further consideration of the third status "Project Completed"
			if ((sr.getString(0, "status")).equals("WIP"))
			{
				status = "WIP";
			} else status = "CLOSED";
			
			// write department name
			HSSFCell cell = null;
			cell = sheet.getRow(0).getCell((short)13);
			cell.setCellValue(sr.getString(0, "dpt_name"));
			// write status
			cell = sheet.getRow(1).getCell((short)13);
			cell.setCellValue(sr.getString(0, "status"));
			
			//List
			HSSFCellStyle boldTextStyle     = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle numberFormatStyle = sheet.getRow(ListStartRow).getCell((short)8).getCellStyle();
			
			int ExcelRow = ListStartRow;
			
			HSSFRow HRow = null;
			
			//in order to make groups
			String newPid = "";
			String oldPid = "";
			Object resultSet_data = null;
			
			for (int row =0; row < sr.getRowCount(); row++) {
				
				double budgetDays =0;
				double tsDays = 0;
				double tsConfirmDays = 0;
				double cafConfirmDays = 0;
				double cafPendingDays = 0;
				double tsRemain = 0;
				double cafRemain = 0;
				
				newPid = sr.getString(row, "pid");

				budgetDays = sr.getDouble(row, "est_days");
				
				//if "TS Days" is "null" , it remains the default value "0" 
				resultSet_data = sr.getObject(row, "ts_days");
				if(resultSet_data != null)
					tsDays = sr.getDouble(row, "ts_days");
					
				//if "TS Confirm Days" is "null" , it remains the default value "0" 
				resultSet_data = sr.getObject(row, "ts_confirm");
				if(resultSet_data != null)
					tsConfirmDays = sr.getDouble(row, "ts_confirm");
					
				//if "CAF Confirm Days" is "null" , it remains the default value "0" 
				resultSet_data = sr.getObject(row, "caf_confirm");
				if(resultSet_data != null)
					cafConfirmDays = sr.getDouble(row, "caf_confirm");
					
				cafPendingDays = sr.getDouble(row, "caf_pending");
				tsRemain = budgetDays-tsDays;
				if(sr.getString(row, "cafflag").equals("N")){
					cafRemain =0;
				}else{
					cafRemain = budgetDays-cafConfirmDays-cafPendingDays;
				}
			
				HRow = sheet.createRow(ExcelRow);
					
				if(!oldPid.equals(newPid)){
					oldPid = newPid;
					
					cell = HRow.createCell((short)0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"cust_name"));
					cell.setCellStyle(boldTextStyle);
					
				    cell = HRow.createCell((short)1);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"pid"));
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell((short)2);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"pname"));
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell((short)3);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"pm"));
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell((short)4);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					String c ="";
					if(sr.getString(row,"category").equals("TM")){c="Time & Material";}else{c="Fixed Price";}
					cell.setCellValue(c);
					cell.setCellStyle(boldTextStyle);
								
					cell = HRow.createCell((short)5);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"start_date"));
					cell.setCellStyle(boldTextStyle);
								
					cell = HRow.createCell((short)6);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"end_date"));
					cell.setCellStyle(boldTextStyle);
				}
				else {
					cell = HRow.createCell((short)0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("");
					cell.setCellStyle(boldTextStyle);
					
				    cell = HRow.createCell((short)1);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell((short)2);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell((short)3);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("");
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell((short)4);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("");
					cell.setCellStyle(boldTextStyle);
								
					cell = HRow.createCell((short)5);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("");
					cell.setCellStyle(boldTextStyle);
								
					cell = HRow.createCell((short)6);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue("");
					cell.setCellStyle(boldTextStyle);
				}
					cell = HRow.createCell((short)7);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(sr.getString(row,"st_desc"));
					cell.setCellStyle(boldTextStyle);
					
					cell = HRow.createCell((short)8);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(budgetDays);
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)9);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(tsDays);
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)10);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(tsConfirmDays);
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)11);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(cafConfirmDays);
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)12);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(cafPendingDays);
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)13);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(tsRemain);
					cell.setCellStyle(numberFormatStyle);
					
					cell = HRow.createCell((short)14);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(cafRemain);
					cell.setCellStyle(numberFormatStyle);
				
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
	private final static String ExcelTemplate="ActualVSBudgetMD.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Actual VS Budget Man-Days Report.xls";
	private final int ListStartRow = 5;
}