/*
 * Created on 2005-4-29
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.originaldata;

import org.apache.log4j.Logger;

import com.aof.component.prm.Bill.BillInstructionService;
import com.aof.component.prm.Bill.BillTransactionDetail;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.project.ServiceType;
import com.aof.util.Constants;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ServiceTypeLoader {
	
	private Logger log = Logger.getLogger(ServiceTypeLoader.class);
	
	public void addToBillInstruction(Session session, CAF caf) throws HibernateException {
		log.info("load CAF ID = [" + caf.getId() + "]...");
		try {
			TransactionServices tService = new TransactionServices();
			
			caf.getServiceType().setCustAcceptanceDate(caf.getCafDate());
			session.update(caf.getServiceType());
			tService.insert(caf.getServiceType(), caf.getCreateUser());
			
			if (caf.getBilling() != null) {
				BillTransactionDetail btd = (BillTransactionDetail)tService.getInsertedRecord(
						"BillTransactionDetail", caf.getServiceType().getId().longValue(), 
						Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE);
				
				btd.setTransactionMaster(caf.getBilling());
				
				session.update(btd);
				
				//recalculate amount
				if (caf.getBilling() != null) {
					BillInstructionService biService = new BillInstructionService();
					caf.getBilling().addDetail(btd);
					caf.getBilling().setCalAmount(biService.calculateBillingAmount(caf.getBilling().getId()));
					session.update(caf.getBilling());
				}
			}
		} catch (Exception e) {
			log.error("insert into trasaction table failure, CAF ID = [" + caf.getId() + "]...");
			e.printStackTrace();
			throw new HibernateException("insert into trasaction table failure");
		}
	}
	
	public ServiceType getServiceType(Session session, CAF caf) {
		return caf.getServiceType();
	}
}
