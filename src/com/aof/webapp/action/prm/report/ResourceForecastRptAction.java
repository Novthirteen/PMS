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
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
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
public class ResourceForecastRptAction extends ReportBaseAction {
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
			String FromDate = request.getParameter("dateStart");
			String EndDate = request.getParameter("dateEnd");
			String EmployeeId = request.getParameter("EmployeeId");
			String departmentId = request.getParameter("departmentId");
			//String dayCount = request.getParameter("dayCount");
			boolean zeroflag = false;
			if (request.getParameter("zeroflag") != null) zeroflag = true;
			if (EmployeeId == null) EmployeeId = "";
			if (departmentId == null) departmentId = "";
			if (FromDate==null) FromDate=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-10));
			if (EndDate==null) EndDate=Date_formater.format(nowDate);
			//if (qDate==null) qDate=Date_formater.format(nowDate);
		
			if (action == null) action = "view";
			EndDate = EndDate + " 23:59";
			
			if (action.equals("QueryForList")) {
				SQLResults sr = findQueryResult(request,FromDate,EndDate,EmployeeId,departmentId,zeroflag);
				request.setAttribute("QryList",sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response,FromDate,EndDate,EmployeeId,departmentId, zeroflag);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private SQLResults findQueryResult(HttpServletRequest request,String FromDate, String ToDate,String EmployeeId,String departmentId, boolean zeroflag) throws Exception {
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
		
		String SqlStr = "select distinct ftd.ts_date as date , ul.name, p.description as customer , ftd.ts_proj_id as proj, ftd.ts_description as description";
		SqlStr = SqlStr + " from user_login as ul left join proj_ts_forecast_mstr as ftm on ul.user_login_id = ftm.tsm_userlogin";
		SqlStr = SqlStr + " left join proj_ts_forecast_det as ftd on ftm.tsm_id = ftd.tsm_id and ftd.ts_date between '"+FromDate+"' and '"+ToDate+"' and ftd.ts_hrs_user <>0";
		SqlStr = SqlStr + " left join proj_mstr as pm on pm.proj_id = ftd.ts_proj_id";
		SqlStr = SqlStr + " left join party as p on p. party_id = pm.cust_id";
		SqlStr = SqlStr + " where ";
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " ul.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " pm.proj_pm_user ='"+ul.getUserLoginId()+"'";
		}
		if (!EmployeeId.trim().equals("")) {
			SqlStr = SqlStr + " and (ul.user_login_id like '%"+EmployeeId+"%' or ul.name like '%"+EmployeeId+"%')";
		}
		SqlStr = SqlStr + " and ul.enable = 'Y' ";
		if (!zeroflag) {
			SqlStr = SqlStr + " and ul.note = 'INT'";
		}
		SqlStr = SqlStr + " order by ul.name, ftd.ts_date";
				
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		
		return sr;
	}
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,String FromDate, String ToDate,String EmployeeId,String departmentId, boolean zeroflag){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			SQLResults sr = findQueryResult(request,FromDate,ToDate,EmployeeId,departmentId, zeroflag);
			if (sr== null || sr.getRowCount() == 0) return null;
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat Date_formater1 = new SimpleDateFormat("MM-dd(EEE)");
			Map resultMap = new TreeMap();
			if (sr!=null){
				for (int row =0; row < sr.getRowCount(); row++) {
					String staff = null;
					String date = null;
					if (sr.getDate(row,"date") != null) {
						date = Date_formater.format(sr.getDate(row,"date"));
					}
					staff = sr.getString(row,"name");
					
					Map dateMap = null;
					Map staffMap = null;
					
					if (resultMap.get(staff) != null) {
						staffMap= (Map)resultMap.get(staff);
					} else {
						staffMap = new HashMap();
						resultMap.put(staff, staffMap);
					}
					
					if (date != null) {
						if (staffMap.get(date) != null) {
							dateMap = (Map)staffMap.get(date);
						} else {
							dateMap = new HashMap();
							staffMap.put(date, dateMap);
						}
						
						Set forecastCustomerSet = null;
						if (dateMap.get("FORECAST_CUSTOMER_SET") != null) {
							forecastCustomerSet = (Set)dateMap.get("FORECAST_CUSTOMER_SET");
						} else {
							forecastCustomerSet = new HashSet();
							dateMap.put("FORECAST_CUSTOMER_SET", forecastCustomerSet);
						}
						if (sr.getObject(row, "proj") != null){
							forecastCustomerSet.add(sr.getString(row,"customer"));
						}else{
							forecastCustomerSet.add(sr.getString(row,"description"));
						}
					}
				}
			}
			//------------------------------
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			//Header
			int fromYear = 0;
			int fromMonth = 0;
			int fromDay = 0;
			int toYear = 0;
			int toMonth = 0;
			int toDay = 0;
			Calendar fromCalendar = Calendar.getInstance();
			if (FromDate != null && FromDate.trim().length() > 9) {
			    fromYear = Integer.parseInt(FromDate.substring(0, 4));
			    fromMonth = Integer.parseInt(FromDate.substring(5, 7));
			    fromDay = Integer.parseInt(FromDate.substring(8, 10));
			    fromCalendar.set(Calendar.YEAR, fromYear);
			    fromCalendar.set(Calendar.MONTH, fromMonth - 1);
			    fromCalendar.set(Calendar.DATE, fromDay);
			}
			Date fromDate = fromCalendar.getTime();
			Calendar toCalendar = Calendar.getInstance();
			if (ToDate != null && ToDate.trim().length() > 9) {
			    toYear = Integer.parseInt(ToDate.substring(0, 4));
			    toMonth = Integer.parseInt(ToDate.substring(5, 7));
			    toDay = Integer.parseInt(ToDate.substring(8, 10));
			    toCalendar.set(Calendar.YEAR, toYear);
			    toCalendar.set(Calendar.MONTH, toMonth - 1);
			    toCalendar.set(Calendar.DATE, toDay);
			}
			Date toDate = toCalendar.getTime();
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

			HSSFCell cell = null;
			cell = sheet.getRow(0).getCell((short)6);
			cell.setCellValue(df.format(fromDate) + " ~ " + df.format(toDate));
			
			//List
			HSSFCellStyle nameStyle = sheet.getRow(ListStartRow).getCell((short)1).getCellStyle();
			HSSFCellStyle custStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle dateStyle = sheet.getRow(ListStartRow+1).getCell((short)0).getCellStyle();
			HSSFCellStyle wkendStyle = sheet.getRow(ListStartRow+1).getCell((short)1).getCellStyle();
			//----------------------------------------
		//*****************	
			int ExcelRow = ListStartRow;
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(fromDate);
			int count =0;
			do {
				count++;
				calendar.add(Calendar.DATE, 1);
			} while(calendar.getTime().compareTo(toDate) <= 0);
			
			Date dateArray[];
			dateArray = new Date[count];
			calendar.setTime(fromDate);
			for (int c=0; c<count; c++){
				dateArray[c] = calendar.getTime();
				calendar.add(Calendar.DATE, 1);
			}
			
		//************************ create row of staff name	
			HSSFRow HRow = null;
			HSSFRow HRow1 = null;
			HRow = sheet.createRow(ExcelRow);
			cell = HRow.createCell((short)0);
			int r = 0;
			Map staffMap =null;
			Iterator iterator = resultMap.keySet().iterator();
			while (iterator.hasNext()) {
				String staff = (String)iterator.next();
				staffMap = (Map)resultMap.get(staff);
				cell = HRow.createCell((short)(++r));
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(staff);
				cell.setCellStyle(nameStyle);					
			}
			ExcelRow = ExcelRow+1;
			
		//********************************** create date cell
			int nr=0;
			int or=0;
			for (int col = 0; col < dateArray.length; col++) {
				nr=or;
				calendar.setTime(dateArray[col]);
				HRow1 = sheet.createRow(ExcelRow);
				cell = HRow1.createCell((short)0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(Date_formater.format(dateArray[col]));
				cell.setCellStyle(dateStyle);
				Iterator iterator2 = resultMap.keySet().iterator();
				int cellno =0;
				while (iterator2.hasNext()) {
					
					String staff = (String)iterator2.next();
					staffMap = (Map)resultMap.get(staff);

					if(staffMap.keySet().size() == 0){
						if(!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
								&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){	
							cell = HRow1.createCell((short)(cellno+1));
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue("");
							cell.setCellStyle(custStyle);	
						}else{
							cell = HRow1.createCell((short)(cellno+1));
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue("");
							cell.setCellStyle(wkendStyle);
						}
					}else{
						Iterator staffMapItr = staffMap.keySet().iterator();
						int mc=0;
						while (staffMapItr.hasNext()) {
							String date = (String)staffMapItr.next();
							if (Date_formater.format(dateArray[col]).equals(date)) {
								nr++;
								Map dateMap = (Map)staffMap.get(date);
								Set forecastCustomerSet = (Set)dateMap.get("FORECAST_CUSTOMER_SET");
								Iterator custSetItr = forecastCustomerSet.iterator();
								String cust="";
								int ct = 0;
								while (custSetItr.hasNext()){
									if (ct==0){
										cust = (String)custSetItr.next();
									}else{
										cust = cust + " , " + (String)custSetItr.next();
									}
									ct++;
								}
								cell = HRow1.createCell((short)(cellno+1));
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
								cell.setCellValue(cust);
								cell.setCellStyle(custStyle);
								mc++;
							}
							if (mc ==0){
								if(!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
										&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
									cell = HRow1.createCell((short)(cellno+1));
									cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
									cell.setCellValue("");
									cell.setCellStyle(custStyle);	
								}else{
									cell = HRow1.createCell((short)(cellno+1));
									cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
									cell.setCellValue("");
									cell.setCellStyle(wkendStyle);
								}
							}
						}
					}
					cellno++;
				}
		
				ExcelRow = ExcelRow+1;
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
	private final static String ExcelTemplate="ResourceForecast.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Resource Forecast Report.xls";
	private final int ListStartRow = 4;
}