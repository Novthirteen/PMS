/*
 * Created on 2004-12-2
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.helpdesk.util;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
import javax.naming.*;
import java.sql.*;
import javax.sql.*;
public class Database
{
    public static Connection getConn() throws SQLException{
        try{
            Context ctx = new InitialContext();
            if(ctx == null)
                throw new SQLException("No Context");
            DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/aofdb");
            if (ds==null)
                throw new SQLException("No JNDI");
            else
            {
                Connection retVal=ds.getConnection();
                retVal.setAutoCommit(true);
                return retVal;
            }
        }
        catch(javax.naming.NamingException e)
        {
            throw new SQLException("JNDI error!");
        }
    }
}

