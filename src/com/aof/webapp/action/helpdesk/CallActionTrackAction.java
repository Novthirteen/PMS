//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.ActionTypeService;
import com.aof.component.helpdesk.CallActionHistory;
import com.aof.component.helpdesk.CallActionTrackService;
import com.aof.component.helpdesk.CallMaster;
import com.aof.component.helpdesk.CallService;
import com.aof.component.helpdesk.Status;
import com.aof.component.helpdesk.StatusTypeService;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;
import com.shcnc.struts.form.BeanActionForm;
import com.shcnc.utils.UUID;

/** 
 * MyEclipse Struts
 * Creation date: 11-14-2004
 * 
 * XDoclet definition:
 * @struts:action path="/newCallActionTrack" name="callActionTrackForm" parameter="new" scope="request"
 */
public class CallActionTrackAction extends com.shcnc.struts.action.BaseAction {

	// --------------------------------------------------------- Instance Variables

	// --------------------------------------------------------- Methods

	private final static String EDIT_PAGE="editPage";
	private final static String ACTION="action";
	private final static String ACTION_TRACK_UPDATE="/helpdesk.updateCallActionTrack";
	private final static String ACTION_TRACK_INSERT="/helpdesk.insertCallActionTrack";
	private final static String ACTION_TRACK_NEW="/helpdesk.newCallActionTrack";
	private final static String ACTION_TRACK_EDIT="/helpdesk.editCallActionTrack";
	private final static String ATTACH_GROUP_ID="attachGroupID";
	private final static String ACTION_TRACK_LIST="callActionTracks";
	private final static String STATUS_CHANGE_LIST="statusChange";
	private final static String CALL_ID="callId";
	private final static String ID="id";
	
	/** 
	 * Method execute
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return ActionForward
	 * @throws HibernateException
	 * @throws Throwable
	 */
	public ActionForward execute(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) throws HibernateException {
		final String para=mapping.getParameter();
		if(para.equals(EDIT))
		{
			return edit(mapping,request);
		}
		else if(para.equals(NEW))
		{
			return newCallAction(mapping,request);
		}
		else if(para.equals(INSERT))
		{
			return insert(mapping,request,form);
		}
		else if(para.equals(UPDATE))
		{
			return update(mapping,request,form);
		}
		else if (para.equals(DELETE)) {
			return delete(request);
		}
		else
		{
			throw new UnsupportedOperationException();
		}			
	}

	private ActionForward delete(HttpServletRequest request) throws HibernateException {
		Integer callActionTrackID=ActionUtils.parseInt(request.getParameter(ID));
		Integer callMasterID=ActionUtils.parseInt(request.getParameter(CALL_ID));
		CallActionTrackService service=new CallActionTrackService();
		service.delete(callActionTrackID);
		final ActionForward forward=new ActionForward(
				ACTION_TRACK_NEW+".do?"+CALL_ID+"="+callMasterID);
		forward.setRedirect(true);
		return forward;
	}
	
	private ActionForward insert(ActionMapping mapping,  HttpServletRequest request,ActionForm form) 	throws HibernateException {
		CallActionTrackService service=new CallActionTrackService();
		CallActionHistory callActionTrack=null;
		BeanActionForm callActionTrackForm=(BeanActionForm)form;
			callActionTrack=new CallActionHistory();
			
		callActionTrackForm.populate(callActionTrack,BeanActionForm.TO_BEAN);
		
		CallService callMasterService=new CallService();
		CallMaster checkCall=callMasterService.find(callActionTrack.getCallMaster().getCallID());
		if (StatusTypeService.hasClosed(checkCall))
			ClosedPowerChecker.checkChangeClosedPermission(request,checkCall.getType().getType(),mapping,"error.nopermission.HELPDESK_CALL_ACTIONTRACK_CREATE_CLOSED");
		
		callActionTrack.getModifyLog().setModifyUser(ActionUtils.getCurrentUser(request));
		callActionTrack.getModifyLog().setCreateUser(ActionUtils.getCurrentUser(request));
		service.insert(callActionTrack);

		request.getSession().removeAttribute(ACTION_TRACK_LIST+callActionTrack.getCallMaster().getCallID());
		request.getSession().removeAttribute(STATUS_CHANGE_LIST+callActionTrack.getCallMaster().getCallID());
		
		
		
		final ActionForward forward=new ActionForward(
				"helpdesk.edit"+checkCall.getType().getName()+"ActionTrack.do?"+ID+"="+callActionTrack.getId());
		forward.setRedirect(true);
		return forward;

	}
	
