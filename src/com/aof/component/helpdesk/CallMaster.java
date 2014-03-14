/*
 * Created Fri Nov 12 12:04:39 CST 2004 by MyEclipse Hibernate Tool.
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

/**
 * A class that represents a row in the 'Call_Master' table. 
 * This class may be customized as it is never re-generated 
 * after being created.
 */
public class CallMaster
    extends AbstractCallMaster
    implements Serializable
{
    /**
     * Simple constructor of CallMaster instances.
     */
    public CallMaster()
    {
    }

    /**
     * Constructor of CallMaster instances given a simple primary key.
     * @param cmId
     */
    public CallMaster(java.lang.Integer cmId)
    {
        super(cmId);
    }

    /* Add customized code below */

}
