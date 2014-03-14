package com.aof.webapp.action.party;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;

public class ListProspectAction extends BaseAction{
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
				// Extract attributes we will need
				Logger log = Logger.getLogger(ListCustPartyAction.class.getName());
				Locale locale = getLocale(request);
				MessageResources messages = getResources();		

				try{
					
//					List result = new ArrayList();
//					net.sf.hibernate.Session session = Hibernate2Session.currentSession();
//					Query q = session.createQuery("select p from CustomerProfile as p where p.type='P' ");
					//q.setMaxResults(20);
//					result = q.list();
					
//					request.setAttribute("custPartys",result);
					
				}catch(Exception e){
					
					log.error(e.getMessage());
				}finally{
					try {
						Hibernate2Session.closeSession();
					} catch (HibernateException e1) {
						log.error(e1.getMessage());
						e1.printStackTrace();
					} catch (SQLException e1) {
						log.error(e1.getMessage());
						e1.printStackTrace();
					}				
				}
				
				return (mapping.findForward("success"));
		}


}
