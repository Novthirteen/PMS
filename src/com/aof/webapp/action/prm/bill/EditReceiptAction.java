/*
 * Created on 2005-4-12
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.bill;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.InvoiceService;
import com.aof.component.prm.Bill.ProjectReceipt;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bill.EditReceiptForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditReceiptAction extends BaseAction {
	private Logger log = Logger.getLogger(EditReceiptAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		InvoiceService service = new InvoiceService();
		try {
		    EditReceiptForm erForm = (EditReceiptForm)form;
			
			
			if (erForm.getFormAction().equals("view") || erForm.getFormAction().equals("dialogView")) {
				request.setAttribute("Currency", service.getAllCurrency());			
				request.setAttribute("Receipt", service.viewReceipt(erForm.getReceiptId()));
			}
			
			if (erForm.getFormAction().equals("edit")) {
				ProjectReceipt pr = convertFormToModel(service, erForm);
				UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				service.editReceipt(pr, ul);
				request.setAttribute("Currency", service.getAllCurrency());
			}
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
		    service.closeSession();
		}
		
		return mapping.findForward("success");
	}
	
	private ProjectReceipt convertFormToModel(InvoiceService service, EditReceiptForm erForm) {
	    ProjectReceipt pr = null;
	    
	    if (erForm.getReceiptId() != null && erForm.getReceiptId().longValue() > 0L) {
	        pr = service.viewReceipt(erForm.getReceiptId());
	    }
	    
	    if (pr == null) {
	        pr = new ProjectReceipt();
	    }
	    
	    if (erForm.getReceiptNo() != null) {
	        pr.setReceiptNo(erForm.getReceiptNo());
	    }
	    
	    if (erForm.getInvoiceId() != null) {
	        pr.setInvoiceId(erForm.getInvoiceId());
	    }
	    
	    if (erForm.getReceiveAmount() != null) {
	        pr.setReceiveAmount(erForm.getReceiveAmount());
	    }
	    
	    if (erForm.getCurrency() != null) {
	        pr.setCurrencyId(erForm.getCurrency());
	    }
	    
	    if (erForm.getCurrencyRate() != null) {
	    	pr.setCurrencyRate(erForm.getCurrencyRate());
	    }
	    
	    if (erForm.getReceiveDate() != null) {
	        java.util.Date receiveDate = UtilDateTime.toDate2(erForm.getReceiveDate() + " 00:00:00.000");
	        pr.setReceiveDate(receiveDate);
	    }
	    
	    if (erForm.getNote() != null) {
	        pr.setNote(erForm.getNote());
	    }
	    
	    return pr;
	}
}
