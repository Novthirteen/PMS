/*
 * Created on 2005-6-21
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.webapp.action.prm.contract;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.bid.BidMaster;
import com.aof.component.prm.contract.ContractProfile;
import com.aof.component.prm.contract.ContractService;
import com.aof.component.prm.project.CurrencyType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.prm.report.ReportBaseAction;

/**
 * @author CN01512
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class EditContractProfileAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditContractProfileAction.class.getName());
		// Locale locale = getLocale(request);
		// MessageResources messages = getResources();
		UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);

		String action = request.getParameter("FormAction");
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		log.info("action=" + action);
		try {
			String ProjectId = request.getParameter("contractId");
			String ContractNo = request.getParameter("contractNo");
			String ContractDes = request.getParameter("contractDes");
			String CustomerId = request.getParameter("customerId");
			// String ProjectManagerId =
			// request.getParameter("projectManagerId");
			String accountManagerId = request.getParameter("accountManagerId");
			String totalServiceValueStr = request.getParameter("totalServiceValue");
			String AlownceStr = request.getParameter("alownceAmt");
			String ContractType = request.getParameter("ContractType");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String bidId = request.getParameter("bidId");
			String currencyId = request.getParameter("currency");
			String exchangeRateStr = request.getParameter("exchangeRate");
			String signedOrNot = request.getParameter("signedOrNot");
			String signedDate = request.getParameter("signedDate");
			String DepartmentId = request.getParameter("departmentId");
			String legalReviewDate = request.getParameter("legalReviewDate");
			String custSat = request.getParameter("custSat");
			String SalesPersonId1 = request.getParameter("SalesPersonId1");
			String SalesPersonId2 = request.getParameter("SalesPersonId2");
			String comments = request.getParameter("contractComments");

			String status = request.getParameter("textStatus");

			if (custSat == null)
				custSat = "";
			String deleteOrNot = "yes";

			String repeatFlag = "";

			totalServiceValueStr = UtilString.removeSymbol(totalServiceValueStr, ',');
			exchangeRateStr = UtilString.removeSymbol(exchangeRateStr, ',');
			AlownceStr = UtilString.removeSymbol(AlownceStr, ',');

			Double totalServiceValue = null;
			// Float PSCBudget=null;
			// Float ProcBudget=null;
			Float AlownceRate = null;
			Float exchangeRate = null;

			// Float EXPBudget=null;
			// Float totalLicsValue=null;

			if (!(totalServiceValueStr == null || totalServiceValueStr.length() < 1)) {
				totalServiceValue = new Double(totalServiceValueStr);
			} else {
				totalServiceValue = new Double(0);
			}

			if (!(AlownceStr == null || AlownceStr.length() < 1)) {
				AlownceRate = new Float(AlownceStr);
			} else {
				AlownceRate = new Float(0);
			}

			if (!(exchangeRateStr == null || exchangeRateStr.length() < 1)) {
				exchangeRate = new Float(exchangeRateStr);
			} else {
				exchangeRate = new Float(0);
			}

			if (ProjectId == null)
				ProjectId = "";
			if (ContractNo == null)
				ContractNo = "";
			if (accountManagerId == null)
				accountManagerId = "";
			if (SalesPersonId1 == null)
				SalesPersonId1 = "";
			if (SalesPersonId2 == null)
				SalesPersonId2 = "";
			if (comments == null)
				comments = "";

			// //if (ProjectManagerId == null) ProjectManagerId ="";
			// String CAFFlag=request.getParameter("CAFFlag");
			// if (CAFFlag == null) CAFFlag ="N";

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			if (action == null)
				action = "view";
			ContractProfile CustProject = null;

			if (action.equals("create")) {

				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				try {
					tx = hs.beginTransaction();

					CustProject = new ContractProfile();

					if (CustomerId != null && CustomerId.trim().length() != 0) {
						com.aof.component.crm.customer.CustomerProfile Customer = (com.aof.component.crm.customer.CustomerProfile) hs
								.load(com.aof.component.crm.customer.CustomerProfile.class,
										CustomerId);
						if (signedOrNot != null) {
							Customer.setType("C");
						}
						CustProject.setCustomer(Customer);
					}

					if (DepartmentId != null && DepartmentId.trim().length() != 0) {
						Party Department = (Party) hs.load(Party.class, DepartmentId);
						CustProject.setDepartment(Department);
					}

					// if (!ProjectManagerId.equals("")) {
					// UserLogin
					// ProjectManager=(UserLogin)hs.load(UserLogin.class,ProjectManagerId);
					// CustProject.setProjectManager(ProjectManager);
					// }
					if (!accountManagerId.equals("")) {
						UserLogin AccountManager = (UserLogin) hs.load(UserLogin.class,
								accountManagerId);
						CustProject.setAccountManager(AccountManager);
					}
					if (ContractNo.trim().equals("")) {
						ContractService Service = new ContractService();
						CustProject.setNo(Service.getContractNo(CustProject, hs));
					}

					if (currencyId != null && currencyId.trim().length() != 0) {
						CurrencyType currency = (CurrencyType) hs.load(CurrencyType.class,
								currencyId);
						CustProject.setCurrency(currency);
					}
					if (bidId != null && bidId.trim().length() != 0) {
						long bId = Long.parseLong(bidId);
						BidMaster bid = (BidMaster) hs.load(BidMaster.class, new Long(bId));
						CustProject.setBidMaster(bid);
					}

					CustProject.setContractType(ContractType);
					CustProject.setDescription(ContractDes);
					CustProject.setTotalContractValue(totalServiceValue);
					CustProject.setCustomerSat(custSat);
					CustProject.setComments(comments);
					CustProject.setCustPaidAllowance(AlownceRate);
					CustProject.setStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
					CustProject.setEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
					if (SalesPersonId1 != null && SalesPersonId1.trim().length() != 0) {
						UserLogin SalesPerson1 = (UserLogin) hs.load(UserLogin.class,
								SalesPersonId1);
						CustProject.setSalesPerson1(SalesPerson1);
					}
					if (SalesPersonId2 != null && SalesPersonId2.trim().length() != 0) {
						UserLogin SalesPerson2 = (UserLogin) hs.load(UserLogin.class,
								SalesPersonId2);
						CustProject.setSalesPerson2(SalesPerson2);
					}

					if (legalReviewDate != null && legalReviewDate.trim().length() != 0) {
						CustProject.setLegalReviewDate(UtilDateTime.toDate2(legalReviewDate
								+ " 00:00:00.000"));
					}

					CustProject.setCreateUser(ul);
					/*
					 * if(createDate!=null && createDate.length()!=0 ){
					 * CustProject.setCreateDate(UtilDateTime.toDate2(createDate + "
					 * 00:00:00.000")); }
					 */
					CustProject.setCreateDate(UtilDateTime.toDate2(Date_formater.format(new Date())+ " 00:00:00.000"));
					if (signedOrNot != null) {
						if (signedDate != null && signedDate.length() != 0) {
							CustProject.setSignedDate(UtilDateTime.toDate2(signedDate
									+ " 00:00:00.000"));
						}
					}
					// CustProject.setNeedCAF(CAFFlag);
					CustProject.setExchangeRate(exchangeRate);

					if (CustProject.getSignedDate() != null) {
						CustProject.setStatus(Constants.CONTRACT_PROFILE_STATUS_SIGNED);
					} else {
						CustProject.setStatus(Constants.CONTRACT_PROFILE_STATUS_UNSIGNED);
					}

					if (ContractNo != null && !ContractNo.equals("")) {
						String QryStr = " select cp from ContractProfile as cp ";
						QryStr = QryStr + "where cp.no = '" + ContractNo + "'";
						Query query = hs.createQuery(QryStr);
						List result = query.list();
						if (result != null && result.size() > 0) {
							repeatFlag = "yes";
							request.setAttribute("repeatName", repeatFlag);
							request.setAttribute("CustProject", CustProject);
							CustProject.setNo(ContractNo);
							return (mapping.findForward("view"));
						}

						CustProject.setNo(ContractNo);
					}

					// insert default CTC forecast

					hs.save(CustProject);
					tx.commit();

					log.info("go to >>>>>>>>>>>>>>>>. view forward");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			if (action.equals("update")) {
				if ((ProjectId == null) || ProjectId.equals("null") || (ProjectId.length() < 1))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}

				tx = hs.beginTransaction();
				CustProject = (ContractProfile) hs.load(ContractProfile.class, new Long(ProjectId));

				String cpNo = CustProject.getNo();

				if (CustomerId != null && CustomerId.trim().length() != 0) {
					com.aof.component.crm.customer.CustomerProfile Customer = (com.aof.component.crm.customer.CustomerProfile) hs
							.load(com.aof.component.crm.customer.CustomerProfile.class, CustomerId);
					CustProject.setCustomer(Customer);
				}

				if (DepartmentId != null && DepartmentId.trim().length() != 0) {
					Party Department = (Party) hs.load(Party.class, DepartmentId);
					CustProject.setDepartment(Department);
				}
				// if (!ProjectManagerId.equals("")) {
				// UserLogin
				// ProjectManager=(UserLogin)hs.load(UserLogin.class,ProjectManagerId);
				// CustProject.setProjectManager(ProjectManager);
				// }

				if (!accountManagerId.equals("")) {
					UserLogin AccountManager = (UserLogin) hs.load(UserLogin.class,
							accountManagerId);
					CustProject.setAccountManager(AccountManager);
				}

				if (ContractNo == null)
					ContractNo = "";
				if (ContractNo.trim().equals("")) {
					ContractService Service = new ContractService();
					CustProject.setNo(Service.getContractNo(CustProject, hs));
				}

				if (currencyId != null && currencyId.trim().length() != 0) {
					CurrencyType currency = (CurrencyType) hs.load(CurrencyType.class, currencyId);
					CustProject.setCurrency(currency);
				}
				if (CustProject.getBidMaster() == null) {
					if (bidId != null && bidId.trim().length() != 0) {
						BidMaster bid = (BidMaster) hs.load(BidMaster.class, new Long(bidId));
						CustProject.setBidMaster(bid);
					}
				}

				// CustProject.setCreateUser(ul);
				CustProject.setCustomerSat(custSat);
				CustProject.setDescription(ContractDes);
				CustProject.setContractType(ContractType);
				CustProject.setCustPaidAllowance(AlownceRate);
				CustProject.setStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
				CustProject.setEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
				CustProject.setTotalContractValue(totalServiceValue);
				CustProject.setComments(comments);
				if (SalesPersonId1 != null && SalesPersonId1.trim().length() != 0) {
					UserLogin SalesPerson1 = (UserLogin) hs.load(UserLogin.class, SalesPersonId1);
					CustProject.setSalesPerson1(SalesPerson1);
				}

				if (SalesPersonId2 != null && SalesPersonId2.trim().length() != 0) {
					UserLogin SalesPerson2 = (UserLogin) hs.load(UserLogin.class, SalesPersonId2);
					CustProject.setSalesPerson2(SalesPerson2);
				}

				if (legalReviewDate != null && legalReviewDate.trim().length() != 0) {
					CustProject.setLegalReviewDate(UtilDateTime.toDate2(legalReviewDate
							+ " 00:00:00.000"));
				}
				/*
				 * if(createDate!=null && createDate.length()!=0 ){
				 * CustProject.setEndDate(UtilDateTime.toDate2(createDate + "
				 * 00:00:00.000")); }
				 */
				// CustProject.setCreateDate(new Date());
				if (status != null && !status.equals("")) {
					if (status.equals("Signed")) {
						CustProject.setStatus(Constants.CONTRACT_PROFILE_STATUS_SIGNED);
						CustProject.setSignedDate(UtilDateTime
								.toDate2(signedDate + " 00:00:00.000"));
					} else if (status.equals("Unsigned")) {
						CustProject.setStatus(Constants.CONTRACT_PROFILE_STATUS_UNSIGNED);
						CustProject.setSignedDate(null);
					} else if (status.equals("Cancel")) {
						CustProject.setStatus(Constants.CONTRACT_PROFILE_STATUS_CANCEL);
					}
				}

				// CustProject.setNeedCAF(CAFFlag);
				CustProject.setExchangeRate(exchangeRate);

				if (ContractNo != null && !ContractNo.equals(cpNo)) {
					System.out.println("..................log:cpNo->" + cpNo);
					String QryStr = " select cp from ContractProfile as cp ";
					QryStr = QryStr + "where cp.no = '" + ContractNo + "'";
					Query query = hs.createQuery(QryStr);
					List result = query.list();
					if (result != null && result.size() > 0) {
						repeatFlag = "yes";
						request.setAttribute("repeatName", repeatFlag);
						request.setAttribute("CustProject", CustProject);
						CustProject.setNo(ContractNo);
						return (mapping.findForward("view"));
					}

					CustProject.setNo(ContractNo);
				}

				hs.update(CustProject);
				tx.commit();
			}

			if (action.equals("reportToexcel")) {
				if ((ProjectId == null) || ProjectId.equals("null") || (ProjectId.length() < 1))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}

				CustProject = (ContractProfile) hs.load(ContractProfile.class, new Long(ProjectId));

				return ExportToExcel(mapping, request, response, CustProject);
			}

			if (action.equals("delete")) {
				if ((ProjectId == null) || (ProjectId.length() < 1))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.isEmpty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				tx = hs.beginTransaction();

				CustProject = (ContractProfile) hs.load(ContractProfile.class, new Long(ProjectId));
				if (CustProject.getProjects().size() == 0) {
					hs.delete(CustProject);
					hs.flush();
				} else {
					deleteOrNot = "no";
				}
				tx.commit();
				request.setAttribute("deleteOrNot", deleteOrNot);
				return (mapping.findForward("list"));

			}

			if (action.equals("cancel")) {
				tx = hs.beginTransaction();
				CustProject = (ContractProfile) hs.load(ContractProfile.class, new Long(ProjectId));
				CustProject.setStatus(Constants.CONTRACT_PROFILE_STATUS_CANCEL);
				hs.update(CustProject);
				hs.flush();
				tx.commit();
			}
			if (action.equals("closed")) {
				tx = hs.beginTransaction();
				CustProject = (ContractProfile) hs.load(ContractProfile.class, new Long(ProjectId));
				CustProject.setStatus(Constants.CONTRACT_PROFILE_STATUS_CLOSED);
				hs.update(CustProject);
				hs.flush();
				tx.commit();
			}
			if (action.equals("undoCancel")) {
				tx = hs.beginTransaction();
				CustProject = (ContractProfile) hs.load(ContractProfile.class, new Long(ProjectId));
				CustProject.setStatus(Constants.CONTRACT_PROFILE_STATUS_UNSIGNED);
				hs.update(CustProject);
				hs.flush();
				tx.commit();
			}
			if (action.equals("closed") || action.equals("undoCancel") || action.equals("view")
					|| action.equals("create") || action.equals("update")
					|| action.equals("cancel")) {
				if (!((ProjectId == null) || ProjectId.equals("null") || (ProjectId.length() < 1))) {
					CustProject = (ContractProfile) hs.load(ContractProfile.class, new Long(
							ProjectId));

				}
				if (CustProject != null) {
					if (CustProject.getProjects() != null && CustProject.getProjects().size() > 0) {
						request.setAttribute("hasProject", "true");
					} else {
						request.setAttribute("hasProject", "false");
					}
				}
				request.setAttribute("CustProject", CustProject);

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

	private ActionForward ExportToExcel(ActionMapping mapping, HttpServletRequest request,
			HttpServletResponse response, ContractProfile contract) {
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

			HSSFCell cell = null;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private final static String ExcelTemplate = "Contract Profile.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Contract Profile.xls";
}
