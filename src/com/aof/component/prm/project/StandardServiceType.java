package com.aof.component.prm.project;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

import com.aof.component.domain.party.Party;

public class StandardServiceType {
private long id;
private Party customer;
private double rate;
private String description;
private CurrencyType currency;
public Party getCustomer() {
	return customer;
}
public void setCustomer(Party customer) {
	this.customer = customer;
}
public String getDescription() {
	return description;
}
public void setDescription(String descritpion) {
	this.description = descritpion;
}
public long getId() {
	return id;
}
public void setId(long id) {
	this.id = id;
}
public double getRate() {
	return rate;
}
public void setRate(double rate) {
	this.rate = rate;
}
public CurrencyType getCurrency() {
	return currency;
}
public void setCurrency(CurrencyType currency) {
	this.currency = currency;
}
public boolean equals(Object other) {
	if ( !(other instanceof StandardServiceType) ) return false;
	StandardServiceType castOther = (StandardServiceType) other;
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
