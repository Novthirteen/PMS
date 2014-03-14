/*
 * Created on 2005-6-3
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.report;

import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AFCustomer {
	private Set forcastCustomerSet;
	private Set actualCustomerSet;
	
	/**
	 * @return Returns the actualCustomerSet.
	 */
	public Set getActualCustomerSet() {
		return actualCustomerSet;
	}
	/**
	 * @param actualCustomerSet The actualCustomerSet to set.
	 */
	public void setActualCustomerSet(Set actualCustomerSet) {
		this.actualCustomerSet = actualCustomerSet;
	}
	/**
	 * @return Returns the forcastCustomerSet.
	 */
	public Set getForcastCustomerSet() {
		return forcastCustomerSet;
	}
	/**
	 * @param forcastCustomerSet The forcastCustomerSet to set.
	 */
	public void setForcastCustomerSet(Set forcastCustomerSet) {
		this.forcastCustomerSet = forcastCustomerSet;
	}
	public void addForcastCustomer(String customer) {
		if (forcastCustomerSet == null) {
			forcastCustomerSet = new HashSet();
		}
		
		forcastCustomerSet.add(customer);
	}
	public void addActualCustomer(String customer) {
		if (actualCustomerSet == null) {
			actualCustomerSet = new HashSet();
		}
		
		actualCustomerSet.add(customer);
	}
}
