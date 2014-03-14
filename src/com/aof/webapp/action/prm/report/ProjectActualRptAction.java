/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.report;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.prm.Bill.BillTransactionDetail;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;

/**
 * @author Jeffrey Liang 
 * @version 2005-1-12
 *
 */
public class ProjectActualRptAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform (ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
	
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			
			BillTransactionDetail tr = new BillTransactionDetail();
			hs.save(tr);
			
			Hibernate2Session.closeSession();
		}catch(Exception e){
			e.printStackTrace();
		}
		return (mapping.findForward("success"));
	}

}
