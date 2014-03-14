package com.aof.component;

import org.apache.log4j.Logger;   

import net.sf.hibernate.Session;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.shcnc.hibernate.CompositeQuery;
import com.shcnc.hibernate.QueryCondition;
/**
 * @author xxp 
 * @version 2003-6-25
 *  
 */
public class BaseServices {   
	protected Session session = null;

	protected Logger log = Logger.getLogger(BaseServices.class.getName());
	
	protected BaseServices(){
	}
	
	protected void createSession(){
		try {
			this.session = Hibernate2Session.currentSession();
			log.info("Session=>"+session);
			  
		} catch (Exception e) {
			log.error("[Create Hibernate2Session Failed:]"+e.getMessage());
			e.printStackTrace();
		}
	}
	
	public void closeSession(){
		try {
			Hibernate2Session.closeSession();  
			this.session=null;
		} catch (Exception e) {
			log.error("[Close Hibernate2Session Failed:]"+e.getMessage());
			e.printStackTrace();
		}		
	}
	
	/**
	 * @return
	 */
	public Session getSession() {
		if(this.session==null)
		{
			createSession();
		}
		return session;
	}

	/**
	 * @param session
	 */
	public void setSession(Session session) {
		this.session = session;
	}


	protected void makeSimpeCondition(final CompositeQuery query, final String sql, final Object parameter) {
		QueryCondition qc=query.createQueryCondition(sql);
		qc.appendParameter(parameter);
	}

	protected void makeSimpeCondition(final CompositeQuery query, final String sql, final Object[] parameters) {
		QueryCondition qc=query.createQueryCondition(sql);
		for (int i = 0; i < parameters.length; i++) {
		    qc.appendParameter(parameters[i]);
		}
	}

	protected void makeSimpeLikeCondition(final CompositeQuery query, final String sql, final Object parameter) {
		makeSimpeCondition(query, sql, '%' + parameter.toString() + '%');
	}

	protected void makeSimpeLikeCondition(final CompositeQuery query, final String sql, final Object[] parameters) {
		QueryCondition qc=query.createQueryCondition(sql);
		for (int i = 0; i < parameters.length; i++) {
		    qc.appendParameter('%' + parameters[i].toString() + '%');
		}
	}
	protected void makeSimpeLeftLikeCondition(final CompositeQuery query, final String sql, final Object parameter) {
		makeSimpeCondition(query, sql, parameter.toString() + "%");
	}
	
	public static boolean isEqual(Object o1, Object o2) {
	    if (o1 == null) return o2 == null;
	    return o1.equals(o2);
	}

}
