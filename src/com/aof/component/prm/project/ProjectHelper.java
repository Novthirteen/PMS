/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.project;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import java.sql.SQLException;
import java.util.*;

import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.*;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.core.persistence.*;
import com.aof.util.GeneralException;

/**
 * @author xxp 
 * @version 2003-7-1
 *
 */
public class ProjectHelper {


	public ProjectHelper() {
	}
	
	//获得所有Project Event
	public List getAllEvent(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.find("from ProjectEvent pe ");
		return result ;
	}
		
	public List getAllEventType(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.find("from ProjectEventType pet ");
		return result ;
	}
			
	public List getAllProjectType(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.find("from ProjectType pt ");
		return result ;
	}
	public List getAllExpenseType(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.find("from ExpenseType et ");
		return result ;
	}
	
	public List getAllProjectCategory(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.find("from ProjectCategory pc ");
		return result ;
	}
	
	public List getAllCurrency(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.find("from CurrencyType ct");
		return result ;
	}
}
