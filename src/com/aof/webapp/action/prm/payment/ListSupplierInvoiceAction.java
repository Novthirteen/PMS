/**
 * 
 */
package com.aof.webapp.action.prm.payment;

import java.io.IOException;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.RowSetDynaClass;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01511
 *
 */
public class ListSupplierInvoiceAction extends BaseAction {
	
	private Logger log = Logger.getLogger(ListSupplierInvoiceAction.class);

	public ActionForward perform(
			ActionMapping mapping, 
			ActionForm form, 
			HttpServletRequest request, 
			HttpServletResponse response) throws IOException, ServletException {
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));

		SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
		
		//String action = request.getParameter("FormAction");
		String payCode = request.getParameter("payCode");
		String vendorIdString = request.getParameter("vendorId");
		String paidStatus = request.getParameter("paidStatus");
		String settledStatus = request.getParameter("settledStatus");
		String dateStart = request.getParameter("dateStart");
		String dateEnd = request.getParameter("dateEnd");
		String type = request.getParameter("type");
		
		//if(action == null)	action = ""; 
		//if(receiptNo == null )	receiptNo = "";
		//if(process == null) process = "";
		//if(status == null) 	status = "";
		Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
		if (dateStart==null) dateStart=dateFormatter.format(UtilDateTime.toDate(01,01,Calendar.getInstance().get(Calendar.YEAR),0,0,0));
		if (dateEnd==null) dateEnd=dateFormatter.format(nowDate);
			
		String statement = "	";
		statement += "	select 	pay_mstr.pay_code as inv_code,	";
		statement += "	convert(varchar, cast(pay_mstr.pay_amount as money), 1) as tot_amt,	";
		statement += "	pay_mstr.currency as currency,	";
		statement += "	pay_mstr.exchange_rate as rate,	";
		statement += "	pay_mstr.create_user as create_user,	";
		statement += "	pay_mstr.vendor_id+':'+p.DESCRIPTION as vendor_info, ";
		statement += "	pay_mstr.pay_status as paid_status,	";
		statement += "	pay_mstr.settle_status as settled_status, ";
		statement += "	convert(varchar(10),pay_mstr.pay_date,(126)) as pay_date,	";
		statement += "	convert(varchar(10),pay_mstr.create_date,(126)) as create_date,	";
		statement += "	sum(pay_tr.pay_amount) settled_amount, ";
		statement += "	sum(case when pay_tr.post_status = '"+Constants.POST_PAYMENT_TRANSACTION_STATUS_PAID+"' then pay_tr.pay_amount end) paid_amount ";	
		statement += "	from proj_payment_mstr pay_mstr	";
		statement += "	inner join PARTY p on p.PARTY_ID = pay_mstr.vendor_id	";
		statement += "	left join proj_payment_transaction pay_tr on pay_tr.invoice_id = pay_mstr.pay_code ";
		statement += "	where pay_mstr.pay_date between '"+dateStart+"' and '"+dateEnd+"'	";
		
		if(payCode != null && !payCode.trim().equals("")){
			statement += " and pay_mstr.pay_code like '%"+payCode+"%' ";
		}
		  
		if(vendorIdString != null && !vendorIdString.trim().equals("")) {
			statement += " and (pay_mstr.vendor_id like '%"+vendorIdString+"%' or p.DESCRIPTION like '%"+vendorIdString+"%') ";
		}
		  
		if(paidStatus != null && !paidStatus.trim().equals("")) {
			statement += " and pay_mstr.pay_status='"+paidStatus+"' ";
		}
		
		if(settledStatus != null && !settledStatus.trim().equals("")) {
			statement += " and pay_mstr.settle_status='"+settledStatus+"' ";
		}
		  
		if(type != null && !type.trim().equals("")) {
			statement += " and pay_mstr.pay_type='"+type+"' ";
		}
  
		statement += " group by pay_mstr.pay_code, ";
		statement += " pay_mstr.pay_amount, ";
		statement += " pay_mstr.currency, ";
		statement += " pay_mstr.exchange_rate, ";
		statement += " pay_mstr.create_user, ";
		statement += " pay_mstr.vendor_id, ";
		statement += " p.DESCRIPTION, ";
		statement += " pay_mstr.pay_status, ";
		statement += " pay_mstr.settle_status, ";
		statement += " pay_mstr.pay_date, ";
		statement += " pay_mstr.create_date "; 
		statement += " order by pay_mstr.vendor_id, pay_mstr.pay_date "; 
		
		log.info(statement);
		
		long timebegin = System.currentTimeMillis();
		
		ResultSet result = null;
		RowSetDynaClass resultSet = null;
		try{
			result=sqlExec.runQueryStreamResults(statement.toString());
			resultSet=new RowSetDynaClass(result,false);
			sqlExec.closeConnection();
		}catch(Exception ex){
			ex.printStackTrace();
		}

		long timeend = System.currentTimeMillis();
		System.out.println(timeend-timebegin);
		
		request.setAttribute("PaymentList",resultSet);
		return mapping.findForward("success");
	}
}
