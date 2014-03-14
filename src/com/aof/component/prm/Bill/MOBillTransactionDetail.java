package com.aof.component.prm.Bill;

import com.aof.component.crm.customer.CustomerProfile;

public class MOBillTransactionDetail extends MOTransactionDetail{

	private ProjectBill TransactionMaster;
	
	private CustomerProfile TransactionParty;
	
	public ProjectBill getTransactionMaster() {
		return this.TransactionMaster;
	}

	public void setTransactionMaster(ProjectBill TransactionMaster) {
		this.TransactionMaster = TransactionMaster;
	}
	/**
	 * @return Returns the transactionParty.
	 */
	public CustomerProfile getTransactionParty() {
		return TransactionParty;
	}
	/**
	 * @param transactionParty The transactionParty to set.
	 */
	public void setTransactionParty(CustomerProfile transactionParty) {
		TransactionParty = transactionParty;
	}
}
