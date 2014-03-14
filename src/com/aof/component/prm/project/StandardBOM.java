package com.aof.component.prm.project;

import java.util.*;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

public class StandardBOM {
	private long id;
	private StandardBOMMaster master;
	private String stepdesc;
	private String ranking;
	private StandardBOM parent;
	private List children;
	public void addChild(StandardBOM bom)
	{
		if(children==null)
			children =new LinkedList();
		this.children.add(bom);
	}
	
	public List getChildren()
	{
		return children;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getRanking() {
		return ranking;
	}

	public void setRanking(String ranking) {
		this.ranking = ranking;
	}

	public String getStepdesc() {
		return stepdesc;
	}

	public void setStepdesc(String stepdesc) {
		this.stepdesc = stepdesc;
	}

	public void setChildren(List children) {
		this.children = children;
	}
	public StandardBOM getParent() {
		return parent;
	}

	public void setParent(StandardBOM parent) {
		this.parent = parent;
	}

	public StandardBOMMaster getMaster() {
		return master;
	}

	public void setMaster(StandardBOMMaster master) {
		this.master = master;
	}

	public boolean equals(Object other) {
		if ( !(other instanceof StandardBOM) ) return false;
		StandardBOM castOther = (StandardBOM) other;
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
