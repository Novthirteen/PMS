package com.aof.webapp.action.prm.projectmanager;

import java.lang.reflect.Array;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.prm.project.ProjPlanBOMST;
import com.aof.component.prm.project.ProjPlanBom;
import com.aof.component.prm.project.ProjPlanBomMaster;
import com.aof.component.prm.project.ProjPlanType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.prm.project.EditContractProjectAction;
import com.aof.webapp.action.prm.report.ReportBaseAction;

public class EditProjBOMCostAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditContractProjectAction.class.getName());
		String action = request.getParameter("formaction");
		String[] servicetype = request.getParameterValues("servicetypeid");
		String masterid = request.getParameter("masterid");

		String[] bom_id = request.getParameterValues("bom_id");
		String[] document = request.getParameterValues("document");
		log.info("action=" + action);
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = hs.beginTransaction();

			ProjPlanBomMaster master = null;
			if ((masterid != null) && (masterid.length() > 0)) {
				StringTokenizer st = new StringTokenizer(masterid, ".");
				masterid = st.nextToken();
				master = (ProjPlanBomMaster) hs.load(ProjPlanBomMaster.class, new Long(masterid));
			}
			/*
			 * if (!isTokenValid(request)) { if (action.equals("create")) {
			 * System.out.println("token is invalid,change to select"); return
			 * mapping.findForward("redirect"); } } saveToken(request);
			 */

			if (action.equalsIgnoreCase("confirm")) {
				master.setReveConfirm("confirm");
				hs.update(master);
				request.setAttribute("actionflag", "confirm|y");
			}

			if (action.equalsIgnoreCase("edit")) {
				// HashMap stMap = new HashMap();
				ProjPlanType[] arrPPT = new ProjPlanType[Array.getLength(servicetype)];
				for (int i = 0; i < Array.getLength(servicetype); i++) {
					ProjPlanType ppt = (ProjPlanType) hs.load(ProjPlanType.class, new Long(
							servicetype[i]));
					arrPPT[i] = ppt;
					// stMap.put(new Long(ppt.getId()),ppt);
				}

				for (int i = 0; i < Array.getLength(bom_id); i++) {
					ProjPlanBom ppb = (ProjPlanBom) hs.load(ProjPlanBom.class, new Long(bom_id[i]));
					String[] hid_id = request.getParameterValues("hid_id" + i);
					String[] manday = request.getParameterValues("st" + i);
					ppb.setDocument(document[i]);
					hs.update(ppb);
					hs.flush();
					for (int j = 0; j < Array.getLength(hid_id); j++) {
						if (Integer.parseInt(hid_id[j]) != -1)// update
						{
							ProjPlanBOMST st = (ProjPlanBOMST) hs.load(ProjPlanBOMST.class,
									new Long(hid_id[j]));
							st.setManday(Integer.parseInt(manday[j]));
							hs.update(st);
						} else// create
						{
							if (Integer.parseInt(manday[j]) != 0) {
								ProjPlanBOMST st = new ProjPlanBOMST();
								st.setBom(ppb);
								st.setType(arrPPT[j]);
								st.setManday(Integer.parseInt(manday[j]));
								hs.save(st);
							}
						}
					}
				}
				request.setAttribute("actionflag", "update|y");
			}

			hs.flush();
			tx.commit();
			List list = FindSTList(hs, master.getBom_id().longValue());
			HashMap map = new HashMap();
			for (int i = 0; i < list.size(); i++) {
				ProjPlanType ppt = (ProjPlanType) list.get(i);
				map.put(new Long(ppt.getId()), ppt);

			}
			request.setAttribute("stmap", map);
			request.setAttribute("servicetype", list);
			request.setAttribute("resultList", FindQueryList(hs, master));

			request.setAttribute("formaction", action);
			request.setAttribute("master", master);
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

	public List FindQueryList(Session hs, ProjPlanBomMaster master) {
		List resultlist = null;//
		String strquery = null;
		strquery = "from ProjPlanBom as ppb where  ppb.master.id=?";
		try {
			Query query = hs.createQuery(strquery);
			query.setLong(0, master.getId());
			resultlist = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (resultlist == null)
			resultlist = new LinkedList();

		return resultlist;
	}

	public List FindSTList(Session hs, long masterId) {
		List resultlist = null;//
		String strquery = null;
		strquery = " from ProjPlanType as ppt where ppt.bom_id =? and ppt.parent.id is null";
		try {
			Query query = hs.createQuery(strquery);
			query.setLong(0, masterId);
			resultlist = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (resultlist == null)
			resultlist = new LinkedList();

		return resultlist;
	}
}
