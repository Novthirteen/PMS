package com.aof.webapp.action.prm.projectmanager;

import java.lang.reflect.Array;
import java.text.SimpleDateFormat;
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

import com.aof.component.prm.bid.BidMaster;
import com.aof.component.prm.project.ProjPlanBOMST;
import com.aof.component.prm.project.ProjPlanBom;
import com.aof.component.prm.project.ProjPlanBomMaster;
import com.aof.component.prm.project.ProjPlanType;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.StandardBOMMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.project.EditContractProjectAction;

public class EditProjBOMScheAction extends BaseAction {

	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger
				.getLogger(EditContractProjectAction.class.getName());
		String action = request.getParameter("formaction");
		String masterid = request.getParameter("masterid");
		String version = request.getParameter("version");
		String[] bom_id = request.getParameterValues("bom_id"); // id for every
		// bom detail
		String[] bom_ranking = request.getParameterValues("bom_ranking");
		String[] bom_stepdesc = request.getParameterValues("bom_stepdesc");
		String[] document = request.getParameterValues("document");

		String[] pre = request.getParameterValues("pre");
		String[] cservicetype = request.getParameterValues("c_servicetypeid");
		log.info("action=" + action);
		try {
			if (action.equalsIgnoreCase("compare")) {
				
			}

			if (action.equalsIgnoreCase("view")) {
				request.setAttribute("masterid", masterid);
				return mapping.findForward("redirect");
			}

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = hs.beginTransaction();
			ProjPlanBomMaster master = null;
			if ((masterid != null) && (masterid.length() > 0)) {
				StringTokenizer st = new StringTokenizer(masterid, ".");
				masterid = st.nextToken();
				master = (ProjPlanBomMaster) hs.load(ProjPlanBomMaster.class,
						new Long(masterid));
			}
			/*
			 * if (!isTokenValid(request)) { if (action.equals("create")) {
			 * System.out.println("token is invalid,change to select"); return
			 * mapping.findForward("redirect"); } } saveToken(request);
			 */

			if (action.equalsIgnoreCase("confirm")) {
				master.setStatus("confirm");
				hs.update(master);
				request.setAttribute("actionflag", "confirm|y");
			}
			long srt = 0;
			long ed;
			if (action.equalsIgnoreCase("edit")) {
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				ProjPlanType[] CarrPPT = new ProjPlanType[Array
						.getLength(cservicetype)];
				srt = System.currentTimeMillis();

				for (int i = 0; i < Array.getLength(cservicetype); i++) {
					ProjPlanType ppt = (ProjPlanType) hs.load(
							ProjPlanType.class, new Long(cservicetype[i]));
					CarrPPT[i] = ppt;
				}

				ed = System.currentTimeMillis();
				System.out.println("load type takes:" + (srt - ed));
				srt = System.currentTimeMillis();

				for (int i = 0; i < Array.getLength(bom_id); i++) {
					ProjPlanBom ppb = (ProjPlanBom) hs.load(ProjPlanBom.class,
							new Long(bom_id[i]));
					String[] Cldar = request.getParameterValues("dt" + i);
					String[] hid_id = request
							.getParameterValues("c_hid_id" + i); // children
					String[] manday = request
							.getParameterValues(bom_ranking[i]);

					ppb.setStart_time(df.parse(Cldar[0]));
					ppb.setEnd_time(df.parse(Cldar[1]));
					ppb.setPredecessor(pre[i]);// set Predecessor

					for (int j = 0; j < Array.getLength(hid_id); j++) {
						if (Integer.parseInt(hid_id[j]) != -1)// update
						{
							ProjPlanBOMST st = (ProjPlanBOMST) hs.load(
									ProjPlanBOMST.class, new Long(hid_id[j]));
							st.setManday(Float.parseFloat(manday[j]));
							hs.update(st);
						} else// create
						{
							if (Float.parseFloat(manday[j]) != 0f) {
								ProjPlanBOMST st = new ProjPlanBOMST();
								st.setBom(ppb);
								st.setType(CarrPPT[j]);
								st.setManday(Float.parseFloat(manday[j]));
								st.setMaster(master);
								hs.save(st);
								ppb.addType(st);
							}
						}
					}

					hs.update(ppb);
					hs.flush();
				}
				request.setAttribute("actionflag", "update|y");
			}

			if (action.equalsIgnoreCase("editBaseLine")) {
				srt = System.currentTimeMillis();
				// set all other master info to disabled
				String strquery = "from ProjPlanBomMaster as master where master.bom_id=?";
				Query query = hs.createQuery(strquery);
				query.setLong(0, master.getBom_id().longValue());
				// query.setString(0,proj_id);
				List result = query.list();
				if ((result != null) && (result.size() > 0))
					for (int i = 0; i < result.size(); i++) {
						ProjPlanBomMaster p = (ProjPlanBomMaster) result.get(i);
						p.setEnable("n");
						hs.update(p);
					}

				// insert new version
				strquery = "select max(master.version) from ProjPlanBomMaster as master where master.bom_id =? ";
				query = hs.createQuery(strquery);
				query.setLong(0, master.getBom_id().longValue());
				// query.setString(0,proj_id);
				result = query.list();
				int maxv = 0;
				if ((result != null) && (result.size() > 0)) {
					maxv = ((Integer) result.get(0)).intValue();
				}
				Long bomid = master.getBom_id();
				StandardBOMMaster tMaster = master.getTemplate();
				ProjectMaster project = master.getProject();
				BidMaster bid = master.getBid();
				master = new ProjPlanBomMaster();
				master.setVersion((maxv + 1));
				master.setEnable("y");
				master.setProject(project);
				master.setBid(bid);
				master.setBom_id(bomid);
				master.setTemplate(tMaster);
				hs.save(master);
				hs.flush();

				HashMap map = new HashMap();
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				ProjPlanType[] CarrPPT = new ProjPlanType[Array
						.getLength(cservicetype)];
				if(cservicetype!=null){
				for (int i = 0; i < Array.getLength(cservicetype); i++) {
					ProjPlanType ppt = (ProjPlanType) hs.load(
							ProjPlanType.class, new Long(cservicetype[i]));
					CarrPPT[i] = ppt;
				}
				}
				String[] pareST = request.getParameterValues("p_servicetypeid");
				
				for (int i = 0; i < Array.getLength(bom_id); i++) {
					String[] Cldar = request.getParameterValues("dt" + i);

					String[] p_hid_id = request
					.getParameterValues("p_hid_id" + i); // parent
					

					String[] manday = request.getParameterValues(bom_ranking[i]);

					ProjPlanBom ppb = new ProjPlanBom();
					ProjPlanBom parentBom = (ProjPlanBom) map
							.get(bom_ranking[i].substring(0, bom_ranking[i]
									.length() - 3));
					ppb.setDocument(document[i]);
					ppb.setMaster(master);
					ppb.setEnable("Y");
					ppb.setParent(parentBom);
					ppb.setPredecessor(pre[i]);
					ppb.setStart_time(df.parse(Cldar[0]));
					ppb.setEnd_time(df.parse(Cldar[1]));
					ppb.setStepdesc(bom_stepdesc[i]);
					ppb.setRanking(bom_ranking[i]);
					hs.save(ppb);
					map.put(bom_ranking[i], ppb);

					for(int j=0;j<Array.getLength(p_hid_id);j++)
					{
						double value = 0;
							value = Double.parseDouble(p_hid_id[j]);
						
						if(value>0)
						{
							ProjPlanType type = (ProjPlanType)hs.load(ProjPlanType.class,new Long(pareST[j]));
							ProjPlanBOMST bomst = new ProjPlanBOMST();
							bomst.setType(type);
							bomst.setBom(ppb);
							bomst.setManday(value);
							bomst.setMaster(master);
							hs.save(bomst);
							ppb.addType(bomst);
						}
					}
					
					for (int j = 0; j < Array.getLength(cservicetype); j++) {
/*						if (Integer.parseInt(hid_id[j]) != -1) {
							ProjPlanBOMST st = (ProjPlanBOMST) hs.load(
									ProjPlanBOMST.class, new Long(hid_id[j]));
							st.setManday(Integer.parseInt(manday[j]));
							hs.update(st);
						} else {
*/							if (Float.parseFloat(manday[j]) > 0f) {
								ProjPlanBOMST st = new ProjPlanBOMST();
								st.setType(CarrPPT[j]);
								st.setBom(ppb);
								st.setManday(Float.parseFloat(manday[j]));
								st.setMaster(master);
								hs.save(st);
								ppb.addType(st);
							}
//						}
					}
				}
				map = null;
				hs.flush();
				tx.commit();

				request.setAttribute("actionflag", "update|y");
			}

			if (action.equalsIgnoreCase("setNew")) {
				if (version != null) {
					// set all other master info to disabled
					String strquery = "from ProjPlanBomMaster as master where master.bom_id=?";
					Query query = hs.createQuery(strquery);
					query.setLong(0, master.getBom_id().longValue());
					List result = query.list();
					if ((result != null) && (result.size() > 0))
						for (int i = 0; i < result.size(); i++) {
							ProjPlanBomMaster p = (ProjPlanBomMaster) result
									.get(i);
							if (p.getId() == master.getId())
								p.setEnable("y");
							else
								p.setEnable("n");
							hs.update(p);
						}
				}
				request.setAttribute("actionflag", "activate|y");
			}
			if (action.equalsIgnoreCase("viewHistory")) {
				if (version != null) {
					long tempBom = master.getBom_id().longValue();
					// int
					String strquery = "from ProjPlanBomMaster as master where master.bom_id = ? and master.version=?";
					Query query = hs.createQuery(strquery);
					query.setLong(0, tempBom);
					query.setInteger(1, Integer.parseInt(version));
					List result = query.list();
					if ((result != null) && (result.size() > 0))
						master = (ProjPlanBomMaster) result.get(0);
				}
			}

			List list = FindSTList(hs, master.getBom_id().longValue()); // get
			HashMap map = new HashMap();
			int temInt = 0;
			for (int i = 0; i < list.size(); i++) {
				ProjPlanType ppt = (ProjPlanType) list.get(i);
				temInt = ppt.getChildren().size();
				map.put(new Long(ppt.getId()), ppt);
			}
			request.setAttribute("stmap", map);
			request.setAttribute("servicetype", list);
			request.setAttribute("resultList", FindQueryList(hs, master));
			request.setAttribute("VersionList", FindVersionList(hs, master
					.getBom_id().longValue()));

			request.setAttribute("formaction", action);
			request.setAttribute("master", master);
			hs.flush();
			tx.commit();

			ed = System.currentTimeMillis();
			System.out.println("save data takes:" + (srt - ed));
			srt = System.currentTimeMillis();

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
		strquery = "from ProjPlanBom as ppb where  ppb.master.id=? order by ppb.ranking asc";
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

	public List FindSTList(Session hs, long id) {
		List resultlist = null;//
		String strquery = null;
		strquery = " from ProjPlanType as ppt where ppt.bom_id =? and ppt.parent.id is null";
		try {
			Query query = hs.createQuery(strquery);
			query.setLong(0, id);
			resultlist = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (resultlist == null)
			resultlist = new LinkedList();

		return resultlist;
	}

	public List FindVersionList(Session hs, long id) {
		List resultlist = null;//
		String strquery = null;
		strquery = "select master.version from ProjPlanBomMaster as master where master.bom_id = ?";
		try {
			Query query = hs.createQuery(strquery);
			query.setLong(0, id);
			resultlist = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (resultlist == null)
			resultlist = new LinkedList();

		return resultlist;
	}
}
