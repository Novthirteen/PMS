package com.aof.component.prm.project;
import com.aof.component.domain.party.*;
import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.prm.project.*;

/** @author Hibernate CodeGenerator */
public class ConsultantCost implements Serializable {

    /** identifier field */
    private Long Id;

    /** persistent field */
    private UserLogin User;

    /** persistent field */
	private Integer Year;
	
	/** persistent field */
	private Float Cost;

   
    /** full constructor */
    public ConsultantCost(UserLogin User, Integer Year,Float Cost) {
        this.User = User;
        this.Year = Year;
        this.Cost = Cost;
              
    }

    /** default constructor */
    public ConsultantCost() {
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    
    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
    }

	
	public UserLogin getUser() {
		return this.User;
	}

	
	/**
	 * @param login
	 */
	public void setUser(UserLogin login) {
		this.User = login;
	}

	

	/**
	 * @return
	 */
	public Float getCost() {
		return Cost;
	}

	/**
	 * @param f
	 */
	public void setCost(Float f) {
		Cost = f;
	}

	/**
	 * @return
	 */
	public Integer getYear() {
		return Year;
	}

	/**
	 * @param integer
	 */
	public void setYear(Integer integer) {
		Year = integer;
	}

}
