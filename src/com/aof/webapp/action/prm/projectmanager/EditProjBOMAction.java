package com.aof.webapp.action.prm.projectmanager;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
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
import com.aof.component.prm.project.ProjPlanService;
import com.aof.component.prm.project.ProjPlanType;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.StandardBOMMaster;
import com.aof.component.prm.util.EmailService;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

public class EditProjBOMAction extends BaseAction {

	protected ActionErrors errors = new ActionErrors();

	private ProjPlanBom rtnBom = null;

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		Logger log = Logger.getLogger(EditProjBOMAction.class.getName());
		String bid_id = request.getParameter("bidid");
		if (bid_id == null)
			bid_id = request.getParameter("bid_id");
		String proj_id = request.getParameter("proj_id");
		String action = request.getParameter("formaction");
		String version = request.getParameter("version");// look up history
		String simBomId = request.getParameter("simBomId");
		if (action == null || action.equals("")) {
			action = "update";
		}
		String masterid = request.getParameter("masterid");
		String templateid = request.getParameter("template_id");
		String[] chk = request.getParameterValues("chk");
		String email = request.getParameter("email");
		log.info("action=" + action);
		List result = null;
		Query query;
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = hs.beginTransaction();
			BidMaster bm = null;
			ProjectMaster pm = null;
			ProjPlanBomMaster master = null;
			if ((bid_id != null) && (bid_id.length() > 1)) {
				bm = (BidMaster) hs.load(BidMaster.class, new Long(bid_id));
			}
			if ((proj_id != null) && (proj_id.length() > 1)) {
				pm = (ProjectMaster) hs.load(ProjectMaster.class, proj_id);
			}
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
			if (action.equalsIgnoreCase("dialogueView")) {
				request.setAttribute("bomDetail", FindQueryList(hs, master));
				request.setAttribute("master", master);
				return mapping.findForward("dialogueView");
			}
			if (action.equalsIgnoreCase("new")) {
				if (simBomId != null && !(simBomId.equals(""))) {
					StandardBOMMaster tMaster = (StandardBOMMaster) hs.load(
							StandardBOMMaster.class, new Long(templateid));
					request.setAttribute("tMaster", tMaster);
					HashMap m = new HashMap();
					List list = null;
					String strquery = "from ProjPlanBomMaster as master where master.bom_id=? and master.enable='y'";
					query = hs.createQuery(strquery);
					StringTokenizer st = new StringTokenizer(simBomId, ".");
					simBomId = st.nextToken();
					query.setLong(0, Long.parseLong(simBomId));
					List resultlist = query.list();
					if (resultlist != null) {
						master = (ProjPlanBomMaster) resultlist.get(0);
					}
					list = FindQueryList(hs, master);

					for (int i = 0; i < list.size(); i++) {
						ProjPlanBom p = (ProjPlanBom) list.get(i);
						m.put(p.getRanking(), p);
					}
					strquery = "select st from StandardBOM as st where st.master.id =? ";
					strquery += " order by st.ranking asc";
					query = hs.createQuery(strquery);
					query.setLong(0, master.getTemplate().getId());
					result = query.list();
					ProjPlanService service = new ProjPlanService(result, m,
							null, 0);
					request.setAttribute("tree", service.BuildXMLTree(0)); // new
					// bom

					hs.flush();
					tx.commit();
//					request.setAttribute("tMaster", tMaster);
					request.setAttribute("pm", pm);
					request.setAttribute("bm", bm);

				} else {
					StandardBOMMaster tMaster = (StandardBOMMaster) hs.load(
							StandardBOMMaster.class, new Long(templateid));
					result = new LinkedList();
					String strquery = "select st from StandardBOM as st  where st.master.id =?  ";
					strquery += " order by st.ranking asc";
					query = hs.createQuery(strquery);
					query.setLong(0, tMaster.getId());
					result = query.list();
					ProjPlanService service = new ProjPlanService(result, null,
							null, 0);
					request.setAttribute("tree", service.BuildXMLTree(0)); // new
					// bom
					hs.flush();
					tx.commit();
					request.setAttribute("tMaster", tMaster);
					request.setAttribute("pm", pm);
					request.setAttribute("bm", bm);
				}
			}
			if (action.equalsIgnoreCase("create")) {
				StandardBOMMaster tMaster = (StandardBOMMaster) hs.load(
						StandardBOMMaster.class, new Long(templateid));
				String strquery = "select max(master.bom_id) from ProjPlanBomMaster as master ";
				query = hs.createQuery(strquery);
				// query.setString(0,proj_id);
				result = query.list();
				long maxbom_id = 0;
				if ((result != null) && (result.size() > 0)) {
					if (result.get(0) != null) {
						maxbom_id = ((Long) result.get(0)).longValue();
					}
				}

				master = new ProjPlanBomMaster();
				master.setVersion(1);
				master.setEnable("y");
				master.setBom_id(new Long(maxbom_id + 1));
				master.setTemplate(tMaster);
				if (pm != null) {
					// master.setPm(pm.getProjectManager());
					master.setProject(pm);
				}
				if (bm != null) {
					master.setBid(bm);
				}
				// master.setDepartment(pm.getDepartment());
				hs.save(master);
				hs.flush();

				HashMap map = new HashMap();
				for (int i = 0; i < java.lang.reflect.Array.getLength(chk); i++) {
					String temp1 = chk[i];
					StringTokenizer st = new StringTokenizer(temp1, "-");
					String temp2 = st.nextToken();
					// String temp3 = st.nextToken();
					String temp = request.getParameter("parent" + temp2);
					st = new StringTokenizer(temp, "-");
					String parent = st.nextToken();
					String ranking = st.nextToken();
					String desc = request.getParameter("desc" + temp2);
					ProjPlanBom ppb = new ProjPlanBom();
					// ppb.setProject(pm);
					// ppb.setVersion(1);
					ppb.setStepdesc(desc);
					ProjPlanBom parent_ppb = (ProjPlanBom) map.get(parent);
					ppb.setParent(parent_ppb);
					ppb.setRanking(ranking);
					ppb.setMaster(master);
					hs.save(ppb);
					map.put(temp2, ppb);
				}
				map = null;
				hs.flush();
				tx.commit();

				// email if check box is ticked
				if ((email != null) && (email.equalsIgnoreCase("y")))
					EmailService.notifyUser(master);
				request.setAttribute("actionflag", "create|y");

			}
			if (action.startsWith("deletecurr")) {
				query = hs
						.createQuery("from ProjPlanBom as ppb where ppb.master.id =?");
				query.setLong(0, master.getId());
				List list = query.list();
				if (list != null) {
					for (int i = 0; i < list.size(); i++) {
						ProjPlanBom bom = (ProjPlanBom) list.get(i);
						Iterator it = bom.getTypes().iterator();
						while (it.hasNext()) {
							hs.delete((ProjPlanBOMST) it.next());
						}
						hs.delete(bom);
					}
				}

				long bom_id = master.getBom_id().longValue();
				String enable = master.getEnable();
				hs.delete(master);
				hs.flush();
				if (enable.equalsIgnoreCase("y")) {
					query = hs
							.createQuery("from ProjPlanBomMaster as master where master.bom_id =? order by master.version desc");
					query.setLong(0, bom_id);
					list = query.list();
					if ((list != null)&&(list.size()>0)) {
						ProjPlanBomMaster bomM = (ProjPlanBomMaster) list
								.get(0);
						bomM.setEnable("y");
					} else {
						query = hs
								.createQuery("from ProjPlanType as type where type.bom_id =? ");
						query.setLong(0, bom_id);
						list = query.list();
						if (list != null) {
							for (int i = 0; i < list.size(); i++) {
								ProjPlanType type = (ProjPlanType) list.get(i);
								hs.delete(type);
							}
						}
					}
				}

				hs.flush();
				tx.commit();

				return mapping.findForward("redirect");
			}

