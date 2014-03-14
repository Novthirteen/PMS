//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk.puquery;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.party.ListPartyAction;
import com.aof.webapp.form.helpdesk.ParlistForm;
/** 
 * MyEclipse Struts
 * Creation date: 11-30-2004
 * 
 * XDoclet definition:
 * @struts:action validate="true"
 * @struts:action-forward name="LIST" path="/WEB-INF/jsp/helpdesk/puquery/PartyResult.jsp"
 */
public class Parlist extends com.shcnc.struts.action.BaseAction {

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
		
		String stype,sdesc,slink,saddr;
//		stype=request.getParameter("type");
//		if (stype==null) stype="";
//		sdesc=request.getParameter("desc");
//		if (sdesc==null) sdesc="";
//		slink=request.getParameter("link");
//		if (slink==null) slink="";
//		saddr=request.getParameter("addr");
//		if (saddr==null) saddr="";
		ParlistForm queryForm=(ParlistForm) form;
		int pageNo=ActionUtils.parseInt(queryForm.getPageNo()).intValue();
		final int pageSize=ActionUtils.parseInt(queryForm.getPageSize()).intValue();
		final Integer integerCount=ActionUtils.parseInt(queryForm.getCount());
		
		stype=queryForm.getType();
		if (stype==null) stype="";
		sdesc=queryForm.getDesc();
		slink=queryForm.getRelation();
		saddr=queryForm.getAddr();
		
		//queryForm.setCount("3");
		//queryForm.setPageCount("10");
		Logger log = Logger.getLogger(ListPartyAction.class.getName());
		try{
			List result = new ArrayList();
			PartyResult mPs= new PartyResult();		
			if (integerCount==null)
			{
				if(pageNo!=0)throw new RuntimeException("count must have beean computed when not first page");
				//compute count
				final int count=mPs.GetPartySelectCount(stype,sdesc,slink,saddr);
				final int pageCount=(count-1)/pageSize+1;
				queryForm.setCount(String.valueOf(count));
				//queryForm.setPageCount(String.valueOf(pageCount));
			}		
			
			result=mPs.getPartySelectPage(stype,sdesc,slink,saddr,pageNo);
			request.setAttribute("custPartys",result);
		}catch(Exception e){
			log.error(e.getMessage());
		}finally{
		}
		
		//return mapping.getInputForward();
		return (mapping.findForward("LIST"));
	}

}