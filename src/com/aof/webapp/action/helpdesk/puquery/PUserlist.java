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

import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.party.ListPartyAction;
import com.aof.webapp.form.helpdesk.UserlistForm;

/** 
 * MyEclipse Struts
 * Creation date: 12-02-2004
 * 
 * XDoclet definition:
 * @struts:action path="Userlist" name="ParlistForm" input="/WEB-INF/jsp/helpdesk/puquery/UserResult.jsp" scope="request"
 * @struts:action-forward name="LIST" path="/WEB-INF/jsp/helpdesk/puquery/UserResult.jsp"
 */
public class PUserlist extends com.shcnc.struts.action.BaseAction {

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
		
		String stype,spartyid,spartyname,susername;
		UserlistForm queryForm = (UserlistForm) form;
		int pageNo=ActionUtils.parseInt(queryForm.getPageNo()).intValue();
		final int pageSize=ActionUtils.parseInt(queryForm.getPageSize()).intValue();
		final Integer integerCount=ActionUtils.parseInt(queryForm.getCount());

		stype=queryForm.getType();
		if (stype==null) stype="";
		spartyname=queryForm.getPartyname();
		susername=queryForm.getUsername();
		
		Logger log = Logger.getLogger(ListPartyAction.class.getName());
		Locale locale = getLocale(request);
		try{
			List result = new ArrayList();
			PartyResult mPs= new PartyResult();		
			if (integerCount==null)
			{
				if(pageNo!=0)throw new RuntimeException("count must have beean computed when not first page");
				//compute count
				final int count=mPs.getPartyUserCount(stype,spartyname,susername);
				final int pageCount=(count-1)/pageSize+1;
				queryForm.setCount(String.valueOf(count));
				//queryForm.setPageCount(String.valueOf(pageCount));
			}
			
			result=mPs.getPartyUser(stype,spartyname,susername,pageNo);
			request.setAttribute("custusers",result);			
		}catch(Exception e){
			
			log.error(e.getMessage());
		}finally{
		}
		
		
		return (mapping.findForward("LIST"));

	}

}