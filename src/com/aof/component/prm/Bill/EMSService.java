/*
 * Created on 2005-4-7
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.Bill;

import java.util.Iterator;
import java.util.Set;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;

import com.aof.component.BaseServices;
import com.aof.component.domain.party.UserLogin;
import com.aof.util.Constants;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EMSService extends BaseServices {
    
    private Logger log = Logger.getLogger(EMSService.class);
    
    public ProjectEMS viewEMS(Long emsId) {
        ProjectEMS pe = null;
		
		if (emsId != null && emsId.longValue() > 0) {
			try {
				session = this.getSession();
				
				pe = (ProjectEMS)session.load(ProjectEMS.class, emsId);				
				
				//for load invoice
				if (pe.getInvoices() != null) {
					pe.getInvoices().size();
				}
				
				return pe;
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		
		return pe;
    }
    
    public Long newEMS(ProjectEMS pe, UserLogin ul) {
    	
    	Long emsId = null;
    	
    	session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			pe.setDepartment(ul.getParty());
			pe.setCreateUser(ul);
			pe.setCreateDate(new java.sql.Date((new java.util.Date()).getTime()));
			
			session.save(pe);
			session.flush();
				
		} catch (HibernateException e) {
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
		
		return emsId;
    }
    
    public void updateEMS(ProjectEMS pe) {
    	session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			session.update(pe);
			session.flush();
				
		} catch (HibernateException e) {
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
    
    public void removeEMS(Long emsId) {
    	
    	session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			ProjectEMS pe = viewEMS(emsId);
			
			Set invoices = pe.getInvoices();
			
			if (invoices != null) {
				Iterator it = invoices.iterator();
				while (it.hasNext()) {
					ProjectInvoice pi = (ProjectInvoice)it.next();
					pi.setStatus(Constants.INVOICE_STATUS_UNDELIVERED);
					pi.setEMS(null);					
					session.update(pi);
				}
			}
			
			session.delete(pe);
			
		} catch (HibernateException e) {
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
    
    public void deleteFormEMS(Long[] invoiceId, Long emsId) {
	    session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			if (invoiceId != null) {	
			    ProjectEMS pe = viewEMS(emsId);
				for (int i0 = 0; i0 < invoiceId.length; i0++) {
					ProjectInvoice pi = (ProjectInvoice)session.load(ProjectInvoice.class, invoiceId[i0]);					
					pi.setEMS(null);
					pi.setStatus(Constants.INVOICE_STATUS_UNDELIVERED);
					pe.removeInvoice(pi);
					
					session.update(pi);
				}
				session.update(pe);
				
				session.flush();
			}
		} catch (HibernateException e) {
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
}
