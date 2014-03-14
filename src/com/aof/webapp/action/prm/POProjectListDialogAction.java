/*
 * Created on 2006-2-16
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import org.apache.struts.validator.DynaValidatorForm;

import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.PageBean;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class POProjectListDialogAction extends BaseAction {
	private static final int MAXPAGE = 10;

	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(PRMProjectListAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		HttpSession session = request.getSession();
		List projectSelectArr = new ArrayList();
		List result = new ArrayList();
		List pageNumberList = new ArrayList();
		PageBean pageBean = new PageBean();

		String nowTimestampString = UtilDateTime.nowTimestamp().toString();

		String pageNumber = request.getParameter("pageNumber");
		if(pageNumber == null ) pageNumber = "";
		if (!pageNumber.equals("")) {
			pageBean =
				(PageBean) session.getAttribute("ProjectPageBean");
			pageBean.setCurrentPage(new Integer(pageNumber).intValue());
			pageNumberList = getPageNumberList(pageBean);
		} else {
			//			init display
			try {
				net.sf.hibernate.Session hs =
					Hibernate2Session.currentSession();
				Transaction tx = null;
				String lStrOpt=request.getParameter("rad");
				String srchproj=request.getParameter("srchproj");

				if(lStrOpt == null ) lStrOpt = "2";
				if(srchproj == null ) srchproj = "";
				String QryStr = "";
				if (!srchproj.equals("")) {
					if (lStrOpt.equals("2")) {
						QryStr = QryStr + " and (p.projId like '%" + srchproj +"%' or p.projName like '%" + srchproj +"%')";
					} else {
						QryStr = QryStr + " and (p.projId = '" + srchproj +"' or p.projName = '" + srchproj +"')";
					}
				}
				
				result = initSelect(QryStr);
				pageBean.setItemList(result);
				int recCount = result.size();
				pageBean.setPage(MAXPAGE, recCount);
				pageNumberList = getPageNumberList(pageBean);

			} catch (Exception e) {
				e.printStackTrace();
				log.error(e.getMessage());
				return (mapping.findForward("success"));
			} finally {
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
		}

		session.setAttribute("ProjectPageBean", pageBean);
		request.setAttribute("PageNumberList", pageNumberList);

		return (mapping.findForward("success"));
	}

	private List initSelect(String AddCondition) {
		List result =  null;
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			String QryStr = "from ProjectMaster as p where p.projectCategory.Name='PO' and p.projStatus = 'WIP'";
			if (!AddCondition.trim().equals("")) 
				QryStr = QryStr + AddCondition;
			Query q = hs.createQuery(QryStr);
			result = q.list();
			
		} catch (Exception e) {
			e.printStackTrace();
			//return (mapping.findForward("success"));
		} 
		return result;
	}
}
