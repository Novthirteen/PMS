<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="org.apache.struts.action.*"%>
<%@ page import="com.aof.core.persistence.jdbc.*"%>
<%@ page import="com.aof.core.persistence.*"%>
<%@ page import="com.aof.core.persistence.util.*"%>
<%@ page import="com.aof.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
try{
UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);

if (AOFSECURITY.hasEntityPermission("VIEW", "_INVENTORY", session)) {%>




<%	
}else{
	out.println("没有访问权限.");
}
}catch(Exception e){
		e.printStackTrace(new PrintWriter(out));
}
%>