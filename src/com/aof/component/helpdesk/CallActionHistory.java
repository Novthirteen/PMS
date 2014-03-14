/*
 * Created Fri Nov 12 12:04:37 CST 2004 by MyEclipse Hibernate Tool.
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

/**
 * A class that represents a row in the 'CM_Action_History' table. 
 * This class may be customized as it is never re-generated 
 * after being created.
 */
public class CallActionHistory
    extends AbstractCallActionHistory
    implements Serializable
{
    /**
     * Simple constructor of CallActionHistory instances.
     */
    public CallActionHistory()
    {
    }

    /**
     * Constructor of CallActionHistory instances given a simple primary key.
     * @param cmahId
     */
    public CallActionHistory(java.lang.Integer cmahId)
    {
        super(cmahId);
    }

    /* Add customized code below */

}
