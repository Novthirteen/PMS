/*
 * Created Mon Nov 22 09:26:50 CST 2004 by MyEclipse Hibernate Tool.
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

/**
 * A class that represents a row in the 'custConfigItem' table. 
 * This class may be customized as it is never re-generated 
 * after being created.
 */
public class CustConfigItem
    extends AbstractCustConfigItem
    implements Serializable
{
    /**
     * Simple constructor of CustConfigItem instances.
     */
    public CustConfigItem()
    {
    }

    /**
     * Constructor of CustConfigItem instances given a composite primary key.
     * @param id
     */
    public CustConfigItem(Integer id)
    {
        super(id);
    }

    /* Add customized code below */

}
