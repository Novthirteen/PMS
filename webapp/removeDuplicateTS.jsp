<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.core.persistence.*"%>
<%@ page import="com.aof.core.persistence.jdbc.*"%>
<%@ page import="com.aof.core.persistence.util.*"%>

<%
SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
						
StringBuffer statement = new StringBuffer("");
statement.append(" select  ");
statement.append(" td1.ts_id, ");
statement.append(" td2.ts_id, ");
statement.append(" td1.tsm_id, ");
statement.append(" td1.ts_proj_id, ");
statement.append(" td1.ts_projevent, ");
statement.append(" td1.ts_servicetype, ");
statement.append(" td1.ts_date ");
statement.append(" from proj_ts_det as td1  ");
statement.append(" inner join proj_ts_det as td2 ");
statement.append(" on td1.ts_id <> td2.ts_id ");
statement.append(" and td1.tsm_id = td2.tsm_id ");
statement.append(" and td1.ts_proj_id = td2.ts_proj_id ");
statement.append(" and td1.ts_projevent = td2.ts_projevent ");
statement.append(" and td1.ts_servicetype = td2.ts_servicetype ");
statement.append(" and td1.ts_date = td2.ts_date ");
statement.append(" order by  ");
statement.append(" td1.tsm_id,  ");
statement.append(" td1.ts_proj_id,  ");
statement.append(" td1.ts_projevent,  ");
statement.append(" td1.ts_servicetype, ");
statement.append(" td1.ts_date, ");
statement.append(" td1.ts_id ");

sqlExec.setMaxRows(2000);
SQLResults result = sqlExec.runQueryCloseCon(statement.toString());

sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
sqlExec.setAutoCommit(false);

int ts_id;
int old_tsm_id;
int new_tsm_id;
String old_ts_proj_id;
String new_ts_proj_id;
int old_ts_projevent;
int new_ts_projevent;
int old_ts_servicetype;
int new_ts_servicetype;
Date old_ts_date;
Date new_ts_date;

if (result != null && result.getRowCount() > 0) {
	old_tsm_id = result.getInt(0, 2);
	old_ts_proj_id = result.getString(0, 3);
	old_ts_projevent = result.getInt(0, 4);
	old_ts_servicetype = result.getInt(0, 5);
	old_ts_date = result.getDate(0, 6);
	int count = 0;
	
	for (int i0 = 1; i0 < result.getRowCount(); i0++) {
		ts_id = result.getInt(i0, 0);
		new_tsm_id = result.getInt(i0, 2);
		new_ts_proj_id = result.getString(i0, 3);
		new_ts_projevent = result.getInt(i0, 4);
		new_ts_servicetype = result.getInt(i0, 5);
		new_ts_date = result.getDate(i0, 6);
		
		if (old_tsm_id == new_tsm_id
		&& old_ts_proj_id.equals(new_ts_proj_id)
		&& old_ts_projevent == new_ts_projevent
		&& old_ts_servicetype == new_ts_servicetype
		&& old_ts_date.compareTo(new_ts_date) == 0) {
			//delete
			sqlExec.clearParams();
			sqlExec.addParam(ts_id);
			sqlExec.runQuery("delete from proj_ts_det where ts_id = ?");
			
			System.out.println("***********************************************");
			System.out.println("ts_id = " + ts_id);
			System.out.println("tsm_id = " + new_tsm_id);
			System.out.println("ts_proj_id = " + new_ts_proj_id);
			System.out.println("ts_projevent = " + new_ts_projevent);
			System.out.println("ts_servicetype = " + new_ts_servicetype);
			System.out.println("ts_date = " + new_ts_date);
			count++;
		} else {
			old_tsm_id = new_tsm_id;
			old_ts_proj_id = new_ts_proj_id;
			old_ts_projevent = new_ts_projevent;
			old_ts_servicetype = new_ts_servicetype;
			old_ts_date = new_ts_date;
		}
	}
	
	System.out.println("Total delete " + count + " records...");
	sqlExec.commitTrans();
	sqlExec.closeConnection();
}

%>