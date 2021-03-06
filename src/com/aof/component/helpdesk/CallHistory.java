/*
 * Created Fri Nov 12 12:39:39 CST 2004 by MyEclipse Hibernate Tool.
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

/**
 * A class that represents a row in the 'CM_History' table. 
 * This class may be customized as it is never re-generated 
 * after being created.
 */
public class CallHistory
    extends AbstractCallHistory
    implements Serializable
{
    /**
     * Simple constructor of CallHistory instances.
     */
    public CallHistory()
    {
    }

    /**
     * Constructor of CallHistory instances given a simple primary key.
     * @param cmahId
     */
    public CallHistory(java.lang.Integer cmahId)
    {
        super(cmahId);
    }

    /* Add customized code below */

}
