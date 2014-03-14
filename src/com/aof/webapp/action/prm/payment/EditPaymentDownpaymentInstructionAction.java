/*
 * Created on 2005-6-7
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.payment;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import org.apache.struts.util.MessageResources;

import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.TransacationDetail;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.payment.PaymentInstructionService;
import com.aof.component.prm.payment.PaymentTransactionDetail;
import com.aof.component.prm.payment.ProjPaymentTransaction;
import com.aof.component.prm.payment.ProjectPayment;
import com.aof.component.prm.payment.ProjectPaymentMaster;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.prm.report.ReportBaseAction;
import com.aof.webapp.form.prm.payment.EditPaymentDownpaymentInstructionForm;
import com.aof.webapp.form.prm.payment.EditPaymentInstructionForm;

/**
 * @author gus
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditPaymentDownpaymentInstructionAction extends ReportBaseAction {

	
	private Logger log = Logger.getLogger(EditPaymentDownpaymentInstructionAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		Transaction transaction = null; 
		
		try {
			EditPaymentDownpaymentInstructionForm ediForm = (EditPaymentDownpaymentInstructionForm)form;
			PaymentInstructionService payInstructionService = new PaymentInstructionService();
			TransactionServices transactionServices = new TransactionServices();
			
			if (ediForm.getFormAction().equals("view") 
					|| ediForm.getFormAction().equals("dialogView")) {	
				ProjectPayment pp = payInstructionService.viewPaymentInstruction(ediForm.getPayId());
				request.setAttribute("ProjectPayment", pp);
				if (pp != null && pp.getProject() != null) {
					TransacationDetail td = transactionServices.getInsertedRecord("PaymentTransactionDetail", pp.getId().longValue(), Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
					request.setAttribute("CreidtDownpayment", td);
				}
				request.setAttribute("Currency", payInstructionService.getAllCurrency());	
				
				if (ediForm.getFormAction().equals("dialogView")) {
					return mapping.findForward("showDialog");
				}
			}
			
			if (ediForm.getFormAction().equals("new")) {
				Session session = Hibernate2Session.currentSession();
				transaction = session.beginTransaction();
				
				ProjectPayment pp = convertFormToModel(payInstructionService, ediForm);
				//Currency
				CurrencyType ct = (CurrencyType)session.load(CurrencyType.class,"RMB");
				//Create User
				UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				
				pp.setStatus(Constants.PAYMENT_STATUS_DRAFT);
				pp.setCreateUser(ul);
				pp.setCreateDate(UtilDateTime.nowTimestamp());
				pp.setSettledAmount(new Double(0));
				
				Long payId = (Long)session.save(pp);
				request.setAttribute("ProjectPayment", pp);
				
				TransactionServices tService = new TransactionServices();
				
				PaymentTransactionDetail tr = 
					(PaymentTransactionDetail)tService.getInsertedRecord(
							"PaymentTransactionDetail", payId.longValue(), 
							Constants.TRANSACATION_CATEGORY_DOWN_PAYMENT);
				
				if (tr == null) {
					tr = new PaymentTransactionDetail();
					tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
					tr.setTransactionCreateUser(ul);
				}
				
				tr.setCurrency(ct);
				tr.setExchangeRate(new Double(1));
				tr.setProject(pp.getProject());
				tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_DOWN_PAYMENT);

				tr.setTransactionDate(UtilDateTime.nowTimestamp());
				tr.setTransactionParty(pp.getPayAddress());
				tr.setTransactionRecId(payId);
				tr.setTransactionUser(pp.getProject().getProjectManager());
				
				tr.setDesc1(pp.getPaymentCode());
				tr.setDesc2(pp.getNote());
				
				tr.setAmount(ediForm.getDownAmount());
				tr.setTransactionMaster(pp);
				pp.addDetail(tr);
				
				//save down payment
				session.saveOrUpdate(tr);
				//request.setAttribute("Downpayment", tr);
				
				tr = (PaymentTransactionDetail)tService.getInsertedRecord(
							"PaymentTransactionDetail", payId.longValue(), 
							Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
				
				if (ediForm.getCreditAmount().doubleValue() != 0L) {
					if (tr == null) {
						tr = new PaymentTransactionDetail();
						tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
						tr.setTransactionCreateUser(ul);
					}
					
					tr.setCurrency(ct);
					tr.setExchangeRate(new Double(1));
					tr.setProject(pp.getProject());
					tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
					
					tr.setTransactionDate(UtilDateTime.nowTimestamp());
					tr.setTransactionParty(pp.getPayAddress());
					tr.setTransactionRecId(payId);
					tr.setTransactionUser(pp.getProject().getProjectManager());
					
					tr.setDesc1(pp.getPaymentCode());
					tr.setDesc2(pp.getNote());
					
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
			}
			
			if (ediForm.getFormAction().equals("update")) {
				Session session = Hibernate2Session.currentSession();
				transaction = session.beginTransaction();
				
				ProjectPayment pp = convertFormToModel(payInstructionService, ediForm);
				session.update(pp);
				request.setAttribute("ProjectPayment", pp);
				
				Set set = pp.getDetails();
				Iterator it = set.iterator();
				PaymentTransactionDetail td = (PaymentTransactionDetail)it.next();
				td.setAmount(ediForm.getDownAmount());
				session.update(td);
				
				td = (PaymentTransactionDetail)transactionServices.getInsertedRecord(
						"PaymentTransactionDetail", pp.getId().longValue(), 
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
						td = new PaymentTransactionDetail();
						td.setTransactionCreateDate(UtilDateTime.nowTimestamp());
						td.setTransactionCreateUser((UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY));
						
						td.setCurrency((CurrencyType)session.load(CurrencyType.class,"RMB"));
						td.setExchangeRate(new Double(1));
						td.setProject(pp.getProject());
						td.setTransactionCategory(Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
						
						td.setTransactionDate(UtilDateTime.nowTimestamp());
						td.setTransactionParty(pp.getPayAddress());
						td.setTransactionRecId(pp.getId());
						td.setTransactionUser(pp.getProject().getProjectManager());
						
						td.setDesc1(pp.getPaymentCode());
						td.setDesc2(pp.getNote());
						
						td.setAmount(ediForm.getCreditAmount());
						request.setAttribute("CreidtDownpayment", td);
					}
				}
				session.flush();
				transaction.commit();
			}
			
			if (ediForm.getFormAction().equals("delete")) {
				Session session = Hibernate2Session.currentSession();
				transaction = session.beginTransaction();

				ProjectPayment pp = payInstructionService.viewPaymentInstruction(ediForm.getPayId());
				
				if (pp != null) {
					Set set = pp.getDetails();
					Iterator it = set.iterator();
					TransacationDetail td = (TransacationDetail)it.next();
					session.delete(td);
					
					td = (PaymentTransactionDetail)transactionServices.getInsertedRecord(
							"PaymentTransactionDetail", pp.getId().longValue(), 
							Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
					
					if (td != null) {
						session.delete(td);
					}
					session.delete(pp);
					session.flush();
				}
				
				transaction.commit();
				
				return mapping.findForward("list");
			}
			
			//payment settlement
			if(ediForm.getFormAction().equals("removeSupplierInvoice")){
				Session session = Hibernate2Session.currentSession();
				removeSupplierInvoice(session, Long.parseLong(request.getParameter("paymentId")));
				doView(session, request, String.valueOf(ediForm.getPayId()));
			}
			
			if(ediForm.getFormAction().equals("post")){			
				Session session = Hibernate2Session.currentSession();
				String postIds[] = request.getParameterValues("chk");
				
				postPaymentSettle(session, String.valueOf(ediForm.getPayId()), postIds);
				doView(session, request, String.valueOf(ediForm.getPayId()));
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

	private void doView(Session session, HttpServletRequest request, String payId) throws HibernateException {
		if (payId != null && payId.trim().length() != 0) {
			//show edit payment instruction page
			long id = Long.parseLong(payId);
			
			String payStatement = "from ProjectPayment as pp where pp.Id = ?";
			Query query = session.createQuery(payStatement);
			query.setLong(0, id);
			
			List list = query.list();
			
			if (list != null && list.size() > 0) {
				ProjectPayment payment = (ProjectPayment)list.get(0);
				//set payment instruction in request
				request.setAttribute("ProjectPayment", payment);
				
				//set transaction detail list that can be add to payment instruction in request
				String projectId = payment.getProject().getProjId();
				TransactionServices ts = new TransactionServices();
				
				/*
				if (category.equals(Constants.TRANSACATION_CATEGORY_EXPENSE)) {
					List tranExpenseList = ts.findPaymentTransactionList(projectId, Constants.TRANSACATION_CATEGORY_EXPENSE);
					//List tranCostList = ts.findBillingTransactionList(projectId, Constants.TRANSACATION_CATEGORY_OTHER_COST);
					if (tranExpenseList == null) {
						tranExpenseList = new ArrayList();
					}
					//if (tranCostList != null) {
					//	tranExpenseList.addAll(tranCostList);
					//}
					request.setAttribute("ExpenseTransactionList", tranExpenseList);
				}
				*/
