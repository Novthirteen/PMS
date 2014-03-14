/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.Bill;

import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;

import com.aof.component.BaseServices;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.TimeSheet.TimeSheetDetail;
import com.aof.component.prm.expense.ExpenseAmount;
import com.aof.component.prm.expense.ExpenseMaster;
import com.aof.component.prm.expense.ProjectCostMaster;
import com.aof.component.prm.payment.PaymentMaterial;
import com.aof.component.prm.payment.PaymentTransactionDetail;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.Material;
import com.aof.component.prm.project.ServiceType;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;

public class TransactionServices extends BaseServices {

	private Logger log = Logger.getLogger(TransactionServices.class);
	
	public TransactionServices(){
		super();
	}
	
	public void insert(Material m, UserLogin ul) throws Exception {
		Session sess=null;
		Transaction tx = null;
		
		try {
			if ((m instanceof BillingMaterial
					&& ((BillingMaterial)m).getBillling() == null)
				|| (m instanceof PaymentMaterial
						&& ((PaymentMaterial)m).getVender() == null)) {
				sess=this.getSession();
				tx = sess.beginTransaction();
				m.setCategory(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE);	
				if (m.getCreateDate() == null) {
					m.setCreateDate(UtilDateTime.nowTimestamp());
				}
				if (m.getCreateUser() == null) {
					m.setCreateUser(ul);
				}
				sess.saveOrUpdate(m);
				tx.commit();
			}			
		}catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		}
	}
	
	public void insert(ExpenseMaster em, UserLogin ul) throws Exception{
		Session sess=null;
		Transaction tx = null;
		
		try {
			if ((em.getStatus().equals("Confirmed")) || (em.getStatus().equals("Claimed"))) {
				sess=this.getSession();
				tx = sess.beginTransaction();
				
				if (em.getClaimType().equals("CY")) {  //billing
					
					BillTransactionDetail tr = (BillTransactionDetail)getInsertedRecord(
							"BillTransactionDetail", em.getId().longValue(), Constants.TRANSACATION_CATEGORY_EXPENSE);
					
					if (tr == null) {
						tr = new BillTransactionDetail();
						tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
						tr.setTransactionCreateUser(ul);
					}
					tr.setCurrency(em.getExpenseCurrency());
					tr.setExchangeRate(new Double(em.getCurrencyRate().doubleValue()));
					tr.setProject(em.getProject());
					tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_EXPENSE);
					
					tr.setTransactionDate(em.getExpenseDate());
					//tr.setTransactionDate1(em.getVerifyDate());
					tr.setTransactionDate1(em.getReceiptDate());
					tr.setTransactionDate2(em.getApprovalDate());
					tr.setTransactionParty(em.getProject().getBillTo());
					tr.setTransactionRecId(em.getId());
					tr.setTransactionUser(em.getExpenseUser());
					
					tr.setDesc1(em.getFormCode());
					//Amount
					Iterator itAmt = em.getAmounts().iterator();
					ExpenseAmount ea = null;
					double AmtClaim = 0;
					while (itAmt.hasNext()) {
						ea = (ExpenseAmount)itAmt.next();
						if (!ea.getExpType().getExpDesc().equalsIgnoreCase("Allowance")) {
							AmtClaim = AmtClaim + ea.getPaidAmount().doubleValue();
						}
					}
					tr.setAmount(new Double(AmtClaim));
					
					sess.saveOrUpdate(tr);
				}
				/*
				if ("EXT".equalsIgnoreCase(em.getExpenseUser().getNote())) {  //payment
					
					PaymentTransactionDetail ptd = (PaymentTransactionDetail)getInsertedRecord(
							"PaymentTransactionDetail", em.getId().longValue(), Constants.TRANSACATION_CATEGORY_EXPENSE);
					
					if (ptd == null) {
						ptd = new PaymentTransactionDetail();
						ptd.setTransactionCreateDate(UtilDateTime.nowTimestamp());
						ptd.setTransactionCreateUser(ul);
					}
					
					ptd.setCurrency(em.getExpenseCurrency());
					ptd.setExchangeRate(new Double(em.getCurrencyRate().doubleValue()));
					ptd.setProject(em.getProject());
					ptd.setTransactionCategory(Constants.TRANSACATION_CATEGORY_EXPENSE);

					ptd.setTransactionDate(em.getExpenseDate());
					//tr.setTransactionDate1(em.getVerifyDate());
					ptd.setTransactionDate1(em.getReceiptDate());
					ptd.setTransactionDate2(em.getApprovalDate());
					ptd.setTransactionParty(em.getProject().getVendor());
					ptd.setTransactionRecId(em.getId());
					ptd.setTransactionUser(em.getExpenseUser());
					
					ptd.setDesc1(em.getFormCode());
					//Amount
					Iterator itAmt = em.getAmounts().iterator();
					ExpenseAmount ea = null;
					double AmtClaim = 0;
					while (itAmt.hasNext()) {
						ea = (ExpenseAmount)itAmt.next();
						AmtClaim = AmtClaim + ea.getPaidAmount().doubleValue();
					}
					ptd.setAmount(new Double(AmtClaim));
					
					sess.saveOrUpdate(ptd);
				}
				*/
				tx.commit();
			}
		}catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		}
	}
	
	public void insert(TimeSheetDetail tsd, UserLogin ul) throws Exception {
		Session sess=null;
		Transaction tx = null;

		try {
			sess=this.getSession();
			tx = sess.beginTransaction();
			if (tsd.getCAFStatusConfirm().equals("Y") && tsd.getConfirm().trim().equals("Confirmed")) {
				CurrencyType ct = (CurrencyType)sess.load(CurrencyType.class,"RMB");
				BillTransactionDetail tr = null;
				double AmtClaim = 0L;
				
				if (tsd.getProject().getProjectCategory().getId().equals("C")){
					//Billing for CAF		
					if (tsd.getTsHoursConfirm() != null 
							&& tsd.getTsHoursConfirm().floatValue() != 0f
							&& tsd.getProject().getContractType().equals("TM")
							&& tsd.getProjectEvent().getBillable().equals("Yes")) {
						
						tr = (BillTransactionDetail)getInsertedRecord(
								"BillTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_CAF);
						
						if (tr == null) {
							tr = new BillTransactionDetail();
							tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
							tr.setTransactionCreateUser(ul);
						}
						
						tr.setCurrency(ct);
						tr.setExchangeRate(new Double(1));
						tr.setProject(tsd.getProject());
						tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_CAF);
						
						tr.setTransactionDate(tsd.getTsDate());
						tr.setTransactionDate1(tsd.getTsConfirmDate());
						tr.setTransactionParty(tsd.getProject().getBillTo());
						tr.setTransactionRecId(new Long(tsd.getTsId().intValue()));
						tr.setTransactionUser(tsd.getTimeSheetMaster().getTsmUser());
						
						tr.setDesc1(tsd.getProjectEvent().getPeventName());
						tr.setDesc2(tsd.getTSServiceType().getDescription());
						
						tr.setTransactionNum1(new Double(tsd.getTsHoursConfirm().doubleValue()));
						tr.setTransactionNum2(new Double(tsd.getTSServiceType().getRate().doubleValue()));
						
						//Amount
						AmtClaim = (tsd.getTsHoursConfirm().doubleValue()) * (tsd.getTSServiceType().getRate().doubleValue() / 8);
						
						tr.setAmount(new Double(AmtClaim));
						
						sess.saveOrUpdate(tr);
					} else {
						tr = (BillTransactionDetail)getInsertedRecord(
								"BillTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_CAF);
						
						if (tr != null && tr.getTransactionMaster() == null) {
							sess.delete(tr);
						}
					}
					
					//Allowance Bill
					if (tsd.getProject().getPaidAllowance().doubleValue() > 0
							&& tsd.getTSAllowance() != null
							&& tsd.getTSAllowance().doubleValue() > 0) {
						tr = (BillTransactionDetail)getInsertedRecord(
								"BillTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_ALLOWANCE);
						
						if (tr == null) {
							tr = new BillTransactionDetail();
							tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
							tr.setTransactionCreateUser(ul);
						}
						tr.setCurrency(ct);
						tr.setExchangeRate(new Double(1));
						tr.setProject(tsd.getProject());
						tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_ALLOWANCE);
	
						tr.setTransactionDate(tsd.getTsDate());
						tr.setTransactionDate1(tsd.getTsConfirmDate());
						tr.setTransactionParty(tsd.getProject().getBillTo());
						tr.setTransactionRecId(new Long(tsd.getTsId().intValue()));
						tr.setTransactionUser(tsd.getTimeSheetMaster().getTsmUser());
	
						tr.setDesc1(tsd.getProjectEvent().getPeventName());
						tr.setDesc2(tsd.getTSServiceType().getDescription());
						
						//Amount
						//AmtClaim = (tsd.getTsHoursConfirm().doubleValue()) * (tsd.getProject().getPaidAllowance().doubleValue()/8);
						AmtClaim = tsd.getTSAllowance().doubleValue() * tsd.getProject().getPaidAllowance().doubleValue();
						tr.setAmount(new Double(AmtClaim));
						tr.setTransactionNum1(new Double(tsd.getTSAllowance().doubleValue()));
						tr.setTransactionNum2(new Double(tsd.getProject().getPaidAllowance().doubleValue()));
						
						sess.saveOrUpdate(tr);
					} else {
						tr = (BillTransactionDetail)getInsertedRecord(
								"BillTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_ALLOWANCE);
						
						if (tr != null && tr.getTransactionMaster() == null) {
							sess.delete(tr);
						}
					}
				}
				
				if (tsd.getProject().getProjectCategory().getId().equals("P")){
					//Billing for CAF		
					if (tsd.getTsHoursConfirm() != null 
							&& tsd.getTsHoursConfirm().floatValue() != 0f
							&& tsd.getProject().getParentProject().getContractType().equals("TM")
							&& tsd.getProjectEvent().getBillable().equals("Yes")) {
						
						tr = (BillTransactionDetail)getInsertedRecord(
								"BillTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_CAF);
						
						if (tr == null) {
							tr = new BillTransactionDetail();
							tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
							tr.setTransactionCreateUser(ul);
						}
						
						tr.setCurrency(ct);
						tr.setExchangeRate(new Double(1));
						tr.setProject(tsd.getProject().getParentProject());
						tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_CAF);
						
						tr.setTransactionDate(tsd.getTsDate());
						tr.setTransactionDate1(tsd.getTsConfirmDate());
						tr.setTransactionParty(tsd.getProject().getParentProject().getBillTo());
						tr.setTransactionRecId(new Long(tsd.getTsId().intValue()));
						tr.setTransactionUser(tsd.getTimeSheetMaster().getTsmUser());
						
						tr.setDesc1(tsd.getProjectEvent().getPeventName());
						tr.setDesc2(tsd.getTSServiceType().getDescription());
						
						tr.setTransactionNum1(new Double(tsd.getTsHoursConfirm().doubleValue()));
						tr.setTransactionNum2(new Double(tsd.getTSServiceType().getRate().doubleValue()));
						
						//Amount
						AmtClaim = (tsd.getTsHoursConfirm().doubleValue()) * (tsd.getTSServiceType().getRate().doubleValue() / 8);
						
						tr.setAmount(new Double(AmtClaim));
						
						sess.saveOrUpdate(tr);
					} else {
						tr = (BillTransactionDetail)getInsertedRecord(
								"BillTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_CAF);
						
						if (tr != null && tr.getTransactionMaster() == null) {
							sess.delete(tr);
						}
					}
					
					//Allowance Bill
					if (tsd.getProject().getParentProject().getPaidAllowance().doubleValue() > 0
							&& tsd.getTSAllowance() != null
							&& tsd.getTSAllowance().doubleValue() > 0) {
						tr = (BillTransactionDetail)getInsertedRecord(
								"BillTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_ALLOWANCE);
						
						if (tr == null) {
							tr = new BillTransactionDetail();
							tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
							tr.setTransactionCreateUser(ul);
						}
						tr.setCurrency(ct);
						tr.setExchangeRate(new Double(1));
						tr.setProject(tsd.getProject().getParentProject());
						tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_ALLOWANCE);
	
						tr.setTransactionDate(tsd.getTsDate());
						tr.setTransactionDate1(tsd.getTsConfirmDate());
						tr.setTransactionParty(tsd.getProject().getParentProject().getBillTo());
						tr.setTransactionRecId(new Long(tsd.getTsId().intValue()));
						tr.setTransactionUser(tsd.getTimeSheetMaster().getTsmUser());
	
						tr.setDesc1(tsd.getProjectEvent().getPeventName());
						tr.setDesc2(tsd.getTSServiceType().getDescription());
						
						//Amount
						//AmtClaim = (tsd.getTsHoursConfirm().doubleValue()) * (tsd.getProject().getPaidAllowance().doubleValue()/8);
						AmtClaim = tsd.getTSAllowance().doubleValue() * tsd.getProject().getParentProject().getPaidAllowance().doubleValue();
						tr.setAmount(new Double(AmtClaim));
						tr.setTransactionNum1(new Double(tsd.getTSAllowance().doubleValue()));
						tr.setTransactionNum2(new Double(tsd.getProject().getParentProject().getPaidAllowance().doubleValue()));
						
						sess.saveOrUpdate(tr);
					} else {
						tr = (BillTransactionDetail)getInsertedRecord(
								"BillTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_ALLOWANCE);
						
						if (tr != null && tr.getTransactionMaster() == null) {
							sess.delete(tr);
						}
					}
				}
				
				//Pay to SubContract
				if (tsd.getTsHoursConfirm() != null 
						&& tsd.getTsHoursConfirm().floatValue() != 0f
						&& tsd.getProject().getContractType().equals("TM")
						&& tsd.getProjectEvent().getBillable().equals("Yes")
						&& (tsd.getTSServiceType().getSubContractRate().doubleValue() > 0) 
						&& tsd.getTimeSheetMaster().getTsmUser().getNote().equals("EXT")) {
					
					PaymentTransactionDetail ptr = (PaymentTransactionDetail)getInsertedRecord(
							"PaymentTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_CAF);
					
					if (ptr == null) {
						ptr = new PaymentTransactionDetail();
						ptr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
						ptr.setTransactionCreateUser(ul);
					}
					
					ptr.setCurrency(ct);
					ptr.setExchangeRate(new Double(1));
					ptr.setProject(tsd.getProject());
					ptr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_CAF);
					
					ptr.setTransactionDate(tsd.getTsDate());
					ptr.setTransactionDate1(tsd.getTsConfirmDate());
					ptr.setTransactionParty(tsd.getProject().getVendor());
					ptr.setTransactionRecId(new Long(tsd.getTsId().intValue()));
					ptr.setTransactionUser(tsd.getTimeSheetMaster().getTsmUser());
					
					ptr.setDesc1(tsd.getProjectEvent().getPeventName());
					ptr.setDesc2(tsd.getTSServiceType().getDescription());
					
					ptr.setTransactionNum1(new Double(tsd.getTsHoursConfirm().doubleValue()));
					ptr.setTransactionNum2(new Double(tsd.getTSServiceType().getSubContractRate().doubleValue()));
					
					//Amount
					AmtClaim = (tsd.getTsHoursConfirm().doubleValue()) * (tsd.getTSServiceType().getSubContractRate().doubleValue() / 8);

					ptr.setAmount(new Double(AmtClaim));
					sess.saveOrUpdate(ptr);
				} else {
					PaymentTransactionDetail ptr = (PaymentTransactionDetail)getInsertedRecord(
							"PaymentTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_CAF);
					
					if (ptr != null && ptr.getTransactionMaster() == null) {
						sess.delete(ptr);
					}
				}
			} else {
				
			}
			
			tx.commit();
		}catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		}
	}
	
	public void insert(ServiceType st, UserLogin ul) throws Exception{
		Session sess=null;
		Transaction tx = null;
		
		try {
			if (st.getProject().getContractType().equals("FP")) {
				sess=this.getSession();
				if (st.getCustAcceptanceDate() != null) {
					//billing
					tx = sess.beginTransaction();
					
					BillTransactionDetail tr = (BillTransactionDetail)getInsertedRecord("BillTransactionDetail", st.getId().longValue(), Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE);

					if (tr ==  null) {
						tr = new BillTransactionDetail();
						//Create User
						//HttpSession session = request.getSession();
						//UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
						tr.setTransactionCreateUser(ul);
						tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
					}
					
					tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE);
					tr.setTransactionRecId(st.getId());
					tr.setAmount(new Double(st.getRate().doubleValue()));
					tr.setCurrency((CurrencyType)sess.load(CurrencyType.class,"RMB"));
					tr.setExchangeRate(new Double(1));
					tr.setDesc1(st.getDescription());
					tr.setProject(st.getProject());
					tr.setTransactionParty(st.getProject().getBillTo());
					tr.setTransactionDate(st.getCustAcceptanceDate());
					//tr.setTransactionDate1(st.getEstimateAcceptanceDate());
					tr.setTransactionUser(st.getProject().getProjectManager());
					tr.setTransactionNum1(new Double(st.getEstimateManDays().doubleValue()));
					
					//calculate man days below
					SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
					
					String query = " select sum(tsd.ts_hrs_user) as cal_hrs "
						         + "   from proj_ts_det as tsd inner join proj_mstr as proj on tsd.ts_proj_id = proj.proj_id "
								 + "  where proj.proj_id = ? "
								 + "    and tsd.ts_status = 'Approved' "
								 + "    and tsd.ts_servicetype = ? ";
					query = query + " group by tsd.ts_proj_id ";
					
					sqlExec.addParam(st.getProject().getProjId());
					sqlExec.addParam(st.getId());
					
					SQLResults sr = sqlExec.runQueryCloseCon(query);

					if (sr != null && sr.getRowCount() > 0) {
						tr.setTransactionNum2(new Double(Math.round(sr.getDouble(0, "cal_hrs") / 8)));
					} else {
						tr.setTransactionNum2(new Double(0));
					}
					//calculate man days up
								
					sess.saveOrUpdate(tr);
					tx.commit();
				}else{
					//billing
					BillTransactionDetail tr = (BillTransactionDetail)getInsertedRecord("BillTransactionDetail", st.getId().longValue(), Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE);
					if (tr !=  null) {
						tx = sess.beginTransaction();
						tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE);
						tr.setTransactionRecId(st.getId());
						sess.delete(tr);
						tx.commit();
					}
				}
				 
				
				if (st.getVendAcceptanceDate() != null) {
					//payment
					tx = sess.beginTransaction();
					
					PaymentTransactionDetail tr = 
						(PaymentTransactionDetail)getInsertedRecord("PaymentTransactionDetail", st.getId().longValue(), Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE);

					if (tr == null) {
						tr = new PaymentTransactionDetail();
						//Create User
						//HttpSession session = request.getSession();
						//UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
						tr.setTransactionCreateUser(ul);
						tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
					}

					tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE);
					tr.setTransactionRecId(st.getId());
					tr.setAmount(new Double(st.getSubContractRate().doubleValue()));
					tr.setCurrency((CurrencyType)sess.load(CurrencyType.class,"RMB"));
					tr.setExchangeRate(new Double(1));
					tr.setDesc1(st.getDescription());
					tr.setProject(st.getProject());
					tr.setTransactionParty(st.getProject().getVendor());
					tr.setTransactionDate(st.getVendAcceptanceDate());
					//tr.setTransactionDate1(st.getEstimateAcceptanceDate());
					tr.setTransactionUser(st.getProject().getProjectManager());
					tr.setTransactionNum1(new Double(st.getEstimateManDays().doubleValue()));
					
					//calculate man days below
					SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
					
					String query = " select sum(tsd.ts_hrs_user) as cal_hrs "
						         + "   from proj_ts_det as tsd inner join proj_mstr as proj on tsd.ts_proj_id = proj.proj_id "
						         + "                           inner join proj_ts_mstr as ptm on ptm.tsm_id = tsd.tsm_id "
								 + "                           inner join user_login as ul on ul.user_login_id = ptm.tsm_userlogin "
								 + "  where proj.proj_id = ? "
								 + "    and tsd.ts_status = 'Approved' "
								 + "    and tsd.ts_servicetype = ? "
							     + "    and ul.note = 'EXT' ";
					query = query + " group by tsd.ts_proj_id ";
					
					sqlExec.addParam(st.getProject().getProjId());
					sqlExec.addParam(st.getId());
					
					SQLResults sr = sqlExec.runQueryCloseCon(query);

					if (sr != null && sr.getRowCount() > 0) {
						tr.setTransactionNum2(new Double(Math.round(sr.getDouble(0, "cal_hrs") / 8)));
					} else {
						tr.setTransactionNum2(new Double(0));
					}
					//calculate man days up
					
					sess.saveOrUpdate(tr);
					tx.commit();
				} else {
					//payment
					PaymentTransactionDetail tr = 
						(PaymentTransactionDetail)getInsertedRecord("PaymentTransactionDetail", st.getId().longValue(), Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE);

					if (tr != null) {
						tx = sess.beginTransaction();
						tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE);
						tr.setTransactionRecId(st.getId());
						sess.delete(tr);
						tx.commit();
					}
				}
			}
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		}
	}
	
	public void insert(ProjectCostMaster pcm, UserLogin ul) throws Exception{
		Session sess=null;
		Transaction tx = null;
		
		try {
			if (pcm.getApprovalDate() != null) {
				sess=this.getSession();
				tx = sess.beginTransaction();
				
				if (pcm.getProjectCostType().getTypeaccount().equals("Expense")) {				
					//billing
					//ProjectCostDetail detail = (ProjectCostDetail)iterator.next();		
					BillTransactionDetail tr = 
								(BillTransactionDetail)getInsertedRecord("BillTransactionDetail",pcm.getCostcode().longValue(), Constants.TRANSACATION_CATEGORY_OTHER_COST);
							
					if (pcm.getClaimType().equals("CY")) {
						if (tr ==  null) {
							tr = new BillTransactionDetail();
							//Create User
							//HttpSession session = request.getSession();
							//UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
							tr.setTransactionCreateUser(ul);
							tr.setTransactionCreateDate(UtilDateTime.nowTimestamp());
						}
						
						tr.setTransactionRecId(new Long(pcm.getCostcode().longValue()));
						tr.setCurrency(pcm.getCurrency());
						tr.setDesc1(pcm.getFormCode());
						tr.setDesc2(pcm.getProjectCostType().getTypename());
						tr.setAmount(new Double(pcm.getTotalvalue()));
						tr.setExchangeRate(new Double(pcm.getExchangerate()));
						tr.setTransactionDate(pcm.getCostdate());
						tr.setTransactionDate1(pcm.getApprovalDate());
						tr.setProject(pcm.getProjectMaster());
						tr.setTransactionCategory(Constants.TRANSACATION_CATEGORY_OTHER_COST);
						tr.setTransactionUser(pcm.getUserLogin());
						tr.setTransactionParty(pcm.getProjectMaster().getBillTo());
						
						sess.saveOrUpdate(tr);
					} else {
						if (tr !=  null) {
							sess.delete(tr);
						}
					}
					
					//payment
					/*
					if (pcm.getVendor() != null) {
						PaymentTransactionDetail ptd = 
							(PaymentTransactionDetail)getInsertedRecord("PaymentTransactionDetail", 
									pcm.getCostcode().longValue(), Constants.TRANSACATION_CATEGORY_OTHER_COST);
						
						if (ptd ==  null) {
							ptd = new PaymentTransactionDetail();
							ptd.setTransactionCreateUser(ul);
							ptd.setTransactionCreateDate(UtilDateTime.nowTimestamp());
						}
						
						ptd.setTransactionRecId(new Long(pcm.getCostcode().longValue()));
						ptd.setCurrency(pcm.getCurrency());
						ptd.setDesc1(pcm.getFormCode());
						ptd.setDesc2(pcm.getProjectCostType().getTypename());
						ptd.setAmount(new Double(pcm.getTotalvalue()));
						ptd.setExchangeRate(new Double(pcm.getExchangerate()));
						ptd.setTransactionDate(pcm.getCostdate());
						ptd.setTransactionDate1(pcm.getApprovalDate());
						ptd.setProject(pcm.getProjectMaster());
						ptd.setTransactionCategory(Constants.TRANSACATION_CATEGORY_OTHER_COST);
						ptd.setTransactionUser(pcm.getUserLogin());
						ptd.setTransactionParty(pcm.getProjectMaster().getVendor());
						
						sess.saveOrUpdate(ptd);
					}	
					*/
				}
				tx.commit();
			}
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		}
	}
	
	public List getInsertedTS(TimeSheetDetail ts) throws HibernateException {
		Session sess = this.getSession();
		String sqlStr = "select tr from TransacationDetail as tr" +
				" where tr.TransactionRecId = ? " +
				" and (tr.TransactionCategory = ? or tr.TransactionCategory = ?)";
		
		Query query = sess.createQuery(sqlStr);
		query.setInteger(0, ts.getTsId().intValue());
		query.setString(1, Constants.TRANSACATION_CATEGORY_CAF);
		query.setString(2, Constants.TRANSACATION_CATEGORY_ALLOWANCE);
		List list = query.list();
		
		return list;
	}
	
	public TransacationDetail getInsertedRecord(String detailType, long refId, String category) throws HibernateException {
		Session sess = this.getSession();
		String sqlStr = "from " + detailType + " as td where td.TransactionCategory = ? and td.TransactionRecId = ?";
		Query query = sess.createQuery(sqlStr);
		query.setString(0, category);
		query.setLong(1, refId);
		List list = query.list();
		if (list != null && list.size() > 0) {
			return (TransacationDetail)list.get(0);
		}
		
		return null;
	}
	
	public boolean hasPosted(String detailType, long refId, String category) throws HibernateException {
		Session sess = this.getSession();
		String sqlStr = "from " + detailType + " as td " +
				" where td.TransactionCategory = ? " +
				" and td.TransactionRecId = ? " +
				" and td.TransactionMaster is not null";
		Query query = sess.createQuery(sqlStr);
		query.setString(0, category);
		query.setLong(1, refId);
		List list = query.list();
		if (list != null && list.size() > 0) {
			return true;
		}
		
		return false;
	}
	
	public void remove(ServiceType st) {

	}
	
	public void remove(ProjectCostMaster pcm) throws HibernateException {
		Session sess=null;
		Transaction tx = null;
		
		try {
			sess=this.getSession();
			tx = sess.beginTransaction();
			
			BillTransactionDetail tr = 
				(BillTransactionDetail)getInsertedRecord("BillTransactionDetail",
						pcm.getCostcode().longValue(), Constants.TRANSACATION_CATEGORY_OTHER_COST);
			if (tr != null) {
				if (tr.getTransactionMaster() != null) {
					return;
				}
				sess.delete(tr);
			}
			/*
			PaymentTransactionDetail ptd = 
				(PaymentTransactionDetail)getInsertedRecord("PaymentTransactionDetail", 
						pcm.getCostcode().longValue(), Constants.TRANSACATION_CATEGORY_OTHER_COST);
			if (ptd != null) {
				if (ptd.getTransactionMaster() != null) {
					tx.rollback();
					return;
				}
				sess.delete(ptd);
			}
			*/
			
	//		pcm.setApprovalDate(null);
			tx.commit();
		}  catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		}
	}
	
	public List findBillingTransactionList(
			String projectId, String transactionCategory) throws HibernateException {
		try {
			Session session = this.getSession();
			String statement = "  select btd from BillTransactionDetail as btd inner join btd.Project as p" +
					           " where btd.TransactionMaster is null " +
					           "   and (p.projId = ? or p.ProjectLink like ?)";
			if (transactionCategory != null) {
				statement += "   and btd.TransactionCategory = ? ";
			}
			statement += " order by btd.TransactionUser, btd.TransactionDate ";
			
			Query query = session.createQuery(statement);
			query.setString(0, projectId);
			query.setString(1, "%" + projectId + ":%");
			if (transactionCategory != null) {
				query.setString(2, transactionCategory);
			}
			
			List list = query.list();
			
			return list;
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}
	}
	
	public List findPaymentTransactionList(
			String projectId, String transactionCategory) throws HibernateException {
		try {
			Session session = this.getSession();
			String statement = "  from PaymentTransactionDetail as ptd " +
					           " where ptd.TransactionMaster is null " +						
					           "   and ptd.Project.projId = ? ";
			if (transactionCategory != null) {
				statement += "   and ptd.TransactionCategory = ? ";
			}
			
			Query query = session.createQuery(statement);
			query.setString(0, projectId);
			if (transactionCategory != null) {
				query.setString(1, transactionCategory);
			}
			
			List list = query.list();
			
			return list;
			
		} catch (HibernateException e) {
			log.error(e.getMessage());
			throw e;
		}
	}
	
	
	/**
	 * Added for bill checking
	 * @param projectID
	 * @return
	 * @throws HibernateException
	 */
	public void findCheckBillingTransactionList(HttpServletRequest request, String projectID) throws HibernateException{
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		Session session = this.getSession();
//			String statement = "select * from proj_invoice inv, proj_receipt_mstr mst, proj_receipt rec"
//							+  "where inv.inv_proj_id = ? and mst.receipt_no = rec.receipt_no and rec.invoice_id = inv.inv_id";
//			String statement = " from ProjectReceiptMaster mst inner join ProjectReceiptMaster mst on "
//				+	"inner join ProjectReceipt rec on "
//				+  "where inv.ProjectMaster.projId = ?";
		
//			String statement = " from ProjectInvoice inv where Project.projId = ?";
		
//			String statement = "select inv.Project, mstr.customerId, inv.InvoiceCode," 
//				+ " inv.Amount, inv.Status, inv.InvoiceDate, rec.receiveAmount, mstr, inv"
////			String statement = "select mstr, rec, inv"				
//				+ " from ProjectReceiptMaster mstr"
//				+ " inner join ProjectReceipt rec on mstr.receiptNo = rec.receiptNo" 
//				+ " inner join rec.invoice as inv" 
//				+ " where inv.Project.projId = ?";

//	String statement = "select mstr, rec, inv"
//		+ " from ProjectReceiptMaster mstr, ProjectReceipt rec, rec.invoice as inv" 
//		+ " where mstr.receiptNo = rec.receiptNo and inv.Project.projId = ?";
		String statement = "";
		statement += "	select 	mstr.proj_name as proj_name,	";
		statement += "		mstr.proj_id as proj_id,	";
		statement += "		p.DESCRIPTION as cust_name,	";
		statement += "		inv.Inv_Amount as inv_amt,	";
		statement += "		inv.Inv_Code as inv_code,	";
		statement += "		(case when rec.receive_Amount is NULL then 0 else rec.receive_Amount end) as rec_amt	";
		statement += "	from Proj_Invoice inv	"; 
		statement += "		left outer join Proj_Receipt rec on inv.Inv_Id=rec.invoice_Id	";
		statement += "		inner join Proj_Mstr mstr on inv.Inv_Proj_Id=mstr.proj_id	";
		statement += "		inner join PARTY p on p.PARTY_ID=mstr.cust_id	";
		statement += "	where inv.Inv_Proj_Id='"+projectID+"'	";
		statement += "	and inv.Inv_Type='Normal'	";
		statement += "	and inv.Inv_Status<>'Cancelled'	";

		SQLResults result= sqlExec.runQueryCloseCon(statement.toString());
		request.setAttribute("CheckBillingList", result);
	}

	public boolean delete(ExpenseMaster findmaster, UserLogin ul) {

		Session session = null;
		//Transaction tx = null;
		
		try{
		session = this.getSession();
		BillTransactionDetail btr = (BillTransactionDetail)getInsertedRecord(
				"BillTransactionDetail", findmaster.getId().longValue(), Constants.TRANSACATION_CATEGORY_EXPENSE);
		PaymentTransactionDetail ptr = (PaymentTransactionDetail)getInsertedRecord(
				"PaymentTransactionDetail", findmaster.getId().longValue(), Constants.TRANSACATION_CATEGORY_EXPENSE);		
		if(btr != null && ptr != null){
			if(btr.getTransactionMaster() != null || ptr.getTransactionMaster() != null){	//bill & payment
				return false;
			}
			else{
				Iterator itAmt = findmaster.getAmounts().iterator();
				ExpenseAmount ea = null;
				while (itAmt.hasNext()) {
					ea = (ExpenseAmount)itAmt.next();
					if (!ea.getExpType().getExpDesc().equalsIgnoreCase("Allowance") || !findmaster.getClaimType().equals("CY")) {
						ea.setConfirmedAmount(null);
						ea.setPaidAmount(null);
						session.update(ea);
					}
				}
				session.delete(btr);
				session.delete(ptr);
				session.flush();
				return true;
			}
		}else if(btr != null && ptr == null){					//bill
			if(btr.getTransactionMaster() != null)
				return false;
			else{
				Iterator itAmt = findmaster.getAmounts().iterator();
				ExpenseAmount ea = null;
				while (itAmt.hasNext()) {
					ea = (ExpenseAmount)itAmt.next();
					if (!ea.getExpType().getExpDesc().equalsIgnoreCase("Allowance") || !findmaster.getClaimType().equals("CY")) {
						ea.setConfirmedAmount(new Float(0));
						ea.setPaidAmount(new Float(0));
						session.update(ea);
					}
				}
				session.delete(btr);
				session.flush();
				return true;
			}	
		}else
			return false;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
		
	}
}