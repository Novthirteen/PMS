<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.report.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.component.helpdesk.ConsultantGroup"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
if (AOFSECURITY.hasEntityPermission("HELPDESK_GROUP", "_BROWSE", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
Object groupListObject = request.getAttribute("groupList");
List groupList = null;
if(groupListObject != null)	groupList = (List)groupListObject;

%>
<script language="javascript">
function assignGroup(number) {
	var formObj = document.update_frm;
	formObj.elements["formAction"].value = "assignPage";
	formObj.elements["gid"].value = formObj.elements["gid"+number].value;
	formObj.elements["supervisor"].value = formObj.elements["supervisor"+number].value;
	formObj.elements["super_name"].value = formObj.elements["super_name"+number].value;
	formObj.elements["desc"].value = formObj.elements["desc"+number].value;
	formObj.target = "_self";
	formObj.submit();
}

</script>
<Form action="helpdesk.assignGroupMember.do" name="update_frm" method="post">
<input type="hidden" name="formAction">
<input type="hidden" name="gid">
<input type="hidden" name="supervisor">
<input type="hidden" name="super_name">
<input type="hidden" name="desc">
<table width="100%" cellpadding="2" border="0" cellspacing="2">
<caption class="pgheadsmall">Helpdesk Group List</caption>
	<tr>
		<td colspan="16" valign="bottom"><hr color=red></hr></td>
	</tr>
	<tr bgcolor="#e9eee1">
		<td class="lblbold">Group ID</td>
		<td class="lblbold">Supervisor</td>
		<td class="lblbold">Description</td>
	</tr>
	<%
	if(groupList!=null){
		Iterator groupIte = groupList.iterator();
		int seq = 0;
		while(groupIte.hasNext()){
			ConsultantGroup cg= (ConsultantGroup)groupIte.next();
	%>
		<tr bgcolor="#e9eee1">
			<td><a href="#" onclick="assignGroup(<%=seq%>);"><%=cg.getId()%></a></td>
			<input type="hidden" name="<%="gid"+seq%>" value="<%=cg.getId()%>">
			<td><%=cg.getSupvisor().getName()%></td>
			<input type="hidden" name="<%="supervisor"+seq%>" value="<%=cg.getSupvisor().getUserLoginId()%>">
			<input type="hidden" name="<%="super_name"+seq%>" value="<%=cg.getSupvisor().getName()%>">
			<td><%=cg.getDescription()%></td>
			<input type="hidden" name="<%="desc"+seq%>" value="<%=cg.getDescription()%>">
		</tr>
	<%seq++;}}%>
</table>
</form>
<%
}else{
	out.println("没有访问权限.");
}
} catch(Exception ex) {
	ex.printStackTrace();
}
%>