/*
 * Created Fri Nov 12 12:04:39 CST 2004 by MyEclipse Hibernate Tool.
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

/**
 * A class that represents a row in the 'CM_Status_History' table. 
 * This class may be customized as it is never re-generated 
 * after being created.
 */
public class CallStatusHistory
    extends AbstractCallStatusHistory
    implements Serializable
{
    /**
     * Simple constructor of CallStatusHistory instances.
     */
    public CallStatusHistory()
    {
    }

    /**
     * Constructor of CallStatusHistory instances given a simple primary key.
     * @param cmshId
     */
    public CallStatusHistory(java.lang.Integer cmshId)
    {
        super(cmshId);
    }

    /* Add customized code below */

}
