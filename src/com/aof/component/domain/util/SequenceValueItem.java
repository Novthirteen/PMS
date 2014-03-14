package com.aof.component.domain.util;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class SequenceValueItem implements Serializable {

    /** identifier field */
    private String seqName;

    /** nullable persistent field */
    private long seqId;

    /** full constructor */
    public SequenceValueItem(java.lang.String seqName, long seqId) {
        this.seqName = seqName;
        this.seqId = seqId;
    }

    /** default constructor */
    public SequenceValueItem() {
    }

    /** minimal constructor */
    public SequenceValueItem(java.lang.String seqName) {
        this.seqName = seqName;
    }

    public java.lang.String getSeqName() {
        return this.seqName;
    }

    public void setSeqName(java.lang.String seqName) {
        this.seqName = seqName;
    }

    public long getSeqId() {
        return this.seqId;
    }

    public void setSeqId(long seqId) {
        this.seqId = seqId;
    }

    public String toString() {
        return new ToStringBuilder(this)
            .append("seqName", getSeqName())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof SequenceValueItem) ) return false;
        SequenceValueItem castOther = (SequenceValueItem) other;
        return new EqualsBuilder()
            .append(this.getSeqName(), castOther.getSeqName())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getSeqName())
            .toHashCode();
    }

}
