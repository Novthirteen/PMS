<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld"prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld"prefix="tiles"%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<link rel="stylesheet" type="text/css" href="includes/xmlTree/xmlTree.css"/>
<script language="javascript">
</script>
<form>
<% List result = (List)request.getAttribute("resultList");
String pre = "";
%>
<table>
<tr><td>
<A HREF="#A" ><font size="4">A</A>
<A HREF="#B" ><font size="4">B</A>
<A HREF="#C" ><font size="4">C</A>
<A HREF="#D" ><font size="4">D</A>
<A HREF="#E" ><font size="4">E</A>
<A HREF="#F" ><font size="4">F</A>
<A HREF="#G" ><font size="4">G</A>
<A HREF="#H" ><font size="4">H</A>
<A HREF="#I" ><font size="4">I</A>
<A HREF="#J" ><font size="4">J</A>
<A HREF="#K" ><font size="4">K</A>
<A HREF="#L" ><font size="4">L</A>
<A HREF="#M" ><font size="4">M</A>
<A HREF="#N" ><font size="4">N</A>
<A HREF="#O" ><font size="4">O</A>
<A HREF="#P" ><font size="4">P</A>
<A HREF="#Q" ><font size="4">Q</A>
<A HREF="#R" ><font size="4">R</A>
<A HREF="#S" ><font size="4">S</A>
<A HREF="#T" ><font size="4">T</A>
<A HREF="#U" ><font size="4">U</A>
<A HREF="#V" ><font size="4">V</A>
<A HREF="#W" ><font size="4">W</A>
<A HREF="#X" ><font size="4">X</A>
<A HREF="#Y" ><font size="4">Y</A>
<A HREF="#Z" ><font size="4">Z</A></td></tr>
</table>
<hr color="red">
<table>
<tr><td>&nbsp;</td><td class=lblbold>Customer</td><td class=lblbold>Project Description</td>
<td class=lblbold>ProjectCode</td><td></td></tr>
<%
System.out.println("the size is:"+result.size());
if(result!=null){
  for(int i=0;i<result.size();i++)
	{
		ProjectMaster pm = (ProjectMaster)result.get(i);
		if((pm.getCustomer().getChineseName().startsWith(pre.toUpperCase()))||(pm.getCustomer().getChineseName().startsWith(pre.toLowerCase())))
		{%>
		<tr>
		<td>&nbsp;</td>
		<td><%=pm.getCustomer().getChineseName()%></td>
		<td><%=pm.getProjName()%></td>
		<td><%=pm.getProjId()%></td>
		<td><input type="button" value="Select"></td>		
		</tr>
		<%}
		else{
		pre = pm.getCustomer().getChineseName().substring(0,0);
		System.out.println(pre);%>
		<tr><td>#<%=pre.toUpperCase()%></td><td></td><td></td></tr>
		<tr>
		<td>&nbsp;</td>
		<td><%=pm.getCustomer().getChineseName()%></td>
		<td><%=pm.getProjName()%></td>
		<td><%=pm.getProjId()%></td>
		<td><input type="button" value="Select"></td>		
		</tr>
		<%
		}	
	}
}
%>
<tr><td><a name="A">A</a>
</td></tr></table>
<hr colour="red" />
</form>