			if (action.startsWith("deleteall")) {

				long bom_id = master.getBom_id().longValue();
				query = hs
						.createQuery("from ProjPlanBomMaster as master where master.bom_id =?");
				query.setLong(0, master.getBom_id().longValue());
				List list = query.list();
				if (list != null) {
					for (int i = 0; i < list.size(); i++) {
						ProjPlanBomMaster tempMaster = (ProjPlanBomMaster) list
								.get(i);
						query = hs
								.createQuery("from ProjPlanBom as ppb where ppb.master.id =?");
						query.setLong(0, master.getId());
						List tempList = query.list();
						if (tempList != null) {
							for (int j = 0; j < tempList.size(); j++) {
								ProjPlanBom bom = (ProjPlanBom) tempList.get(j);
								Iterator it = bom.getTypes().iterator();
								while (it.hasNext()) {
									hs.delete(it);
								}
								hs.delete(bom);
							}
						}
						hs.delete(tempMaster);
					}
				}
				query = hs
						.createQuery("from ProjPlanType as type where type.bom_id =? and type.parent is null");
				query.setLong(0, bom_id);
				list = query.list();
				if (list != null) {
					for (int i = 0; i < list.size(); i++) {
						ProjPlanType type = (ProjPlanType) list.get(i);
						Iterator it = type.getChildren().iterator();
						while (it.hasNext()) {
							hs.delete(it);
						}
						hs.delete(type);
					}
				}

				hs.flush();
				tx.commit();

				return mapping.findForward("redirect");
			}
			if (action.startsWith("edit")) {
				if (action.equalsIgnoreCase("editSave")) {
					List ll = this.FindQueryList(hs, master);
					HashMap map = new HashMap();
					for (int i = 0; i < ll.size(); i++) {
						ProjPlanBom bom = (ProjPlanBom) ll.get(i);
						map.put(bom.getRanking(), bom);
					}

					Iterator it = ll.iterator();
					// Iterator itHelper = ll.iterator();
					ProjPlanBom bom = null;
					if (it.hasNext())
						bom = (ProjPlanBom) it.next();

					for (int i = 0;;) {
						if ((chk == null)
								|| (!(i < java.lang.reflect.Array
										.getLength(chk)))) {
							if (bom != null) {
								KickChildren(hs, bom, it, bom.getRanking());
								bom = this.rtnBom;
							} else
								break;
						} else {
							String ranking = chk[i]; // temp1 is the ranking
							if (bom != null) {
								if (ranking.equalsIgnoreCase(bom.getRanking()))// equal
								{
									if (it.hasNext())
										bom = (ProjPlanBom) it.next();
									else
										bom = null;
									i++;
								} else if (ranking.compareTo(bom.getRanking()) < 0)// newbom
								{
									ProjPlanBom newBom = new ProjPlanBom();
									String desc = request.getParameter("desc"
											+ ranking);
									// newBom.setDocument();
									newBom.setMaster(master);
									newBom.setStepdesc(desc);
									newBom.setRanking(ranking);
									ProjPlanBom parent = null;
									if (ranking.substring(0,
											ranking.length() - 3).length() > 0)
										parent = (ProjPlanBom) map.get(ranking
												.substring(0,
														ranking.length() - 3));
									newBom.setParent(parent);
									hs.save(newBom);
									map.put(ranking, newBom);
									i++;
								} else { // delete bom
									KickChildren(hs, bom, it, bom.getRanking());
									bom = this.rtnBom;
								}
							} else {
								ProjPlanBom newBom = new ProjPlanBom();
								String desc = request.getParameter("desc"
										+ ranking);
								// newBom.setDocument();
								newBom.setMaster(master);
								newBom.setStepdesc(desc);
								newBom.setRanking(ranking);
								ProjPlanBom parent = null;
								if (ranking.substring(0, ranking.length() - 3)
										.length() > 0)
									parent = (ProjPlanBom) map
											.get(ranking.substring(0, ranking
													.length() - 3));
								newBom.setParent(parent);
								hs.save(newBom);
								map.put(ranking, newBom);
								i++;
							}
						}
						this.rtnBom = null;
					}

				} else if (action.equalsIgnoreCase("editBaseLine")) {
					// set all other master info to disabled
					String strquery = "from ProjPlanBomMaster as master where master.bom_id=?";
					query = hs.createQuery(strquery);
					query.setLong(0, master.getBom_id().longValue());
					// query.setString(0,proj_id);
					result = query.list();
					if ((result != null) && (result.size() > 0))
						for (int i = 0; i < result.size(); i++) {
							ProjPlanBomMaster p = (ProjPlanBomMaster) result
									.get(i);
							p.setEnable("n");
							hs.update(p);
						}

					// insert new version
					strquery = "select max(master.version) from ProjPlanBomMaster as master where master.bom_id=? ";
					query = hs.createQuery(strquery);
					query.setLong(0, master.getBom_id().longValue());
					result = query.list();
					int maxv = 0;
					if ((result != null) && (result.size() > 0)) {
						maxv = ((Integer) result.get(0)).intValue();
					}

					Long bomid = master.getBom_id();
					StandardBOMMaster tMaster = master.getTemplate();
					master = new ProjPlanBomMaster();
					master.setVersion((maxv + 1));
					master.setEnable("y");
					master.setProject(pm);
					master.setBid(bm);
					master.setBom_id(bomid);
					master.setTemplate(tMaster);
					hs.save(master);
					hs.flush();

					HashMap map = new HashMap();
					for (int i = 0; i < java.lang.reflect.Array.getLength(chk); i++) {
						String ranking = chk[i]; // temp1 is the ranking
						String parent = ranking.substring(0,
								ranking.length() - 3);
						String desc = request.getParameter("desc" + ranking);

						ProjPlanBom ppb = new ProjPlanBom();
						ppb.setStepdesc(desc);
						ProjPlanBom parent_ppb = (ProjPlanBom) map.get(parent);
						ppb.setParent(parent_ppb);
						ppb.setRanking(ranking);
						ppb.setMaster(master);
						hs.save(ppb);
						map.put(ranking, ppb);
					}
					map = null;
				}
				hs.flush();
				tx.commit();
				request.setAttribute("actionflag", "update|y");
			}

