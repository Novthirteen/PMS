/*
 * Created Thu Dec 02 15:56:59 CST 2004 by MyEclipse Hibernate Tool.
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

/**
 * A class that represents a row in the 'Status_Type' table. 
 * This class may be customized as it is never re-generated 
 * after being created.
 */
public class StatusType
    extends AbstractStatusType
    implements Serializable
{
    /**
     * Simple constructor of StatusType instances.
     */
    public StatusType()
    {
    }

    /**
     * Constructor of StatusType instances given a simple primary key.
     * @param stutusId
     */
    public StatusType(java.lang.Integer stutusId)
    {
        super(stutusId);
    }

    /* Add customized code below */

}
