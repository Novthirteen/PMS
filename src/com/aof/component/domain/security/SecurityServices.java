
/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */

package com.aof.component.domain.security;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import com.aof.component.BaseServices;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Transaction;

  
/**
 * @author xxp 
 * @version 2003-6-16
 *
 */
public class SecurityServices extends BaseServices{
	public SecurityServices(){
		super();
	}
    
    
	/*****************************************************************************************
	 * 维护系统的securityGroup表
	 * 
	 * @param groupId
	 * @param description
	 * @return
	 * @throws HibernateException
	 * 
	 * ***************************************************************************************
	 */

	public SecurityGroup updateSecurityGroup(String groupId,String description) throws HibernateException {
        
		SecurityGroup sg = null;

		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			sg = (SecurityGroup)session.load(SecurityGroup.class,groupId);
			sg.setDescription(description);
			session.save(sg);
			tx.commit();
		}
		catch (HibernateException he) {
			if (tx!=null) tx.rollback();
			throw he;
		}
		finally {
			session.close();
		}
		return sg;
	}
	
	public SecurityGroup deleteSecurityGroup(String groupId) throws HibernateException {
        
		SecurityGroup sg = null;
        

		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			sg = (SecurityGroup)session.load(SecurityGroup.class,groupId);
			session.delete(sg);
			tx.commit();
		}
		catch (HibernateException he) {
			if (tx!=null) tx.rollback();
			throw he;
		}
		finally {
			session.close();
		}
		return sg;
	}

	/**
	 * @param permissionId
	 * @param description
	 * @return
	 * @throws HibernateException
	 */
	public SecurityGroup findSecurityGroup(String groupId) throws HibernateException {
		SecurityGroup sg = null;

		try {
			sg = (SecurityGroup)session.load(SecurityGroup.class,groupId);
			
		}
		catch (HibernateException he) {
			throw he;
		}
		finally {
		}
		return sg;
	}    
	
	



	public List findSecurityGroupPermissionBySecurityGroup() throws HibernateException {
		List result = new ArrayList();
		
		Transaction tx = null;
		try{
			result = session.find("select sg,sgp from SecurityGroup as sg , SecurityGroupPermission as sgp" +
				"where sg.groupId = sgp.groupId");
			
		}catch(HibernateException he){
			if (tx!=null) tx.rollback();
			throw he;
		}finally{
			session.close();
		}
		return result;
	}
	
	
	
	/**
	 * @param permissionId
	 * @param description
	 * @return
	 * @throws HibernateException
	 */
	public SecurityPermission createSecurityPermission(String permissionId, String description) throws HibernateException{
		SecurityPermission sp = new SecurityPermission();
		sp.setPermissionId(permissionId);
		sp.setDescription(description);
		Transaction tx = null;
		try{
			tx = session.beginTransaction();
			session.save(sp);
			tx.commit();
		}catch(HibernateException he){
			if (tx!=null) tx.rollback();
			throw he;
		}
		return sp;
	}

	public SecurityPermission updateSecurityPermission(String permissionId, String description) throws HibernateException{
		SecurityPermission sp = null;
		Transaction tx = null;
		try{
			tx = session.beginTransaction();
			sp = (SecurityPermission)session.load(SecurityPermission.class,permissionId);
			sp.setDescription(description);
			session.update(sp);
			tx.commit();
		}catch(HibernateException he){
			if (tx!=null) tx.rollback();
			throw he;
		}
		return sp;
	}
	
	public SecurityPermission deleteSecurityPermission(String permissionId) throws HibernateException{
		SecurityPermission sp = null;
		Transaction tx = null;
		try{
			tx = session.beginTransaction();
			sp = (SecurityPermission)session.load(SecurityPermission.class,permissionId);
			session.delete(sp);
			tx.commit();
		}catch(HibernateException he){
			if (tx!=null) tx.rollback();
			throw he;
		}
		return sp;
	}
	
	
	public SecurityGroup createSecurityGroupPermission(SecurityGroup sg ,Set securityPermissions) throws HibernateException {
		Transaction tx = null;
		try{	
			
			tx = session.beginTransaction();
			sg.setSecurityPermissions(securityPermissions);
			session.save(sg);
			tx.commit();
		}catch(HibernateException he){
			if (tx!=null) tx.rollback();
			throw he;			
		}
		return sg; 
	}
}
