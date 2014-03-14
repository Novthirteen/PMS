/*
 * Created on 2005-4-25
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.bill;

import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.BillInstructionService;
import com.aof.component.prm.Bill.BillTransactionDetail;
import com.aof.component.prm.Bill.ProjectBill;
import com.aof.component.prm.Bill.TransacationDetail;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bill.EditDownpaymentInstructionForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditDownpaymentInstructionAction extends BaseAction {
	
	private Logger log = Logger.getLogger(EditDownpaymentInstructionAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		Transaction transaction = null; 
		
		try {
			EditDownpaymentInstructionForm ediForm = (EditDownpaymentInstructionForm)form;
			BillInstructionService billInstructionService = new BillInstructionService();
			TransactionServices transactionServices = new TransactionServices();
			
			if (ediForm.getFormAction().equals("view") 
					|| ediForm.getFormAction().equals("dialogView")) {	
				ProjectBill pb = billInstructionService.viewBillingInstruction(ediForm.getBillId());
				
				request.setAttribute("ProjectBill", pb);
				if (pb != null && pb.getProject() != null) {
					TransacationDetail td = transactionServices.getInsertedRecord("BillTransactionDetail", pb.getId().longValue(), Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
					request.setAttribute("CreidtDownpayment", td);
				}
				request.setAttribute("Currency", billInstructionService.getAllCurrency());	
				
				if (ediForm.getFormAction().equals("dialogView")) {
					return mapping.findForward("showDialog");
				}
			}
			
			if (ediForm.getFormAction().equals("new")) {
				Session session = Hibernate2Session.currentSession();
				transaction = session.beginTransaction();
				
				ProjectBill pb = convertFormToModel(billInstructionService, ediForm);
				//Currency
				CurrencyType ct = (CurrencyType)session.load(CurrencyType.class,"RMB");
				//Create User
				UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				
				pb.setStatus(Constants.BILLING_STATUS_DRAFT);
				pb.setCreateUser(ul);
				pb.setCreateDate(UtilDateTime.nowTimestamp());
				
				Long billId = (Long)session.save(pb);
				request.setAttribute("ProjectBill", pb);
				
				TransactionServices tService = new TransactionServices();
				
				BillTransactionDetail tr = 
					(BillTransactionDetail)tService.getInsertedRecord(
							"BillTransactionDetail", billId.longValue(), 
							Constants.TRANSACATION_CATEGORY_DOWN_PAYMENT);
				
				if (tr == null) {
					tr = new BillTransactionDetail();
					tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
					tr.setTransactionCreateUser(ul);
				}
				
				tr.setCurrency(ct);
				tr.setExchangeRate(new Double(1));
				tr.setProject(pb.getProject());
				tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_DOWN_PAYMENT);

				tr.setTransactionDate(UtilDateTime.nowTimestamp());
				tr.setTransactionParty(pb.getBillAddress());
				tr.setTransactionRecId(billId);
				tr.setTransactionUser(pb.getProject().getProjectManager());
				
				tr.setDesc1(pb.getBillCode());
				tr.setDesc2(pb.getNote());
				
				tr.setAmount(ediForm.getDownAmount());
				tr.setTransactionMaster(pb);
				pb.addDetail(tr);
				
				//save down payment
				session.saveOrUpdate(tr);
				//request.setAttribute("Downpayment", tr);
				
				tr = (BillTransactionDetail)tService.getInsertedRecord(
							"BillTransactionDetail", billId.longValue(), 
							Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
				
				if (ediForm.getCreditAmount().doubleValue() != 0L) {
					if (tr == null) {
						tr = new BillTransactionDetail();
						tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
						tr.setTransactionCreateUser(ul);
					}
					
					tr.setCurrency(ct);
					tr.setExchangeRate(new Double(1));
					tr.setProject(pb.getProject());
					tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
					
					tr.setTransactionDate(UtilDateTime.nowTimestamp());
					tr.setTransactionParty(pb.getBillAddress());
					tr.setTransactionRecId(billId);
					tr.setTransactionUser(pb.getProject().getProjectManager());
					
					tr.setDesc1(pb.getBillCode());
					tr.setDesc2(pb.getNote());
					
					tr.setAmount(ediForm.getCreditAmount());
					
					//save credit down payment
					session.saveOrUpdate(tr);
					request.setAttribute("CreidtDownpayment", tr);
				} else {
					if (tr != null) {
						//if credit amount is zero, delete it
						session.delete(tr);
					}
				}

				session.flush();
				transaction.commit();
				
				//for load trasaction, and invoice
				if (pb.getDetails() != null) {
					pb.getDetails().size();
				}
				if (pb.getInvoices() != null) {
					pb.getInvoices().size();
				}
			}
			
			if (ediForm.getFormAction().equals("update")) {
				Session session = Hibernate2Session.currentSession();
				transaction = session.beginTransaction();
				
				ProjectBill pb = convertFormToModel(billInstructionService, ediForm);
				session.update(pb);
				request.setAttribute("ProjectBill", pb);
				
				Set set = pb.getDetails();
				Iterator it = set.iterator();
				BillTransactionDetail td = (BillTransactionDetail)it.next();
				td.setAmount(ediForm.getDownAmount());
				session.update(td);
				
				td = (BillTransactionDetail)transactionServices.getInsertedRecord(
						"BillTransactionDetail", pb.getId().longValue(), 
						Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
				
				if (td != null) {
					if (ediForm.getCreditAmount().doubleValue() != 0L) {
						td.setAmount(ediForm.getCreditAmount());
						session.update(td);
						request.setAttribute("CreidtDownpayment", td);
					} else {
						//if credit amount is zero, delete it
						session.delete(td);
					}
				} else {
					if (ediForm.getCreditAmount().doubleValue() != 0L) {
						td = new BillTransactionDetail();
						td.setTransactionCreateDate(UtilDateTime.nowTimestamp());
						td.setTransactionCreateUser((UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY));
						
						td.setCurrency((CurrencyType)session.load(CurrencyType.class,"RMB"));
						td.setExchangeRate(new Double(1));
						td.setProject(pb.getProject());
						td.setTransactionCategory(Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
						
						td.setTransactionDate(UtilDateTime.nowTimestamp());
						td.setTransactionParty(pb.getBillAddress());
						td.setTransactionRecId(pb.getId());
						td.setTransactionUser(pb.getProject().getProjectManager());
						
						td.setDesc1(pb.getBillCode());
						td.setDesc2(pb.getNote());
						
						td.setAmount(ediForm.getCreditAmount());
						request.setAttribute("CreidtDownpayment", td);
					}
				}
				session.flush();
				transaction.commit();
				
				//for load trasaction, and invoice
				pb.getDetails().size();
				pb.getInvoices().size();
			}
			
			if (ediForm.getFormAction().equals("delete")) {
				Session session = Hibernate2Session.currentSession();
				transaction = session.beginTransaction();
				
				ProjectBill pb = billInstructionService.viewBillingInstruction(ediForm.getBillId());
				
				if (pb != null) {
					Set set = pb.getDetails();
					Iterator it = set.iterator();
					TransacationDetail td = (TransacationDetail)it.next();
					session.delete(td);
					
					td = (BillTransactionDetail)transactionServices.getInsertedRecord(
							"BillTransactionDetail", pb.getId().longValue(), 
							Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
					
					if (td != null) {
						session.delete(td);
					}
					session.delete(pb);
					session.flush();
				}
				
				transaction.commit();
				
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
	
	private ProjectBill convertFormToModel(
			BillInstructionService billInstructionService, EditDownpaymentInstructionForm ediForm) throws HibernateException {
		
		ProjectBill pb = null;
		try {
			
			Session session = Hibernate2Session.currentSession();
			
			if (ediForm.getBillId() != null && ediForm.getBillId().longValue() > 0L) {
				pb = billInstructionService.viewBillingInstruction(ediForm.getBillId());
			} else {
				pb = new ProjectBill();
				pb.setBillCode(billInstructionService.generateBillCode(ediForm.getProjId()));
			}
			
			pb.setBillType(Constants.BILLING_TYPE_DOWN_PAYMENT);
			
			pb.setCalAmount(ediForm.getDownAmount());
			
			if (ediForm.getProjId() != null && ediForm.getProjId().trim().length() != 0) {
				ProjectMaster pm = (ProjectMaster)session.load(ProjectMaster.class, ediForm.getProjId());
				pb.setProject(pm);
			}
			
			if (ediForm.getBillAddr() != null && ediForm.getBillAddr().trim().length() != 0) {
				CustomerProfile party = (CustomerProfile)session.load(CustomerProfile.class, ediForm.getBillAddr());
				pb.setBillAddress(party);
			}
			
			if (ediForm.getStatus() != null) {
				pb.setStatus(ediForm.getStatus());
			}
			
			if (ediForm.getNote() != null) {
				pb.setNote(ediForm.getNote().trim());
			}
			
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		}
		return pb;
	}
}
