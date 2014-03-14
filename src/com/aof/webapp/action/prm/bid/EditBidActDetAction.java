/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.bid;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.bid.BMHistory;
import com.aof.component.prm.bid.BidActDetail;
import com.aof.component.prm.bid.BidActivity;
import com.aof.component.prm.bid.BidMaster;
import com.aof.component.prm.bid.SalesActivity;
import com.aof.component.prm.bid.SalesStep;
import com.aof.component.prm.bid.SalesStepGroup;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

/**
 * @author angus
 * 
 */
public class EditBidActDetAction extends BaseAction {

	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		String action = request.getParameter("FormAction");

		if (action == null)
			action = "view";
		BidActivity bidActivity = null;

		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;

			String bidActId = request.getParameter("bidActId");// bidActivity
			String bidId = request.getParameter("bidId");
			BidMaster bm = new BidMaster();
			ProjectMaster project = null;

			if (!((bidId == null) || (bidId.length() < 1))) {
				bm = (BidMaster) hs.load(BidMaster.class, new Long(bidId));
				Query query = hs.createQuery(" from ProjectMaster as pm where pm.ContractNo = ?");
				query.setString(0, bm.getNo());
				List result = query.list();
				if ((result != null) && (result.size() > 0))
					project = (ProjectMaster) result.get(0);
			}

			if (action.equals("addDetail")) {
				String aId = request.getParameter("aAssignee");
				String aDate = request.getParameter("aDate");
				String aHours = request.getParameter("aHours");
				String aDesc = request.getParameter("aDesc");

				BidActDetail bad = null;
				bidActivity = (BidActivity) hs.load(BidActivity.class, new Long(bidActId));
				tx = hs.beginTransaction();

				if (!(aId.trim().equals(""))) {
					com.aof.component.domain.party.UserLogin assignee = (com.aof.component.domain.party.UserLogin) hs
							.load(com.aof.component.domain.party.UserLogin.class, aId);
					bad = new BidActDetail();
					bad.setBidActivity(bidActivity);
					bad.setAssignee(assignee);
					bad.setDescription(aDesc);
					bad.setHours(new Float(aHours));
					bad.setActionDate(UtilDateTime.toDate2(aDate + " 00:00:00.000"));
					hs.save(bad);
					bidActivity.addBidActDetail(bad);
				}
				tx.commit();
				hs.flush();
			}

			if (action.equals("deleteDetail")) {
				String badIdStr = request.getParameter("badId");// detail
				if (((badIdStr == null) || (badIdStr.length() < 1)))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				tx = hs.beginTransaction();
				BidActDetail detail = (BidActDetail) hs.load(BidActDetail.class, new Long(badIdStr));
				BidActivity activity = detail.getBidActivity();
				activity.removeBidActDetails(detail);
				hs.delete(detail);
				hs.flush();
				tx.commit();
			}

