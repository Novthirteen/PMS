/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
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
import com.aof.component.prm.Bill.BillInstructionService;
import com.aof.component.prm.Bill.InvoiceService;
import com.aof.component.prm.Bill.ProjectInvoice;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bill.EditInvoiceForm;

/**
 * @author Jackey Ding 
 * @version 2005-03-31
 *
 */
public class EditInvoiceAction extends BaseAction {
	
	private Logger log = Logger.getLogger(EditInvoiceAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		InvoiceService service = new InvoiceService();
		
		try {
			EditInvoiceForm eiForm = (EditInvoiceForm)form;
			
			String action = request.getParameter("action");
			String dataId = request.getParameter("DataId");
			if(action == null) action = "";
			if(dataId == null) dataId = "";
			if(action.equalsIgnoreCase("dialogView") && !dataId.trim().equals("")){
				request.setAttribute("Currency", service.getAllCurrency());			
				request.setAttribute("ProjectInvoice", service.viewInvoice(dataId));
				return mapping.findForward("dialogView");
			}
 			
			if (eiForm.getFormAction().equals("view")) {
				if (eiForm.getBillId() != null) {
					BillInstructionService biService = new BillInstructionService();
					request.setAttribute("ProjectBill", biService.viewBillingInstruction(eiForm.getBillId()));
				}
				request.setAttribute("Currency", service.getAllCurrency());			
				request.setAttribute("ProjectInvoice", service.viewInvoice(eiForm.getInvoiceId()));
			}
			
			if (eiForm.getFormAction().equals("dialogView")) {
				request.setAttribute("Currency", service.getAllCurrency());			
				request.setAttribute("ProjectInvoice", service.viewInvoice(eiForm.getInvoiceId()));
				return mapping.findForward("dialogView");
			}
			
			if (eiForm.getFormAction().equals("new")) {
				ProjectInvoice pi = convertFormToModel(service, eiForm);
				UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				if (service.checkAmount(pi)) {
					Long invoiceId = service.newInvoice(pi, ul);
				} else {
					service.setProject(pi);
					service.setBillAddress(pi);
					service.setCurrency(pi);
					service.setBilling(pi);
					request.setAttribute("ErrorMessage", "Entry Amount can not be large than Remaining Amount!!!");
				}
				
				request.setAttribute("Currency", service.getAllCurrency());
				request.setAttribute("ProjectInvoice", pi);
			}
			
			if (eiForm.getFormAction().equals("update")) {
				ProjectInvoice pi = convertFormToModel(service, eiForm);
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
			
			if (eiForm.getFormAction().equals("delete")) {
				ProjectInvoice pi = convertFormToModel(service, eiForm);
				service.deleteInvoice(pi.getId());
				return mapping.findForward("list");
			}
			
			if (eiForm.getFormAction().equals("cancel")) {
				service.cancelInvoice(eiForm.getInvoiceId());
				request.setAttribute("Currency", service.getAllCurrency());			
				request.setAttribute("ProjectInvoice", service.viewInvoice(eiForm.getInvoiceId()));
				//return mapping.findForward("list");
			}
			
			if (eiForm.getFormAction().equals("confirm")) {
				service.confirmInvoice(eiForm.getInvoiceId());
				request.setAttribute("Currency", service.getAllCurrency());			
				request.setAttribute("ProjectInvoice", service.viewInvoice(eiForm.getInvoiceId()));
			}
			
			if (eiForm.getFormAction().equals("add") || eiForm.getFormAction().equals("OK")) {
				String[] invoiceIdStr = request.getParameterValues("invoiceId");
				Long[] invoiceIdL = null;
				if (invoiceIdStr != null) {
					invoiceIdL = new Long[invoiceIdStr.length];
					for (int i0 = 0; i0 < invoiceIdStr.length; i0++) {
						invoiceIdL[i0] = new Long(invoiceIdStr[i0]);
					}
				}
				
				service.addToEMS(invoiceIdL, eiForm.getEmsId());				
				return mapping.findForward("list");				
			}
			
			if (eiForm.getFormAction().equals("deleteConfirm")) {
				ProjectInvoice pi = convertFormToModel(service, eiForm);
				service.deleteConfirmation(pi, eiForm.getConfirmId());
				request.setAttribute("Currency", service.getAllCurrency());			
				request.setAttribute("ProjectInvoice", service.viewInvoice(eiForm.getInvoiceId()));
			}
			
			if (eiForm.getFormAction().equals("deleteReceipt")) {
				ProjectInvoice pi = convertFormToModel(service, eiForm);
				service.deleteReceipt(pi, eiForm.getReceiptId());
				request.setAttribute("Currency", service.getAllCurrency());			
				request.setAttribute("ProjectInvoice", service.viewInvoice(eiForm.getInvoiceId()));
			}
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
		    service.closeSession();
		}
		
		return mapping.findForward("success");
	}
	
	private ProjectInvoice convertFormToModel(InvoiceService service, EditInvoiceForm eiForm) {
		
		ProjectInvoice pi = null;
		
		if (eiForm.getInvoiceId() != null) {	
			pi = service.viewInvoice(eiForm.getInvoiceId());				
		} else {
			pi = new ProjectInvoice();
		}
		
		pi.setInvoiceType(Constants.INVOICE_TYPE_NORMAL);
		
		if (eiForm.getInvoiceCode() != null) {
			pi.setInvoiceCode(eiForm.getInvoiceCode());
		}
		
		if (eiForm.getProjectId() != null) {
			pi.setProjectId(eiForm.getProjectId());
		}
		
		if (eiForm.getBillAddressId() != null) {
			pi.setBillAddressId(eiForm.getBillAddressId());
		}
		
		if (eiForm.getCurrency() != null) {
			pi.setCurrencyId(eiForm.getCurrency());
		}
		
		if (eiForm.getCurrencyRate() != null) {
			pi.setCurrencyRate(eiForm.getCurrencyRate());
		}
		
		if (eiForm.getAmount() != null) {
			pi.setAmount(eiForm.getAmount());
		}
		
		if (eiForm.getInvoiceDate() != null) {
			java.util.Date invoiceDate = UtilDateTime.toDate2(eiForm.getInvoiceDate() + " 00:00:00.000");
			pi.setInvoiceDate(invoiceDate);
		}
		
		if (eiForm.getNote() != null) {
			pi.setNote(eiForm.getNote().trim());
		}
		
		if (eiForm.getBillId() != null) {
			pi.setBillId(eiForm.getBillId());
		}
		
		if (eiForm.getEmsId() != null) {
			pi.setEmsId(eiForm.getEmsId());
		}
		
		if (eiForm.getInvoiceType() != null) {
			pi.setInvoiceType(eiForm.getInvoiceType());
		}
		
		return pi;
	}
}
