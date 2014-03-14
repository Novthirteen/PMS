/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.bid;

import org.apache.log4j.Logger;
import java.util.*;
import com.aof.component.BaseServices;
import net.sf.hibernate.Transaction;

public class SalesStepService extends BaseServices {
	private Logger log = Logger.getLogger(SalesStepService.class);
	
	public SalesStep viewSalesStep(Long id) {
		
		SalesStep ss = null;
		
		if (id != null && id.longValue() > 0) {
			try {
				session = this.getSession();
				
				ss = (SalesStep)session.load(SalesStep.class, id);
				
				if (ss.getActivities() != null) {
					Iterator iterator = ss.getActivities().iterator();
					while (iterator.hasNext()) {
						SalesActivity sa = (SalesActivity)iterator.next();
					}
					ss.getActivities().size();
				}
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		
		return ss;
	}
	
	public void newSalesStep(SalesStep ss) {
		if (ss != null) {
			try {
				session = this.getSession();
				session.save(ss);
				session.flush();
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
	
	public void updateSalesStep(SalesStep ss) {
		if (ss != null) {
			try {
				session = this.getSession();
				session.update(ss);
				session.flush();
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
	
	public void deleteSalesStep(SalesStep ss) {
		if (ss != null) {
			try {
				session = this.getSession();
				Transaction transaction = null; 
				transaction = session.beginTransaction();
				
				session.delete(ss);
				Set activities = ss.getActivities();
				if(activities != null){
					Iterator iterator = activities.iterator();
					while (iterator.hasNext()) {
						SalesActivity sa = (SalesActivity)iterator.next();
						session.delete(sa);
					}
				}
				transaction.commit();
				session.flush();
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
}
