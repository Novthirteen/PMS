/*
 * Created on 2005-4-28
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.originaldata;

import java.util.ArrayList;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;

import com.aof.component.prm.Bill.BillInstructionService;
import com.aof.component.prm.Bill.ProjectBill;
import com.aof.util.Constants;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class BillingLoader {
	
	private Logger log = Logger.getLogger(BillingLoader.class);
	
	public List loadBilling(Session session) throws HibernateException {
		log.info("start load billing...");
		List projectBillList = new ArrayList();
		
		try {
			String sqlStr = "from Billing";
			Query query = session.createQuery(sqlStr);
			List list = query.list();
			BillInstructionService service = new BillInstructionService();
			
			int count = 0;
			for (int i0 = 0; i0 < list.size(); i0++) {
				Billing billing = (Billing)list.get(i0);
				
				if (billing.getBilling() == null) {
					ProjectBill pb = new ProjectBill();
					
					pb.setBillCode(service.generateBillCode(billing.getProject().getProjId()));
					pb.setBillType(Constants.BILLING_TYPE_NORMAL);
					pb.setProject(billing.getProject());
					pb.setBillAddress(billing.getBillAddress());
					pb.setCreateDate(billing.getBillDate());
					pb.setCreateUser(billing.getCreateUser());
					pb.setStatus(Constants.BILLING_STATUS_DRAFT);
					pb.setNote("");
					
					billing.setBilling(pb);
					
					session.save(billing);
					session.save(pb);
					
					projectBillList.add(pb);
					
					count++;
				}
			}
			session.flush();
			
			log.info("load " + count + " billings...");
		} catch (HibernateException e) {
			log.error("load billing failure...");
			throw e;
		}

		log.info("load billing successful...");
		
		return projectBillList;
	}
}
