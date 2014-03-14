package com.aof.webapp.action.prm.bid;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.bid.BMHistory;
import com.aof.component.prm.bid.BidActivity;
import com.aof.component.prm.bid.BidMaster;
import com.aof.component.prm.bid.BidMasterService;
import com.aof.component.prm.bid.BidMasterStatus;
import com.aof.component.prm.bid.BidUnweightedValue;
import com.aof.component.prm.bid.ContactList;
import com.aof.component.prm.bid.SalesActivity;
import com.aof.component.prm.bid.SalesStep;
import com.aof.component.prm.bid.SalesStepGroup;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectCategory;
import com.aof.component.prm.project.ProjectHelper;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ProjectType;
import com.aof.component.prm.project.ServiceType;
import com.aof.component.prm.util.EmailService;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.prm.contract.EditContractProfileAction;
import com.aof.webapp.action.prm.report.ReportBaseAction;

public class DialogBidMasterAction extends ReportBaseAction {
	


	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditContractProfileAction.class.getName());

		UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		net.sf.hibernate.Transaction tx = null;

		try {
			String formAction = request.getParameter("formAction");
			String column = request.getParameter("column");

			if (formAction == null || formAction.trim().equals("")) {
				formAction = "view";
			}
			if (column == null) {
				column = "";
			}

			Session hs = Hibernate2Session.currentSession();
			ProjectHelper projHelper = new ProjectHelper();
			List currencyList = projHelper.getAllCurrency(hs);
			if (currencyList == null) {
				currencyList = new ArrayList();
			}
			request.setAttribute("currencyList", currencyList);

			PartyHelper ph = new PartyHelper();
			List partyList = ph.getAllBidDept(hs);
			if (partyList == null) {
				partyList = new ArrayList();
			}

			request.setAttribute("PartyList", partyList);

			Query query = null;

			String offSet = request.getParameter("offSet");

			String id = request.getParameter("id");

			String sqlStr = "";

			if ((id != null) && (id.length() > 0)) {
				sqlStr = "select bv from BidUnweightedValue as bv where bid_no ='" + id + "'";
				Query bidQuery = hs.createQuery(sqlStr);
				request.setAttribute("BidUnweightedValueList", bidQuery.list());
			}

			BidMaster bm = null;

			if ( formAction.equals("view")) {

				if (!((id == null) || (id.length() < 1))) {
					bm = (BidMaster) hs.load(BidMaster.class, new Long(id));
				}

				if (column.equals("Unweighted")) {
					if ((id != null) && (id.length() > 0)) {
						Query strUnweightedQuery = hs
								.createQuery("select bv from BidUnweightedValue as bv where bid_no ='"
										+ id + "' order by bv.id asc");
						request.setAttribute("BidUnweightedValueList", strUnweightedQuery.list());
					}
				}

				if (column.equals("Contact")) {
					bm.getContactList().size();
				}

				if (column.equals("Activity")) {

					Set bidActivities = bm.getBidActivities();
					if (bidActivities != null) {
						bidActivities.size();
					}

					List stepList = new ArrayList();
					SalesStepGroup stepGroup = null;

					if (bm.getStepGroup() != null) {

						stepGroup = bm.getStepGroup();

						if (stepGroup.getSteps() != null) {
							Set stepSet = stepGroup.getSteps();
							stepList = ComparatorStepArray(stepSet);
							Iterator its = stepSet.iterator();
							while (its.hasNext()) {
								SalesStep step = (SalesStep) its.next();
								if (step.getActivities() != null) {
									step.getActivities().size();
								}
							}
						}
					}

					request.setAttribute("stepGroup", stepGroup);
					request.setAttribute("bidActivityObject", bidActivities);
					request.setAttribute("stepsList", stepList);
				}

				if (column.equals("History")) {
					Query q = hs.createQuery("from BMHistory as history where history.masterid=?");
					q.setLong(0, bm.getId().longValue());
					request.setAttribute("bidmasterhistory", q.list());
				
//					bm.getBmhistory().size();
				}

				request.setAttribute("BidMaster", bm);
				request.setAttribute("mstr", bm);
				request.setAttribute("offSet", offSet);
			}

		} catch (Exception e) {
			try {
				if (tx != null) {
					tx.rollback();
				}
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (tx != null) {
					tx.commit();
				}
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
