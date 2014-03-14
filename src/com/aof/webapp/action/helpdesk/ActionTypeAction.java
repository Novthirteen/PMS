/*
 * Created on 2004-11-30
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.helpdesk;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import net.sf.hibernate.HibernateException;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.helpdesk.ActionType;
import com.aof.component.helpdesk.ActionTypeService;
import com.aof.component.helpdesk.CallTypeService;
import com.aof.component.helpdesk.StatusTypeService;
import com.aof.component.domain.party.UserLogin;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;
import com.shcnc.struts.form.BeanActionForm;
/**
 * @author zhangyan
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ActionTypeAction extends com.shcnc.struts.action.BaseAction{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {

		UserLogin userLogin = ActionUtils.getCurrentUser(request);
		
		final String action = mapping.getParameter();
		ActionTypeService service = new ActionTypeService();
		ActionType actiontype = null;
		
		if(action.equals(LIST)){
			List actiontypelist = service.listAllActionTypes();
		    request.setAttribute("X_actiontypelist",actiontypelist);
		    return mapping.findForward("success");
		}

		//为修改页面准备数据
		if (action.equals(EDIT)) {
		    //从数据库中读入
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if (id == null) throw new ActionException("call.actiontype.error.missingargument");
			actiontype = service.find(id);
			if (actiontype == null) throw new ActionException("call.actiontype.error.notfound");
			//把数据填入form
			BeanActionForm actionTypeForm = (BeanActionForm)this.getForm("/helpdesk.updateActionType", request);
			ActionErrors errors = actionTypeForm.populate(actiontype, BeanActionForm.TO_FORM);
			if(!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
			prepareFormList(request);
			return mapping.findForward("editpage");
		}

		if (action.equals(NEW)) {
		    MessageResources messages = getResources(request); 
		    prepareFormList(request);
			return mapping.findForward("editpage");
		}
		
		//保存新增、修改的数据前，根据form的内容填充bean
		if (action.equals(INSERT) || action.equals(UPDATE)) {
			actiontype = new ActionType();
			BeanActionForm actionTypeForm = (BeanActionForm)form;
			ActionErrors errors = actionTypeForm.populate(actiontype, BeanActionForm.TO_BEAN);
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
			if (action.equals(INSERT)) {
			    actiontype = service.insert(actiontype, userLogin);
			} else {
			    actiontype = service.update(actiontype, userLogin);
			    
			}
		    request.setAttribute("X_actiontype",actiontype);
		}
		return mapping.findForward("success");
	}
	
	private void prepareFormList(HttpServletRequest request) {
		//call type list
		CallTypeService callTypeService=new CallTypeService();
		List callTypes=null;
		try {
			callTypes = callTypeService.listCallType();
		} catch (HibernateException e) {
			e.printStackTrace();
		}
		request.getSession().setAttribute("callTypes",callTypes);
	}
	
}
