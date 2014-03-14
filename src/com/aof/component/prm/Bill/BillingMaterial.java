/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.Bill;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.prm.project.Material;

public class BillingMaterial extends Material {
	private CustomerProfile billTo;
	private ProjectBill billling;
	/**
	 * @return Returns the billling.
	 */
	public ProjectBill getBillling() {
		return billling;
	}
	/**
	 * @param billling The billling to set.
	 */
	public void setBillling(ProjectBill billling) {
		this.billling = billling;
	}
	/**
	 * @return Returns the billTo.
	 */
	public CustomerProfile getBillTo() {
		return billTo;
	}
	/**
	 * @param billTo The billTo to set.
	 */
	public void setBillTo(CustomerProfile billTo) {
		this.billTo = billTo;
	}
	
}
