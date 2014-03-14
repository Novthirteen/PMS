/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.expense;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

import com.aof.component.prm.expense.ExpenseMaster;
import com.aof.component.prm.util.EmailService;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

/**
 * @author xxp
 * @version 2003-7-2
 * 
 */
public class ApproveExpenseAction extends BaseAction {

	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(ApproveExpenseAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");

		String FormStatus = request.getParameter("FormStatus");
		String action = request.getParameter("FormAction");

		if (FormStatus == null)
			FormStatus = "";
		if (action == null)
			action = "view";

		try {
			String DataId = request.getParameter("DataId");

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			Query q = null;

			if (action.equals("update")) {

				if ((DataId == null) || (DataId.length() < 1))
					actionDebug.addGlobalError(errors, "error.context.required");

				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				try {
					tx = hs.beginTransaction();
					ExpenseMaster findmaster = (ExpenseMaster) hs.load(ExpenseMaster.class,
							new Long(DataId));

					if (FormStatus.equals("Approved") && (findmaster.getApprovalDate() == null)) {
						// if (FormStatus.equals("Approved")) {
						findmaster.setStatus(FormStatus);
						Date approveDate = UtilDateTime.toDate2((Date_formater.format(UtilDateTime
								.nowDate()) + " 00:00:00.000"));
						findmaster.setApprovalDate(approveDate);
						hs.update(findmaster);
					}
					if (FormStatus.equals("Rejected") && (findmaster.getReceiptDate() == null)
							&& (!findmaster.getStatus().equals("Posted To F&A"))) {
						findmaster.setStatus(FormStatus);
						findmaster.setApprovalDate(null);
						hs.update(findmaster);
					}
					tx.commit();
					hs.flush();

					// sendmail to expense user
					if (findmaster.getStatus().equals("Approved")
							|| findmaster.getStatus().equals("Rejected"))
						EmailService.notifyUser(findmaster);

				} catch (Exception e) {
					e.printStackTrace();
					log.error(e.getMessage());
				}
			}
			if (action.equals("view") || action.equals("update")) {
				ExpenseMaster findmaster = null;

				if (!((DataId == null) || (DataId.length() < 1)))
					findmaster = (ExpenseMaster) hs.load(ExpenseMaster.class, new Long(DataId));

				List detailList = null;
				ArrayList DateList = new ArrayList();
				if (findmaster != null) {
					q = hs
							.createQuery("select ed from ExpenseDetail as ed inner join ed.ExpMaster as em inner join ed.ExpType as et where em.Id =:DataId order by ed.ExpenseDate, et.expSeq ASC");
					q.setParameter("DataId", DataId);
					detailList = q.list();
					Date dayStart = findmaster.getExpenseDate();

					for (int i = 0; i < 14; i++) {
						DateList.add(UtilDateTime.getDiffDay(dayStart, i));
					}

					if (findmaster.getStatus().equals("Claimed")) {
						request.setAttribute("FreezeFlag", "Y");
					} else {
						request.setAttribute("FreezeFlag", "N");
					}

					request.setAttribute("findmaster", findmaster);
					request.setAttribute("detailList", detailList);
					request.setAttribute("DateList", DateList);

					q = hs
							.createQuery("select ec from ExpenseComments as ec inner join ec.ExpMaster as em where em.Id =:DataId order by ec.ExpenseDate");
					q.setParameter("DataId", DataId);
					detailList = q.list();
					request.setAttribute("CommentsList", detailList);

					q = hs
							.createQuery("select ea from ExpenseAmount as ea inner join ea.ExpMaster as em inner join ea.ExpType as et where em.Id =:DataId order by et.expSeq ASC");
					q.setParameter("DataId", DataId);
					detailList = q.list();
					request.setAttribute("AmountList", detailList);

					FetchActualCost(request, DataId);
				}
				return (mapping.findForward("view"));
			}

			if (!errors.isEmpty()) {
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

	private void FetchActualCost(HttpServletRequest request, String ProjId) {
		List ActualList = null;
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));
		String SqlStr = "Select isnull(sum(Res.TotalAmt),0) as TotalAmt from (";
		SqlStr = SqlStr + " select sum(ts.ts_hrs_user * ts.ts_user_rate) as TotalAmt from";
		SqlStr = SqlStr
				+ " proj_ts_det as ts inner join proj_ts_mstr as tsm on ts.tsm_id = tsm.tsm_id";
		SqlStr = SqlStr
				+ " inner join user_login as ul on (tsm.tsm_userlogin = ul.user_login_id and ul.note <>'EXT')";
		SqlStr = SqlStr + " where ts.ts_proj_Id = '" + ProjId + "' and ts.ts_status = 'Approved'";
		SqlStr = SqlStr + " Union ";
		SqlStr = SqlStr
				+ " select sum(ea.ea_amt_user * em.em_Curr_Rate) as TotalAmt from Proj_Exp_Amt as ea, proj_exp_mstr as em";
		SqlStr = SqlStr + " where ea.em_id = em.em_id  and em.em_proj_Id = '" + ProjId
				+ "' and isnull(em.em_approval_date,'1990-1-1')<>'1990-1-1'";
		SqlStr = SqlStr + " and em.em_claimtype='CN'";
		SqlStr = SqlStr + " Union ";
		SqlStr = SqlStr
				+ " select sum(pcd.percentage * pcm.totalvalue * pcm.exchangerate)/100 as TotalAmt from proj_cost_det as pcd, proj_cost_mstr as pcm, Proj_Cost_Type as pct";
		SqlStr = SqlStr
				+ " where pcd.costcode = pcm.costcode and pct.typeid=pcm.type and pcd.proj_Id = '"
				+ ProjId + "' and isnull(pcm.approvalDate,'1990-1-1')<>'1990-1-1'";
		SqlStr = SqlStr + " and pcm.claimtype='CN'";
		SqlStr = SqlStr + " ) as Res";
		SQLResults rs = sqlExec.runQueryCloseCon(SqlStr);
		request.setAttribute("ActualCost", new Float(rs.getDouble(0, 0)));
	}
}
