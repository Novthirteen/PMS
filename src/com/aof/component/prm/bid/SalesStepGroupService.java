/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.bid;

import java.util.Iterator;
import java.util.Set;

import org.apache.log4j.Logger;

import com.aof.component.BaseServices;

public class SalesStepGroupService extends BaseServices {
	private Logger log = Logger.getLogger(SalesStepGroupService.class);
	
	public SalesStepGroup viewSalesStepGroup(Long id, boolean lazyFlg) {
		
		SalesStepGroup ssg = null;
		
		if (id != null && id.longValue() > 0) {
			try {
				session = this.getSession();
				
				ssg = (SalesStepGroup)session.load(SalesStepGroup.class, id);				
				
				//for load step and activity
				if (!lazyFlg) {
					if (ssg.getSteps() != null) {
						Set steps = ssg.getSteps();
						
						if (steps != null) {
							steps.size();
						}
						/*
						if (steps != null) {
							Iterator iterator = steps.iterator();
							while (iterator.hasNext()) {
								SalesStep ss = (SalesStep)iterator.next();
								if (ss.getActivities() != null) {
									ss.getActivities().size();
								}
							}
						}
						*/
					}
				}
				return ssg;
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		return ssg;
	}
	
	public void newSalesStepGroup(SalesStepGroup ssg) {
		if (ssg != null) {
			try {
				session = this.getSession();
				session.save(ssg);
				session.flush();
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
	
	public void updateSalesStepGroup(SalesStepGroup ssg) {
		if (ssg != null) {
			try {
				session = this.getSession();
				session.update(ssg);
				session.flush();
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
	
	public void deleteSalesStepGroup(SalesStepGroup ssg) {
		if (ssg != null) {
			try {
				session = this.getSession();
				session.delete(ssg);
				session.flush();
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
}
