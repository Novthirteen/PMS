/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.contract;

import com.aof.component.crm.vendor.VendorProfile;

/**
 * @author CN01458
 * @version 2005-6-21
 */
public class POProfile extends BaseContract {
	private VendorProfile vendor;
	private ContractProfile linkProfile;
	/**
	 * @return Returns the vendor.
	 */
	public VendorProfile getVendor() {
		return vendor;
	}
	/**
	 * @param vendor The vendor to set.
	 */
	public void setVendor(VendorProfile vendor) {
		this.vendor = vendor;
	}
	/**
	 * @return Returns the linkProfile.
	 */
	public ContractProfile getLinkProfile() {
		return linkProfile;
	}
	/**
	 * @param linkProfile The linkProfile to set.
	 */
	public void setLinkProfile(ContractProfile linkProfile) {
		this.linkProfile = linkProfile;
	}
}
