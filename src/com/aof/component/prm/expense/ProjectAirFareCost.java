/*
 * Created on 2005-4-13
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.expense;

import java.util.Date;

import com.aof.component.prm.project.CurrencyType;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ProjectAirFareCost extends ProjectCostMaster {
    
    private String takeOffTime;
    private Float sameFlightPrice;
    private String takeOffTimeIn4;
    private String flightNoIn4;
    private Float priceIn4;
    private String takeOffTimeInDay;
    private String flightNoInDay;
    private Float priceInDay;
    private Date bookDate;
    private String destination;
    private Date returnDate;
    
    /** full constructor */
    public ProjectAirFareCost(java.lang.String refno, 
    		                    java.lang.String costdescription, 
								ProjectCostType projectCostType, 
								CurrencyType currency, 
								float totalvalue, 
								float exchangerate, 
								java.util.Date costdate, 
								java.lang.String createuser, 
								java.util.Date createdate, 
								java.lang.String modifyuser, 
								java.util.Date modifydate,
								String takeOffTime,
							    Float sameFlightPrice,
							    String takeOffTimeIn4,
							    String flightNoIn4,
							    Float priceIn4,
							    String takeOffTimeInDay,
							    String flightNoInDay,
							    Float priceInDay,
								Date bookDate,
								String destination,
								Date returnDate) {
    	setRefno(refno);
        setCostdescription(costdescription);
        setProjectCostType(projectCostType);
        setCurrency(currency);
        setTotalvalue(totalvalue);
        setExchangerate(exchangerate);
        setCostdate(costdate);
        setCreateuser(createuser);
        setCreatedate(createdate);
        setModifyuser(modifyuser);
        setModifydate(modifydate);
        this.takeOffTime = takeOffTime;
        this.sameFlightPrice = sameFlightPrice;
        this.takeOffTimeIn4 = takeOffTimeIn4;
        this.flightNoIn4 = flightNoIn4;
        this.priceIn4 = priceIn4;
        this.takeOffTimeInDay = takeOffTimeInDay;
        this.flightNoInDay = flightNoInDay;
        this.priceInDay = priceInDay;
        this.destination = destination;
    }

    /** default constructor */
    public ProjectAirFareCost() {
    }

	/**
	 * @return Returns the flightNoIn4.
	 */
	public String getFlightNoIn4() {
		return flightNoIn4;
	}
	/**
	 * @param flightNoIn4 The flightNoIn4 to set.
	 */
	public void setFlightNoIn4(String flightNoIn4) {
		this.flightNoIn4 = flightNoIn4;
	}
	/**
	 * @return Returns the flightNoInDay.
	 */
	public String getFlightNoInDay() {
		return flightNoInDay;
	}
	/**
	 * @param flightNoInDay The flightNoInDay to set.
	 */
	public void setFlightNoInDay(String flightNoInDay) {
		this.flightNoInDay = flightNoInDay;
	}
	/**
	 * @return Returns the priceIn4.
	 */
	public Float getPriceIn4() {
		return priceIn4;
	}
	/**
	 * @param priceIn4 The priceIn4 to set.
	 */
	public void setPriceIn4(Float priceIn4) {
		this.priceIn4 = priceIn4;
	}
	/**
	 * @return Returns the priceInDay.
	 */
	public Float getPriceInDay() {
		return priceInDay;
	}
	/**
	 * @param priceInDay The priceInDay to set.
	 */
	public void setPriceInDay(Float priceInDay) {
		this.priceInDay = priceInDay;
	}
	/**
	 * @return Returns the sameFlightPrice.
	 */
	public Float getSameFlightPrice() {
		return sameFlightPrice;
	}
	/**
	 * @param sameFlightPrice The sameFlightPrice to set.
	 */
	public void setSameFlightPrice(Float sameFlightPrice) {
		this.sameFlightPrice = sameFlightPrice;
	}
	/**
	 * @return Returns the takeOffTime.
	 */
	public String getTakeOffTime() {
		return takeOffTime;
	}
	/**
	 * @param takeOffTime The takeOffTime to set.
	 */
	public void setTakeOffTime(String takeOffTime) {
		this.takeOffTime = takeOffTime;
	}
	/**
	 * @return Returns the takeOffTimeIn4.
	 */
	public String getTakeOffTimeIn4() {
		return takeOffTimeIn4;
	}
	/**
	 * @param takeOffTimeIn4 The takeOffTimeIn4 to set.
	 */
	public void setTakeOffTimeIn4(String takeOffTimeIn4) {
		this.takeOffTimeIn4 = takeOffTimeIn4;
	}
	/**
	 * @return Returns the takeOffTimeInDay.
	 */
	public String getTakeOffTimeInDay() {
		return takeOffTimeInDay;
	}
	/**
	 * @param takeOffTimeInDay The takeOffTimeInDay to set.
	 */
	public void setTakeOffTimeInDay(String takeOffTimeInDay) {
		this.takeOffTimeInDay = takeOffTimeInDay;
	}
	/**
	 * @return Returns the bookDate.
	 */
	public Date getBookDate() {
		return bookDate;
	}
	/**
	 * @param bookDate The bookDate to set.
	 */
	public void setBookDate(Date bookDate) {
		this.bookDate = bookDate;
	}
	
	public String getDestination() {
		return destination;
	}
	public void setDestination(String destination) {
		this.destination = destination;
	}
	
	/**
	 * @return Returns the returnDate.
	 */
	public Date getReturnDate() {
		return returnDate;
	}
	/**
	 * @param returnDate The returnDate to set.
	 */
	public void setReturnDate(Date returnDate) {
		this.returnDate = returnDate;
	}
}
