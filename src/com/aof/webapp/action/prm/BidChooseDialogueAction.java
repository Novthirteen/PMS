package com.aof.webapp.action.prm;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import org.apache.struts.validator.DynaValidatorForm;

import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;

public class BidChooseDialogueAction extends BaseAction {

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(PRMProjectListAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		DynaValidatorForm actionForm = (DynaValidatorForm) form;
		HttpSession session = request.getSession();
		List projectSelectArr = new ArrayList();
		List result = new ArrayList();

		String UserId = request.getParameter("UserId");
		String DataPeriod = request.getParameter("DataPeriod");
		String nowTimestampString = UtilDateTime.nowTimestamp().toString();
		String DateStart = "";
		if (UserId == null)
			UserId = "";
		if (DataPeriod == null) {
			DateStart = nowTimestampString;
		} else {
			DateStart = DataPeriod + " 00:00:00.000";
		}
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			String lStrOpt = request.getParameter("rad");
			String srchproj = request.getParameter("srchproj");

			if (lStrOpt == null)
				lStrOpt = "2";
			if (srchproj == null)
				srchproj = "";
			String QryStr = "";
			if (!srchproj.equals("")) {
				if (lStrOpt.equals("2")) {
					// QryStr = QryStr + " and (p.projId like '%" + srchproj
					// + "%' or p.projName like '%" + srchproj + "%')";
					QryStr = QryStr + " and (master.bid_no like '%" + srchproj
							+ "%' or master.bid_description like '%" + srchproj + "%'"
							+ " or cust.description like '%" + srchproj + "%')";
				} else {
					// QryStr = QryStr + " and (p.projId = '" + srchproj
					// + "' or p.projName = '" + srchproj + "')";
					QryStr = QryStr + " and (master.bid_no  = '" + srchproj
							+ "' or master.bid_description  ='" + srchproj
							+ "' or cust.description = '" + srchproj + "')";
				}
			}
			UserLogin userLogin = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			request.setAttribute("result", initSelect(QryStr, userLogin.getUserLoginId()));
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

	private SQLResults initSelect(String AddCondition, String userId) {
		try {

			SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
					.getConnectionByName("jdbc/aofdb")));
			String SqlStr;
			SqlStr = " select master.bid_id as id,master.bid_no as bid,master.bid_description as description,cust.party_id as cust_id,cust.description as cust_desc,"
					+ " dep.party_id as dep_id,dep.description as dep_desc from bid_mstr as master "
					+ " inner join party as cust on master.bid_prospect_company_id = cust.party_id "
					+ " inner join party as dep on master.bid_dep_id = dep.party_id "
					+ " where master.bid_id not in(select m.bid_id from proj_plan_bom_mstr as m where m.bid_id is not null )"
					+ " and master.bid_no is not null ";
			
			if (!AddCondition.trim().equals(""))
				SqlStr = SqlStr + AddCondition;
			
			UserLogin ul = (UserLogin)Hibernate2Session.currentSession().load(UserLogin.class, userId);
			if(ul.getParty().getPartyId().equals("014")){
				SqlStr+=" and master.bid_dep_id in ('014','005','006','007') ";
			}else{
				SqlStr+=" and master.bid_dep_id in ('"+ul.getParty().getPartyId()+"') ";
			}
			
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
