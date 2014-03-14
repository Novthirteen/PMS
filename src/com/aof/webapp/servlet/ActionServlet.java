	/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.servlet;

import java.io.IOException;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.hibernate.Session;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.security.Security;
import com.aof.core.security.SecurityConfigurationException;
import com.aof.core.security.SecurityFactory;
import com.aof.util.Constants;
import org.apache.commons.logging.Log;

/**
 * @author xxp 
 * @version 2003-6-24
 *
 */
public class ActionServlet extends org.apache.struts.action.ActionServlet {
	Logger log = Logger.getLogger(ActionServlet.class.getName());
	//static List queryList = null;
	//static boolean refreshList = false;
	
	public void init() throws ServletException
	{
	  super.init();
	  log.info("[= Start the AOF System =]");
	  //getSession();
	  getSecurity();
	}
	
	protected void process (HttpServletRequest request,HttpServletResponse response) throws IOException, ServletException{
		HttpSession session = request.getSession();

		Security security = (Security) session.getAttribute(Constants.SECURITY_HANDLER_KEY);
		
		//init the attribute of the session object and put the security object to SECURITY_HANDLER_KEY
		if (security == null) {
			security = (Security) getServletContext().getAttribute(Constants.SECURITY_HANDLER_KEY);
			if (security == null) {
				log.error("ERROR: security not found in ServletContext"); 
			}
			session.setAttribute(Constants.SECURITY_HANDLER_KEY, security);
			log.info("[PUT SECURITY_HANDLER_KEY]->"+security);
		}
		
		ActionErrors errors = (ActionErrors) session.getAttribute(Constants.ERROR_KEY);
		if ( errors != null && !errors.isEmpty()){
			log.info("系统发生错误!");
			ActionForward forward = new ActionForward();
			forward.setPath("/error/Error.jsp");
			forward.setRedirect(true);
			session.setAttribute(Constants.ERROR_KEY,new ActionErrors());
		}
		
		//session.setAttribute("QueryList",getQueryList(request));
		
		super.process(request,response);
		/*
		try {
			super.process(request,response);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ServletException e) {
			e.printStackTrace();
		}
		*/		
	}
	/*
	protected void processActionForward(ActionForward forward,
										ActionMapping mapping,
										ActionForm formInstance,
										HttpServletRequest request,
										HttpServletResponse response)throws IOException, ServletException 
	{

		HttpSession session = request.getSession();

		Security security = (Security) session.getAttribute(Constants.SECURITY_HANDLER_KEY);
		
		//init the attribute of the session object and put the security object to SECURITY_HANDLER_KEY
		if (security == null) {
			security = (Security) getServletContext().getAttribute(Constants.SECURITY_HANDLER_KEY);
		}
		if (security == null) {
			log.error("ERROR: security not found in ServletContext"); 
		}
		session.setAttribute(Constants.SECURITY_HANDLER_KEY, security);
		log.info("[PUT SECURITY_HANDLER_KEY]->"+security);
		
		//init the attribute of the session object and put the hibernateSession object to HIBERNATE_SESSION_KEY
		//		net.sf.hibernate.Session hibernateSession = (net.sf.hibernate.Session) session.getAttribute(Constants.HIBERNATE_SESSION_KEY);
		//		if (hibernateSession == null) {
		//			hibernateSession = (net.sf.hibernate.Session) getServletContext().getAttribute(Constants.HIBERNATE_SESSION_KEY);
		//		}
		//		if (hibernateSession == null) {
		//			log.error("ERROR: hibernateSession not found in ServletContext"); 
		//		}
		//		session.setAttribute(Constants.HIBERNATE_SESSION_KEY, hibernateSession);
		//		log.info("[PUT HIBERNATE_SESSION_KEY]->"+hibernateSession);
		
		ActionErrors errors = (ActionErrors) session.getAttribute(Constants.ERROR_KEY);
		if ( errors != null && !errors.empty()){
			forward = new ActionForward();
			forward.setPath("/error/Error.jsp");
			session.setAttribute(Constants.ERROR_KEY,new ActionErrors());
		}
		super.processActionForward(forward,mapping,formInstance,request,response);
	}
	*/
	
	 
	/**
	 * @return
	 */
	private Security getSecurity() {
		Security security = (Security) getServletContext().getAttribute(Constants.SECURITY_HANDLER_KEY);
		if (security == null) {

			try {
				security = SecurityFactory.getInstance(SecurityFactory.AOFSecurity);
			} catch (SecurityConfigurationException e) {
				log.error("ERROR: No instance of security imeplemtation found."+e.getMessage());
			}
			getServletContext().setAttribute(Constants.SECURITY_HANDLER_KEY, security);
			if (security == null)
				log.error("ERROR: security create failed.");
		}
		log.info("[= INIT_AOF_SECURITY_SUCCESS =]");		
		return security;
	}
	
	/*
	private List getQueryList(HttpServletRequest request){
		if(queryList == null){
			queryList = new ArrayList();
		}
		return queryList;
			
	}
	*/
	
	/**
	 * @return
	 */
	private Session getSession(){ 
		net.sf.hibernate.Session session = (net.sf.hibernate.Session) getServletContext().getAttribute(Constants.HIBERNATE_SESSION_KEY);
		if (session == null){
			try{
				session = Hibernate2Session.currentSession();
			}catch(Exception e){
				log.error("ERROR: No instance of hibernateSession imeplemtation found."+e.getMessage());
				e.printStackTrace();
			}
		}
		getServletContext().setAttribute(Constants.HIBERNATE_SESSION_KEY,session);
		if(session == null){
			log.error("ERROR: delegator create failed.");	
		}else{
			log.info("[= INIT_AOF_SESSION_SUCCESS =]");
		}
	
		return session;
	}
}
