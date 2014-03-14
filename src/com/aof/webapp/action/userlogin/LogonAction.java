/*
 * $Header: /home/cvsroot/HelpDesk/src/com/aof/webapp/action/userlogin/LogonAction.java,v 1.6 2004/12/02 02:18:09 shilei Exp $
 * $Revision: 1.6 $
 * $Date: 2004/12/02 02:18:09 $
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
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.PartyKeys;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.domain.party.UserLoginServices;
import com.aof.component.prm.util.EmailService;
import com.aof.component.useraccount.UserAccount;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.LogonForm;
import com.aof.webapp.listener.SessionListener;

/**
 * 实现<strong>Action</strong>，作用户系统登陆控制。
 * 
 * @author XingPing Xu
 * @version $Revision: 1.6 $ $Date: 2004/12/02 02:18:09 $
 */

public final class LogonAction extends BaseAction {

	/**
	 * 处理系统用户的登陆。如果用户验证通过就Catch用户的模块功能和权限功能点。 如果用户不能验证通过就返回到用户的最初登陆界面，使用户再次登陆系统。
	 * 
	 * @param mapping
	 *            The ActionMapping used to select this instance
	 * @param actionForm
	 *            The optional ActionForm bean for this request (if any)
	 * @param request
	 *            The HTTP request we are processing
	 * @param response
	 *            The HTTP response we are creating
	 * 
	 * @exception IOException
	 *                if an input/output error occurs
	 * @exception ServletException
	 *                if a servlet exception occurs
	 * @throws HibernateException
	 */
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws IOException,
			ServletException, HibernateException {

		ActionErrors errors = this.getActionErrors(request.getSession());

		ActionErrorLog actionDebug = new ActionErrorLog();
		Logger log = Logger.getLogger(LogonAction.class.getName());
		UserLogin userLogin = null;
		String ForgetPwd = request.getParameter("ForgetPwd");

		// Extract attributes we will need
		Locale locale = getLocale(request);
		MessageResources messages = getResources();

		// 由LogonForm中得到登陆系统的账号和口令
		String username = ((LogonForm) form).getUsername();
		String password = ((LogonForm) form).getPassword();
		// log.info("username=" + username + " " + "password=" + password);

		userLogin = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);

		String role = (String) request.getSession().getAttribute(Constants.USER_ROLE_KEY);
		log.info("user=" + username + " role=" + role);
		boolean changePwd = false;

