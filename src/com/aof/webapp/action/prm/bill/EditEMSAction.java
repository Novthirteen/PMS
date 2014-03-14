/*
 * Created on 2005-4-7
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
import com.aof.component.prm.Bill.EMSService;
import com.aof.component.prm.Bill.ProjectEMS;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bill.EditEMSForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditEMSAction extends BaseAction {
	private Logger log = Logger.getLogger(EditInvoiceAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		EMSService service = new EMSService();
		try {
			EditEMSForm eeForm = (EditEMSForm)form;

			if (eeForm.getFormAction().equals("view")) {			    
			    request.setAttribute("ProjectEMS", service.viewEMS(eeForm.getEmsId()));
			}
			
			if (eeForm.getFormAction().equals("dialogView")) {
				request.setAttribute("ProjectEMS", service.viewEMS(eeForm.getEmsId()));
				return mapping.findForward("dialogView");
			}
			
			if (eeForm.getFormAction().equals("new")) {
				ProjectEMS pe = convertFormToModel(service, eeForm);
				UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				service.newEMS(pe, ul);
				request.setAttribute("ProjectEMS", pe);
			}
			
			if (eeForm.getFormAction().equals("update")) {
				ProjectEMS pe = convertFormToModel(service, eeForm);
				service.updateEMS(pe);
				request.setAttribute("ProjectEMS", pe);
			}
			
			if (eeForm.getFormAction().equals("delete")) {
				service.removeEMS(eeForm.getEmsId());
				return mapping.findForward("list");
			}
			
			if (eeForm.getFormAction().equals("deleteInvoice")) {
				service.deleteFormEMS(eeForm.getInvoiceId(), eeForm.getEmsId());
				request.setAttribute("ProjectEMS", service.viewEMS(eeForm.getEmsId()));
			}
			
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
		    service.closeSession();
		}
		
		return mapping.findForward("success");
	}
	
	private ProjectEMS convertFormToModel(EMSService service, EditEMSForm eeForm) {
		ProjectEMS pe = null;
		
		if (eeForm.getEmsId() != null && eeForm.getEmsId().longValue() > 0L) {
			pe = service.viewEMS(eeForm.getEmsId());
		} else {
			pe = new ProjectEMS();
		}
		
		if (eeForm.getEmsType() != null) {
			pe.setType(eeForm.getEmsType());
		}
		
		if (eeForm.getEmsNo() != null) {
			pe.setNo(eeForm.getEmsNo());
		}
		
		if (eeForm.getEmsDate() != null) {
			java.util.Date emsDate = UtilDateTime.toDate2(eeForm.getEmsDate() + " 00:00:00.000");
			pe.setEmsDate(emsDate);
		}
		
		if (eeForm.getEmsNote() != null) {
			pe.setNote(eeForm.getEmsNote().trim());
		}
		
		return pe;
	}
	
}
