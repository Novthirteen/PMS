/*
 * Created on 2006-3-27
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.crm.customer;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.PageBean;

/**
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ProspectDialogAction extends BaseAction {

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//Extract attributes we will need
		try {
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
			String SrcIndustry = request.getParameter("SrcIndustry");
			String SrcAccount = request.getParameter("SrcAccount");
			String SrcCustomer = request.getParameter("SrcCustomer");
			String SrcType = request.getParameter("SrcType");
			if (SrcIndustry == null) SrcIndustry ="";
			if (SrcAccount == null) SrcAccount ="";
			if (SrcType == null) SrcType ="";
			if (SrcCustomer == null) SrcCustomer ="";
			String QryStr ="select p from CustomerProfile as p inner join p.Account as ac inner join p.Industry as ind";
			QryStr = QryStr + " where p.description like '%"+SrcCustomer+"%'";
			QryStr = QryStr + " and p.type like '"+SrcType+"%'";
			QryStr = QryStr + " and ac.Description like '%"+SrcAccount+"%'";
			QryStr = QryStr + " and ind.Description like '%"+SrcIndustry+"%'";
			QryStr = QryStr + " order by p.description";
			List result = hs.createQuery(QryStr).list();
			request.setAttribute("resultList",result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		Hibernate2Session.closeSession();
		return (mapping.findForward("success"));
	}


}
