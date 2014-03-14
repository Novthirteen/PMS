/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.bill;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.BillInstructionService;
import com.aof.component.prm.Bill.BillTransactionDetail;
import com.aof.component.prm.Bill.ProjectBill;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bill.EditBillingInstructionForm;

/**
 * @author Jackey Ding 
 * @version 2005-03-17
 *
 */
public class EditBillingInstructionAction extends BaseAction {
	
	private Logger log = Logger.getLogger(EditBillingInstructionAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		Transaction transaction = null; 
		
		try {
			EditBillingInstructionForm ebiForm = (EditBillingInstructionForm)form;
			
			String action = ebiForm.getAction();
			if (request.getAttribute("action") != null) {
				action = (String)request.getAttribute("action");
			} 
			String category = ebiForm.getCategory();
			if (category == null || category.trim().length() == 0) {
				category = Constants.TRANSACATION_CATEGORY_CAF;
				ebiForm.setCategory(category);
			}
			Session session = Hibernate2Session.currentSession();
			transaction = session.beginTransaction();

			if (action.equals("view")) {
				String billId = ebiForm.getBillId();
				if (request.getAttribute("billId") != null) {
					billId = (String)request.getAttribute("billId");
				}
				doView(session, request, billId, category);
			}
			
			if (action.equals("dialogView")) {
				String billId = request.getParameter("billId");
				doView(session, request, billId, category);
				return mapping.findForward("dialogView");
			}
			
			if (action.equals("new")) {
				Long billId = doNew(session, request, ebiForm);
				//return refreshPage(mapping, request, String.valueOf(billId));
				doView(session, request, String.valueOf(billId), category);
			}
			
			if (action.equals("delete")) {
				doDelete(ebiForm);
				return mapping.findForward("list");
			}
			
			if (action.equals("updateHead")) {
				doUpdateHead(session, ebiForm);
				//return refreshPage(mapping, request, ebiForm.getBillId());
				doView(session, request, ebiForm.getBillId(), category);
			}
			
			if (action.equals("add")) {
				doAdd(session, ebiForm);
				//return refreshPage(mapping, request, ebiForm.getBillId());
				doView(session, request, ebiForm.getBillId(), category);
			}
			
			if (action.equals("remove")) {
				doRemove(session, ebiForm);
				//return refreshPage(mapping, request, ebiForm.getBillId());
				doView(session, request, ebiForm.getBillId(), category);
			}			
			
			if (action.equals("close")) {
				doClose(session, ebiForm);
				return mapping.findForward("list");
			}
		} catch (Exception e) {
			try {
				if (transaction != null) {
					transaction.rollback();
				}
			} catch (HibernateException e1) {
				// TODO Auto-generated catch block
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (transaction != null) {
					transaction.commit();
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
	
	private void doView(Session session, HttpServletRequest request, String billId, String category) throws HibernateException {
		if (billId != null && billId.trim().length() != 0) {
			//show edit billing instruction page
			long id = Long.parseLong(billId);
			
			String billStatement = "from ProjectBill as pb where pb.Id = ?";
			Query query = session.createQuery(billStatement);
			query.setLong(0, id);
			
			List list = query.list();
			
			if (list != null && list.size() > 0) {
				ProjectBill bill = (ProjectBill)list.get(0);
				//set billing instruction in request
				request.setAttribute("ProjectBill", bill);
				
				//set transaction detail list that can be add to billing instruction in request
				String projectId = bill.getProject().getProjId();
				TransactionServices ts = new TransactionServices();
				if (category.equals(Constants.TRANSACATION_CATEGORY_EXPENSE)) {
					List tranExpenseList = ts.findBillingTransactionList(projectId, Constants.TRANSACATION_CATEGORY_EXPENSE);
					List tranCostList = ts.findBillingTransactionList(projectId, Constants.TRANSACATION_CATEGORY_OTHER_COST);
					if (tranExpenseList == null) {
						tranExpenseList = new ArrayList();
					}
					if (tranCostList != null) {
						tranExpenseList.addAll(tranCostList);
					}
					request.setAttribute("ExpenseTransactionList", tranExpenseList);
				}
				
				if (category.equals(Constants.TRANSACATION_CATEGORY_CAF)) {
					List tranCAFList = ts.findBillingTransactionList(projectId, Constants.TRANSACATION_CATEGORY_CAF);
					request.setAttribute("CAFTransactionList", tranCAFList);
				}
				
				if (category.equals(Constants.TRANSACATION_CATEGORY_ALLOWANCE)) {
					List tranAllowanceList = ts.findBillingTransactionList(projectId, Constants.TRANSACATION_CATEGORY_ALLOWANCE);
					request.setAttribute("AllowanceTransactionList", tranAllowanceList);
				}
				
				List tranBillList = null;
				if (category.equals(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE) && bill.getProject().getContractType().equals("FP")) {
					//if the project's contract type is "FP" then the project have billing acceptance
					tranBillList = ts.findBillingTransactionList(projectId, Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE);
					request.setAttribute("BillingTransactionList", tranBillList);
				}
				
				if (category.equals(Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT)) {
					List tranCreditList = ts.findBillingTransactionList(projectId, Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
					request.setAttribute("CreditDownPaymentList", tranCreditList);
				}
				
				//for load trasaction, and invoice
				if (bill.getDetails() != null) {
					bill.getDetails().size();
				}
				if (bill.getInvoices() != null) {
					bill.getInvoices().size();
				}
			}
		} else {
			//show new billing instruction display page
			//it seems we shall do not do anything here!!
		}
	}
	
	private ProjectBill convertFormToBill(Session session, EditBillingInstructionForm ebiForm, ProjectBill pb) throws HibernateException {
		String projectId = ebiForm.getProjId();
		String billAddrId = ebiForm.getBillAddr();
		ProjectMaster project = null;
		com.aof.component.crm.customer.CustomerProfile party = null;
		if (projectId != null && projectId.trim().length() != 0) {
			project = (ProjectMaster)session.load(ProjectMaster.class, projectId);
		}
		if (billAddrId != null && billAddrId.trim().length() != 0) {
			party = (com.aof.component.crm.customer.CustomerProfile)session.load(com.aof.component.crm.customer.CustomerProfile.class, billAddrId);
		}
		
		//set bill id
		//if (ebiForm.getBillId() != null && ebiForm.getBillId().trim().length() != 0) {
			//Long id = new Long(ebiForm.getBillId());
			//pb.setId(id);
		//}
		
		//set bill code 
		if (ebiForm.getBillCode() != null && ebiForm.getBillCode().trim().length() != 0) {
			pb.setBillCode(ebiForm.getBillCode());
		} 
		
		//set bill type
		pb.setBillType(Constants.BILLING_TYPE_NORMAL);
		
		
		//set bill calculate amount
		//if (ebiForm.getBillId() != null) {
			//Long id = new Long(ebiForm.getBillId());
			//BillInstructionService billInstructionService = new BillInstructionService();
			//pb.setCalAmount(billInstructionService.calculateBillingAmount(id));
		//}
		
		//set bill amount
		//double amount = 0L;
		//if (ebiForm.getAmount() != null) {
			//try {
				//amount = Double.parseDouble(ebiForm.getAmount());
			//} catch(NumberFormatException e) {
				//log.error(e.getMessage());
			//}
		//}
		//pb.setAmount(new Double(amount));
		
		//set project
		if (project != null) {
			pb.setProject(project);
		}
		
		//set bill address
		if (party != null) {
			pb.setBillAddress(party);
		}
		
		//set status
		if (ebiForm.getStatus() != null) {
			pb.setStatus(ebiForm.getStatus());
		}
		
		//set note
		if (ebiForm.getNote() != null) {
			pb.setNote(ebiForm.getNote().trim());
		}
		
		return pb;
	}
	
	private Long doNew(Session session, HttpServletRequest request, EditBillingInstructionForm ebiForm) throws HibernateException {
		
		ProjectBill pb = new ProjectBill();
		convertFormToBill(session, ebiForm, pb);
		
		//set bill code 
		if (pb.getBillCode() == null || pb.getBillCode().trim().length() == 0) {
			//if user not input the bill code, system would generate one for it
			BillInstructionService billInstructionService = new BillInstructionService();
			pb.setBillCode(billInstructionService.generateBillCode(pb.getProject().getProjId()));
		}
		
		//set bill type
		pb.setBillType(Constants.BILLING_TYPE_NORMAL);
		
		//set bill status
		pb.setStatus(Constants.BILLING_STATUS_DRAFT);
		
		//set create date
		pb.setCreateDate(new Date());
		
		//set create user
		pb.setCreateUser((UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY));
		
		//set calculation amount
		pb.setCalAmount(new Double(0L));
		
		Long billId = (Long)session.save(pb);
		
		return billId;
	}
	
	private void doDelete(EditBillingInstructionForm ebiForm) throws HibernateException {
		Long billId  = new Long(ebiForm.getBillId());
		BillInstructionService billInstructionService = new BillInstructionService(); 
		billInstructionService.deleteBillingInstruction(billId);
	}
	
	private void doUpdateHead(Session session, EditBillingInstructionForm ebiForm) throws HibernateException {
		Long billId = new Long(ebiForm.getBillId());
		ProjectBill pb = (ProjectBill)session.load(ProjectBill.class, billId);
		convertFormToBill(session, ebiForm, pb);
		session.update(pb);
	}
	
	private void doAdd(Session session, EditBillingInstructionForm ebiForm) throws HibernateException {
		String[] transactionId = ebiForm.getTransactionId();
		Long billId = new Long(ebiForm.getBillId());
		ProjectBill pb = (ProjectBill)session.load(ProjectBill.class, billId);
		
		BillInstructionService billInstructionService = new BillInstructionService();
		for (int i0 =0; transactionId != null && i0 < transactionId.length; i0++) {
			long id = Long.parseLong(transactionId[i0]);
			BillTransactionDetail btd = billInstructionService.addBillingInstruction(pb, id);
		}

		session.update(pb);
	}
	
	private void doRemove(Session session, EditBillingInstructionForm ebiForm) throws HibernateException {
		Long billId = new Long(ebiForm.getBillId());
		String[] billDetailId = ebiForm.getBillDetailId();
		ProjectBill pb = (ProjectBill)session.load(ProjectBill.class, billId);

		BillInstructionService billInstructionService = new BillInstructionService();
		for (int i0 =0; billDetailId != null && i0 < billDetailId.length; i0++) {
			long id = Long.parseLong(billDetailId[i0]);
			BillTransactionDetail btd = billInstructionService.removeBillingInstruction(id);
		}

		session.update(pb);
		//reCalculateBillingAmount(session, billId);
	}
	
	private void doClose(Session session, EditBillingInstructionForm ebiForm) throws HibernateException {
		Long billId = new Long(ebiForm.getBillId());
		ProjectBill pb = (ProjectBill)session.load(ProjectBill.class, billId);
		pb.setStatus(Constants.BILLING_STATUS_COMPLETED);
		session.update(pb);
	}
	
	/*
	private void reCalculateBillingAmount(Session session, Long billId) throws HibernateException {
		BillInstructionService billInstructionService = new BillInstructionService();
		ProjectBill pb = (ProjectBill)session.load(ProjectBill.class, billId);
		pb.setCalAmount(billInstructionService.calculateBillingAmount(billId));
		session.save(pb);
	}
	
	private ActionForward refreshPage(ActionMapping mapping, HttpServletRequest request, String billId) {
		request.setAttribute("action", "view");
		request.setAttribute("billId", billId);
		return mapping.findForward("refresh");
	}
	*/
}
