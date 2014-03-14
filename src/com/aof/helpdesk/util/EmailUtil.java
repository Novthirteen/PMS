/*
 * Created on 2004-12-2
 *
 */
package com.aof.helpdesk.util;

import java.sql.Connection;
import java.sql.SQLException;

import org.apache.log4j.Logger;

/**
 * @author shilei
 *
 */
public class EmailUtil {
	static Logger log = Logger.getLogger(EmailUtil.class.getName());
	static public boolean sendMail(final String email,final String title,final String content) throws SQLException	{
		log.info("send email to:"+email);
		Connection conn=null;
		try {
			//conn=Database.getConn();
			//CallableStatement call= conn.prepareCall("exec master..xp_sendmail @recipients=?, @subject=?, @message=?");
			//call.setString(1,email);
			//call.setString(2,title);
			//call.setString(3,content);
			//return call.execute();
			return true;
		} finally {
			if(conn!=null) {
				conn.close();
			}
		}
	}
}
