/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.module;

import java.util.Set;
import java.io.Serializable;
/**
 * @author xxp 
 * @version 2003-6-23
 *
 */
public class ModuleGroup implements Serializable {
	private String moduleGroupId;
	private String description;
	private Set modules;
	private int priority;
	/**
	 * @return
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @return
	 */
	public String getModuleGroupId() {
		return moduleGroupId;
	}

	/**
	 * @param string
	 */
	public void setDescription(String string) {
		description = string;
	}

	/**
	 * @param string
	 */
	public void setModuleGroupId(String string) {
		moduleGroupId = string;
	}

	/**
	 * @return
	 */
	public Set getModules() {
		return modules;
	}

	/**
	 * @param set
	 */
	public void setModules(Set set) {
		modules = set;
	}



	/**
	 * @return
	 */
	public int getPriority() {
		return priority;
	}

	/**
	 * @param i
	 */
	public void setPriority(int i) {
		priority = i;
	}

}
