package com.aof.component.prm.bid;

import java.io.Serializable;
import java.util.Date;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.ProjectMaster;

public class BMHistory implements Serializable{

	private Long id;

//	private BidMaster bm_id;
	
	private Long masterid;

	private UserLogin user_id;

	private Date modify_date;

	private Date con_st_date;

	private Date con_ed_date;

	private Date con_sign_date;

	private String status;

	private String reason;
	
    public boolean equals(Object other) {
        if ( !(other instanceof BMHistory) ) return false;
        BMHistory castOther = (BMHistory) other;
        return new EqualsBuilder()
            .append(this.getId(), castOther.getId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
    }

/*
	public BidMaster getBm_id() {
		return bm_id;
	}

	public void setBm_id(BidMaster bm_id) {
		this.bm_id = bm_id;
	}
*/
	public Date getCon_ed_date() {
		return con_ed_date;
	}

	public void setCon_ed_date(Date con_ed_date) {
		this.con_ed_date = con_ed_date;
	}

	public Date getCon_sign_date() {
		return con_sign_date;
	}

	public void setCon_sign_date(Date con_sign_date) {
		this.con_sign_date = con_sign_date;
	}

	public Date getCon_st_date() {
		return con_st_date;
	}

	public void setCon_st_date(Date con_st_date) {
		this.con_st_date = con_st_date;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Date getModify_date() {
		return modify_date;
	}

	public void setModify_date(Date modify_date) {
		this.modify_date = modify_date;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public UserLogin getUser_id() {
		return user_id;
	}

	public void setUser_id(UserLogin user_id) {
		this.user_id = user_id;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public Long getMasterid() {
		return masterid;
	}

	public void setMasterid(Long masterid) {
		this.masterid = masterid;
	}

}
