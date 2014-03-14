/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.component.prm.payment;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;

import com.aof.component.BaseServices;
import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.ProjectHelper;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ServiceType;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;

/**
* @author angus 
* @version 2005-05-17
*
*/
public class PaymentInstructionService extends BaseServices {
	
	private final char PAY_CODE_PERFIX = 'P';
	private Logger log = Logger.getLogger(PaymentInstructionService.class);
	
	public PaymentInstructionService(){
		super();
	}
	
	public ProjectPayment viewPaymentInstruction(Long payId) throws HibernateException {
		session = this.getSession();
		
		ProjectPayment pb = null;

		try {
			if (payId != null && payId.longValue() > 0L) {
				pb = (ProjectPayment)session.load(ProjectPayment.class, payId);
//				for load trasaction, and invoice
				if (pb.getDetails() != null) {
					pb.getDetails().size();
				}
				if (pb.getSettleRecords() != null) {
					pb.getSettleRecords().size();
				}
				//pb.getInvoices().size();
			}
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}
		
		return pb;
	}
	
	public String generatePaymentCode(String projectId) throws HibernateException {
		String payCode = null;
		int sequence = 1;
		session = this.getSession();
		
		try {
			String statement = "from ProjectPayment as pp where pp.PaymentCode like ?";
			Query query = session.createQuery(statement);
			query.setString(0, PAY_CODE_PERFIX + projectId + "%");
			List list = query.list();
			
			for (int i0 = 0; list != null && i0 < list.size(); i0++) {
				ProjectPayment pb = (ProjectPayment)list.get(i0);
				try {
					int surfix = Integer.parseInt(pb.getPaymentCode().substring(projectId.length() + 1));
					if (sequence <= surfix) {
						sequence = surfix + 1;
					}
				} catch(NumberFormatException e) {
					log.error(e.getMessage());
				}
			}
			payCode = PAY_CODE_PERFIX + projectId + leftPad(String.valueOf(sequence), 3, "0");
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}
		
		return payCode;
	}
	
	public Double calculateSettledAmount(Long payId) throws HibernateException {
		try {
			session = this.getSession();
			ProjectPayment pb = (ProjectPayment)session.load(ProjectPayment.class, payId);
			
			return calculateSettledAmount(pb);
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}
	}
	
	public Double calculateSettledAmount(ProjectPayment pb) throws HibernateException {
		if (pb == null) {
			return null;
		}
		
		double settleAmount = 0L;
		
		if (pb.getSettleRecords() != null) {
			Iterator iterator = pb.getSettleRecords().iterator();
			
			while (iterator.hasNext()) {
				ProjPaymentTransaction ppt = (ProjPaymentTransaction)iterator.next();
				if (ppt.getAmount() != null) {
					settleAmount += ppt.getAmount().doubleValue();
				}
			}
		}
		
		BigDecimal amount = new BigDecimal(settleAmount);
		amount = amount.setScale(2, BigDecimal.ROUND_HALF_UP);
		return new Double(amount.doubleValue());
	}
	
	public Double calculatePaymentAmount(Long payId) throws HibernateException {
		
		try {
			session = this.getSession();
			ProjectPayment pb = (ProjectPayment)session.load(ProjectPayment.class, payId);
			
			return calculatePaymentAmount(pb);
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}
	}
	
	public Double calculatePaymentAmount(ProjectPayment pb) throws HibernateException {
		if (pb == null) {
			return null;
		}
		
		double calAmount = 0L;
		
		if (pb.getDetails() != null) {
			Iterator iterator = pb.getDetails().iterator();
			
			while (iterator.hasNext()) {
				PaymentTransactionDetail btd = (PaymentTransactionDetail)iterator.next();
				if (btd.getAmount() != null) {
					calAmount += btd.getAmount().doubleValue()*btd.getExchangeRate().doubleValue();
				}
			}
		}
		
		BigDecimal amount = new BigDecimal(calAmount);
		amount = amount.setScale(2, BigDecimal.ROUND_HALF_UP);
		return new Double(amount.doubleValue());
	}
	
	public void deletePaymentInstruction(Long payId) throws HibernateException {
		try {
			session = this.getSession();
			ProjectPayment pb = (ProjectPayment)session.load(ProjectPayment.class, payId);
			
			if (pb != null) {
				if (pb.getDetails() != null) {
					Iterator iterator = pb.getDetails().iterator();
					
					//release transaction detail
					while (iterator.hasNext()) {
						PaymentTransactionDetail btd = (PaymentTransactionDetail)iterator.next();
						btd.setTransactionMaster(null);
						
						if (btd.getTransactionCategory().equals(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE)) {
							synServiceType(null, btd);
						}
						
						session.save(btd);
					}
				}
				
				//delete payment instruction head
				session.delete(pb);
				session.flush();
			}
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}	
	}
	
