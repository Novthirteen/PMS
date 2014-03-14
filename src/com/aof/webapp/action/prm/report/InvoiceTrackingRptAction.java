/*
 * Created on 2005-10-12
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.report;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.commons.beanutils.RowSetDynaClass;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.form.prm.report.OutstandingAcceptanceRptForm;

/**
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class InvoiceTrackingRptAction extends ReportBaseAction {

	
	private Log log = LogFactory.getLog(OutstandingAcceptanceRptAction.class);
	
	public ActionForward execute (ActionMapping mapping,
	                              ActionForm form,
								  HttpServletRequest request,
								  HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String invoiceCode = request.getParameter("invoiceCode");
		String invoiceStatus = request.getParameter("invoiceStatus");
		String dpt = request.getParameter("dpt");
		String project = request.getParameter("project");
		String pa = request.getParameter("pa");
		String billto = request.getParameter("billto");
		String outstandingDays = request.getParameter("outstandingDays");
		String compareDate =  request.getParameter("compareDate");
		String formAction =  request.getParameter("formAction");
		if (invoiceCode == null) {
			invoiceCode = "";
		}
		if (invoiceStatus == null) {
			invoiceStatus = "";
		}
		if (compareDate == null) {
			compareDate = dateFormat.format(new Date());
		}
		if (dpt == null) {
			dpt = "";
		}
		if (project == null) {
			project = "";
		}
		if (pa == null) {
			pa = "";
		}
		if (billto == null) {
			billto = "";
		}
		if (outstandingDays == null) {
			outstandingDays = "";
		}

		if (formAction == null) {
			formAction = "";
		}
		
		try {
			if ("QueryForList".equals(formAction)) {
				ResultSet sr = findQueryResult(invoiceCode, invoiceStatus, dpt, project, pa, billto, outstandingDays, compareDate,  request);
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
	
	private ResultSet findQueryResult(String invoiceCode, String invoiceStatus, String dpt, String project, String pa, String billto,
			String outstandingDays, String compareDate, HttpServletRequest request) throws Exception {
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		StringBuffer statement = new StringBuffer("");
		statement.append(" select pi.inv_id as inv_id, ");
		statement.append("        pi.inv_code as inv_code, ");
		statement.append("        pb.bill_id as bill_id, ");
		statement.append("        pb.bill_code as bill_code, ");
		statement.append("        pb.bill_type as bill_type, ");
		statement.append("        pm.proj_id as proj_id, ");
		statement.append("        pm.proj_name as proj_name, ");
		statement.append("        p1.party_id as billAddrId, ");
		statement.append("        p1.description as billAddr, ");
		statement.append("        p2.party_id as departmentId, ");
		statement.append("        p2.description as department, ");
		statement.append("        pi.inv_curr_id as currency, ");
		statement.append("        convert(varchar,cast(pi.inv_amount as money),1) as inv_amount, ");    
		statement.append("        sum(pr.receive_amount) as receivedAmount, ");
		statement.append("        pi.inv_status as inv_status, ");
		statement.append("        pi.inv_invoicedate as inv_invoicedate, ");
		statement.append("        convert(varchar(10), pi.inv_createdate , (126)) as inv_createdate, ");
		statement.append("        pm.proj_pa_id as paId, ");
		statement.append("        pa.name as paName,  isnull(convert(varchar(10), ems.ems_date , (126)), 'N/A') as ems_date ");
		//from setatement
		statement.append("   from proj_invoice as pi "); 
		statement.append("  inner join proj_bill as pb on pi.inv_bill_id = pb.bill_id ");
		statement.append("  inner join proj_mstr as pm on pi.inv_proj_id = pm.proj_id ");
		statement.append("  left join proj_ems as ems on pi.inv_ems_id = ems.ems_id ");
		statement.append("  inner join party as p1 on pi.inv_billaddr = p1.party_id ");
		statement.append("  inner join party as p2 on pm.dep_id = p2.party_id ");
		statement.append("  left join user_login as pa on pm.proj_pa_id = pa.user_login_id ");
		statement.append("   left join proj_receipt as pr on pi.inv_id = pr.invoice_id ");
		
		//where statement
		statement.append("  where pi.inv_type = ? ");
		sqlExec.addParam(Constants.INVOICE_TYPE_NORMAL);
		if (invoiceStatus != null && invoiceStatus.trim().length() != 0 && !invoiceStatus.trim().equals("")) {
			statement.append("  and pi.inv_status = ? ");
			sqlExec.addParam(invoiceStatus);
		}
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String PartyListStr = "''";
		List partyList_dep=ph.getAllSubPartysByPartyId(session, dpt);
		Iterator itdep = partyList_dep.iterator();
		PartyListStr = "'" + dpt + "'";
		while (itdep.hasNext()) {
			Party p =(Party)itdep.next();
			PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
		}
		statement.append("  and p2.party_id in (" + PartyListStr + ") ");
		
		if(!billto.trim().equals("")){
			statement.append("  and p1.party_id = ? ");
			sqlExec.addParam(billto);
		}
		if(!invoiceCode.trim().equals("")){
			statement.append("  and pi.inv_code like '%"+invoiceCode+"%'");
		}
		if(!project.trim().equals("")){
			statement.append("  and (pm.proj_id like '%"+project+"%'  or pm.proj_name like '%"+project+"%')" );
		}
		if(!pa.trim().equals("")){
			statement.append("  and (pa.user_login_id like '%"+pa+"%'  or pa.name like '%"+pa+"%')" );
		}
		if(!compareDate.trim().equals("") && !outstandingDays.trim().equals("")){
			if (!invoiceStatus.trim().equals("") && invoiceStatus.equals("Undelivered")){
				statement.append("  and datediff(day, pi.inv_createdate, '"+compareDate+"' ) >= "+outstandingDays +" " );	
			}
			if (!invoiceStatus.trim().equals("") && invoiceStatus.equals("Delivered")){
				statement.append("  and datediff(day, ems.ems_date, '"+compareDate+"' ) >= "+outstandingDays +" " );	
			}
			//if (!invoiceStatus.trim().equals("") && invoiceStatus.equals("Confirmed")){
			//	statement.append("  and datediff(day, ems_date, "+new Date()+" ) >= "+outstandingDays +" " );	
			//}
			//if (!invoiceStatus.trim().equals("") && invoiceStatus.equals("In Process")){
			//	statement.append("  and datediff(day, pi.inv_createdate, "+new Date()+" ) >= "+outstandingDays +" " );	
			//}
		}
		//group by statement
		statement.append("  group by pi.inv_id, ");
		statement.append("           pi.inv_code, ");
		statement.append("           pb.bill_id, ");
		statement.append("           pb.bill_code, ");
		statement.append("           pb.bill_type, ");
		statement.append("           pm.proj_id, ");
		statement.append("           pm.proj_name, ");
		statement.append("           p1.party_id, ");
		statement.append("           p1.description, ");
		statement.append("           p2.party_id, ");
		statement.append("           p2.description, ");
		statement.append("           pi.inv_curr_id, ");
		statement.append("           pi.inv_amount, ");
		statement.append("           pi.inv_status, ");
		statement.append("           pi.inv_invoicedate, ");
		statement.append("           pi.inv_createdate, ");
		statement.append("           pm.proj_pa_id, ");
		statement.append("           pa.name, ems.ems_date ");
		//order by statement
		statement.append("  order by pi.inv_code ");
		
		log.info(statement.toString());
		
		ResultSet result = sqlExec.runQueryStreamResults(statement.toString());			
		RowSetDynaClass resultSet = new RowSetDynaClass(result,false);
		sqlExec.closeConnection();
		request.setAttribute("QryList",resultSet);

		return result;
	}

}
