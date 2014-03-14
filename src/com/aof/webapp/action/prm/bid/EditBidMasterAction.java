/*
 * Created on 2005-7-8
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
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
import com.aof.component.prm.project.ProjectAssignment;
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

/**
 * @author angus
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class EditBidMasterAction extends ReportBaseAction {

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

			String pId = "";
			for (int pIt = 0; pIt < partyList.size(); pIt++) {
				if (pIt == 0) {
					pId = ((Party) partyList.get(pIt)).getPartyId();
				}
				pId += "," + ((Party) partyList.get(pIt)).getPartyId();
			}
			String strQueryUl = "select ul from UserLogin as ul where ul.party.partyId in (" + pId
					+ ") and ul.type='slmanager'";
			query = hs.createQuery(strQueryUl);
			List slList = query.list();
			request.setAttribute("slList", slList);

			String dept = request.getParameter("departmentId");
			String offSet = request.getParameter("offSet");
			if (!isTokenValid(request)) {
				if (formAction.equals("new") || formAction.equals("update")
						|| formAction.indexOf("Prospect") > 0
						|| formAction.indexOf("Unweighted") > 0
						|| formAction.indexOf("Contact") > 0 || formAction.indexOf("Activity") > 0
						|| formAction.indexOf("History") > 0) {
					System.out.println("token is invalid,change to view");
					formAction = "view";
				}
			}
			if (!formAction.equalsIgnoreCase("ExportToExcel")
					&& !formAction.equalsIgnoreCase("dialog")) {
				saveToken(request);
			}

			if (formAction.equals("preCreate")) {
				request.setAttribute("dept", dept);
				request.setAttribute("offSet", offSet);
				return mapping.findForward("success");
			}

			String id = request.getParameter("id");
			String dapartmentId = request.getParameter("dapartmentId");
			String description = request.getParameter("description");
			String presalePMId = request.getParameter("PresalePMId");
			String salesPersonId = request.getParameter("salesPersonId");
			String salesPersonId2 = request.getParameter("salesPersonId2");
			String currencyId = request.getParameter("currencyId");
			String status = request.getParameter("statusValue");
			String estimateAmount = request.getParameter("estimateAmount");
			String exchangeRate = request.getParameter("exchangeRate");
			String startDate = request.getParameter("estimateStartDate");
			String hid_startDate = request.getParameter("hid_estimateStartDate");
			String endDate = request.getParameter("estimateEndDate");
			String hid_endDate = request.getParameter("hid_estimateEndDate");
			String expectedEndDate = request.getParameter("expectedEndDate");
			String hid_expectedEndDate = request.getParameter("hid_expectedEndDate");
			String contractType = request.getParameter("contractType");
			String prospectCompanyId = request.getParameter("prospectCompanyId");

			estimateAmount = UtilString.removeSymbol(estimateAmount, ',');
			exchangeRate = UtilString.removeSymbol(exchangeRate, ',');

			Double amountValue = null;
			Float rateValue = null;
			if (!(estimateAmount == null || estimateAmount.length() < 1)) {
				amountValue = new Double(estimateAmount);
			} else {
				amountValue = new Double(0);
			}
			if (!(exchangeRate == null || exchangeRate.length() < 1)) {
				rateValue = new Float(exchangeRate);
			} else {
				rateValue = new Float(0);
			}

			String changeReason = request.getParameter("changeReason");

			String sqlStr = "";

			if ((id != null) && (id.length() > 0)) {
				sqlStr = "select bv from BidUnweightedValue as bv where bid_no =?";
				Query bidQuery = hs.createQuery(sqlStr);
				bidQuery.setLong(0, Long.parseLong(id));
				request.setAttribute("BidUnweightedValueList", bidQuery.list());
			}

			BidMaster bm = null;
			CustomerProfile prospectCompany = null;
			BidMasterService bidservice = new BidMasterService();

			if ("new".equals(formAction)) {
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				try {
					tx = hs.beginTransaction();

					bm = new BidMaster();
					BMHistory bmh = new BMHistory();

					String bidNo = bidservice.getBidMasterNo(bm, hs);
					bm.setNo(bidNo);

					if (currencyId != null && currencyId.trim().length() != 0) {
						CurrencyType currency = (CurrencyType) hs.load(CurrencyType.class,
								currencyId);
						bm.setCurrency(currency);
					}
					if (salesPersonId != null && salesPersonId.trim().length() != 0) {
						UserLogin salesPerson = (UserLogin) hs.load(UserLogin.class, salesPersonId);
						bm.setSalesPerson(salesPerson);
					}
					if (salesPersonId2 != null && salesPersonId2.trim().length() != 0) {
						UserLogin salesPerson2 = (UserLogin) hs.load(UserLogin.class,
								salesPersonId2);
						bm.setSecondarySalesPerson(salesPerson2);
					}
					if (presalePMId != null && presalePMId.trim().length() != 0) {
						UserLogin presalePM = (UserLogin) hs.load(UserLogin.class, presalePMId);
						bm.setPresalePM(presalePM);
					}
					if (dapartmentId != null && dapartmentId.trim().length() != 0) {
						Party Department = (Party) hs.load(Party.class, dapartmentId);
						bm.setDepartment(Department);
					}
					if (startDate != null && startDate.length() != 0) {
						bm.setEstimateStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
						bmh.setCon_st_date(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
					}
					if (endDate != null && endDate.length() != 0) {
						bm.setEstimateEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
						bmh.setCon_ed_date(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
					}

					if (expectedEndDate != null && expectedEndDate.length() != 0) {
						bm.setExpectedEndDate(UtilDateTime.toDate2(expectedEndDate
								+ " 00:00:00.000"));
						bmh.setCon_sign_date(UtilDateTime
								.toDate2(expectedEndDate + " 00:00:00.000"));
					}
					Date createDate = UtilDateTime.nowTimestamp();
					bm.setCreateDate(UtilDateTime.toDate2(createDate.toString()));

					bm.setDescription(description);
					bm.setEstimateAmount(amountValue);
					bm.setExchangeRate(rateValue);
					bm.setStatus("Active");
					bm.setContractType(contractType);
					bm.setLastActionDate(new Date());
					bmh.setStatus("Active");
					bmh.setUser_id(ul);
					bmh.setModify_date(Calendar.getInstance().getTime());
					bmh.setReason("New Creation");

					if (prospectCompanyId != null && prospectCompanyId.trim().length() != 0) {
						prospectCompany = (CustomerProfile) hs.load(Party.class, prospectCompanyId);
						bm.setProspectCompany(prospectCompany);
					}

					SalesStepGroup stepGroup = new SalesStepGroup();

				//	String departmentId = ul.getParty().getPartyId();
					String QryStr = " select sg from SalesStepGroup as sg ";
					QryStr += " inner join sg.department as dep where dep.partyId = '"
							+ dapartmentId + "'";
					query = hs.createQuery(QryStr);
					List result = query.list();

					stepGroup = (SalesStepGroup) result.get(0);
					bm.setStepGroup(stepGroup);

					String strQueryAct = "select act from SalesActivity as act inner join act.step as step where step.stepGroup.id='"
							+ stepGroup.getId() + "'";

					query = hs.createQuery(strQueryAct);
					List stepList = query.list();

					Iterator stepIter = stepList.iterator();
					while (stepIter.hasNext()) {
						SalesActivity salesAct = (SalesActivity) stepIter.next();
						BidActivity bidActivity = new BidActivity();
						bidActivity.setActivity(salesAct);

						bidActivity.setBidMaster(bm);
						hs.save(bidActivity);
						bm.addBidActivity(bidActivity);
					}

					hs.save(bm);
					bmh.setMasterid(bm.getId());
					hs.save(bmh);
//					bm.addBidMstrHistoty(bmh);
					BidMasterStatus bms = new BidMasterStatus();
					bms.setBidMaster(bm);
					bms.setStatus(bm.getStatus());
					bms.setActionDate(bm.getLastActionDate());

					hs.save(bms);

					hs.flush();
					tx.commit();
					id = bm.getId().toString();

					Transaction txx = hs.beginTransaction();
					try {
						double estAmt = amountValue.doubleValue();
						Date estStartDate = UtilDateTime.toDate2(startDate + " 00:00:00.000");
						Date estEndDate = UtilDateTime.toDate2(endDate + " 00:00:00.000");

						Calendar cal = Calendar.getInstance();
						cal.setTime(estEndDate);
						int estEndYear = cal.get(Calendar.YEAR);
						int estEndMonth = cal.get(Calendar.MONTH);
						cal.clear();
						cal.setTime(estStartDate);
						int estStartYear = cal.get(Calendar.YEAR);
						int estStartMonth = cal.get(Calendar.MONTH);
						cal.clear();

						int acrossYear = estEndYear - estStartYear + 1;

						int acrossMonth = (acrossYear - 1) * 12 + estEndMonth - estStartMonth + 1;

						for (int ii = 1; ii <= acrossYear; ii++) {
							BidUnweightedValue uwValue = new BidUnweightedValue();
							if (acrossYear == 1) {
								uwValue.setYear(String.valueOf(estStartYear));
								uwValue.setBid_no(id);
								uwValue.setValue(new Double(estAmt));
							} else if (ii == acrossYear) {
								uwValue.setYear(String.valueOf(estEndYear));
								uwValue.setBid_no(id);
								double tmpValue = ((double) (estEndMonth + 1)) / acrossMonth;
								uwValue.setValue(new Double(tmpValue * estAmt));
							} else if (ii == 1) {
								uwValue.setYear(String.valueOf(estStartYear + ii - 1));
								uwValue.setBid_no(id);
								double tmpValue = ((double) 12 - estStartMonth) / acrossMonth;
								uwValue.setValue(new Double(tmpValue * estAmt));
							} else if ((ii > 1) && (ii < acrossYear)) {
								uwValue.setYear(String.valueOf(estStartYear + ii - 1));
								uwValue.setBid_no(id);
								double tmpValue = ((double) 12 / acrossMonth);
								uwValue.setValue(new Double(tmpValue * estAmt));
							}
							hs.save(uwValue);
						}
						hs.flush();
					} catch (Exception e) {
						txx.rollback();
						e.printStackTrace();
					}
					txx.commit();

					Transaction txxx = hs.beginTransaction();
					try {
						ProjectMaster CustProject = null;
						CustProject = new ProjectMaster();

						if (prospectCompanyId != null) {
							com.aof.component.crm.customer.CustomerProfile Customer = (com.aof.component.crm.customer.CustomerProfile) hs
									.load(com.aof.component.crm.customer.CustomerProfile.class,
											prospectCompanyId);
							CustProject.setCustomer(Customer);
							CustProject.setBillTo(Customer);
						}
						UserLogin ProjectManager = new UserLogin();
						if ((dapartmentId != null) && (salesPersonId != null)
								&& (presalePMId != null)) {
							Party Department = (Party) hs.load(Party.class, dapartmentId);
							CustProject.setDepartment(Department);

							ProjectManager = (UserLogin) hs.load(UserLogin.class, presalePMId);
							CustProject.setProjectManager(ProjectManager);

							UserLogin assistant = (UserLogin) hs.load(UserLogin.class,
									salesPersonId);
							CustProject.setProjAssistant(assistant);

						}

						ProjectType ProjType = (ProjectType) hs.load(ProjectType.class, "AO-China");
						CustProject.setProjectType(ProjType);

						ProjectCategory ProjCategory = (ProjectCategory) hs.load(
								ProjectCategory.class, "I");
						CustProject.setProjectCategory(ProjCategory);
						CustProject.setMailFlag("Y");
						CustProject.setCategory("N");

						CustProject.setProjName("PRESALE-" + bidNo + "-" + description);
						CustProject.setContractNo(bidNo);
						CustProject.setPublicFlag("N");
						CustProject.setProjStatus("WIP");

						CustProject.settotalServiceValue(new Double(new Double(estimateAmount)
								.floatValue()
								* bm.getCurrency().getCurrRate().floatValue()));
						CustProject.setContractGroup("Presale");
						CustProject.setPSCBudget(new Double(0));
						CustProject.setProcBudget(new Double(0));
						CustProject.settotalLicsValue(new Double(0));
						CustProject.setEXPBudget(new Double(0));
						CustProject.setContractType(contractType);
						CustProject.setStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
						CustProject.setEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));

						// ProjectService Service = new ProjectService();
						CustProject.setProjId('I' + bidNo);

						CustProject.setCAFFlag("N");
						CustProject.setProjectLink('I' + bidNo + ":");
						hs.save(CustProject);
						EmailService.notifyUser(CustProject);
						ServiceType st = new ServiceType();
						st.setProject(CustProject);
						st.setDescription("Presale");
						hs.save(st);

						// add member
						if ((salesPersonId != null) && (salesPersonId.length() > 0)) {
							ProjectAssignment pa = new ProjectAssignment();
							pa.setProject(CustProject);
							UserLogin member = (UserLogin) hs.load(UserLogin.class, salesPersonId);
							pa.setUser(member);
							pa.setDateStart(new Date());
							pa.setDateEnd(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
							hs.save(pa);
						}
						if ((salesPersonId2 != null) && (salesPersonId2.length() > 0)) {
							ProjectAssignment pa = new ProjectAssignment();
							pa.setProject(CustProject);
							UserLogin member = (UserLogin) hs.load(UserLogin.class, salesPersonId2);
							pa.setUser(member);
							pa.setDateStart(new Date());
							pa.setDateEnd(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
							hs.save(pa);
						}

						hs.flush();
					} catch (Exception e) {
						txxx.rollback();
						e.printStackTrace();
					}
					txxx.commit();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			if ("update".equals(formAction)) {
				if ((id == null) || (id.length() < 1))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}

				tx = hs.beginTransaction();
				bm = (BidMaster) hs.load(BidMaster.class, new Long(id));

				List result = null;
				ProjectMaster Custproject = null;
				query = hs.createQuery(" from ProjectMaster as pm where pm.ContractNo = ?");
				query.setString(0, bm.getNo());
				result = query.list();
				if ((result != null) && (result.size() > 0))
					Custproject = (ProjectMaster) result.get(0);
				BMHistory bmh = new BMHistory();

				if (currencyId != null && currencyId.trim().length() != 0) {
					CurrencyType currency = (CurrencyType) hs.load(CurrencyType.class, currencyId);
					bm.setCurrency(currency);
				}
				if (salesPersonId != null && salesPersonId.trim().length() != 0) {
					UserLogin salesPerson = (UserLogin) hs.load(UserLogin.class, salesPersonId);
					bm.setSalesPerson(salesPerson);
				}
				if (salesPersonId2 != null && salesPersonId2.trim().length() != 0) {
					UserLogin salesPerson2 = (UserLogin) hs.load(UserLogin.class, salesPersonId2);
					bm.setSecondarySalesPerson(salesPerson2);
				}
				if (presalePMId != null && presalePMId.trim().length() != 0) {
					UserLogin presalePM = (UserLogin) hs.load(UserLogin.class, presalePMId);
					bm.setPresalePM(presalePM);
					Custproject.setProjectManager(presalePM);
					hs.save(Custproject);
				}
				if (dapartmentId != null && dapartmentId.trim().length() != 0) {
					Party Department = (Party) hs.load(Party.class, dapartmentId);
					bm.setDepartment(Department);
					Custproject.setDepartment(Department);
					hs.save(Custproject);
				}
				if (startDate != null && startDate.length() != 0) {
					bm.setEstimateStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
				}
				if (endDate != null && endDate.length() != 0) {
					bm.setEstimateEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
				}
				if (expectedEndDate != null && expectedEndDate.length() != 0) {
					bm.setExpectedEndDate(UtilDateTime.toDate2(expectedEndDate + " 00:00:00.000"));
				}
				if (description != null && !description.equals(bm.getDescription())) {
					bm.setDescription(description);
				}
				if (amountValue != null && !amountValue.equals(bm.getEstimateAmount())) {
					bm.setEstimateAmount(amountValue);
				}
				if (rateValue != null && !rateValue.equals(bm.getExchangeRate())) {
					bm.setExchangeRate(rateValue);
				}
				if (status == null) {
					status = "Won";
				}
				if (status != null && !status.equals(bm.getStatus())) {
					bm.setStatus(status);
				}
				if (contractType != null && !contractType.equals(bm.getContractType())) {
					bm.setContractType(contractType);
				}

				bm.setLastActionDate(new Date());

				if ((hid_startDate.equalsIgnoreCase("yes"))
						|| (hid_endDate.equalsIgnoreCase("yes"))
						|| (hid_expectedEndDate.equalsIgnoreCase("yes"))) {
					bmh.setMasterid(bm.getId());
					if (startDate != null && startDate.length() != 0) {
						bmh.setCon_st_date(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
					}
					if (endDate != null && endDate.length() != 0) {
						bmh.setCon_ed_date(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
					}
					if (expectedEndDate != null && expectedEndDate.length() != 0) {
						bmh.setCon_sign_date(UtilDateTime
								.toDate2(expectedEndDate + " 00:00:00.000"));
					}
					if (changeReason == null) {
						changeReason = "";
					}
					bmh.setStatus(status);
					bmh.setUser_id(ul);
					bmh.setModify_date(Calendar.getInstance().getTime());
					bmh.setMasterid(bm.getId());
					bmh.setReason(changeReason);
					hs.save(bmh);
//					bm.addBidMstrHistoty(bmh);
				}
				hs.update(bm);
				// save bid master status table
				BidMasterStatus bms = new BidMasterStatus();
				bms.setBidMaster(bm);
				bms.setStatus(bm.getStatus());
				bms.setActionDate(bm.getLastActionDate());

				hs.save(bms);
				if ((status.equalsIgnoreCase("Lost/Drop")) || (status.equalsIgnoreCase("Won"))) {
					if (Custproject != null) {
						Custproject.setProjStatus("Close");
					}
					hs.save(Custproject);
				} else {
					if (Custproject != null)
						Custproject.setProjStatus("WIP");
					hs.save(Custproject);
				}

				hs.flush();
				tx.commit();
			}

			if (formAction.equals("predel")) {
				return mapping.findForward("predel-success");
			}

			if (formAction.equals("delete")) {

				String reason = request.getParameter("reason");

				if ((id == null) || (id.length() < 1))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				tx = hs.beginTransaction();

				bm = (BidMaster) hs.load(BidMaster.class, new Long(id));

				List result = null;
				ProjectMaster Custproject = null;
				query = hs.createQuery(" from ProjectMaster as pm where pm.ContractNo = ?");
				query.setString(0, bm.getNo());
				result = query.list();
				if ((result != null) && (result.size() > 0))
					Custproject = (ProjectMaster) result.get(0);
				if (Custproject != null) {
					Custproject.setProjStatus("Close");
					// Custproject.setContractNo(null);
					hs.save(Custproject);
				}
				bm.setStatus("Deleted");

				EmailService.notifyUser(bm, reason);

				hs.flush();
				tx.commit();
				return (mapping.findForward("list"));
			}

			if (formAction.equals("addUnweightedValueList")) {

				String yearNew = request.getParameter("yearNew");
				String unweightedValue = request.getParameter("unweightedValueNew");

				Double v = null;
				if (unweightedValue != null) {
					v = new Double(unweightedValue);
				}
				tx = hs.beginTransaction();
				BidUnweightedValue bv = new BidUnweightedValue();
				bv.setBid_no(id);
				bv.setValue(v);
				bv.setYear(yearNew);
				hs.save(bv);
				hs.flush();
				tx.commit();
				formAction = "view";

			}

			if (formAction.equals("recalUnweightedValue")) {
				if ((id == null) || id.equals("null") || (id.length() < 1)) {
					actionDebug.addGlobalError(errors, "error.context.required");
				}

				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				tx = hs.beginTransaction();
				bm = (BidMaster) hs.load(BidMaster.class, new Long(id));
				if (startDate != null && startDate.length() != 0) {
					bm.setEstimateStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
				}
				if (endDate != null && endDate.length() != 0) {
					bm.setEstimateEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
				}
				if (expectedEndDate != null && expectedEndDate.length() != 0) {
					bm.setExpectedEndDate(UtilDateTime.toDate2(expectedEndDate + " 00:00:00.000"));
				}
				if (amountValue != null && !amountValue.equals(bm.getEstimateAmount()))
					bm.setEstimateAmount(amountValue);
				bm.setLastActionDate(new Date());
				hs.update(bm);

				Query q = hs.createQuery("from BidUnweightedValue as un where un.bid_no = ?");
				q.setLong(0, Long.parseLong(id));
				List unList = q.list();
				if ((unList != null) && (unList.size() > 0)) {
					for (int i = 0; i < unList.size(); i++) {
						hs.delete(unList.get(i));
					}
				}

				double estAmt = amountValue.doubleValue();
				Date estStartDate = UtilDateTime.toDate2(startDate + " 00:00:00.000");
				Date estEndDate = UtilDateTime.toDate2(endDate + " 00:00:00.000");

				Calendar cal = Calendar.getInstance();
				cal.setTime(estEndDate);
				int estEndYear = cal.get(Calendar.YEAR);
				int estEndMonth = cal.get(Calendar.MONTH);
				cal.clear();
				cal.setTime(estStartDate);
				int estStartYear = cal.get(Calendar.YEAR);
				int estStartMonth = cal.get(Calendar.MONTH);
				cal.clear();

				int acrossYear = estEndYear - estStartYear + 1;

				int acrossMonth = (acrossYear - 1) * 12 + estEndMonth - estStartMonth + 1;

				for (int ii = 1; ii <= acrossYear; ii++) {
					BidUnweightedValue uwValue = new BidUnweightedValue();
					if (acrossYear == 1) {
						uwValue.setYear(String.valueOf(estStartYear));
						uwValue.setBid_no(id);
						uwValue.setValue(new Double(estAmt));
					} else if (ii == acrossYear) {
						uwValue.setYear(String.valueOf(estEndYear));
						uwValue.setBid_no(id);
						double tmpValue = ((double) (estEndMonth + 1)) / acrossMonth;
						uwValue.setValue(new Double(tmpValue * estAmt));
					} else if (ii == 1) {
						uwValue.setYear(String.valueOf(estStartYear + ii - 1));
						uwValue.setBid_no(id);
						double tmpValue = ((double) 12 - estStartMonth) / acrossMonth;
						uwValue.setValue(new Double(tmpValue * estAmt));
					} else if ((ii > 1) && (ii < acrossYear)) {
						uwValue.setYear(String.valueOf(estStartYear + ii - 1));
						uwValue.setBid_no(id);
						double tmpValue = ((double) 12 / acrossMonth);
						uwValue.setValue(new Double(tmpValue * estAmt));
					}
					hs.save(uwValue);
				}
			}

			if (formAction.equals("deleteUnweightedValue")) {
				if ((id == null) || id.equals("null") || (id.length() < 1)) {
					actionDebug.addGlobalError(errors, "error.context.required");
				}

				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}

				String year = request.getParameter("yearAdd");
				tx = hs.beginTransaction();
				String sql = "select bv from BidUnweightedValue as bv where bid_no=? and bid_year='"
						+ year + "' ";
				query = hs.createQuery(sql);
				query.setLong(0, Long.parseLong(id));
				List l = query.list();
				Iterator valueItr = l.iterator();
				while (valueItr.hasNext()) {
					BidUnweightedValue bv = (BidUnweightedValue) valueItr.next();
					hs.delete(bv);
				}
				hs.flush();
				tx.commit();
			}

			if ("deleteContact".equals(formAction)) {
				String contactId = request.getParameter("contactId");
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				if (((contactId == null) || (contactId.length() < 1)))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}

				tx = hs.beginTransaction();

				bm = (BidMaster) hs.load(BidMaster.class, new Long(id));
				ContactList contact = (ContactList) hs.load(ContactList.class, new Long(contactId));

				Set contactList = bm.getContactList();
				if (contactList == null) {
					contactList = new HashSet();
				}

				contactList.remove(contact);
				bm.setContactList(contactList);
				hs.update(bm);
				hs.delete(contact);

				hs.flush();
				tx.commit();
			}

			if ("addContact".equals(formAction)) {
				if (((id == null) || (id.length() < 1))) {
					actionDebug.addGlobalError(errors, "error.context.required");
				}

				String clname = request.getParameter("clname1");
				String clchinesename = request.getParameter("clchinesename1");
				String clteleno = request.getParameter("clteleno1");
				String clemail = request.getParameter("clemail1");
				String clposition = request.getParameter("clposition1");

				if (clname != null) {
					bm = (BidMaster) hs.load(BidMaster.class, new Long(id));
					ContactList contact = new ContactList();
					Set contactList = bm.getContactList();

					if (contactList == null) {
						contactList = new HashSet();
					}

					tx = hs.beginTransaction();

					contact.setName(clname);
					contact.setChineseName(clchinesename);
					contact.setEmail(clemail);
					contact.setTeleNo(clteleno);
					contact.setPosition(clposition);
					contact.setBid_id(new Long(Long.parseLong(id)));
					hs.save(contact);

					contactList.add(contact);
					bm.setContactList(contactList);
					hs.update(bm);

					hs.flush();
					tx.commit();
				}
			}

			if (formAction.equals("updateProspect")) {

				if (id != null && !id.trim().equals("")) {

					tx = hs.beginTransaction();

					bm = (BidMaster) hs.load(BidMaster.class, new Long(id));
					if (prospectCompanyId != null && prospectCompanyId.trim().length() != 0) {

						prospectCompany = (CustomerProfile) hs.load(Party.class, prospectCompanyId);

						bm.setProspectCompany(prospectCompany);
						hs.update(bm);

						hs.flush();
					}
					tx.commit();
				}

			}

			if (formAction.equals("dialog")) {
				return mapping.findForward("changestatus");
			}

			if (formAction.equals("ExportToExcel")) {
				if ((id == null) || id.equals("null") || (id.length() < 1))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}

				bm = (BidMaster) hs.load(BidMaster.class, new Long(id));

				if (bm.getCurrentStep() != null) {
					return ExportToExcel(mapping, request, response, bm);
				}
				formAction = "view";
			}

			if ("viewBidMaster".equals(formAction)) {
				if (!((id == null) || (id.length() < 1))) {
					bm = (BidMaster) hs.load(BidMaster.class, new Long(id));
				}

				ArrayList stepList = new ArrayList();
				ArrayList bidActivitiesIdList = new ArrayList();
				SalesStepGroup stepGroup = new SalesStepGroup();
				Set tmpContactSet = new HashSet();

				if (bm != null) {
					prospectCompany = bm.getProspectCompany();
					if (prospectCompany != null)
						tmpContactSet = bm.getContactList();
					if (tmpContactSet != null)
						tmpContactSet.size();
				}

				if (bm != null && bm.getStepGroup() != null) {
					stepList = new ArrayList();
					if (bm.getStepGroup() != null) {
						stepGroup = bm.getStepGroup();
						if (stepGroup.getSteps() != null) {
							Set steps = stepGroup.getSteps();
							stepList = ComparatorStepArray(steps);
							Iterator its = steps.iterator();
							while (its.hasNext()) {
								SalesStep step = (SalesStep) its.next();
								if (step.getActivities() != null) {
									step.getActivities().size();
								}
							}
						}
					}
					bidActivitiesIdList = new ArrayList();
					if (bm.getBidActivities() != null && bm.getBidActivities().size() > 0) {
						Set bidActivities = bm.getBidActivities();
						Iterator it = bidActivities.iterator();
						while (it.hasNext()) {
							BidActivity bidActivity = (BidActivity) it.next();
							Long bidActiId = bidActivity.getActivity().getId();
							bidActivitiesIdList.add(bidActiId);
						}
					}
				}
				request.setAttribute("contactList", tmpContactSet);
				request.setAttribute("prospectCompany", prospectCompany);
				request.setAttribute("stepGroup", stepGroup);
				request.setAttribute("bidActivities", bidActivitiesIdList);
				request.setAttribute("stepsList", stepList);
				request.setAttribute("BidMaster", bm);
				return mapping.findForward("view");
			}

			if (formAction.equals("new") || formAction.equals("update")
					|| formAction.equals("view") || formAction.equals("addContact")
					|| formAction.equals("deleteContact") || formAction.indexOf("Prospect") > 0
					|| formAction.indexOf("Unweighted") > 0 || formAction.indexOf("Contact") > 0
					|| formAction.indexOf("Activity") > 0 || formAction.indexOf("History") > 0) {

				if (!((id == null) || (id.length() < 1))) {
					bm = (BidMaster) hs.load(BidMaster.class, new Long(id));
				}

				if (column.equals("Unweighted")) {
					if ((id != null) && (id.length() > 0)) {
						Query strUnweightedQuery = hs
								.createQuery("select bv from BidUnweightedValue as bv where bv.bid_no =? order by bv.id asc");
						strUnweightedQuery.setLong(0, Long.parseLong(id));
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
				}

				request.setAttribute("BidMaster", bm);
				request.setAttribute("mstr", bm);
				request.setAttribute("dept", dept);
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

		return mapping.findForward("success");
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

	private ActionForward ExportToExcel(ActionMapping mapping, HttpServletRequest request,
			HttpServletResponse response, BidMaster bid) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return null;
			}
			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName
					+ "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
					+ ExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

			HSSFCell cell = null;

			int shiftLength = 0;
			if (bid.getProspectCompany() != null) {
				Party prospectCompany = bid.getProspectCompany();
				// status
				cell = sheet.getRow(1).getCell((short) 0);
				// cell.setCellValue(cell.getStringCellValue() +
				// prospectCompany);

				// date
				cell = sheet.getRow(2).getCell((short) 1);
				cell.setCellValue(df.format((java.util.Date) UtilDateTime.nowTimestamp()));

				net.sf.hibernate.Transaction tx = null;
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				tx = hs.beginTransaction();
				bid.setPostDate((java.util.Date) UtilDateTime.nowTimestamp());
				hs.update(bid);
				hs.flush();
				tx.commit();

				int CostomerRow = CostomerStartRow;

				// company name
				cell = sheet.getRow(CostomerRow).getCell((short) 2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(prospectCompany.getDescription());

				// address
				cell = sheet.getRow(CostomerRow + 1).getCell((short) 2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(prospectCompany.getAddress());

				// contact List
				HSSFRow HRow = null;

				int ContactRow = CostomerRow + 3;
				HSSFCellStyle StyleContent = sheet.getRow(CostomerRow + 2).getCell((short) 2)
						.getCellStyle();
				HSSFCellStyle StyleTitle = sheet.getRow(CostomerRow + 2).getCell((short) 1)
						.getCellStyle();

				if (bid.getContactList() != null) {
					shiftLength = bid.getContactList().size();
					// shift the templet
					if (shiftLength > 1) {
						int startRow = ShiftStartRow;
						int endRow = ShiftEndRow;
						sheet.shiftRows(startRow, endRow, shiftLength - 1, true, true);
					}
					Set contactList = bid.getContactList();
					Iterator it = contactList.iterator();
					while (it.hasNext()) {
						ContactList contact = (ContactList) it.next();

						HRow = sheet.createRow(ContactRow);
						cell = HRow.createCell((short) 1);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue("Contact:");
						cell.setCellStyle(StyleTitle);

						cell = HRow.createCell((short) 2);

						sheet.addMergedRegion(new Region(ContactRow, (short) 2, ContactRow,
								(short) 3));
						cell = sheet.getRow(ContactRow).getCell((short) 2);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(contact.getName());
						cell.setCellStyle(StyleContent);

						cell = HRow.createCell((short) 3);
						cell.setCellStyle(StyleContent);

						cell = HRow.createCell((short) 4);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue("Email:");
						cell.setCellStyle(StyleTitle);

						cell = HRow.createCell((short) 5);
						cell = sheet.getRow(ContactRow).getCell((short) 5);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(contact.getEmail());
						cell.setCellStyle(StyleContent);

						cell = HRow.createCell((short) 6);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue("Telephone:");
						cell.setCellStyle(StyleTitle);

						cell = HRow.createCell((short) 7);
						cell = sheet.getRow(ContactRow).getCell((short) 7);
						cell.setCellValue(contact.getTeleNo());
						cell.setCellStyle(StyleContent);

						ContactRow++;
					}
				}

			}

			// salesPerson
			if (bid.getSalesPerson() != null) {
				cell = sheet.getRow(2).getCell((short) 4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(bid.getSalesPerson().getName());
			}

			// department
			cell = sheet.getRow(2).getCell((short) 6);
			cell.setCellValue(bid.getDepartment().getDescription());

			int ContactRow = ContractStartRow;
			if (shiftLength > 1) {
				ContactRow = ContactRow + shiftLength - 1;
			}

			// description
			cell = sheet.getRow(ContactRow).getCell((short) 2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
			cell.setCellValue(bid.getDescription());

			// start date
			cell = sheet.getRow(ContactRow + 1).getCell((short) 2);
			if (bid.getEstimateStartDate() != null)
				cell.setCellValue(df.format(bid.getEstimateStartDate()));

			// end date
			cell = sheet.getRow(ContactRow + 1).getCell((short) 5);
			if (bid.getEstimateEndDate() != null)
				cell.setCellValue(df.format(bid.getEstimateEndDate()));

			// contract Type
			cell = sheet.getRow(ContactRow + 2).getCell((short) 2);
			if (bid.getContractType() != null && bid.getContractType().equals("FP")) {
				cell.setCellValue("Fixed Price");
			} else {
				cell.setCellValue("Time & Material");
			}

			// total amount
			cell = sheet.getRow(ContactRow + 3).getCell((short) 2);
			cell.setCellValue(bid.getEstimateAmount() + "");

			// 写入Excel工作表
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.setStatus(HttpServletResponse.SC_OK);
			response.flushBuffer();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private final static String ExcelTemplate = "RequestContract.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Contract Profile.xls";

	private final int CostomerStartRow = 5;

	private final int ContractStartRow = 12;

	private final int ShiftStartRow = 9;

	private final int ShiftEndRow = 46;
}
