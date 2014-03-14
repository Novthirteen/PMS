/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.Bill;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

import org.apache.log4j.Logger;

import com.aof.component.BaseServices;
import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.ProjectHelper;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ServiceType;
import com.aof.util.Constants;

/**
 * @author Jackey Ding 
 * @version 2005-03-17
 *
 */
public class BillInstructionService extends BaseServices {
	
	private final char BILL_CODE_PERFIX = 'B';
	private Logger log = Logger.getLogger(BillInstructionService.class);
	
	public BillInstructionService(){
		super();
	}
	
	public ProjectBill viewBillingInstruction(Long billId) throws HibernateException {
		session = this.getSession();
		
		ProjectBill pb = null;
		
		try {
			if (billId != null && billId.longValue() > 0L) {
				pb = (ProjectBill)session.load(ProjectBill.class, billId);
				
				//for load trasaction, and invoice
				pb.getDetails().size();
				pb.getInvoices().size();
			}
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}
		
		return pb;
	}
	
	public String generateBillCode(String projectId) throws HibernateException {
		String billCode = null;
		int sequence = 1;
		session = this.getSession();
		
		try {
			String statement = "from ProjectBill as pb where pb.BillCode like ?";
			Query query = session.createQuery(statement);
			query.setString(0, BILL_CODE_PERFIX + projectId + "%");
			List list = query.list();
			
			for (int i0 = 0; list != null && i0 < list.size(); i0++) {
				ProjectBill pb = (ProjectBill)list.get(i0);
				try {
					int surfix = Integer.parseInt(pb.getBillCode().substring(projectId.length() + 1));
					if (sequence <= surfix) {
						sequence = surfix + 1;
					}
				} catch(NumberFormatException e) {
					log.error(e.getMessage());
				}
			}
			billCode = BILL_CODE_PERFIX + projectId + leftPad(String.valueOf(sequence), 3, "0");
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}
		
		return billCode;
	}
	
	public Double calculateBillingAmount(Long billId) throws HibernateException {
		
		try {
			session = this.getSession();
			ProjectBill pb = (ProjectBill)session.load(ProjectBill.class, billId);
			
			if (pb == null) {
				return null;
			}
			
			double calAmount = 0L;
			
			if (pb.getDetails() != null) {
				Iterator iterator = pb.getDetails().iterator();
				
				while (iterator.hasNext()) {
					BillTransactionDetail btd = (BillTransactionDetail)iterator.next();
					if (btd.getAmount() != null) {
						calAmount += btd.getAmount().doubleValue()*btd.getExchangeRate().doubleValue();
					}
				}
			}
			
			BigDecimal amount = new BigDecimal(calAmount);
			amount = amount.setScale(2, BigDecimal.ROUND_HALF_UP);
			return new Double(amount.doubleValue());
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}
	}
	
	public void deleteBillingInstruction(Long billId) throws HibernateException {
		try {
			session = this.getSession();
			ProjectBill pb = (ProjectBill)session.load(ProjectBill.class, billId);
			
			if (pb != null) {
				if (pb.getDetails() != null) {
					Iterator iterator = pb.getDetails().iterator();
					
					//release transaction detail
					while (iterator.hasNext()) {
						BillTransactionDetail btd = (BillTransactionDetail)iterator.next();
						btd.setTransactionMaster(null);
						
						if (btd.getTransactionCategory().equals(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE)) {
							synServiceType(null, btd);
						}
						
						session.save(btd);
					}
				}
				
				//delete bill instruction head
				session.delete(pb);
				session.flush();
			}
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}	
	}
	
