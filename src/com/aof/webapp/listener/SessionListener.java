/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.listener;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import org.apache.log4j.Logger;

import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;

/**
 * @author Jackey Ding 
 * @version 2005-04-17
 *
 */
public class SessionListener implements HttpSessionBindingListener {

	private Logger log = Logger.getLogger(SessionListener.class);
	
	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpSessionBindingListener#valueBound(javax.servlet.http.HttpSessionBindingEvent)
	 */
	public void valueBound(HttpSessionBindingEvent arg0) {
		HttpSession session = arg0.getSession();
		ServletContext context = session.getServletContext();
		Map userMap = (Map)context.getAttribute(Constants.ONLINE_USER_KEY);
		
		if (userMap == null) {
			userMap = new HashMap();
			context.setAttribute(Constants.ONLINE_USER_KEY, userMap);
		}
		userMap.put(session.getId(), session);
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		String userId = ((UserLogin)session.getAttribute(Constants.USERLOGIN_KEY)).getUserLoginId();
		String insertStatement = "insert into sys_log (user_id, event, access_time) values(?, ?, ?)";
		sqlExec.addParam(userId);
		sqlExec.addParam("USER LOGIN");
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sqlExec.addParam(format.format(new Date()));
		
		sqlExec.runQueryCloseCon(insertStatement);
	}

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpSessionBindingListener#valueUnbound(javax.servlet.http.HttpSessionBindingEvent)
	 */
	public void valueUnbound(HttpSessionBindingEvent arg0) {
		// TODO Auto-generated method stub
		HttpSession session = arg0.getSession();
		ServletContext context = session.getServletContext();
		Map userMap = (Map)context.getAttribute(Constants.ONLINE_USER_KEY);
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		String userId = ((UserLogin)session.getAttribute(Constants.USERLOGIN_KEY)).getUserLoginId();
		String insertStatement = "insert into sys_log (user_id, event, access_time) values(?, ?, ?)";
		sqlExec.addParam(userId);
		sqlExec.addParam("USER LOGOFF");
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sqlExec.addParam(format.format(new Date()));
		
		sqlExec.runQueryCloseCon(insertStatement);
		
		if (userMap != null) {
			userMap.remove(session.getId());
		}
	}

}
