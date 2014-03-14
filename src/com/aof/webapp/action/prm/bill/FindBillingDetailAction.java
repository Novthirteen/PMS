/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.action.prm.bill;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.TimeSheet.TimeSheetMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.bill.*;
import com.aof.webapp.form.prm.bill.FindBillingInstructionForm;

/**
 * @author gus 
 * @version 2005-03-22
 *
 */
public class FindBillingDetailAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	public ActionForward perform(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response) {
		
		//Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(FindBillingInstructionAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		String PID = request.getParameter("pid");
		String Ctgry = request.getParameter("category");
		if (PID == null) PID = "";
		if (Ctgry == null) Ctgry = "";
		
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			if ((PID) != null && Ctgry != null)
			 {
				TransactionServices trs = new TransactionServices();
				List list = trs.findBillingTransactionList(PID, Ctgry);
				if (Constants.TRANSACATION_CATEGORY_EXPENSE.equals(Ctgry)) {
					List list2 = trs.findBillingTransactionList(PID, Constants.TRANSACATION_CATEGORY_OTHER_COST);
					if (list != null) {
						if (list2 != null) {
							list.addAll(list2);
						}
					} else {
						list = list2;
					}
				}
				
				request.setAttribute("readonly", "1");
				
				if (Constants.TRANSACATION_CATEGORY_EXPENSE.equals(Ctgry)) {
					request.setAttribute("ExpenseTransactionList", list);
				}
				
				if (Constants.TRANSACATION_CATEGORY_CAF.equals(Ctgry)) {
					request.setAttribute("CAFTransactionList", list);
				}
				
				if (Constants.TRANSACATION_CATEGORY_ALLOWANCE.equals(Ctgry)) {
					request.setAttribute("AllowanceTransactionList", list);
				}
				
				if (Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE.equals(Ctgry)) {
					request.setAttribute("BillingTransactionList", list);
				}
				
				if (Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT.equals(Ctgry)) {
					request.setAttribute("CreditDownPaymentList", list);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
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
		
		return (mapping.findForward("viewDetail"));
	}
	

}
