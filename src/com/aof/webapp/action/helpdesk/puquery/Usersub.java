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
import com.aof.webapp.form.helpdesk.UsersubForm;

/** 
 * MyEclipse Struts
 * Creation date: 11-18-2004
 * 
 * XDoclet definition:
 * @struts:action path="/Usersub" name="UsersubForm" input="/WEB-INF/jsp/puquery/UserQry.jsp" scope="request" validate="true"
 */
public class Usersub extends com.shcnc.struts.action.BaseAction {

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
		
		UsersubForm UsersubForm = (UsersubForm) form;
		Logger log = Logger.getLogger(ListPartyAction.class.getName());
		Locale locale = getLocale(request);
		try{
			List result = new ArrayList();
//			net.sf.hibernate.Session session = Hibernate2Session.currentSession();
//			Query q = session.createQuery("select p from Party as p inner join p.partyRoles as pr where pr.roleTypeId = 'ORGANIZATION_UNIT'");
//			result = q.list();
//			
//			request.setAttribute("custPartys",result);
//			
//		
			PartyResult mPs= new PartyResult();
			result=mPs.getSelCust(UsersubForm.getType(),UsersubForm.getDesc(),UsersubForm.getName(),UsersubForm.getNote());
			request.setAttribute("custusers",result);
		}catch(Exception e){
			
			log.error(e.getMessage());
		}finally{
		}
		
		
		return (mapping.findForward("OK"));
	}

}