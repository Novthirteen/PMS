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
public class Module implements Serializable {
	private String moduleId; 
	private String moduleName;
	private String moduleImage;
	private String requestPath;
	private String visbale;
	private String description;
	private Integer priority;
	
	private Set modules;
		
	/**
	 * @return
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @return
	 */
	public String getModuleId() {
		return moduleId;
	}

	/**
	 * @return
	 */
	public String getModuleImage() {
		return moduleImage;
	}

	/**
	 * @return
	 */
	public String getModuleName() {
		return moduleName;
	}

	/**
	 * @return
	 */
	public Set getModules() {
		return modules;
	}

	/**
	 * @return
	 */
	public String getRequestPath() {
		return requestPath;
	}

	/**
	 * @return
	 */
	public String getVisbale() {
		return visbale;
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
	public void setModuleId(String string) {
		moduleId = string;
	}

	/**
	 * @param string
	 */
	public void setModuleImage(String string) {
		moduleImage = string;
	}

	/**
	 * @param string
	 */
	public void setModuleName(String string) {
		moduleName = string;
	}

	/**
	 * @param set
	 */
	public void setModules(Set set) {
		modules = set;
	}

	/**
	 * @param string
	 */
	public void setRequestPath(String string) {
		requestPath = string;
	}

	/**
	 * @param string
	 */
	public void setVisbale(String string) {
		visbale = string;
	}

	/**
	 * @return
	 */
	public Integer getPriority() {
		return priority;
	}

	/**
	 * @param string
	 */
	public void setPriority(Integer integer) {
		priority = integer;
	}

}
