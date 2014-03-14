/*
 * Created on 2004-12-16
 *
 */
package com.aof.webapp.action.helpdesk.party;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.helpdesk.party.PartyResponsibilityType;
import com.aof.component.helpdesk.party.PartyResponsibilityTypeService;
import com.aof.component.helpdesk.party.PartyResponsibilityUser;
import com.aof.component.helpdesk.party.PartyResponsibilityUserService;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.form.helpdesk.PartyResponsibilityUserQueryForm;
import com.shcnc.struts.action.BaseAction;
import com.shcnc.struts.form.BeanActionForm;

/**
 * @author nicebean
 *
 */
public class PartyResponsibilityUserAction extends BaseAction {
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {

		final String action = mapping.getParameter();
		PartyResponsibilityUserService service = new PartyResponsibilityUserService();
		
		if (action.equals(NEW)) {
			List partyResponsibilityTypes = new PartyResponsibilityTypeService().getAll();
			request.setAttribute("X_PartyResponsibilityType", partyResponsibilityTypes);
		    return mapping.findForward("editpage");
		}
		
		if (action.equals(INSERT)) {
		    PartyResponsibilityUser p = new PartyResponsibilityUser();
			BeanActionForm partyResponsibilityUserForm = (BeanActionForm)form;
			ActionErrors errors = partyResponsibilityUserForm.populate(p, BeanActionForm.TO_BEAN);
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward("failure");
			}
		    p = service.insert(p);
		    return mapping.findForward("success");
		}
		
		if (action.equals(DELETE)) {
			Integer id = ActionUtils.parseInt(request.getParameter("id"));
			if(id == null) throw new ActionException("helpdesk.partyresponsibilityuser.error.missingargument");
		    service.delete(id);
		    return mapping.findForward("success");
		}
		
		if (action.equals(LIST)) {
			final PartyResponsibilityUserQueryForm queryForm=(PartyResponsibilityUserQueryForm) form;
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
			List partyResponsibilityTypes = new PartyResponsibilityTypeService().getAll();
			partyResponsibilityTypes.add(0, new PartyResponsibilityType());
			request.setAttribute("X_PartyResponsibilityType", partyResponsibilityTypes);
		    return mapping.getInputForward();
		}
		
		throw new UnsupportedOperationException();
	}

    private Map getQueryMap(PartyResponsibilityUserQueryForm queryForm) {
	    Map map = new HashMap();
	    String party = queryForm.getParty();
	    String user = queryForm.getUser();
	    String type = queryForm.getType();
		if (party != null) {
		    party = party.trim();
		    if (party.length() > 0) map.put(PartyResponsibilityUserService.QUERY_CONDITION_PARTY, party); 
		}
		if (user != null) {
		    user = user.trim();
		    if (user.length() > 0) map.put(PartyResponsibilityUserService.QUERY_CONDITION_USER, user); 
		}
		if (type != null) {
		    type = type.trim();
		    if (type.length() > 0) map.put(PartyResponsibilityUserService.QUERY_CONDITION_TYPE, type); 
		}
		return map;
    }
}
