/*
 * Created on 2004-11-22
 *
 */
package com.aof.webapp.action.helpdesk;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.servicelevel.SLACategory;
import com.aof.component.helpdesk.servicelevel.SLACategoryService;
import com.aof.component.helpdesk.servicelevel.SLAPriority;
import com.aof.component.helpdesk.servicelevel.SLAPriorityService;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;
import com.shcnc.struts.form.BeanActionForm;
/**
 * @author zhangyan
 *
 */
public class SLAPriorityAction extends com.shcnc.struts.action.BaseAction{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {

		UserLogin userLogin = ActionUtils.getCurrentUser(request);
		
		final String action = mapping.getParameter();
		Locale locale = getLocale(request);
		SLAPriorityService service = new SLAPriorityService();
		SLACategoryService categoryservice = new SLACategoryService();
		SLAPriority priority = null;
		SLACategory category = null;

		//为修改页面准备数据
		if (action.equals(EDIT)) {
		    //从数据库中读入
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if (id == null) throw new ActionException("helpdesk.servicelevel.priority.error.missingargument");
			priority = service.find(id);
			if (priority == null) throw new ActionException("helpdesk.servicelevel.priority.error.notfound");
			//把数据写入form
			BeanActionForm slaPriorityForm = (BeanActionForm)getForm("/helpdesk.updateSLAPriority", request);
			ActionErrors errors = slaPriorityForm.populate(priority, BeanActionForm.TO_FORM);
			if(!errors.isEmpty()) {
				saveErrors(request, errors);
				return new ActionForward("failure");
			}
			return mapping.findForward("editpage");
		}
		//为新建页面准备数据
		if(action.equals(NEW)){
			Integer categoryid = ActionUtils.parseInt(request.getParameter("categoryid"));
			if (categoryid == null)	throw new ActionException("helpdesk.servicelevel.category.error.missingargument");
			category = categoryservice.findFirstClass(categoryid);
			if (category == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
	        BeanActionForm newslaPriorityForm = (BeanActionForm)getForm("/helpdesk.insertSLAPriority", request);
	        newslaPriorityForm.set("category_id", categoryid.toString());
	        category.setLocale(locale);
	        request.setAttribute("X_categoryDesc", category.getDesc());
			return mapping.findForward("editpage");
		}
		
		//保存新增、修改的数据前，根据form的内容填充bean
		if (action.equals(INSERT) || action.equals(UPDATE)) {
			priority = new SLAPriority();
			BeanActionForm slaCategoryForm = (BeanActionForm)form;
			ActionErrors errors = slaCategoryForm.populate(priority, BeanActionForm.TO_BEAN);
			if(!errors.isEmpty()) {
				saveErrors(request, errors);
				return new ActionForward("/failure");
			}
			if (action.equals(INSERT)) {
			    priority = service.insert(priority, userLogin);
			} else {
			    priority = service.update(priority, userLogin);
			}
			priority.setLocale(locale);
			priority.getCategory().setLocale(locale);
			request.setAttribute("X_priority", priority);
			return mapping.findForward("success");
		}
		
		if (action.equals(DELETE)) {
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if (id == null) throw new ActionException("helpdesk.servicelevel.priority.error.missingargument");
	    	service.delete(id);
		    return mapping.findForward("success");
		}
		 
		throw new UnsupportedOperationException();
	}

}
