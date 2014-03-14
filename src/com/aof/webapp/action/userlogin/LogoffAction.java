/*
 * $Header: /home/cvsroot/HelpDesk/src/com/aof/webapp/action/userlogin/LogoffAction.java,v 1.2 2004/11/10 07:57:19 shilei Exp $
 * $Revision: 1.2 $
 * $Date: 2004/11/10 07:57:19 $
 *
 * ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ====================================================================
 */

package com.aof.webapp.action.userlogin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Locale;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.listener.SessionListener;

/**   
 * Implementation of <strong>Action</strong> that processes a
 * user logoff.
 *
 * @author Craig R. McClanahan
 * @version $Revision: 1.2 $ $Date: 2004/11/10 07:57:19 $
 */

public final class LogoffAction extends BaseAction {

	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws IOException, ServletException {

		// Extract attributes we will need
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		HttpSession session = request.getSession();
		UserLogin user =
			(UserLogin) session.getAttribute(Constants.USERLOGIN_KEY);

		// Process this user logoff
		if (user != null) {
			if (servlet.getDebug() >= 1)
				servlet.log(
					"LogoffAction: User '"
						+ user.getUserLoginId()
						+ "' logged off in session "
						+ session.getId());
		} else {
			if (servlet.getDebug() >= 1)
				servlet.log(
					"LogoffActon: User logged off in session "
						+ session.getId());
		}
		try {
			Hibernate2Session.closeSession();
			clearSession(session);
			
		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		// Forward control to the specified success URI
		return (mapping.findForward("success"));

	}
	
	/**
	 * 清除系统缓存数据 SECURITY_KEY MODELS_KEY USER_KEY
	 *  
	 */
	protected void clearSession(javax.servlet.http.HttpSession session) {
		//log.info("[ReleaseUserInformation]=>[START]");
		session.removeAttribute(Constants.ONLINE_USER_LISTENER);
		session.removeAttribute(Constants.USERID_KEY);
		session.removeAttribute(Constants.USERNAME_KEY);
		session.removeAttribute(Constants.USERLOGIN_KEY);
		session.removeAttribute(Constants.SECURITY_KEY);
		session.removeAttribute(Constants.MODELS_KEY);
		session.removeAttribute(Constants.USERLOGIN_KEY);
		session.removeAttribute(Constants.USER_ROLE_KEY);
		session.removeAttribute(Constants.USERLOGIN_ROLE_KEY);
		session.removeAttribute(Constants.PARTY_KEY);
		session.removeAttribute(Constants.TRUE_PARTY_KEY);
		session.removeAttribute(Constants.SECURITY_HANDLER_KEY);
		session.removeAttribute(Constants.SUB_PARTY_KEY);

		if (session.getAttribute(Constants.HIBERNATE_SESSION_KEY) != null) {
			try {
				((net.sf.hibernate.Session) session
						.getAttribute(Constants.HIBERNATE_SESSION_KEY)).close();
				//log.info("[ReleaseConnectionSession Success]");
			} catch (HibernateException e) {
				//log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		session.removeAttribute(Constants.HIBERNATE_SESSION_KEY);
		session.removeAttribute(Constants.ERROR_KEY);
		session.removeAttribute(Constants.ONLINE_USER_IP_ADDRESS);
		session.invalidate();

		//log.info("[ReleaseUserInformation]=>[END]");

	}

}
