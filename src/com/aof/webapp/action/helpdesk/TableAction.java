//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyServices;
import com.aof.component.helpdesk.CustConfigService;
import com.aof.component.helpdesk.CustConfigTable;
import com.aof.component.helpdesk.CustConfigTableType;
import com.aof.component.helpdesk.CustConfigTableTypeService;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;
import com.shcnc.struts.form.BeanActionForm;

/** 
 * MyEclipse Struts
 * Creation date: 11-22-2004
 * 
 * XDoclet definition:
 * @struts:action parameter="list"
 */
public class TableAction extends com.shcnc.struts.action.BaseAction {

	// --------------------------------------------------------- Instance Variables

	// --------------------------------------------------------- Methods

	/** 
	 * Method execute
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return ActionForward
	 * @throws HibernateException
	 */
	public ActionForward execute(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) throws HibernateException {

		final String action=mapping.getParameter();

		//String name=null;
		/*String companyID=null;
		Integer tableID=null;
		if(action.equals(LIST))
		{
			companyID=request.getParameter("company");
			if(companyID==null)
			{
				throw new ActionException(ActionUtils.ERROR_PARA_NOT_SET,"company");
			}
		}
		if(action.equals(VIEW))
		{
			tableID=ActionUtils.parseInt(request.getParameter("table"));
			if(tableID==null)
			{
				throw new ActionException(ActionUtils.ERROR_ID_INT,"table");
			}
		}*/
		
		if(action.equals(NEW))
		{
			return newTable(mapping,form,request,response);
		}
		else if(action.equals(INSERT))
		{
			return insert(mapping,form,request,response);
		}
		else if(action.equals(LIST))
		{
			return list(mapping,form,request,response);
		}
		else if(action.equals(VIEW))
		{
			return view(mapping,form,request,response);
		}
		else if(action.equals(DELETE))
		{
			return delete(mapping,form,request,response);
		}
		else 
		{
			throw new UnsupportedOperationException();
		}
		/*else if(action.equals(UPDATE))
		{
			return update(tableID,name,companyID);
		}*/
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws HibernateException {
		CustConfigTable table=this.getTable(request);
		CustConfigService service=new CustConfigService();
		service.deleteTable(table.getId());
		ActionForward forward=new ActionForward("/helpdesk.listTable.do?company="+java.net.URLEncoder.encode(table.getCompany().getPartyId()));
		forward.setRedirect(true);
		return forward;
	}

	/**
	 * @param companyID
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward newTable(ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response) throws HibernateException {
		Party company=this.getCompany(request);
		BeanActionForm tableForm=(BeanActionForm) this.getForm("/helpdesk.insertTable",request);
		tableForm.set("company_partyId",company.getPartyId());
		List typeList=new ArrayList();
		CustConfigTableTypeService typeService=new CustConfigTableTypeService();
		List allTypeList=typeService.listAllTableType();
		CustConfigService service=new CustConfigService();
		List usedTypeList=service.getUsedTypeList(company.getPartyId());
		Iterator itor=allTypeList.iterator();
		while(itor.hasNext())
		{
			CustConfigTableType type=(CustConfigTableType) itor.next();
			if(!usedTypeList.contains(type))
			{
				typeList.add(type);
			}
		}
		request.setAttribute("typeList",typeList);
		return mapping.findForward("editPage");
	}

	/**
	 * @param companyID
	 * @param request
	 * @param mapping
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward list(ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response) throws HibernateException {
		String companyID=request.getParameter("company");
		if(companyID!=null)
		{
			Party company=this.getCompany(request);
			
			//new
			BeanActionForm tableForm=(BeanActionForm) this.getForm("/helpdesk.insertTable",request);
			tableForm.set("company_partyId",company.getPartyId());
			List typeList=new ArrayList();
			CustConfigTableTypeService typeService=new CustConfigTableTypeService();
			List allTypeList=typeService.listAllTableType();
			CustConfigService service=new CustConfigService();
			List usedTypeList=service.getUsedTypeList(company.getPartyId());
			Iterator itor=allTypeList.iterator();
			while(itor.hasNext())
			{
				CustConfigTableType type=(CustConfigTableType) itor.next();
				if(!usedTypeList.contains(type))
				{
					typeList.add(type);
				}
			}
			request.setAttribute("typeList",typeList);
			//end new
			
			List tables=service.listCompanyConfigTables(company.getPartyId());
			request.setAttribute("tables",tables);
			request.setAttribute("company",company);
		}
		return mapping.findForward("listTable");
	}

	/**
	 * @param tableID
	 * @param mapping
	 * @param request
	 * @return
	 * @throws HibernateException
	 * @throws HibernateException
	 */
	private ActionForward view(ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response) throws HibernateException  {
		CustConfigTable table=this.getTable(request);
		
		CustConfigService service=new CustConfigService();
		List rows=service.listRows(table.getId());
		request.setAttribute("rows",rows);
		request.setAttribute("tableType",table.getTableType());
		return mapping.findForward("viewTable");
	}

	/**
	 * @param tableID
	 * @param companyID
	 * @return
	 * @throws HibernateException
	 */
	/*private ActionForward delete(Integer tableID, String companyID) throws HibernateException {
		CustConfigService service=new CustConfigService();
		service.deleteTable(tableID);
		ActionForward forward=new ActionForward("/listTable.do?company="+companyID);
		forward.setRedirect(true);
		return forward;
	}*/

	/**
	 * @param tableID
	 * @param name
	 * @param companyID
	 * @return
	 * @throws HibernateException
	 */
	/*private ActionForward update(Integer tableID, String name, String companyID) throws HibernateException {
		CustConfigService service=new CustConfigService();
		CustConfigTable table=service.getTable(tableID);
		if(table==null)
		{
			throw new ActionException(ActionUtils.ERROR_NOT_FOUND,"table("+tableID+")");
		}
		//table.setName(name);
		service.updateTable(table);
		ActionForward forward=new ActionForward("/listTable.do?company="+companyID);
		forward.setRedirect(true);
		return forward;
	}*/

	/**
	 * @param request
	 * @return
	 * @throws HibernateException
	 */
	private CustConfigTable getTable(HttpServletRequest request) throws HibernateException {
		Integer tableID=ActionUtils.parseInt(request.getParameter("table"));
		if(tableID==null)
		{
			throw new ActionException(ActionUtils.ERROR_ID_INT,"table");
		}
		CustConfigService service=new CustConfigService();
		CustConfigTable table=service.getTable(tableID);
		if(table==null)
		{
			throw new ActionException(ActionUtils.ERROR_NOT_FOUND,"table("+tableID+")");
		}
		return table;
	}

	/**
	 * @param companyID
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward insert(ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response) throws HibernateException {
		BeanActionForm tableForm=(BeanActionForm) form;
		CustConfigService service=new CustConfigService();
		CustConfigTable table=new CustConfigTable();
		tableForm.populate(table,BeanActionForm.TO_BEAN);
		service.insertTable(table);
		//this.postGlobalMessage("helpdesk.table.insert.success",request);
		ActionForward forward=new ActionForward("/helpdesk.listTable.do?company="+java.net.URLEncoder.encode(table.getCompany().getPartyId()));
		forward.setRedirect(true);
		return forward;
	}

	/**
	 * @return
	 * @throws HibernateException
	 */
	private Party getCompany(HttpServletRequest request) throws HibernateException {
		// TODO Auto-generated method stub
		String companyID=request.getParameter("company");
		if(companyID==null)
		{
			throw new ActionException(ActionUtils.ERROR_PARA_NOT_SET,"company");
		}
		PartyServices partyServ=new PartyServices();
		Party party=partyServ.getParty(companyID);
		if(party==null)
		{
			throw new ActionException("errors.not_found","party");
		}
		return party;
	}



}