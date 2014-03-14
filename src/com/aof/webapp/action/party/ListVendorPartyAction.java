
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
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ListVendorPartyAction extends BaseAction {
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(ListVendorPartyAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();		

		try{
			
			List result = new ArrayList();
			net.sf.hibernate.Session session = Hibernate2Session.currentSession();
			Query q = session.createQuery("select p from VendorProfile as p");
			//q.setMaxResults(20);
			result = q.list();
			
			request.setAttribute("vendorPartys",result);
			
			
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
