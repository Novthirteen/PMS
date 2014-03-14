/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
/**
 * @author xxp 
 * @version 2003-7-17
 *
 */
public class UtilDateTime {  

	/** Return a Timestamp for right now
	 * @return Timestamp for right now
	 */
	public static java.sql.Timestamp nowTimestamp() {
		return new java.sql.Timestamp(System.currentTimeMillis());
	}

	/** Return a Date for right now
	 * @return Date for right now
	 */
	public static java.util.Date nowDate() {
		return new java.util.Date();
	}
	
	public static java.sql.Timestamp getDayStart(java.util.Date OriginalDate, int daysLater) {
		return getDayStart(new java.sql.Timestamp(OriginalDate.getTime()), daysLater);
	}

	public static java.sql.Timestamp getDayStart(java.sql.Timestamp stamp) {
		return getDayStart(stamp, 0);
	}
	
	public static java.sql.Timestamp getDayStart(java.sql.Timestamp stamp, int daysLater) {
		Calendar tempCal = Calendar.getInstance();

		tempCal.setTime(new java.util.Date(stamp.getTime()));
		tempCal.set(tempCal.get(Calendar.YEAR), tempCal.get(Calendar.MONTH), tempCal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		tempCal.add(Calendar.DAY_OF_MONTH, daysLater);
		
		java.sql.Timestamp start = new java.sql.Timestamp(tempCal.getTime().getTime());
		start.setNanos(0);
		return start;
	}

	public static java.sql.Timestamp getNextDayStart(java.sql.Timestamp stamp) {
		return getDayStart(stamp, 1);
	}

	public static java.sql.Timestamp getDayEnd(java.util.Date OriginalDate, int daysLater) {
		return getDayEnd(new java.sql.Timestamp(OriginalDate.getTime()), daysLater);
	}

	public static java.sql.Timestamp getDayEnd(java.sql.Timestamp stamp) {
		return getDayEnd(stamp, 0);
	}
		
	public static java.sql.Timestamp getDayEnd(java.sql.Timestamp stamp, int daysLater) {
		Calendar tempCal = Calendar.getInstance();

		tempCal.setTime(new java.util.Date(stamp.getTime()));
		tempCal.set(tempCal.get(Calendar.YEAR), tempCal.get(Calendar.MONTH), tempCal.get(Calendar.DAY_OF_MONTH), 23, 59, 59);
		tempCal.add(Calendar.DAY_OF_MONTH, daysLater);
		java.sql.Timestamp endDate = new java.sql.Timestamp(tempCal.getTime().getTime()); 
		endDate.setNanos(0);
		return endDate;
	}

	/** Converts a date String into a java.sql.Date
	 * @param date The date String: MM/DD/YYYY
	 * @return A java.sql.Date made from the date String
	 */
	public static java.sql.Date toSqlDate(String date) {
		java.util.Date newDate = toDate(date, "00:00:00");

		if (newDate != null)
			return new java.sql.Date(newDate.getTime());
		else
			return null;
	}

	/** Makes a java.sql.Date from separate Strings for month, day, year
	 * @param monthStr The month String
	 * @param dayStr The day String
	 * @param yearStr The year String
	 * @return A java.sql.Date made from separate Strings for month, day, year
	 */
	public static java.sql.Date toSqlDate(String monthStr, String dayStr, String yearStr) {
		java.util.Date newDate = toDate(monthStr, dayStr, yearStr, "0", "0", "0");

		if (newDate != null)
			return new java.sql.Date(newDate.getTime());
		else
			return null;
	}

	/** Makes a java.sql.Date from separate ints for month, day, year
	 * @param month The month int
	 * @param day The day int
	 * @param year The year int
	 * @return A java.sql.Date made from separate ints for month, day, year
	 */
	public static java.sql.Date toSqlDate(int month, int day, int year) {
		java.util.Date newDate = toDate(month, day, year, 0, 0, 0);

		if (newDate != null)
			return new java.sql.Date(newDate.getTime());
		else
			return null;
	}

	/** Converts a time String into a java.sql.Time
	 * @param time The time String: either HH:MM or HH:MM:SS
	 * @return A java.sql.Time made from the time String
	 */
	public static java.sql.Time toSqlTime(String time) {
		java.util.Date newDate = toDate("1/1/1970", time);

		if (newDate != null)
			return new java.sql.Time(newDate.getTime());
		else
			return null;
	}

	/** Makes a java.sql.Time from separate Strings for hour, minute, and second.
	 * @param hourStr The hour String
	 * @param minuteStr The minute String
	 * @param secondStr The second String
	 * @return A java.sql.Time made from separate Strings for hour, minute, and second.
	 */
	public static java.sql.Time toSqlTime(String hourStr, String minuteStr, String secondStr) {
		java.util.Date newDate = toDate("0", "0", "0", hourStr, minuteStr, secondStr);

		if (newDate != null)
			return new java.sql.Time(newDate.getTime());
		else
			return null;
	}

	/** Makes a java.sql.Time from separate ints for hour, minute, and second.
	 * @param hour The hour int
	 * @param minute The minute int
	 * @param second The second int
	 * @return A java.sql.Time made from separate ints for hour, minute, and second.
	 */
	public static java.sql.Time toSqlTime(int hour, int minute, int second) {
		java.util.Date newDate = toDate(0, 0, 0, hour, minute, second);

		if (newDate != null)
			return new java.sql.Time(newDate.getTime());
		else
			return null;
	}

	/** Converts a date and time String into a Timestamp
	 * @param dateTime A combined data and time string in the format "MM/DD/YYYY HH:MM:SS", the seconds are optional
	 * @return The corresponding Timestamp
	 */
	public static java.sql.Timestamp toTimestamp(String dateTime) {
		java.util.Date newDate = toDate(dateTime);

		if (newDate != null)
			return new java.sql.Timestamp(newDate.getTime());
		else
			return null;
	}

	/** Converts a date String and a time String into a Timestamp
	 * @param date The date String: MM/DD/YYYY
	 * @param time The time String: either HH:MM or HH:MM:SS
	 * @return A Timestamp made from the date and time Strings
	 */
	public static java.sql.Timestamp toTimestamp(String date, String time) {
		java.util.Date newDate = toDate(date, time);

		if (newDate != null)
			return new java.sql.Timestamp(newDate.getTime());
		else
			return null;
	}

	/** Makes a Timestamp from separate Strings for month, day, year, hour, minute, and second.
	 * @param monthStr The month String
	 * @param dayStr The day String
	 * @param yearStr The year String
	 * @param hourStr The hour String
	 * @param minuteStr The minute String
	 * @param secondStr The second String
	 * @return A Timestamp made from separate Strings for month, day, year, hour, minute, and second.
	 */
	public static java.sql.Timestamp toTimestamp(String monthStr, String dayStr, String yearStr, String hourStr,
		String minuteStr, String secondStr) {
		java.util.Date newDate = toDate(monthStr, dayStr, yearStr, hourStr, minuteStr, secondStr);

		if (newDate != null)
			return new java.sql.Timestamp(newDate.getTime());
		else
			return null;
	}

	/** Makes a Timestamp from separate ints for month, day, year, hour, minute, and second.
	 * @param month The month int
	 * @param day The day int
	 * @param year The year int
	 * @param hour The hour int
	 * @param minute The minute int
	 * @param second The second int
	 * @return A Timestamp made from separate ints for month, day, year, hour, minute, and second.
	 */
	public static java.sql.Timestamp toTimestamp(int month, int day, int year, int hour, int minute, int second) {
		java.util.Date newDate = toDate(month, day, year, hour, minute, second);

		if (newDate != null)
			return new java.sql.Timestamp(newDate.getTime());
		else
			return null;
	}

	/** Converts a date and time String into a Date
	 * @param dateTime A combined data and time string in the format "MM/DD/YYYY HH:MM:SS", the seconds are optional
	 * @return The corresponding Date
	 */
	public static java.util.Date toDate(String dateTime) {
		// dateTime must have one space between the date and time...
		String date = dateTime.substring(0, dateTime.indexOf(" "));
		String time = dateTime.substring(dateTime.indexOf(" ") + 1);

		return toDate(date, time);
	}
	
	public static java.util.Date toDate2 (String date){
		try{
			if(date == null) return null;
		
			int timeSlash1 = date.indexOf(" ");
			String time = date.substring(timeSlash1+1);

			String month;
			String day;
			String year;
			String hour;
			String minute;
			String second;
				
			int dateSlash1 = date.indexOf("-");
			int dateSlash2 = date.lastIndexOf("-");

			if (dateSlash1 <= 0 || dateSlash1 == dateSlash2) return null;
			int timeColon1 = time.indexOf(":");
			int timeColon2 = time.lastIndexOf(":");
			int timeColon3 = time.indexOf(".");
					
			if (timeColon1 <= 0) return null;
		
			year = date.substring(0, dateSlash1);
			month = date.substring(dateSlash1 + 1, dateSlash2);
			
			day = date.substring(dateSlash2 + 1,timeSlash1);
			
			hour = time.substring(0, timeColon1);

			if (timeColon1 == timeColon2) {
				minute = time.substring(timeColon1 + 1);
				second = "0";
			} else {
				minute = time.substring(timeColon1 + 1, timeColon2);
				second = time.substring(timeColon2 + 1,timeColon3);
			}
			
			return toDate(month, day, year, hour, minute, second);
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}

		
				
		
	}
	/** Converts a date String and a time String into a Date
	 * @param date The date String: MM/DD/YYYY
	 * @param time The time String: either HH:MM or HH:MM:SS
	 * @return A Date made from the date and time Strings
	 */
	public static java.util.Date toDate(String date, String time) {
		if (date == null || time == null) return null;
		String month;
		String day;
		String year;
		String hour;
		String minute;
		String second;

		int dateSlash1 = date.indexOf("/");
		int dateSlash2 = date.lastIndexOf("/");

		if (dateSlash1 <= 0 || dateSlash1 == dateSlash2) return null;
		int timeColon1 = time.indexOf(":");
		int timeColon2 = time.lastIndexOf(":");

		if (timeColon1 <= 0) return null;
		month = date.substring(0, dateSlash1);
		day = date.substring(dateSlash1 + 1, dateSlash2);
		year = date.substring(dateSlash2 + 1);
		hour = time.substring(0, timeColon1);

		if (timeColon1 == timeColon2) {
			minute = time.substring(timeColon1 + 1);
			second = "0";
		} else {
			minute = time.substring(timeColon1 + 1, timeColon2);
			second = time.substring(timeColon2 + 1);
		}

		return toDate(month, day, year, hour, minute, second);
	}

	/** Makes a Date from separate Strings for month, day, year, hour, minute, and second.
	 * @param monthStr The month String
	 * @param dayStr The day String
	 * @param yearStr The year String
	 * @param hourStr The hour String
	 * @param minuteStr The minute String
	 * @param secondStr The second String
	 * @return A Date made from separate Strings for month, day, year, hour, minute, and second.
	 */
	public static java.util.Date toDate(String monthStr, String dayStr, String yearStr, String hourStr,
		String minuteStr, String secondStr) {
		int month, day, year, hour, minute, second;

		try {
			month = Integer.parseInt(monthStr);
			day = Integer.parseInt(dayStr);
			year = Integer.parseInt(yearStr);
			hour = Integer.parseInt(hourStr);
			minute = Integer.parseInt(minuteStr);
			second = Integer.parseInt(secondStr);
		} catch (Exception e) {
			return null;
		}
		return toDate(month, day, year, hour, minute, second);
	}

	/** Makes a Date from separate ints for month, day, year, hour, minute, and second.
	 * @param month The month int
	 * @param day The day int
	 * @param year The year int
	 * @param hour The hour int
	 * @param minute The minute int
	 * @param second The second int
	 * @return A Date made from separate ints for month, day, year, hour, minute, and second.
	 */
	public static java.util.Date toDate(int month, int day, int year, int hour, int minute, int second) {
		
		Calendar calendar = Calendar.getInstance();

		try {
			calendar.set(year, month - 1, day, hour, minute, second);
		} catch (Exception e) {
			return null;
		}
		java.sql.Timestamp stamp = new java.sql.Timestamp(calendar.getTime().getTime());
		stamp.setNanos(0);
		return new java.util.Date(stamp.getTime());
	}

	/** Makes a date String in the format MM/DD/YYYY from a Date
	 * @param date The Date
	 * @return A date String in the format MM/DD/YYYY
	 */
	public static String toDateString(java.util.Date date) {
		if (date == null) return "";
		Calendar calendar = Calendar.getInstance();

		calendar.setTime(date);
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		int year = calendar.get(Calendar.YEAR);
		String monthStr;
		String dayStr;
		String yearStr;

		if (month < 10) {
			monthStr = "0" + month;
		} else {
			monthStr = "" + month;
		}
		if (day < 10) {
			dayStr = "0" + day;
		} else {
			dayStr = "" + day;
		}
		yearStr = "" + year;
		return monthStr + "/" + dayStr + "/" + yearStr;
	}

	public static String toDateString2(java.util.Date date) {
		if (date == null) return "";
		Calendar calendar = Calendar.getInstance();

		calendar.setTime(date);
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		int year = calendar.get(Calendar.YEAR);
		String monthStr;
		String dayStr;
		String yearStr;

		if (month < 10) {
			monthStr = "0" + month;
		} else {
			monthStr = "" + month;
		}
		if (day < 10) {
			dayStr = "0" + day;
		} else {
			dayStr = "" + day;
		}
		yearStr = "" + year;
		return  yearStr + "-" + monthStr + "-" + dayStr;
	}
	/** Makes a time String in the format HH:MM:SS from a Date. If the seconds are 0, then the output is in HH:MM.
	 * @param date The Date
	 * @return A time String in the format HH:MM:SS or HH:MM
	 */
	public static String toTimeString(java.util.Date date) {
		if (date == null) return "";
		Calendar calendar = Calendar.getInstance();

		calendar.setTime(date);
		return (toTimeString(calendar.get(Calendar.HOUR_OF_DAY), calendar.get(Calendar.MINUTE), calendar.get(Calendar.SECOND)));
	}

	/** Makes a time String in the format HH:MM:SS from a separate ints for hour, minute, and second. If the seconds are 0, then the output is in HH:MM.
	 * @param hour The hour int
	 * @param minute The minute int
	 * @param second The second int
	 * @return A time String in the format HH:MM:SS or HH:MM
	 */
	public static String toTimeString(int hour, int minute, int second) {
		String hourStr;
		String minuteStr;
		String secondStr;

		if (hour < 10) {
			hourStr = "0" + hour;
		} else {
			hourStr = "" + hour;
		}
		if (minute < 10) {
			minuteStr = "0" + minute;
		} else {
			minuteStr = "" + minute;
		}
		if (second < 10) {
			secondStr = "0" + second;
		} else {
			secondStr = "" + second;
		}
		if (second == 0)
			return hourStr + ":" + minuteStr;
		else
			return hourStr + ":" + minuteStr + ":" + secondStr;
	}

	/** Makes a combined data and time string in the format "MM/DD/YYYY HH:MM:SS" from a Date. If the seconds are 0 they are left off.
	 * @param date The Date
	 * @return A combined data and time string in the format "MM/DD/YYYY HH:MM:SS" where the seconds are left off if they are 0.
	 */
	public static String toDateTimeString(java.util.Date date) {
		if (date == null) return "";
		String dateString = toDateString(date);
		String timeString = toTimeString(date);

		if (dateString != null && timeString != null)
			return dateString + " " + timeString;
		else
			return "";
	}

	/** Makes a Timestamp for the beginning of the month
	 * @return A Timestamp of the beginning of the month
	 */
	public static java.sql.Timestamp monthBegin() {
		Calendar mth = Calendar.getInstance();

		mth.set(Calendar.DAY_OF_MONTH, 1);
		mth.set(Calendar.HOUR_OF_DAY, 0);
		mth.set(Calendar.MINUTE, 0);
		mth.set(Calendar.SECOND, 0);
		mth.set(Calendar.AM_PM, Calendar.AM);
		return new java.sql.Timestamp(mth.getTime().getTime());
	}
	
	public static long getDayDistance(java.util.Date endDate,java.util.Date startDate){
		return (endDate.getTime()-startDate.getTime())/(3600*24*1000);
	}
	
	public static java.util.Date getNextDay(java.util.Date date){
		Calendar tempCal = Calendar.getInstance();

		tempCal.setTime(new java.util.Date(date.getTime()));
		tempCal.set(tempCal.get(Calendar.YEAR), tempCal.get(Calendar.MONTH), tempCal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		tempCal.add(Calendar.DAY_OF_MONTH, 1);	
		return tempCal.getTime();
	}
	
	public static java.util.Date getDiffDay(java.util.Date date, int DayDiff){
		Calendar tempCal = Calendar.getInstance();

		tempCal.setTime(new java.util.Date(date.getTime()));
		tempCal.set(tempCal.get(Calendar.YEAR), tempCal.get(Calendar.MONTH), tempCal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		tempCal.add(Calendar.DAY_OF_MONTH, DayDiff);	
		return tempCal.getTime();
	}
	
	public static java.util.Date getNextWeekDay(java.util.Date date){
		Calendar tempCal = Calendar.getInstance();

		tempCal.setTime(new java.util.Date(date.getTime()));
		tempCal.set(tempCal.get(Calendar.YEAR), tempCal.get(Calendar.MONTH), tempCal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		tempCal.add(Calendar.DAY_OF_WEEK_IN_MONTH, 1);	
		return tempCal.getTime();
	}
	
	public static java.util.Date getThisWeekDay(java.util.Date date,int DayDiff){
		Calendar tempCal = Calendar.getInstance();
		int DayAdd = 0;
		if (date.getDay() == 0) {
			DayAdd = DayDiff - 7;
		} else {
			DayAdd = DayDiff - date.getDay();
		}
		tempCal.setTime(new java.util.Date(date.getTime()));
		tempCal.set(tempCal.get(Calendar.YEAR), tempCal.get(Calendar.MONTH), tempCal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		tempCal.add(Calendar.DAY_OF_MONTH, DayAdd);
		return tempCal.getTime();
	}
	
	public static java.util.Date getThisWeekDay(String dateString,int DayDiff) {
		Calendar tempCal = Calendar.getInstance();
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date date = toDate2(dateString + " 00:00:00.000");
		int DayAdd = 0;
		if (date.getDay() == 0) {
			DayAdd = DayDiff - 7;
		} else {
			DayAdd = DayDiff - date.getDay();
		}
		tempCal.setTime(new java.util.Date(date.getTime()));
		tempCal.set(tempCal.get(Calendar.YEAR), tempCal.get(Calendar.MONTH), tempCal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		tempCal.add(Calendar.DAY_OF_MONTH, DayAdd);
		return tempCal.getTime();
	}
		
	public static String getDateString (java.util.Date date){
		Calendar calendar = Calendar.getInstance();

		calendar.setTime(date);
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		int year = calendar.get(Calendar.YEAR);
		String monthStr;
		String dayStr;
		String yearStr;

		if (month < 10) {
			monthStr = "0" + month;
		} else {
			monthStr = "" + month;
		}
		if (day < 10) {
			dayStr = "0" + day;
		} else {
			dayStr = "" + day;
		}
		yearStr = "" + year;
		return (monthStr + "/" + dayStr);		
			
	}
	
	public static int getDiffWorkingDate(java.util.Date from,java.util.Date to)
	{
		java.util.Date temp = from;
		int diff = 0;
		while(temp.before(to))
		{
			if(!(temp.getDay()==6)&&!(temp.getDay()==0))
				diff ++;			
			temp = getNextDay(temp);
		}
		return diff;
		
	}
}
