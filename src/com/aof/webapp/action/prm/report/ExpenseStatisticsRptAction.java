/*
 * Created on 2006-1-6
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.report;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.commons.beanutils.RowSetDynaClass;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01558
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ExpenseStatisticsRptAction extends BaseAction {

	private Log log = LogFactory.getLog(ExpenseStatisticsRptAction.class);

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		String action = request.getParameter("formAction");

		try {
			if ("QueryForList".equals(action)) {
				ResultSet sr = findQueryResult(request);
			}
			return (mapping.findForward("success"));
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
	}

	private ResultSet findQueryResult(HttpServletRequest request) throws Exception {
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));

		String dpt = request.getParameter("dpt");
		String begin_date = request.getParameter("begin_date");
		String end_date = request.getParameter("end_date");

		if (begin_date == null || end_date == null) {
			return null;
		}

		if (dpt == null) {
			dpt = "All";
		}

		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String PartyListStr = "''";

		List partyList_dep = ph.getAllSubPartysByPartyId(session, dpt);
		Iterator itdep = partyList_dep.iterator();
		PartyListStr = "'" + dpt + "'";
		while (itdep.hasNext()) {
			Party p = (Party) itdep.next();
			PartyListStr = PartyListStr + ", '" + p.getPartyId() + "'";
		}

		StringBuffer statement = new StringBuffer("");
		statement.append(" select 	ul.NAME user_name,	");
		statement.append(" 		cast(sum(ed.ed_amt_user) as varchar(20)) total,	");
		statement
				.append(" 		cast(sum(case exp_id when 1 then ed.ed_amt_user else 0 end) as varchar(20)) hotel,	");
		statement
				.append(" 		cast(sum(case exp_id when 2 then ed.ed_amt_user else 0 end) as varchar(20)) meal,	");
		statement
				.append(" 		cast(sum(case exp_id when 3 then ed.ed_amt_user else 0 end) as varchar(20)) travel,	");
		statement
				.append(" 		cast(sum(case exp_id when 4 then ed.ed_amt_user else 0 end) as varchar(20)) allowance,	");
		statement
				.append(" 		cast(sum(case exp_id when 5 then ed.ed_amt_user else 0 end) as varchar(20)) telephone,	");
		statement
				.append(" 		cast(sum(case exp_id when 6 then ed.ed_amt_user else 0 end) as varchar(20)) misc,	");
		statement
		.append(" 		cast(sum(case exp_id when 7 then ed.ed_amt_user else 0 end) as varchar(20)) ot,	");
		statement
		.append(" 		cast(sum(case exp_id when 8 then ed.ed_amt_user else 0 end) as varchar(20)) entertainment	");

		statement.append(" from proj_exp_mstr em	");
		statement.append(" 		inner join proj_exp_det ed on em.em_id=ed.em_id	");
		statement
				.append(" 		inner join User_Login ul on em.em_userlogin=ul.user_login_id and ul.enable = 'Y'	");

		statement.append(" where em.em_receipt_date>='" + begin_date + "'	");
		statement.append("		and em.em_receipt_date<='" + end_date + "'	");

		if (!dpt.equals("All")) {
			statement.append("  and ul.PARTY_ID in (" + PartyListStr + ") ");
		}

		statement.append(" group by ul.NAME	");
		statement.append(" order by ul.NAME	");

		log.info(statement.toString());

		ResultSet result = sqlExec.runQueryStreamResults(statement.toString());
		RowSetDynaClass resultSet = new RowSetDynaClass(result, false);
		sqlExec.closeConnection();
		request.setAttribute("QryList", resultSet);

		return result;
	}
}
