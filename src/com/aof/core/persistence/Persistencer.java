/*
 * Created on 2004-5-9
 *
 */
package com.aof.core.persistence;

import java.sql.*;

import com.aof.core.persistence.jdbc.ConnectionPool;


/**
 * @author xxp
 *
 */
public class Persistencer {  

	private static Persistencer instance;
	
	public static int SQLExectuor = 0;
	
	public static Persistencer instance() {
		if (instance == null) {
			instance = new Persistencer();
		}
		return instance;
	}
	

	public static ConnectionPool getSQLExecutorConnection (Connection conn){
		return new ConnectionPool(conn);
	}
}
