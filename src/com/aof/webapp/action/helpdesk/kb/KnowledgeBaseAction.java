/*
 * Created on 2004-11-26
 *
 */
package com.aof.webapp.action.helpdesk.kb;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import com.aof.webapp.action.BaseAction;
import java.util.Map;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.webapp.form.helpdesk.KnowledgeBaseQueryForm;
import com.aof.component.helpdesk.kb.KnowledgeBase;
import com.aof.component.helpdesk.kb.KnowledgeBaseService;
import com.aof.component.helpdesk.servicelevel.SLACategory;
import com.aof.component.helpdesk.servicelevel.SLACategoryService;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;
import com.shcnc.struts.form.BeanActionForm;
import com.shcnc.utils.UUID;

/**
 * @author nicebean
 *
 */
public class KnowledgeBaseAction extends com.shcnc.struts.action.BaseAction {
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {

		final String action = mapping.getParameter();
		Locale locale = getLocale(request);
		KnowledgeBaseService service = new KnowledgeBaseService();
		KnowledgeBase kb = null;
		
		if (action.equals(LIST)) {
			final KnowledgeBaseQueryForm queryForm=(KnowledgeBaseQueryForm) form;
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
			resultList=service.listKnowledgeBase(map,pageNo, pageSize, locale);
			request.setAttribute("results", resultList);
			return  mapping.findForward("listPage");
		}
	
		//为显示页面准备数据
		if (action.equals(VIEW)) {
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if (id == null) throw new ActionException("error.id", "id");
		    kb = service.find(id);
		    if (kb == null) throw new ActionException("helpdesk.kb.error.notfound");
		    request.setAttribute("X_kb", kb);
			request.setAttribute("X_categoryPathDesc", new SLACategoryService().getPathDesc(kb.getCategory(), locale));
		    return mapping.findForward("success");
		}

		//根据Call创建KB，创建成功后转编辑页面
		if (action.equals(CREATE)) {
			Integer callid = ActionUtils.parseInt(request.getParameter("callid"));
			if (callid == null) throw new ActionException("error.id", "callid");
		    kb = service.createFromCall(callid);
		    return new ActionForward("/helpdesk.editKnowledgeBase.do?id=" + kb.getId(), true);
		}
		
		//为新建页面准备数据
		if (action.equals(NEW)) {
		    kb = new KnowledgeBase();
		    kb.setProblemAttachGroupId(UUID.getUUID());
		    kb.setSolutionAttachGroupId(UUID.getUUID());
			BeanActionForm kbForm = (BeanActionForm)getForm("/helpdesk.insertKnowledgeBase", request);
			//把数据填入form
			ActionErrors errors = kbForm.populate(kb, BeanActionForm.TO_FORM);
			if(!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
		    return mapping.findForward("editpage");
		}
		
		//保存新建的数据前，根据form的内容填充bean
		if (action.equals(INSERT)) {
		    kb = new KnowledgeBase();
			BeanActionForm kbForm = (BeanActionForm)form;
			ActionErrors errors = kbForm.populate(kb, BeanActionForm.TO_BEAN);
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
			kb.setOriginalCustomer(kb.getCustomer());
		    kb = service.insert(kb);
			request.setAttribute("X_knowledgebase", kb);
		    return new ActionForward("/helpdesk.viewKnowledgeBase.do?id=" + kb.getId(), true);
		}

		//为修改页面准备数据
		if (action.equals(EDIT)) {
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if (id == null) throw new ActionException("helpdesk.kb.error.missingargument");
			kb = service.find(id);
			if (kb == null) throw new ActionException("helpdesk.kb.error.notfound");
			BeanActionForm kbForm = (BeanActionForm)getForm("/helpdesk.updateKnowledgeBase", request);
			//把数据填入form
			ActionErrors errors = kbForm.populate(kb, BeanActionForm.TO_FORM);
			if(!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
		    MessageResources messages = getResources(request); 
			List customerIDList = new ArrayList();
			List customerNameList = new ArrayList();
			customerIDList.add("");
			customerNameList.add(messages.getMessage(locale, "helpdesk.kb.customer.choice.default"));
			Party customer = kb.getOriginalCustomer();
			if (customer != null) {
			    customerIDList.add(customer.getPartyId());
			    customerNameList.add(customer.getDescription());
			}
			request.setAttribute("X_customerIDList", customerIDList);
			request.setAttribute("X_customerNameList", customerNameList);
			request.setAttribute("X_categoryPathDesc", new SLACategoryService().getPathDesc(kb.getCategory(), locale));
		    return mapping.findForward("editpage");
		}

		//保存修改的数据前，根据form的内容填充bean
		if (action.equals(UPDATE)) {
		    kb = new KnowledgeBase();
			BeanActionForm kbForm = (BeanActionForm)form;
			ActionErrors errors = kbForm.populate(kb, BeanActionForm.TO_BEAN);
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
		    kb = service.update(kb);
			request.setAttribute("X_knowledgebase", kb);
		    return new ActionForward("/helpdesk.viewKnowledgeBase.do?id=" + kb.getId(), true);
		}
		
		if (action.equals(DELETE)) {
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if (id == null) throw new ActionException("helpdesk.kb.error.missingargument");
		    service.delete(id);
		    return mapping.findForward("success");
		}
		
		throw new UnsupportedOperationException();
	}
	
	private Map getQueryMap(KnowledgeBaseQueryForm queryForm) {
		final Map map=new HashMap();
		//company
		final String searchword=queryForm.getSearchword().trim();
		final String select=queryForm.getSelect();
		final Integer categoryid=ActionUtils.parseInt(queryForm.getCategoryid());
		if(select!=null && !select.equals(""))
		{
			map.put(KnowledgeBaseService.QUERY_CONDITION_SELECT,select);
		}
		if(searchword!=null && !searchword.equals(""))
		{ 
			map.put(KnowledgeBaseService.QUERY_CONDITION_SEARCHWORD,searchword);
			
		}
		if(categoryid!=null && !categoryid.equals(""))
		{
			map.put(KnowledgeBaseService.QUERY_CONDITION_CATEGORYID,categoryid);
		}
		return map;
	}
}
