package com.aof.component.prm.project;

import java.io.Serializable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;


public class ProjPlanBOMST implements Serializable{
	private long id;
	private ProjPlanBom bom;
	private ProjPlanType type;
	private double manday;
	private ProjPlanBomMaster master;
	
	public ProjPlanBom getBom() {
		return bom;
	}
	public void setBom(ProjPlanBom bom) {
		this.bom = bom;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	
	
	public double getManday() {
		return manday;
	}
	public void setManday(double manday) {
		this.manday = manday;
	}
	public ProjPlanType getType() {
		return type;
	}
	public void setType(ProjPlanType type) {
		this.type = type;
	}
	public ProjPlanBomMaster getMaster() {
		return master;
	}
	public void setMaster(ProjPlanBomMaster master) {
		this.master = master;
	}
	public boolean equals(Object other) {
		if ( !(other instanceof ProjPlanBOMST) ) return false;
		ProjPlanBOMST castOther = (ProjPlanBOMST) other;
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
