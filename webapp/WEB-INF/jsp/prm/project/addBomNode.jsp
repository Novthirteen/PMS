<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
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
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
	String close = (String)request.getAttribute("CLOSE");
	String error = (String)request.getAttribute("error");
	System.out.println(error);
	if(error!=null){
%>
<script language="javascript">
	window.returnValue ="<%=error%>";
	window.close();
</script>

<%}
else{
	if (close != null && close.equals("TRUE")) {
	ProjPlanBom bom = (ProjPlanBom)request.getAttribute("NewBom");
%>
<script language="javascript">
	window.returnValue = "<%=bom.getRanking()%>"+"|"+"<%=bom.getId()%>"+"|"+"<%=bom.getStepdesc()%>"+"|"
	+"<%if(bom.getParent()!=null)out.print(bom.getParent().getId());else out.print("null");%>"
	window.close();
</script>

<%
	} else {
	String parentranking = (String)request.getAttribute("parentranking");
	String parentdesc = (String)request.getAttribute("parentdesc");
	ProjPlanBomMaster master = (ProjPlanBomMaster)request.getAttribute("master");
%>
<form action="editProjBOMNode.do" method="post">
<br>
<table width=100% align=center Frame=box rules=none bordercolordark=black bordercolorlight=white bgcolor=white>
<CAPTION align="center" class=pgheadsmall>  Add New Node </CAPTION>
<input type="hidden" name="masterid" value="<%=master.getId()%>">
<input type="hidden" name="parentranking" value="<%if(parentranking!=null)out.print(parentranking);else out.print("0");%>">
<input type="hidden" name="formaction" value="add">

	<tr bgcolor="#e9eee9">
	<td class="lblbold" align="center">Parent Node:</td>
	<td class="lblbold" align="center"><%if(parentdesc!=null)out.print(parentdesc);else out.print("Root");%>
	</td>
	</tr>
	<tr bgcolor="#e9eee9">
	<td class="lblbold" align="center">Description :</td>
	<td class="lblbold" align="center"><input size="50" type="text" name="add_desc" 
		style="background-color:#ffffff;border-color:#7F9DB9"/></td>
	</tr>
</table>
<br>
<table>
	<tr>
	<td class="lblbold" align="center">&nbsp;</td>
	<td class="lblbold" align="center"><input type="submit" value="Add" class="button"></td>
	</tr>
	
</table>
</form>
<%}
}%>