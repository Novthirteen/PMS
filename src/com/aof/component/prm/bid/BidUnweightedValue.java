package com.aof.component.prm.bid;

public class BidUnweightedValue {
	private Long id;
	private String bid_no ;
	private String year;
	private Double value;
	public BidUnweightedValue(String bid_no,String year,Double value) {
		this.bid_no=bid_no;
		this.year = year;
		this.value = value;
	}
	public String getBid_no() {
		return bid_no;
	}
	public void setBid_no(String bid_no) {
		this.bid_no = bid_no;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Double getValue() {
		return value;
	}
	public void setValue(Double value) {
		this.value = value;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public BidUnweightedValue() {
		super();
		// TODO Auto-generated constructor stub
	}

}
