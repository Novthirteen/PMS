/*
 * Created Thu Nov 18 09:42:08 CST 2004 by MyEclipse Hibernate Tool.
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

/**
 * A class that represents a row in the 'Attachment' table. 
 * This class may be customized as it is never re-generated 
 * after being created.
 */
public class Attachment
    extends AbstractAttachment
    implements Serializable
{
    /**
     * Simple constructor of Attachment instances.
     */
    public Attachment()
    {
    }

    /**
     * Constructor of Attachment instances given a simple primary key.
     * @param attachId
     */
    public Attachment(java.lang.Integer attachId)
    {
        super(attachId);
    }

    /* Add customized code below */

}