	private ActionForward update(ActionMapping mapping,  HttpServletRequest request,ActionForm form) 	throws HibernateException {
		CallActionTrackService service=new CallActionTrackService();
		CallActionHistory callActionTrack=null;
		BeanActionForm callActionTrackForm=(BeanActionForm)form;
		String updateId = (String) (callActionTrackForm.get("id"));
		callActionTrack=service.find(new Integer(updateId));
		if (StatusTypeService.hasClosed(callActionTrack.getCallMaster()))
			ClosedPowerChecker.checkChangeClosedPermission(request,callActionTrack.getCallMaster().getType().getType(),mapping,"error.nopermission.HELPDESK_CALL_ACTIONTRACK_MODIFY_CLOSED");
		callActionTrackForm.populate(callActionTrack,BeanActionForm.TO_BEAN);
		
		callActionTrack.getModifyLog().setModifyUser(ActionUtils.getCurrentUser(request));
		service.update(callActionTrack);
		
		request.getSession().removeAttribute(ACTION_TRACK_LIST+callActionTrack.getCallMaster().getCallID());
		request.getSession().removeAttribute(STATUS_CHANGE_LIST+callActionTrack.getCallMaster().getCallID());
		
		final ActionForward forward=new ActionForward(
				"helpdesk.edit"+callActionTrack.getCallMaster().getType().getName()+"ActionTrack.do?"+ID+"="+callActionTrack.getId());
		forward.setRedirect(true);
		return forward;
				

	}
	
	private ActionForward edit(ActionMapping mapping,  HttpServletRequest request) 	throws HibernateException {
		
		CallActionTrackService callActionTrackService=new CallActionTrackService();
		CallActionHistory callActionTrack=null;
		BeanActionForm callActionTrackForm=(BeanActionForm) this.getForm(ACTION_TRACK_UPDATE,request);
		Integer callActionTrackID=ActionUtils.parseInt(request.getParameter(ID));
		if(callActionTrackID==null)
		{
			throw new ActionException("helpdesk.call.actionTrack.error.noCallActionTrackID");
		}
		callActionTrack = callActionTrackService.find(callActionTrackID);
		if(callActionTrack==null)
		{
			throw new ActionException("helpdesk.call.actionTrack.error.cannotFindCallActionTrack");
		}
		 
		Boolean buttonEnabled=Boolean.TRUE;
		if (StatusTypeService.hasClosed(callActionTrack.getCallMaster()))
		{
			try{
				ClosedPowerChecker.checkChangeClosedPermission(request,callActionTrack.getCallMaster().getType().getType(),mapping,"error.nopermission.HELPDESK_CALL_CHANGE_CLOSED");
			}
			catch(ActionException e)
			{
				buttonEnabled=Boolean.FALSE;
			}
		}
		request.setAttribute("buttonEnabled",buttonEnabled);
		
		ActionErrors errors=callActionTrackForm.populate(callActionTrack);
		if(!errors.isEmpty())
		{
			throw new ActionException("helpdesk.call.actionTrack.error.data");
		}
		if (callActionTrack.getAttachGroupID()==null)
			callActionTrackForm.set(ATTACH_GROUP_ID,UUID.getUUID());
		prepareFormList(request,callActionTrack);
		return mapping.findForward(EDIT_PAGE);
	}
	
