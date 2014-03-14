/*
 * Created on 2005-4-11
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.bill;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.util.Constants;
import com.aof.webapp.form.prm.bill.FindInvoiceForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindInvoiceConfirmAction extends FindInvoiceAction {
	
	private Logger log = Logger.getLogger(FindInvoiceConfirmAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		FindInvoiceForm fiForm = (FindInvoiceForm)form;
		request.setAttribute("process", "confirmation");
		return super.perform(mapping, form, request, response);
	}
}
