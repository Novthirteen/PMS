/*
 * Created on 2004-11-10
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form;

import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class DateFormatter extends Formatter {
	
	/**
	 * @param type
	 */
	public DateFormatter(Class type) {
		super(type);
	}

	protected Object unformat(String string) 
	{
		SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
		ParsePosition pos = new ParsePosition(0);
		Date formatDate = formatter.parse(string, pos);
		String s=formatter.format(formatDate);
		if(!s.equals(string))
		{
			throw new FormattingException("Data format error");
		}
		return formatDate;
	}
	public String getErrorKey()
	{
		return ERROR_KEY;
	}
	private static final String ERROR_KEY="Data format error";
}
