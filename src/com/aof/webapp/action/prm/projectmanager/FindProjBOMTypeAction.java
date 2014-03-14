package com.aof.webapp.action.prm.projectmanager;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.ProjPlanType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.report.OutstandingAcceptanceRptAction;

public class FindProjBOMTypeAction extends BaseAction {

	protected ActionErrors errors = new ActionErrors();

	private Log log = LogFactory.getLog(OutstandingAcceptanceRptAction.class);

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		String proj_desc = (String) request.getParameter("proj_desc");
		String action = (String) request.getParameter("formaction");
		String proj_id = (String) request.getParameter("proj_id");
		String cust_id = (String) request.getParameter("cust_id");
		String cust_desc = (String) request.getParameter("cust_desc");
		String dpt = (String) request.getParameter("dpt");
		log.info("action :" + action);
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			tx = hs.beginTransaction();
			UserLogin ul = (UserLogin) request.getSession().getAttribute(
					Constants.USERLOGIN_KEY);

			String strQuery = "select distinct ppt.project.projId,ppt.project.projName,ppt.project.ProjectManager.name from ProjPlanType as ppt where ppt.id is not null";
			if ((proj_id != null) && (proj_id.length() > 0)) {
				strQuery += " and ppt.project.projId like '%" + proj_id + "%'";
			}
			if ((proj_desc != null) && (proj_desc.length() > 0)) {
				strQuery += " and ppt.project.projName like '%" + proj_desc
						+ "%'";
			}
			if ((dpt != null) && (dpt.length() > 0)) {
				strQuery += " and ppt.project.department.partyId like '%" + dpt
						+ "%'";
			}

			Query query;
			query = hs.createQuery(strQuery);
			List list = query.list();
			request.setAttribute("resultList", list);
			query = hs
					.createQuery("select distinct pt from Party as p inner join p.relationships as pr inner join pr.partyTo as pt"
							+ " where p.partyId=? and pr.relationshipType=?");
			query.setString(0, ul.getParty().getPartyId());
			query.setString(1, "GROUP_ROLLUP");
			list = query.list();
			list.add(0,ul.getParty());
			request.setAttribute("partyList", list);


		} catch (Exception e) {
			e.printStackTrace();
		}

		return mapping.findForward("view");
	}

}
