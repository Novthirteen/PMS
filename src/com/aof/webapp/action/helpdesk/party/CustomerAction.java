/*
 * Created on 2004-12-20
 *
 */
package com.aof.webapp.action.helpdesk.party;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.helpdesk.party.CustomerService;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.form.helpdesk.CustomerQueryForm;
import com.shcnc.struts.action.BaseAction;

/**
 * @author nicebean
 *
 */
public class CustomerAction extends BaseAction {
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {

		final String action = mapping.getParameter();
		CustomerService service = new CustomerService();
		
		if (action.equals(LIST)) {
			final CustomerQueryForm queryForm=(CustomerQueryForm) form;
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
		    return mapping.getInputForward();
		}
		throw new UnsupportedOperationException();
	}

    /**
     * @param queryForm
     * @return
     */
    private Map getQueryMap(CustomerQueryForm queryForm) {
	    Map map = new HashMap();
	    String desc = queryForm.getDesc();
		if (desc != null) {
		    desc = desc.trim();
		    if (desc.length() > 0) map.put(CustomerService.QUERY_CONDITION_DESC, desc); 
		}
		return map;
    }

}
