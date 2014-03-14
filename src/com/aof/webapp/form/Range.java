/*
 * Created on 2004-11-10
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form;

/**
 * @author shilei
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
import java.io.Serializable;

public class Range implements Serializable {
	Comparable minValue;

	Comparable maxValue;

	public Range(Comparable minValue, Comparable maxValue) {
		setMinValue(minValue);
		setMaxValue(maxValue);
	}

	public Comparable getMinValue() {
		return minValue;
	}

	public void setMinValue(Comparable minValue) {
		this.minValue = minValue;
	}

	public Comparable getMaxValue() {
		return maxValue;
	}

	public void setMaxValue(Comparable maxValue) {
		this.maxValue = maxValue;
	}

	boolean isInRange(Comparable value) {
		if (value == null)
			return false;
		if ((minValue == null || value.compareTo(minValue) >= 0)
				&& (maxValue == null || value.compareTo(maxValue) <= 0))
			return true;
		return false;
	}
}