	public Long newBillingInstruction(String projectId, UserLogin ul) throws HibernateException {
		
		Long billId = null;
		
		try {
			session = this.getSession();
			
			TransactionServices tService = new TransactionServices();
			List list = tService.findBillingTransactionList(projectId, null);
			
			if (list != null && list.size() > 0) {
				BillTransactionDetail btd = (BillTransactionDetail)list.get(0);
				ProjectBill pb = new ProjectBill();
				double amout = 0L;
				
				ProjectMaster project = (ProjectMaster)session.load(ProjectMaster.class, projectId);
				CustomerProfile customerProfile = project.getCustomer();
				
				//set bill code 
				pb.setBillCode(generateBillCode(projectId));
				//set project
				pb.setProject(project);
				//set bill address
				pb.setBillAddress(customerProfile);
				//set bill type
				pb.setBillType(Constants.BILLING_TYPE_NORMAL);
				//set bill status
				pb.setStatus(Constants.BILLING_STATUS_DRAFT);
				//set create date
				pb.setCreateDate(new Date());
				//set create user
				pb.setCreateUser(ul);
				
				billId = (Long)session.save(pb);
				session.flush();
				
				if (btd.getAmount() != null) {
					amout = btd.getAmount().doubleValue()*btd.getExchangeRate().doubleValue();
				}
				
				//update transaction detail table
				btd.setTransactionMaster(pb);
				
				if (btd.getTransactionCategory().equals(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE)) {
					synServiceType(pb, btd);
				}
				
				session.update(btd);
				
				for (int i0 = 1; i0 < list.size(); i0++) {
					btd = (BillTransactionDetail)list.get(i0);
					btd.setTransactionMaster(pb);
					if (btd.getAmount() != null) {
						amout = amout + btd.getAmount().doubleValue()*btd.getExchangeRate().doubleValue();
					}
					
					if (btd.getTransactionCategory().equals(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE)) {
						synServiceType(pb, btd);
					}
					
					session.update(btd);
				}
				
				BigDecimal calAmount = new BigDecimal(amout);
				calAmount = calAmount.setScale(2, BigDecimal.ROUND_HALF_UP);
				pb.setCalAmount(new Double(calAmount.doubleValue()));
				//pb.setAmount(new Double(amout));
				
				session.update(pb);
				session.flush();
			}
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}	
		
		return billId;
	}
	
	public BillTransactionDetail addBillingInstruction(ProjectBill pb, long transactionId) throws HibernateException {
		try {
			session = this.getSession();
			BillTransactionDetail btd = null;
			String sqlStr = "  from BillTransactionDetail as btd " +
					        " where btd.TransactionId = ? and btd.TransactionMaster is null ";
			
			Query query = session.createQuery(sqlStr);
			query.setLong(0, transactionId);
			List list = query.list();
			
			if (list != null && list.size() > 0) {
				btd = (BillTransactionDetail)list.get(0);
				
				if (btd.getTransactionCategory().equals(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE)) {
					synServiceType(pb, btd);
				}
				
				//update transaction detail table
				pb.addDetail(btd);
				btd.setTransactionMaster(pb);
				//recalculate amount
				pb.setCalAmount(calculateBillingAmount(pb.getId()));
				
				session.update(btd);
			}
			
			session.flush();
			
			return btd;
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}	
	}
	
	public BillTransactionDetail removeBillingInstruction(long billDetailId) throws HibernateException {
		try {
			session = this.getSession();
			BillTransactionDetail btd = null;
			String sqlStr = "  from BillTransactionDetail as btd " +
					        " where btd.TransactionId = ? and btd.TransactionMaster is not null";
			
			Query query = session.createQuery(sqlStr);
			query.setLong(0, billDetailId);
			List list = query.list();
			
			if (list != null && list.size() > 0) {
				btd = (BillTransactionDetail)list.get(0);
				
				if (btd.getTransactionCategory().equals(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE)) {
					synServiceType(null, btd);
				}
				
				//update transaction detail table
				btd.getTransactionMaster().removeDetail(btd);
				//recalculate amount
				btd.getTransactionMaster().setCalAmount(calculateBillingAmount(btd.getTransactionMaster().getId()));
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
	
	private void synServiceType(ProjectBill pb, BillTransactionDetail btd) throws HibernateException {
		if(btd.getProject().getContractGroup().equalsIgnoreCase("Material")){
			return;
		}else{
		try {
			session = this.getSession();
			
			String sqlStr = " from ServiceType as st where st.Id = ? ";
			Query query = session.createQuery(sqlStr);
			query.setLong(0, btd.getTransactionRecId().longValue());
			
			List list = query.list();
			
			if (list != null && list.size() > 0) {
				ServiceType st = (ServiceType)list.get(0);

				st.setProjBill(pb);
				session.update(st);
			}
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}	
		}
	}
	
	private String leftPad(String target, int length, String padString) {
		for (int i0 = target.length(); i0 < length; i0++) {
			target = padString + target;
		}
		
		return target;
	}
}
