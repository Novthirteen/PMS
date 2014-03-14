/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.sales;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.CurrencyType;

/**
 * @author CN01458
 * @version 2005-5-25
 */
public class SalesSheetMaster {
	private Long id;
	private CustomerProfile customer;
	private UserLogin salesman;
	private Double amount;
	private String description;
	private CurrencyType currency;
	private Double exchangeRate;
	private UserLogin createUser;
	private Date createDate;
	private Set details;
	
	/**
	 * @param id
	 * @param customer
	 * @param salesman
	 * @param amount
	 * @param description
	 * @param currency
	 * @param exchangeRate
	 * @param createUser
	 * @param createDate
	 * @param details
	 */
	public SalesSheetMaster(Long id, CustomerProfile customer,
			UserLogin salesman, Double amount, String description,
			CurrencyType currency, Double exchangeRate, UserLogin createUser,
			Date createDate, Set details) {
		super();
		this.id = id;
		this.customer = customer;
		this.salesman = salesman;
		this.amount = amount;
		this.description = description;
		this.currency = currency;
		this.exchangeRate = exchangeRate;
		this.createUser = createUser;
		this.createDate = createDate;
		this.details = details;
	}
	/**
	 * @param id
	 */
	public SalesSheetMaster(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public SalesSheetMaster() {
		super();
	}
	/**
	 * @return Returns the amount.
	 */
	public Double getAmount() {
		return amount;
	}
	/**
	 * @param amount The amount to set.
	 */
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	/**
	 * @return Returns the createDate.
	 */
	public Date getCreateDate() {
		return createDate;
	}
	/**
	 * @param createDate The createDate to set.
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	/**
	 * @return Returns the createUser.
	 */
	public UserLogin getCreateUser() {
		return createUser;
	}
	/**
	 * @param createUser The createUser to set.
	 */
	public void setCreateUser(UserLogin createUser) {
		this.createUser = createUser;
	}
	/**
	 * @return Returns the currency.
	 */
	public CurrencyType getCurrency() {
		return currency;
	}
	/**
	 * @param currency The currency to set.
	 */
	public void setCurrency(CurrencyType currency) {
		this.currency = currency;
	}
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
	/**
	 * @return Returns the description.
	 */
	public String getDescription() {
		return description;
	}
	/**
	 * @param description The description to set.
	 */
	public void setDescription(String description) {
		this.description = description;
	}
	/**
	 * @return Returns the details.
	 */
	public Set getDetails() {
		return details;
	}
	/**
	 * @param details The details to set.
	 */
	public void setDetails(Set details) {
		this.details = details;
	}
	public void addDetail(SalesSheetDetail detail) {
		if (details == null) {
			details = new HashSet();
		}
		
		details.add(detail);
	}
	public void removeDetail(SalesSheetDetail detail) {
		if (details != null) {
			details.remove(detail);
		}
	}
	/**
	 * @return Returns the exchangeRate.
	 */
	public Double getExchangeRate() {
		return exchangeRate;
	}
	/**
	 * @param exchangeRate The exchangeRate to set.
	 */
	public void setExchangeRate(Double exchangeRate) {
		this.exchangeRate = exchangeRate;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the salesman.
	 */
	public UserLogin getSalesman() {
		return salesman;
	}
	/**
	 * @param salesman The salesman to set.
	 */
	public void setSalesman(UserLogin salesman) {
		this.salesman = salesman;
	}
	public String toString() {
        return new ToStringBuilder(this)
            .append("id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof SalesSheetMaster) ) return false;
        SalesSheetMaster castOther = (SalesSheetMaster) other;
        return new EqualsBuilder()
            .append(this.getId(), castOther.getId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
    }
}
