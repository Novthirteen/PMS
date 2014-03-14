/*
 * Created on 2004-11-12
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

import java.util.ArrayList;
import java.util.List;

import net.sf.hibernate.PersistentEnum;

/**
 * @author shilei
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Status implements PersistentEnum {

	private final int code;
	private final int level;
	private final boolean enabled;
	private final String desc;

	
	
	public Status(int code,int level,boolean enabled,String desc) {
		this.code = code;
		this.level=level;
		this.enabled=enabled;
		this.desc=desc;
	}
	
	/**
	 * @return Returns the statusList.
	 */
	public static List getStatusList() {
		List list=new ArrayList();
		for(int i=0;i<statusList.length;i++)
		{
			if (statusList[i].enabled==true) 
				list.add(statusList[i]);
		}
		return list;
	}
	
	
	/**
	 * @return Returns the statusList.
	 */
	public static List getAllStatusList() {

		List list=new ArrayList();
		for(int i=0;i<statusList.length;i++)
		{
				list.add(statusList[i]);
		}

		return list;
		
	}
	
	/**
	 * @return Returns the code.
	 */
	public int getCode() {
		return code;
	}
	
	
	/**
	 * @return Returns the desc.
	 */
	public String getDesc() {
		return desc;
	}
	
	
	/**
	 * @return Returns the enabled.
	 */
	public boolean isEnabled() {
		return enabled;
	}
	/**
	 * @return Returns the level.
	 */
	public int getLevel() {
		return level;
	}
	
	public static final Status WIP = new Status(0,0,true,"wip");
	public static final Status L_RESPONSE = new Status(1,1,true,"l_response");
	public static final Status CUSTOMER_RESPONSE = new Status(2,1,true,"CUSTOMER_RESPONSE");
	public static final Status SOLVED = new Status(3,2,true,"SOLVED");
	public static final Status CLOSED = new Status(4,3,true,"CLOSED");

	private static final Status[] statusList={
		WIP,
		L_RESPONSE,
		CUSTOMER_RESPONSE,
		SOLVED,
		CLOSED
	};
	public int toInt() {
		return code;
	}

	public static Status fromInt(int code) {
		return statusList[code];
	}

}