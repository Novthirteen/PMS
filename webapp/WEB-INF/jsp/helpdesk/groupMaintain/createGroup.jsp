<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.report.*"%>
<%@ page import="com.aof.core.security.Security"%>
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
if (AOFSECURITY.hasEntityPermission("HELPDESK_GROUP", "_CREATE", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
String action = request.getParameter("formAction");
String gid = request.getParameter("gid");
String desc = request.getParameter("desc");
String supervisor = request.getParameter("supervisor");
String super_name = request.getParameter("super_name");

String isUpdate = request.getParameter("isUpdate");

if(isUpdate==null){
	isUpdate = "";
}

if(action==null){
	action="create";
}
if(gid==null){
	gid="";
}

if (desc == null) {
	desc = "";
}

if (supervisor == null) {
	supervisor = "";
}

if(super_name == null){
	super_name="";
}

%>
<script language="javascript">
function saveGroup(sign) {
	var formObj = document.frm;
	if(sign=="yes"){
		formObj.elements["formAction"].value = "realUpdate";
	}else{
		formObj.elements["formAction"].value = "realCreate";
	}
	formObj.elements["isUpdate"].value = "yes";
	formObj.target = "_self";
	formObj.submit();
}
function deleteGroup() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "delete";
	formObj.target = "_self";
	formObj.submit();
}
function backToList() {
	location.href="helpdesk.maintainGroup.do";
}
function showDialog_staff() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.frm.supervisor.value=v.split("|")[0];
			document.frm.super_name.value=v.split("|")[1];
			sup_name.innerHTML=v.split("|")[1];	
	}
}
</script>

<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">Helpdesk Group Creation / Update</caption> 
	<tr>
		<td>
			<Form action="helpdesk.maintainGroup.do" name="frm" method="post">
				<input type="hidden" name="formAction">
				<input type="hidden" name="gid" value="<%=gid%>">
				<table width=100% >
					<tr>
						<td colspan="16" valign="bottom"><hr color=red></hr></td>
					</tr>
					<tr>
						<td/>
						<td class="lblbold">Supervisor:</td>
						<td class="lblLight">
							<div style="display:inline" id="sup_name"><%=super_name%>&nbsp;</div>
							<input type="hidden" name="supervisor" value="<%=supervisor%>">
							<input type="hidden" name="super_name" value="<%=super_name%>">
							<a href="javascript:showDialog_staff()"><img align="absmiddle" alt="Select supervisor of the group/>" src="images/select.gif" border="0" /></a>
						</td>
						<td/>
					<tr>
						<td/>
						<td class="lblbold">Description:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="desc" size="20" value="<%=desc%>">
						</td>
						<td/>
					</tr>
					<tr>
						<td colspan="3"/>
						<td>
						<input type="hidden" name="isUpdate">
						<input type="button" value="Save" onclick="saveGroup('<%=isUpdate%>');">
						<input type="button" value="Delete" onclick="deleteGroup();">
						<input type="button" value="Back To List" onclick="backToList();"></td>
					</tr>
					<tr>
						<td colspan="16" valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
</table>

<%
}else{
	out.println("没有访问权限.");
}
} catch(Exception ex) {
	ex.printStackTrace();
}
%>