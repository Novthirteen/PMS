/*
 * Created on 2004-11-10
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form;

import java.util.Date;

import org.apache.commons.beanutils.locale.LocaleConvertUtils;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Formatter {
	/**
	 * @param type
	 */
	
	public static void main(String args[]) {
		Formatter f=Formatter.getFormatter(Date.class);
	}
	
	public Formatter(Class type) {
		
		clazz=type;
	}
	public static Formatter getFormatter(Class type) {
		if (Date.class.isAssignableFrom(type))
		{
			return new DateFormatter(type);
		} else 
			return new Formatter(type);
	}
	protected Class clazz;
	
	
	
	protected String format(Object target) {
		return target == null ? "" : target.toString();
	}
	protected Object unformat(String string) 
	{
		return LocaleConvertUtils.convert(string,clazz);
		//throw new UnsupportedOperationException();
	}
	public String getErrorKey()
	{
		throw new UnsupportedOperationException();
	}
}
