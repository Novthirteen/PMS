/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.report;

import java.io.Serializable;
import java.sql.Date;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;

/**
 * @author Jackey Ding
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ProjectCost implements Serializable {

	private static String DEFAULT_DOUBLE_VALUE = "0";
	private static String DEFAULT_DATE_VALUE = "";
	
	/** fields */
	private String projCode;
	private String projName;
	private Date projectStartDate;
	private Date origCompDate;
	//private String curr;
	private Double serviceSalesValue;
	private Double licenceSalesValue;
	private Double daysBudget;
	private Double daysThisMonth;
	private Double daysTodate;
	private Double pSCBudget;
	//private Double pSCOpBudget;
	private Double pSCThisMonth;
	private Double pSCTodate;
	private Double expsBudget;
	//private Double expsOpBudget;
	private Double expsThisMonth;
	private Double expsTodate;
	private Double totalBudget;
	//private Double totalOpBudget;
	private Double costThisMonth;
	private Double totalCostTodate;
	private Double pSCForecast;
	private Double expsForecast;
	private Double forecasttoComp;
	//private Double pSCForecast1;
	//private Double pSCForecast2;
	//private Double pSCForecast3;
	//private Double expsForecast1;
	//private Double expsForecast2;
	//private Double expsForecast3;

	/**
	 * @return
	 */
	public Double getCostThisMonth() {
		return costThisMonth;
	}
	
	/**
	 * @return
	 */
	public String getCostThisMonthStr() {		
		return formatDouble(costThisMonth, 2);
	}

	/**
	 * @return
	 */
	/*
	public String getCurr() {
		if (curr == null) {
			return "";
		}
		return curr;
	}
	*/

	/**
	 * @return
	 */
	public Double getDaysBudget() {
		return daysBudget;
	}
	
	/**
	 * @return
	 */
	public String getDaysBudgetStr() {
		
		return formatDouble(daysBudget, 0);
	}

	/**
	 * @return
	 */
	public Double getDaysThisMonth() {
		return daysThisMonth;
	}
	
	/**
	 * @return
	 */
	public String getDaysThisMonthStr() {
		return formatDouble(daysThisMonth, 0);
	}

	/**
	 * @return
	 */
	public Double getDaysTodate() {
		return daysTodate;
	}
	
	/**
	 * @return
	 */
	public String getDaysTodateStr() {
		return formatDouble(daysTodate, 0);
	}

	/**
	 * @return
	 */
	public Double getExpsBudget() {
		return expsBudget;
	}
	
	/**
	 * @return
	 */
	public String getExpsBudgetStr() {
		return formatDouble(expsBudget, 2);
	}

	/**
	 * @return
	 */
	public Double getExpsForecast() {
		return expsForecast;
	}
	
	/**
	 * @return
	 */
	public String getExpsForecastStr() {
		return formatDouble(expsForecast, 2);
	}

	/**
	 * @return
	 */
	/*
	public Double getExpsForecast1() {
		return expsForecast1;
	}
	*/
	
	/**
	 * @return
	 */
	/*
	public String getExpsForecast1Str() {
		if (expsForecast1 == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		return expsForecast1.toString();
	}
	*/
	
	/**
	 * @return
	 */
	/*
	public Double getExpsForecast2() {
		return expsForecast2;
	}
	*/
	
	/**
	 * @return
	 */
	/*
	public String getExpsForecast2Str() {
		if (expsForecast2 == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		return expsForecast2.toString();
	}
	*/

	/**
	 * @return
	 */
	/*
	public Double getExpsForecast3() {
		return expsForecast3;
	}
	*/
	
	/**
	 * @return
	 */
	/*
	public String getExpsForecast3Str() {
		if (expsForecast3 == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		return expsForecast3.toString();
	}
	*/

	/**
	 * @return
	 */
	/*
	public Double getExpsOpBudget() {
		return expsOpBudget;
	}
	*/
	
	/**
	 * @return
	 */
	/*
	public String getExpsOpBudgetStr() {
		if (expsOpBudget == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		return expsOpBudget.toString();
	}
	*/

	/**
	 * @return
	 */
	public Double getExpsThisMonth() {
		return expsThisMonth;
	}
	
	/**
	 * @return
	 */
	public String getExpsThisMonthStr() {
		return formatDouble(expsThisMonth, 2);
	}

	/**
	 * @return
	 */
	public Double getExpsTodate() {
		return expsTodate;
	}
	
	/**
	 * @return
	 */
	public String getExpsTodateStr() {
		return formatDouble(expsTodate, 2);
	}

	/**
	 * @return
	 */
	public Double getForecasttoComp() {
		return forecasttoComp;
	}
	
	/**
	 * @return
	 */
	public String getForecasttoCompStr() {
		return formatDouble(forecasttoComp, 2);
	}

	/**
	 * @return
	 */
	public Double getLicenceSalesValue() {
		return licenceSalesValue;
	}
	
	/**
	 * @return
	 */
	public String getLicenceSalesValueStr() {
		return formatDouble(licenceSalesValue, 2);
	}

	/**
	 * @return
	 */
	public Date getOrigCompDate() {
		return origCompDate;
	}
	
	/**
	 * @return
	 */
	public String getOrigCompDateStr() {
		if (origCompDate == null) {
			return DEFAULT_DATE_VALUE;
		}
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		return dateFormat.format(origCompDate);
	}

	/**
	 * @return
	 */
	public String getProjCode() {
		return projCode;
	}

	/**
	 * @return
	 */
	public Date getProjectStartDate() {
		return projectStartDate;
	}
	
	/**
	 * @return
	 */
	public String getProjectStartDateStr() {
		if (projectStartDate == null) {
			return DEFAULT_DATE_VALUE;
		}
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		return dateFormat.format(projectStartDate);
	}

	/**
	 * @return
	 */
	public String getProjName() {
		return projName;
	}

	/**
	 * @return
	 */
	public Double getPSCBudget() {
		return pSCBudget;
	}
	
	/**
	 * @return
	 */
	public String getPSCBudgetStr() {
		return formatDouble(pSCBudget, 2);
	}

	/**
	 * @return
	 */
	public Double getPSCForecast() {
		return pSCForecast;
	}
	
	/**
	 * @return
	 */
	public String getPSCForecastStr() {
		if (pSCForecast == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		return formatDouble(pSCForecast, 2);
	}

	/**
	 * @return
	 */
	/*
	public Double getPSCForecast1() {
		return pSCForecast1;
	}
	*/
	
	/**
	 * @return
	 */
	/*
	public String getPSCForecast1Str() {
		if (pSCForecast1 == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		return pSCForecast1.toString();
	}
	*/

	/**
	 * @return
	 */
	/*
	public Double getPSCForecast2() {
		return pSCForecast2;
	}
	*/
	
	/**
	 * @return
	 */
	/*
	public String getPSCForecast2Str() {
		if (pSCForecast2 == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		return pSCForecast2.toString();
	}
	*/

	/**
	 * @return
	 */
	/*
	public Double getPSCForecast3() {
		return pSCForecast3;
	}
	*/
	
	/**
	 * @return
	 */
	/*
	public String getPSCForecast3Str() {
		if (pSCForecast3 == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		return pSCForecast3.toString();
	}
	*/

	/**
	 * @return
	 */
	/*
	public Double getPSCOpBudget() {
		return pSCOpBudget;
	}
	*/
	
	/**
	 * @return
	 */
	/*
	public String getPSCOpBudgetStr() {
		if (pSCOpBudget == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		return pSCOpBudget.toString();
	}
	*/

	/**
	 * @return
	 */
	public Double getPSCThisMonth() {
		return pSCThisMonth;
	}
	
	/**
	 * @return
	 */
	public String getPSCThisMonthStr() {
		return formatDouble(pSCThisMonth, 2);
	}

	/**
	 * @return
	 */
	public Double getPSCTodate() {
		return pSCTodate;
	}
	
	/**
	 * @return
	 */
	public String getPSCTodateStr() {
		return formatDouble(pSCTodate, 2);
	}

	/**
	 * @return
	 */
	public Double getServiceSalesValue() {
		return serviceSalesValue;
	}
	
	/**
	 * @return
	 */
	public String getServiceSalesValueStr() {
		return formatDouble(serviceSalesValue, 2);
	}

	/**
	 * @return
	 */
	public Double getTotalCostTodate() {
		return totalCostTodate;
	}
	
	/**
	 * @return
	 */
	public String getTotalCostTodateStr() {
		return formatDouble(totalCostTodate, 2);
	}

	/**
	 * @return
	 */
	public Double getTotalBudget() {
		return totalBudget;
	}
	
	/**
	 * @return
	 */
	public String getTotalBudgetStr() {
		return formatDouble(totalBudget, 2);
	}

	/**
	 * @return
	 */
	/*
	public Double getTotalOpBudget() {
		return totalOpBudget;
	}
	*/
	
	/**
	 * @return
	 */
	/*
	public String getTotalOpBudgetStr() {
		if (totalOpBudget == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		return totalOpBudget.toString();
	}
	*/

	/**
	 * @param double1
	 */
	public void setCostThisMonth(Double double1) {
		costThisMonth = double1;
	}

	/**
	 * @param string
	 */
	/*
	public void setCurr(String string) {
		curr = string;
	}
	*/

	/**
	 * @param double1
	 */
	public void setDaysBudget(Double double1) {
		daysBudget = double1;
	}

	/**
	 * @param double1
	 */
	public void setDaysThisMonth(Double double1) {
		daysThisMonth = double1;
	}

	/**
	 * @param double1
	 */
	public void setDaysTodate(Double double1) {
		daysTodate = double1;
	}

	/**
	 * @param double1
	 */
	public void setExpsBudget(Double double1) {
		expsBudget = double1;
	}

	/**
	 * @param double1
	 */
	public void setExpsForecast(Double double1) {
		expsForecast = double1;
	}

	/**
	 * @param double1
	 */
	/*
	public void setExpsForecast1(Double double1) {
		expsForecast1 = double1;
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setExpsForecast2(Double double1) {
		expsForecast2 = double1;
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setExpsForecast3(Double double1) {
		expsForecast3 = double1;
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setExpsOpBudget(Double double1) {
		expsOpBudget = double1;
	}
	*/

	/**
	 * @param double1
	 */
	public void setExpsThisMonth(Double double1) {
		expsThisMonth = double1;
	}

	/**
	 * @param double1
	 */
	public void setExpsTodate(Double double1) {
		expsTodate = double1;
	}

	/**
	 * @param double1
	 */
	public void setForecasttoComp(Double double1) {
		forecasttoComp = double1;
	}

	/**
	 * @param double1
	 */
	public void setLicenceSalesValue(Double double1) {
		licenceSalesValue = double1;
	}

	/**
	 * @param date
	 */
	public void setOrigCompDate(Date date) {
		origCompDate = date;
	}

	/**
	 * @param string
	 */
	public void setProjCode(String string) {
		projCode = string;
	}

	/**
	 * @param date
	 */
	public void setProjectStartDate(Date date) {
		projectStartDate = date;
	}

	/**
	 * @param string
	 */
	public void setProjName(String string) {
		projName = string;
	}

	/**
	 * @param double1
	 */
	public void setPSCBudget(Double double1) {
		pSCBudget = double1;
	}

	/**
	 * @param double1
	 */
	public void setPSCForecast(Double double1) {
		pSCForecast = double1;
	}

	/**
	 * @param double1
	 */
	/*
	public void setPSCForecast1(Double double1) {
		pSCForecast1 = double1;
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setPSCForecast2(Double double1) {
		pSCForecast2 = double1;
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setPSCForecast3(Double double1) {
		pSCForecast3 = double1;
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setPSCOpBudget(Double double1) {
		pSCOpBudget = double1;
	}
	*/

	/**
	 * @param double1
	 */
	public void setPSCThisMonth(Double double1) {
		pSCThisMonth = double1;
	}

	/**
	 * @param double1
	 */
	public void setPSCTodate(Double double1) {
		pSCTodate = double1;
	}

	/**
	 * @param double1
	 */
	public void setServiceSalesValue(Double double1) {
		serviceSalesValue = double1;
	}

	/**
	 * @param double1
	 */
	public void setTotalCostTodate(Double double1) {
		totalCostTodate = double1;
	}

	/**
	 * @param double1
	 */
	public void setTotalBudget(Double double1) {
		totalBudget = double1;
	}

	/**
	 * @param double1
	 */
	/*
	public void setTotalOpBudget(Double double1) {
		totalOpBudget = double1;
	}
	*/
	
	/**
	 * @param double1
	 */
	public void setCostThisMonth(double double1) {
		costThisMonth = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setDaysBudget(double double1) {
		daysBudget = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setDaysThisMonth(double double1) {
		daysThisMonth = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setDaysTodate(double double1) {
		daysTodate = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setExpsBudget(double double1) {
		expsBudget = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setExpsForecast(double double1) {
		expsForecast = new Double(double1);
	}

	/**
	 * @param double1
	 */
	/*
	public void setExpsForecast1(double double1) {
		expsForecast1 = new Double(double1);
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setExpsForecast2(double double1) {
		expsForecast2 = new Double(double1);
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setExpsForecast3(double double1) {
		expsForecast3 = new Double(double1);
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setExpsOpBudget(double double1) {
		expsOpBudget = new Double(double1);
	}
	*/

	/**
	 * @param double1
	 */
	public void setExpsThisMonth(double double1) {
		expsThisMonth = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setExpsTodate(double double1) {
		expsTodate = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setForecasttoComp(double double1) {
		forecasttoComp = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setLicenceSalesValue(double double1) {
		licenceSalesValue = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setPSCBudget(double double1) {
		pSCBudget = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setPSCForecast(double double1) {
		pSCForecast = new Double(double1);
	}

	/**
	 * @param double1
	 */
	/*
	public void setPSCForecast1(double double1) {
		pSCForecast1 = new Double(double1);
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setPSCForecast2(double double1) {
		pSCForecast2 = new Double(double1);
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setPSCForecast3(double double1) {
		pSCForecast3 = new Double(double1);
	}
	*/

	/**
	 * @param double1
	 */
	/*
	public void setPSCOpBudget(double double1) {
		pSCOpBudget = new Double(double1);
	}
	*/

	/**
	 * @param double1
	 */
	public void setPSCThisMonth(double double1) {
		pSCThisMonth = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setPSCTodate(double double1) {
		pSCTodate = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setServiceSalesValue(double double1) {
		serviceSalesValue = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setTotalCostTodate(double double1) {
		totalCostTodate = new Double(double1);
	}

	/**
	 * @param double1
	 */
	public void setTotalBudget(double double1) {
		totalBudget = new Double(double1);
	}

	/**
	 * @param double1
	 */
	/*
	public void setTotalOpBudget(double double1) {
		totalOpBudget = new Double(double1);
	}
	*/
	
	private String formatDouble(Double d, int scale) {
		if (d == null) {
			return DEFAULT_DOUBLE_VALUE;
		}
		//return d.toString();
		NumberFormat nf = NumberFormat.getInstance();
		nf.setMaximumFractionDigits(scale);
		nf.setMinimumFractionDigits(scale);
		return nf.format(d);
	}
}
