package com.aof.component.crm.vendor;

import com.aof.component.domain.party.Party;

/** @author Hibernate CodeGenerator */
public class VendorProfile extends Party {

	/** nullable persistent field */
    private String ChineseName;
    /** nullable persistent field */
    private String bankNo;
    /** nullable persistent field */
    private String taxNo;
    
    /** nullable persistent field */
    private VendorType CategoryType;
    private String AccountCode;
    public String getAccountCode() {
		return AccountCode;
	}

	public void setAccountCode(String accountCode) {
		AccountCode = accountCode;
	}
    /** default constructor */
    public VendorProfile() {
    }
	/**
	 * @return Returns the categoryType.
	 */
	public VendorType getCategoryType() {
		return CategoryType;
	}
	/**
	 * @param categoryType The categoryType to set.
	 */
	public void setCategoryType(VendorType categoryType) {
		CategoryType = categoryType;
	}
	/**
	 * @return Returns the chineseName.
	 */
	public String getChineseName() {
		return ChineseName;
	}
	/**
	 * @param chineseName The chineseName to set.
	 */
	public void setChineseName(String chineseName) {
		ChineseName = chineseName;
	}
	
	/**
	 * @return Returns the bankNo.
	 */
	public String getBankNo() {
		return bankNo;
	}
	/**
	 * @param bankNo The bankNo to set.
	 */
	public void setBankNo(String bankNo) {
		this.bankNo = bankNo;
	}
	/**
	 * @return Returns the taxNo.
	 */
	public String getTaxNo() {
		return taxNo;
	}
	/**
	 * @param taxNo The taxNo to set.
	 */
	public void setTaxNo(String taxNo) {
		this.taxNo = taxNo;
	}
}
