/*
 * Created on 2006-1-23
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
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
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ProjectByPMRptAction extends ReportBaseAction {

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
			String PMId = request.getParameter("PMId");
			if (PMId == null) PMId = "";
			if (action == null) action = "view";
			
			if (action.equals("QueryForList")) {
				SQLResults sr = findQueryResult(request,PMId);
				request.setAttribute("QryList",sr);
				return (mapping.findForward("success"));
			}
			if (action.equals("ExportToExcel")) {
				return ExportToExcel(mapping,request, response,PMId);
			}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}
	
	private SQLResults findQueryResult(HttpServletRequest request,String PMId) throws Exception {
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		String SqlStr = 
		"select pmul.name as pm, pm.proj_id, p.description as cust, pm.proj_name, pm.proj_status, " +
		"pm.contracttype, paul.name as pa, pm.total_service_value as tcv, pm.start_date, "+ 
		"pm.end_date, sum (st.st_estdays) as estMD, isnull(td.actualMD,0) as actualMD, "+
		"isnull(caf.otcaf,0) as otcaf, isnull(accp.otAccep,0) as otAccp, "+
		"isnull(bill_pending.tr_pending_amt, 0) as bill_pending, "+
	 	"isnull(billed.inv_amount,0) as total_billed_amount, "+
		"isnull(last_billed.inv_amount, 0) as last_billed_amount, "+
		"isnull(last_inv.inv_status, 'N/A') as last_inv_status, "+
		"isnull(AR_amt.AR, 0) as AR, isnull(ar_amt.total_r_amount,0) as total_receipt_amt, "+
		"last_receipt.m_r_date as last_r_date "+
		//"--case when last_receipt.m_r_date is null then 'N\A' else last_receipt.m_r_date end as last_r_date
	"from proj_mstr as pm  "+
	"inner join user_login as pmul on pmul.user_login_id = pm.proj_pm_user "+
	"inner join user_login as paul on paul.user_login_id = pm.proj_pa_id "+
	"inner join party as p on p.party_id = pm.cust_id "+
	"inner join proj_servicetype as st on st_proj_id = pm.proj_id "+
	"left join "+
		"(select ts_proj_id, (sum(ts_hrs_user)/8) as actualMd from proj_ts_det where ts_status = 'Approved' "+
		"group by ts_proj_id) as td on td.ts_proj_id= pm.proj_id   "+
	"left join "+
		"(select ptd.ts_proj_id, (sum(ptd.ts_hrs_user)/8) as otcaf "+
		"from proj_ts_mstr as ptm inner join proj_ts_det as ptd on ptd.tsm_id = ptm.tsm_id "+
		"and ptd.ts_hrs_user <> 0 And ptd.ts_cafstatus_confirm = 'N' and ptd.ts_status <> 'draft'  "+
		"inner join proj_mstr as pm on pm.proj_id = ptd.ts_proj_id "+
		"inner join projevent as pe on pe.pevent_id = ptd.ts_projevent and pe.Billable = 'Yes' "+
		"where pm.proj_caf_flag = 'y'   and pm.proj_category = 'C' "+
		"and (ptd.ts_date between '2005-01-01' and '"+(java.util.Date)UtilDateTime.nowTimestamp()+"') "+
		"group by  ptd.ts_proj_id ) as caf on caf.ts_proj_id = pm.proj_id "+
	"left join "+
		"(select pm.proj_id, sum(st_rate) as otAccep "+
		"from proj_mstr as pm inner join proj_servicetype as pst on pst.st_proj_id = pm.proj_id "+
		"where contracttype ='fp' and pst.st_custacceptance_date is null  "+
			"and pst.st_estimatedate < '"+(java.util.Date)UtilDateTime.nowTimestamp()+"' "+
		"group by pm.proj_id) as accp on accp.proj_id = pm.proj_id "+
	"left join  "+
		"(select tr.tr_proj_id, sum(tr_amount) as tr_pending_amt "+
		"from proj_tr_det as tr inner join proj_mstr as pm on pm.proj_id = tr.tr_proj_id "+
		"where tr_mstr_id is null "+
		"group by tr.tr_proj_id) as bill_pending on bill_pending.tr_proj_id = pm.proj_id "+
	"left join  "+
		"(select inv_proj_id, sum(inv_amount) as inv_amount from proj_invoice  "+
		"where inv_status not in ('undelivered', 'cancelled') and inv_type ='normal' "+
		"group by inv_proj_id) as billed on billed.inv_proj_id = pm.proj_id "+
	"left join "+
		"(select i.inv_proj_id, i.inv_amount, i.inv_createdate, i.inv_invoicedate, i.inv_status "+
		"from proj_invoice as i  "+
		"inner join  "+
		"(select inv_proj_id, max(inv_invoicedate) as m_inv_date from proj_invoice  "+
		"where inv_status not in ('undelivered', 'cancelled') and inv_type ='Normal' "+
		"group by inv_proj_id ) as i1 on i1.inv_proj_id = i.inv_proj_id "+
		"right join  "+
		"(select inv_proj_id, max(inv_createdate) as m_create_date from proj_invoice  "+
		"where inv_status not in ('undelivered', 'cancelled') and inv_type ='Normal' "+
		"group by inv_proj_id ) as i2 on i2.inv_proj_id = i.inv_proj_id  and i.inv_createdate = i2.m_create_date "+
		"where i.inv_invoicedate = i1.m_inv_date ) as last_billed on last_billed.inv_proj_id = pm.proj_id "+
	"left join "+
		"(select i.inv_proj_id, i.inv_amount, i.inv_createdate, i.inv_invoicedate, i.inv_status "+
		"from proj_invoice as i  "+
		"inner join  "+ 
		"(select inv_proj_id, max(inv_invoicedate) as m_inv_date from proj_invoice  "+
		"where inv_type ='Normal' "+
		"group by inv_proj_id ) as i1 on i1.inv_proj_id = i.inv_proj_id "+
		"right join  "+
		"(select inv_proj_id, max(inv_createdate) as m_create_date from proj_invoice  "+
		"where inv_type ='Normal' "+
		"group by inv_proj_id ) as i2 on i2.inv_proj_id = i.inv_proj_id  and i.inv_createdate = i2.m_create_date "+
		"where i.inv_invoicedate = i1.m_inv_date ) as last_inv on last_inv.inv_proj_id = pm.proj_id "+
	"left join "+
	"(select t_inv.inv_proj_id, sum(t_inv.inv_amount) as total_inv_amout, t_r.total_r_amount, "+  
	"case when abs(sum(t_inv.inv_amount) - isnull(t_r.total_r_amount,0)) < 1  then 0  "+
	"else (sum(t_inv.inv_amount) - isnull(t_r.total_r_amount,0)) end  as AR  "+
	"from (select * from proj_invoice where inv_status not in ('undelivered','cancelled') and inv_type ='normal') as t_inv  "+ 
	"left join   "+
	"(select i.inv_proj_id, sum(r.receive_amount) as total_r_amount from proj_receipt as r   "+
	"inner join proj_invoice as i on i.inv_id = r.invoice_id  "+
	"group by i.inv_proj_id )as t_r on t_r.inv_proj_id = t_inv.inv_proj_id  "+
	"group by t_inv.inv_proj_id,t_r.total_r_amount) as AR_amt on AR_amt.inv_proj_id = pm.proj_id "+
	"left join "+
	"	(select inv.inv_proj_id, max(rm.receipt_date) as m_r_date from proj_receipt as r  "+
	"	inner join proj_receipt_mstr as rm on rm.receipt_no = r.receipt_no "+
	"	inner join proj_invoice as inv on inv.inv_id = r.invoice_id "+
	"	group by inv.inv_proj_id) as last_receipt on last_receipt.inv_proj_id = pm.proj_id "+

	"where pm.proj_category ='C' and pm.proj_status in ('WIP','PC') and (pm.proj_pm_user like '%"+PMId+"%' or pmul.name like '%"+PMId+"%') "+

	"group by pm.proj_id, pmul.name, p.description, pm.proj_name, pm.proj_status, "+
	"	pm.contracttype, paul.name, pm.total_service_value, pm.start_date,  "+
	"	pm.end_date, td.actualMD, CAF.otcaf, accp.otAccep, bill_pending.tr_pending_amt, "+
	"	billed.inv_amount,last_billed.inv_amount,last_inv.inv_status, AR_amt.AR, ar_amt.total_r_amount, "+
	"	last_receipt.m_r_date ";
		
		System.out.println("\n"+SqlStr+"\n");
		
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		
		//SQLResults sr =null;
		
		return sr;
	}
	private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response,String PMId){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			SQLResults sr = findQueryResult(request,PMId);
			if (sr== null || sr.getRowCount() == 0) return null;
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			//Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);			
			
			HSSFCell cell = null;
			
			HSSFCellStyle textStyle = sheet.getRow(ListStartRow).getCell((short)5).getCellStyle();
			HSSFCellStyle numberStyle = sheet.getRow(ListStartRow+1).getCell((short)2).getCellStyle();
			HSSFCellStyle numberStyle2 = sheet.getRow(ListStartRow+1).getCell((short)1).getCellStyle();
			HSSFCellStyle dateStyle = sheet.getRow(ListStartRow).getCell((short)11).getCellStyle();
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			NumberFormat numFormat1 = NumberFormat.getInstance();
			numFormat1.setMaximumFractionDigits(0);
			numFormat1.setMinimumFractionDigits(0);
			NumberFormat numFormat2 = NumberFormat.getInstance();
			numFormat2.setMaximumFractionDigits(2);
			numFormat2.setMinimumFractionDigits(2);
			
			int ExcelRow = ListStartRow;
			HSSFRow HRow = null;
			short cellNum = 0;
			
			HSSFCellStyle PMNameStyle = sheet.getRow(1).getCell((short)18).getCellStyle();
			HRow = sheet.createRow(1);
			cell = HRow.createCell(pmNamePosition);
			cell.setCellValue(request.getParameter("PMName"));
			cell.setCellStyle(PMNameStyle);
			
			for (int row =0; row < sr.getRowCount(); row++) {
				HRow = sheet.createRow(ExcelRow);
				
				cell = HRow.createCell(cellNum++);
				cell.setCellValue(row+1);
				cell.setCellStyle(numberStyle);
				
				//there blank columns
				//cell = HRow.createCell(cellNum++);
				//cell.setCellStyle(textStyle);
				//cell = HRow.createCell(cellNum++);
				//cell.setCellStyle(textStyle);
				//cell = HRow.createCell(cellNum++);
				//cell.setCellStyle(textStyle);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"cust"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"proj_id"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"proj_name"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"proj_status"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"pa"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(numFormat2.format(sr.getDouble(row,"tcv")));
				cell.setCellStyle(numberStyle2);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"start_date")==null?"N/A":dateFormat.format(sr.getDate(row,"start_date")));
				cell.setCellStyle(dateStyle);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"end_date")==null?"N/A":dateFormat.format(sr.getDate(row,"end_date")));
				cell.setCellStyle(dateStyle);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"estMD")==null?"N/A":numFormat2.format(sr.getDouble(row,"estMD")));
				cell.setCellStyle(numberStyle2);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"actualMD")==null?"N/A":numFormat2.format(sr.getDouble(row,"actualMD")));
				cell.setCellStyle(numberStyle2);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"otcaf")==null?"N/A":numFormat1.format(sr.getDouble(row,"otcaf")));
				cell.setCellStyle(numberStyle);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"otaccp")==null?"N/A":numFormat2.format(sr.getDouble(row,"otaccp")));
				cell.setCellStyle(numberStyle2);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"bill_pending")==null?"N/A":numFormat2.format(sr.getDouble(row,"bill_pending")));
				cell.setCellStyle(numberStyle2);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"total_billed_amount")==null?"N/A":numFormat2.format(sr.getDouble(row,"total_billed_amount")));
				cell.setCellStyle(numberStyle2);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"last_billed_amount")==null?"N/A":numFormat2.format(sr.getDouble(row,"last_billed_amount")));
				cell.setCellStyle(numberStyle2);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getString(row,"last_inv_status").equals("N/A")?"N/A":sr.getString(row,"last_inv_status"));
				cell.setCellStyle(textStyle);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"AR")==null?"N/A":numFormat2.format(sr.getDouble(row,"AR")));
				cell.setCellStyle(numberStyle2);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"total_receipt_amt")==null?"N/A":numFormat2.format(sr.getDouble(row,"total_receipt_amt")));
				cell.setCellStyle(numberStyle2);
				
				cell = HRow.createCell(cellNum++);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
				cell.setCellValue(sr.getObject(row,"last_r_date")==null?"N/A":dateFormat.format(sr.getDate(row,"last_r_date")));
				cell.setCellStyle(dateStyle);
				
				ExcelRow++;
				cellNum = 0;
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
	private final static String ExcelTemplate="ProjectByPM.xls";
	private final static String FormSheetName="Form";
	private final static String SaveToFileName="ProjectByPM.xls";
	private final short pmNamePosition = 18;
	private final int ListStartRow = 4;

}
