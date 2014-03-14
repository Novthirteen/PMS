/*
 * Created on 2005-6-26
 * By Angus chen 
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.payment;

import java.sql.SQLException;
import java.util.ArrayList;
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

import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.PageBean;
import com.aof.webapp.action.prm.ProjectListAction;

/**
 * @author gus
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class PayProjectListAction extends BaseAction {


	private static final int MAXPAGE = 10;

	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(ProjectListAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		DynaValidatorForm actionForm = (DynaValidatorForm) form;
		HttpSession session = request.getSession();
		List projectSelectArr = new ArrayList();
		List result = new ArrayList();
		List pageNumberList = new ArrayList();
		PageBean pageBean = new PageBean();

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
				String QryStr = "select p from ProjectMaster as p where p.projStatus = 'WIP' and proj_vendaddr is not NULL";
				if (!srchproj.equals("")) {
					if (lStrOpt.equals("2")) {
						QryStr = QryStr + " and (p.projId like '%" + srchproj +"%' or p.projName like '%" + srchproj +"%')";
					} else {
						QryStr = QryStr + " and (p.projId = '" + srchproj +"' or p.projName = '" + srchproj +"')";
					}
				}
				
				Query q = hs.createQuery(QryStr);
				
				result = q.list();
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

}
