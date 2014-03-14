/*
 * Created on 2006-2-16
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.payment;

import java.sql.SQLException;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.prm.payment.PaymentMasterService;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindInvoiceDialogAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	public ActionForward perform(ActionMapping mapping, 
	                             ActionForm form, 
	                             HttpServletRequest request, 
	                             HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String invId = request.getParameter("invId");
		
		try{
		    net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			if ((invId) != null)
			{
				PaymentMasterService service = new PaymentMasterService(); 
				service.getSupplierInvoiceList(request, invId);
				
				request.setAttribute("readonly", "1");	
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}		
		}
		return (mapping.findForward("viewDetail"));
    }
}
