/*
 * Created on 2005-4-6
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.bill;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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
import com.aof.component.prm.Bill.ProjectBill;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bill.FindEMSForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindEMSAction extends BaseAction {
	
	private Logger log = Logger.getLogger(FindEMSAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		try {
			long timeStart = System.currentTimeMillis();      //for performance test
			//String action = request.getParameter("action");
			//String offSetStr = request.getParameter("offSet");
			//String recordPerPageStr = request.getParameter("recordPerPage");
			FindEMSForm feForm = (FindEMSForm)form;
			Session session = Hibernate2Session.currentSession();
			PartyHelper ph = new PartyHelper();
			
			if (feForm.getFormAction() != null) {
				//int offSet = 0;
				//int recordPerPage = 20;
				
				//if (offSetStr != null && offSetStr.trim().length() != 0) {
					//offSet = Integer.parseInt(offSetStr);
				//}
				//if (recordPerPageStr != null && recordPerPageStr.trim().length() != 0) {
					//recordPerPage = Integer.parseInt(recordPerPageStr);
				//}
				
				if (feForm.getQryDepartment() == null) {
					UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
					if (userLogin != null) {
						feForm.setQryDepartment(userLogin.getParty().getPartyId());
					}
				}
				/*
				if (feForm.getQryEMSDateStart() == null || feForm.getQryEMSDateEnd() == null) {
					SimpleDateFormat dateFormate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(new Date());
					calendar.set(Calendar.HOUR, 23);
					calendar.set(Calendar.MINUTE, 59);
					calendar.set(Calendar.SECOND, 59);
					feForm.setQryEMSDateEnd(dateFormate.format(calendar.getTime()));
					calendar.add(Calendar.DATE, -30);
					calendar.set(Calendar.HOUR, 0);
					calendar.set(Calendar.MINUTE, 0);
					calendar.set(Calendar.SECOND, 0);
					feForm.setQryEMSDateStart(dateFormate.format(calendar.getTime()));
				}
				*/
				
				if (feForm.getQryEMSType() == null 
						|| feForm.getQryEMSType().trim().length() == 0) {
					feForm.setQryEMSType(Constants.EMS_TYPE_EMS_DELIVER);
				}
				
				SQLExecutor sqlExec = new SQLExecutor(
						Persistencer.getSQLExecutorConnection(
								EntityUtil.getConnectionByName("jdbc/aofdb")));
				
				StringBuffer statement = new StringBuffer("");
				statement.append(" select pe.ems_id, ");
				statement.append("        pe.ems_type, ");
				statement.append("        pe.ems_no, ");
				statement.append("        p.description, ");
				statement.append("        pe.ems_date, ");
				statement.append("        pe.ems_create_date ");
				statement.append("   from proj_ems as pe ");
				statement.append("  inner join party as p on pe.ems_department = p.party_id ");
				
				String PartyListStr = "''";
				List partyList_dep=ph.getAllSubPartysByPartyId(session, feForm.getQryDepartment());
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'" + feForm.getQryDepartment() + "'";
				while (itdep.hasNext()) {
					Party p =(Party)itdep.next();
					PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
				}
				statement.append("  where p.party_id in (" + PartyListStr + ") ");
				
				if (feForm.getQryEMSNo() != null && feForm.getQryEMSNo().trim().length() != 0) {
					statement.append("    and pe.ems_no like ? ");
					sqlExec.addParam("%" + feForm.getQryEMSNo() + "%");
				}
				
				if (feForm.getQryEMSType() != null && feForm.getQryEMSType().trim().length() != 0) {
					statement.append("    and pe.ems_type = ? ");
					sqlExec.addParam(feForm.getQryEMSType());
				}
				statement.append("  order by pe.ems_no ");
				
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
			
			if (feForm.getFormAction() != null && feForm.getFormAction().equals("dialogView")) {
				return mapping.findForward("dialogView");
			}
			
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
