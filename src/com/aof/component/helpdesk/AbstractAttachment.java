/*
 * WARNING: DO NOT EDIT THIS FILE. This is a generated file that is synchronized
 * by MyEclipse Hibernate tool integration.
 *
 * Created Thu Nov 18 09:42:06 CST 2004 by MyEclipse Hibernate Tool.
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

import com.aof.component.domain.party.UserLogin;

/**
 * A class that represents a row in the Attachment table. 
 * You can customize the behavior of this class by editing the class, {@link Attachment()}.
 * WARNING: DO NOT EDIT THIS FILE. This is a generated file that is synchronized * by MyEclipse Hibernate tool integration.
 */
public abstract class AbstractAttachment 
    implements Serializable
{
	
	private boolean deleted;
    /** The cached hash code value for this instance.  Settting to 0 triggers re-calculation. */
    private int hashValue = 0;

    /** The composite primary key value. */
    private java.lang.Integer id;

    /** The value of the simple groupid property. */
    private java.lang.String groupid;

    /** The value of the simple name property. */
    private java.lang.String name;

    /** The value of the simple mime property. */
    private java.lang.String mime;

    /** The value of the simple size property. */
    private java.lang.Integer size;

    /** The value of the simple attachContent property. */
   //private java.lang.String attachContent;

    /** The value of the simple attachCuser property. */
   // private java.lang.String attachCuser;
    private UserLogin createUser;

    /** The value of the simple createDate property. */
    private java.util.Date createDate;

    private String title;
    
    
	/**
	 * @return Returns the title.
	 */
	public String getTitle() {
		return title;
	}
	/**
	 * @param title The title to set.
	 */
	public void setTitle(String title) {
		this.title = title;
	}
    /**
     * Simple constructor of AbstractAttachment instances.
     */
    public AbstractAttachment()
    {
    }

    /**
     * Constructor of AbstractAttachment instances given a simple primary key.
     * @param id
     */
    public AbstractAttachment(java.lang.Integer attachId)
    {
        this.setId(attachId);
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
    public void setId(java.lang.Integer attachId)
    {
        this.hashValue = 0;
        this.id = attachId;
    }

    /**
     * Return the value of the Attach_GroupID column.
     * @return java.lang.String
     */
    public java.lang.String getGroupid()
    {
        return this.groupid;
    }

    /**
     * Set the value of the Attach_GroupID column.
     * @param groupid
     */
    public void setGroupid(java.lang.String attachGroupid)
    {
        this.groupid = attachGroupid;
    }

    /**
     * Return the value of the Attach_Name column.
     * @return java.lang.String
     */
    public java.lang.String getName()
    {
        return this.name;
    }

    /**
     * Set the value of the Attach_Name column.
     * @param name
     */
    public void setName(java.lang.String attachName)
    {
        this.name = attachName;
    }

    /**
     * Return the value of the Attach_MIME column.
     * @return java.lang.String
     */
    public java.lang.String getMime()
    {
        return this.mime;
    }

    /**
     * Set the value of the Attach_MIME column.
     * @param mime
     */
    public void setMime(java.lang.String attachMime)
    {
        this.mime = attachMime;
    }

    /**
     * Return the value of the Attach_Size column.
     * @return java.lang.Integer
     */
    public java.lang.Integer getSize()
    {
        return this.size;
    }

    /**
     * Set the value of the Attach_Size column.
     * @param size
     */
    public void setSize(java.lang.Integer attachSize)
    {
        this.size = attachSize;
    }

    /**
     * Return the value of the Attach_Content column.
     * @return java.lang.String
     */
    /*public java.lang.String getAttachContent()
    {
        return this.attachContent;
    }*/

    /**
     * Set the value of the Attach_Content column.
     * @param attachContent
     */
    /*public void setAttachContent(java.lang.String attachContent)
    {
        this.attachContent = attachContent;
    }*/

    	
    
    /**
     * Return the value of the Attach_CDate column.
     * @return java.util.Date
     */
    public java.util.Date getCreateDate()
    {
        return this.createDate;
    }

    /**
     * Set the value of the Attach_CDate column.
     * @param createDate
     */
    public void setCreateDate(java.util.Date attachCdate)
    {
        this.createDate = attachCdate;
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
        if (! (rhs instanceof Attachment))
            return false;
        Attachment that = (Attachment) rhs;
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
            int attachIdValue = this.getId() == null ? 0 : this.getId().hashCode();
            result = result * 37 + attachIdValue;
            this.hashValue = result;
        }
        return this.hashValue;
    }
	/**
	 * @return Returns the createUser.
	 */
	public UserLogin getCreateUser() {
		return createUser;
	}
	/**
	 * @param createUser The createUser to set.
	 */
	public void setCreateUser(UserLogin createUser) {
		this.createUser = createUser;
	}
	
	
	/**
	 * @return Returns the deleted.
	 */
	public boolean isDeleted() {
		return deleted;
	}
	/**
	 * @param deleted The deleted to set.
	 */
	public void setDeleted(boolean deleted) {
		this.deleted = deleted;
	}
}