/*
 * Created on 2004-11-13
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ContactInfo {
	/*
	    <component name="contactInfo" class="ContactInfo">
        	<property name="companyName" column="CM_Customer" type="java.lang.String" />
	        <property name="contactName" column="CM_Contact" type="java.lang.String" />
	        <property name="teleCode" column="CM_Tele_Code" type="java.lang.String" />
	        <property name="email" column="CM_Email" type="java.lang.String" />
	        <property name="fax" column="CM_Fax" type="java.lang.String" />
	        <property name="mobileCode" column="CM_Mobile_Code" type="java.lang.String" />
	        <property name="province" column="CM_Province" type="java.lang.String" />
        </component>
	 */
	private String companyName;
	private String contactName;
	private String teleCode;
	private String email;
	private String fax;
	private String mobileCode;
	private String province;
	

	/**
	 * @return Returns the companyName.
	 */
	public String getCompanyName() {
		return companyName;
	}
	/**
	 * @param companyName The companyName to set.
	 */
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	/**
	 * @return Returns the contactName.
	 */
	public String getContactName() {
		return contactName;
	}
	/**
	 * @param contactName The contactName to set.
	 */
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}
	/**
	 * @return Returns the email.
	 */
	public String getEmail() {
		return email;
	}
	/**
	 * @param email The email to set.
	 */
	public void setEmail(String email) {
		this.email = email;
	}
	/**
	 * @return Returns the fax.
	 */
	public String getFax() {
		return fax;
	}
	/**
	 * @param fax The fax to set.
	 */
	public void setFax(String fax) {
		this.fax = fax;
	}
	/**
	 * @return Returns the mobileCode.
	 */
	public String getMobileCode() {
		return mobileCode;
	}
	/**
	 * @param mobileCode The mobileCode to set.
	 */
	public void setMobileCode(String mobileCode) {
		this.mobileCode = mobileCode;
	}
	/**
	 * @return Returns the province.
	 */
	public String getProvince() {
		return province;
	}
	/**
	 * @param province The province to set.
	 */
	public void setProvince(String province) {
		this.province = province;
	}
	/**
	 * @return Returns the teleCode.
	 */
	public String getTeleCode() {
		return teleCode;
	}
	/**
	 * @param teleCode The teleCode to set.
	 */
	public void setTeleCode(String teleCode) {
		this.teleCode = teleCode;
	}
}
