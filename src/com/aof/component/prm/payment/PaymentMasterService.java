package com.aof.component.prm.payment;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import com.aof.component.BaseServices;
import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.expense.ProjectCostMaster;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;

public class PaymentMasterService extends BaseServices {

	public PaymentMasterService() {
		super();
		// TODO Auto-generated constructor stub
	}

	public CurrencyType getCurrency(String currencyString) {
		
		session = this.getSession();
		
		try{
			String statement = "from CurrencyType as ct where ct.currId = ?";
			Query q = session.createQuery(statement);
			q.setString(0,currencyString);
			List list = q.list();
			Iterator i = list.iterator();
			if(i.hasNext()){
				session.flush();
				return (CurrencyType)i.next();
			}
			session.flush();
		}catch(HibernateException e){
			e.printStackTrace();
		}
		return new CurrencyType();
	}

	public UserLogin getCreateUser(String createUserString) {

		session = this.getSession();
		
		try{
			String statement = "from UserLogin as ul where ul.userLoginId = ?";
			Query q = session.createQuery(statement);
			q.setString(0,createUserString);
			List list = q.list();
			Iterator i = list.iterator();
			if(i.hasNext()){
				session.flush();
				return (UserLogin)i.next();
			}
			session.flush();
		
		}catch(HibernateException e){
			e.printStackTrace();
		}
		return new UserLogin();
		
	}

	public VendorProfile getVendor(String vendorIdString) {
		
		session = this.getSession();
		
		try{
			String statement = "from VendorProfile as vp where vp.partyId = ?";
			Query q = session.createQuery(statement);
			q.setString(0,vendorIdString);
			List list = q.list();
			Iterator i = list.iterator();
			if(i.hasNext()){
				session.flush();
				return (VendorProfile)i.next();
			}
			session.flush();
		}catch(HibernateException e){
			e.printStackTrace();
		}
		return new VendorProfile();
	}
	
	public ProjectMaster getPoProject(String projId) {
		
		session = this.getSession();
		
		try{
			String statement = "from ProjectMaster as pm where pm.projId = ?";
			Query q = session.createQuery(statement);
			q.setString(0,projId);
			List list = q.list();
			Iterator i = list.iterator();
			if(i.hasNext()){
				session.flush();
				return (ProjectMaster)i.next();
			}
			session.flush();
		}catch(HibernateException e){
			e.printStackTrace();
		}
		return new ProjectMaster();
	}
	
	public boolean checkPayCode(String payCode) {

		session = this.getSession();
		
		try{
			String statement = "from ProjectPaymentMaster as ppm where ppm.payCode = ?";
			Query q = session.createQuery(statement);
			q.setString(0,payCode);
			List list = q.list();
			Iterator i = list.iterator();
			if(i.hasNext()){
				session.flush();
				return true;
			}
			session.flush();
		}catch(HibernateException e){
			e.printStackTrace();
		}
		return false;
	
	}
	
	public boolean isPayAmountValid(ProjectPaymentMaster ppm, double payAmount) {
		if (new BigDecimal(payAmount).setScale(2, BigDecimal.ROUND_HALF_UP )
				.compareTo(new BigDecimal(ppm.getSettledAmount()).setScale(2, BigDecimal.ROUND_HALF_UP )) 
				< 0) {
			return false;
		}
		
		return true;
	}
	
	public void resetInvoiceSettleStatus(ProjectPaymentMaster ppm) {
		if(Math.abs(ppm.getSettledRemainingAmount()) < 1){
			ppm.setSettleStatus(Constants.PAYMENT_STATUS_COMPLETED);
		} else if (Math.abs(ppm.getSettledAmount()) < 1){
			ppm.setSettleStatus(Constants.PAYMENT_STATUS_DRAFT);
		} else {
			ppm.setSettleStatus(Constants.PAYMENT_STATUS_WIP);
		}
	}
	
	public void resetInvoicPayStatus(ProjectPaymentMaster ppm) {
		if(Math.abs(ppm.getPaidRemainingAmount()) < 1){
			ppm.setPayStatus(Constants.PAYMENT_STATUS_COMPLETED);
		} else if (Math.abs(ppm.getPaidAmount()) < 1){
			ppm.setPayStatus(Constants.PAYMENT_STATUS_DRAFT);
		} else {
			ppm.setPayStatus(Constants.PAYMENT_STATUS_WIP);
		}
	}
	
