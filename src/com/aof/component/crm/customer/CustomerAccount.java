package com.aof.component.crm.customer;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class CustomerAccount implements Serializable {

    /** identifier field */
    private Long AccountId;

    /** nullable persistent field */
    private String Description;
	private String Abbreviation;
	private String Type;

    /** full constructor */
    public CustomerAccount(java.lang.String Description) {
        this.Description = Description;
    }

    /** default constructor */
    public CustomerAccount() {
    }

    public Long getAccountId() {
        return this.AccountId;
    }
	public void setAccountId(Long AccountId) {
		this.AccountId = AccountId;
	}

    public java.lang.String getDescription() {
        return this.Description;
    }
	public void setDescription(java.lang.String Description) {
		this.Description = Description;
	}
	
	public String getAbbreviation() {
		return this.Abbreviation;
	}
	public void setAbbreviation(String Abbreviation) {
		this.Abbreviation = Abbreviation;
	}
	
	public String getType() {
		return this.Type;
	}
	public void setType(String Type) {
		this.Type = Type;
	}
	
    public String toString() {
        return new ToStringBuilder(this)
            .append("AccountId", getAccountId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof CustomerAccount) ) return false;
        CustomerAccount castOther = (CustomerAccount) other;
        return new EqualsBuilder()
            .append(this.getAccountId(), castOther.getAccountId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getAccountId())
            .toHashCode();
    }

}
