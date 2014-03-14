package com.aof.component.prm.project;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;

public class ProjPlanType implements Serializable{
	private long id;
	
	private Long bom_id;

	private String description;

	private double STRate;
	
	private CurrencyType currency;

	private SalaryLevel sl;

	private CustomerProfile customer;

	private UserLogin staff;
	
	private String tax;

	private Set types;

	private ProjPlanType parent;

	private double indirectRate;

	private double nhrRevenue;

	private double codingSubContr;

	private Set children;

	public void addChild(ProjPlanType type) {
		if (this.children == null)
			this.children = new HashSet();
		this.children.add(type);
	}

	public Set getChildren() {
		if (this.children == null)
			this.children = new HashSet();
		return children;
	}

	public void setChildren(Set children) {
		this.children = children;
	}

	public Set getTypes() {
		if (types == null)
			types = new HashSet();
		return types;
	}

	public void setTypes(Set types) {
		this.types = types;
	}

	public void addType(ProjPlanBOMST type) {
		if (types == null)
			this.types = new HashSet();
		this.types.add(type);
	}

	public void removeType(ProjPlanBOMST type) {
		if (types == null)
			return;
		this.types.remove(type);
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String type) {
		this.description = type;
	}

	public CustomerProfile getCustomer() {
		return customer;
	}

	public void setCustomer(CustomerProfile customer) {
		this.customer = customer;
	}

	public SalaryLevel getSl() {
		return sl;
	}

	public void setSl(SalaryLevel sl) {
		this.sl = sl;
	}

	public double getSTRate() {
		return STRate;
	}

	public void setSTRate(double rate) {
		STRate = rate;
	}
/*
	public ProjPlanBomMaster getMaster() {
		return master;
	}

	public void setMaster(ProjPlanBomMaster master) {
		this.master = master;
	}
*/
	public ProjPlanType getParent() {
		return parent;
	}

	public void setParent(ProjPlanType parent) {
		this.parent = parent;
	}

	public UserLogin getStaff() {
		return staff;
	}

	public void setStaff(UserLogin staff) {
		this.staff = staff;
	}

	public double getCodingSubContr() {
		return codingSubContr;
	}

	public void setCodingSubContr(double codingSubContr) {
		this.codingSubContr = codingSubContr;
	}

	public double getIndirectRate() {
		return indirectRate;
	}

	public void setIndirectRate(double indirectRate) {
		this.indirectRate = indirectRate;
	}

	public double getNhrRevenue() {
		return nhrRevenue;
	}

	public void setNhrRevenue(double nhrRevenue) {
		this.nhrRevenue = nhrRevenue;
	}

	public Long getBom_id() {
		return bom_id;
	}

	public void setBom_id(Long bom_id) {
		this.bom_id = bom_id;
	}

	public CurrencyType getCurrency() {
		return currency;
	}

	public void setCurrency(CurrencyType currency) {
		this.currency = currency;
	}

	public String getTax() {
		return tax;
	}

	public void setTax(String tax) {
		this.tax = tax;
	}

	public boolean equals(Object other) {
		if ( !(other instanceof ProjPlanType) ) return false;
		ProjPlanType castOther = (ProjPlanType) other;
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
