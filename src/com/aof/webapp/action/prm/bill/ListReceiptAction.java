/**
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 */

package com.aof.webapp.action.prm.bill;

import java.io.IOException;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.RowSetDynaClass;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.ProjectReceiptMaster;
import com.aof.component.prm.Bill.ReceiptService;
import com.aof.component.prm.project.CurrencyType;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilFormat;
import com.aof.webapp.action.BaseAction;

/**
 * @author stanley
 * @version 2005-07-27
 * 			Modified from HQL to SQL at 2005-12-01
 */

public class ListReceiptAction extends BaseAction{
	
	private Logger log = Logger.getLogger(EditInvoiceAction.class);

	public ActionForward perform(
			ActionMapping mapping, 
			ActionForm form, 
			HttpServletRequest request, 
			HttpServletResponse response) throws IOException, ServletException {
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		ReceiptService service = new ReceiptService();
		
		UserLogin currentUser = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
		
		
		String action = request.getParameter("FormAction");
		String receiptNo = request.getParameter("receiptNo");
		//String process = request.getParameter("process");
		String receiptDateFromString = request.getParameter("receiptDateFrom");
		String receiptDateToString = request.getParameter("receiptDateTo");
		String customerIdString = request.getParameter("customerId");
		String status = request.getParameter("status");
		String dateStart = request.getParameter("dateStart");
		String dateEnd = request.getParameter("dateEnd");
		String type = request.getParameter("type");
		
		if(action == null)	action = ""; 
		//if(receiptNo == null )	receiptNo = "";
		//if(process == null) process = "";
		//if(status == null) 	status = "";
		Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
		if (dateStart==null) dateStart=dateFormatter.format(UtilDateTime.toDate(01,01,Calendar.getInstance().get(Calendar.YEAR),0,0,0));
		if (dateEnd==null) dateEnd=dateFormatter.format(nowDate);
			
		String statement = "	";
		statement += "	select 	rec_mstr.Receipt_No as rec_no,	";
		statement += "	convert(varchar,cast(rec_mstr.Receipt_Amt as money),1) as rec_amt,	";
		statement += "	rec_mstr.Currency as currency,	";
		statement += "	convert(varchar,cast(rec_mstr.Exchange_Rate as money),1) as rate,	";
		statement += "	rec_mstr.Create_User as create_user,	";
		statement += "	p.PARTY_ID+':'+p.DESCRIPTION as cust_name,	";
		statement += "	rec_mstr.Receipt_Status as status,	"; 
		statement += "	convert(varchar(10),rec_mstr.Receipt_Date,(126)) as rec_date,	";
		statement += "	convert(varchar(10),rec_mstr.Create_Date,(126)) as create_date,	";
		statement += "	convert(varchar,	";
		statement += "				cast(	";
		statement += "					(case	"; 
		statement += "					when abs(sum(settle.receive_Amount)-rec_mstr.Receipt_Amt*rec_mstr.Exchange_Rate)<1	"; 
		statement += "					then 0.0	"; 
		statement += "					else isnull((rec_mstr.Receipt_Amt*rec_mstr.Exchange_Rate - sum(settle.receive_Amount)),rec_mstr.Receipt_Amt)	";
		statement += "					end)	"; 
		statement += "				as money)	";
		statement += "		    ,1) as remain_amt	";
		statement += "	";		
		statement += "	from proj_receipt_mstr rec_mstr	";
		statement += "	inner join PARTY p on rec_mstr.CustomerId=p.PARTY_ID	";
		statement += "	left outer join Proj_Receipt settle on rec_mstr.Receipt_No=settle.receipt_No	";
		statement += "	";	
		statement += "	where	rec_mstr.Receipt_Date between '"+dateStart+"' and '"+dateEnd+"'	";
					
		if(receiptNo != null && !receiptNo.trim().equals("")){
			statement += "	and rec_mstr.Receipt_No like '%" + receiptNo+"%'	";
			if(customerIdString != null && !customerIdString.trim().equals(""))
				statement += "	and (p.PARTY_ID like '%"+ customerIdString+"%' or p.DESCRIPTION like '%"+ customerIdString+"%')	";
			if(status != null && !status.trim().equals(""))	
				statement += "	and rec_mstr.Receipt_Status='"+ status+"'	";
			if(type != null && !type.trim().equals(""))
				statement += "	and rec_mstr.receipt_type='"+ type+"'	";
		}
		else{
			if(customerIdString != null && !customerIdString.trim().equals("")){
				statement += "	and (p.PARTY_ID like '%"+ customerIdString+"%' or p.DESCRIPTION like '%"+ customerIdString+"%')	";
				if(status != null && !status.trim().equals(""))
					statement += "	and rec_mstr.Receipt_Status='"+ status+"'	";
				if(type != null && !type.trim().equals(""))
					statement += "	and rec_mstr.receipt_type='"+ type+"'	";		
			}
			else{
				if(status != null && !status.trim().equals("")){
					statement += "	and rec_mstr.Receipt_Status='"+ status+"'	";
					if(type != null && !type.trim().equals(""))
						statement += "	and rec_mstr.receipt_type='"+ type+"'	";						
				}
				else{
					if(type != null && !type.trim().equals(""))
						statement += "	and rec_mstr.receipt_type='"+ type+"'	";	
				}
			}
		}
		
		statement += "	group by rec_mstr.Receipt_No,	";
		statement += "	rec_mstr.Receipt_Amt,	";
		statement += "	rec_mstr.Currency,	";
		statement += "	rec_mstr.Exchange_Rate,	";
		statement += "	rec_mstr.Create_User,	";
		statement += "	p.PARTY_ID+':'+p.DESCRIPTION,	";
		statement += "	rec_mstr.Receipt_Status,	"; 
		statement += "	rec_mstr.Receipt_Date,	";
		statement += "	rec_mstr.Create_Date	";
			
			//*/
		log.info(statement.toString());

		ResultSet result = null;
		RowSetDynaClass resultSet = null;
		try{
			result = sqlExec.runQueryStreamResults(statement.toString());
			resultSet = new RowSetDynaClass(result,false);
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		sqlExec.closeConnection();
			
		request.setAttribute("ReceiptList",resultSet);
		return mapping.findForward("success");
	}

}