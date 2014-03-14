<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.aof.component.domain.party.PartyKeys"%>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
if (true || AOFSECURITY.hasEntityPermission("SYSTEM_ROLE", "_PAGE", session)) {
	String role = (String)session.getAttribute(Constants.USERLOGIN_ROLE_KEY);
%>
<%	if(role!=null && role.equals("FULLADMIN")){
	%>
		<table border="0" width="100%">
		  <tr>   
		    <td width="60%" valign="top" width="50%">   
			   hello to helpdesk module.
		    </td>
		</table>    
	<%
	}
}else{
	out.println("没有访问权限.");
}
%>

