/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.action.prm.bill;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.ProjectBill;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bill.FindInvoiceForm;

/**
 * @author Jackey Ding 
 * @version 2005-03-31
 *
 */
public class FindInvoiceAction extends BaseAction {
	
	private Logger log = Logger.getLogger(FindInvoiceAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		try {
			long timeStart = System.currentTimeMillis();
			//String offSetStr = request.getParameter("offSet");
			//String recordPerPageStr = request.getParameter("recordPerPage");
			FindInvoiceForm fiForm = (FindInvoiceForm)form;
			Session session = Hibernate2Session.currentSession();
			PartyHelper ph = new PartyHelper();
			
			String process = (String)request.getAttribute("process");
			String projectAssistant = (String)request.getParameter("pa");
			if (process == null) {
				process = "maintenance";
			}
			request.setAttribute("process", process);
			
			if (fiForm.getFormAction() != null) {
				//int offSet = 0;
				//int recordPerPage = 20;
				
				//if (offSetStr != null && offSetStr.trim().length() != 0) {
					//offSet = Integer.parseInt(offSetStr);
				//}
				//if (recordPerPageStr != null && recordPerPageStr.trim().length() != 0) {
					//recordPerPage = Integer.parseInt(recordPerPageStr);
				//}
				
				if (fiForm.getDepartment() == null) {
					UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
					if (userLogin != null) {
						fiForm.setDepartment(userLogin.getParty().getPartyId());
					}
				}
				
				SQLExecutor sqlExec = new SQLExecutor(
						Persistencer.getSQLExecutorConnection(
								EntityUtil.getConnectionByName("jdbc/aofdb")));
				
				StringBuffer statement = new StringBuffer("");
				//select statement
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
				statement.append("        pi.inv_amount as inv_amount, ");
				statement.append("        sum(pr.receive_amount) as receivedAmount, ");
				statement.append("        pi.inv_status as inv_status, ");
				statement.append("        pi.inv_invoicedate as inv_invoicedate, ");
				statement.append("        pi.inv_createdate as inv_createdate, ");
				statement.append("        pm.proj_pa_id as paId, ");
				statement.append("        pa.name as paName ");
				//from setatement
				statement.append("   from proj_invoice as pi "); 
				statement.append("  inner join proj_bill as pb on pi.inv_bill_id = pb.bill_id ");
				statement.append("  inner join proj_mstr as pm on pi.inv_proj_id = pm.proj_id ");
				statement.append("  inner join party as p1 on pi.inv_billaddr = p1.party_id ");
				statement.append("  inner join party as p2 on pm.dep_id = p2.party_id ");
				statement.append("  left join user_login as pa on pm.proj_pa_id = pa.user_login_id ");
				statement.append("   left join proj_receipt as pr on pi.inv_id = pr.invoice_id ");
				
				//where statement
				statement.append("  where pi.inv_type = ? ");
				sqlExec.addParam(Constants.INVOICE_TYPE_NORMAL);
				
				if (fiForm.getInvoice() != null && fiForm.getInvoice().trim().length() != 0) {
					statement.append("  and pi.inv_code like ? ");
					sqlExec.addParam("%" + fiForm.getInvoice() + "%");
				}
				
				if (fiForm.getBilling() != null && fiForm.getBilling().trim().length() != 0) {
					statement.append("  and pb.bill_code like ? ");
					sqlExec.addParam("%" + fiForm.getBilling() + "%");
				}
				
				if (fiForm.getProject() != null && fiForm.getProject().trim().length() != 0) {
					statement.append("  and (pm.proj_id like ? or pm.proj_name like ?) ");
		
					sqlExec.addParam("%" + fiForm.getProject() + "%");
					sqlExec.addParam("%" + fiForm.getProject() + "%");
				}
				
				if (fiForm.getBillAddress() != null && fiForm.getBillAddress().trim().length() != 0) {
					statement.append("  and (p1.party_id like ? or p1.description like ?) ");
		
					sqlExec.addParam("%" + fiForm.getBillAddress() + "%");
					sqlExec.addParam("%" + fiForm.getBillAddress() + "%");
				}
				
				if(projectAssistant != null && !projectAssistant.trim().equals("")){
					statement.append(" and (pm.proj_pa_id like ? or pa.name like ?)");
					sqlExec.addParam("%" + projectAssistant + "%");
					sqlExec.addParam("%" + projectAssistant + "%");
				}
				
				if (fiForm.getStatus() != null && fiForm.getStatus().trim().length() != 0) {
					statement.append("  and pi.inv_status = ? ");
		
					sqlExec.addParam(fiForm.getStatus());
				} else {
					if (process.equals("confirmation")) {
						statement.append("  and (pi.inv_status = ? or pi.inv_status = ?) ");
						sqlExec.addParam(Constants.INVOICE_STATUS_DELIVERED);
						sqlExec.addParam(Constants.INVOICE_STATUS_CONFIRMED);
					}
				}
				
				String PartyListStr = "''";
				List partyList_dep=ph.getAllSubPartysByPartyId(session, fiForm.getDepartment());
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'" + fiForm.getDepartment() + "'";
				while (itdep.hasNext()) {
					Party p =(Party)itdep.next();
					PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
				}
				statement.append("  and p2.party_id in (" + PartyListStr + ") ");
				
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
				statement.append("           pa.name ");
				//order by statement
				statement.append("  order by pi.inv_code ");
				
				log.info(statement.toString());
				request.setAttribute("QueryList", sqlExec.runQueryCloseCon(statement.toString()));
			}
		
			List partyList = null;
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			partyList = ph.getAllSubPartysByPartyId(session, ul.getParty().getPartyId());
			if (partyList == null) partyList = new ArrayList();
			partyList.add(0, ul.getParty());
			
			request.setAttribute("PartyList", partyList);
			
			long timeEnd = System.currentTimeMillis();       //for performance test
			log.info("it takes " + (timeEnd - timeStart) + " ms to excute the query...");
			
			if (fiForm.getFormAction() != null 
			        && (fiForm.getFormAction().equals("add") 
			                || fiForm.getFormAction().equals("OK")
			                || fiForm.getFormAction().equals("dialogView"))) {
				return mapping.findForward("dialogView");
			}
			
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}

		return mapping.findForward("success");
	}
}
