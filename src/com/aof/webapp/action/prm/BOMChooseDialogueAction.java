package com.aof.webapp.action.prm;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.webapp.action.BaseAction;

public class BOMChooseDialogueAction extends BaseAction {

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		// Extract attributes we will need
		Logger log = Logger.getLogger(PRMProjectListAction.class.getName());

		try {
			String lStrOpt = request.getParameter("rad");
			String srchproj = request.getParameter("srchproj");

			if (lStrOpt == null) {
				lStrOpt = "2";
			}
			if (srchproj == null) {
				srchproj = "";
			}

			String QryStr = "";
			if (!srchproj.equals("")) {
				if (lStrOpt.equals("2")) {
					QryStr = QryStr + " and (bid.bid_no like '%" + srchproj
							+ "%' or bid.bid_description like '%" + srchproj + "%'"
							+ " or cust.description like '%" + srchproj + "%')";
				} else {
					QryStr = QryStr + " and (bid.bid_no  = '" + srchproj
							+ "' or bid.bid_description  ='" + srchproj
							+ "' or cust.description = '" + srchproj + "')";
				}
			}
			request.setAttribute("result", initSelect(QryStr));

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
		return (mapping.findForward("success"));
	}

	private SQLResults initSelect(String AddCondition) {
		try {

			SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
					.getConnectionByName("jdbc/aofdb")));
			String SqlStr = "";

			SqlStr = "select bom.template_id,bom.mst_id,bom.bom_id as bom_id, cust.description as cust_desc, bid.bid_description as bid_desc, bid.bid_no as bid_no "
					+ "from proj_plan_bom_mstr as bom "
					+ "inner join bid_mstr as bid on bom.bid_id = bid.bid_id "
					+ "inner join party as cust on bid.bid_prospect_company_id = cust.party_id "
					+ "where bom.enable='y'";

			if (!AddCondition.trim().equals(""))
				SqlStr = SqlStr + AddCondition;
			SqlStr = SqlStr + " order by cust.description asc";
			System.out.println(SqlStr);
			SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
			return sr;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}