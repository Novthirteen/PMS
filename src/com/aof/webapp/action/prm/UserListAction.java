/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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

import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.PageBean;
/**
 * @author Paige Li 
 * @version 2004-12-19
 */
public class UserListAction extends BaseAction {

	private static final int MAXPAGE = 10;

	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(UserListAction.class.getName());
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
/*		if (!pageNumber.equals("")) {
			pageBean = (PageBean) session.getAttribute("UserPageBean");
			pageBean.setCurrentPage(new Integer(pageNumber).intValue());
			pageNumberList = getPageNumberList(pageBean);
		} else {
*/			//			init display
			try {
				net.sf.hibernate.Session hs =
					Hibernate2Session.currentSession();
				Transaction tx = null;
				
				String PartyId=request.getParameter("partyId");
				String lStrOpt=request.getParameter("rad");
				String srchStaff=request.getParameter("srchStaff");
				String srchDep=request.getParameter("srchDep");

				if(PartyId == null ) PartyId = "";
				if(lStrOpt == null ) lStrOpt = "2";
				if(srchStaff == null ) srchStaff = "";
				if(srchDep == null ) srchDep = "";
				
				String QryStr = "";
				QryStr = "select ul from UserLogin as ul inner join ul.party as p inner join p.partyRoles as pr where ul.enable = 'Y' and pr.roleTypeId = 'ORGANIZATION_UNIT' ";
				if (!srchStaff.equals("")) {
					if (lStrOpt.equals("2")) {
						QryStr = QryStr + " and (ul.userLoginId like '%" + srchStaff +"%' or ul.name like '%" + srchStaff +"%')";
					} else {
						QryStr = QryStr + " and (ul.userLoginId = '" + srchStaff +"' or ul.name = '" + srchStaff +"')";
					}
				}
				if (!srchDep.equals("")) {
					if (lStrOpt.equals("2")) {
						QryStr = QryStr + " and (p.partyId like '%" + srchDep +"%' or p.description like '%" + srchDep +"%')";
					} else {
						QryStr = QryStr + " and (p.partyId = '" + srchDep +"' or p.description = '" + srchDep +"')";
					}
				}
		
				QryStr = QryStr +" order by ul.name asc";
				Query q = hs.createQuery(QryStr);

				result = q.list();
//				pageBean.setItemList(result);
//				int recCount = result.size();
//				pageBean.setPage(MAXPAGE, recCount);
//				pageNumberList = ProjectListAction.getPageNumberList(pageBean);

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
//		}

//		session.setAttribute("UserPageBean", pageBean);
//		request.setAttribute("PageNumberList", pageNumberList);
	    request.setAttribute("resultList",result);
		return (mapping.findForward("success"));
	}
}