			if ((action.equalsIgnoreCase("create"))
					|| (action.startsWith("edit"))
					|| (action.equalsIgnoreCase("update"))) {// reselect

				HashMap m = new HashMap();
				List list = null;
				if (action.equalsIgnoreCase("update")) {
					if ((version != null) && (version.length() > 0)) // find
					// history
					{
						String strquery = "from ProjPlanBomMaster as master where master.bom_id=? and master.version=?";
						query = hs.createQuery(strquery);
						query.setLong(0, master.getBom_id().longValue());
						query.setInteger(1, Integer.parseInt(version));
						List resultlist = query.list();
						if (resultlist != null)
							master = (ProjPlanBomMaster) resultlist.get(0);
					}
				}
				List tempList = new ArrayList();
				tempList = FindQueryList(hs, master);

				String strquery = "select st from StandardBOM as st where st.master.id=?  ";
				strquery += " order by st.ranking asc";
				query = hs.createQuery(strquery);
				query.setLong(0, master.getTemplate().getId());
				list = new ArrayList();
				list = query.list();

				ProjPlanService service = new ProjPlanService(tempList, m,
						list, 1);

				request.setAttribute("tree", service.BuildXMLTree(1));// update
				request.setAttribute("master", master);

				query = hs
						.createQuery("select distinct master.version from ProjPlanBomMaster as master where master.bom_id=?");
				query.setLong(0, master.getBom_id().longValue());
				request.setAttribute("versionList", query.list());
			}

			request.setAttribute("formaction", action);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return mapping.findForward("view");
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

	private void KickChildren(Session hs, ProjPlanBom lastBom, Iterator it,
			String root) {
		if (lastBom != null) {
			try {
				it.remove();
				Iterator itSet = lastBom.getTypes().iterator(); // get rid of
				// last bom and
				// bomst
				while (itSet.hasNext()) {
					ProjPlanBOMST st = (ProjPlanBOMST) itSet.next();
					itSet.remove();
					hs.delete(st);
				}
				if (it.hasNext()) {
					ProjPlanBom currentbom = (ProjPlanBom) it.next(); //
					if (currentbom.getRanking().startsWith(root)) {
						KickChildren(hs, currentbom, it, root); // go
						hs.delete(lastBom);
					} else {
						hs.delete(lastBom);
						this.rtnBom = currentbom;
						return;
					}
				} else {
					hs.delete(lastBom);
					return;
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		} else
			return;
	}

}
