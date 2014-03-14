/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.party;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import com.aof.component.BaseServices;
import com.aof.component.domain.module.Module;
import com.aof.component.domain.module.ModuleGroup;
import com.aof.component.domain.module.ModuleServices;
import com.aof.component.domain.security.SecurityGroup;
import com.aof.component.domain.security.SecurityPermission;

/**
 * @author xxp 
 * @version 2003-6-24
 *
 */
public class UserLoginServices extends BaseServices {

	public UserLoginServices(){
		super();
	}
	
	/**
	 * @description 获得登陆用户的权限点
	 * @param userLogin
	 * @return List
	 */
	public List getUserLoginSecurityPermission(UserLogin userLogin) throws HibernateException{
		this.createSession();

		List result = new ArrayList();
		userLogin = (UserLogin)session.load(UserLogin.class,userLogin.getUserLoginId());
		
		Set sgSet = userLogin.getSecurityGroups();
		if(sgSet != null){
			Iterator sgIter = sgSet.iterator();
			while(sgIter.hasNext()){
				SecurityGroup sg = (SecurityGroup)sgIter.next();
				
				Set spSet = sg.getSecurityPermissions();
				Iterator spIter = spSet.iterator();
				while(spIter.hasNext()){
					SecurityPermission sp = (SecurityPermission)spIter.next();
					result.add(sp.getPermissionId());	 
					
				}
			}
		}
		
		this.closeSession();
		return result;		

	}

