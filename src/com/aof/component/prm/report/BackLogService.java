package com.aof.component.prm.report;

import java.sql.CallableStatement;
import java.sql.Connection;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;

public class BackLogService {
private String cyear;
private String cmonth;
private String dept;
private SQLExecutor sqlExec=null;
	public BackLogService(String cyear, String cmonth,String dept)
	{	
		this.cyear=cyear;
		this.cmonth=cmonth;
		this.dept=dept;		
	}
	public synchronized void executeStorProc()
	{
		try{
			Connection conn=null;
		InitialContext initContext = new InitialContext();
		Context envContext  = (Context)initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/aofdb");
		conn = ds.getConnection();
		CallableStatement statement = conn.prepareCall("{call backlogcheck(?,?,?,?,?,?)}");
		statement.setInt(1, Integer.parseInt(cyear));
		statement.setInt(2, Integer.parseInt(cmonth));
		statement.setString(3, cyear+"-1-1");
		statement.setString(4, cyear+"-"+cmonth+"-1");
		if(Integer.parseInt(cmonth)!=12) {
			statement.setString(5, cyear+"-"+(Integer.parseInt(cmonth)+1)+"-1");			
		} else {
			statement.setString(5, (Integer.parseInt(cyear)+1)+"-"+cmonth+"-1");
		}
		statement.setString(6, dept);
		statement.executeUpdate();
		conn.commit();
		System.out.println("finish executeupdate...");
		statement.close();
		conn.close();
		/*
	
		sqlExec.addParam(Integer.parseInt(cyear));
		sqlExec.addParam(Integer.parseInt(cmonth));
		sqlExec.addParam(cyear+"-1-1");
		sqlExec.addParam(cyear+"-"+cmonth+"-1");
		if(Integer.parseInt(cmonth)!=12)
		{
			sqlExec.addParam(cyear+"-"+(Integer.parseInt(cmonth)+1)+"-1");
		}
		else
			sqlExec.addParam((Integer.parseInt(cyear)+1)+"-"+cmonth+"-1");
		//dept = "'"+dept+"'";
		sqlExec.addParam(dept);
		System.out.println("before carry out");
		System.out.println(Integer.parseInt(cyear)+", "+Integer.parseInt(cmonth)+", "+cyear+"-1-1"+", "+cyear+"-"+cmonth+"-1"+", "+cyear+"-"+(Integer.parseInt(cmonth)+1)+"-1"+",  "+dept);
		sqlExec.runStoredProcCloseCon("backlogcheck");
		
		System.out.println("Stroe procedure DONE!");
	//	sqlExec=null;
	 * */
		}catch(Exception e)	{
			e.printStackTrace();
			}
		}
	
	
	public void execuSQL(net.sf.hibernate.Session hs,String strDept)
	{
		String bldate=cyear+"-1-1";
		String stdate=cyear+"-"+cmonth+"-1";
		String eddate="";
		if(Integer.parseInt(cmonth)!=12)
		{
			eddate=cyear+"-"+(Integer.parseInt(cmonth)+1)+"-1";
		}
		else
			eddate=(Integer.parseInt(cyear)+1)+"-"+cmonth+"-1";
		
			SQLExecutor sqlExec = new SQLExecutor(Persistencer
					.getSQLExecutorConnection(EntityUtil
							.getConnectionByName("jdbc/aofdb")));
			System.out.println(strDept);
			String SqlStr=" insert into backlog(project,bl_year,bl_month,amount,status)"+
			" select pm2.proj_id,"+Integer.parseInt(cyear)+","+Integer.parseInt(cmonth)+",0,'draft' from proj_mstr as pm2"+
			" where pm2.proj_id in "+
			" (select proj_id from proj_mstr as pm where pm.contracttype='tm' "+
			"	and pm.proj_caf_flag='y' and "+
			"	dep_id in ("+strDept+")"+
			"	and proj_category ='c'and (proj_status='wip' "+
			"	or close_date >= case when (proj_status='pc')then convert(datetime,'"+bldate+"') end "+
			"	or close_date >= case when (proj_status='close')then convert(datetime,'"+bldate+"') end))"+
			"	and pm2.proj_id not in(select project from backlog where bl_year="+cyear+" and bl_month="+cmonth+") ";
			System.out.println(SqlStr);
			SQLResults sr = sqlExec.runQuery(SqlStr);
		
			SqlStr="update backlog set amount=(select case when sum(tr_amount) is not null then ROUND(sum(tr_amount)/1000,0) "+
		" else  0 end  from proj_tr_det as tr inner join proj_mstr as pm on pm.proj_id=tr.tr_proj_id "+
 		" where  tr.tr_type='bill' and tr.tr_category='caf' and tr_date1<convert(datetime,'"+eddate+"') and project=tr.tr_proj_id "+
		" and tr_date1>convert(datetime,'"+stdate+"') and pm.contracttype='tm' and pm.proj_caf_flag='y'and pm.proj_category='c' "+
		" and (pm.proj_status='wip' or pm.close_date >= case when (pm.proj_status='pc')then convert(datetime,'"+bldate+"') end  "+
		" or pm.close_date >= case when (proj_status='close')then convert(datetime,'"+bldate+"') end) "+
		" and pm.dep_id in ("+strDept+") )"+
		" where bl_year="+Integer.parseInt(cyear)+" and bl_month="+Integer.parseInt(cmonth)+" and project in(select proj_id from proj_mstr inner join proj_tr_det "+
		" as tr2 on proj_id=tr2.tr_proj_id where  contracttype='tm' and proj_caf_flag='y'"+
		" and (proj_status='wip'or close_date >= case when (proj_status='pc')then convert(datetime,'"+bldate+"') end "+
		" or close_date >= case when (proj_status='close')then convert(datetime,'"+bldate+"') end)"+
		" and dep_id in("+strDept+"))";	
			System.out.println(SqlStr);
			sr = sqlExec.runQueryCloseCon(SqlStr);
			
		}
		//return result;
	}
	


