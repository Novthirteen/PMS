/*
 * Created on 2006-1-10
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.payment;

import java.text.ParseException;
import java.util.Date;
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
import com.aof.component.prm.payment.PaymentInstructionService;
import com.aof.component.prm.payment.ProjPaymentTransaction;
import com.aof.component.prm.payment.ProjectPayment;
import com.aof.component.prm.payment.ProjectPaymentMaster;
import com.aof.component.prm.project.CurrencyType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.GeneralException;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.payment.SettleSupplierInvoiceForm;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class PaymentSettlementAction extends BaseAction {
	private Logger log = Logger.getLogger(PaymentSettlementAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		PaymentInstructionService service = new PaymentInstructionService();
		
		try {
			SettleSupplierInvoiceForm siForm = (SettleSupplierInvoiceForm)form;
			
			if (siForm.getFormAction().equals("view")) {
				request.setAttribute("paymentId", new Long(Long.parseLong(request.getParameter("paymentId"))));
				if(request.getParameter("tranId")!=null){
					request.setAttribute("tranId", new Long(Long.parseLong(request.getParameter("tranId"))));
				}
				request.setAttribute("Currency", service.getAllCurrency());
			}
			
			if (siForm.getFormAction().equals("save")) {
				UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				ProjPaymentTransaction ppt = convertFormToModel(service, siForm, ul);
				ProjectPayment pp = service.viewPaymentInstruction(new Long(Long.parseLong(request.getParameter("paymentId"))));
				service.addPaymentSettlement(pp, ppt);
				request.setAttribute("toClose", "y");
				request.setAttribute("Currency", service.getAllCurrency());
			}
			
			if(siForm.getFormAction().equals("update")){
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				ProjPaymentTransaction ppt = (ProjPaymentTransaction)hs.load(ProjPaymentTransaction.class, new Long(Long.parseLong(request.getParameter("tranId"))));
				service.updatePaymentSettlement(ppt, request.getParameter("settleAmt"), request.getParameter("note"));
				request.setAttribute("toClose", "y");
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
	
	private ProjPaymentTransaction convertFormToModel(PaymentInstructionService service, SettleSupplierInvoiceForm siForm, UserLogin ul) 
	throws GeneralException, HibernateException, ParseException{
		ProjPaymentTransaction ppt = new ProjPaymentTransaction();
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		
	    if (siForm.getInvCode() != null && !siForm.getInvCode().equals("")) {
	    	ProjectPaymentMaster ppm = (ProjectPaymentMaster)hs.load(ProjectPaymentMaster.class, siForm.getInvCode());
	        ppt.setInvoice(ppm);
	    }
	    
	    ProjectPayment pp = (ProjectPayment)hs.load(ProjectPayment.class, new Long(siForm.getPaymentId())); 
	    ppt.setPayment(pp);
	    
	    ppt.setAmount(new Double(siForm.getAmt()));
	    	    
	    if (siForm.getCurrency() != null) {
	    	CurrencyType c = (CurrencyType)hs.load(CurrencyType.class, siForm.getCurrency());
	        ppt.setCurrency(c);
	    }
	    
	    ppt.setCurrRate(new Float(siForm.getRate()));
	    
	    if (siForm.getNote() != null) {
	        ppt.setNote(siForm.getNote());
	    }
	    
	    ppt.setAmount(new Double(siForm.getSettleAmt()));
	    ppt.setCreateUser(ul);
	    ppt.setCreateDate(new Date());
	    
	    if(siForm.getPayDate() != null){
	    	Date payDate = UtilDateTime.toDate2(siForm.getPayDate()+" 00:00:00.000");
	    	ppt.setPayDate(payDate);
	    }
	    
	    if(ppt.getPostStatus()==null){
	    	ppt.setPostStatus(Constants.POST_PAYMENT_TRANSACTION_STATUS_DRAFT);
	    }
	    
	    return ppt;
	}
}
