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
import org.apache.poi.hssf.util.Region;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.report.AFCustomer;
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
public class ActualVSForecastRptAction extends ReportBaseAction {
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
			String billable = request.getParameter("Billable");
			boolean zeroflag = false;
			if (request.getParameter("zeroflag") != null) zeroflag = true;
			if (EmployeeId == null) EmployeeId = "";
			if (departmentId == null) departmentId = "";
			if (billable == null) billable = "all";
			if (FromDate==null) FromDate=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-10));
			if (EndDate==null) EndDate=Date_formater.format(nowDate);
			//if (qDate==null) qDate=Date_formater.format(nowDate);
		
			if (action == null) action = "view";
			EndDate = EndDate + " 23:59";

			if (action.equals("QueryForList")) {
				SQLResults fsr = findForecastQueryResult(request,FromDate,EndDate,EmployeeId,departmentId,zeroflag );
				request.setAttribute("forecastQryList",fsr);
				SQLResults asr = findActualQueryResult(request,FromDate,EndDate,EmployeeId,departmentId, zeroflag);
				request.setAttribute("actualQryList",asr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response,FromDate,EndDate,EmployeeId,departmentId, zeroflag,billable);
			}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private SQLResults findForecastQueryResult(HttpServletRequest request,String FromDate, String ToDate,String EmployeeId,String departmentId, boolean zeroflag) throws Exception {
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
		SqlStr = SqlStr + " left join proj_mstr as pm on pm.proj_id = ftd.ts_proj_id and pm.proj_status = 'WIP' ";
		SqlStr = SqlStr + " left join party as p on p. party_id = pm.cust_id";
		SqlStr = SqlStr + " where ";
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " ul.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " pm.proj_pm_user ='"+ul.getUserLoginId()+"'";
		}
		if (!EmployeeId.trim().equals("")) {
			SqlStr = SqlStr + " and (ul.user_login_id like '%"+EmployeeId.trim()+"%' or ul.name like '%"+EmployeeId.trim()+"%')";
		}
		SqlStr = SqlStr + " and ul.enable = 'Y' ";
		if (!zeroflag) {
			SqlStr = SqlStr + " and ul.note = 'INT'";
		}
		SqlStr = SqlStr + " order by ul.name, ftd.ts_date";
				
		SQLResults fsr = sqlExec.runQueryCloseCon(SqlStr);
		
		return fsr;
	}
	
	private SQLResults findActualQueryResult(HttpServletRequest request,String FromDate, String ToDate,String EmployeeId,String departmentId, boolean zeroflag) throws Exception {
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
		
		String SqlStr = "select distinct atd.ts_date as adate , ul.name, ap.description as acustomer , atd.ts_proj_id as aproj";
		SqlStr = SqlStr + " from user_login as ul left join proj_ts_mstr as atm on ul.user_login_id = atm.tsm_userlogin";
		SqlStr = SqlStr + " left join proj_ts_det as atd on atm.tsm_id = atd.tsm_id and atd.ts_date between '"+FromDate+"' and '"+ToDate+"' and atd.ts_hrs_user <>0";
		SqlStr = SqlStr + " left join proj_mstr as apm on apm.proj_id = atd.ts_proj_id";
		SqlStr = SqlStr + " left join party as ap on ap. party_id = apm.cust_id";
		SqlStr = SqlStr + " where ";
		if (!departmentId.trim().equals("")) {
			SqlStr = SqlStr + " ul.party_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " apm.proj_pm_user ='"+ul.getUserLoginId()+"'";
		}
		if (!EmployeeId.trim().equals("")) {
			SqlStr = SqlStr + " and (ul.user_login_id like '%"+EmployeeId.trim()+"%' or ul.name like '%"+EmployeeId.trim()+"%')";
		}
		SqlStr = SqlStr + " and ul.enable = 'Y' ";
		if (!zeroflag) {
			SqlStr = SqlStr + " and ul.note = 'INT'";
		}
		SqlStr = SqlStr + " order by ul.name, atd.ts_date";
				
		SQLResults asr = sqlExec.runQueryCloseCon(SqlStr);
		
		return asr;
	}
	
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,String FromDate, String ToDate,String EmployeeId,String departmentId, boolean zeroflag,String billable){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			SQLResults asr = findActualQueryResult(request,FromDate,ToDate,EmployeeId,departmentId,  zeroflag);
			SQLResults fsr = findForecastQueryResult(request,FromDate,ToDate,EmployeeId,departmentId,  zeroflag);
			if (fsr== null || fsr.getRowCount() == 0) return null;
			if (asr== null || asr.getRowCount() == 0) return null;
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat Date_formater1 = new SimpleDateFormat("MM-dd(EEE)");
			Map resultMap = new TreeMap();
			if (fsr!=null){
				for (int row =0; row < fsr.getRowCount(); row++) {
					String staff = null;
					String date = null;
					if (fsr.getDate(row,"date") != null) {
						date = Date_formater.format(fsr.getDate(row,"date"));
					}
					staff = fsr.getString(row,"name");
					
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
						AFCustomer AFCustomer;
						if (dateMap.get(date) != null) {
							AFCustomer = (AFCustomer)dateMap.get(date);
						} else {
							AFCustomer = new AFCustomer();
							dateMap.put(date, AFCustomer);
						}
						if (fsr.getObject(row, "proj") != null){
							AFCustomer.addForcastCustomer(fsr.getString(row,"customer"));
						}else{
							AFCustomer.addForcastCustomer(fsr.getString(row,"description"));
						}
					}
				}
			}
			//------------------------------------------------
			if (asr!=null){
				for (int row =0; row < asr.getRowCount(); row++) {
					String aStaff = null;
					String aDate = null;
					if (asr.getDate(row,"adate") != null) {
						aDate = Date_formater.format(asr.getDate(row,"adate"));
					}
					aStaff = asr.getString(row,"name");
					Map dateMap = null;
					Map staffMap = null;
					
					if (resultMap.get(aStaff) != null) {
						staffMap= (Map)resultMap.get(aStaff);
					} else {
						staffMap = new HashMap();
						resultMap.put(aStaff, staffMap);
					}
					
					if (aDate != null) {
						if (staffMap.get(aDate) != null) {
							dateMap = (Map)staffMap.get(aDate);
						} else {
							dateMap = new HashMap();
							staffMap.put(aDate, dateMap);
						}
						
						AFCustomer ACustomer;
			
						if (dateMap.get(aDate) != null) {
							ACustomer = (AFCustomer)dateMap.get(aDate);
						} else {
							ACustomer = new AFCustomer();
							dateMap.put(aDate, ACustomer);
						}

						ACustomer.addActualCustomer(asr.getString(row,"acustomer"));
					}
				}
			}
			
			//-----------------------------------------------------------------
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
			HSSFCell cell2 = null;
			cell = sheet.getRow(0).getCell((short)6);
			cell.setCellValue(df.format(fromDate) + " ~ " + df.format(toDate));
			
			//List
			HSSFCellStyle nameStyle = sheet.getRow(ListStartRow).getCell((short)1).getCellStyle();
			HSSFCellStyle boldStyle = sheet.getRow(ListStartRow).getCell((short)2).getCellStyle();
			HSSFCellStyle custStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle dateStyle = sheet.getRow(ListStartRow+1).getCell((short)0).getCellStyle();
			HSSFCellStyle wkendStyle = sheet.getRow(ListStartRow+1).getCell((short)1).getCellStyle();
			HSSFCellStyle percentageFormatStyle = sheet.getRow(ListStartRow).getCell((short)3).getCellStyle();
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
			HSSFRow HRow2 = null;
			HRow = sheet.createRow(ExcelRow);
			cell = HRow.createCell((short)0);
			int r = 2;
			Map staffMap =null;
			cell = HRow.createCell((short)1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue("Date");
			cell.setCellStyle(boldStyle);
			Iterator iterator = resultMap.keySet().iterator();
			
			int totallStaffNum=0;
			
			while (iterator.hasNext()) {
				totallStaffNum+=1;
				String staff = (String)iterator.next();
				staffMap = (Map)resultMap.get(staff);
				cell = HRow.createCell((short)(r++));
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(staff);
				cell.setCellStyle(nameStyle);					
			}
			
			int rateArray[]=new int[totallStaffNum];
			
			ExcelRow = ExcelRow+1;
			
		//********************************** create date cell
			int nr=0;
			int or=0;
			int anr=0;
			int aor=0;
			AFCustomer AFCustomer = new AFCustomer();
			int day=0;
			//Map rateMap=new  HashMap();
			for (int col = 0; col < dateArray.length; col++) {
				HRow1 = sheet.createRow(ExcelRow);
				cell = HRow1.createCell((short)0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue("Forecast");
				cell.setCellStyle(boldStyle);
				
				HRow2 = sheet.createRow(ExcelRow+1);
				cell2 = HRow2.createCell((short)0);
				cell2.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell2.setCellValue("Actual");
				cell2.setCellStyle(boldStyle);
				
				nr=or;
				calendar.setTime(dateArray[col]);
				cell = HRow1.createCell((short)1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(Date_formater.format(dateArray[col]));
				cell.setCellStyle(dateStyle);
				cell2 = HRow2.createCell((short)1);
				cell2.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell2.setCellValue("");
				cell2.setCellStyle(boldStyle);
				Iterator iterator2 = resultMap.keySet().iterator();
				int cellno =1;
				while (iterator2.hasNext()) {
					
					String staff = (String)iterator2.next();
					staffMap = (Map)resultMap.get(staff);
					
					String accuCust="";
				    String forcCust="";
					
					
					if(staffMap.keySet().size() == 0){
						if(!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
								&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){	
							cell = HRow1.createCell((short)(cellno+1));
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue("");
							cell.setCellStyle(custStyle);
							
							cell2 = HRow2.createCell((short)(cellno+1));
							cell2.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell2.setCellValue("");
							cell2.setCellStyle(custStyle);
						}else{
							cell = HRow1.createCell((short)(cellno+1));
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue("");
							cell.setCellStyle(wkendStyle);
							
							cell2 = HRow2.createCell((short)(cellno+1));
							cell2.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell2.setCellValue("");
							cell2.setCellStyle(wkendStyle);
						}
					}else{
						Iterator staffMapItr = staffMap.keySet().iterator();
						int mc=0;
						int amc=0;
						while (staffMapItr.hasNext()) {
							String date = (String)staffMapItr.next();
							if (Date_formater.format(dateArray[col]).equals(date)) {
								Map dateMap = (Map)staffMap.get(date);
								AFCustomer = (AFCustomer)dateMap.get(date);	
								if (AFCustomer != null){
									if((AFCustomer.getForcastCustomerSet() !=null) ){
										nr++;
										
										Set forecastCustomerSet = AFCustomer.getForcastCustomerSet();
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
										forcCust=cust;
										cell = HRow1.createCell((short)(cellno+1));
										cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
										cell.setCellValue(cust);
										cell.setCellStyle(custStyle);
										mc++;
									}
									if((AFCustomer.getActualCustomerSet() !=null) ){
										anr++;
										
										Set actualCustomerSet = AFCustomer.getActualCustomerSet();
										Iterator acustSetItr = actualCustomerSet.iterator();
										String acust="";
										int act = 0;
										while (acustSetItr.hasNext()){
											if (act==0){
												acust = (String)acustSetItr.next();
											}else{
												acust = acust + " , " + (String)acustSetItr.next();
											}
											act++;
										}
										accuCust=acust;
										if((AFCustomer.getForcastCustomerSet() !=null) ){
											cell2 = HRow2.createCell((short)(cellno+1));
											cell2.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
											cell2.setCellValue(acust);
											cell2.setCellStyle(custStyle);
										}else{
											cell = HRow1.createCell((short)(cellno+1));
											cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
											cell.setCellValue("");
											cell.setCellStyle(custStyle);
											
											cell2 = HRow2.createCell((short)(cellno+1));
											cell2.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
											cell2.setCellValue(acust);
											cell2.setCellStyle(custStyle);
										}
										amc++;
									}
								}
								
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
							if (amc ==0){
								if(!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
										&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
									cell2 = HRow2.createCell((short)(cellno+1));
									cell2.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
									cell2.setCellValue("");
									cell2.setCellStyle(custStyle);
								}else{
					
									cell2 = HRow2.createCell((short)(cellno+1));
									cell2.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
									cell2.setCellValue("");
									cell2.setCellStyle(wkendStyle);
								}
							}
							
							
							
						}
					}
					
						//-------- count rate here----------------
					
					if (accuCust.equals(forcCust)&& accuCust.trim().length()!=0 &&!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
							&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
						rateArray[cellno-1]+=1;
							}
					//-----------------------------------
					cellno++;
				}
							if (!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
									&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
				             day=day+1;
					               }
				ExcelRow = ExcelRow+2;
			}
			// write the rate to excel as the last row
			
			if(billable.equals("billable")){
			 HRow = sheet.createRow(ExcelRow);
			  cell = HRow.createCell((short)0);
			  cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			  sheet.addMergedRegion(new Region(ExcelRow, (short) 0, ExcelRow, (short) 1));
			  cell.setCellValue("Accurate Rate");
			  cell.setCellStyle(boldStyle);	
			 for (int j=0;j<rateArray.length;j++)
			 {
			  cell = HRow.createCell((short)(j+2));
			  cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			  cell.setCellValue((double)(100*rateArray[j])/day);
			  cell.setCellStyle(percentageFormatStyle);	
			 }
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
	private final static String ExcelTemplate="ResourceForecastActual.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="Resource Forecast vs Actual Report.xls";
	private final int ListStartRow = 4;
}