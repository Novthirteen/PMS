package com.aof.webapp.action.prm.projectmanager;

import java.util.LinkedList;
import java.util.List;

public class ProjectBOMBean {
	
	//for standard BOM
	private long std_id;
	private String std_desc;
	private String std_rank;
	
	//for actual project BOM
	private long bom_id;
	private String bom_desc;
	private String bom_rank;
	
	private List child;
	
	public String getBom_desc() {
		return bom_desc;
	}

	public void setBom_desc(String bom_desc) {
		this.bom_desc = bom_desc;
	}

	public long getBom_id() {
		return bom_id;
	}

	public void setBom_id(long bom_id) {
		this.bom_id = bom_id;
	}

	public String getBom_rank() {
		return bom_rank;
	}

	public void setBom_rank(String bom_rank) {
		this.bom_rank = bom_rank;
	}

	public List getChild() {
		return child;
	}

	public void setChild(List child) {
		this.child = child;
	}

	public String getStd_desc() {
		return std_desc;
	}

	public void setStd_desc(String std_desc) {
		this.std_desc = std_desc;
	}

	public long getStd_id() {
		return std_id;
	}

	public void setStd_id(long std_id) {
		this.std_id = std_id;
	}

	public String getStd_rank() {
		return std_rank;
	}

	public void setStd_rank(String std_rank) {
		this.std_rank = std_rank;
	}
	
	public void addChild(ProjectBOMBean bean)
	{
		if(this.child==null)
			this.child = new LinkedList();
		this.child.add(bean);
	}
	
	public void removeChild(ProjectBOMBean bean)
	{
		if(this.child==null)
			this.child = new LinkedList();
		else
			this.child.remove(bean);
	}
	

}
