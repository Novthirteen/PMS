<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.report.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.component.helpdesk.ConsultantAssign"%>
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
if (AOFSECURITY.hasEntityPermission("HELPDESK_GROUP", "_ASSIGN", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
Object memberObject = request.getAttribute("memberList");
List memberList = null;
if(memberObject != null)	memberList = (List)memberObject;

String action = request.getParameter("formAction");
String gid = request.getParameter("gid");
String desc = request.getParameter("desc");
String supervisor = request.getParameter("supervisor");
String super_name = request.getParameter("super_name");

if(action==null){
	action="";
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
function removeMember(rowid){
	document.frm.formAction.value="remove";
	document.frm.uid.value=rowid;
	document.frm.submit();
}
function backToList() {
	location.href="helpdesk.assignGroupMember.do";
}
function showDialog_staff() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.frm.formAction.value="assign";
			document.frm.uid.value=v.split("|")[0];
			document.frm.submit();
	}
}
</script>
<Form action="helpdesk.assignGroupMember.do" name="frm" method="post">
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">Helpdesk Group Member Assignment</caption> 
	<tr>
		<td>
				<input type="hidden" name="formAction" id = "formAction">
				<input type="hidden" name="gid" id = "gid" value="<%=gid%>">
				<!--when deleting , uid represents the row id-->
				<input type="hidden" name="uid" id = "uid">
				<input type="hidden" name="desc" id = "desc" value="<%=desc%>">
				<input type="hidden" name="super_name" id = "super_name" value="<%=super_name%>">
				<table width=100% >
					<tr>
						<td colspan="16" valign="bottom"><hr color=red></hr></td>
					</tr>
					<tr>
						<td/>
						<td class="lblbold">Group ID:</td>
						<td class="lblLight">
							<%=gid%>
						</td>
						<td/>
					<tr>
						<td/>
						<td class="lblbold">Supervisor:</td>
						<td class="lblLight">
							<%=super_name%>
						</td>
						<td/>
					</tr>
					<tr>
						<td/>
						<td class="lblbold">Description:</td>
						<td class="lblLight">
							<%=desc%>
						</td>
						<td/>
					</tr>
					<tr>
						<td colspan="16" valign="top"><hr color=red></hr></td>
					</tr>
				</table>
				<br>
				
				<table width="100%">
					<tr>
						<td><input type="button" value="Add Member" onclick="showDialog_staff();">&nbsp;
						<input type="button" value="Back To List" onclick="backToList();"></td>
						<%
							Object warningObject = request.getAttribute("warning");
							String warning;
							if(warningObject == null){
								warning = "";
							}else{
								warning = (String)warningObject;
							}
						%>					
						<td colspan="4"><div style="display:inline;color:red"><%=warning%></div></td>			
					</tr>
					<tr>
						<td colspan="5"/>
					</tr>
					<tr bgcolor="#e9eee1">
						<td class="lblbold" width="20%">User Login ID</td>
						<td class="lblbold" width="20%">User Name</td>
						<td class="lblbold" width="20%">Department</td>
						<td class="lblbold" width="20%">Email</td>
						<td class="lblLight" width="20%">&nbsp;</td>
					</tr>
					<%
					if(memberList!=null){
						Iterator memberIte = memberList.iterator();
						while(memberIte.hasNext()){
						ConsultantAssign ca = (ConsultantAssign)memberIte.next();
					%>
						<tr bgcolor="#e9eee1">
							<td><%=ca.getConsultant().getUserLoginId()%></td>
							<td><%=ca.getConsultant().getName()%></td>
							<td><%=ca.getConsultant().getParty().getDescription()%></td>
							<td><%=ca.getConsultant().getEmail_addr()%></td>
							<td><a href="#" onclick="removeMember(<%=ca.getId()%>);">Remove</a></td>
						</tr>
					<%  }
					}else{%>
						<tr><td colspan="5" align="center">The group has no members!</tr>
					<%}%>
				</table>
		</td>
	</tr>
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