/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.action.prm.payment;


import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.BillInstructionService;
import com.aof.component.prm.payment.PaymentInstructionService;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;


public class FindPaymentPendingListAction extends BaseAction{
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());		
		// Extract attributes we will need
		Logger log = Logger.getLogger(FindPaymentPendingListAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();		
		try{
			String textcode = request.getParameter("textcode");
			String textcust = request.getParameter("textcust");
			String textdep = request.getParameter("textdep");
			String action = request.getParameter("FormAction");
			if (textcode == null) textcode ="";
			if (textcust == null) textcust ="";
			if (textdep == null) textdep ="";
			boolean detailflag = false;
			if (request.getParameter("detailflag") != null) detailflag = true;
			log.info("action is "  +action);
			if (action == null) action = "view";
			if (action.equals("create")) {
				String pid  = request.getParameter("pid");
				String paymentId = null;
				if (pid != null) {
					paymentId = String.valueOf(createPaymentInstruction(pid, request));
				}
					request.setAttribute("action", "view");
					request.setAttribute("payId", paymentId);
					return (mapping.findForward("gotoInstruction"));
				
			}
		//	if (action.equals("QueryForList") || action.equals("create")) {
				SQLResults sr = findQueryResult(request,textcode,textcust,textdep,detailflag);
				request.setAttribute("QryList",sr);
				//if (action.equals("create")) {
				//	SQLResults srr = findQueryResult(request,textcode,textcust,textdep,detailflag);
				//	request.setAttribute("QryList",srr);
				//	return (mapping.findForward("success"));
			//	}
				//log.info("****** customer is "+sr.getString(0,"customer"));
				
		//	}
		}catch(Exception e){
			e.printStackTrace();
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
		return (mapping.findForward("success"));
	}
	
	private Long createPaymentInstruction(String projectId, HttpServletRequest request) throws HibernateException {
		PaymentInstructionService pis = new PaymentInstructionService();
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		Long paymentId = pis.newPaymentInstruction(projectId, ul);
		
		return paymentId;
	}
	
	private SQLResults findQueryResult(HttpServletRequest request, String textcode, String textcust, String textdep, boolean detailflag) throws Exception {

		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String JoinStr = "";
		String PartyListStr = "''";
		if (!textdep.trim().equals("")) {
			List partyList_dep=ph.getAllSubPartysByPartyId(session,textdep);
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'"+textdep+"'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
		}
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		String SqlStr = "";
		if (detailflag) {
			SqlStr = SqlStr + "select pm.proj_id as pid, " +
			                  " sum(detres.CAFDays) as CAFDays, " +
			                  " sum(detres.CAFAmt) as CAFAmt, " +
			                //  " sum(detres.AlwnceAmt) as AlwnceAmt, " +
			                  " sum(detres.AccpAmt) as AccpAmt, " +
			                //  " sum(detres.ExpAmt) as ExpAmt, " +
			                  " sum(detres.CDPAmt) as CDPAmt, " +
			                  " p.description as customer, " +
			                  " pty.description as payto, " +
			                  " pm.proj_name as pname, " +
			                  " pm.contracttype, " +
			                  " b.pay_id as PayId," +
							  " b.pay_Type as PayType, " +
			                  " b.pay_code as payCode, " +
			                  " b.pay_Createdate as payDate " +
			                  " from proj_mstr as pm " +
			                  //" inner join proj_tr_det as t  on pm.proj_id= t.tr_proj_id " +
			                  " inner join party as pty on pm.proj_vendaddr = pty.party_id " +
			                  " inner join party as p on pm.cust_id = p.party_id " +
			                  " left join (select pb.pay_proj_id, " +
			                  " pb.pay_id, " +
			                  " pb.pay_type, " +
			                  " pb.pay_code, " +
			                  " pb.pay_createDate " +
			                  " from proj_payment as pb " +
			                  " inner join (select max(pay_id) as pay_id, " +
			                  " pay_proj_id " +
			                  " from proj_payment " +
			                  " group by pay_proj_id" +
			                  " ) as a on pb.pay_id = a.pay_id " +
			                  " ) as b on pm.proj_id = b.pay_proj_id " + 
			                  " inner join ( ";
			
		}
		
		SqlStr = SqlStr + "select t.tr_proj_id as pid," +
							" (sum(case when t.tr_category = 'CAF' then t.tr_num1 end)/8) as CAFDays," +
							" sum(case when t.tr_category = 'CAF' then t.tr_amount end) as CAFAmt," +
					//		" sum(case when t.tr_category = 'Allowance' then t.tr_amount end) as AlwnceAmt," +
							" sum(case when t.tr_category = 'ProjPayment' then t.tr_amount end) as AccpAmt," +
					//		" sum(case when t.tr_category = 'Expense' then t.tr_amount end) as ExpAmt," +
							" sum(case when t.tr_category = 'Credit-Down-Payment' then t.tr_amount end) as CDPAmt," +
							" p.description as customer, pty.description as payto, pm.proj_name as pname, pm.contracttype, " +
							" b.pay_id as PayId," +
							" b.pay_Type as PayType," +
							" b.pay_code as PayCode,b.pay_Createdate as PayDate," +
							" pm. proj_linknote as proj_linknote ";
		SqlStr = SqlStr + " from proj_mstr  as pm  inner join proj_tr_det as t  on pm.proj_id= t.tr_proj_id";
		SqlStr = SqlStr + " inner join party as pty on pm.proj_vendaddr = pty.party_id";
		SqlStr = SqlStr + " inner join party as p on pm.cust_id = p.party_id";
		SqlStr = SqlStr + " left join (select pp.pay_proj_id, pp.pay_id, pp.pay_type, pp.pay_code, pp.pay_createDate from proj_payment as pp  " +
				"inner join (select max(pay_id) as pay_id, pay_proj_id from proj_payment group by pay_proj_id) as a on pp.pay_id = a.pay_id) as b on pm.proj_id = b.pay_proj_id ";
	//	SqlStr = SqlStr + " where t.tr_type='Payment' and t.tr_mstr_id is null ";
		SqlStr = SqlStr + " where pm.proj_category='P' and t.tr_type='Payment' and t.tr_mstr_id is null ";
		if (!textdep.trim().equals("")) {
			SqlStr = SqlStr + " and pm.dep_id in ("+PartyListStr+")";
		} else {
			SqlStr = SqlStr + " and pm.proj_pm_user ='"+ul.getUserLoginId()+"'";
		}
		
		if (!textcode.trim().equals("")) {
			SqlStr = SqlStr + " and (t.tr_proj_id like '%"+textcode+"%' or pm.proj_name like '%"+textcode+"%')";
		}
		if (!textcust.trim().equals("")) {
			SqlStr = SqlStr + "  and (pty.description like '%"+textcust+"%' or pty.party_id like '%"+textcust+"%')";
		}
		
		SqlStr = SqlStr + " group by  t.tr_proj_id, b.pay_id,  b.pay_Type, b.pay_code, b.pay_Createdate, p.description,pm.proj_name, pm.contracttype, pty.description, proj_linknote ";
		if (!detailflag) {
			SqlStr = SqlStr + " order by t.tr_proj_id ";
		} else {
			
			SqlStr = SqlStr + " ) as detres on pm.proj_id = left(detres.proj_linknote,CHARINDEX(':',detres.proj_linknote)-1) " +
	                          " group by pm.proj_id, " +
                              " p.description, " + 
                              " pty.description, " + 
	                          " pm.proj_name, " + 
	                          " pm.contracttype, " +  
	                          " b.pay_code, " +
	                          " b.pay_id, " +
							  " b.pay_Type," +
	                          " b.pay_Createdate ";
			SqlStr = SqlStr + " order by pm.proj_id ";
		}
		
		System.out.println(SqlStr);
		
		SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
		return sr;
	}
}

