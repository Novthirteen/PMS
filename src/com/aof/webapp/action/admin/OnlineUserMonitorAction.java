/*
 * Created on 2005-4-20
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.webapp.action.BaseAction;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class OnlineUserMonitorAction extends BaseAction {

	public ActionForward execute(ActionMapping mapping, 
								 ActionForm form, 
								 HttpServletRequest request, 
								 HttpServletResponse response) throws Exception {
		return mapping.findForward("view");
	}
}
