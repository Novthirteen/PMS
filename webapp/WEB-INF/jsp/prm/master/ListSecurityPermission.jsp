<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%try{%>
<%if (AOFSECURITY.hasEntityPermission("PAS_PERMISSION", "_VIEW", session)) {
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
%>
<script language="javascript">

function ExportExcel() {
	var formObj = document.frm;
	formObj.elements["FormAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
</script>

<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> PAS Permissions List </caption> 
<tr>
	<td>
		<Form action="ListSecurityPermission.do" name="frm" method="post">
		<input type="hidden" name="FormAction" id="FormAction">
		<table width=100%>
			<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr>
				<td colspan=3></td>
				<td  align="center" >
				<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
				</td>
			</tr>
			<tr bgcolor="#e9eee9">
				<td align=center class="lblbold">&nbsp;Permission Group &nbsp;</td>
				<td align=center class="lblbold">&nbsp;Group Description &nbsp;</td>
				<td align=center class="lblbold">&nbsp;Security Permission&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Permission Description&nbsp;</td>
			</tr>
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			Object resultSet_data;
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='4' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				String oldGroup ="";
				String newGroup ="";
				for (int row =0; row < sr.getRowCount(); row++) {
				newGroup = sr.getString(row,"group_id");

				if (!newGroup.equals(oldGroup)){
					oldGroup = newGroup ;
			%>
					<tr bgcolor="#e9eee9"> 
						<td nowrap align=left class="lblbold"><%=sr.getString(row,"group_id")%></td>
						<td nowrap align=left ><%=sr.getString(row,"group_desc")%></td>
						<td nowrap align=left><%=sr.getString(row,"permission_id")%></td>
						<td nowrap align=left ><%=sr.getString(row,"permission_desc")%></td>
					</tr>
					<%}else{%>
						<tr bgcolor="#e9eee9">
						<td></td>
						<td></td>
						<td nowrap align=left><%=sr.getString(row,"permission_id")%></td>
						<td nowrap align=left ><%=sr.getString(row,"permission_desc")%></td>
					</tr>
					<%}%>
				<%}%>
			<%}%>
		</table>
	</td>
</tr>
</table>

<%
}else{
	out.println("没有访问权限.");
}
%>
<%}catch (Exception e){
			e.printStackTrace();
		}%>