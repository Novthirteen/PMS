/*
 * Created on 2005-5-8
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
import com.aof.component.prm.Bill.ProjectInvoice;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bill.EditLostRecordForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditLostRecordAction extends BaseAction {
	private Logger log = Logger.getLogger(EditLostRecordAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		InvoiceService service = new InvoiceService();
		
		try {
			EditLostRecordForm elrForm = (EditLostRecordForm)form;
			
			if (elrForm.getFormAction().equals("view")) {
				request.setAttribute("Currency", service.getAllCurrency());			
				request.setAttribute("ProjectInvoice", service.viewInvoice(elrForm.getLostRecordId()));
			}
			
			if (elrForm.getFormAction().equals("new")) {
				ProjectInvoice pi = convertFormToModel(service, elrForm);
				UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				if (service.checkAmount(pi)) {
					Long invoiceId = service.newInvoice(pi, ul);
				} else {
					service.setProject(pi);
					service.setCurrency(pi);
					service.setBilling(pi);
					request.setAttribute("ErrorMessage", "Entry Amount can not be large than Remaining Amount!!!");
				}
				
				request.setAttribute("Currency", service.getAllCurrency());
				request.setAttribute("ProjectInvoice", pi);
			}
			
			if (elrForm.getFormAction().equals("update")) {
				ProjectInvoice pi = convertFormToModel(service, elrForm);
				if (service.checkAmount(pi)) {
					service.updateInvoice(pi);
				} else {
					service.setBillAddress(pi);
					service.setCurrency(pi);
					service.setEms(pi);
					request.setAttribute("ErrorMessage", "Entry Amount can not be large than Remaining Amount!!!");
				}
				request.setAttribute("Currency", service.getAllCurrency());
				request.setAttribute("ProjectInvoice", pi);
			}
			if (elrForm.getFormAction().equals("confirm")) {
				ProjectInvoice pi = convertFormToModel(service, elrForm);
				if(service.checkAmount(pi))
					pi.setStatus("Confirmed");
				service.updateInvoice(pi);
				request.setAttribute("Currency", service.getAllCurrency());
				request.setAttribute("ProjectInvoice", pi);
			}			
			if (elrForm.getFormAction().equals("delete")) {
				ProjectInvoice pi = convertFormToModel(service, elrForm);
				service.deleteInvoice(pi.getId());
				return mapping.findForward("list");
			}
			
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
		    service.closeSession();
		}
		
		return mapping.findForward("success");
	}
	
	private ProjectInvoice convertFormToModel(InvoiceService service, EditLostRecordForm elrForm) {
		
		ProjectInvoice pi = null;
		
		if (elrForm.getLostRecordId() != null) {	
			pi = service.viewInvoice(elrForm.getLostRecordId());				
		} else {
			pi = new ProjectInvoice();
		}
		
		pi.setInvoiceType(Constants.INVOICE_TYPE_LOST_RECORD);
		
		if (elrForm.getProjectId() != null) {
			pi.setProjectId(elrForm.getProjectId());
		}
		
		if (elrForm.getCurrency() != null) {
			pi.setCurrencyId(elrForm.getCurrency());
		}
		
		if (elrForm.getExchangeRate() != null) {
			pi.setCurrencyRate(elrForm.getExchangeRate());
		}

		if (elrForm.getAmount() != null) {
			pi.setAmount(elrForm.getAmount());
		}
		
		if (elrForm.getNote() != null) {
			pi.setNote(elrForm.getNote().trim());
		}
		
		if (elrForm.getBillId() != null) {
			pi.setBillId(elrForm.getBillId());
		}

		return pi;
	}
}
