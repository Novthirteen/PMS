/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.bid;

import org.apache.log4j.Logger;

import com.aof.component.BaseServices;

public class SalesActivityService extends BaseServices {
	private Logger log = Logger.getLogger(SalesActivityService.class);
	
	public SalesActivity viewSalesActivity(Long id) {
		
		SalesActivity sa = null;
		
		if (id != null && id.longValue() > 0) {
			try {
				session = this.getSession();
				
				sa = (SalesActivity)session.load(SalesActivity.class, id);				
				return sa;
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		return sa;
	}
	
	public void newSalesActivity(SalesActivity sa) {
		if (sa != null) {
			try {
				session = this.getSession();
				session.save(sa);
				session.flush();
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
	
	public void updateSSalesActivity(SalesActivity sa) {
		if (sa != null) {
			try {
				session = this.getSession();
				session.update(sa);
				session.flush();
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
	
	public void deleteSalesActivity(SalesActivity sa) {
		if (sa != null) {
			try {
				session = this.getSession();
				session.delete(sa);
				session.flush();
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
}
