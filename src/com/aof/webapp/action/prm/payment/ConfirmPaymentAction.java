/*
 * Created on 2006-1-19
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.payment;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.prm.payment.PaymentMasterService;
import com.aof.component.prm.payment.ProjPaymentTransaction;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ConfirmPaymentAction extends BaseAction {
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Session hs = Hibernate2Session.currentSession();
		
		String action = request.getParameter("formAction");
		String status = request.getParameter("status");
		
		if(action==null){
			action = "view";
		}
		if(status==null){
			status = "Post";
		}
		
		if(action.equals("view")){
			doView(status, hs, request);
		}
		
		if(action.equals("pay")){
			doPay(hs, request);
			doView(status, hs, request);
		}
		
		if(action.equals("cancel")){
			doCancel(hs, request);
			doView(status, hs, request);
		}
		
		return mapping.findForward("success");
	}
	
	public void doView(String status, Session hs, HttpServletRequest request)
	throws HibernateException{
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		String invCode = request.getParameter("invCode");
		String paymentCode = request.getParameter("paymentCode");
		String project = request.getParameter("project");
		String vendor = request.getParameter("vendor");
		String dateStart = request.getParameter("dateStart");
		String dateEnd = request.getParameter("dateEnd");
		
		String statement = "";
		statement += "	select 	ppt.pay_tran_id tran_id,	";
		statement += "		ppm.pay_code invoice_id,	";
		statement += "		pp.pay_id payment_id,	";
		statement += "		pp.pay_code payment_code,	";
		statement += "		proj_mstr.proj_id proj_id,	";
		statement += "		proj_mstr.proj_name proj_name,		";
		statement += "		proj_mstr.proj_contract_no contract_no,	";
		statement += "		proj_mstr.contracttype con_type,	";
		statement += "		p.description vendor,	";
		statement += "		ppt.pay_amount pay_amount,	";
		statement += "		curr.curr_name curr_name,	";
		statement += "		curr.curr_rate rate,	";
		statement += "		ppt.post_status status,	";
		statement += "		ppt.post_date post_date,	";
		statement += "		ppt.pay_date pay_date,	";
		statement += "		ppt.create_date create_date,	";
		statement += "		ppt.export_date export_date	";

		statement += "	from	Proj_Payment_Transaction ppt	";
		statement += "		inner join Proj_Payment pp on ppt.payment_id=pp.pay_id	";
		statement += "		inner join Proj_Payment_Mstr ppm on ppt.invoice_id=ppm.pay_code	";
		statement += "		inner join Proj_mstr proj_mstr on pp.pay_proj_id=proj_mstr.proj_id	";
		statement += "		inner join party p on pp.pay_addr=p.party_id	";	
		statement += "		inner join Currency curr on ppt.currency=curr.curr_id	";

		statement += "	where	1=1";
		
		if(!status.equals("All")){
			statement += "	and ppt.post_status='"+status+"'	";
		}
		if(invCode!=null && !invCode.trim().equals("")){
			statement += "	and ppm.pay_code like '%"+invCode+"%'	";
		}
		if(paymentCode!=null && !paymentCode.trim().equals("")){
			statement += "	and pp.pay_code like '%"+paymentCode+"%'	";
		}
		if(project!=null && !project.trim().equals("")){
			statement += "	and (proj_mstr.proj_id like '%"+project+"%' or proj_mstr.proj_name like '%"+project+"%')	";
		}
		if(vendor!=null && !vendor.trim().equals("")){
			statement += "	and (p.description like '%"+vendor+"%' or p.party_id like '%"+vendor+"%')	";
		}
		
		if(dateStart!=null && !dateStart.trim().equals("")){
			statement += "	and ppt.pay_date>='"+dateStart+"' 	";
		}
		if(dateEnd!=null && !dateEnd.trim().equals("")){
			statement += "	and ppt.pay_date<='"+dateEnd+"'	";
		}

		System.out.println(statement);
		
		SQLResults sr = sqlExec.runQueryCloseCon(statement);
		request.setAttribute("result", sr);
	}
	
	public void doPay(Session hs, HttpServletRequest request)
	throws HibernateException{
		String[] idArray = request.getParameterValues("chk");
		for(int i=0; i<idArray.length; i++){
			Long id = new Long(Long.parseLong(idArray[i]));
			ProjPaymentTransaction ppt = (ProjPaymentTransaction)hs.load(ProjPaymentTransaction.class, id);
			ppt.setPostStatus(Constants.POST_PAYMENT_TRANSACTION_STATUS_PAID);
			PaymentMasterService service = new PaymentMasterService();
			service.resetInvoicPayStatus(ppt.getInvoice());
			ppt.setPayDate(new Date());
			hs.update(ppt);
		}
		hs.flush();
	}
	
	public void doCancel(Session hs, HttpServletRequest request)
	throws HibernateException{
		Long id = new Long(Long.parseLong(request.getParameter("tranId")));
		ProjPaymentTransaction ppt = (ProjPaymentTransaction)hs.load(ProjPaymentTransaction.class, id);
		ppt.setPostStatus(Constants.POST_PAYMENT_TRANSACTION_STATUS_REJECTED);
		hs.update(ppt);
		hs.flush();
	}
}