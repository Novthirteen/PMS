/*
 * Created on 2005-8-22
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.TimeSheet.TimeSheetDetail;
import com.aof.component.prm.TimeSheet.TimeSheetMaster;

import com.aof.component.prm.project.ExpenseType;
import com.aof.component.prm.project.ProjectEvent;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ServiceType;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.GeneralException;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilFormat;
import com.aof.webapp.action.ActionErrorLog;
import com.lowagie.text.Cell;

/**
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CAFPrintExcelFormAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		return ExportToExcel(mapping, form, request, response);
	}
	private ActionForward ExportToExcel (ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			//Fetch related Data
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			PartyHelper ph = new PartyHelper();
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			String UserId = request.getParameter("UserId");
			String DataPeriod = request.getParameter("DataId");
			if (UserId == null) UserId = "";
			if (DataPeriod == null) DataPeriod = "";

			List result = new ArrayList();
			TimeSheetMaster tsm = null;
			Query q =
				hs.createQuery(
					"select tsm from TimeSheetMaster as tsm inner join tsm.TsmUser as tUser where tsm.Period = :DataPeriod and tUser.userLoginId = :DataUser");
			q.setParameter("DataPeriod", DataPeriod);
			q.setParameter("DataUser", UserId);
			result = q.list();
			List result2 = result;
			Iterator itMstr = result.iterator();
			
			String projId[] = request.getParameterValues("projId");
			String PSTId[] = request.getParameterValues("PSTId");
			String chk[] = request.getParameterValues("chk");
			String PEventId[] = request.getParameterValues("PEventId");
			
			int ChkSize = 0;
			if (chk == null) {
				chk = new String[1];
				chk[0] = "-1";
				return null;
			} else {
				ChkSize = java.lang.reflect.Array.getLength(chk);
			}

			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
	
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));

			if (itMstr.hasNext()) {
				// set query result to request
				request.setAttribute("QryMaster", result);
				tsm = (TimeSheetMaster) itMstr.next();
			}else
				tsm = new TimeSheetMaster();

			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
			NumberFormat numFormater = NumberFormat.getInstance();
			numFormater.setMaximumFractionDigits(2);
			numFormater.setMinimumFractionDigits(2);			
	
			if (projId != null) {
				int RowSize = java.lang.reflect.Array.getLength(projId);
				try {
					TimeSheetDetail ts = null;
					
					ProjectMaster oldPM = null;
					ServiceType oldST = null;
					Object[] details = null;
					int ckrow = 1;
					int ci = 0;
					for (int i = 1; i <= RowSize; i++) {
						
						int ColSize = 0;
						
						
						if (ci < ChkSize && i == new Integer(chk[ci]).intValue()) {
							String tsId[] = request.getParameterValues("tsId" + i);
							String RecordVal[] =request.getParameterValues("RecordVal" + i);
							
							ProjectMaster projectMaster =(ProjectMaster) hs.load(ProjectMaster.class,projId[i - 1].toString());
							ProjectEvent projectEvent =(ProjectEvent) hs.load(ProjectEvent.class,new Integer(PEventId[i - 1]));
							ServiceType st = (ServiceType) hs.load(ServiceType.class, new Long(PSTId[i - 1]));
														
							if(projectMaster.equals(oldPM) && st.equals(oldST)){
								//update last record

								if (tsId != null) ColSize= java.lang.reflect.Array.getLength(tsId);
								
								for (int j = 0; j < ColSize; j++) {
									if (!tsId[j].trim().equals("")) {
										ts =(TimeSheetDetail) hs.load(TimeSheetDetail.class,new Integer(tsId[j]));
										int diff = new Long(
														UtilDateTime.getDayDistance(
																ts.getTsDate(),(UtilDateTime.toDate2(tsm.getPeriod() + " 00:00:00.000"))))
														.intValue();
										if(details[diff] == null){
											details[diff] = ts;
										}
										//If TimeSheetDetail in Monday & user hours equals zero, we don't add it.
										else if(diff != 0 || ts.getTsHoursUser().floatValue() != 0){
											if(details[diff] instanceof TimeSheetDetail){
												ArrayList al = new ArrayList();
												al.add(details[diff]);
												al.add(ts);
												details[diff] = al;		
											}else if(details[diff] instanceof ArrayList){
												((ArrayList)details[diff]).add(ts);
											}
										}
									}
								}

							}else{
								//create new record
								details = new Object[7];
								
								if (tsId != null) ColSize= java.lang.reflect.Array.getLength(tsId);
								
								for (int j = 0; j < ColSize; j++) {
									if (!tsId[j].trim().equals("")) {
										ts =(TimeSheetDetail) hs.load(TimeSheetDetail.class,new Integer(tsId[j]));
										int diff = new Long(
														UtilDateTime.getDayDistance(
																ts.getTsDate(),(UtilDateTime.toDate2(tsm.getPeriod() + " 00:00:00.000"))))
														.intValue();
										details[diff] = ts;
									}
								}
							}
							if(ci == ChkSize-1){
								String cafNo = this.generateCAFFormNumber();
								setCAFNumber(details,cafNo);
								printCAF(wb, request, response, tsm,details, cafNo,true);
							}else if(ci < ChkSize-1){
								//System.out.println(new Integer(chk[ci]).intValue());
								ProjectMaster nextPM = (ProjectMaster) hs.load(ProjectMaster.class,projId[new Integer(chk[ci+1]).intValue()-1].toString()); 
								ServiceType nextST = (ServiceType) hs.load(ServiceType.class, new Long(PSTId[new Integer(chk[ci+1]).intValue()-1]));
								//System.out.println(projectMaster.equals(nextPM));
								//System.out.println(st.equals(nextST));
								if(!projectMaster.equals(nextPM) || !st.equals(nextST)){
									String cafNo = this.generateCAFFormNumber();
									setCAFNumber(details,cafNo);
									printCAF(wb, request, response, tsm,details, cafNo,false);
								}
							}
							oldPM = projectMaster;
							oldST = st;
							ci++;
						} 
						
					}	
					
					
				}catch (Exception e) {
					e.printStackTrace();
				} 
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private void setCAFNumber(Object[] details, String cafNo) {
		
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			for(int i = 0; i < 7; i++){
				if(details[i] instanceof TimeSheetDetail){
					//TimeSheetDetail tsd = (TimeSheetDetail)hs.load(TimeSheetDetail.class, ((TimeSheetDetail)details[i]).getTsId());
					TimeSheetDetail tsd = (TimeSheetDetail)details[i];
					(tsd).setCAFPrintDate(cafNo);
					hs.update(tsd);
				}else if(details[i] instanceof ArrayList){
					for(int j = 0; j < ((ArrayList)details[i]).size(); j++){
						TimeSheetDetail tsd1 = (TimeSheetDetail)((ArrayList)details[i]).get(j);
						tsd1.setCAFPrintDate(cafNo);
						hs.update(tsd1);
					}
				}					
			}
			hs.flush();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void printCAF(HSSFWorkbook wb, HttpServletRequest request, HttpServletResponse response, TimeSheetMaster tsm, Object[] details, String cafNo, boolean closed) {
		try{
			TimeSheetDetail tsd = null;
			for(int i=0; i<7; i++){
				if(details[i] != null){
					if(details[0] instanceof ArrayList){
						tsd = (TimeSheetDetail)((ArrayList)details[i]).get(0);
					}else
						tsd = (TimeSheetDetail)details[i];
					break;
				}
			}
			
			//Select the first worksheet
			HSSFSheet sheet = null;
			sheet = wb.cloneSheet(0);
//			System.out.println(wb.getNumberOfSheets()-1);
			wb.setSheetName(wb.getNumberOfSheets()-1, "Sheet"+(sheetIndex));
			sheetIndex+=1;
			
			if(sheet.getProtect()==true)
				sheet.setProtect(false);
			HSSFCellStyle boldTextStyle = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle normalStyle = sheet.getRow(ListStartRow).getCell((short)1).getCellStyle();
			HSSFCellStyle dateStyle = sheet.getRow(ListStartRow).getCell((short)2).getCellStyle();
			
			HSSFCell cell = null;
			cell = sheet.getRow(1).getCell((short)8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(cafNo); 
			cell = sheet.getRow(3).getCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getProject().getCustomer().getDescription());
			cell = sheet.getRow(4).getCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getProject().getCustomer().getAddress());
			cell = sheet.getRow(5).getCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getProject().getContact());
			
			cell = sheet.getRow(3).getCell((short)8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getTimeSheetMaster().getTsmUser().getName());
			cell = sheet.getRow(4).getCell((short)8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getProject().getProjectManager().getName());
			cell = sheet.getRow(5).getCell((short)8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			if(tsd.getProject().getProjAssistant()!=null)
			cell.setCellValue(tsd.getProject().getProjAssistant().getName());
			
			cell = sheet.getRow(8).getCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getProject().getContractNo());
			cell = sheet.getRow(9).getCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getProject().getContractType());
			cell = sheet.getRow(10).getCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getProject().getProjName());
			cell = sheet.getRow(11).getCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getTSServiceType().getDescription());
			cell = sheet.getRow(12).getCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getProject().getCustPM());						
			
			java.util.Set expenseSet = tsd.getProject().getExpenseTypes();
			Iterator itES = expenseSet.iterator();
			ArrayList expenseList = new ArrayList();
			while(itES.hasNext()){
				expenseList.add(((ExpenseType)itES.next()).getExpDesc());
			}
			cell = sheet.getRow(8).getCell((short)8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(expenseList.contains("Hotel") ? "Y" : "N");
			cell = sheet.getRow(9).getCell((short)8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(expenseList.contains("Meal") ? "Y" : "N");
			cell = sheet.getRow(10).getCell((short)8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(expenseList.contains("Transport(Travel)") ? "Y" : "N");
			cell = sheet.getRow(11).getCell((short)8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(expenseList.contains("Telephones") ? "Y" : "N");			
			cell = sheet.getRow(12).getCell((short)8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(expenseList.contains("Misc") ? "Y" : "N");
			cell = sheet.getRow(13).getCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(tsd.getProject().getExpenseNote());
			
			int dynRow = this.detailStartRow;
			float totalNormalHours = 0;
			float totalOneAndHalfHours = 0;
			float totalRateTwoHours = 0;
			
			for(int index = 0; index < 7; index++){
				if(details[index] != null){
					if(details[index] instanceof TimeSheetDetail){
						String date = UtilFormat.format(((TimeSheetDetail)details[index]).getTsDate());
						float hours = ((TimeSheetDetail)details[index]).getTsHoursUser().floatValue();
						if(hours != 0){
							cell = sheet.getRow(dynRow).getCell((short)1);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(date);
							if(index < 5){
								/*  Modification : hours are printed no matter <=8 or >8 , by Bill Yu
								if(hours <= 8){
									cell = sheet.getRow(dynRow).getCell((short)2);
									cell.setCellValue(hours);
									totalNormalHours += hours;
								}else{
									cell = sheet.getRow(dynRow).getCell((short)2);
									cell.setCellValue(8.0);
									cell = sheet.getRow(dynRow).getCell((short)3);
									cell.setCellValue(hours - 8);
									totalNormalHours += 8.0;
									totalOneAndHalfHours += (hours-8.0);
								}
								*/
								// following 3 rows replace the code above
								cell = sheet.getRow(dynRow).getCell((short)2);
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
								cell.setCellValue(hours);
								totalNormalHours += hours;
							}else if(index == 5){  //Modification : hours on Saturday placed at rate 1.5 column , by Bill Yu
								cell = sheet.getRow(dynRow).getCell((short)3);
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
								cell.setCellValue(hours);
								totalOneAndHalfHours += hours;
							}else if(index == 6){  //Modification : hours on Sunday placed at rate 2 column , by Bill Yu
								cell = sheet.getRow(dynRow).getCell((short)4);
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
								cell.setCellValue(hours);
								totalRateTwoHours += hours;
							}
							cell = sheet.getRow(dynRow).getCell((short)5);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							cell.setCellValue(((TimeSheetDetail)details[index]).getProjectEvent().getPeventName());
						}
					}
					else if(details[index] instanceof ArrayList){
						for(int index1 = 0; index1 < ((ArrayList)details[index]).size(); index1++){
							TimeSheetDetail ts = (TimeSheetDetail)((ArrayList)details[index]).get(index1);
							if(index1 > 0){
								sheet.shiftRows(dynRow+1,sheet.getPhysicalNumberOfRows(), 1);
								dynRow++;
								sheet.createRow(dynRow);
								this.cloneRow(sheet, dynRow-1,dynRow);
							}
							String date = UtilFormat.format(ts.getTsDate());
							float hours = ts.getTsHoursUser().floatValue();
							if(hours != 0){
								cell = sheet.getRow(dynRow).getCell((short)1);
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
								cell.setCellValue(date);
								if(index < 5){
									/*
									if(hours <= 8){
										cell = sheet.getRow(dynRow).getCell((short)2);
										cell.setCellValue(hours);
										totalNormalHours += hours;
									}else{
										cell = sheet.getRow(dynRow).getCell((short)2);
										cell.setCellValue(8.0);
										cell = sheet.getRow(dynRow).getCell((short)3);
										cell.setCellValue(hours - 8);
										totalNormalHours += 8.0;
										totalOneAndHalfHours += (hours-8.0);
									}
								}else{
									cell = sheet.getRow(dynRow).getCell((short)4);
									cell.setCellValue(hours);
									totalRateTwoHours += hours;
								}*/
									cell = sheet.getRow(dynRow).getCell((short)2);
									cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
									cell.setCellValue(hours);
									totalNormalHours += hours;
								}else if(index == 5){  //Modification : hours on Saturday placed at rate 1.5 column , by Bill Yu
									cell = sheet.getRow(dynRow).getCell((short)3);
									cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
									cell.setCellValue(hours);
									totalOneAndHalfHours += hours;
								}else if(index == 6){  //Modification : hours on Sunday placed at rate 2 column , by Bill Yu
									cell = sheet.getRow(dynRow).getCell((short)4);
									cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
									cell.setCellValue(hours);
									totalRateTwoHours += hours;
								}
								
								cell= sheet.getRow(dynRow).getCell((short)5);
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
								cell.setCellValue(ts.getProjectEvent().getPeventName());
								
							}
						}
					}
				}
				dynRow++;	
			}
			sheet.setProtect(true);
		/*	cell = sheet.getRow(dynRow).getCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(totalNormalHours);
			cell = sheet.getRow(dynRow).getCell((short)3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(totalOneAndHalfHours);
			cell = sheet.getRow(dynRow).getCell((shor)4);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellValue(totalRateTwoHours);
			*/
			if(closed){
				sheetIndex = 1;
				wb.removeSheetAt(0);
				//写入Excel工作表
				wb.write(response.getOutputStream());
				//关闭Excel工作薄对象
				response.getOutputStream().close();
				response.setStatus( HttpServletResponse.SC_OK );
				response.flushBuffer();
			}
	
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
	
	private void cloneRow(HSSFSheet sheet, int prev, int cur) {
		// TODO Auto-generated method stub
		HSSFRow prevRow = sheet.getRow(prev);
		HSSFRow curRow = sheet.getRow(cur);
		if(prevRow != null && curRow != null){
			int size = prevRow.getPhysicalNumberOfCells();
			for(int i = 0; i < size; i++){
				HSSFCell cell = curRow.createCell((short)i);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellStyle(prevRow.getCell((short)i).getCellStyle());				
			}
			sheet.addMergedRegion(new Region(cur, (short)5, cur, (short)8));
		}
		
	}
	private HSSFCell getCell(HSSFSheet sheet, int dynRow, short s) {
		HSSFCell cell = sheet.getRow(dynRow).getCell(s);
		if(cell == null){
			cell = sheet.getRow(dynRow).createCell(s);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
			cell.setCellStyle(sheet.getRow(dynRow-1).getCell(s).getCellStyle());
		}
		return cell;
	}
	
	public String generateCAFFormNumber()   {

		Calendar calendar = Calendar.getInstance();
		StringBuffer sb = new StringBuffer();
		sb.append("CAF");
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH)+1;
		int day = calendar.get(Calendar.DATE);
		sb.append(year);
		sb.append(this.fillPreZero(month,2));
		sb.append(this.fillPreZero(day,2));
		String codePrefix = sb.toString();
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));

		try {
			String statement = "select max(t.caf_printdate) from proj_ts_det as t where t.caf_printdate like '"+codePrefix+"%'";
			SQLResults result = sqlExec.runQueryCloseCon(statement);
					
			int count = 0;
			String GetResult = (String)result.getString(0,0);
			if (GetResult !=  null)
			count = (new Integer(GetResult.substring(codePrefix.length()))).intValue();
		
			sb = new StringBuffer();
			sb.append(codePrefix);
			sb.append(fillPreZero(count+1,3));
			return sb.toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			
			if(sqlExec.getConnection() != null)
				sqlExec.closeConnection();

			return null;
		}

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

	
	private final static String ExcelTemplate="CAFPrintForm.xls";
	private int sheetIndex = 1;
	private final static String SaveToFileName="CAF Excel Form.xls";
	private static int ListStartRow = 5;
	private static int detailStartRow = 19;
}
