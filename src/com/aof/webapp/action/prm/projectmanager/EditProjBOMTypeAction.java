package com.aof.webapp.action.prm.projectmanager;

import java.lang.reflect.Array;
import java.util.Iterator;
import java.util.List;
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

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjPlanBOMST;
import com.aof.component.prm.project.ProjPlanBomMaster;
import com.aof.component.prm.project.ProjPlanType;
import com.aof.component.prm.project.SalaryLevel;
import com.aof.component.prm.util.EmailService;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

public class EditProjBOMTypeAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();

	private Log log = LogFactory.getLog(EditProjBOMTypeAction.class);

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		String hid_id = (String) request.getParameter("hid_id");
		String[] id = request.getParameterValues("id");
		String[] desc = request.getParameterValues("desc");

		String[] sstid = request.getParameterValues("sstid");
		String[] sstdesc = request.getParameterValues("sstdesc");
		String[] sstrate = request.getParameterValues("sstrate");
		String[] sstcurr_id = request.getParameterValues("sstcurr_id");
		String[] sstcheck = request.getParameterValues("sstcheck");// save
		// check
		String[] taxcheck = request.getParameterValues("taxcheck");// std
		// service
		// type tax
		// check
		String[] rate = request.getParameterValues("rate");
		String[] slid = request.getParameterValues("slid");
		String[] hid_status = request.getParameterValues("hid_status");
		String action = (String) request.getParameter("formaction");
		String masterid = (String) request.getParameter("masterid");
		String add_desc = (String) request.getParameter("add_desc");
		String add_rate = (String) request.getParameter("add_rate");
		String add_check = (String) request.getParameter("add_check");
		String hid_sl_id = (String) request.getParameter("hid_sl_id");
		String hid_curr_id = (String) request.getParameter("hid_curr_id");
		String email = (String) request.getParameter("email");
		UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);

		log.info("action :" + action);
		try {
			if (action.equalsIgnoreCase("new")) {
				return mapping.findForward("new");
			}

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			tx = hs.beginTransaction();
			Query query;
			String SqlStr;
			ProjPlanBomMaster master = null;
			if ((masterid != null) && (masterid.length() > 0)) {
				StringTokenizer st = new StringTokenizer(masterid, ".");
				masterid = st.nextToken();
				master = (ProjPlanBomMaster) hs.load(ProjPlanBomMaster.class,
						new Long(masterid));
			}

			if ((action.equalsIgnoreCase("createST"))
					|| (action.equalsIgnoreCase("other")))// used to create
			// the new
			// servicetype from standard
			// st history
			{
				if(master.getBid()!=null)
				SqlStr = "from StandardServiceType as sst where sst.customer.partyId= '"
						+ master.getBid().getProspectCompany().getPartyId()
						+ "' order by sst.description ";
				else
					SqlStr = "from StandardServiceType as sst where sst.customer.partyId= '"
						+ master.getProject().getCustomer().getPartyId()
						+ "' order by sst.description ";
					
				query = hs.createQuery(SqlStr);
				request.setAttribute("servicetype", query.list());
				request.setAttribute("newflag", "y");
			}
			if (action.equalsIgnoreCase("delete")) {
				if (hid_id != null) {
					ProjPlanType type = (ProjPlanType) hs.load(
							ProjPlanType.class, new Long(hid_id));
					SqlStr = "from ProjPlanBOMST as ppt where ppt.type.id= ?";

					query = hs.createQuery(SqlStr);
					query.setLong(0, type.getId());

					List list = query.list();
					if (list != null)
						for (int i = 0; i < list.size(); i++) {
							ProjPlanBOMST st = (ProjPlanBOMST)list.get(i);
							hs.delete(st);
						}
					// for children type can't be deleted,no function offerd
					hs.delete(type);// casecade, ProjPlanBOMST should be deleted
					hs.flush();
					tx.commit();
				}
				request.setAttribute("actionflag", "delete|y");
			}
			if ((action.equalsIgnoreCase("add"))
					|| (action.equalsIgnoreCase("insert"))) {

				// FOR CHECKBOX
				if ((sstid != null) && (sstid.length > 0)&&(sstcheck!=null)) {
					for (int i = 0, j = 0, k = 0; i < Array.getLength(sstid);) {
						if (j < Array.getLength(sstcheck)) {
							if (sstid[i].equalsIgnoreCase(sstcheck[j])) {
								SalaryLevel sl = (SalaryLevel) hs.load(
										SalaryLevel.class, new Long(slid[i]));
								CurrencyType curr = (CurrencyType) hs.load(
										CurrencyType.class, sstcurr_id[i]);
								ProjPlanType ppt = new ProjPlanType();
								ppt.setDescription(sstdesc[i]);
								if((sstrate[i]==null)||(sstrate[i].length()<1))
									sstrate[i] = "0";
								ppt.setSTRate(Double.parseDouble(sstrate[i]));
								ppt.setSl(sl);
								ppt.setCurrency(curr);
								ppt.setBom_id(master.getBom_id());
								if(taxcheck!=null)
								{
								if (taxcheck[k].equalsIgnoreCase(sstcheck[j])) {
									ppt.setTax("y");
									k++;
								}
								}
								hs.save(ppt);
								i++;
								j++;
							} else
								i++;
						} else
							break;
					}
				}

				// FOR ADD BUTTON
				if ((add_desc != null) && (add_desc.length() > 0)) {
					if ((add_rate != null) && (add_rate.length() > 0)) {
						SalaryLevel sl = (SalaryLevel) hs.load(
								SalaryLevel.class, new Long(hid_sl_id));
						CurrencyType curr = (CurrencyType) hs.load(
								CurrencyType.class, hid_curr_id);
						ProjPlanType ppt = new ProjPlanType();
						ppt.setDescription(add_desc);
						ppt.setCurrency(curr);
						ppt.setSTRate(Double.parseDouble(add_rate));
						ppt.setBom_id(master.getBom_id());
						ppt.setSl(sl);
						if (add_check != null)
							ppt.setTax("y");
						hs.save(ppt);
						ppt = null;
					}
				}
				hs.flush();
				tx.commit();
				request.setAttribute("actionflag", "add|y");

				if (action.equalsIgnoreCase("insert")) {
					request.setAttribute("actionflag", "create|y");
				}
			}

			if (action.startsWith("edit")) // no available
			{
				for (int i = 0; i < java.lang.reflect.Array.getLength(desc); i++) {
					if (hid_status[i].equalsIgnoreCase("yes")) {
						ProjPlanType ppt = (ProjPlanType) hs.load(
								ProjPlanType.class, new Long(id[i]));
						ppt.setDescription(desc[i]);
						ppt.setSTRate(Double.parseDouble(rate[i]));
						hs.update(ppt);
					}
				}
				hs.flush();
				tx.commit();

				if ((email != null) && (email.equalsIgnoreCase("y")))
					EmailService.notifyUser(master, "");
				request.setAttribute("actionflag", "create|y");
			}

			SqlStr = "from ProjPlanType as ppt where ppt.bom_id= ? and ppt.parent.id is null order by ppt.description";
			query = hs.createQuery(SqlStr);
			query.setLong(0, master.getBom_id().longValue());
			request.setAttribute("resultList", query.list());

			PartyHelper ph = new PartyHelper();
			List partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
			Iterator itdep = partyList_dep.iterator();
			String PartyListStr = "'"+ul.getParty().getPartyId()+"'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
			
			if(master.getReveConfirm()==null){
			SqlStr = "from SalaryLevel as sl where sl.party.partyId in("+PartyListStr+") order by sl.party.partyId";
			query = hs.createQuery(SqlStr);
			request.setAttribute("level", query.list());

			SqlStr = "from CurrencyType as curr";
			query = hs.createQuery(SqlStr);
			request.setAttribute("currList", query.list());
			}

			request.setAttribute("bommaster", master);

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
		return (ActionForward) mapping.findForward("view");
	}

}
