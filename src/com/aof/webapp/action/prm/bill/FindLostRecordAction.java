/*
 * Created on 2005-5-8
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.bill;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bill.FindLostRecordForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindLostRecordAction extends BaseAction {
	
	private Logger log = Logger.getLogger(FindLostRecordAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		try {
			long timeStart = System.currentTimeMillis();
			//String offSetStr = request.getParameter("offSet");
			//String recordPerPageStr = request.getParameter("recordPerPage");
			FindLostRecordForm flrForm = (FindLostRecordForm)form;
			Session session = Hibernate2Session.currentSession();
			PartyHelper ph = new PartyHelper();
			
			if (flrForm.getFormAction() != null) {
				//int offSet = 0;
				//int recordPerPage = 20;
				
				//if (offSetStr != null && offSetStr.trim().length() != 0) {
					//offSet = Integer.parseInt(offSetStr);
				//}
				//if (recordPerPageStr != null && recordPerPageStr.trim().length() != 0) {
					//recordPerPage = Integer.parseInt(recordPerPageStr);
				//}

				String status = request.getParameter("status");
				if (flrForm.getQryDepartment() == null) {
					UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
					if (userLogin != null) {
						flrForm.setQryDepartment(userLogin.getParty().getPartyId());
					}
				}
				
				SQLExecutor sqlExec = new SQLExecutor(
						Persistencer.getSQLExecutorConnection(
								EntityUtil.getConnectionByName("jdbc/aofdb")));
				
				StringBuffer statement = new StringBuffer("");
				//select statement
				statement.append(" select pi.inv_id as inv_id, ");
				statement.append("        pb.bill_id as bill_id, ");
				statement.append("        pb.bill_code as bill_code, ");
				statement.append("        pb.bill_type as bill_type, ");
				statement.append("        pm.proj_id as proj_id, ");
				statement.append("        pm.proj_name as proj_name, ");
				statement.append("        p.party_id as departmentId, ");
				statement.append("        p.description as department, ");
				statement.append("        pi.inv_curr_id as currency, ");
				statement.append("        pi.inv_amount as inv_amount, ");
				statement.append("        pi.inv_createdate as inv_createdate, ");
				statement.append("        pi.inv_status as inv_status ");
				//from setatement
				statement.append("   from proj_invoice as pi "); 
				statement.append("  inner join proj_bill as pb on pi.inv_bill_id = pb.bill_id ");
				statement.append("  inner join proj_mstr as pm on pi.inv_proj_id = pm.proj_id ");
				statement.append("  inner join party as p on pm.dep_id = p.party_id ");
				
				//where statement
				statement.append("  where pi.inv_type = ? ");
				sqlExec.addParam(Constants.INVOICE_TYPE_LOST_RECORD);
				
				if (flrForm.getQryBillCode() != null && flrForm.getQryBillCode().trim().length() != 0) {
					statement.append("  and pb.bill_code like ? ");
					sqlExec.addParam("%" + flrForm.getQryBillCode() + "%");
				}
				
				if (flrForm.getQryProject() != null && flrForm.getQryProject().trim().length() != 0) {
					statement.append("  and (pm.proj_id like ? or pm.proj_name like ?) ");
	
					sqlExec.addParam("%" + flrForm.getQryProject() + "%");
					sqlExec.addParam("%" + flrForm.getQryProject() + "%");
				}
				
				String PartyListStr = "''";
				List partyList_dep=ph.getAllSubPartysByPartyId(session, flrForm.getQryDepartment());
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'" + flrForm.getQryDepartment() + "'";
				while (itdep.hasNext()) {
					Party p =(Party)itdep.next();
					PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
				}
				statement.append("  and p.party_id in (" + PartyListStr + ") ");
				statement.append(" and pi.inv_status = '"+status+"'");
				
				//order by statement
				statement.append("  order by pb.bill_code ");
		
				log.info(statement.toString());
				request.setAttribute("QueryList", sqlExec.runQueryCloseCon(statement.toString()));
			}
			
			List partyList = null;
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			partyList = ph.getAllSubPartysByPartyId(session,ul.getParty().getPartyId());
			if (partyList == null) partyList = new ArrayList();
			partyList.add(0, ul.getParty());
			
			request.setAttribute("PartyList", partyList);
			
			long timeEnd = System.currentTimeMillis();       //for performance test
			log.info("it takes " + (timeEnd - timeStart) + " ms to excute the query...");
			
		} catch (Exception e) {
			log.error(e.getMessage());
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

		return mapping.findForward("success");
	}
}
