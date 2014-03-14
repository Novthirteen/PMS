/*
 * Created on 2004-11-16
 *
 */
package com.aof.webapp.action.helpdesk;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.servicelevel.SLACategory;
import com.aof.component.helpdesk.servicelevel.SLACategoryService;
import com.aof.component.helpdesk.servicelevel.SLAMasterService;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;
import com.shcnc.struts.form.BeanActionForm;

/**
 * @author zhangyan
 *
 */
public class SLACategoryAction extends com.shcnc.struts.action.BaseAction{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {

		UserLogin userLogin = ActionUtils.getCurrentUser(request);
		
		final String action = mapping.getParameter();
		Locale locale = getLocale(request);
		SLACategoryService service = new SLACategoryService();
		SLAMasterService masterservice = new SLAMasterService();
		SLACategory category = null;

		//Ϊ�޸�ҳ��׼������
		if (action.equals(EDIT)) {
		    //�����ݿ��ж���
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if (id == null)	throw new ActionException("helpdesk.servicelevel.category.error.missingargument");
			category = service.find(id);
			if (category == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
			//������д��form
			BeanActionForm slaCategoryForm = (BeanActionForm)getForm("/helpdesk.updateSLACategory", request);
			ActionErrors errors = slaCategoryForm.populate(category, BeanActionForm.TO_FORM);
			if(!errors.isEmpty()) {
				saveErrors(request, errors);
				return new ActionForward("failure");
			}
			return mapping.findForward("editpage");
		}
		
		//Ϊ����ҳ��׼������
		if (action.equals(NEW)) {
		    Integer parentId = ActionUtils.parseInt(request.getParameter("parentId"));
		    Integer masterid = null;
		    SLACategory parent = null;
		    if (parentId != null) {
		        parent = service.find(parentId);
		        if (parent == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
		        masterid = parent.getMaster().getId();
		    } else {
		        masterid = ActionUtils.parseInt(request.getParameter("masterid"));
		    }
		    if (masterid == null) throw new ActionException("helpdesk.servicelevel.category.error.missingargument");
			//������д��form
			BeanActionForm slaCategoryForm = (BeanActionForm)getForm("/helpdesk.insertSLACategory", request);
			slaCategoryForm.set("master_id", masterid.toString());
		    MessageResources messages = getResources(request); 
			List parentIDList = new ArrayList();
			List parentDescList = new ArrayList();
			parentIDList.add("");
			parentDescList.add(messages.getMessage(locale, "helpdesk.servicelevel.category.parent.choice.default"));
			if (parentId != null) {
			    slaCategoryForm.set("parentId", parentId.toString());
			    parentIDList.add(parentId.toString());
			    parentDescList.add(service.getPathDesc(parent, locale));
			}
			request.setAttribute("X_parentIDList", parentIDList);
			request.setAttribute("X_parentDescList", parentDescList);
			return mapping.findForward("editpage");
		}
		
		//�����������޸ĵ�����ǰ������form���������bean
		if (action.equals(INSERT) || action.equals(UPDATE)) {
			category = new SLACategory();
			BeanActionForm slaCategoryForm = (BeanActionForm)form;
			ActionErrors errors = slaCategoryForm.populate(category, BeanActionForm.TO_BEAN);
			if(!errors.isEmpty()) {
				saveErrors(request, errors);
				return new ActionForward("/failure");
			}
			if (action.equals(INSERT)) {
			    if (category.getMaster() == null) throw new ActionException("helpdesk.servicelevel.category.error.missingargument");
			    category = service.insert(category, userLogin);
			} else {
			    category = service.update(category, userLogin);
			}
			category.setLocale(locale);
			request.setAttribute("X_category", category);
			return mapping.findForward("success");
		}
		
		if (action.equals(DELETE)) {
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if(id == null) throw new ActionException("helpdesk.servicelevel.category.error.missingargument");
		    service.delete(id);
		    return mapping.findForward("success");
		}
		 
		throw new UnsupportedOperationException();
	}
}


