//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

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

import com.aof.component.crm.customer.CustomerHelper;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.PageBean;

/** 
 * MyEclipse Struts
 * Creation date: 11-18-2004
 * 
 * XDoclet definition:
 * @struts:action validate="true"
 */
public class CustomerDialogAction extends BaseAction {
	private static final int MAXPAGE = 10;
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//Extract attributes we will need
		Logger log = Logger.getLogger(CustomerDialogAction.class.getName());
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
				if (SrcIndustry == null) SrcIndustry ="";
				if (SrcAccount == null) SrcAccount ="";
				if (SrcCustomer == null) SrcCustomer ="";
				if (SrcInitial == null) SrcInitial ="";
				String QryStr ="select p from CustomerProfile as p inner join p.Account as ac inner join p.Industry as ind";
				QryStr = QryStr + " where p.description like '%"+SrcCustomer+"%'";
				QryStr = QryStr + " and p.description like '"+SrcInitial+"%'";
				QryStr = QryStr + " and ac.Description like '%"+SrcAccount+"%'";
				QryStr = QryStr + " and ind.Description like '%"+SrcIndustry+"%'";
				QryStr = QryStr + " and p.type = 'C'";
				QryStr = QryStr + " order by p.description";
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