	public Long newPaymentInstruction(String projectId, UserLogin ul) throws HibernateException {
		
		Long payId = null;
		
		try {
			session = this.getSession();
			String sqlStr = "  from PaymentTransactionDetail as btd " +
					        " where btd.Project.projId = ? " +
					        "   and btd.TransactionMaster is null ";
			
			Query query = session.createQuery(sqlStr);
			query.setString(0, projectId);
			List list = query.list();
			
			if (list != null && list.size() > 0) {
				PaymentTransactionDetail btd = (PaymentTransactionDetail)list.get(0);
				ProjectPayment pb = new ProjectPayment();
				double amout = 0L;
				
				ProjectMaster project = btd.getProject();
				VendorProfile vendorProfile = btd.getProject().getVendor();
				
				//set payment code 
				pb.setPaymentCode(generatePaymentCode(project.getProjId()));
				//set project
				pb.setProject(project);
				//set payment address
				pb.setPayAddress(vendorProfile);
				//set payment type
				pb.setType(Constants.PAYMENT_TYPE_NORMAL);
				//set payment status
				pb.setStatus(Constants.PAYMENT_STATUS_DRAFT);
				//set create date
				pb.setCreateDate(new Date());
				//set create user
				pb.setCreateUser(ul);
				
				payId = (Long)session.save(pb);
				
				session.flush();
				
				if (btd.getAmount() != null) {
					amout = btd.getAmount().doubleValue()*btd.getExchangeRate().doubleValue();
				}
				
				//update transaction detail table
				btd.setTransactionMaster(pb);
				
				if (btd.getTransactionCategory().equals(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE)) {
					synServiceType(pb, btd);
				}
				
				session.update(btd);
				
				for (int i0 = 1; i0 < list.size(); i0++) {
					btd = (PaymentTransactionDetail)list.get(i0);
					btd.setTransactionMaster(pb);
					if (btd.getAmount() != null) {
						amout = amout + btd.getAmount().doubleValue()*btd.getExchangeRate().doubleValue();
					}
					
					if (btd.getTransactionCategory().equals(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE)) {
						synServiceType(pb, btd);
					}
					
					session.update(btd);
				}
				
				BigDecimal calAmount = new BigDecimal(amout);
				calAmount = calAmount.setScale(2, BigDecimal.ROUND_HALF_UP);
				pb.setCalAmount(new Double(calAmount.doubleValue()));
				pb.setSettledAmount(new Double(0));
				
				session.update(pb);
				session.flush();
			}
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}	
		
		return payId;
	}
	
	public PaymentTransactionDetail addPaymentTransaction(ProjectPayment pb, long transactionId) throws HibernateException {
		try {
			session = this.getSession();
			PaymentTransactionDetail btd = null;
			String sqlStr = "  from PaymentTransactionDetail as btd " +
					        " where btd.TransactionId = ? and btd.TransactionMaster is null ";
			
			Query query = session.createQuery(sqlStr);
			query.setLong(0, transactionId);
			List list = query.list();
			
			if (list != null && list.size() > 0) {
				btd = (PaymentTransactionDetail)list.get(0);
				
				if (btd.getTransactionCategory().equals(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE)) {
					synServiceType(pb, btd);
				}
				
				//update transaction detail table
				pb.addDetail(btd);
				btd.setTransactionMaster(pb);
				//recalculate amount
				pb.setCalAmount(calculatePaymentAmount(pb));
				
				session.update(btd);
			}
			
			session.flush();
			
			return btd;
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}	
	}
	
	public PaymentTransactionDetail removePaymentTransaction(long payDetailId) throws HibernateException {
		try {
			session = this.getSession();
			PaymentTransactionDetail btd = null;
			String sqlStr = "  from PaymentTransactionDetail as btd " +
					        " where btd.TransactionId = ? and btd.TransactionMaster is not null";
			
			Query query = session.createQuery(sqlStr);
			query.setLong(0, payDetailId);
			List list = query.list();
			
			if (list != null && list.size() > 0) {
				btd = (PaymentTransactionDetail)list.get(0);
				
				if (btd.getTransactionCategory().equals(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE)) {
					synServiceType(null, btd);
				}
				
				//update transaction detail table
				btd.getTransactionMaster().removeDetail(btd);
				//recalculate amount
				btd.getTransactionMaster().setCalAmount(calculatePaymentAmount(btd.getTransactionMaster()));
				
				btd.setTransactionMaster(null);
				
				session.update(btd);
			}
			
			session.flush();
			
			return btd;
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}	
	}
	
