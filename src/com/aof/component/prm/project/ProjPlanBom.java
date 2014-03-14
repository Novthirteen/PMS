package com.aof.component.prm.project;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

import com.aof.component.domain.party.Party;

public class ProjPlanBom implements Serializable{

	private long id;
	private String stepdesc;
	private String document;
	private String enable;
	private Date start_time ;
	private Date end_time;
	private String ranking;
	private ProjPlanBom parent;
	private Party department;
	private List children;
	private String rev_confirm;
	private String status;
	private ProjPlanBomMaster master;
	private String predecessor;
	private Set types;
	public Set getTypes() {
		return types;
	}
	public void setTypes(Set types) {
		if(types==null)
			this.types = new HashSet();
		this.types = types;
	}
	public void addType(ProjPlanBOMST type)
	{
		if(this.types==null)
			types = new HashSet();
		types.add(type);
	}
	public void removeType(ProjPlanBOMST type)
	{
		if(this.types!=null)
			return;
		types.remove(type);
			
	}
	public void setChildren(List children) {
		this.children = children;
	}
	public String getRev_confirm() {
		return rev_confirm;
	}
	public void setRev_confirm(String rev_confirm) {
		this.rev_confirm = rev_confirm;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public void addChild(ProjPlanBom bom)
	{
		if(children==null)
			children =new LinkedList();
		this.children.add(bom);
	}
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

	public ProjPlanBom getParent() {
		return parent;
	}
	public void setParent(ProjPlanBom parent) {
		this.parent = parent;
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
	public String getDocument() {
		return document;
	}
	public void setDocument(String document) {
		this.document = document;
	}
	public String getEnable() {
		return enable;
	}
	public void setEnable(String enable) {
		this.enable = enable;
	}
	public Date getEnd_time() {
		return end_time;
	}
	public void setEnd_time(Date end_time) {
		this.end_time = end_time;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public Date getStart_time() {
		return start_time;
	}
	public void setStart_time(Date start_time) {
		this.start_time = start_time;
	}
	public Party getDepartment() {
		return department;
	}
	public void setDepartment(Party department) {
		this.department = department;
	}
	public ProjPlanBomMaster getMaster() {
		return master;
	}
	public void setMaster(ProjPlanBomMaster master) {
		this.master = master;
	}
	public boolean equals(Object other) {
		if ( !(other instanceof ProjPlanBom) ) return false;
		ProjPlanBom castOther = (ProjPlanBom) other;
		return new EqualsBuilder()
			.append(this.getId(), castOther.getId())
			.isEquals();
	}

	public int hashCode() {
		return new HashCodeBuilder()
			.append(getId())
			.toHashCode();
	}
	public String getPredecessor() {
		return predecessor;
	}
	public void setPredecessor(String predecessor) {
		this.predecessor = predecessor;
	}


}
