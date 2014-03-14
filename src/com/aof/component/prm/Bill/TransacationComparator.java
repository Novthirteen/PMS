/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.Bill;

import java.util.Comparator;

/**
 * @author CN01458
 * @version 2005-5-17
 */
public class TransacationComparator implements Comparator {

	/* (non-Javadoc)
	 * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
	 */
	public int compare(Object arg0, Object arg1) {
		
		if (arg0 instanceof TransacationDetail
				&& arg1 instanceof TransacationDetail) {
			TransacationDetail t0 = (TransacationDetail)arg0;
			TransacationDetail t1 = (TransacationDetail)arg1;
			
			int result = t0.getTransactionUser().getName().compareTo(t1.getTransactionUser().getName());
			if (result != 0) {
				return result;
			} else {
				return t0.getTransactionDate().compareTo(t1.getTransactionDate());
			}
		}
		
		return 0;
	}

}
