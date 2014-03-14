/*
 * Created on 2006-3-15
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.bid;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Session;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.CallService;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class NotifyCreateCustomerAction extends BaseAction {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
	HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String formAction = request.getParameter("formAction");
		String emailAddr = request.getParameter("emailAddr");
		String targetName = request.getParameter("targetName");
		String custName = request.getParameter("custName");
		String chnName = request.getParameter("chnName");
		String address = request.getParameter("address");
		String industry = request.getParameter("industry");
		
		if(formAction==null)	formAction = "view";
		if(emailAddr==null)		emailAddr = "";
		if(targetName==null)	targetName = "";
		if(custName==null)	custName = "";
		if(chnName==null)	chnName = "";
		if(address==null)	address = "";
		if(industry==null)	industry = "";
		
	    UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		
	    if(formAction.equals("view")){
	    	Session session = Hibernate2Session.currentSession();
	    	List list = session.find("from Industry");
	    	request.setAttribute("resultList", list);
	    }
	    
		if(formAction.equals("submit")){
			CallService emailService = new CallService();
			emailService.notifyCreateCustomer(emailAddr, targetName, ul.getName(), custName, chnName, address, industry);
			request.setAttribute("toClose", "toClose");
		}
		
		return mapping.findForward("success");
	}
}
