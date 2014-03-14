/**
 * 
 */
package com.aof.component.prm.Bill;

import java.util.Calendar;
import java.util.Iterator;
import java.util.List;

import net.sf.hibernate.Transaction;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

import com.aof.component.BaseServices;
import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.expense.ProjectCostMaster;
import com.aof.component.prm.project.CurrencyType;

import com.aof.core.persistence.jdbc.*;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.core.persistence.*;

/**
 * @author CN01511
 *
 */
public class ReceiptService extends BaseServices{

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

	public CustomerProfile getCustomer(String customerIdString) {
		
		session = this.getSession();
		
		try{
			String statement = "from CustomerProfile as cp where cp.partyId = ?";
			Query q = session.createQuery(statement);
			q.setString(0,customerIdString);
			List list = q.list();
			Iterator i = list.iterator();
			if(i.hasNext()){
				session.flush();
				return (CustomerProfile)i.next();
			}
			session.flush();
		}catch(HibernateException e){
			e.printStackTrace();
		}
		return new CustomerProfile();
	}
	
	public boolean checkReceiptNo(String receiptNo) {

		session = this.getSession();
		
		try{
			String statement = "from ProjectReceiptMaster as prm where prm.receiptNo = ?";
			Query q = session.createQuery(statement);
			q.setString(0,receiptNo);
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
	
	public void insert(ProjectReceiptMaster prm) {
		
		session = this.getSession();
		Transaction transaction = null;
		
		try{
			//transaction = session.beginTransaction();			
			session.save(prm);
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
	
	public void update(ProjectReceiptMaster prm) {

		session = this.getSession();
		Transaction transaction = null;
		
		try{
			//transaction = session.beginTransaction();

			session.saveOrUpdate(prm);
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

	public void delete(ProjectReceiptMaster prm) {
		// TODO Auto-generated method stub
		session = this.getSession();
		Transaction transaction = null;
		
		try{
			transaction = session.beginTransaction();
			ProjectReceiptMaster receipt = 
				(ProjectReceiptMaster)session.load(ProjectReceiptMaster.class,prm.getReceiptNo());
			
			session.delete(receipt);
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

	public ProjectReceiptMaster getView(String dataId) {
		// TODO Auto-generated method stub

		session = this.getSession();
		Transaction transaction = null;
		
		try{
			transaction = session.beginTransaction();
			if(dataId != null && !dataId.trim().equals("")){
				
				ProjectReceiptMaster prm  = 
					(ProjectReceiptMaster)session.load(ProjectReceiptMaster.class,dataId);
				if(prm != null)
					return prm;
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
		return null;
	}
	
	public Double getRemainAmount(ProjectReceiptMaster prm){
		if(prm == null || prm.getReceiptAmount() == null)
			return new Double(0.0);
		
		double amount = prm.getReceiptAmount().doubleValue() * prm.getExchangeRate().doubleValue();
		Iterator i = prm.getInvoices().iterator();
		while(i.hasNext()){
			ProjectReceipt pr = (ProjectReceipt)i.next();
			double settledAmount = 
				pr.getReceiveAmount().doubleValue(); //* pr.getCurrencyRate().doubleValue();
			amount -= settledAmount;		
		}
		if(amount < 1 && amount > -1) amount = 0;
		return new Double(amount);
	}

	/*
	public Double getRemainAmount(ProjectReceiptMaster prm){
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		try{
		StringBuffer sql = new StringBuffer();
		sql.append(" select sum(receive_amount)");
		sql.append(" from proj_receipt"); 
		sql.append(" where receipt_no = '"+ prm.getReceiptNo()+"'"); 
		sql.append(" group by receipt_no");
		SQLResults result = sqlExec.runQueryCloseCon(sql.toString());
			double settleAmount = (result.getRowCount()==0) ? 0.0 : result.getDouble(0,0);
			double totalAmount = prm.getReceiptAmount()==null?0.0:prm.getReceiptAmount().doubleValue();
			return new Double(totalAmount-settleAmount);
		}catch(Exception e){
			//e.printStackTrace();
			if(sqlExec.getConnection() != null)
			sqlExec.closeConnection();
			
			return new Double(0.0);
		}
			
	}
	*/
	
	public List getSettlement(ProjectReceiptMaster prm) {
		
		session = this.getSession();
		String statement = "from ProjectReceipt  as pr where pr.receiptNo = '"+prm.getReceiptNo()+"'";
		List list = null;
		
		try{
			Query q = session.createQuery(statement);
			list = q.list();
			session.flush();
		}catch(Exception e){
			e.printStackTrace();
		}
		return list;
	}

	public String generateNo()   {
		// TODO Auto-generated method stub
		 session = this.getSession();
		
		Calendar calendar = Calendar.getInstance();
		StringBuffer sb = new StringBuffer();
		sb.append("R");
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
			String statement = "select max(p.receipt_no) from proj_receipt_mstr as p where p.receipt_no like '"+codePrefix+"%'";
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

}
