package com.aof.component.prm.admin;

import java.io.Serializable;
import java.util.Date;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.UserLogin;

public class BookingRoomVO implements Serializable {

	private Long bookingId;

	private String room;

	private Date bookingDate;

	private String startTime;

	private String endTime;

	private UserLogin person;

	public BookingRoomVO() {

	}

	public BookingRoomVO(Long bookingId, String room, Date bookingDate,
			String startTime, String endTime, UserLogin person) {
		super();
		this.bookingId = bookingId;
		this.room = room;
		this.bookingDate = bookingDate;
		this.startTime = startTime;
		this.endTime = endTime;
		this.person = person;
	}

	public Date getBookingDate() {
		return bookingDate;
	}

	public void setBookingDate(Date bookingDate) {
		this.bookingDate = bookingDate;
	}

	public Long getBookingId() {
		return bookingId;
	}

	public void setBookingId(Long bookingId) {
		this.bookingId = bookingId;
	}

	public UserLogin getPerson() {
		return person;
	}

	public void setPerson(UserLogin person) {
		this.person = person;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getRoom() {
		return room;
	}

	public void setRoom(String room) {
		this.room = room;
	}

	public String toString() {
		return new ToStringBuilder(this).append("bookingId", getBookingId())
				.toString();
	}

	public boolean equals(Object other) {
		if (!(other instanceof BookingRoomVO))
			return false;
		BookingRoomVO castOther = (BookingRoomVO) other;
		return new EqualsBuilder().append(this.getBookingId(),
				castOther.getBookingId()).isEquals();
	}

	public int hashCode() {
		return new HashCodeBuilder().append(getBookingId()).toHashCode();
	}

}
