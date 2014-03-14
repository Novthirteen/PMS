package com.aof.component.domain.security;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.type.Type;

import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.GeneralException;

public class SecurityHelper {
	
	public SecurityHelper(){
		
	}

	public List listAllSecurityGroup(){

		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		String sql = "select group_id from security_group";
		SQLResults result = sqlExec.runQueryCloseCon(sql);
		List list = result.toList();
		return list;
	}
	
	public List listAllSecurityPermission(){
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		String sql = "select permission_id from security_permission";
		SQLResults result = sqlExec.runQueryCloseCon(sql);
		List list = result.toList();
		return list;
	}
}
