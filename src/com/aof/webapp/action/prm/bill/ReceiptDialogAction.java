package com.aof.webapp.action.prm.bill;

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
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.PageBean;

public class ReceiptDialogAction extends BaseAction{

	private static final int MAXPAGE = 10;
		
	public ActionForward execute(
			ActionMapping mapping, 
			ActionForm form, 
			HttpServletRequest request, 
			HttpServletResponse response) throws Exception {
			
			//Extract attributes we will need
			Logger log = Logger.getLogger(ReceiptDialogAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();
			String action = request.getParameter("FormAction");
			HttpSession session = request.getSession();
			List pageNumberList = new ArrayList();
			PageBean pageBean = new PageBean();
			
			String customerId = (String)request.getSession().getAttribute("BillAddressForReceipt");
			String filter = request.getParameter("custFilter");

			String pageNumber = request.getParameter("pageNumber");
			if(pageNumber == null ) pageNumber = "";
			if (!pageNumber.equals("")) {
				pageBean = (PageBean) session.getAttribute("UserPageBean");
				pageBean.setCurrentPage(new Integer(pageNumber).intValue());
				pageNumberList = getPageNumberList(pageBean);
			} else {
				try {
					net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
					String receiptNo = request.getParameter("ReceiptNo");
					String receiptCustomer = request.getParameter("ReceiptCustomer");
					
					if (receiptNo == null) receiptNo ="";
					if (receiptCustomer == null) receiptCustomer ="";
					
					String QryStr ="select p from ProjectReceiptMaster as p inner join p.customerId as c ";
					QryStr = QryStr + " where p.receiptNo like '%"+receiptNo+"%'";
					QryStr = QryStr + " and ( c.partyId like '%"+receiptCustomer+"%' or c.description like '%"+receiptCustomer+"%')";
					QryStr = QryStr + " and p.receiptStatus <> '" +Constants.RECEIPT_STATUS_COMPLETED + "'";
					
					String QryStr2 = QryStr + " and p.customerId = '"+customerId+"'";
					List result = null;
					if(filter != null && filter.equals("1")){
					    result = hs.createQuery(QryStr).list();
					}else
						result = hs.createQuery(QryStr2).list();
					
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
