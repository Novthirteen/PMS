
package com.aof.webapp.action.crm.supplier;

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
 * @author gus
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class VendorDialogAction extends BaseAction{
	private static final int MAXPAGE = 10;
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//Extract attributes we will need
		Logger log = Logger.getLogger(VendorDialogAction.class.getName());
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
				//String SrcIndustry = request.getParameter("SrcIndustry");
				//String SrcAccount = request.getParameter("SrcAccount");
				//String SrcCustomer = request.getParameter("SrcCustomer");
				String SrcVendor = request.getParameter("SrcVendor");
				//if (SrcIndustry == null) SrcIndustry ="";
				//if (SrcAccount == null) SrcAccount ="";
				//if (SrcCustomer == null) SrcCustomer ="";
				if (SrcVendor == null) SrcVendor ="";
				String QryStr ="select p from VendorProfile as p ";
				QryStr = QryStr + " where p.description like '%"+SrcVendor+"%'";
				//QryStr = QryStr + " and ac.Description like '%"+SrcAccount+"%'";
				//QryStr = QryStr + " and ind.Description like '%"+SrcIndustry+"%'";
				//QryStr = QryStr + " order by p.description";
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
