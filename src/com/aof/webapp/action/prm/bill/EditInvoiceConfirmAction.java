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

import net.sf.hibernate.HibernateException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.InvoiceService;
import com.aof.component.prm.Bill.ProjectInvoice;
import com.aof.component.prm.Bill.ProjectInvoiceConfirmation;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bill.EditInvoiceConfirmForm;
import com.aof.webapp.form.prm.bill.EditInvoiceForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditInvoiceConfirmAction extends BaseAction {
	private Logger log = Logger.getLogger(EditInvoiceAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		InvoiceService service = new InvoiceService();
		try {
			EditInvoiceConfirmForm eicForm = (EditInvoiceConfirmForm)form;
			
			
			if (eicForm.getFormAction().equals("view")) {
				request.setAttribute("Currency", service.getAllCurrency());			
				request.setAttribute("InvoiceConfirmation", service.viewInvoiceConfirmation(eicForm.getConfirmId()));
			}
			
			if (eicForm.getFormAction().equals("edit")) {
				ProjectInvoiceConfirmation pic = convertFormToModel(service, eicForm);
				UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				service.editInvoiceConfirmation(pic, ul);
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
	
	private ProjectInvoiceConfirmation convertFormToModel(InvoiceService service, EditInvoiceConfirmForm eicForm) throws HibernateException {
		ProjectInvoiceConfirmation pic = null;
		
		if (eicForm.getConfirmId() != null && eicForm.getConfirmId().longValue() > 0L) {
			pic = service.viewInvoiceConfirmation(eicForm.getConfirmId());
		} else {
			pic = new ProjectInvoiceConfirmation();
		}
		
		if (eicForm.getInvoiceId() != null) {
			pic.setInvoice(service.viewInvoice(eicForm.getInvoiceId()));
		}
		
		if (eicForm.getContactor() != null) {
			pic.setContactor(eicForm.getContactor());
		}
		
		if (eicForm.getResponsiblePerson() != null) {
			pic.setResponsiblePersonId(eicForm.getResponsiblePerson());
		}
		
		if (eicForm.getContactDate() != null) {
			java.util.Date contactDate = UtilDateTime.toDate2(eicForm.getContactDate() + " 00:00:00.000");
			pic.setContactDate(contactDate);
		}
		
		if (eicForm.getPayAmount() != null) {
			pic.setPayAmount(eicForm.getPayAmount());
		}
		
		if (eicForm.getPayDate() != null) {
			if (eicForm.getPayDate().trim().length() != 0) {
				java.util.Date payDate = UtilDateTime.toDate2(eicForm.getPayDate() + " 00:00:00.000");
				pic.setPayDate(payDate);
			} else {
				pic.setPayDate(null);
			}
		}
		
		if (eicForm.getNote() != null) {
			pic.setNote(eicForm.getNote());
		}
		
		if (eicForm.getCurrency() != null) {
			pic.setCurrencyId(eicForm.getCurrency());
		}
		
		return pic;
	}
}
