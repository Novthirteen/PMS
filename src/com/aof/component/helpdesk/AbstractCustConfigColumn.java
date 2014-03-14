/*
 * WARNING: DO NOT EDIT THIS FILE. This is a generated file that is synchronized
 * by MyEclipse Hibernate tool integration.
 *
 * Created Mon Nov 22 09:26:50 CST 2004 by MyEclipse Hibernate Tool.
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

/**
 * A class that represents a row in the custConfigColumn table. 
 * You can customize the behavior of this class by editing the class, {@link CustConfigColumn()}.
 * WARNING: DO NOT EDIT THIS FILE. This is a generated file that is synchronized * by MyEclipse Hibernate tool integration.
 */
public abstract class AbstractCustConfigColumn 
    implements Serializable
{
    /** The cached hash code value for this instance.  Settting to 0 triggers re-calculation. */
    private int hashValue = 0;

    /** The composite primary key value. */
    private java.lang.Integer id;

    /** The value of the table association. */
    private CustConfigTableType tableType;

    /** The value of the simple name property. */
    private java.lang.String name;

    /** The value of the simple type property. */
    private java.lang.Integer type;
    
	
    private java.lang.Integer index;

    /**
     * Simple constructor of AbstractCustConfigColumn instances.
     */
    public AbstractCustConfigColumn()
    {
    }

    /**
     * Constructor of AbstractCustConfigColumn instances given a simple primary key.
     * @param id
     */
    public AbstractCustConfigColumn(java.lang.Integer columnId)
    {
        this.setId(columnId);
    }

    /**
     * Return the simple primary key value that identifies this object.
     * @return java.lang.Integer
     */
    public java.lang.Integer getId()
    {
        return id;
    }

    /**
     * Set the simple primary key value that identifies this object.
     * @param id
     */
    public void setId(java.lang.Integer columnId)
    {
        this.hashValue = 0;
        this.id = columnId;
    }

    /**
     * Return the value of the table_id column.
     * @return CustConfigTable
     */
    public CustConfigTableType getTableType()
    {
        return this.tableType;
    }

    /**
     * Set the value of the table_id column.
     * @param table
     */
    public void setTableType(CustConfigTableType type)
    {
        this.tableType = type;
    }

    /**
     * Return the value of the column_name column.
     * @return java.lang.String
     */
    public java.lang.String getName()
    {
        return this.name;
    }

    /**
     * Set the value of the column_name column.
     * @param name
     */
    public void setName(java.lang.String columnName)
    {
        this.name = columnName;
    }

    /**
     * Return the value of the column_type column.
     * @return java.lang.Integer
     */
    public java.lang.Integer getType()
    {
        return this.type;
    }

    /**
     * Set the value of the column_type column.
     * @param type
     */
    public void setType(java.lang.Integer columnType)
    {
        this.type = columnType;
    }

    /**
  	 * @return Returns the index.
  	 */
  	public java.lang.Integer getIndex() {
  		return index;
  	}
  	/**
  	 * @param index The index to set.
  	 */
  	public void setIndex(java.lang.Integer index) {
  		this.index = index;
  	}
    
    /**
     * Implementation of the equals comparison on the basis of equality of the primary key values.
     * @param rhs
     * @return boolean
     */
    public boolean equals(Object rhs)
    {
        if (rhs == null)
            return false;
        if (! (rhs instanceof CustConfigColumn))
            return false;
        CustConfigColumn that = (CustConfigColumn) rhs;
        if (this.getId() != null && that.getId() != null)
        {
            if (! this.getId().equals(that.getId()))
            {
                return false;
            }
        }
        return true;
    }

    /**
     * Implementation of the hashCode method conforming to the Bloch pattern with
     * the exception of array properties (these are very unlikely primary key types).
     * @return int
     */
    public int hashCode()
    {
        if (this.hashValue == 0)
        {
            int result = 17;
            int columnIdValue = this.getId() == null ? 0 : this.getId().hashCode();
            result = result * 37 + columnIdValue;
            this.hashValue = result;
        }
        return this.hashValue;
    }
}
