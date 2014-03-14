/*
 * Created on 2005-5-23
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.payment;

import java.sql.SQLException;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.prm.Bill.TransactionServices;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.bill.FindBillingInstructionAction;

/**
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindPaymentDetailAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	public ActionForward perform(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response) {
		
		//Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(FindPaymentInstructionAction.class.getName());
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
				List list = trs.findPaymentTransactionList(PID, Ctgry);
				if (Constants.TRANSACATION_CATEGORY_EXPENSE.equals(Ctgry)) {
					List list2 = trs.findPaymentTransactionList(PID, Constants.TRANSACATION_CATEGORY_OTHER_COST);
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
				
				if (Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE.equals(Ctgry)) {
					//request.setAttribute("BillingTransactionList", list);
					request.setAttribute("PaymentTransactionList", list);
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
