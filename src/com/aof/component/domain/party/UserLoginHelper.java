/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.party;

import java.util.*;
import java.sql.*;

import com.aof.core.persistence.jdbc.*;



import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;



/**
 * @author xxp 
 * @version 2003-11-4
 *
 */
public class UserLoginHelper {

	public UserLoginHelper() {
	}
	
	/**
	 * @deprecated 获得销售担当负责的机构
	 * @param userLoginId
	 * @return
	 * @throws Exception
	 */
	
	
	public List getAllUser(Session session) throws HibernateException{
			List result = new ArrayList();
		 	result = session.find("from UserLogin ul ");
			return result;
		}
		

	
	public List getManagedSalesParty(String userLoginId) throws Exception{
		List result = new ArrayList();
		Connection connection = null;
		ResultSet rs = null;
		try{
			connection = DatabaseConnection.getConnection();
			rs = DatabaseConnection.executeSql(connection,"select p.party_id,p.description from user_login_party as ulp ,party as p where user_login_id = '"+userLoginId+"' and p.party_id = ulp.party_id");
			while(rs.next()){
				HashMap map = new HashMap();
				map.put("PARTY_ID",rs.getString("party_id"));
				map.put("DESCRIPTION",rs.getString("description"));
				result.add(map);
			}
		}catch(Exception e){
			e.printStackTrace();
			throw new Exception("[Exception] getManagedSalesParty is Error!");
		}finally{
			 try {
			 	if(rs!=null) 			rs.close();
				if(connection!=null) 	connection.close();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
		return result;		
	}
}
