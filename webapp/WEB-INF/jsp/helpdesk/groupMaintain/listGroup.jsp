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
function createGroup() {
	var formObj = document.create_frm;
	formObj.elements["formAction"].value = "create";
	formObj.target = "_self";
	formObj.submit();
}
function updateGroup(number) {
	var formObj = document.update_frm;
	formObj.elements["formAction"].value = "update";
	formObj.elements["gid"].value = formObj.elements["gid"+number].value;
	formObj.elements["supervisor"].value = formObj.elements["supervisor"+number].value;
	formObj.elements["super_name"].value = formObj.elements["super_name"+number].value;
	formObj.elements["desc"].value = formObj.elements["desc"+number].value;
	formObj.target = "_self";
	formObj.submit();
}
</script>
<Form action="helpdesk.maintainGroup.do" name="create_frm" method="post">
<input type="hidden" name="formAction" id = "formAction">
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">Group Maintainance</caption>
	<tr>
		<td>
			<table width=100% >
				<tr>
					<td colspan="16" valign="bottom"><hr color=red></hr></td>
				</tr>
				<tr>
					<td><input type="button" onclick="createGroup();" value="   New   "></td>
					<%
						Object warningObject = request.getAttribute("warning");
						String warning;
						if(warningObject == null){
							warning = "";
						}else{
							warning = (String)warningObject;
						}
					%>					
					<td><div style="display:inline;color:red"><%=warning%></div></td>					
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<Form action="helpdesk.maintainGroup.do" name="update_frm" method="post">
<input type="hidden" name="formAction" id = "formAction">
<input type="hidden" name="gid" id = "gid">
<input type="hidden" name="supervisor" id = "supervisor">
<input type="hidden" name="super_name" id = "super_name">
<input type="hidden" name="desc" id = "desc">
<input type="hidden" name="isUpdate" id = "isUpdate" value="yes">
<table width="100%" cellpadding="2" border="0" cellspacing="2">
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
			<td><a href="#" onclick="updateGroup(<%=seq%>);"><%=cg.getId()%></a></td>
			<input type="hidden" name="<%="gid"+seq%>" id = "<%="gid"+seq%>" value="<%=cg.getId()%>">
			<td><%=cg.getSupvisor().getName()%></td>
			<input type="hidden" name="<%="supervisor"+seq%>" id = "<%="supervisor"+seq%>" value="<%=cg.getSupvisor().getUserLoginId()%>">
			<input type="hidden" name="<%="super_name"+seq%>" id = "<%="super_name"+seq%>" value="<%=cg.getSupvisor().getName()%>">
			<td><%=cg.getDescription()%></td>
			<input type="hidden" name="<%="desc"+seq%>" id = "<%="desc"+seq%>" value="<%=cg.getDescription()%>">
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