//				for load trasaction, and invoice
				if (payment.getDetails() != null) {
					payment.getDetails().size();
				}
				if (payment.getSettleRecords() != null) {
					payment.getSettleRecords().size();
				}
			}
		} else {
			//show new payment instruction display page
			//it seems we shall do not do anything here!!
		}
	}
	
	private ProjectPayment convertFormToModel(
			PaymentInstructionService payInstructionService, EditPaymentDownpaymentInstructionForm ediForm) throws HibernateException {
		
		ProjectPayment pp = null;
		try {
			
			Session session = Hibernate2Session.currentSession();
			
			if (ediForm.getPayId() != null && ediForm.getPayId().longValue() > 0L) {
				pp = payInstructionService.viewPaymentInstruction(ediForm.getPayId());
			} else {
				pp = new ProjectPayment();
				pp.setPaymentCode(payInstructionService.generatePaymentCode(ediForm.getProjId()));
			}
	
			pp.setType(Constants.PAYMENT_TYPE_DOWN_PAYMENT);
			
			pp.setCalAmount(ediForm.getDownAmount());
			
			if (ediForm.getProjId() != null && ediForm.getProjId().trim().length() != 0) {
				ProjectMaster pm = (ProjectMaster)session.load(ProjectMaster.class, ediForm.getProjId());
				pp.setProject(pm);
			}
		
			if (ediForm.getPayAddr() != null && ediForm.getPayAddr().trim().length() != 0) {
				VendorProfile vendor = (VendorProfile)session.load(VendorProfile.class, ediForm.getPayAddr());
				pp.setPayAddress(vendor);
			}
			
			if (ediForm.getStatus() != null) {
				pp.setStatus(ediForm.getStatus());
			}
			
			if (ediForm.getNote() != null) {
				pp.setNote(ediForm.getNote().trim());
			}
			
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		}
		return pp;
	}
	
	private ProjectPayment convertFormToPayment(Session session, EditPaymentInstructionForm epiForm, ProjectPayment pp) throws HibernateException {
		String projectId = epiForm.getProjId();
		String payAddrId = epiForm.getPayAddr();
		ProjectMaster project = null;
		com.aof.component.crm.vendor.VendorProfile vendor = null;
		if (projectId != null && projectId.trim().length() != 0) {
			project = (ProjectMaster)session.load(ProjectMaster.class, projectId);
		}
		if (payAddrId != null && payAddrId.trim().length() != 0) {
			vendor = (com.aof.component.crm.vendor.VendorProfile)session.load(com.aof.component.crm.vendor.VendorProfile.class, payAddrId);
		}
		
		//set payment id
		//if (epiForm.getBillId() != null && epiForm.getBillId().trim().length() != 0) {
			//Long id = new Long(epiForm.getBillId());
			//pb.setId(id);
		//}
		
		//set payment code 
		if (epiForm.getPayCode() != null && epiForm.getPayCode().trim().length() != 0) {
			pp.setPaymentCode(epiForm.getPayCode());
		} 
		
		//set payment type
		pp.setType(epiForm.getPayType());
		
		//set project
		if (project != null) {
			pp.setProject(project);
		}
		
		//set payment address
		if (vendor != null) {
			pp.setPayAddress(vendor);
		}
		
		//set status
		if (epiForm.getStatus() != null) {
			pp.setStatus(epiForm.getStatus());
		}
		
		//set note
		if (epiForm.getNote() != null) {
			pp.setNote(epiForm.getNote().trim());
		}

		return pp;
	}
	
	private Long doNew(Session session, HttpServletRequest request, EditPaymentInstructionForm epiForm) throws HibernateException {
		
		ProjectPayment pp = new ProjectPayment();
		convertFormToPayment(session, epiForm, pp);

		//set payment code 
		if (pp.getPaymentCode() == null || pp.getPaymentCode().trim().length() == 0) {
			//if user not input the payment code, system would generate one for it
			PaymentInstructionService paymentInstructionService = new PaymentInstructionService();
			pp.setPaymentCode(paymentInstructionService.generatePaymentCode(pp.getProject().getProjId()));
		}
		
		//set payment type
		pp.setType(Constants.PAYMENT_TYPE_NORMAL);
		
		//set payment status
		pp.setStatus(Constants.PAYMENT_STATUS_DRAFT);
		
		//set create date
		pp.setCreateDate(new Date());
		
		//set create user
		pp.setCreateUser((UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY));
		
		//set calculation amount
		pp.setCalAmount(new Double(0L));
		
		//set settled amount
		pp.setSettledAmount(new Double(0L));
		
		Long payId = (Long)session.save(pp);
		
		return payId;
	}
	
	private void doDelete(EditPaymentInstructionForm epiForm) throws HibernateException {
		Long payId  = new Long(epiForm.getPayId());
		PaymentInstructionService paymentInstructionService = new PaymentInstructionService(); 
		paymentInstructionService.deletePaymentInstruction(payId);
	}
	
	private void doUpdateHead(Session session, EditPaymentInstructionForm epiForm) throws HibernateException {
		Long payId = new Long(epiForm.getPayId());
		ProjectPayment pp = (ProjectPayment)session.load(ProjectPayment.class, payId);
		convertFormToPayment(session, epiForm, pp);
		session.update(pp);
	}
	
	private void doAddTransaction(Session session, EditPaymentInstructionForm epiForm) throws HibernateException {
		String[] transactionId = epiForm.getTransactionId();
		Long payId = new Long(epiForm.getPayId());
		ProjectPayment pp = (ProjectPayment)session.load(ProjectPayment.class, payId);
		
		PaymentInstructionService paymentInstructionService = new PaymentInstructionService();
		for (int i0 =0; transactionId != null && i0 < transactionId.length; i0++) {
			long id = Long.parseLong(transactionId[i0]);
			paymentInstructionService.addPaymentTransaction(pp, id);
		}

		session.update(pp);
	}
	
	private void doRemoveTransaction(Session session, EditPaymentInstructionForm epiForm) throws HibernateException {
		Long payId = new Long(epiForm.getPayId());
		String[] payDetailId = epiForm.getPayDetailId();
		ProjectPayment pp = (ProjectPayment)session.load(ProjectPayment.class, payId);

		PaymentInstructionService paymentInstructionService = new PaymentInstructionService();
		for (int i0 =0; payDetailId != null && i0 < payDetailId.length; i0++) {
			long id = Long.parseLong(payDetailId[i0]);
			paymentInstructionService.removePaymentTransaction(id);
		}

		session.update(pp);
		//reCalculatepaymentingAmount(session, payId);
	}
	
	private void doClose(Session session, EditPaymentInstructionForm epiForm) throws HibernateException {
		Long payId = new Long(epiForm.getPayId());
		ProjectPayment pp = (ProjectPayment)session.load(ProjectPayment.class, payId);
		pp.setStatus(Constants.PAYMENT_STATUS_COMPLETED);
		session.update(pp);
	}
	
	private void removeSupplierInvoice(Session session, long id) throws HibernateException{
		Long paymentId = new Long(id);
		ProjPaymentTransaction ppt = (ProjPaymentTransaction)session.load(ProjPaymentTransaction.class, paymentId);
		PaymentInstructionService paymentInstructionService = new PaymentInstructionService();
		paymentInstructionService.removePaymentSettlement(ppt);
		
	}
	
	public void postPaymentSettle(Session session, String payId, String postIds[]) throws HibernateException{
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			ProjectPayment pp = (ProjectPayment)session.load(ProjectPayment.class, new Long(Long.parseLong(payId)));
		
			if (pp != null && pp.getSettleRecords() != null) {
				Iterator iterator = pp.getSettleRecords().iterator();
				while (iterator.hasNext()) {
					ProjPaymentTransaction ppt = (ProjPaymentTransaction)iterator.next();
					for (int i0 = 0; i0 < postIds.length; i0++) {
						if (ppt.getId().toString().equalsIgnoreCase(postIds[i0])) {
							ppt.setPostStatus(Constants.POST_PAYMENT_TRANSACTION_STATUS_POST);
							ppt.setPostDate(new Date());
							session.update(ppt);
						}
					}
				}
			}
			session.flush();
		} catch (Exception e) {
			try {
				transaction.rollback();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			try {
				transaction.commit();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			}
		}
	}
}
