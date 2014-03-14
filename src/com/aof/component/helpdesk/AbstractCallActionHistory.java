/*
 * WARNING: DO NOT EDIT THIS FILE. This is a generated file that is synchronized
 * by MyEclipse Hibernate tool integration.
 *
 * Created Fri Nov 12 12:04:36 CST 2004 by MyEclipse Hibernate Tool.
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

/**
 * A class that represents a row in the CM_Action_History table. 
 * You can customize the behavior of this class by editing the class, {@link CallActionHistory()}.
 * WARNING: DO NOT EDIT THIS FILE. This is a generated file that is synchronized * by MyEclipse Hibernate tool integration.
 */
public abstract class AbstractCallActionHistory 
    implements Serializable
{

    /** The cached hash code value for this instance.  Settting to 0 triggers re-calculation. */
    private int hashValue = 0;

    /** The composite primary key value. */
    private java.lang.Integer id;

    /** The value of the actionType association. */
    private ActionType actionType;

    /** The value of the callMaster association. */
    private CallMaster callMaster;

    private java.util.Date date;
    
    private ModifyLog modifyLog=new ModifyLog();
    
    /** The value of the simple cmahSubject property. */
    private java.lang.String subject;

    /** The value of the simple cmahDesc property. */
    private java.lang.String desc;

    /** The value of the simple cmahAttachmentId property. */
    private java.lang.String attachGroupID;

    /** The value of the simple cmahCost property. */
    private java.lang.Float cost;

    /**
     * Simple constructor of AbstractCallActionHistory instances.
     */
    public AbstractCallActionHistory()
    {
    }

    /**
     * Constructor of AbstractCallActionHistory instances given a simple primary key.
     * @param cmahId
     */
    public AbstractCallActionHistory(java.lang.Integer Id)
    {
        this.setId(Id);
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
     * @param Id
     */
    public void setId(java.lang.Integer id)
    {
        this.hashValue = 0;
        this.id = id;
    }

    /**
     * Return the value of the CM_ID column.
     * @return CallMaster
     */
    public CallMaster getCallMaster()
    {
        return this.callMaster;
    }

    /**
     * Set the value of the CM_ID column.
     * @param callMaster
     */
    public void setCallMaster(CallMaster callMaster)
    {
        this.callMaster = callMaster;
    }

    /**
     * Return the value of the _Type column.
     * @return ActionType
     */
    public ActionType getActionType()
    {
        return this.actionType;
    }

    /**
     * Set the value of the _Type column.
     * @param actionType
     */
    public void setActionType(ActionType actionType)
    {
        this.actionType = actionType;
    }

    /**
     * Return the value of the _Subject column.
     * @return java.lang.String
     */
    public java.lang.String getSubject()
    {
        return this.subject;
    }

    /**
     * Set the value of the _Subject column.
     * @param Subject
     */
    public void setSubject(java.lang.String Subject)
    {
        this.subject = Subject;
    }

    /**
     * Return the value of the _Desc column.
     * @return java.lang.String
     */
    public java.lang.String getDesc()
    {
        return this.desc;
    }

    /**
     * Set the value of the _Desc column.
     * @param Desc
     */
    public void setDesc(java.lang.String Desc)
    {
        this.desc = Desc;
    }

    /**
     * Return the value of the _Attachment_ID column.
     * @return java.lang.String
     */
    public java.lang.String getAttachGroupID()
    {
        return this.attachGroupID;
    }

    /**
     * Set the value of the _Attachment_ID column.
     * @param AttachmentId
     */
    public void setAttachGroupID(java.lang.String AttachmentId)
    {
        this.attachGroupID = AttachmentId;
    }

    /**
     * Return the value of the _Cost column.
     * @return java.lang.Float
     */
    public java.lang.Float getCost()
    {
        return this.cost;
    }

    /**
     * Set the value of the _Cost column.
     * @param Cost
     */
    public void setCost(java.lang.Float Cost)
    {
        this.cost = Cost;
    }



  	/**
  	 * @return Returns the modifyLog.
  	 */
  	public ModifyLog getModifyLog() {
  		return modifyLog;
  	}
  	/**
  	 * @param modifyLog The modifyLog to set.
  	 */
  	public void setModifyLog(ModifyLog modifyLog) {
  		this.modifyLog = modifyLog;
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
        if (! (rhs instanceof CallActionHistory))
            return false;
        CallActionHistory that = (CallActionHistory) rhs;
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
            int IdValue = this.getId() == null ? 0 : this.getId().hashCode();
            result = result * 37 + IdValue;
            this.hashValue = result;
        }
        return this.hashValue;
    }
	/**
	 * @return Returns the date.
	 */
	public java.util.Date getDate() {
		return date;
	}
	/**
	 * @param date The date to set.
	 */
	public void setDate(java.util.Date date) {
		this.date = date;
	}
}