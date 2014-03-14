//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk.puquery;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.party.ListPartyAction;
import com.aof.webapp.form.helpdesk.PartysubForm;

/** 
 * MyEclipse Struts
 * Creation date: 11-17-2004
 * 
 * XDoclet definition:
 * @struts:action path="/Partysub" name="PartysubForm" input="/WEB-INF/jsp/puquery/ParQry.jsp" scope="request" validate="true"
 * @struts:action-forward name="OK" path="/WEB-INF/jsp/puquery/PartyResult.jsp" contextRelative="true"
 */
public class Partysub extends com.shcnc.struts.action.BaseAction {

	// --------------------------------------------------------- Instance Variables

	// --------------------------------------------------------- Methods

	/** 
	 * Method execute
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return ActionForward
	 */
	public ActionForward execute(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		
		PartysubForm PartysubForm = (PartysubForm) form;
		Logger log = Logger.getLogger(ListPartyAction.class.getName());
		Locale locale = getLocale(request);
		String sChoice= PartysubForm.getChoice().trim();
		if (sChoice.equals("1")) 
			return (mapping.findForward("OK"));
		else
			if (sChoice.equals("2")) 
				return (mapping.findForward("CUSTOM"));
			else
				return (mapping.findForward("PARTYGET"));

	}

}