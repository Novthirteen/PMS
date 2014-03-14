package com.aof.core.persistence.util;

import java.sql.*;

import javax.sql.*;
import javax.naming.*;

import java.util.*;

/**
 * @author xxp
 */  
public class EntityUtil {   
  

	public  static Connection getConnectionByName(String name) {
		Context initContext;
		Connection conn = null;   
		try {  
			initContext = new InitialContext();
			Context envContext  = (Context)initContext.lookup("java:/comp/env");
			DataSource ds = (DataSource)envContext.lookup(name);
			conn = ds.getConnection();
		} catch (NamingException e) {
			e.printStackTrace();
		}catch (SQLException e1) {
			e1.printStackTrace();
		}
		return conn;
	}

}
