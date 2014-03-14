/*
 * Created on 2005-4-1
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.Bill;

import java.util.Iterator;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;

import com.aof.component.BaseServices;
import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectHelper;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.util.Constants;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class InvoiceService extends BaseServices {
	private final char RECEIPT_NO_PERFIX = 'R';
	private Logger log = Logger.getLogger(InvoiceService.class);
	
	public ProjectInvoice viewInvoice(Long invoiceId) {
		ProjectInvoice pi = null;
		
		if (invoiceId != null && invoiceId.longValue() > 0) {
			try {
				session = this.getSession();
				
				pi = (ProjectInvoice)session.load(ProjectInvoice.class, invoiceId);				
				
				//for load confirmation and receipt
				if (pi.getConfirms() != null) {
					pi.getConfirms().size();
				}
				if (pi.getReceipts() != null) {
					pi.getReceipts().size();
				}
				return pi;
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		
		return pi;
	}
	
	public ProjectInvoice viewInvoice(String invoiceCode) {
		ProjectInvoice pi = null;
		
		if (invoiceCode != null && invoiceCode.trim().equals("")) {
			try {
				session = this.getSession();
				String statement = "form ProjectInvoice as pi where pi.invoiceCode = '"+invoiceCode+"'";
				Query q = session.createQuery(statement);
				List list  = q.list();
				Iterator iterator = list.iterator();
				if(iterator.hasNext()){
					pi = (ProjectInvoice)iterator.next();
				}
				//for load confirmation and receipt
				if (pi.getConfirms() != null) {
					pi.getConfirms().size();
				}
				if (pi.getReceipts() != null) {
					pi.getReceipts().size();
				}
				return pi;
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		
		return pi;
	}
	
	public ProjectInvoiceConfirmation viewInvoiceConfirmation(Long confirmId) {
		ProjectInvoiceConfirmation pic = null;
		
		if (confirmId != null && confirmId.longValue() > 0) {
			try {
				session = this.getSession();
				
				pic = (ProjectInvoiceConfirmation)session.load(ProjectInvoiceConfirmation.class, confirmId);				
				
				return pic;
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		
		return pic;
	}
	
	public ProjectReceipt viewReceipt(Long receiptId) {
	    ProjectReceipt pr = null;
		
		if (receiptId != null && receiptId.longValue() > 0) {
			try {
				session = this.getSession();
				
				pr = (ProjectReceipt)session.load(ProjectReceipt.class, receiptId);				
				
				return pr;
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		
		return pr;
	}
	
	public void editInvoiceConfirmation(ProjectInvoiceConfirmation pic, UserLogin ul) {
		session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			if (pic.getResponsiblePersonId() != null && pic.getResponsiblePersonId().trim().length() != 0) {
				UserLogin rp = (UserLogin)session.load(UserLogin.class, pic.getResponsiblePersonId());
				pic.setResponsiblePerson(rp);
			}
			
			if (pic.getCurrencyId() != null && pic.getCurrencyId().trim().length() != 0) {
				CurrencyType c = (CurrencyType)session.load(CurrencyType.class, pic.getCurrencyId());
				pic.setCurrency(c);
			}
			
			if (pic.getCreateUser() == null) {
				pic.setCreateUser(ul);
			}
			
			if (pic.getCreateDate() == null) {
				pic.setCreateDate(new java.sql.Date((new java.util.Date()).getTime()));
			}
			
			session.saveOrUpdate(pic);

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
	
	public void editReceipt(ProjectReceipt pr, UserLogin ul) {
	    session = this.getSession();
		Transaction transaction = null;
		
		try {
			boolean updateFlag = true;
			transaction = session.beginTransaction();
			
			if (pr.getInvoiceId() != null) {				
				pr.setInvoice(viewInvoice(pr.getInvoiceId()));
			}
			
			if (pr.getId() == null) {
				//pr.setReceiptNo(generateReceiptNo(pr.getInvoice().getInvoiceCode()));
				updateFlag = false;
			}
			
			if (pr.getCurrencyId() != null && pr.getCurrencyId().trim().length() != 0) {
				CurrencyType c = (CurrencyType)session.load(CurrencyType.class, pr.getCurrencyId());
				pr.setCurrency(c);
			}
			
			if (pr.getCreateUser() == null) {
				pr.setCreateUser(ul);
			}
			
			if (pr.getCreateDate() == null) {
				pr.setCreateDate(new java.sql.Date((new java.util.Date()).getTime()));
			}
			
			session.saveOrUpdate(pr);
			
			ProjectInvoice pi = pr.getInvoice();
			System.out.println("----1 "+pi.getRemaingAmount().doubleValue());
			
			if(updateFlag == false) {
				pi.addReceipt(pr);
			}
				System.out.println("----2 "+pi.getRemaingAmount().doubleValue());
			if(pi.getRemaingAmount().doubleValue() == 0){
				pi.setStatus(Constants.INVOICE_STATUS_COMPLETED);
			}else if(pi.getRemaingAmount().doubleValue() < pi.getAmount().doubleValue()){
				pi.setStatus(Constants.INVOICE_STATUS_INPROSESS);
			}
			session.saveOrUpdate(pi);
			
			ReceiptService service = new ReceiptService();
			ProjectReceiptMaster prm =  service.getView(pr.getReceiptNo());
			if(prm != null){
				if(updateFlag == false) prm.addInvoice(pr);
				double remainAmount = service.getRemainAmount(prm).doubleValue();
				if(remainAmount == 0.0 )
					prm.setReceiptStatus(Constants.RECEIPT_STATUS_COMPLETED);
				
				double totalAmount = prm.getReceiptAmount().doubleValue()*prm.getExchangeRate().doubleValue();
				if(remainAmount > 0.0 && remainAmount < totalAmount )
					prm.setReceiptStatus(Constants.RECEIPT_STATUS_WIP);
					
				session.update(prm);
			}

			
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
	
	public void deleteConfirmation(ProjectInvoice pi, Long[] confirmId) {
		session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			for (int i0 = 0; confirmId != null && i0 < confirmId.length; i0++) {
				ProjectInvoiceConfirmation pic = viewInvoiceConfirmation(confirmId[i0]);				
				pi.removeConfirm(pic);	
				session.delete(pic);
			}
			if (pi.getConfirms().size() == 0){
				pi.setStatus(Constants.INVOICE_STATUS_DELIVERED);
			}
			session.update(pi);	
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
	
	public void deleteReceipt(ProjectInvoice pi, Long[] receiptId) {
		session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			ReceiptService service = new ReceiptService();
			for (int i0 = 0; receiptId != null && i0 < receiptId.length; i0++) {
				ProjectReceipt pr = viewReceipt(receiptId[i0]);
				String receiptNo = pr.getReceiptNo();
				pi.removeReceipt(pr);				
				
				if(pi.getRemaingAmount().doubleValue() == 0){
					pi.setStatus(Constants.INVOICE_STATUS_COMPLETED);
				}else if(pi.getRemaingAmount().doubleValue() < pi.getAmount().doubleValue()){
					pi.setStatus(Constants.INVOICE_STATUS_INPROSESS);
				}else if(pi.getRemaingAmount().doubleValue()==pi.getAmount().doubleValue()){
					pi.setStatus(Constants.INVOICE_STATUS_DELIVERED);
				}
				
				session.saveOrUpdate(pi);
				ProjectReceiptMaster prm =  service.getView(receiptNo);
				if(prm != null){
				prm.removeInvoice(pr);
				double remainAmount = service.getRemainAmount(prm).doubleValue();
				double totalAmount = prm.getReceiptAmount().doubleValue() * prm.getExchangeRate().doubleValue();
				if(remainAmount == totalAmount)
					prm.setReceiptStatus(Constants.RECEIPT_STATUS_DRAFT);
				if(remainAmount > 0 && remainAmount < totalAmount )
					prm.setReceiptStatus(Constants.RECEIPT_STATUS_WIP);
				

				session.delete(pr);
				session.update(pi);
				session.update(prm);
				
				}

			}
			
			session.update(pi);	
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
	
	public void setProject(ProjectInvoice pi) throws HibernateException {
		
		session = this.getSession();
		
		if (pi.getProjectId() != null && pi.getProjectId().trim().length() != 0) {
			ProjectMaster pm = (ProjectMaster)session.load(ProjectMaster.class, pi.getProjectId());
			pi.setProject(pm);
		}
	}
	
	public void setBillAddress(ProjectInvoice pi) throws HibernateException {
		
		session = this.getSession();
		
		if (pi.getBillAddressId() != null && pi.getBillAddressId().trim().length() != 0) {
			CustomerProfile p = (CustomerProfile)session.load(CustomerProfile.class, pi.getBillAddressId());
			pi.setBillAddress(p);
		}
		
	}
	
	public void setCurrency(ProjectInvoice pi) throws HibernateException {
		
		session = this.getSession();
		
		if (pi.getCurrencyId() != null && pi.getCurrencyId().trim().length() != 0) {
			CurrencyType c = (CurrencyType)session.load(CurrencyType.class, pi.getCurrencyId());
			pi.setCurrency(c);
		}
	}
	
	public void setEms(ProjectInvoice pi) throws HibernateException {
		session = this.getSession();
		
		if (pi.getEmsId() != null && pi.getEmsId().longValue() > 0) {
			ProjectEMS pe = (ProjectEMS)session.load(ProjectEMS.class, pi.getEmsId());
			pi.setEMS(pe);
			pi.setStatus(Constants.INVOICE_STATUS_DELIVERED);
		}
	}
	
	public void setBilling(ProjectInvoice pi) throws HibernateException {
		session = this.getSession();
		
		if (pi.getBillId() != null) {
			ProjectBill pb = (ProjectBill)session.load(ProjectBill.class, pi.getBillId());			
			pi.setBilling(pb);
		}
	}
	
	
	public Long newInvoice(ProjectInvoice pi, UserLogin ul) {
		
		Long invoiceId = null;
		
		session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			setProject(pi);
			setBillAddress(pi);
			setCurrency(pi);

			if (pi.getInvoiceType().equals(Constants.INVOICE_TYPE_NORMAL)) {
				pi.setStatus(Constants.INVOICE_STATUS_UNDELIVERED);
			} else {
				pi.setStatus("Draft");
			}
			
			pi.setCreateUser(ul);
			pi.setCreateDate(new java.sql.Date((new java.util.Date()).getTime()));

			if (pi.getBillId() != null) {
				ProjectBill pb = (ProjectBill)session.load(ProjectBill.class, pi.getBillId());
				
				pb.addInvoice(pi);				
				pi.setBilling(pb);
				
				if (pb.getRemainingAmount() == 0L) {
					pb.setStatus(Constants.BILLING_STATUS_COMPLETED);
				} else {
					pb.setStatus(Constants.BILLING_STATUS_WIP);
				}
				//session.update(pb);
			}	
			
			session.save(pi);

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
		
		return invoiceId;
	}
	
	public void updateInvoice(ProjectInvoice pi) {
		
		session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();

			setBillAddress(pi);
			setCurrency(pi);
			setEms(pi);
			
			ProjectBill pb = pi.getBilling();
			
			if (pb.getRemainingAmount() == 0L) {
				pb.setStatus(Constants.BILLING_STATUS_COMPLETED);
			} else {
				pb.setStatus(Constants.BILLING_STATUS_WIP);
			}	
			
			session.update(pi);
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
	
	public void deleteInvoice(Long invoiceId) {
		
		session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			ProjectInvoice pi = viewInvoice(invoiceId);
			ProjectBill pb = pi.getBilling();
			pb.remvoeInvoice(pi);
			if (pb.getCalAmount().doubleValue() == pb.getRemainingAmount()) {
				pb.setStatus(Constants.BILLING_STATUS_DRAFT);
			} else {
				pb.setStatus(Constants.BILLING_STATUS_WIP);
			}
			session.delete(pi);
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
	
	public void cancelInvoice(Long invoiceId) {
		session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			ProjectInvoice pi = viewInvoice(invoiceId);
			pi.setStatus(Constants.INVOICE_STATUS_CANCELED);
			
			ProjectBill pb = pi.getBilling();
			if (pb.getRemainingAmount() == pb.getCalAmount().doubleValue()) {
				pb.setStatus(Constants.BILLING_STATUS_DRAFT);
			} else {
				pb.setStatus(Constants.BILLING_STATUS_WIP);
			}
			
			//do something relate to the option below

			session.update(pi);
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
	
	public void confirmInvoice(Long invoiceId) {
		session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			ProjectInvoice pi = viewInvoice(invoiceId);
			pi.setStatus(Constants.INVOICE_STATUS_CONFIRMED);
			
			//do something relate to the option below
			
			
			session.update(pi);
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
	
	public void addToEMS(Long[] invoiceId, Long emsId) {
		session = this.getSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			if (invoiceId != null) {
				ProjectEMS pe = (ProjectEMS)session.load(ProjectEMS.class, emsId);				
				for (int i0 = 0; i0 < invoiceId.length; i0++) {
					ProjectInvoice pi = viewInvoice(invoiceId[i0]);
					pi.setEMS(pe);
					pi.setStatus(Constants.INVOICE_STATUS_DELIVERED);
					
					session.update(pi);
				}
				
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
	
	public boolean checkAmount(ProjectInvoice pi) {
		session = this.getSession();
		try {
			ProjectBill pb = null;
			if (pi.getBillId() != null) {
				pb = (ProjectBill)session.load(ProjectBill.class, pi.getBillId());
				if (pb.getRemainingAmount() < pi.getAmount().doubleValue())  {
					return false;
				}
			} else {
				pb = pi.getBilling();
				if (pb.getRemainingAmount() < 0L)  {
					return false;
				}
			}
		} catch (HibernateException e) {
			e.printStackTrace();
		}
		
		return true;
	}
	
	private String generateReceiptNo(String invoiceNo) throws HibernateException {
		String receiptNo = null;
		int sequence = 1;
		session = this.getSession();
		
		try {
			String statement = "from ProjectReceipt as pr where pr.receiptNo like ?";
			Query query = session.createQuery(statement);
			query.setString(0, RECEIPT_NO_PERFIX + invoiceNo + "%");
			List list = query.list();
			
			for (int i0 = 0; list != null && i0 < list.size(); i0++) {
				ProjectReceipt pr = (ProjectReceipt)list.get(i0);
				try {
					int surfix = Integer.parseInt(pr.getReceiptNo().substring(invoiceNo.length() + 1));
					if (sequence <= surfix) {
						sequence = surfix + 1;
					}
				} catch(NumberFormatException e) {
					log.error(e.getMessage());
				}
			}
			receiptNo = RECEIPT_NO_PERFIX + invoiceNo + leftPad(String.valueOf(sequence), 2, "0");
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}
		
		return receiptNo;
	}
	
	private String leftPad(String target, int length, String padString) {
		for (int i0 = target.length(); i0 < length; i0++) {
			target = padString + target;
		}
		
		return target;
	}
}
