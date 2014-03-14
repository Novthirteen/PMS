<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="dori.jasper.engine.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>

<%
//数据库连接
Connection conn=null;
Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
conn=DriverManager.getConnection("jdbc:microsoft:sqlserver://devsvr2000:1433;DatabaseName=devdb;user=aof;password=aof");

//取到编译后的jasper文件
File reportFile = new File(application.getRealPath("ProjList.jasper"));

//向报表中定义的参数赋值
Map parameters = new HashMap();
//Integer i=new Integer(8);
//parameters.put("pjId", i);

byte[] bytes = 
JasperRunManager.runReportToPdf(
reportFile.getPath(), 
parameters, 
conn
);

response.setContentType("application/pdf");
response.setContentLength(bytes.length);
ServletOutputStream ouputStream = response.getOutputStream();
ouputStream.write(bytes, 0, bytes.length);
ouputStream.flush();
ouputStream.close();
%> 
