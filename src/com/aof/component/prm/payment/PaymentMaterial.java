/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.payment;

import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.prm.project.Material;

public class PaymentMaterial extends Material {
	private VendorProfile vender;
	private ProjectPayment payment;
	/**
	 * @return Returns the payment.
	 */
	public ProjectPayment getPayment() {
		return payment;
	}
	/**
	 * @param payment The payment to set.
	 */
	public void setPayment(ProjectPayment payment) {
		this.payment = payment;
	}
	/**
	 * @return Returns the vender.
	 */
	public VendorProfile getVender() {
		return vender;
	}
	/**
	 * @param vender The vender to set.
	 */
	public void setVender(VendorProfile vender) {
		this.vender = vender;
	}
	
}
