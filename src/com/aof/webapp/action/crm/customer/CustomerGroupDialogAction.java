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

public class CustomerGroupDialogAction extends BaseAction{
	private static final int MAXPAGE = 10;
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//Extract attributes we will need
		Logger log = Logger.getLogger(ProspectDialogAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		HttpSession session = request.getSession();
		List pageNumberList = new ArrayList();
		PageBean pageBean = new PageBean();

		String pageNumber = request.getParameter("pageNumber");
		if(pageNumber == null ) pageNumber = "";
		if (!pageNumber.equals("")) {
			pageBean = (PageBean) session.getAttribute("UserPageBean");
			pageBean.setCurrentPage(new Integer(pageNumber).intValue());
			pageNumberList = getPageNumberList(pageBean);
		} else {
			try {
				net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
				String SrcIndustry = request.getParameter("SrcIndustry");
				String SrcAccount = request.getParameter("SrcAccount");
				String SrcCustomer = request.getParameter("SrcCustomer");
				String SrcInitial = request.getParameter("SrcInitial");
				String SrcType = request.getParameter("SrcType");
				if (SrcIndustry == null) SrcIndustry ="";
				if (SrcAccount == null) SrcAccount ="";
				if (SrcType == null) SrcType ="";
				if (SrcCustomer == null) SrcCustomer ="";
				if (SrcInitial == null) SrcInitial ="";
				String QryStr ="select p from CustomerAccount as p ";
				QryStr = QryStr + " where p.Description like '%"+SrcCustomer+"%'";
				QryStr = QryStr + " and p.Description like '"+SrcInitial+"%'";
				QryStr = QryStr + " and p.Type like '"+SrcType+"%'";
				QryStr = QryStr + " order by p.Description";
				List result = hs.createQuery(QryStr).list();
				pageBean.setItemList(result);
				int recCount = result.size();
				pageBean.setPage(MAXPAGE, recCount);
				pageNumberList = getPageNumberList(pageBean);
			} catch (Exception e) {
				e.printStackTrace();
			}
			Hibernate2Session.closeSession();
		}
		session.setAttribute("UserPageBean", pageBean);
		request.setAttribute("PageNumberList", pageNumberList);
		return (mapping.findForward("success"));
	}



}
