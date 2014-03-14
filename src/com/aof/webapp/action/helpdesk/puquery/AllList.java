//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk.puquery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.webapp.form.helpdesk.AllListForm;

/** 
 * MyEclipse Struts
 * Creation date: 12-20-2004
 * 
 * XDoclet definition:
 * @struts:action path="/AllList" name="AllListForm" input="/WEB-INF/jsp/helpdesk/puquery/UserResult.jsp" scope="request" validate="true"
 */
public class AllList extends Action {

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
		AllListForm AllListForm = (AllListForm) form;
		throw new UnsupportedOperationException(
			"Generated method 'execute(...)' not implemented.");
	}

}