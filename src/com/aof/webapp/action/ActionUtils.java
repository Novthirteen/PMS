/*
 * Created on 2004-11-15
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action;

import javax.servlet.http.HttpServletRequest;

import com.aof.component.domain.party.UserLogin;
import com.aof.util.Constants;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ActionUtils extends com.shcnc.struts.action.ActionUtils{
	public static UserLogin getCurrentUser(HttpServletRequest request)
	{
		return (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	}
}
