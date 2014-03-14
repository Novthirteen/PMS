/*
 * Created on 2004-12-17
 *
 */
package com.aof.webapp.action.helpdesk;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.helpdesk.CallType;
import com.aof.component.helpdesk.CallTypeService;
import com.aof.component.helpdesk.RequestType;
import com.aof.component.helpdesk.RequestTypeService;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.form.helpdesk.RequestTypeQueryForm;
import com.shcnc.struts.action.BaseAction;
import com.shcnc.struts.form.BeanActionForm;

/**
 * @author nicebean
 *
 */
public class RequestTypeAction extends BaseAction {
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		final String action = mapping.getParameter();
		RequestTypeService service = new RequestTypeService();

		if (action.equals(NEW)) {
			List callTypes = new CallTypeService().listCallType();
			request.setAttribute("X_CallType", callTypes);
		    CallType callType = new CallTypeService().find(request.getParameter("callType"));
		    if (callType != null) {
			    RequestType r = new RequestType();
		        r.setCallType(callType);
				BeanActionForm requestTypeForm = (BeanActionForm)getForm("/helpdesk.insertRequestType", request);
				ActionErrors errors = requestTypeForm.populate(r, BeanActionForm.TO_FORM);
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return mapping.findForward("failure");
				}
		    }
		    return mapping.findForward("editpage");
		}
		
		if (action.equals(INSERT)) {
		    RequestType r = new RequestType();
			BeanActionForm requestTypeForm = (BeanActionForm)form;
			ActionErrors errors = requestTypeForm.populate(r, BeanActionForm.TO_BEAN);
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
		    r = service.insert(r);
		    return mapping.findForward("success");
		}
		
		if (action.equals(EDIT)) {
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if(id == null) throw new ActionException("helpdesk.call.requesttype.error.missingargument");
			RequestType r = service.find(id);
			if (r == null) throw new ActionException("helpdesk.call.requesttype.error.notfound");
			BeanActionForm requestTypeForm = (BeanActionForm)getForm("/helpdesk.updateRequestType", request);
			ActionErrors errors = requestTypeForm.populate(r, BeanActionForm.TO_FORM);
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
			request.setAttribute("X_CallType", r.getCallType().getTypedesc());
		    return mapping.findForward("editpage");
		}

		if (action.equals(UPDATE)) {
		    RequestType r = new RequestType();
			BeanActionForm requestTypeForm = (BeanActionForm)form;
			ActionErrors errors = requestTypeForm.populate(r, BeanActionForm.TO_BEAN);
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
		    r = service.update(r);
		    return mapping.findForward("success");
		}

		if (action.equals(DELETE)) {
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if(id == null) throw new ActionException("helpdesk.call.requesttype.error.missingargument");
		    service.delete(id);
		    return mapping.findForward("success");
		}
		
		if (action.equals(LIST)) {
			final RequestTypeQueryForm queryForm=(RequestTypeQueryForm) form;
			final Map map=this.getQueryMap(queryForm);
			int pageNo=ActionUtils.parseInt(queryForm.getPageNo()).intValue();
			final int pageSize=ActionUtils.parseInt(queryForm.getPageSize()).intValue();
			final Integer integerCount=ActionUtils.parseInt(queryForm.getCount());
			if (integerCount == null) {
			    pageNo = 0;
				queryForm.setPageNo(String.valueOf(pageNo));
				int count = service.getListCount(map);
				queryForm.setCount(String.valueOf(count));
			}
			final List resultList;
			resultList=service.list(map,pageNo, pageSize);
			request.setAttribute("results", resultList);
			List callTypes = new CallTypeService().listCallType();
			callTypes.add(0, new CallType());
			request.setAttribute("X_CallType", callTypes);
		    return mapping.getInputForward();
		}
		
		throw new UnsupportedOperationException();
	}

    private Map getQueryMap(RequestTypeQueryForm queryForm) {
	    Map map = new HashMap();
	    String description = queryForm.getDescription() ;
	    String callType = queryForm.getCallType();
	    String disabled = queryForm.getDisabled();
		if (description != null) {
		    description = description.trim();
		    if (description.length() > 0) map.put(RequestTypeService.QUERY_CONDITION_DESC, description); 
		}
		if (callType != null) {
		    callType = callType.trim();
		    if (callType.length() > 0) map.put(RequestTypeService.QUERY_CONDITION_CALLTYPE, callType); 
		}
		if (disabled != null) {
		    disabled = disabled.trim();
		    if (disabled.length() > 0) map.put(RequestTypeService.QUERY_CONDITION_DISABLED, disabled);
		}
		return map;
    }

}
