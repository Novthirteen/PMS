/**
 * Atos Origin China ### All Right Reserved
 */
package com.aof.util;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;

/**
 * @author stanley
 *
 */
public class UtilFormat {

	public UtilFormat() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static SimpleDateFormat getDateFormatter() {
		
		if(dateFormatter == null)
			dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
		return dateFormatter;
	}

	public static NumberFormat getNumFormatter() {
		
		if(numFormatter == null){
			numFormatter = NumberFormat.getInstance();		
			numFormatter.setMaximumFractionDigits(2);
			numFormatter.setMinimumFractionDigits(2);
		}
		return numFormatter;
	}

	public static String format(double number){
		return getNumFormatter().format(number);
	}
	public static String format(Double number){
		if(number == null)
			return null;
		return getNumFormatter().format(number);
	}
	public static String format(java.util.Date date){
		if(date != null)
			return getDateFormatter().format(date);
		else
			return null;	
	}
	private static SimpleDateFormat dateFormatter;
	
	private static NumberFormat numFormatter;

}
