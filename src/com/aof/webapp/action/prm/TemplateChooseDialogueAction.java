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

public class TemplateChooseDialogueAction extends BaseAction{


	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		Logger log = Logger.getLogger(TemplateChooseDialogueAction.class.getName());

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
					QryStr = QryStr + " and (mst.description  like '%" + srchproj
							+ "%')";
				} else {
					QryStr = QryStr + " and (mst.description  = '" + srchproj
							+ "' )";
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

			SqlStr =" select mst_id,mst.description as mst_desc,dep.description as dep_desc from bom_std_mstr as mst " +
					" inner join party as dep on mst.dep_id = dep.party_id ";

			if (!AddCondition.trim().equals(""))
				SqlStr = SqlStr + AddCondition;
			SqlStr = SqlStr + " order by mst.dep_id,mst.description";
			SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
			return sr;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}


}