	private ActionForward newCallAction(ActionMapping mapping,  HttpServletRequest request) 	throws HibernateException {
		
		CallActionTrackService callActionTrackService=new CallActionTrackService();
		CallActionHistory callActionTrack=null;
		BeanActionForm callActionTrackForm=(BeanActionForm) this.getForm(ACTION_TRACK_INSERT,request);
		
		callActionTrack=new CallActionHistory();
		//find call
		Integer callMasterID=ActionUtils.parseInt(request.getParameter(CALL_ID));
		if(callMasterID==null)
		{
			throw new ActionException("helpdesk.call.actionTrack.error.noCallID");
		}
		CallService callService=new CallService();
		//set call
		try {
			CallMaster cm=callService.find(callMasterID);
			if (cm==null) 
				throw new ActionException("helpdesk.call.actionTrack.error.cannotFindCallMaster");
			
			//if (StatusTypeService.hasClosed(cm))
			//	ClosedPowerChecker.checkChangeClosedPermission(request,mapping,"error.nopermission.HELPDESK_CALL_ACTIONTRACK_CREATE_CLOSED");
			Boolean buttonEnabled=Boolean.TRUE;
			if (StatusTypeService.hasClosed(cm))
			{
				try{
					ClosedPowerChecker.checkChangeClosedPermission(request,cm.getType().getType(),mapping,"error.nopermission.HELPDESK_CALL_CHANGE_CLOSED");
				}
				catch(ActionException e)
				{
					buttonEnabled=Boolean.FALSE;
				}
			}
			request.setAttribute("buttonEnabled",buttonEnabled);
			
			callActionTrack.setCallMaster(cm);
		} catch (HibernateException e) {
			e.printStackTrace();
			throw new ActionException("helpdesk.call.actionTrack.error.data");
		}
		callActionTrack.setDate(new java.util.Date());
		ActionErrors errors=callActionTrackForm.populate(callActionTrack);
		callActionTrackForm.set(ATTACH_GROUP_ID,UUID.getUUID());
		if(!errors.isEmpty())
		{
			throw new ActionException("helpdesk.call.actionTrack.error.data");
		}
		prepareFormList(request,callActionTrack);
		return mapping.findForward(EDIT_PAGE);
	}
	
	private void prepareFormList(HttpServletRequest request,CallActionHistory callActionTrack) throws HibernateException {
		int callMasterId=callActionTrack.getCallMaster().getCallID().intValue();
		CallActionTrackService callActionTrackService=new CallActionTrackService();
		
		//action type list 
		ActionTypeService atService=new ActionTypeService();
		List actionTypes=null;
		try {
			actionTypes = atService.listActionTypes(callActionTrack.getCallMaster().getType());
		} catch (HibernateException e) {
			e.printStackTrace();
		}
		request.getSession().setAttribute("actionTypes"+callActionTrack.getCallMaster().getType().getType().trim(),actionTypes);
		//status type list
		List statusTypes=null;
		StatusTypeService statusTypeService=new StatusTypeService();
		statusTypes=statusTypeService.listStatusType(callActionTrack.getCallMaster().getType());
		request.getSession().setAttribute("statusTypes"+callActionTrack.getCallMaster().getType().getType().trim(),statusTypes);
		//action track list
		List callActionTracks=null;
		try {
			callActionTracks= callActionTrackService.listActionTrack(callActionTrack.getCallMaster().getCallID());
		} catch (HibernateException e) {
			throw new ActionException("helpdesk.call.actionTrack.error.listActionTracks");
		}
		request.getSession().setAttribute(ACTION_TRACK_LIST+callMasterId,callActionTracks);
		//status change list
		List statusChange=null;
		try {
			statusChange= callActionTrackService.listStatusChange(callActionTrack.getCallMaster().getCallID());
		} catch (HibernateException e) {
			throw new ActionException("helpdesk.call.actionTrack.error.listStatusChange");
		}
		request.getSession().setAttribute(STATUS_CHANGE_LIST+callMasterId,statusChange);
	}

}