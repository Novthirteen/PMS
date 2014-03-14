/*
 * $Header: /home/cvsroot/HelpDesk/src/com/aof/component/useraccount/UserAccount.java,v 1.1 2004/11/10 01:39:04 nicebean Exp $
 * $Revision: 1.1 $
 * $Date: 2004/11/10 01:39:04 $
 *
 * ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ====================================================================
 */
package com.aof.component.useraccount;

import java.util.List;

import org.apache.log4j.Logger;

import net.sf.hibernate.HibernateException;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.domain.party.UserLoginServices;
import com.aof.util.UtilDateTime;

/**
 * 用户信息对象
 *
 * @author XingPing Xu  
 * @version $Revision: 1.1 $ $Date: 2004/11/10 01:39:04 $
 */

public class UserAccount {
	private String userId;
	private String userName;
	private String password;
	private String role;
	private Party party;

	private UserLogin userLogin;
	private List securityPermissions;
	private List modules;
	
	private Logger log = Logger.getLogger(UserAccount.class.getName());
	
	public UserAccount(UserLogin userLogin){
		//log.info("开始为登陆用赋值 userlogin | userId | userName | password | party START");
		//log.info(UtilDateTime.nowTimestamp());
		
		this.userLogin = userLogin;
		this.userId = userLogin.getUserLoginId();
		this.userName = userLogin.getCurrent_password();
		this.password = userLogin.getCurrent_password();
		this.party = userLogin.getParty();

		//log.info(UtilDateTime.nowTimestamp());
		//log.info("开始为登陆用赋值 userlogin | userId | userName | password | party END");

	}
	/**
	 * @return
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param string
	 */
	public void setUserName(String string) {
		userName = string;
	}

	/**
	 * @return
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * @param string
	 */
	public void setPassword(String string) {
		password = string;
	}

	/**
	 * @return
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @return
	 */
	public Party getUserParty() {
		return party;
	}

	/**
	 * @param string
	 */
	public void setUserId(String string) {
		userId = string;
	}

	/**
	 * @return
	 */
	public List getSecurityPermission() {
		List result = null;
		//log.info("开始获得登陆权限点 START");
		//log.info(UtilDateTime.nowTimestamp());
		
		try {
			UserLoginServices uls = new UserLoginServices();
			result = uls.getUserLoginSecurityPermission(this.userLogin);
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			e.printStackTrace();
		}

		//log.info(UtilDateTime.nowTimestamp());
		//log.info("开始获得登陆权限点 END");
		return result;
	}
	
	public List getModules(){
		List result = null;
		//log.info("开始获得系统登陆用户菜单 START");
		//log.info(UtilDateTime.nowTimestamp());
		
		try {
			UserLoginServices uls = new UserLoginServices();
			result = uls.getUserLoginModule(this.userLogin);
			  
		} catch (HibernateException e) {
			log.error(e.getMessage());
			e.printStackTrace();
		}
		//log.info(UtilDateTime.nowTimestamp());
		
		//log.info("开始获得系统登陆用户菜单 END");
		return result;
	} 
	/**
	 * @return
	 */
	public UserLogin getUserLogin() {
		return userLogin;
	}

	/**  
	 * @param list
	 */
	public void setSecurityPermission(List list) {
		securityPermissions = list;
	}

	/**
	 * @param login
	 */
	public void setUserLogin(UserLogin login) {   
		userLogin = login;
	}

	
	/**
	 * @return   
	 */   
	public String getRole() {
		String result = null;
		//log.info("开始获得用户角色:"+result+" START");
		//log.info(UtilDateTime.nowTimestamp());
		
		try {
			UserLoginServices uls = new UserLoginServices();
			result = uls.getUserLoginRole(this.userLogin);
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			e.printStackTrace();
		}
		//log.info(UtilDateTime.nowTimestamp());

		//log.info("开始获得用户角色:"+result+" END");
		return result;
	}

	public String getPartyId(){
		
		String result = null;
		//log.info("开始获得用户在QAD中机构编码:"+result+" START");
		//log.info(UtilDateTime.nowTimestamp());

		try {
			result = userLogin.getParty().getNote();
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		}
		//log.info(UtilDateTime.nowTimestamp());

		//log.info("开始获得用户在QAD中机构编码:"+result+" END");
		
		return result;
	}
	
	public String getTruePartyId(){
		
		String result = null;
		//log.info("开始获得用户在QAD中机构编码:"+result+" START");
		//log.info(UtilDateTime.nowTimestamp());

		try {
			result = userLogin.getParty().getPartyId();
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		}
		//log.info(UtilDateTime.nowTimestamp());

		//log.info("开始获得用户在QAD中机构编码:"+result+" END");
		
		return result;
	}
	
	public String getUserLoginRoleId(){
		String result = null;
		result = userLogin.getRole();
		if(result == null){
			result = "";
		}
		return result ;
	}
	
	
	public List getSubPartys(){
		log.info(UtilDateTime.nowTimestamp());

		List result = null;
		PartyHelper ph = new PartyHelper();
		result  = ph.getGroupRollupParty(userLogin.getParty());
		log.info(UtilDateTime.nowTimestamp());

		return result;
	}

}
