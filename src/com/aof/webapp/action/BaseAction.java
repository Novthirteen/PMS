/*
 * Created on Feb 23, 2003
 */
package com.aof.webapp.action;



import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;

import com.aof.component.prm.project.FMonth;
import com.aof.component.useraccount.UserAccount;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.PageKeys;
import com.aof.util.UtilDateTime;
import com.aof.webapp.listener.SessionListener;

/**
 * @author xxp
 */
public abstract class BaseAction extends Action
{
	private Session  _hibernateSession;
	
	
	Logger log = Logger.getLogger(BaseAction.class.getName());
	
	public void closeHibernateSession(){
		if( _hibernateSession != null){
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public Session getHibernateSession(HttpServletRequest request ){
			
			//_hibernateSession = (Session)request.getSession().getAttribute(Constants.HIBERNATE_SESSION_KEY);
			if ( _hibernateSession == null )
			{
				try {
					_hibernateSession=Hibernate2Session.currentSession();
				} catch (Exception e) {
					try{
				
						_hibernateSession = Hibernate2Session.currentSession();
						return _hibernateSession;
					}catch(Exception he){
						log.error(he.getMessage());
						//e.printStackTrace();  
					}
					e.printStackTrace();
				}
			}
			if ( !_hibernateSession.isOpen(  ) )
			{ 
				if ( !_hibernateSession.isConnected() ){
					try {
						_hibernateSession.reconnect();
					} catch (HibernateException e) {
						try{
							_hibernateSession = Hibernate2Session.currentSession();
							return _hibernateSession;
						}catch(Exception he){
							log.error(he.getMessage());
							//e.printStackTrace();
						}
						e.printStackTrace();
					}
				}
			}
			return _hibernateSession;
	}
	
	protected void initSession(javax.servlet.http.HttpSession session, UserAccount userAccount, String ip)
	{
		//log.info("[InitialUserInformation]=>[START]");
		session.setAttribute( Constants.USERID_KEY, userAccount.getUserId(  ) );
		session.setAttribute( Constants.USERNAME_KEY, userAccount.getUserName(  ) );
		session.setAttribute( Constants.USERLOGIN_KEY, userAccount.getUserLogin());
		session.setAttribute( Constants.SECURITY_KEY, userAccount.getSecurityPermission());
		session.setAttribute( Constants.MODELS_KEY, userAccount.getModules());  
		session.setAttribute( Constants.USER_ROLE_KEY, userAccount.getRole());
		session.setAttribute( Constants.USERLOGIN_ROLE_KEY, userAccount.getUserLoginRoleId());
		session.setAttribute( Constants.PARTY_KEY, userAccount.getPartyId());
		session.setAttribute( Constants.TRUE_PARTY_KEY, userAccount.getTruePartyId());
		session.setAttribute( Constants.SUB_PARTY_KEY, userAccount.getSubPartys());
		session.setAttribute( Constants.ERROR_KEY,new ActionErrors());
		session.setAttribute( Constants.ONLINE_USER_IP_ADDRESS, ip);
		session.setAttribute(Constants.ONLINE_USER_LISTENER, new SessionListener());
		
		log.info("[InitialUserInformation]=>[END]");
	}
	 
	/**
	 * 清除系统缓存数据
	 * SECURITY_KEY
	 * MODELS_KEY
	 * USER_KEY
	 *
	 */
	protected void clearSession(javax.servlet.http.HttpSession session )
	{
		//log.info("[ReleaseUserInformation]=>[START]");
		session.removeAttribute(Constants.ONLINE_USER_LISTENER);
		session.removeAttribute( Constants.USERID_KEY );
		session.removeAttribute( Constants.USERNAME_KEY);
		session.removeAttribute( Constants.USERLOGIN_KEY );
		session.removeAttribute( Constants.SECURITY_KEY );
		session.removeAttribute( Constants.MODELS_KEY );
		session.removeAttribute( Constants.USERLOGIN_KEY );
		session.removeAttribute( Constants.USER_ROLE_KEY);
		session.removeAttribute( Constants.USERLOGIN_ROLE_KEY );
		session.removeAttribute( Constants.PARTY_KEY );
		session.removeAttribute( Constants.TRUE_PARTY_KEY );
		session.removeAttribute( Constants.SECURITY_HANDLER_KEY );
		session.removeAttribute( Constants.SUB_PARTY_KEY );
		
		if(session.getAttribute(Constants.HIBERNATE_SESSION_KEY)!=null){
			try {
				((net.sf.hibernate.Session)session.getAttribute(Constants.HIBERNATE_SESSION_KEY)).close();
				log.info("[ReleaseConnectionSession Success]");
			} catch (HibernateException e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		session.removeAttribute( Constants.HIBERNATE_SESSION_KEY);
		session.removeAttribute( Constants.ERROR_KEY );
		session.removeAttribute(Constants.ONLINE_USER_IP_ADDRESS);
		session.invalidate();

		log.info("[ReleaseUserInformation]=>[END]");
		
	}
	
	protected ActionErrors getActionErrors(javax.servlet.http.HttpSession session){
		ActionErrors errors = (ActionErrors) session.getAttribute(Constants.ERROR_KEY);
		if(errors == null ){
			errors = new ActionErrors();
			session.setAttribute(Constants.ERROR_KEY,errors);
		}
		return errors;
	}
	
	protected void saveToken(HttpServletRequest request)
	{
		HttpSession session = request.getSession();
		String token = generateToken(request);
		if(token != null)
		{
			session.setAttribute(PageKeys.TOKEN_SESSION_NAME, token);
		}
	}	
	
	protected boolean isTokenValid(HttpServletRequest request)
	{
		HttpSession session = request.getSession(false);
		if(session == null)
		{
			return false;
		}
		String saved = (String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME);
		if(saved == null)
		{
			return false;
		}
		String token = request.getParameter(PageKeys.TOKEN_PARA_NAME);
		if(token == null)
		{
			return false;
		} else
		{
			return saved.equals(token);
		}
	}
	
	protected String generateToken(HttpServletRequest request)
	{
		HttpSession session = request.getSession();
		try
		{
			byte id[] = session.getId().getBytes();
			byte now[] = (new Long(System.currentTimeMillis())).toString().getBytes();
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(id);
			md.update(now);
			return toHex(md.digest());
		}
		catch(IllegalStateException illegalstateexception)
		{
			return null;
		}
		catch(NoSuchAlgorithmException nosuchalgorithmexception)
		{
			return null;
		}
	}
	
	public static List getPageNumberList(PageBean pageBean) {
		List pageNumberList = new ArrayList();
		PageNumberBean pageNumberBean;

		if (pageBean.getAllPage() > 0) {
			if (pageBean.getCurrentPage() > 1) {
				pageNumberBean = new PageNumberBean();
				pageNumberBean.setPageNumber("<<");
				pageNumberBean.setPageLink(
					new Integer(pageBean.getCurrentPage() - 1).toString());
				pageNumberList.add(pageNumberBean);					
			}
			for (int i = 1; i <= pageBean.getAllPage(); i++) {
				pageNumberBean = new PageNumberBean();
				pageNumberBean.setPageNumber(new Integer(i).toString());
				if (pageBean.getCurrentPage() == i) {
					pageNumberBean.setPageLink("0");
				} else {
					pageNumberBean.setPageLink(new Integer(i).toString());
				}
				pageNumberList.add(pageNumberBean);
			}
			if (pageBean.getCurrentPage() < pageBean.getAllPage()) {
				pageNumberBean = new PageNumberBean();
				pageNumberBean.setPageNumber(">>");
				pageNumberBean.setPageLink(
					new Integer(pageBean.getCurrentPage() + 1).toString());
				pageNumberList.add(pageNumberBean);					
			}
		}
		return pageNumberList;
	}
	public String FreezeDateCheck (Date dayEnd) {
		String FreezeFlag ="N";
		if (dayEnd == null) return FreezeFlag;
		try {
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
			Query q = hs.createQuery("select fm from FMonth as fm where fm.DateTo >=:DataPeriod and fm.DateFrom <=:DataPeriod");
			q.setParameter("DataPeriod",dayEnd);
			List result = q.list();
			Iterator itFm = result.iterator();
			if (itFm.hasNext()) {
				FMonth fm =(FMonth)itFm.next();
				if (fm.getDateFreeze().compareTo(new Date()) < 0) {
					FreezeFlag = "Y";
					return FreezeFlag;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return FreezeFlag;
	}
}