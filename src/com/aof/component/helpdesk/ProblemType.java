/*
 * Created on 2005-2-5
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.component.helpdesk;

import java.io.Serializable;
/**
 * @author Daniel Liao
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ProblemType implements Serializable{
	
	/** The cached hash code value for this instance.  Settting to 0 triggers re-calculation. */
	private int hashValue = 0;
	/**  The composite primary key value. */
	private Integer id;
	/** The composite description*/
	private String desc;
	


//	/**
//	 * Implementation of the equals comparison on the basis of equality of the primary key values.
//	 * @param rhs
//	 * @return boolean
//	 */
//	public boolean equals(Object rhs)
//	{
//		if (rhs == null)
//			return false;
//		if (! (rhs instanceof CallType))
//			return false;
//		CallType that = (CallType) rhs;
//		if (this.getID() != null && that.getType() != null)
//		{
//			if (! this.getID().equals(that.getType()))
//			{
//				return false;
//			}
//		}
//		return true;
//	}
//
//	/**
//	 * Implementation of the hashCode method conforming to the Bloch pattern with
//	 * the exception of array properties (these are very unlikely primary key types).
//	 * @return int
//	 */
//	public int hashCode()
//	{
//		if (this.hashValue == 0)
//		{
//			int result = 17;
//			int typeValue = this.getID() == null ? 0 : this.getID().hashCode();
//			result = result * 37 + typeValue;
//			this.hashValue = result;
//		}
//		return this.hashValue;
//	}

	/**
	 * @return
	 */
	public String getDesc() {
		return desc;
	}

	/**
	 * @return
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * @param string
	 */
	public void setDesc(String string) {
		desc = string;
	}

	/**
	 * @param integer
	 */
	public void setId(Integer integer) {
		id = integer;
	}

}
