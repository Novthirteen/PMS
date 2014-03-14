/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.util;

import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.GeneralException;

import net.sf.hibernate.*;
/**
 * @author xxp 
 * @version 2003-10-27
 *
 */
public class BasicBean {


	protected Session hs;//hibernate会话
	protected Transaction transaction; //hiberante事务
    
	public BasicBean() throws Exception
	{
		this.initHibernate();
	}
	protected void initHibernate(){
		try {
			if(hs==null){
				hs = Hibernate2Session.currentSession();
			}else{
				if(!hs.isOpen()){
					try {
						hs.connection();
					} catch (HibernateException e1) {
						e1.printStackTrace();
					}
				}
			}
		} catch (GeneralException e) {
			e.printStackTrace();
		}
	}
    
	protected void begin(){
 		try {
 			if(hs==null){
				initHibernate();
 			}else{
				if(!hs.isOpen()){
					try {
							hs = Hibernate2Session.currentSession();
					} catch (Exception e1) {
							e1.printStackTrace();
					}
				}
 			}
			transaction = hs.beginTransaction();
		} catch (HibernateException e) {
			try {
				this.close();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
	}
	
    
	protected void commit(){
		try{
			transaction.commit();
		}catch(Exception e){
			try {
				this.close();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
	}
	
	protected void rollback(){
		try{
			transaction.rollback();
		}catch(Exception e){
			try {
				this.close();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
	}
	
	protected void close() throws Exception{
		Hibernate2Session.closeSession();
	}

}