			if (action.equals("update")) {
				if (((bidActId == null) || (bidActId.length() < 1)))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				bidActivity = (BidActivity) hs.load(BidActivity.class, new Long(bidActId));

				String cc = request.getParameter("cc");
				String assigneeId[] = request.getParameterValues("Assignee");
				String actionDate[] = new String[bidActivity.getBidActDetails().size()];

				for (int cs = 0; cs < (Integer.parseInt(cc)); cs++) {
					actionDate[cs] = request.getParameter("actionDate" + cs);
				}
				String hours[] = request.getParameterValues("hours");
				String actionDesc[] = request.getParameterValues("actionDesc");
				String detailId[] = request.getParameterValues("detailId");

				int RowSize = java.lang.reflect.Array.getLength(assigneeId);
				BidActDetail bad = null;

				tx = hs.beginTransaction();
				for (int i = 0; i < RowSize; i++) {
					Long dId = null;
					if (!(detailId[i] == null || detailId[i].length() < 1))
						dId = new Long(detailId[i]);
					if (!(assigneeId[i].trim().equals(""))) {
						com.aof.component.domain.party.UserLogin assignee = (com.aof.component.domain.party.UserLogin) hs
								.load(com.aof.component.domain.party.UserLogin.class, assigneeId[i]);
						bad = (BidActDetail) hs.load(BidActDetail.class, dId);
						bad.setBidActivity(bidActivity);
						bad.setAssignee(assignee);
						bad.setDescription(actionDesc[i]);
						bad.setHours(new Float(hours[i]));
						bad.setActionDate(UtilDateTime.toDate2(actionDate[i] + " 00:00:00.000"));
						hs.update(bad);
					} else {
						bad = (BidActDetail) hs.load(BidActDetail.class, dId);
						bad.setBidActivity(bidActivity);
						bad.setDescription(actionDesc[i]);
						bad.setHours(new Float(hours[i]));
						bad.setActionDate(UtilDateTime.toDate2(actionDate[i] + " 00:00:00.000"));
						hs.update(bad);
					}
				}
				tx.commit();
				hs.flush();
			}
			if ("view".equals(action) || "addDetail".equals(action) || "deleteDetail".equals(action)
					|| "update".equals(action)) {
				if ((bidActId != null) && (bidActId.length() > 0)) {
					bidActivity = (BidActivity) hs.load(BidActivity.class, new Long(bidActId));
				}
				Set bidActDetailList = null;
				if (bidActivity != null) {
					bidActDetailList = bidActivity.getBidActDetails();
				}
				request.setAttribute("BidActDetailList", bidActDetailList);

				Set bidActivitySet = bm.getBidActivities();
				Iterator bit = bidActivitySet.iterator();
				ArrayList bbId = new ArrayList();
				while (bit.hasNext()) {
					BidActivity bty = (BidActivity) bit.next();
					if (bty.getBidActDetails().size() > 0) {
						bbId.add(bty.getActivity().getId());
					}
				}

				SalesStepGroup stepGroup = bm.getStepGroup();
				Set steps = stepGroup.getSteps();

				int oldPer = 0;
				if (bm.getCurrentStep() != null) {
					oldPer = bm.getCurrentStep().getPercentage().intValue();
				}
				String oldStatus = bm.getStatus();
				String newStatus = bm.getStatus();
				bm.setCurrentStep(null);
				if (steps != null) {
					ArrayList stepList = ComparatorStepArray(steps);
					Iterator it = stepList.iterator();
					while (it.hasNext()) {// step
						tx = hs.beginTransaction();
						SalesStep stepOne = (SalesStep) it.next();
						Iterator ait = stepOne.getActivities().iterator();
						while (ait.hasNext()) {// activity list in each step
							String flag1 = "";
							SalesActivity sa = (SalesActivity) ait.next();
							for (int ii = 0; ii < bbId.size(); ii++) {
								if (sa.getId() == bbId.get(ii)) {
									flag1 = "pass";
									continue;
								}
							}
							if ((flag1.equals("")) || (bbId.size() == 0)) {

								if (!oldStatus.equals(newStatus)) {
									BMHistory bmh = new BMHistory();
									UserLogin ul = (UserLogin) request.getSession().getAttribute(
											Constants.USERLOGIN_KEY);

									bmh.setMasterid(bm.getId());

									if (bm.getEstimateStartDate() != null) {
										bmh.setCon_st_date(bm.getEstimateStartDate());
									}
									if (bm.getEstimateEndDate() != null) {
										bmh.setCon_ed_date(bm.getEstimateEndDate());
									}
									if (bm.getExpectedEndDate() != null) {
										bmh.setCon_sign_date(bm.getExpectedEndDate());
									}

									bmh.setStatus(newStatus);
									bmh.setUser_id(ul);
									bmh.setModify_date(Calendar.getInstance().getTime());
									if (newStatus.equals("Won")) {
										bmh.setReason("Bid Won");
									} else {
										bmh.setReason("");
									}

									hs.save(bmh);
									hs.update(bm);
								}

								hs.flush();
								tx.commit();
								request.setAttribute("bidMaster", bm);
								return (mapping.findForward("view"));
							}
						}

						bm.setCurrentStep(stepOne);
						int nowPer = stepOne.getPercentage().intValue();

						if (nowPer == 100) {
							bm.setStatus("Won");
							project.setProjStatus("Close");
						} else {
							if (oldPer == 100) {
								bm.setStatus("Active");
								project.setProjStatus("WIP");
							}
						}
						hs.update(project);
						hs.update(bm);
						newStatus = bm.getStatus();
					}
				}

				if (!oldStatus.equals(newStatus)) {
					BMHistory bmh = new BMHistory();
					UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);

					bmh.setMasterid(bm.getId());

					if (bm.getEstimateStartDate() != null) {
						bmh.setCon_st_date(bm.getEstimateStartDate());
					}
					if (bm.getEstimateEndDate() != null) {
						bmh.setCon_ed_date(bm.getEstimateEndDate());
					}
					if (bm.getExpectedEndDate() != null) {
						bmh.setCon_sign_date(bm.getExpectedEndDate());
					}

					bmh.setStatus(newStatus);
					bmh.setUser_id(ul);
					bmh.setModify_date(Calendar.getInstance().getTime());
					if (newStatus.equals("Won")) {
						bmh.setReason("Bid Won");
					} else {
						bmh.setReason("");
					}

					hs.save(bmh);

					hs.update(bm);
				}

				hs.flush();
				tx.commit();
				request.setAttribute("bidMaster", bm);

			}
			return (mapping.findForward("view"));
		} catch (Exception e) {
			e.printStackTrace();
			// log.error(e.getMessage());
			return (mapping.findForward("view"));
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				// log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				// log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
	}

	private ArrayList ComparatorStepArray(Set steps) {
		ArrayList list = new ArrayList();
		Object[] stepArray = steps.toArray();
		for (int i = 0; i < steps.size(); i++) {
			Integer seqNo1 = ((SalesStep) stepArray[i]).getSeqNo();
			for (int j = i + 1; j < steps.size(); j++) {
				Integer seqNo2 = ((SalesStep) stepArray[j]).getSeqNo();
				seqNo1 = ((SalesStep) stepArray[i]).getSeqNo();
				if (seqNo1.intValue() > seqNo2.intValue()) {
					Object temp = stepArray[i];
					stepArray[i] = stepArray[j];
					stepArray[j] = temp;
				}
			}
			list.add(stepArray[i]);
		}

		return list;
	}
}