package com.aof.webapp.action.prm.projectmanager;

import java.util.StringTokenizer;

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
import com.aof.component.prm.project.ProjPlanBOMST;
import com.aof.component.prm.project.ProjPlanBomMaster;
import com.aof.component.prm.project.ProjPlanType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.report.OutstandingAcceptanceRptAction;

public class EditProjBOMTypeULAction extends BaseAction{

	

	protected ActionErrors errors = new ActionErrors();

	private Log log = LogFactory.getLog(OutstandingAcceptanceRptAction.class);

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		String hid_id = (String) request.getParameter("hid_id");
		String action = (String) request.getParameter("formaction");
		String masterid = (String)request.getParameter("masterid");
		if((masterid==null)||(masterid.length()<1))
		{
			masterid = (String)request.getAttribute("masterid");
		}
		String add_desc = (String) request.getParameter("add_desc");
//		String add_rate = (String) request.getParameter("add_rate");
		String add_ul_id = (String)request.getParameter("add_ul_id");
		String add_st_id = (String)request.getParameter("add_st_id");

		log.info("action :" + action);
		try {

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			tx = hs.beginTransaction();
			Query query;
			String SqlStr;
			ProjPlanBomMaster master = null;
			if((masterid != null) && (masterid.length() > 0))
			{
				StringTokenizer st = new StringTokenizer(masterid,".");
				masterid = st.nextToken();
				master = (ProjPlanBomMaster) hs.load(ProjPlanBomMaster.class, new Long(masterid));				
			}
			

			if (action.equalsIgnoreCase("delete")) {//delete a ul to type relationship
				if (hid_id != null) {
					ProjPlanType type = (ProjPlanType) hs.load(
							ProjPlanType.class, new Long(hid_id));
//					type.getMaster().getServiceTypes().remove(type);
					hs.delete(type);// casecade, ProjPlanBOMST should be deleted
					// too.
					hs.flush();
					tx.commit();
				}
				request.setAttribute("actionflag","delete|y");
			}
			if (action.equalsIgnoreCase("add")) {
				//FOR ADD BUTTON
				if ((add_desc != null) && (add_desc.length() > 0)) {
						UserLogin ul = (UserLogin) hs.load(
								UserLogin.class, add_ul_id);
						ProjPlanType ppt = new ProjPlanType();
						ProjPlanType type = (ProjPlanType)hs.load(ProjPlanType.class,new Long(add_st_id));
						ppt.setBom_id(master.getBom_id());
//						ppt.setMaster(master);
						ppt.setCurrency(type.getCurrency());
						ppt.setDescription(add_desc);
						ppt.setParent(type);
						ppt.setSl(type.getSl());
						ppt.setSTRate(type.getSTRate());	
						ppt.setStaff(ul);
						hs.save(ppt);
				}
				hs.flush();
				tx.commit();
				request.setAttribute("actionflag","add|y");
			}

			SqlStr = "from ProjPlanType as ppt where ppt.bom_id= ? and ppt.parent.id is null order by ppt.description";
			query = hs.createQuery(SqlStr);
			query.setLong(0,master.getBom_id().longValue());
			request.setAttribute("resultList", query.list());
			
			SqlStr = "from ProjPlanType as ppt where ppt.bom_id= ? and ppt.parent.id is not null order by ppt.description";
			query = hs.createQuery(SqlStr);
			query.setLong(0,master.getBom_id().longValue());
//			System.out.println(query.list().size());
			request.setAttribute("childList", query.list());

			request.setAttribute("bommaster", master);
			return (ActionForward) mapping.findForward("view");

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
	}





}
