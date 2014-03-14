package com.aof.webapp.action.prm.projectmanager;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.prm.Bill.BillTransactionDetail;
import com.aof.component.prm.Bill.MOBillTransactionDetail;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

public class EditMOProjAccpAction extends BaseAction {

	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditProjAccpAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		log.info("action=" + action);
		try {
			String ProjectId = request.getParameter("DataId");
			log.info("***************************** data id =" + ProjectId);
			String ProjName = request.getParameter("projName");
			String ContractNo = request.getParameter("contractNo");
			String ProjectManagerId = request.getParameter("projectManagerId");

			if (ProjectId == null)
				ProjectId = "";
			if (ProjName == null)
				ProjName = "";
			if (ContractNo == null)
				ContractNo = "";
			if (ProjectManagerId == null)
				ProjectManagerId = "";

			String CAFFlag = request.getParameter("CAFFlag");
			String ParentProjectId = request.getParameter("ParentProjectId");
			if (CAFFlag == null)
				CAFFlag = "N";
			if (ParentProjectId == null)
				ParentProjectId = "";

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			tx = hs.beginTransaction();
			if (action == null)
				action = "view";
			ProjectMaster CustProject = null;
			if (action.equals("delete")) {
				Long bt = new Long(
						request.getParameter("tr") != null ? request
								.getParameter("tr") : "0");
				if (bt.intValue() != 0) {
					BillTransactionDetail bl = (BillTransactionDetail) hs.load(
							BillTransactionDetail.class, bt);
					if (bl != null)
						hs.delete(bl);
					Query query = hs
							.createQuery("from MOBillTransactionDetail as tr where tr.Project.projId=? and tr.TransactionIndex=?");
					query.setString(0, bl.getProject().getProjId());
					query.setInteger(1, bl.getTransactionInteger1().intValue());
					List result = query.list();
					if ((result != null) && (result.size() > 0)) {
						for (int i = 0; i < result.size(); i++) {
							MOBillTransactionDetail tr = (MOBillTransactionDetail) result
									.get(i);
							System.out.println(tr.getTransactionId());
							hs.delete(tr);
						}
					}
				}

				tx.commit();

			}
			if (action.equals("delete") || action.equals("view")
					|| action.equals("update")) {
				log.info("project id is " + ProjectId);
				CustProject = (ProjectMaster) hs.load(ProjectMaster.class,
						ProjectId);
				List MaterialList = new LinkedList();
				if (CustProject != null) {
					SQLExecutor sqlExec = new SQLExecutor(Persistencer
							.getSQLExecutorConnection(EntityUtil
									.getConnectionByName("jdbc/aofdb")));
					String SqlStr;
					SqlStr = "select tr.tr_id as trid,tr.tr_int1 as indexid,sum(tr_amount) as amount,Tr_Desc1 as description,tr_mstr_id as mstr_id  from Proj_Tr_Det as tr "
							+ " where tr_int1 is not null and tr.tr_type='Bill' and tr.tr_category='ProjBill'  and tr.tr_proj_Id = '"
							+ ProjectId
							+ "' group by tr.tr_int1,tr.tr_desc1,tr.tr_mstr_id,tr.tr_id";
					SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
					if (sr.getRowCount() != 0) {
						for (int i = 0; i < sr.getRowCount(); i++) {
							Long index = new Long(sr.getLong(i, "indexid"));
							Long id = new Long(sr.getLong(i, "trid"));
							double amount = sr.getDouble(i, "amount");
							String desc = sr.getString(i, "description");
							int msterid = sr.getInt(i, "mstr_id");
							Hashtable record = new Hashtable();
							record.put("id", id);
							record.put("index", index);
							record.put("amount", new Double(amount));
							record.put("desc", desc);
							record.put("mstrid", new Integer(msterid));
							MaterialList.add(record);
						}
					}
					request.setAttribute("MaterialList", MaterialList);
				}
				tx.commit();
				request.setAttribute("CustProject", CustProject);
				return (mapping.findForward("view"));
			}
			if (!errors.empty()) {
				saveErrors(request, errors);
				return (new ActionForward(mapping.getInput()));
			}
			return (mapping.findForward("view"));
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return (mapping.findForward("view"));
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
	}

}