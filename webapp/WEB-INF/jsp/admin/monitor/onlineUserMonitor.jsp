<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
	if (AOFSECURITY.hasEntityPermission("ONLINE_USER", "_VIEW", session)) {
%>
<form name="form1" action="onlineUserMonitor.do" method="post">
	<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
	  <TR>
	    <TD width='100%'>
	      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
	        <tr>
	          <TD align=left width='90%' class="wpsPortletTopTitle">
	           Online Users
	          </TD>
	        </tr>
	      </table>
	    </TD>
	  </TR>
	  
	  <TR>
	    <td>
			<table border="0" cellpadding="1" cellspacing="1" width=100%>
				<tr bgcolor="#e9eee9">
					<td class="lblbold" align="center">&nbsp;User Id&nbsp;</td>
					<td class="lblbold" align="center">&nbsp;User Name&nbsp;</td>
					<td class="lblbold" align="center">&nbsp;Department&nbsp;</td>
					<td class="lblbold" align="center">&nbsp;IP Address&nbsp;</td>
					<td class="lblbold" align="center">&nbsp;Login Time&nbsp;</td>
					<td class="lblbold" align="center">&nbsp;Last Access Time&nbsp;</td>
				</tr>
				<%
					Map userMap = (Map)application.getAttribute(Constants.ONLINE_USER_KEY);
					
					if (userMap != null && userMap.size() > 0) {
						Set keySet = userMap.keySet();
						Iterator it = keySet.iterator();
						SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						while(it.hasNext()) {
							HttpSession userSession = (HttpSession)userMap.get(it.next());								
							try {							
								UserLogin ul = (UserLogin)userSession.getAttribute(Constants.USERLOGIN_KEY);
								String ip = (String)userSession.getAttribute(Constants.ONLINE_USER_IP_ADDRESS);
				%>
				<tr>
					<td class="tabletext" align="left"><%=ul.getUserLoginId()%></td>
					<td class="tabletext" align="left"><%=ul.getName()%></td>
					<td class="tabletext" align="left"><%=ul.getParty().getDescription()%></td>
					<td class="tabletext" align="left"><%=ip%></td>
					<td class="tabletext" align="center"><%=dateFormat.format(new Date(userSession.getCreationTime()))%></td>
					<td class="tabletext" align="center"><%=dateFormat.format(new Date(userSession.getLastAccessedTime()))%></td>
				</tr>
				<%
							} catch (IllegalStateException ex) {
							
							}
						}
					} else {
				%>
				<tr bgcolor="#e9eee9">
					<td align="center" class="lblerr" colspan="5">
			    		No User Found.
			    	</td>
				</tr>
				<%
					}
				%>
			</table>
	      </td>
	  	</tr>
	  	<br>
	  	<TR>
		    <TD width='100%'>
		      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
		        <tr>
		          <TD align=left>
		           &nbsp;&nbsp;<input type="submit" name="submit" value="Refresh">
		          </TD>
		        </tr>
		      </table>
		    </TD>
	  	</TR>
	  <br>
	</table> 
</form>
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
