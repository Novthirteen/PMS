package com.aof.component.prm.Bill;

import java.io.Serializable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;

public class MOTransactionDetail implements Serializable{

    /** identifier field */
    private Long TransactionId;
    
    private Long TransactionIndex;

    /** nullable persistent field */
    private String TransactionCategory;

    /** nullable persistent field */
//    private Long TransactionRecId;
    private Long serivcetypeid;
    
    /** nullable persistent field */
    private String TransactionRecTable;

    /** nullable persistent field */
//    private Double Amount;
    private Double subtotal;
    
    /** nullable persistent field */
    private CurrencyType Currency;

    /** nullable persistent field */
    private Double ExchangeRate;
    

    /** nullable persistent field */
//    private String Desc1;
    private String desc;
    
    /** nullable persistent field */
    private String Desc2;

    /** nullable persistent field */
    private String Desc3;

    /** nullable persistent field */
    private String Desc4;

    /** nullable persistent field */
    private ProjectMaster Project;

    /** nullable persistent field */
    private java.util.Date TransactionDate;

    /** nullable persistent field */
//    private java.util.Date TransactionCreateDate;
    private java.util.Date createdate;
    
    /** nullable persistent field */
    private java.util.Date TransactionDate1;

    /** nullable persistent field */
    private java.util.Date TransactionDate2;

    /** nullable persistent field */
//    private Double TransactionNum1;
    private Double price;
    
    /** nullable persistent field */
//    private Double TransactionNum2;
    private Long quantity;
    
    /** nullable persistent field */
    private Double TransactionNum3;

    /** nullable persistent field */
    private Long TransactionInteger1;

    /** nullable persistent field */
    private Long TransactionInteger2;

    /** nullable persistent field */
    private UserLogin TransactionUser;

    /** nullable persistent field */
    private UserLogin TransactionCreateUser;
    


    /** full constructor */
    public MOTransactionDetail(java.lang.String TransactionCategory, 
    		                  Long TransactionRecId, 
							  java.lang.String TransactionRecTable, 
							  Double Amount, 
							  CurrencyType Currency, 
							  Double ExchangeRate, 
							  java.lang.String Desc1, 
							  java.lang.String Desc2, 
							  java.lang.String Desc3, 
							  java.lang.String Desc4, 
							  ProjectMaster Project, 
							  //CustomerProfile TransactionParty, 
							  java.util.Date TransactionDate, 
							  java.util.Date TransactionCreateDate, 
							  java.util.Date TransactionDate1, 
							  java.util.Date TransactionDate2, 
							  Double TransactionNum1, 
							  Double TransactionNum2, 
							  Double TransactionNum3, 
							  Long TransactionInteger1, 
							  Long TransactionInteger2, 
							  UserLogin TransactionUser, 
							  UserLogin TransactionCreateUser) {
        this.TransactionCategory = TransactionCategory;
        this.serivcetypeid = TransactionRecId;
        this.TransactionRecTable = TransactionRecTable;
        this.subtotal = Amount;
        this.Currency = Currency;
        this.ExchangeRate = ExchangeRate;
        this.desc = Desc1;
        this.Desc2 = Desc2;
        this.Desc3 = Desc3;
        this.Desc4 = Desc4;
        this.Project = Project;
        //this.TransactionParty = TransactionParty;
        this.TransactionDate = TransactionDate;
        this.createdate = TransactionCreateDate;
        this.TransactionDate1 = TransactionDate1;
        this.TransactionDate2 = TransactionDate2;
        this.price = TransactionNum1;
        this.quantity = new Long(TransactionNum2.intValue());
        this.TransactionNum3 = TransactionNum3;
        this.TransactionInteger1 = TransactionInteger1;
        this.TransactionInteger2 = TransactionInteger2;
        this.TransactionUser = TransactionUser;
        this.TransactionCreateUser = TransactionCreateUser;
    }

    /** default constructor */
    public MOTransactionDetail() {
    }

    public Long getTransactionId() {
        return this.TransactionId;
    }

	public void setTransactionId(Long TransactionId) {
		this.TransactionId = TransactionId;
	}

    public java.lang.String getTransactionCategory() {
        return this.TransactionCategory;
    }

	public void setTransactionCategory(java.lang.String TransactionCategory) {
		this.TransactionCategory = TransactionCategory;
	}

/*    public Long getTransactionRecId() {
        return this.TransactionRecId;
    }

	public void setTransactionRecId(Long TransactionRecId) {
		this.TransactionRecId = TransactionRecId;
	}
*/
    public java.lang.String getTransactionRecTable() {
        return this.TransactionRecTable;
    }

	public void setTransactionRecTable(java.lang.String TransactionRecTable) {
		this.TransactionRecTable = TransactionRecTable;
	}

/*    public Double getAmount() {
        return this.Amount;
    }

	public void setAmount(Double Amount) {
		this.Amount = Amount;
	}
*/
    public CurrencyType getCurrency() {
        return this.Currency;
    }

