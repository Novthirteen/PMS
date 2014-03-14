package com.aof.component.prm.payment;

import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.prm.Bill.TransacationDetail;

public class PaymentTransactionDetail extends TransacationDetail {
	private ProjectPayment TransactionMaster;
	
	private VendorProfile TransactionParty;
	
	public ProjectPayment getTransactionMaster() {
		return this.TransactionMaster;
	}

	public void setTransactionMaster(ProjectPayment TransactionMaster) {
		this.TransactionMaster = TransactionMaster;
	}
	/**
	 * @return Returns the transactionParty.
	 */
	public VendorProfile getTransactionParty() {
		return TransactionParty;
	}
	/**
	 * @param transactionParty The transactionParty to set.
	 */
	public void setTransactionParty(VendorProfile transactionParty) {
		TransactionParty = transactionParty;
	}
}