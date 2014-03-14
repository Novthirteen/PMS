/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.crm.customer;

import java.util.ArrayList;
import java.util.List;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import com.aof.component.domain.party.PartyKeys;

/**
 * @author xxp 
 * @version 2003-7-1
 *
 */
public class CustomerHelper {
	public CustomerHelper() {
	}
	public List getCustomers(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.createQuery("select p from CustomerProfile as p").list();
		//result = session.fin
		return result;
	}
	public List getAllAccounts(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.createQuery("select p from CustomerAccount as p order by p.Description").list();
		//result = session.fin
		return result;
	}
	public List getAllIndustry(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.createQuery("select p from Industry as p order by p.Description").list();
		//result = session.fin
		return result;
	}
	public List getAllT2Code(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.createQuery("select p from CustT2Code as p order by p.T2Code").list();
		//result = session.fin
		return result;
	}

}