	/**
	 * @description 获得登陆用户的模块列表
	 * @param userLogin
	 * @return
	 * @throws HibernateException
	 */
	public List getUserLoginModule(UserLogin userLogin) throws HibernateException{  
		this.createSession();
		
		List result = new ArrayList();
		ModuleServices ms = new ModuleServices();
		//log.info("userLoginid="+userLogin.getName());
		try {
			userLogin = (UserLogin)session.load(UserLogin.class,userLogin.getUserLoginId());
			Set mgSet = userLogin.getModuleGroups();
			Iterator it = session.filter(mgSet, "order by priority").iterator();
			
			while(it.hasNext()){
				ModuleGroup mg = (ModuleGroup)it.next();
				
				//log.info(mg.getModuleGroupId()+mg.getDescription());	
				Set mSet = mg.getModules();
				Iterator mit = session.filter(mSet, "order by MODULE_ID").iterator();
				
				Map map = new TreeMap();
				while(mit.hasNext()){
					Module m = (Module)mit.next();   
					if(m.getVisbale().equals("Y")){
						List list = ms.getChildModules(m.getModuleId(),session);
						//log.info(list);
						map.put(m.getModuleId(),list);
					}
				}
				result.add(map);
			}
		} catch (HibernateException e) {
			log.error("error:"+e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			log.error("error:"+e.getMessage());
			e.printStackTrace();
		}
		
		this.closeSession();
		
		return result;
	}	

	/**
	 * @description 获得登陆用户角色
	 * @param ul
	 * @return
	 * @throws HibernateException
	 */
	public String getUserLoginRole(UserLogin ul) throws HibernateException{
		this.createSession();
		
		List supList = new ArrayList();
		ul = (UserLogin)session.load(UserLogin.class,ul.getUserLoginId());
		
		Iterator it = ul.getParty().getPartyRoles().iterator();
		RoleType rt = null;
		while(it.hasNext()){
			rt= (RoleType) it.next();
			break;
		}
		
		this.closeSession();
		if(rt != null){
			return rt.getRoleTypeId();
		}else{
			return "";
		}
		
	}
	
	/**
	 * @description 增加登陆用户
	 * @param ul
	 * @throws HibernateException
	 */
	public void importUserLogin(List userList) throws HibernateException {
		Session sess = this.getSession();
		Transaction tx = null;
		try {
			tx = sess.beginTransaction();
			Iterator itor=userList.iterator();
			while (itor.hasNext()) {
				UserLogin user=(UserLogin) itor.next();
				sess.save(user);
			}
		
			sess.flush();
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		} finally {
			this.closeSession();
		}
	}
	
	/**
	 * @description 增加登陆用户
	 * @param ul
	 * @throws HibernateException
	 */
	public void importUserLogin(UserLogin user,Session sess,boolean newUser) throws HibernateException {
		try {
			if (newUser) {
				sess.save(user);
			} else {
				sess.update(user);
			}
			sess.flush();
		} catch (HibernateException e) {
		} 
	}
	
	
	/**
	 * @description 增加登陆用户的安全组
	 * @param ul
	 * @param securityGroupId
	 * @throws HibernateException
	 */
	public void addUserLoginSecurityGroup(UserLogin ul,String securityGroupId) throws HibernateException{
		this.createSession();
		Transaction tx = session.beginTransaction();
		Set mset = ul.getSecurityGroups();
		if(mset==null){
			mset = new HashSet();
		}
		mset.add((SecurityGroup)session.load(SecurityGroup.class,securityGroupId));
		ul.setSecurityGroups(mset);
		session.update (ul);
		tx.commit();		
		this.closeSession();
	}
	
	/**
	 * @description 整加登陆用户的模块组
	 * @param ul
	 * @param moduleGroupId
	 * @throws HibernateException
	 */
	public void addUserLoginModuleGroup(UserLogin ul,String moduleGroupId) throws HibernateException{
		this.createSession();
		Transaction tx = session.beginTransaction();
		Set mset = ul.getModuleGroups();
		if(mset==null){
			mset = new HashSet();
		}
		mset.add((ModuleGroup)session.load(ModuleGroup.class,moduleGroupId));
		ul.setModuleGroups(mset);
		session.update (ul);
		tx.commit();
		this.closeSession();
	}
	
	/**
	 * @description 删除登陆用户的安全组
	 * @param ul
	 * @param securityGroupId
	 * @throws HibernateException
	 */
	public void deleteUserLoginSecurityGroup(UserLogin ul,String securityGroupId) throws HibernateException {
		this.createSession();
		Transaction tx = session.beginTransaction();
		Set mset = ul.getSecurityGroups();

		mset.remove((SecurityGroup)session.load(SecurityGroup.class,securityGroupId));
		session.update (ul);
		tx.commit();
		this.closeSession();
		
	}
	
	/**
	 * @description 删除登陆用户的模块组
	 * @param ul
	 * @param moduleGroupId
	 * @throws HibernateException
	 */
	public void deleteUserLoginModuleGroup(UserLogin ul,String moduleGroupId ) throws HibernateException {
		this.createSession();
		Transaction tx = session.beginTransaction();
		Set mset = ul.getModuleGroups();
		mset.remove((ModuleGroup)session.load(ModuleGroup.class,moduleGroupId));
		session.update (ul);
		tx.commit();
		this.closeSession();
	}
	
	public void updateUserLogin(UserLogin ul) throws HibernateException
	{
		try{
			this.getSession().update(ul);
			this.getSession().flush();
		}
		finally{
			this.closeSession();
		}
	}
	
	public UserLogin getUserLogin(String id) throws HibernateException
	{
		try{
			return (UserLogin) this.getSession().get(UserLogin.class,id);
		}
		finally{
			this.closeSession();
		}
		
	}
	
	public UserLogin getUserLogin(String id,Session sess) throws HibernateException
	{
		return (UserLogin) sess.get(UserLogin.class,id);
	}
	
	public String getCustUserID(Session sess) throws HibernateException {
		String CodePrefix = "C00";
		Query q = sess.createQuery("select max(ul.userLoginId) from UserLogin as ul where ul.userLoginId like '"+CodePrefix+"%'");
		List result=q.list();
		int count = 0;
		String GetResult = (String)result.get(0);
		if (GetResult !=  null)
			count = (new Integer(GetResult.substring(CodePrefix.length()))).intValue();
		return getCustUserID(CodePrefix,count+1);
	}
	private String getCustUserID(String CodePrefix,int no)
	{
		StringBuffer sb=new StringBuffer();
		sb.append(CodePrefix);
		sb.append(fillPreZero(no,6));
		return sb.toString();
	}
	private String fillPreZero(int no,int len) {
		String s=String.valueOf(no);
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<len-s.length();i++)
		{
			sb.append('0');
		}
		sb.append(s);
		return sb.toString();
	}
}
