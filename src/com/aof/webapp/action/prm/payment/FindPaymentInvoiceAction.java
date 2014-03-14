/*
 * Created on 2005-6-28
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.payment;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;
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
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.bill.FindInvoiceAction;
import com.aof.webapp.form.prm.bill.FindInvoiceForm;
import com.aof.webapp.form.prm.payment.FindPaymentInvoiceForm;

/**
 * @author angus
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindPaymentInvoiceAction extends BaseAction {

	
	private Logger log = Logger.getLogger(FindPaymentInvoiceAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		try {
			long timeStart = System.currentTimeMillis();
			String offSetStr = request.getParameter("offSet");
			String recordPerPageStr = request.getParameter("recordPerPage");
			
			int offSet = 0;
			int recordPerPage = 20;
			
			if (offSetStr != null && offSetStr.trim().length() != 0) {
				offSet = Integer.parseInt(offSetStr);
			}
			if (recordPerPageStr != null && recordPerPageStr.trim().length() != 0) {
				recordPerPage = Integer.parseInt(recordPerPageStr);
			}
			
			//FindInvoiceForm fiForm = (FindInvoiceForm)form;
			FindPaymentInvoiceForm fiForm = (FindPaymentInvoiceForm)form;
			if (fiForm.getDepartment() == null) {
				UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				if (userLogin != null) {
					fiForm.setDepartment(userLogin.getParty().getPartyId());
				}
			}
			
			//String process = (String)request.getAttribute("process");
			//if (process == null) {
			//	process = "maintenance";
			//}
			//request.setAttribute("process", process);
			
			SQLExecutor sqlExec = new SQLExecutor(
					Persistencer.getSQLExecutorConnection(
							EntityUtil.getConnectionByName("jdbc/aofdb")));
			
			StringBuffer statement = new StringBuffer("");
			//select statement

			statement.append("select 	pcm.costcode as inv_id, ");
			statement.append("			pcm.refno as inv_code, ");
			statement.append("			pcm.pay_id, ");
			statement.append("			pcm.formcode, ");
			statement.append("			pp.pay_code, ");
			statement.append("			pp.pay_type,");
			statement.append("			pm.proj_id,");
			statement.append("			pm.proj_name as proj_name,");
			statement.append("			v.party_id as payAddrId,");
			statement.append("			p.description as payAddr,");
			statement.append("			p1.party_id as depId,");
			statement.append("			p1.description as dep,");
			statement.append("			pcm.currency,");
			statement.append("			pcm.totalvalue as inv_amount,");
	//	-- received amount
			statement.append("			pcm.payment_status as inv_status,");
			statement.append("			pcm.payment_type as inv_type,");
			statement.append("			pcm.costdate as inv_invoicedate,");
			statement.append("			pcm.createdate as inv_createdate, ");
			statement.append("			pcm.costdate as inv_paydate, ");
			statement.append("			pcm.modifydate as inv_modifydate ");
			//from setatement
			statement.append("from proj_cost_mstr as pcm ");
			statement.append(" inner join proj_payment as pp on pp.pay_id = pcm.pay_id");
			statement.append(" inner join proj_mstr as pm on pm.proj_id = pp.pay_proj_id");
			statement.append(" inner join vendorprofile as v on v.party_id = pcm.vendoraddr");
			statement.append(" inner join party as p on p.party_id = v.party_id");
			statement.append(" inner join party as p1 on p1.party_id = pm.dep_id");
															
			
			//where statement
			statement.append("  where pcm.payment_type = ? ");
			sqlExec.addParam(Constants.PAYMENT_INVOICE_TYPE_NORMAL);
			
			if (fiForm.getInvoice() != null && fiForm.getInvoice().trim().length() != 0) {
				statement.append("  and pcm.refno like ? ");
				sqlExec.addParam("%" + fiForm.getInvoice() + "%");
			}
			
			if (fiForm.getPayment() != null && fiForm.getPayment().trim().length() != 0) {
				statement.append("  and pp.pay_code like ? ");
				sqlExec.addParam("%" + fiForm.getPayment() + "%");
			}
			
			if (fiForm.getProject() != null && fiForm.getProject().trim().length() != 0) {
				statement.append("  and (pm.proj_id like ? or pm.proj_name like ?) ");

				sqlExec.addParam("%" + fiForm.getProject() + "%");
				sqlExec.addParam("%" + fiForm.getProject() + "%");
			}
			
			if (fiForm.getPayAddress() != null && fiForm.getPayAddress().trim().length() != 0) {
				statement.append("  and (v.party_id like ? or p.description like ?) ");

				sqlExec.addParam("%" + fiForm.getPayAddress() + "%");
				sqlExec.addParam("%" + fiForm.getPayAddress() + "%");
			}
			
			if (fiForm.getStatus() != null && fiForm.getStatus().trim().length() != 0) {
				statement.append("  and pcm.payment_status = ? ");

				sqlExec.addParam(fiForm.getStatus());
			} else {

					statement.append("  and (pcm.payment_status = ? or pcm.payment_status = ? or pcm.payment_status = ?) ");
					sqlExec.addParam(Constants.PAYMENT_INVOICE_STATUS_DRAFT);
					sqlExec.addParam(Constants.PAYMENT_INVOICE_STATUS_CONFIRMED);
					sqlExec.addParam(Constants.PAYMENT_INVOICE_STATUS_CANCELED);
			}
			
			Session session = Hibernate2Session.currentSession();
			PartyHelper ph = new PartyHelper();
			String PartyListStr = "''";
			List partyList_dep=ph.getAllSubPartysByPartyId(session, fiForm.getDepartment());
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'" + fiForm.getDepartment() + "'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
			statement.append("  and p1.party_id in (" + PartyListStr + ") ");
			
			//group by statement
			statement.append("group by 	pcm.costcode, ");
			statement.append("			pcm.refno, ");
			statement.append("			pcm.pay_id, ");
			statement.append("			pcm.formcode, ");
			statement.append("			pp.pay_code, ");
			statement.append("			pp.pay_type,");
			statement.append("			pm.proj_id,");
			statement.append("			pm.proj_name,");
			statement.append("			v.party_id,");
			statement.append("			p.description,");
			statement.append("			p1.party_id,");
			statement.append("			p1.description,");
			statement.append("			pcm.currency,");
			statement.append("			pcm.totalvalue,");
	//	-- received amount
			statement.append("			pcm.payment_type,");
			statement.append("			pcm.payment_status,");
			statement.append("			pcm.costdate,");
			statement.append("			pcm.createdate,");
			statement.append("			pcm.costdate,");
			statement.append("			pcm.modifydate");
			//order by statement
			statement.append("  order by pcm.costcode ");
			
			log.info(statement.toString());
			request.setAttribute("QueryList", sqlExec.runQueryCloseCon(statement.toString()));
		
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
