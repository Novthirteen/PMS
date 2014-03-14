package com.aof.webapp.action.prm;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
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

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;

public class ProjectChooseDialogueAction extends BaseAction {
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
			String dep_name = request.getParameter("dep_name");
			String bid_id = request.getParameter("bid");
			String bid_name = request.getParameter("bname");
			String bid_no = request.getParameter("bno");

			if (lStrOpt == null)
				lStrOpt = "2";
			if (srchproj == null)
				srchproj = "";
			if(dep_name==null)
				dep_name = "";
			String QryStr = "";
			if (!srchproj.equals("")) {
				if (lStrOpt.equals("2")) {
					// QryStr = QryStr + " and (p.projId like '%" + srchproj
					// + "%' or p.projName like '%" + srchproj + "%')";
					QryStr = QryStr + " and (pm.proj_Id like '%" + srchproj
							+ "%' or pm.proj_name like '%" + srchproj + "%'"
							+ " or cust.description like '%"+ srchproj +"'" +
							  ")";
				} else {
					// QryStr = QryStr + " and (p.projId = '" + srchproj
					// + "' or p.projName = '" + srchproj + "')";
					QryStr = QryStr + " and (pm.proj_Id  = '" + srchproj
							+ "' or pm.proj_name  ='" + srchproj + "')"
							+ " ";
				}
			}
			if(!dep_name.equalsIgnoreCase(""))
			{

				if (lStrOpt.equals("2")) {
					QryStr = QryStr + " and dpt.description like '%"+ dep_name.trim() +"%'";
				} else {
					QryStr = QryStr + " and dpt.description = '"+dep_name.trim()+"'";
				}
							
			}
			if((bid_id!=null)&&(!bid_id.equalsIgnoreCase("")))
				QryStr += " and cp.cp_bid_id="+bid_id;

			UserLogin userLogin = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			request.setAttribute("result", initSelect(userLogin.getUserLoginId(), DateStart, QryStr,bid_id));
			request.setAttribute("bid",bid_id);
			request.setAttribute("bname",bid_name);
			request.setAttribute("bno",bid_no);
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

	private SQLResults initSelect(String UserId, String DateStart, String AddCondition,String bid_id) {
		try {

			SQLExecutor sqlExec = new SQLExecutor(Persistencer
					.getSQLExecutorConnection(EntityUtil
							.getConnectionByName("jdbc/aofdb")));
			String SqlStr;
			SqlStr = "select cust.party_id as cust_id,cust.description as description," +
			"pm.proj_id,pm.proj_name,pm.dep_id,dpt.description as dep_name from  proj_mstr as pm "+
			" inner join party as cust on pm.cust_id = cust.party_Id"+
			" inner join party as dpt on pm.dep_id = dpt.party_Id";
			if((bid_id!=null)&&(!bid_id.equalsIgnoreCase("")))
				SqlStr+=" inner join contract_profile as cp on pm.proj_contract_no = cp.cp_no ";
			
			UserLogin ul = (UserLogin)Hibernate2Session.currentSession().load(UserLogin.class, UserId);
			if(ul.getParty().getPartyId().equals("014")){
				SqlStr+=" where proj_category = 'c' and pm.dep_id in ('014','005','006','007') ";
			}else{
				SqlStr+=" where proj_category = 'c' and pm.dep_id in ('"+ul.getParty().getPartyId()+"') ";
			}
			
			
/*			
			SqlStr = " select cust.party_id as cust_id,cust.description as description,pm.proj_id as projid ,pm.proj_name as projname,pm.dep_id,dpt.description as dep_name from proj_mstr as pm inner join party as cust"
					+ " on pm.cust_id = cust.party_Id inner join party as dpt on pm.dep_id = dpt.party_id inner join contract_profile as cp on pm.proj_contract_no = cp.cp_no "
					+ " where pm.proj_category = 'c' and proj_status <> 'close'";
*/
			if (!AddCondition.trim().equals(""))
				SqlStr = SqlStr + AddCondition;
			SqlStr = SqlStr + 
			" and pm.proj_id not in (select distinct(proj_id) from proj_plan_bom_mstr where proj_id is not null)"+
			" order by cust.description asc";
			System.out.println(SqlStr);
			SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
			return sr;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}