	public void setCurrency(CurrencyType Currency) {
		this.Currency = Currency;
	}

    public Double getExchangeRate() {
        return this.ExchangeRate;
    }

	public void setExchangeRate(Double ExchangeRate) {
		this.ExchangeRate = ExchangeRate;
	}

/*    public java.lang.String getDesc1() {
        return this.Desc1;
    }

	public void setDesc1(java.lang.String Desc1) {
		this.Desc1 = Desc1;
	}
*/
    public java.lang.String getDesc2() {
        return this.Desc2;
    }

	public void setDesc2(java.lang.String Desc2) {
		this.Desc2 = Desc2;
	}

    public java.lang.String getDesc3() {
        return this.Desc3;
    }

	public void setDesc3(java.lang.String Desc3) {
		this.Desc3 = Desc3;
	}

    public java.lang.String getDesc4() {
        return this.Desc4;
    }

	public void setDesc4(java.lang.String Desc4) {
		this.Desc4 = Desc4;
	}

    public ProjectMaster getProject() {
        return this.Project;
    }

	public void setProject(ProjectMaster Project) {
		this.Project = Project;
	}

	/*
    public CustomerProfile getTransactionParty() {
        return this.TransactionParty;
    }

	public void setTransactionParty(CustomerProfile TransactionParty) {
		this.TransactionParty = TransactionParty;
	}
	*/
	
    public java.util.Date getTransactionDate() {
        return this.TransactionDate;
    }

	public void setTransactionDate(java.util.Date TransactionDate) {
		this.TransactionDate = TransactionDate;
	}

/*    public java.util.Date getTransactionCreateDate() {
        return this.TransactionCreateDate;
    }

	public void setTransactionCreateDate(java.util.Date TransactionCreateDate) {
		this.TransactionCreateDate = TransactionCreateDate;
	}
*/
    public java.util.Date getTransactionDate1() {
        return this.TransactionDate1;
    }

	public void setTransactionDate1(java.util.Date TransactionDate1) {
		this.TransactionDate1 = TransactionDate1;
	}

    public java.util.Date getTransactionDate2() {
        return this.TransactionDate2;
    }

	public void setTransactionDate2(java.util.Date TransactionDate2) {
		this.TransactionDate2 = TransactionDate2;
	}

/*    public Double getTransactionNum1() {
        return this.TransactionNum1;
    }

	public void setTransactionNum1(Double TransactionNum1) {
		this.TransactionNum1 = TransactionNum1;
	}

    public Double getTransactionNum2() {
        return this.TransactionNum2;
    }

	public void setTransactionNum2(Double TransactionNum2) {
		this.TransactionNum2 = TransactionNum2;
	}
*/
    public Double getTransactionNum3() {
        return this.TransactionNum3;
    }

	public void setTransactionNum3(Double TransactionNum3) {
		this.TransactionNum3 = TransactionNum3;
	}

    public Long getTransactionInteger1() {
        return this.TransactionInteger1;
    }

	public void setTransactionInteger1(Long TransactionInteger1) {
		this.TransactionInteger1 = TransactionInteger1;
	}

    public Long getTransactionInteger2() {
        return this.TransactionInteger2;
    }

	public void setTransactionInteger2(Long TransactionInteger2) {
		this.TransactionInteger2 = TransactionInteger2;
	}

    public UserLogin getTransactionUser() {
        return this.TransactionUser;
    }

	public void setTransactionUser(UserLogin TransactionUser) {
		this.TransactionUser = TransactionUser;
	}

    public UserLogin getTransactionCreateUser() {
        return this.TransactionCreateUser;
    }

	public void setTransactionCreateUser(UserLogin TransactionCreateUser) {
		this.TransactionCreateUser = TransactionCreateUser;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("TransactionId", getTransactionId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof TransacationDetail) ) return false;
        TransacationDetail castOther = (TransacationDetail) other;
        return new EqualsBuilder()
            .append(this.getTransactionId(), castOther.getTransactionId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getTransactionId())
            .toHashCode();
    }


	public Long getTransactionIndex() {
		return TransactionIndex;
	}

	public void setTransactionIndex(Long transactionIndex) {
		TransactionIndex = transactionIndex;
	}

	public java.util.Date getCreatedate() {
		return createdate;
	}

	public void setCreatedate(java.util.Date createdate) {
		this.createdate = createdate;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public Long getSerivcetypeid() {
		return serivcetypeid;
	}

	public void setSerivcetypeid(Long serivcetypeid) {
		this.serivcetypeid = serivcetypeid;
	}

	public Double getSubtotal() {
		return subtotal;
	}

	public void setSubtotal(Double subtotal) {
		this.subtotal = subtotal;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public Long getQuantity() {
		return quantity;
	}

	public void setQuantity(Long quantity) {
		this.quantity = quantity;
	}

}
