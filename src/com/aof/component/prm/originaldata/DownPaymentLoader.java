/*
 * Created on 2005-4-29
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.originaldata;

import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;

import com.aof.component.prm.Bill.BillInstructionService;
import com.aof.component.prm.Bill.BillTransactionDetail;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.project.CurrencyType;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class DownPaymentLoader {
	private Logger log = Logger.getLogger(DownPaymentLoader.class);
	
	public void createDownPayment(Session session, CAF caf) throws HibernateException {
		log.info("load CAF ID = [" + caf.getId() + "]...");
		try {
			//Currency
			CurrencyType ct = (CurrencyType)session.load(CurrencyType.class,"RMB");
			
			TransactionServices tService = new TransactionServices();
			
			BillTransactionDetail tr = 
				(BillTransactionDetail)tService.getInsertedRecord(
						"BillTransactionDetail", caf.getBilling().getId().longValue(), 
						Constants.TRANSACATION_CATEGORY_DOWN_PAYMENT);
			
			if (tr == null) {
				tr = new BillTransactionDetail();
				tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
				tr.setTransactionCreateUser(caf.getCreateUser());
			}
			
			tr.setCurrency(ct);
			tr.setExchangeRate(new Double(1));
			tr.setProject(caf.getProject());
			tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_DOWN_PAYMENT);

			tr.setTransactionDate(caf.getCafDate());
			tr.setTransactionParty(caf.getProject().getBillTo());
			tr.setTransactionRecId(caf.getBilling().getId());
			tr.setTransactionUser(caf.getProject().getProjectManager());
			
			tr.setDesc1(caf.getBilling().getBillCode());
			tr.setDesc2("");
			
			tr.setAmount(new Double(caf.getWorkingHours().floatValue() / 8 * caf.getRate().doubleValue()));
			tr.setTransactionMaster(caf.getBilling());
			
			session.saveOrUpdate(tr);
			
			//recalculate amount
			if (caf.getBilling() != null) {
				BillInstructionService biService = new BillInstructionService();
				caf.getBilling().addDetail(tr);
				caf.getBilling().setCalAmount(biService.calculateBillingAmount(caf.getBilling().getId()));
				session.update(caf.getBilling());
			}
			
			//find CreditDownPayment
			BillTransactionDetail creditDownPayment = 
				(BillTransactionDetail)getCreditDownPayment(session, caf.getProject().getProjId());
			
			if (creditDownPayment != null) {
				creditDownPayment.setTransactionRecId(tr.getTransactionMaster().getId());
				session.update(creditDownPayment);
			}
		} catch (HibernateException e) {
			log.error("insert into trasaction table failure, CAF ID = [" + caf.getId() + "]...");
			throw e;
		}
	}
	
	public void createCreditDownPayment(Session session, CAF caf) throws HibernateException {
		
		log.info("load CAF ID = [" + caf.getId() + "]...");
		
		try {
			//Currency
			CurrencyType ct = (CurrencyType)session.load(CurrencyType.class,"RMB");
			
			TransactionServices tService = new TransactionServices();
			
			BillTransactionDetail tr = 
				(BillTransactionDetail)tService.getInsertedRecord(
						"BillTransactionDetail", caf.getBilling().getId().longValue(), 
						Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
			
			if (tr == null) {
				tr = new BillTransactionDetail();
				tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
				tr.setTransactionCreateUser(caf.getCreateUser());
			}
			
			tr.setCurrency(ct);
			tr.setExchangeRate(new Double(1));
			tr.setProject(caf.getProject());
			tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);

			tr.setTransactionDate(caf.getCafDate());
			tr.setTransactionParty(caf.getProject().getBillTo());
			//tr.setTransactionRecId(caf.getBilling().getId());
			tr.setTransactionUser(caf.getProject().getProjectManager());
			
			tr.setDesc1(caf.getBilling().getBillCode());
			tr.setDesc2("");
			
			tr.setAmount(new Double(caf.getWorkingHours().floatValue() / 8 * caf.getRate().doubleValue()));
			tr.setTransactionMaster(caf.getBilling());
			
			session.saveOrUpdate(tr);
			
			//recalculate amount
			if (caf.getBilling() != null) {
				BillInstructionService biService = new BillInstructionService();
				caf.getBilling().addDetail(tr);
				caf.getBilling().setCalAmount(biService.calculateBillingAmount(caf.getBilling().getId()));
				session.update(caf.getBilling());
			}
			
			//find DownPayment
			BillTransactionDetail downPayment = 
				(BillTransactionDetail)getDownPayment(session, caf.getProject().getProjId());
			if (downPayment != null) {
				tr.setTransactionRecId(downPayment.getTransactionMaster().getId());
				session.update(tr);
			}
			
		} catch (HibernateException e) {
			log.error("insert into trasaction table failure, CAF ID = [" + caf.getId() + "]...");
			throw e;
		}
	}
	
	public BillTransactionDetail getDownPayment(Session session, String projectId) throws HibernateException {
		
		String sqlStr = "from BillTransactionDetail as btd " +
				" where btd.TransactionCategory = ? " +
				"   and btd.Project.projId = ? ";
		
		Query query = session.createQuery(sqlStr);
		query.setString(0, Constants.TRANSACATION_CATEGORY_DOWN_PAYMENT);
		query.setString(1, projectId);
		List list = query.list();
		
		if (list != null && list.size() > 0) {
			return (BillTransactionDetail)list.get(0);
		}
		
		return null;
	}
	
	public BillTransactionDetail getCreditDownPayment(Session session, String projectId) throws HibernateException {
		
		String sqlStr = "from BillTransactionDetail as btd " +
				" where btd.TransactionCategory = ? " +
				"   and btd.Project.projId = ? ";
		
		Query query = session.createQuery(sqlStr);
		query.setString(0, Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
		query.setString(1, projectId);
		List list = query.list();
		
		if (list != null && list.size() > 0) {
			return (BillTransactionDetail)list.get(0);
		}
		
		return null;
	}
}
