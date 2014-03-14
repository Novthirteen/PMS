/*
 * Created on 2005-4-28
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.prm.originaldata.BillingLoader;
import com.aof.component.prm.originaldata.CAFLoader;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class DataLoadAction extends BaseAction {
	private Logger log = Logger.getLogger(DataLoadAction.class);
	
	public ActionForward perform(ActionMapping mapping,
			 ActionForm form,
			 HttpServletRequest request,
			 HttpServletResponse response) {
		
		Transaction transaction = null; 
		try {
			Session session = Hibernate2Session.currentSession();
			transaction = session.beginTransaction();
			
			BillingLoader billingLoader = new BillingLoader();
			List projectBillList = billingLoader.loadBilling(session);
			//request.setAttribute("ProjectBillList", projectBillList);
			
			CAFLoader cafLoader = new CAFLoader();
			cafLoader.loadCAF(session);
			
		} catch (Exception e) {
			try {
				if (transaction != null) {
					transaction.rollback();
				}
			} catch (HibernateException e1) {
				// TODO Auto-generated catch block
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (transaction != null) {
					transaction.commit();
				}
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
		
		return mapping.findForward("success");
	}
}
