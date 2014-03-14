/*
 * Created on 2004-11-15
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

import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.servicelevel.SLACategoryService;
import com.aof.component.helpdesk.servicelevel.SLAMaster;
import com.aof.component.helpdesk.servicelevel.SLAMasterService;
import com.aof.component.helpdesk.servicelevel.SLAPriorityService;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.form.helpdesk.SLAMasterQueryForm;
import com.shcnc.struts.form.BeanActionForm;

/**
 * @author nicebean
 */

public class SLAMasterAction extends com.shcnc.struts.action.BaseAction{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {

		UserLogin userLogin = ActionUtils.getCurrentUser(request);
		
		final String action = mapping.getParameter();
		SLAMasterService service = new SLAMasterService();
		SLAMaster master = null;

		//为修改页面准备数据
		if (action.equals(EDIT)) {
		    //从数据库中读入
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if (id == null) throw new ActionException("helpdesk.servicelevel.master.error.missingargument");
			master = service.find(id);
			if (master == null) throw new ActionException("helpdesk.servicelevel.master.error.notfound");
			//把数据填入form
			BeanActionForm slaMasterForm = (BeanActionForm)getForm("/helpdesk.updateSLAMaster", request);
			ActionErrors errors = slaMasterForm.populate(master, BeanActionForm.TO_FORM);
			if(!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
			return mapping.findForward("editpage");
		}
		//为新增页面准备数据
		if (action.equals(NEW)) {
			return mapping.findForward("editpage");
		}
		
		//保存新增、修改的数据前，根据form的内容填充bean
		if (action.equals(INSERT) || action.equals(UPDATE)) {
			master = new SLAMaster();
			BeanActionForm slaMasterForm = (BeanActionForm)form;
			ActionErrors errors = slaMasterForm.populate(master, BeanActionForm.TO_BEAN);
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
			if (action.equals(INSERT)) {
			    master = service.insert(master, userLogin);
			    return new ActionForward("/helpdesk.viewSLAMaster.do?id=" + master.getId(), true);
			}
			master = service.update(master, userLogin);
			request.setAttribute("X_master", master);
			return mapping.findForward("success");
		}
		
		if (action.equals(DELETE)) {
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if (id == null) throw new ActionException("helpdesk.servicelevel.master.error.missingargument");
		    service.delete(id);
			return mapping.findForward("success");
		}

		if (action.equals(VIEW)) {
		    Integer id = ActionUtils.parseInt(request.getParameter("id"));
		    master = service.find(id);
		    if (master == null) throw new ActionException("helpdesk.servicelevel.master.error.notfound");
		    if (request.getParameter("updateCategoryFullPath") != null) new SLACategoryService().updateCategoryFulPath(id);
			if (request.getParameter("updateCategoryFullDesc") != null) new SLACategoryService().updateCategoryFullDesc(id);
		    String xmlCategories = new SLACategoryService().getAllForMasterAsXml(id, getLocale(request));
		    List priorities = new SLAPriorityService().getPrioritiesForMaster(id, getLocale(request));
		    request.setAttribute("X_master", master);
		    request.setAttribute("X_categoryxml", xmlCategories);
		    request.setAttribute("X_priorities", priorities);
		    return mapping.findForward("success");
		}
		
		if (action.equals(LIST)) {
		    SLAMasterQueryForm queryForm = (SLAMasterQueryForm)form;
		    Map map = getQueryMap(queryForm);
			int pageNo = ActionUtils.parseInt(queryForm.getPageNo()).intValue();
			int pageSize = ActionUtils.parseInt(queryForm.getPageSize()).intValue();
			Integer integerCount = ActionUtils.parseInt(queryForm.getCount());
			if (integerCount == null) {
			    pageNo = 0;
				queryForm.setPageNo(String.valueOf(pageNo));
				int count = service.getListCount(map);
				queryForm.setCount(String.valueOf(count));
			}
			List resultList = service.getList(map, pageNo, pageSize);
			request.setAttribute("X_masters", resultList);
			return mapping.getInputForward();
		}
		
		throw new UnsupportedOperationException();
	}
	
	private Map getQueryMap(SLAMasterQueryForm queryForm) {
	    Map map = new HashMap();
	    String desc = queryForm.getDesc();
	    String customer = queryForm.getCustomer();
	    String active = queryForm.getActive();
		if (desc != null) {
		    desc = desc.trim();
		    if (desc.length() > 0) map.put(SLAMasterService.QUERY_CONDITION_DESC, desc); 
		}
		if (customer != null) {
		    customer = customer.trim();
		    if (customer.length() > 0) map.put(SLAMasterService.QUERY_CONDITION_CUSTOMER, customer); 
		}
		if (active != null) {
		    active = active.trim();
		    if (active.length() > 0) map.put(SLAMasterService.QUERY_CONDITION_ACTIVE, active); 
		}
		return map;
	}
}