		// -----------------login
		// -------------------------------------------------------
		if ((ForgetPwd == null) || (ForgetPwd.length() < 1)) {

			if (userLogin != null) {
				if (role.equals(PartyKeys.SUPPLIER_ROLE_KEY)) {
					return (mapping.findForward(PartyKeys.SUPPLIER_ROLE_KEY));
				}
				if (role.equals(PartyKeys.STORAGE_ROLE_KEY)) {
					return (mapping.findForward(PartyKeys.STORAGE_ROLE_KEY));
				}
				if (role.equals(PartyKeys.SHIPPER_ROLE_KEY)) {
					return (mapping.findForward(PartyKeys.SHIPPER_ROLE_KEY));
				}
				if (role.equals(PartyKeys.ORGANIZATION_UNIT_ROLE_KEY)) {
					String siteRole = userLogin.getRole();
					if (siteRole != null) {
						return (mapping.findForward(siteRole));
					}
					return (mapping.findForward("EMPTY"));
				}
				return (new ActionForward(mapping.getInput()));
			}

			try {
				List ulList = Hibernate2Session.currentSession().find(
						"from UserLogin as ul where ul.userLoginId='" + username + "'");

				if (ulList.size() <= 0) {
					actionDebug.addGlobalError(errors, "error.user.nohave");
				} else {
					userLogin = (UserLogin) ulList.iterator().next();
					if (userLogin.getEnable().equals("N")) {
						actionDebug.addGlobalError(errors, "error.uesr.dispable");
					} else if (!(password.equals(userLogin.getCurrent_password()))) {
						actionDebug.addGlobalError(errors, "error.password.mismatch");
					}
				}
				Calendar c = Calendar.getInstance();
				Date curDate = c.getTime();
				Date lastUpdateDate = userLogin.getLast_update_Date();
				if (((UtilDateTime.getDiffDay(lastUpdateDate, 90)).compareTo(curDate)) <= 0) {
					changePwd = true;
					// return (mapping.findForward("changePwd"));
				}
				// c.
				// if(curDate.)
			} catch (Exception e) {
				actionDebug.addGlobalError(errors, "error.user.nohave");
				log.error("Exception: " + e.getMessage());
				e.printStackTrace();
			} finally {
				try {
					Hibernate2Session.closeSession();
				} catch (HibernateException he) {
					log.error(he.getMessage());
					he.printStackTrace();
				} catch (SQLException se) {
					log.error(se.getMessage());
					se.printStackTrace();
				}
			}

			if (!errors.empty()) {
				saveErrors(request, errors);
				return (mapping.findForward("ERROR"));
			}

			// Add by Will begin. 2006-6-26
			Integer skillSize = new Integer(0);
			String skillFlag = "no";
			try {
				Session hs = Hibernate2Session.currentSession();
				Transaction tx = hs.beginTransaction();
				List valueList = null;

				Query query = null;
				query = hs.createQuery("from Skill as s where s.employee=:userlogin");
				query.setParameter("userlogin", userLogin);
				valueList = query.list();

				if (valueList != null && valueList.size() > 0) {
					skillFlag = "yes";
				}
				request.setAttribute("skillFlag", skillFlag);

				hs.flush();
				tx.commit();

			} catch (Exception e) {
				e.printStackTrace();
				log.error(e.getMessage());
				return (mapping.findForward("failed"));
			} finally {
				try {
					Hibernate2Session.closeSession();
				} catch (HibernateException e1) {
					log.error(e1.getMessage());
					e1.printStackTrace();
				} catch (SQLException e1) {
					log.error(e1.getMessage());
					e1.printStackTrace();
				}
			}
			// Add by Will end.

			/*******************************************************************
			 * 
			 * log.info("partyId=" + userLogin.getParty().getPartyId() + "|");
			 * log.info("userloginId=" + userLogin.getUserLoginId() + "|");
			 * log.info("currentpassword=" + userLogin.getCurrent_password() +
			 * "|"); log.info("enable=" + userLogin.getEnable() + "|");
			 * 
			 ******************************************************************/
			initSession(request.getSession(), new UserAccount(userLogin), request.getRemoteAddr());
			role = (String) request.getSession().getAttribute(Constants.USER_ROLE_KEY);

			// Add by Will begin. 2006-6-26
			request.getSession().setAttribute("skillFlag", skillFlag);
			// Add by Will end.

			// locale
			String strlocale = request.getParameter("locale");
			if (strlocale.equals(""))// previous setting
			{
				strlocale = userLogin.getLocale();
			} else {
				// save locale to db
				userLogin.setLocale(strlocale);
				UserLoginServices service = new UserLoginServices();
				service.updateUserLogin(userLogin);
			}
			if (strlocale == null || strlocale.trim().equals("")) {
				strlocale = DEFAULT_LOCALE;
			}
			// save locale to session
			this.setLocale(request, new Locale(strlocale));
			if (changePwd == true) {
				request.setAttribute("overduePwd", "overduePwd");
				return (mapping.findForward("changePwd"));
			}
			if (role.equals(PartyKeys.SUPPLIER_ROLE_KEY)) {
				return (mapping.findForward(PartyKeys.SUPPLIER_ROLE_KEY));
			}
			if (role.equals(PartyKeys.STORAGE_ROLE_KEY)) {
				return (mapping.findForward(PartyKeys.STORAGE_ROLE_KEY));
			}
			if (role.equals(PartyKeys.SHIPPER_ROLE_KEY)) {
				return (mapping.findForward(PartyKeys.SHIPPER_ROLE_KEY));
			}

			if (role.equals(PartyKeys.ORGANIZATION_UNIT_ROLE_KEY)) {
				String siteRole = userLogin.getRole();
				if (siteRole != null) {
					return (mapping.findForward(siteRole));
				}
				return (mapping.findForward("EMPTY"));

			}
			return (new ActionForward(mapping.getInput()));

		}
		// -----------------forget password
		// -------------------------------------------------------
		else {
			try {
				List ulList = Hibernate2Session.currentSession().find(
						"from UserLogin as ul where ul.userLoginId='" + username + "'");

				if (ulList.size() <= 0) {
					actionDebug.addGlobalError(errors, "error.user.nohave");
				} else {
					userLogin = (UserLogin) ulList.iterator().next();
					if (userLogin.getEnable().equals("N")) {
						actionDebug.addGlobalError(errors, "error.uesr.dispable");
					} else {
						EmailService.notifyUser(userLogin);
					}
				}
			} catch (Exception e) {
				actionDebug.addGlobalError(errors, "error.user.nohave");
				log.error("Exception: " + e.getMessage());
				e.printStackTrace();
			} finally {
				try {
					Hibernate2Session.closeSession();
				} catch (HibernateException he) {
					log.error(he.getMessage());
					he.printStackTrace();
				} catch (SQLException se) {
					log.error(se.getMessage());
					se.printStackTrace();
				}
			}
			request.setAttribute("SendPwdByEmail", "SendPwdByEmail");
			return (mapping.findForward("failed"));
		}
	}

	protected void initSession(javax.servlet.http.HttpSession session, UserAccount userAccount,
			String ip) {
		// log.info("[InitialUserInformation]=>[START]");
		session.setAttribute(Constants.USERID_KEY, userAccount.getUserId());
		session.setAttribute(Constants.USERNAME_KEY, userAccount.getUserName());
		session.setAttribute(Constants.USERLOGIN_KEY, userAccount.getUserLogin());
		session.setAttribute(Constants.SECURITY_KEY, userAccount.getSecurityPermission());
		session.setAttribute(Constants.MODELS_KEY, userAccount.getModules());
		session.setAttribute(Constants.USER_ROLE_KEY, userAccount.getRole());
		session.setAttribute(Constants.USERLOGIN_ROLE_KEY, userAccount.getUserLoginRoleId());
		session.setAttribute(Constants.PARTY_KEY, userAccount.getPartyId());
		session.setAttribute(Constants.TRUE_PARTY_KEY, userAccount.getTruePartyId());
		session.setAttribute(Constants.SUB_PARTY_KEY, userAccount.getSubPartys());
		session.setAttribute(Constants.ERROR_KEY, new ActionErrors());
		session.setAttribute(Constants.ONLINE_USER_IP_ADDRESS, ip);
		session.setAttribute(Constants.ONLINE_USER_LISTENER, new SessionListener());

		// log.info("[InitialUserInformation]=>[END]");

	}

	private static String DEFAULT_LOCALE = "en";

}