	public List getAllCurrency() {
		session = this.getSession();
		ProjectHelper ph = new ProjectHelper();
		try {
			return ph.getAllCurrency(session);
		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	private void synServiceType(ProjectPayment pb, PaymentTransactionDetail btd) throws HibernateException {
		
		try {
			session = this.getSession();
			
			String sqlStr = " from ServiceType as st where st.Id = ? ";
			Query query = session.createQuery(sqlStr);
			query.setLong(0, btd.getTransactionRecId().longValue());
			
			List list = query.list();
			
			if (list != null && list.size() > 0) {
				ServiceType st = (ServiceType)list.get(0);

				st.setProjPayment(pb);
				session.update(st);
			}
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}	
	}
	
	private String leftPad(String target, int length, String padString) {
		for (int i0 = target.length(); i0 < length; i0++) {
			target = padString + target;
		}
		
		return target;
	}

	//temporary , not in using
	public ProjPaymentTransaction viewProjectPaymentTransaction(Long id){
		ProjPaymentTransaction ppt = null;
		try {
			if(id != null && id.longValue() > 0){
				session = this.getSession();
				ppt = (ProjPaymentTransaction)session.load(ProjPaymentTransaction.class, id);				
				return ppt;
			}
		}catch(Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		}
		
		return ppt;
	}
	
	public ProjectPaymentMaster viewPaymentMaster(String code) throws HibernateException{
		ProjectPaymentMaster ppm = (ProjectPaymentMaster)session.load(ProjectPaymentMaster.class, code);
		return ppm;
	}
	
	public void removePaymentSettlement(ProjPaymentTransaction ppt){
		session = this.getSession();
		Transaction transaction = null;
		
		try {
			transaction = session.beginTransaction();
			PaymentMasterService service = new PaymentMasterService();
			
			ProjectPayment pp = ppt.getPayment();
			pp.removeSettleRecord(ppt);
			
			pp.setSettledAmount(calculateSettledAmount(pp));
			reSetPaymentInstructionStatus(pp);
			
			ProjectPaymentMaster ppm = ppt.getInvoice();
			ppm.getSettleRecords().remove(ppt);
			
			service.resetInvoiceSettleStatus(ppm);
			
			session.update(pp);
			session.update(ppm);
			session.delete(ppt);
			
			session.flush();
		} catch (Exception e) {
			try {
				// TODO Auto-generated catch block
				transaction.rollback();
			} catch (HibernateException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			try {
				transaction.commit();
			} catch (HibernateException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}
	
	public void addPaymentSettlement(ProjectPayment pp, ProjPaymentTransaction ppt){
		session = this.getSession();
		Transaction transaction = null;
		
		try {
			transaction = session.beginTransaction();
			session.save(ppt);
			
			//ProjectPayment pp = ppt.getPayment();
			if(pp != null){
				ProjectPaymentMaster ppm = ppt.getInvoice();
				pp.addSettleRecord(ppt);
				ppm.getSettleRecords().add(ppt);
				
				pp.setSettledAmount(calculateSettledAmount(pp));
				reSetPaymentInstructionStatus(pp);
				
				PaymentMasterService service = new PaymentMasterService();
				service.resetInvoiceSettleStatus(ppm);
				
				session.update(pp);
				session.update(ppm);
			}
			
//			ProjectPaymentMaster ppm =  ppt.getInvoice();
//			
//			if(ppm != null){
//				ppm.getSettleRecords().add(ppt);
//				double remainAmount = ppm.setS();
//				double totalAmount = ppm.getPayAmount()*ppm.getExchangeRate().floatValue();
//				if(remainAmount == 0.0 ){
//					ppm.setPayStatus(Constants.PAYMENT_STATUS_COMPLETED);
//				}else if(remainAmount > 0.0 && remainAmount < totalAmount ){
//					ppm.setPayStatus(Constants.PAYMENT_STATUS_WIP);
//				}
//					
//				session.saveOrUpdate(ppm);
//			}
			session.flush();
		} catch (Exception e) {
			try {
				// TODO Auto-generated catch block
				transaction.rollback();
			} catch (HibernateException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			try {
				transaction.commit();
			} catch (HibernateException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}
	
	public void updatePaymentSettlement(ProjPaymentTransaction ppt, String settleAmt, String note){
		session = this.getSession();
		Transaction transaction = null;
		
		try {
			transaction = session.beginTransaction();
			
			ppt.setAmount(new Double(Double.parseDouble(settleAmt)));
			ppt.setNote(note);
			
			ProjectPayment pp = ppt.getPayment();
			pp.setSettledAmount(calculateSettledAmount(pp));
			reSetPaymentInstructionStatus(pp);
			
			ProjectPaymentMaster ppm = ppt.getInvoice();
			PaymentMasterService service = new PaymentMasterService();
			service.resetInvoiceSettleStatus(ppm);
			
			session.update(pp);
			session.update(ppm);
			session.update(ppt);
			session.flush();
			
		} catch (Exception e) {
			try {
				// TODO Auto-generated catch block
				transaction.rollback();
			} catch (HibernateException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			try {
				transaction.commit();
			} catch (HibernateException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}
	
	public void reSetPaymentInstructionStatus(ProjectPayment pp) {
		if(Math.abs(pp.getCalAmount().doubleValue()-pp.getSettledAmount().doubleValue()) < 1){
			pp.setStatus(Constants.PAYMENT_STATUS_COMPLETED);
		} else if (Math.abs(pp.getSettledAmount().doubleValue()) < 1){
			pp.setStatus(Constants.PAYMENT_STATUS_DRAFT);
		} else {
			pp.setStatus(Constants.PAYMENT_STATUS_WIP);
		}
	}
	
	public void getPaymentInstructionList(HttpServletRequest request, Long id)
	throws Exception{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		List result = hs.find("from ProjectPayment pp where pp.Id="+id.longValue());
		request.setAttribute("InstructionList", result.get(0));
	}
}