	public void insert(ProjectPaymentMaster ppm) {
		
		session = this.getSession();
		Transaction transaction = null;
		
		try{
			//transaction = session.beginTransaction();			
			session.save(ppm);
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
				//transaction.commit();
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}		
		}
		
	}
	
	public void update(ProjectPaymentMaster ppm) {

		session = this.getSession();
		Transaction transaction = null;
		
		try{
			//transaction = session.beginTransaction();

			session.saveOrUpdate(ppm);
			session.flush();
			
		} catch (HibernateException e) {
			try {
				// TODO Auto-generated catch block
				//transaction.rollback();
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			try {
				//transaction.commit();
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}		
		}
		
	}

	public void delete(ProjectPaymentMaster ppm) {
		// TODO Auto-generated method stub
		session = this.getSession();
		Transaction transaction = null;
		
		try{
			transaction = session.beginTransaction();
			ProjectPaymentMaster p = 
				(ProjectPaymentMaster)session.load(ProjectPaymentMaster.class,ppm.getPayCode());
			
			session.delete(p);
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

	public ProjectPaymentMaster getView(String dataId) {
		// TODO Auto-generated method stub

		session = this.getSession();
		Transaction transaction = null;
		
		try{
			//transaction = session.beginTransaction();
			if(dataId != null & !dataId.trim().equals("")){
				
				ProjectPaymentMaster ppm  = 
					(ProjectPaymentMaster)session.load(ProjectPaymentMaster.class,dataId);
				if(ppm != null)
					return ppm;
			}			
		} catch (HibernateException e) {
			try {
				// TODO Auto-generated catch block
				//transaction.rollback();
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			try {
				//transaction.commit();
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}		
		}
		return null;
	}
	
	public Double getRemainAmount(ProjectPaymentMaster ppm){
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		try{
		StringBuffer sql = new StringBuffer();
		sql.append(" select sum(receive_amount)");
		sql.append(" from proj_receipt"); 
		sql.append(" where receipt_no = '"+ ppm.getPayCode()+"'"); 
		sql.append(" group by receipt_no");
		SQLResults result = sqlExec.runQueryCloseCon(sql.toString());
			double settleAmount = (result.getRowCount()==0) ? 0.0 : result.getDouble(0,0);
			double totalAmount = ppm.getPayAmount();
			return new Double(totalAmount-settleAmount);
		}catch(Exception e){
			//e.printStackTrace();
			if(sqlExec.getConnection() != null)
			sqlExec.closeConnection();
			
			return new Double(0.0);
		}
			
	}

	public List getSettlement(ProjectPaymentMaster ppm) {
		Iterator i = ppm.getInvoicePayments().iterator();
		List list = new java.util.ArrayList();
		while(i.hasNext()){
			ProjectCostMaster pcm = (ProjectCostMaster)i.next();
			list.add(pcm);
		}
		return list;
	}

	public String generateNo()   {
		// TODO Auto-generated method stub
		 session = this.getSession();
		
		Calendar calendar = Calendar.getInstance();
		StringBuffer sb = new StringBuffer();
		sb.append("SI");
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH)+1;
		int day = calendar.get(Calendar.DATE);
		sb.append(year);
		sb.append(this.fillPreZero(month,2));
		sb.append(this.fillPreZero(day,2));
		String codePrefix = sb.toString();
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));

		try {
			String statement = "select max(p.pay_code) from proj_payment_mstr as p where p.pay_code like '"+codePrefix+"%'";
			SQLResults result = sqlExec.runQueryCloseCon(statement);
					
			int count = 0;
			String GetResult = (String)result.getString(0,0);
			if (GetResult !=  null)
			count = (new Integer(GetResult.substring(codePrefix.length()))).intValue();
		
			sb = new StringBuffer();
			sb.append(codePrefix);
			sb.append(fillPreZero(count+1,3));
			return sb.toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			
			if(sqlExec.getConnection() != null)
				sqlExec.closeConnection();

			return null;
		}

	}
	
	private String fillPreZero(int no,int len) {
		String s=String.valueOf(no);
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<len-s.length();i++)
		{
			sb.append('0');
		}
		sb.append(s);
		return sb.toString();
	}
	
	public void getSupplierInvoiceList(HttpServletRequest request, String id)
	throws Exception{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		List result = hs.find("from ProjectPaymentMaster ppm where ppm.payCode='"+id+"'");
		request.setAttribute("InvoiceList", result.get(0));
	}
}
