package com.aof.webapp.action.prm.projectmanager;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.prm.project.ProjPlanBom;
import com.aof.component.prm.project.ProjPlanBomMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

public class EditProjBOMNodeAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		Logger log = Logger.getLogger(EditProjBOMNodeAction.class.getName());
		String action = request.getParameter("formaction");
		log.info("action=" + action);

		String add_desc = request.getParameter("add_desc");
		long masterid = Long.parseLong(request.getParameter("masterid"));
		String parentranking = request.getParameter("parentranking");
		String selfRanking = request.getParameter("ranking");
		String bomid = request.getParameter("bomid");

		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = hs.beginTransaction();
			ProjPlanBomMaster master = (ProjPlanBomMaster) hs.load(
					ProjPlanBomMaster.class, new Long(masterid));
			request.setAttribute("master", master);

			Query query = null;
			ProjPlanBom parent = null;
			List list = null;

			// find the parent
			if ((parentranking != null)
					&& (!parentranking.equalsIgnoreCase("0"))) {
				query = hs
						.createQuery("select bom from ProjPlanBom as bom where bom.master.id = ? and bom.ranking = ?  ");
				query.setLong(0, master.getId());
				query.setString(1, parentranking);
				list = query.list();
				if ((list != null) && (list.size() > 0)) {
					parent = (ProjPlanBom) list.get(0);
					request.setAttribute("parentranking", parent.getRanking());
					request.setAttribute("parentdesc", parent.getStepdesc());
				} else {
					if (parentranking != null) // select a standard bom
					// Node,this is not allowed
					{
						request.setAttribute("error",
								"Can't not add Node at at this Branch! ");
						return mapping.findForward("view");
					}
				}
			}

			if (action.equalsIgnoreCase("add")) {

				String ranking = "";

				if (!parentranking.equalsIgnoreCase("0")) {
					query = hs
							.createQuery("select max(bom.ranking) from ProjPlanBom as bom where bom.parent.ranking = ? ");
					query.setString(0, parentranking);
					list = query.list();
					if ((list != null) && (list.size() > 0)) {
						if (list.get(0) != null)
							ranking = (String) list.get(0);
						else
							ranking = parentranking + "000";
					}

					query = hs
							.createQuery("select max(bom.ranking) from StandardBOM as bom where bom.parent.ranking=? and bom.master.id = ?");
					query.setString(0, parentranking);
					query.setLong(1, master.getTemplate().getId());
					list = query.list();
					if ((list != null) && (list.size() > 0)) {
						if (list.get(0) != null) {
							if (ranking.compareTo((String) list.get(0)) < 0)
								ranking = (String) list.get(0);
						}
					}
				} else {
					query = hs
							.createQuery("select max(bom.ranking) from ProjPlanBom as bom where bom.parent is null ");
					list = query.list();
					if ((list != null) && (list.size() > 0)) {
						if (list.get(0) != null) {
							ranking = (String) list.get(0);
						}
					}
					query = hs
							.createQuery("select max(bom.ranking) from StandardBOM as bom where bom.parent = bom and bom.master.id = ?");
					query.setLong(0, master.getId());
					list = query.list();
					if ((list != null) && (list.size() > 0)) {
						if (list.get(0) != null) {
							if (ranking.compareTo((String) list.get(0)) < 0)
								ranking = (String) list.get(0);
						}
					}
				}
				int temp = Integer.parseInt(ranking.substring(
						ranking.length() - 3, ranking.length()));
				temp += 1;
				if (String.valueOf(temp).length() == 1)
					ranking = ranking.substring(0, ranking.length() - 3) + "00"
							+ temp;
				if (String.valueOf(temp).length() == 2)
					ranking = ranking.substring(0, ranking.length() - 3) + "0"
							+ temp;
				if (String.valueOf(temp).length() == 3)
					ranking = ranking.substring(0, ranking.length() - 3) + temp;

				ProjPlanBom bom = new ProjPlanBom();
				bom.setStepdesc(add_desc);
				bom.setMaster(master);
				bom.setParent(parent);
				bom.setRanking(ranking);
				request.setAttribute("NewBom", bom);
				hs.save(bom);

				request.setAttribute("CLOSE", "TRUE");
			}
			if (action.equalsIgnoreCase("view")) {
				request.setAttribute("parentranking", parentranking);
			}

			if (action.equalsIgnoreCase("editShow")) {
				ProjPlanBom bom = null;
				query = hs
						.createQuery("select bom from ProjPlanBom as bom where bom.ranking =? and bom.master.id = ?");
				query.setString(0,selfRanking);
				query.setLong(1,masterid);
				list = query.list();
				if ((list != null) && (list.size() > 0)) {
					bom = (ProjPlanBom)list.get(0);
					request.setAttribute("selfBom",bom);
				}
				else
				{
					request.setAttribute("error",
					"Can't not add Node at at this Branch! ");
				}
				return mapping.findForward("edit");
			}
			if (action.equalsIgnoreCase("editSave")) {
				ProjPlanBom bom = (ProjPlanBom)hs.load(ProjPlanBom.class,new Long(bomid));
				bom.setStepdesc(add_desc);
				request.setAttribute("CLOSE", "TRUE");
				request.setAttribute("selfBom",bom);
				hs.flush();
				tx.commit();
				return mapping.findForward("edit");
			}
			hs.flush();
			tx.commit();

		} catch (Exception e) {
			e.printStackTrace();
			return mapping.findForward("view");
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return mapping.findForward("view");
	}

}
