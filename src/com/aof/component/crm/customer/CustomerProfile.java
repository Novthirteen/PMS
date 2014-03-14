package com.aof.component.crm.customer;

import com.aof.component.domain.party.Party;

/** @author Hibernate CodeGenerator */
public class CustomerProfile extends Party {

    /** nullable persistent field */
    private Industry Industry;

    /** nullable persistent field */
    private CustomerAccount Account;

	/** nullable persistent field */
    private String ChineseName;
    
	/** nullable persistent field */
    private CustT2Code T2Code;

    private String AccountCode;
    
	private String type;  // P(Prospect) or C(Customer)
	
	private String status; //whether verified
	
    public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAccountCode() {
		return AccountCode;
	}

	public void setAccountCode(String accountCode) {
		AccountCode = accountCode;
	}

	/** full constructor */
    public CustomerProfile(Industry Industry, CustomerAccount Account, CustT2Code T2Code) {
        this.Industry = Industry;
        this.Account = Account;
        this.T2Code = T2Code;
    }

    /** default constructor */
    public CustomerProfile() {
    }

    public Industry getIndustry() {
        return this.Industry;
    }

	public void setIndustry(Industry Industry) {
		this.Industry = Industry;
	}

    public CustomerAccount getAccount() {
        return this.Account;
    }

	public void setAccount(CustomerAccount Account) {
		this.Account = Account;
	}

	public String getChineseName() {
        return this.ChineseName;
    }

	public void setChineseName(String ChineseName) {
		this.ChineseName = ChineseName;
	}
	/**
	 * @return Returns the t2Code.
	 */
	public CustT2Code getT2Code() {
		return T2Code;
	}
	/**
	 * @param code The t2Code to set.
	 */
	public void setT2Code(CustT2Code code) {
		T2Code = code;
	}
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
}
