/**
 * 
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
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.bill.FindBillingInstructionAction;


/**
 * @author CN01449
 *
 */
public class FindCheckBillingAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	public ActionForward perform(ActionMapping mapping, 
	                             ActionForm form, 
	                             HttpServletRequest request, 
	                             HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log =Logger.getLogger(FindPaymentInstructionAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String PID = request.getParameter("pid");
		
		try{
		    net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			if ((PID) != null)
			{
				TransactionServices trs = new TransactionServices();
				ProjectMaster project = (ProjectMaster)hs.load(ProjectMaster.class, PID);
				ProjectMaster parentProject = project.getParentProject();
				trs.findCheckBillingTransactionList(request, parentProject.getProjId());
				
				request.setAttribute("readonly", "1");	
			}
		}catch(Exception e){
			e.printStackTrace();
			log.error(e.getMessage());	
		}finally{
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
