/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.contract;

import com.aof.component.crm.customer.CustomerProfile;

/**
 * @author CN01458
 * @version 2005-6-21
 */
public class ContractProfile extends BaseContract {
	private CustomerProfile customer;
	/**
	 * @return Returns the customer.
	 */
	public CustomerProfile getCustomer() {
		return customer;
	}
	/**
	 * @param customer The customer to set.
	 */
	public void setCustomer(CustomerProfile customer) {
		this.customer = customer;
	}
}
