<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ pageimport="java.util.Date"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
           Fiscal Calendar
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <td>
		<table border="0" cellpadding="1" cellspacing="1" width=100%>
			<tr bgcolor="#e9eee9">
				<td class="lblbold" align="center">&nbsp;Period&nbsp;</td>
				<td class="lblbold" align="center">&nbsp;Start Date&nbsp;</td>
				<td class="lblbold" align="center">&nbsp;End Date&nbsp;</td>
				<td class="lblbold" align="center">&nbsp;Close Date&nbsp;</td>
				
			</tr>
			<%
				List list = (List)request.getAttribute("QryList");
				SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
				if (list != null && list.iterator().hasNext()) {
					Iterator iterator = list.iterator();
					
					while(iterator.hasNext()) {
						FMonth fm = (FMonth)iterator.next();
			%>
			<%	Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
				
				if( nowDate.after(fm.getDateFrom()) && nowDate.before(fm.getDateTo())){
				%>
					<tr bgcolor="#B4D4D4" >
						<td class="tabletext" align="center"><%=fm.getYear()%>-<%=fm.getMonthSeq()+1%></td>
						<td class="tabletext" align="center"><%=fm.getDateFrom()%></td>
						<td class="tabletext" align="center"><%=fm.getDateTo()%></td>
						<td class="tabletext" align="center"><b><%=fm.getDateFreeze()%></b></td>
					</tr>
					
			<%	} else { 
			%> 
			<tr>
			<td class="tabletext" align="center"><%=fm.getYear()%>-<%=fm.getMonthSeq()+1%></td>
			<td class="tabletext" align="center"><%=fm.getDateFrom()%></td>
			<td class="tabletext" align="center"><%=fm.getDateTo()%></td>
			<td class="tabletext" align="center"><%=fm.getDateFreeze()%></td>
			</tr>
			<%
						}
					}
				}
			%>
		</table>
      </td>
  	</tr>
</table>