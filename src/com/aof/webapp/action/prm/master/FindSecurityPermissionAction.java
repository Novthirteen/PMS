/*
 * Created on 2005-7-19
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

package com.aof.webapp.action.prm.master;

import java.io.FileInputStream;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.RowSetDynaClass;
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
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.report.ReportBaseAction;


/**
 * @author stanley
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

public class FindSecurityPermissionAction extends ReportBaseAction {


	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	public ActionForward perform (
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response){
		
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		try {
			SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-mm-dd");
			Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
			
			String action = request.getParameter("FormAction");
			
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			Party party = ul.getParty();
			request.setAttribute("userLogin",ul);
			request.setAttribute("userParty",party);
			
			if (action == null || action.trim().equals("")) 
				action = "view";
			
			if (action.equals("view")) {
				ResultSet result = getQueryResult(request);
				//request.setAttribute("QryList",result);
				return (mapping.findForward("success"));
			}
			
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response );
			}		
		
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return (mapping.findForward("success"));
	}
	
	private ResultSet getQueryResult(HttpServletRequest request) throws Exception {
		
		String username = 
			request.getParameter("UserName");
		String department = 
			request.getParameter("Department");
		String securityGroup = 
			request.getParameter("SecurityGroup");
		String securityPermission = 
			request.getParameter("SecurityPermission");
		
		if(username == null)	username = "";
		if(department == null)	department = "";
		if(securityGroup == null)	securityGroup = "";
		if(securityPermission == null)	securityPermission = "";
		
		//net.sf.hibernate.Session session = Hibernate2Session.currentSession();

		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		StringBuffer sql = new StringBuffer();
		
		sql.append(" select ul.user_login_id as uid, ul.name as uname, pt.description as udesc,");
		sql.append(" sg.group_id as gid, sg.description as gdesc,");
		sql.append(" sp.permission_id as pid, sp.description as pdesc");
		sql.append(" from user_login as ul");
		sql.append(" inner join party as pt on ul.party_id=pt.party_id");
		sql.append(" inner join user_login_security_group as ulsg on ul.user_login_id=ulsg.user_login_id");
		sql.append(" inner join security_group as sg on ulsg.group_id=sg.group_id");
		sql.append(" inner join security_group_permission as sgp on sgp.group_id=sg.group_id");
		sql.append(" inner join security_permission as sp on sp.permission_id=sgp.permission_id");
		
		if(!username.trim().equals("")){
			sql.append(" where (ul.user_login_id like '%"+username+"%' or ul.name like '%"+username+"%')");
		}
		else{
			sql.append(" where pt.party_id='"+department+"'");
		}
		
		if(!securityPermission.trim().equals("")){
			sql.append(" and sp.permission_id='"+securityPermission+"'");
		}
		else if(!securityGroup.trim().equals("")){
			sql.append(" and sg.group_id='"+securityGroup+"'");
		}
		else
			;
		
		
		ResultSet result = sqlExec.runQueryStreamResults(sql.toString());
		RowSetDynaClass resultSet = new RowSetDynaClass(result,false);
		sqlExec.closeConnection();
		request.setAttribute("QryList",resultSet);
		return result;
	}
	
	private ActionForward ExportToExcel (
			ActionMapping mapping, 
			HttpServletRequest request, 
			HttpServletResponse response ){
	/*
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			ResultSet result = getQueryResult(request);
			if (result== null || result.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			HSSFCell cell = null;
			
			//Style
			HSSFCellStyle Style1 = sheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
			HSSFCellStyle Style2 = sheet.getRow(ListStartRow).getCell((short)1).getCellStyle();
				
			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			String oldUser ="";
			String newUser ="";
			String oldGroup = "";
			String newGroup = "";
			for (int row =0; row < result.getRowCount(); row++) {
				newUser = result.getString(row,"uid");
				newUser += ":";
				newUser += result.getString(row,"uname");
				
				newGroup = result.getString(row,"gid");
				
				HRow = sheet.createRow(ExcelRow);
				
				if (!newUser.equals(oldUser)){
					oldUser = newUser ;
	
					cell = HRow.createCell((short)0);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(newUser);
					cell.setCellStyle(Style1);
					
				    cell = HRow.createCell((short)1);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"udesc"));
					cell.setCellStyle(Style2);
					
					cell = HRow.createCell((short)2);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"gid"));
					cell.setCellStyle(Style2);
					
					cell = HRow.createCell((short)3);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"gdesc"));
					cell.setCellStyle(Style2);

					cell = HRow.createCell((short)4);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"pid"));
					cell.setCellStyle(Style2);
					
					cell = HRow.createCell((short)5);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"pdesc"));
					cell.setCellStyle(Style2);
					
				}else if(!newGroup.equals(oldGroup)){
					
					oldGroup = newGroup;
					cell = HRow.createCell((short)0);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellStyle(Style1);
					
				    cell = HRow.createCell((short)1);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellStyle(Style2);
					
					cell = HRow.createCell((short)2);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"gid"));
					cell.setCellStyle(Style2);
					
					cell = HRow.createCell((short)3);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"gdesc"));
					cell.setCellStyle(Style2);

					cell = HRow.createCell((short)4);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"pid"));
					cell.setCellStyle(Style2);
					
					cell = HRow.createCell((short)5);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"pdesc"));
					cell.setCellStyle(Style2);
					
				}else{
					cell = HRow.createCell((short)0);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellStyle(Style1);
					
				    cell = HRow.createCell((short)1);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellStyle(Style2);
					
					cell = HRow.createCell((short)2);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellStyle(Style2);
					
					cell = HRow.createCell((short)3);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellStyle(Style2);

					cell = HRow.createCell((short)4);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"pid"));
					cell.setCellStyle(Style2);
					
					cell = HRow.createCell((short)5);			
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					cell.setCellValue(result.getString(row,"pdesc"));
					cell.setCellStyle(Style2);
					
				}
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
		*/
		return null;
	}
	private final static String ExcelTemplate="PermissionList.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="PAS Permission List.xls";
	private final int ListStartRow = 5;


}
