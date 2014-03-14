/*
 * Created on 2005-6-7
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.payment;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.util.Constants;
import com.aof.webapp.action.prm.bill.FindBillingInstructionAction;
import com.aof.webapp.action.prm.bill.FindDownpaymentInstruction;

/**
 * @author gus
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindPaymentDownpaymentInstructionAction extends
		FindPaymentInstructionAction {


	private Logger log = Logger.getLogger(FindDownpaymentInstruction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		request.setAttribute("PaymentType", Constants.PAYMENT_TYPE_DOWN_PAYMENT);
		return super.perform(mapping, form, request, response);
	}

}
