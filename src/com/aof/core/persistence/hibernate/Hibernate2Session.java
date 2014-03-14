package com.aof.core.persistence.hibernate;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Hashtable;

   
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.SessionFactory;
import net.sf.hibernate.cfg.Configuration;

import org.apache.log4j.Logger;

import com.aof.component.domain.party.Party;
import com.aof.util.GeneralException;
import com.aof.util.PropertiesUtil;
 
/**
 * @author xxp  
 * 
 * This is for Hibernate version 2.x
 *   
 */
public class Hibernate2Session {

	// Add a Log4J logger
	static Logger log = Logger.getLogger(Hibernate2Session.class.getName());

	static Configuration cfg = null;
	static SessionFactory sf = null;

	static {
		try {
			init();
		} catch (Exception e) {
			log.error("could not init " + e.getMessage());
		}
	}

	/**
	 * Make this class a singleton
	 */
	private Hibernate2Session() {
		super();
	}

	public static final ThreadLocal local = new ThreadLocal();

	public static void configure() throws Hibernate2Exception{
		init();
	}
	/**
	 * Retrieve the current Hibernate Session object via the ThreadLocal
	 * class.
	 * 
	 * @return Session
	 * @throws PortalException
	 * 
	 */
	
	public static Session currentSession() throws GeneralException {

		Session session = (Session) local.get();
		if (session == null) {
			Connection con = null;

			// create a datasource object
			if (sf == null) {
				init();
			}

			try {   
				session = sf.openSession();
				
			}catch(Exception e){
				log.error("Exception: " + e.getMessage());
				throw new GeneralException("Exception: " + e.getMessage());
				
			}
			local.set(session);
		}
		
		return session;
	}  

	/**
	 * Close the Hibernate Session and any underlying Connection
	 * for further cleanup
	 * 
	 * @param uc - the user's container object stored in the session
	 * @return String - the hashcode of the session object that was closed
	 * 					for debug purposes		
	 * @throws HibernateException, SQLException
	 */
	public static void closeSession()
		throws HibernateException,SQLException {
		Connection con = null;

		Session session = (Session) local.get();

		//String sessionHashCode = session.toString();
		
		local.set(null);
		if (session != null) {
			con = session.close();
		}   

		if (con != null) {
		
			con.close();
		}  
		 
		//return sessionHashCode;
	}

	private static synchronized void init() throws Hibernate2Exception {
		if (sf != null) {
			// check again because more than 1 user might be
			// trying to do this at the same time.  just return.
			return;  
		}
		cfg = null;
		try {  
			sf = new Configuration().configure().buildSessionFactory();
			//sf = new Configuration().addClass(Party.class).addClass(OrderHeader.class).addClass(InventoryItem.class).addClass(Module.class).buildSessionFactory();
			log.info("HibernateSession Initialized SessionFactory=" + sf); 
		} catch (Exception e) {
			log.error(
				"Could not intialize Hibernate session factory. "
					+ e.getMessage());
			throw new Hibernate2Exception(
				"Could not intialize Hibernate session factory. "
					+ e.getMessage());
		}
	}
}  
