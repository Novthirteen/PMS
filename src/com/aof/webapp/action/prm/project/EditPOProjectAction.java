/*
 * Created on 2005-6-28
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.webapp.action.prm.project;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

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

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.contract.POProfile;
import com.aof.component.prm.project.ExpenseType;
import com.aof.component.prm.project.FMonth;
import com.aof.component.prm.project.FMonthHelper;
import com.aof.component.prm.project.ProjectCategory;
import com.aof.component.prm.project.ProjectCostToComplete;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ProjectService;
import com.aof.component.prm.project.ProjectType;
import com.aof.component.prm.project.ServiceType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

/**
 * @author xxp
 * @version 2003-7-2
 * 
 */
public class EditPOProjectAction extends BaseAction {

	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditContractProjectAction.class.getName());
		// Locale locale = getLocale(request);
		// MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		// SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		log.info("action=" + action);
		try {
			String ProjectId = request.getParameter("DataId");
			String ProjName = request.getParameter("projName");
			String EventCategoryId = request.getParameter("projectType");
			// String ProjectTypeId = request.getParameter("P");
			String contractId = request.getParameter("contractId");
			String ContractNo = request.getParameter("contractNo");
			// String CustomerId = request.getParameter("vendorId");
			String DepartmentId = request.getParameter("departmentId");
			String ProjectManagerId = request.getParameter("projectManagerId");
			String PublicFlag = request.getParameter("PublicFlag");
			String totalServiceValueStr = request.getParameter("totalServiceValue");
			String totalLicsValueStr = request.getParameter("totalLicsValue");
			String EXPBudgetStr = request.getParameter("EXPBudget");
			String PSCBudgetStr = request.getParameter("PSCBudget");
			String ProcBudgetStr = request.getParameter("procBudget");
			String AlownceStr = request.getParameter("alownceAmt");
			String ContractType = request.getParameter("ContractType");
			// String billToId = request.getParameter("billToId");
			String vendorId = request.getParameter("vendorId");
			String paId = request.getParameter("paId");
			String ProjectStatus = request.getParameter("projectStatus");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String CAFFlag = request.getParameter("CAFFlag");
			String ParentProjectId = request.getParameter("ParentProjectId");
			String[] exTypeChk = request.getParameterValues("exTypeChk");
			String expenseNote = request.getParameter("expenseNote");
			String contact = request.getParameter("contact");
			String contactTele = request.getParameter("contactTele");
			String custPM = request.getParameter("custPM");
			String custPMTele = request.getParameter("custPMTele");
			String mailFlag = request.getParameter("mailFlag");
			String vatFlag = request.getParameter("VATFlag");
			String contractCategory = request.getParameter("contractCategory");

			if (contact == null)
				contact = "";
			if (contactTele == null)
				contactTele = "";
			if (custPM == null)
				custPM = "";
			if (custPMTele == null)
				custPMTele = "";
			if (mailFlag == null) {
				mailFlag = "N";
			} else {
				mailFlag = "Y";
			}
			if (vatFlag == null) {
				vatFlag = "N";
			}

			if (contractCategory == null)
				contractCategory = "Labor";
			String repeatFlag = "";

			totalServiceValueStr = UtilString.removeSymbol(totalServiceValueStr, ',');
			totalLicsValueStr = UtilString.removeSymbol(totalLicsValueStr, ',');
			EXPBudgetStr = UtilString.removeSymbol(EXPBudgetStr, ',');
			PSCBudgetStr = UtilString.removeSymbol(PSCBudgetStr, ',');
			ProcBudgetStr = UtilString.removeSymbol(ProcBudgetStr, ',');
			AlownceStr = UtilString.removeSymbol(AlownceStr, ',');

			Double totalServiceValue = null;
			Double PSCBudget = null;
			Double ProcBudget = null;
			Float AlownceRate = null;
			Double EXPBudget = null;
			Double totalLicsValue = null;

			if (!(totalLicsValueStr == null || totalLicsValueStr.length() < 1)) {
				totalLicsValue = new Double(totalLicsValueStr);
			} else {
				totalLicsValue = new Double(0);
			}

			if (!(EXPBudgetStr == null || EXPBudgetStr.length() < 1)) {
				EXPBudget = new Double(EXPBudgetStr);
			} else {
				EXPBudget = new Double(0);
			}

			if (!(totalServiceValueStr == null || totalServiceValueStr.length() < 1)) {
				totalServiceValue = new Double(totalServiceValueStr);
			} else {
				totalServiceValue = new Double(0);
			}

			if (!(PSCBudgetStr == null || PSCBudgetStr.length() < 1)) {
				PSCBudget = new Double(PSCBudgetStr);
			} else {
				PSCBudget = new Double(0);
			}

			if (!(ProcBudgetStr == null || ProcBudgetStr.length() < 1)) {
				ProcBudget = new Double(ProcBudgetStr);
			} else {
				ProcBudget = new Double(0);
			}

			if (!(AlownceStr == null || AlownceStr.length() < 1)) {
				AlownceRate = new Float(AlownceStr);
			} else {
				AlownceRate = new Float(0);
			}

			if (ProjectId == null)
				ProjectId = "";
			if (ProjName == null)
				ProjName = "";
			if (ContractNo == null)
				ContractNo = "";
			if (ProjectManagerId == null)
				ProjectManagerId = "";
			if (CAFFlag == null)
				CAFFlag = "N";
			if (ParentProjectId == null)
				ParentProjectId = "";

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			if (action == null)
				action = "view";
			ProjectMaster CustProject = null;
			if (expenseNote == null)
				expenseNote = "";

			java.util.HashSet al = new HashSet();
			int length = (exTypeChk == null) ? 0 : exTypeChk.length;
			for (int j0 = 0; j0 < length; j0++) {
				ExpenseType et = (ExpenseType) hs.load(ExpenseType.class,
						new Integer(exTypeChk[j0]));
				al.add(et);
			}
			String ProjectTypeId = "P";

			if (action.equals("precreate")) {
				tx = hs.beginTransaction();
				POProfile poContract = (POProfile) hs.load(POProfile.class, new Long(contractId));

				request.setAttribute("poContract", poContract);

				Set projSet = null;
				Set tmpSet = poContract.getLinkProfile().getProjects();
				if (tmpSet != null && tmpSet.size() > 0) {
					projSet = poContract.getLinkProfile().getProjects();
				}
				request.setAttribute("projSet", projSet);

				hs.flush();
				tx.commit();
				return mapping.findForward("view");
			}

			if (action.equals("create")) {

				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				try {
					tx = hs.beginTransaction();

					CustProject = new ProjectMaster();

					if (ProjectTypeId != null) {
						ProjectCategory ProjCategory = (ProjectCategory) hs.load(
								ProjectCategory.class, ProjectTypeId);
						CustProject.setProjectCategory(ProjCategory);
					}
					if (DepartmentId != null) {
						Party Department = (Party) hs.load(Party.class, DepartmentId);
						CustProject.setDepartment(Department);
					}
					if (ProjectId.trim().equals("")) {
						ProjectService Service = new ProjectService();
						CustProject.setProjId(Service.getProjectNo(CustProject, hs));
					} else {
						CustProject.setProjId(ProjectId);
					}
					// set parent project
					if (ParentProjectId != null) {
						ProjectService ps = new ProjectService();
						ps.UpdateProjectLink(hs, CustProject, ParentProjectId);

						ProjectMaster parentProject = CustProject.getParentProject();
						CustProject.setCustomer(parentProject.getCustomer()); // set
						// parent
						// customer
						// as
						// customer
						CustProject.setBillTo(parentProject.getBillTo()); // set
						// parent
						// billTo
						// as
						// billTo
					}
					// if (CustomerId != null) {
					// com.aof.component.crm.customer.CustomerProfile
					// Customer=(com.aof.component.crm.customer.CustomerProfile)hs.load(com.aof.component.crm.customer.CustomerProfile.class,CustomerId);
					// CustProject.setCustomer(Customer);
					// }

					if (EventCategoryId != null) {
						ProjectType ProjType = (ProjectType) hs.load(ProjectType.class,
								EventCategoryId);
						CustProject.setProjectType(ProjType);
					}
					if (!ProjectManagerId.equals("")) {
						UserLogin ProjectManager = (UserLogin) hs.load(UserLogin.class,
								ProjectManagerId);
						CustProject.setProjectManager(ProjectManager);
					}
					// if (billToId != null) {
					// com.aof.component.crm.customer.CustomerProfile
					// billTo=null;
					// if (CustomerId.equals(billToId)) {
					// billTo = CustProject.getCustomer();
					// } else {
					// billTo=(com.aof.component.crm.customer.CustomerProfile)hs.load(com.aof.component.crm.customer.CustomerProfile.class,billToId);
					// }
					// CustProject.setBillTo(billTo);
					// }
					if (vendorId != null && vendorId.trim().length() != 0) {
						com.aof.component.crm.vendor.VendorProfile vendor = null;
						vendor = (com.aof.component.crm.vendor.VendorProfile) hs.load(
								com.aof.component.crm.vendor.VendorProfile.class, vendorId);
						CustProject.setVendor(vendor);
					}
					if (contractId != null && contractId.trim().length() != 0) {
						POProfile pp = (POProfile) hs.load(POProfile.class, new Long(contractId));
						CustProject.setContract(pp);
						CustProject.setContractNo(pp.getNo());
					} else {
						CustProject.setContractNo(ContractNo);
					}
					if (paId != null && paId.trim().length() != 0) {
						UserLogin pa = null;
						pa = (UserLogin) hs.load(UserLogin.class, paId);
						CustProject.setProjAssistant(pa);
					}

					// CustProject.setProjProfileType("P");
					CustProject.setProjName(ProjName);
					// CustProject.setContractNo(ContractNo);
					CustProject.setPublicFlag(PublicFlag);
					CustProject.setProjStatus(ProjectStatus);
					CustProject.settotalServiceValue(totalServiceValue);
					CustProject.setPSCBudget(PSCBudget);
					CustProject.setProcBudget(ProcBudget);
					CustProject.settotalLicsValue(totalLicsValue);
					CustProject.setEXPBudget(EXPBudget);
					CustProject.setContractType(ContractType);
					CustProject.setPaidAllowance(AlownceRate);
					CustProject.setStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
					CustProject.setEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
					CustProject.setCAFFlag(CAFFlag);
					CustProject.setExpenseNote(expenseNote);
					CustProject.setContact(contact);
					CustProject.setContactTele(contactTele);
					CustProject.setCustPM(custPM);
					CustProject.setCustPMTele(custPMTele);
					CustProject.setMailFlag(mailFlag);
					CustProject.setContractGroup(contractCategory);
					CustProject.setVAT(vatFlag);
					CustProject.setCategory("N");

					if (ProjectId != null && !ProjectId.equals("")) {
						String QryStr = " select pm from ProjectMaster as pm ";
						QryStr = QryStr + "where pm.projId = '" + ProjectId + "'";
						Query query = hs.createQuery(QryStr);
						List result = query.list();
						if (result != null && result.size() > 0) {
							repeatFlag = "yes";
							request.setAttribute("repeatName", repeatFlag);
							request.setAttribute("CustProject", CustProject);
							ProjectMaster ParentProject = (ProjectMaster) hs.load(
									ProjectMaster.class, ParentProjectId);
							CustProject.setParentProject(ParentProject);
							CustProject.setProjId(ProjectId);
							return (mapping.findForward("view"));
						}

						CustProject.setProjId(ProjectId);
					}
					CustProject.setExpenseTypes(al);
					hs.save(CustProject);

					// insert default CTC forecast
					ProjectCostToComplete ctc = null;

					Date date = new Date();
					FMonthHelper fMonthHelper = new FMonthHelper();
					FMonth fMonth = fMonthHelper.findFiscalMonthByActurlDate(hs, date);

					// insert default PSC forecast
					ctc = new ProjectCostToComplete();
					ctc.setFiscalMonth(fMonth);
					ctc.setAmount(PSCBudget.doubleValue());
					ctc.setProject(CustProject);
					ctc.setType("PSC");
					ctc.setVersionFiscalMonth(fMonth);
					hs.save(ctc);

					// insert default EXP forecast
					ctc = new ProjectCostToComplete();
					ctc.setFiscalMonth(fMonth);
					ctc.setAmount(EXPBudget.doubleValue());
					ctc.setProject(CustProject);
					ctc.setType("Expense");
					ctc.setVersionFiscalMonth(fMonth);
					hs.save(ctc);

					// insert default Proc forecast
					ctc = new ProjectCostToComplete();
					ctc.setFiscalMonth(fMonth);
					ctc.setAmount(ProcBudget.doubleValue());
					ctc.setProject(CustProject);
					ctc.setType("ExtCost");
					ctc.setVersionFiscalMonth(fMonth);
					hs.save(ctc);

					tx.commit();

					// Add a Default Serice Type for this project
					ServiceType st = new ServiceType();
					st.setProject(CustProject);
					st.setDescription("Other");
					st.setRate(new Double(0));
					st.setEstimateManDays(new Float(0));
					st.setSubContractRate(new Double(0));
					st.setEstimateAcceptanceDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
					hs.save(st);
					log.info("go to >>>>>>>>>>>>>>>>. view forward");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			if (action.equals("update")) {
				if ((ProjectId == null) || (ProjectId.length() < 1))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}

				tx = hs.beginTransaction();
				CustProject = (ProjectMaster) hs.load(ProjectMaster.class, ProjectId);

				double orgPSCBudget = CustProject.getPSCBudget().doubleValue();
				double orgEXPBudget = CustProject.getEXPBudget().doubleValue();
				double orgProcBudget = CustProject.getProcBudget().doubleValue();

				// if (CustomerId != null) {
				// com.aof.component.crm.customer.CustomerProfile
				// Customer=(com.aof.component.crm.customer.CustomerProfile)hs.load(com.aof.component.crm.customer.CustomerProfile.class,CustomerId);
				// CustProject.setCustomer(Customer);
				// }
				if (ParentProjectId != null) {
					ProjectService ps = new ProjectService();
					ps.UpdateProjectLink(hs, CustProject, ParentProjectId);

					ProjectMaster parentProject = CustProject.getParentProject();
					CustProject.setCustomer(parentProject.getCustomer()); // set
					// parent
					// customer
					// as
					// customer
					CustProject.setBillTo(parentProject.getBillTo()); // set
					// parent
					// billTo
					// as
					// billTo
				}
				if (DepartmentId != null) {
					Party Department = (Party) hs.load(Party.class, DepartmentId);
					CustProject.setDepartment(Department);
				}
				if (ProjectTypeId != null) {
					ProjectCategory ProjCategory = (ProjectCategory) hs.load(ProjectCategory.class,
							ProjectTypeId);
					CustProject.setProjectCategory(ProjCategory);
				}
				if (EventCategoryId != null) {
					ProjectType ProjType = (ProjectType) hs
							.load(ProjectType.class, EventCategoryId);
					CustProject.setProjectType(ProjType);
				}
				if (!ProjectManagerId.equals("")) {
					UserLogin ProjectManager = (UserLogin) hs.load(UserLogin.class,
							ProjectManagerId);
					CustProject.setProjectManager(ProjectManager);
				}
				// if (billToId != null) {
				// com.aof.component.crm.customer.CustomerProfile billTo=null;
				// if (CustomerId.equals(billToId)) {
				// billTo = CustProject.getCustomer();
				// } else {
				// billTo=(com.aof.component.crm.customer.CustomerProfile)hs.load(com.aof.component.crm.customer.CustomerProfile.class,billToId);
				// }
				// CustProject.setBillTo(billTo);
				// }
				if (vendorId != null && vendorId.trim().length() != 0) {
					com.aof.component.crm.vendor.VendorProfile vendor = null;
					vendor = (com.aof.component.crm.vendor.VendorProfile) hs.load(
							com.aof.component.crm.vendor.VendorProfile.class, vendorId);
					CustProject.setVendor(vendor);
				} else {
					CustProject.setVendor(null);
				}
				if (contractId != null && contractId.trim().length() != 0) {
					POProfile pp = null;
					pp = (POProfile) hs.load(POProfile.class, new Long(contractId));
					CustProject.setContract(pp);
					CustProject.setContractNo(pp.getNo());
				} else {
					CustProject.setContractNo(ContractNo);
				}
				if (paId != null && paId.trim().length() != 0) {
					UserLogin pa = null;
					pa = (UserLogin) hs.load(UserLogin.class, paId);
					CustProject.setProjAssistant(pa);
				}

				// CustProject.setProjProfileType("P");
				CustProject.setProjName(ProjName);
				// CustProject.setContractNo(ContractNo);
				CustProject.setPublicFlag(PublicFlag);
				CustProject.setProjStatus(ProjectStatus);
				CustProject.settotalServiceValue(totalServiceValue);
				CustProject.setPSCBudget(PSCBudget);
				CustProject.settotalLicsValue(totalLicsValue);
				CustProject.setEXPBudget(EXPBudget);
				CustProject.setProcBudget(ProcBudget);
				CustProject.setContractType(ContractType);
				CustProject.setPaidAllowance(AlownceRate);
				CustProject.setStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
				CustProject.setEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
				CustProject.setCAFFlag(CAFFlag);
				// ProjectService ps = new ProjectService();
				// ps.UpdateProjectLink(hs,CustProject,ParentProjectId);
				CustProject.setExpenseTypes(al);
				CustProject.setExpenseNote(expenseNote);
				CustProject.setContact(contact);
				CustProject.setContactTele(contactTele);
				CustProject.setCustPM(custPM);
				CustProject.setCustPMTele(custPMTele);
				CustProject.setMailFlag(mailFlag);
				CustProject.setVAT(vatFlag);
				CustProject.setContractGroup(contractCategory);

				hs.update(CustProject);

				// insert default CTC forecast below
				Long CurrVerFMId = getCurrVerionFMId(hs, ProjectId);
				List CustProjectCTCs = null;

				if (CustProject != null) {
					java.util.Date SDate = CustProject.getStartDate();
					java.util.Date EDate = CustProject.getEndDate();
					if (CurrVerFMId != null) {
						Query q = hs
								.createQuery("select ctc from ProjectCostToComplete as ctc inner join ctc.FiscalMonth as fm where ctc.Project.projId =:ProjectId and ctc.VersionFiscalMonth.Id =:CurrVerFMId order by ctc.Type DESC, fm.Year, fm.MonthSeq");
						q.setParameter("ProjectId", ProjectId);
						q.setParameter("CurrVerFMId", CurrVerFMId);
						CustProjectCTCs = q.list();

						if (CustProjectCTCs != null) {
							Iterator iterator = CustProjectCTCs.iterator();
							while (iterator.hasNext()) {
								ProjectCostToComplete projCTC = (ProjectCostToComplete) iterator
										.next();
								if ("PSC".equals(projCTC.getType())) {
									if (orgPSCBudget != PSCBudget.doubleValue()
											&& orgPSCBudget == projCTC.getAmount()) {
										projCTC.setAmount(PSCBudget.doubleValue());
										hs.save(projCTC);
									}
								} else if ("Expense".equals(projCTC.getType())) {
									if (orgEXPBudget != EXPBudget.doubleValue()
											&& orgEXPBudget == projCTC.getAmount()) {
										projCTC.setAmount(EXPBudget.doubleValue());
										hs.save(projCTC);
									}
								} else if ("ExtCost".equals(projCTC.getType())) {
									if (orgProcBudget != ProcBudget.doubleValue()
											&& orgProcBudget == projCTC.getAmount()) {
										projCTC.setAmount(ProcBudget.doubleValue());
										hs.save(projCTC);
									}
								}
							}
						}
					}
				}
				// insert default CTC forecast Up

				tx.commit();
				String StId[] = request.getParameterValues("StId");
				String STDescription[] = request.getParameterValues("STDescription");
				String STRate[] = request.getParameterValues("STRate");
				String SubContractRate[] = request.getParameterValues("SubContractRate");
				String EstimateManDays[] = request.getParameterValues("EstimateManDays");
				String EstimateDate[] = request.getParameterValues("EstimateDate");

				int RowSize = java.lang.reflect.Array.getLength(StId);
				ServiceType st = null;
				tx = hs.beginTransaction();
				for (int i = 0; i < RowSize; i++) {
					if (StId[i].trim().equals("")) {
						if (!STDescription[i].trim().equals("")) {
							st = new ServiceType();
							st.setProject(CustProject);
							st.setDescription(STDescription[i]);
							if (STRate != null) {
								st.setRate(new Double(UtilString.removeSymbol(STRate[i], ',')));
							} else {
								st.setRate(new Double(0));
							}
							st.setEstimateManDays(new Float(UtilString.removeSymbol(
									EstimateManDays[i], ',')));
							st.setSubContractRate(new Double(UtilString.removeSymbol(
									SubContractRate[i], ',')));
							st.setEstimateAcceptanceDate(UtilDateTime.toDate2(EstimateDate[i]
									+ " 00:00:00.000"));
							hs.save(st);
						}
					} else {
						st = (ServiceType) hs.load(ServiceType.class, new Long(StId[i]));
						if (STDescription[i].trim().equals("")) {
							hs.delete(st);
						} else {
							st.setDescription(STDescription[i]);
							if (STRate != null) {
								st.setRate(new Double(UtilString.removeSymbol(STRate[i], ',')));
							} else {
								st.setRate(new Double(0));
							}
							st.setEstimateManDays(new Float(UtilString.removeSymbol(
									EstimateManDays[i], ',')));
							st.setSubContractRate(new Double(UtilString.removeSymbol(
									SubContractRate[i], ',')));
							st.setEstimateAcceptanceDate(UtilDateTime.toDate2(EstimateDate[i]
									+ " 00:00:00.000"));
							hs.update(st);
						}
					}
				}
				tx.commit();
			}

			if (action.equals("delete")) {
				if ((ProjectId == null) || (ProjectId.length() < 1))
					actionDebug.addGlobalError(errors, "error.context.required");
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				tx = hs.beginTransaction();

				Query query = hs
						.createQuery("from ProjectCostToComplete as pctc where pctc.Project.projId = ?");
				query.setString(0, ProjectId);
				List ctcList = query.list();
				if (ctcList != null) {
					for (int i0 = 0; i0 < ctcList.size(); i0++) {
						hs.delete(ctcList.get(i0));
					}
				}

				CustProject = (ProjectMaster) hs.load(ProjectMaster.class, ProjectId);
				Iterator itSt = CustProject.getServiceTypes().iterator();
				while (itSt.hasNext()) {
					ServiceType st = (ServiceType) itSt.next();
					hs.delete(st);
				}
				hs.delete(CustProject);
				hs.flush();
				tx.commit();
				return (mapping.findForward("list"));

			}

			if (action.equals("view") || action.equals("create") || action.equals("update")
					|| action.equals("dialogView")) {
				if (!((ProjectId == null) || (ProjectId.length() < 1)))
					CustProject = (ProjectMaster) hs.load(ProjectMaster.class, ProjectId);

				List ServiceTypeList = null;
				if (CustProject != null) {
					Query q = hs
							.createQuery("select st from ServiceType as st inner join st.Project as p where p.projId =:ProjectId");
					q.setParameter("ProjectId", CustProject.getProjId());
					ServiceTypeList = q.list();
				}

				request.setAttribute("CustProject", CustProject);
				request.setAttribute("ServiceTypeList", ServiceTypeList);

				if (action.equals("dialogView")) {
					return (mapping.findForward("dialogView"));
				} else {
					return (mapping.findForward("view"));
				}
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

	private Long getCurrVerionFMId(Session session, String ProjectId) throws HibernateException {
		Long VerionFMId = null;
		String QryStr = "select max(ctc.VersionFiscalMonth.Id) from ProjectCostToComplete as ctc inner join ctc.Project as p where p.projId =:ProjectId";
		Query q = session.createQuery(QryStr);
		q.setParameter("ProjectId", ProjectId);
		Iterator itFind = q.list().iterator();
		if (itFind.hasNext()) {
			VerionFMId = (Long) itFind.next();
		}
		return VerionFMId;
	}
}