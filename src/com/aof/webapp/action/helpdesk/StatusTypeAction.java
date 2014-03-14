//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.helpdesk.ActionTypeService;
import com.aof.component.helpdesk.CallActionHistory;
import com.aof.component.helpdesk.CallActionTrackService;
import com.aof.component.helpdesk.CallService;
import com.aof.component.helpdesk.CallTypeService;
import com.aof.component.helpdesk.Status;
import com.aof.component.helpdesk.StatusType;
import com.aof.component.helpdesk.StatusTypeService;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.form.helpdesk.CallQueryForm;
import com.aof.webapp.form.helpdesk.StatusTypeQueryForm;
import com.aof.webapp.form.helpdesk.TableTypeQueryForm;
import com.shcnc.struts.action.BaseAction;
import com.shcnc.struts.form.BaseQueryForm;
import com.shcnc.struts.form.BeanActionForm;
import com.shcnc.utils.UUID;

/** 
 * MyEclipse Struts
 * Creation date: 12-02-2004
 * 
 * XDoclet definition:
 * @struts:action parameter="list" validate="true"
 */
public class StatusTypeAction extends com.shcnc.struts.action.BaseAction {

	// --------------------------------------------------------- Instance Variables

	// --------------------------------------------------------- Methods

	
	private final static String LIST_PAGE="listPage";
	private final static String EDIT_PAGE="editPage";
	private final static String ACTION_TABLE_TYPE_LIST="/helpdesk.listStatusType";
	private final static String ACTION_TABLE_TYPE_UPDATE="/helpdesk.updateStatusType";
	private final static String ACTION_TABLE_TYPE_INSERT="/helpdesk.insertStatusType";
	private final static String ACTION_TABLE_TYPE_NEW="/helpdesk.newStatusType";
	private final static String ACTION_TABLE_TYPE_EDIT="/helpdesk.editStatusType";
	private final static String RESULTS="results";
	private final static String ID="id";
	
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
		final String para=mapping.getParameter();
		if (para.equals(LIST)) {
			return listStatusType(mapping,form,request);
		} else if (para.equals(NEW)) {
			return newStatusType(mapping,request);
		} else if (para.equals(EDIT)) {
			return editStatusType(mapping,request);
		}	else if (para.equals(INSERT)) {
			return insertStatusType(mapping,form,request);
		} else if (para.equals(UPDATE)) {
			return updateStatusType(mapping,form,request);
		}
		else {
			throw new UnsupportedOperationException("Generated method 'execute(...)' not implemented.");
		}
			
	}
	
	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward updateStatusType(ActionMapping mapping, ActionForm form, HttpServletRequest request) throws HibernateException {
		StatusTypeService service=new StatusTypeService();
		StatusType statusType=new StatusType();
		BeanActionForm statusTypeForm=(BeanActionForm)form;
		
		if (this.isCancelled(request)){
			ActionForward forward=new ActionForward(ACTION_TABLE_TYPE_EDIT+".do?"+ID+"="+statusTypeForm.get("id"));
			forward.setRedirect(true);
			return forward;
			
	  }
		
		statusTypeForm.populate(statusType,BeanActionForm.TO_BEAN);
		service.update(statusType);
		final ActionForward forward=new ActionForward(
				ACTION_TABLE_TYPE_EDIT+".do?"+ID+"="+statusType.getId());
		forward.setRedirect(true);
		return forward;
		
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward insertStatusType(ActionMapping mapping, ActionForm form, HttpServletRequest request) throws HibernateException {
		// TODO Auto-generated method stub
		StatusTypeService service=new StatusTypeService();
		StatusType statusType=new StatusType();
		BeanActionForm statusTypeForm=(BeanActionForm)form;
		statusTypeForm.populate(statusType,BeanActionForm.TO_BEAN);
		statusType.setFlag(new Integer(0));
		service.insert(statusType);
		final ActionForward forward=new ActionForward(
				ACTION_TABLE_TYPE_EDIT+".do?"+ID+"="+statusType.getId());
		forward.setRedirect(true);
		return forward;
			
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward newStatusType(ActionMapping mapping, HttpServletRequest request) throws HibernateException {
		prepareFormList(request);
		return mapping.findForward(EDIT_PAGE);
	}
	
	private ActionForward editStatusType(ActionMapping mapping,  HttpServletRequest request) 	throws HibernateException {
		StatusTypeService statusTypeService=new StatusTypeService();
		StatusType statusType=null;
		BeanActionForm callActionTrackForm=(BeanActionForm) this.getForm(ACTION_TABLE_TYPE_UPDATE,request);
		Integer statusTypeID=ActionUtils.parseInt(request.getParameter(ID));
		if(statusTypeID==null)
		{
			throw new ActionException("helpdesk.statusType.error.noID");
		}
		statusType=statusTypeService.findStatusType(statusTypeID);
		if(statusType==null)
		{
			throw new ActionException("helpdesk.statusType.error.cannotFindStatusType");
		}
		ActionErrors errors=callActionTrackForm.populate(statusType);
		if(!errors.isEmpty())
		{
			throw new ActionException("helpdesk.statusType.error.data");
		}
		prepareFormList(request);
		return mapping.findForward(EDIT_PAGE);
	}
	
	private ActionForward listStatusType(ActionMapping mapping,	ActionForm form,HttpServletRequest request) throws HibernateException{
		StatusTypeService service=new StatusTypeService();
		final StatusTypeQueryForm queryForm=(StatusTypeQueryForm) form;
		final Map map=this.getQueryMap(queryForm);
		final int pageNo=ActionUtils.parseInt(queryForm.getPageNo()).intValue();
		final int pageSize=ActionUtils.parseInt(queryForm.getPageSize()).intValue();
		final Integer integerCount=ActionUtils.parseInt(queryForm.getCount());
		if (integerCount==null)
		{
			if(pageNo!=0)throw new RuntimeException("count must have been computed when not first page");
			//compute count
			final int count=service.getCount(map);
			queryForm.setCount(String.valueOf(count));
		}
		final List resultList=service.findStatusType(map,pageNo,pageSize);
		request.setAttribute(RESULTS,resultList);
		
		//	call type list
		CallTypeService callTypeService=new CallTypeService();
		List callTypes=null;
		callTypes = callTypeService.listCallType();
		request.getSession().setAttribute("callTypes",callTypes);
		
		return  mapping.findForward(LIST_PAGE);
		
	}
	
	private Map getQueryMap(StatusTypeQueryForm queryForm) {
		final Map map=new HashMap();
		//status
		map.put(StatusTypeService.QUERY_CONDITION_CALLTYPE,queryForm.getCallType());
		map.put(StatusTypeService.QUERY_CONDITION_DISABLED,queryForm.getDisabledStatus());
		
		return map;
	}
	
	private void prepareFormList(HttpServletRequest request) throws HibernateException {
		//call type list
		CallTypeService callTypeService=new CallTypeService();
		List callTypes=null;
		callTypes = callTypeService.listCallType();
		request.getSession().setAttribute("callTypes",callTypes);
		//status types group by call type
		StatusTypeService statusTypeService=new StatusTypeService();
		List statusTypes=null;
		statusTypes=statusTypeService.listStatusTypeGroupByCallType();
		request.getSession().setAttribute("statusTypes",statusTypes);
	}
	
}