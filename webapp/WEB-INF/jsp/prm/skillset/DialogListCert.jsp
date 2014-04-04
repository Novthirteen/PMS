<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.skillset.SkillCert" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("SKILL_SET", "_QUERY", session)) {

	SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");

	List certList = (List)request.getAttribute("certList");
	String staffId = (String)request.getAttribute("staffId");

	if(certList == null){
		certList = new ArrayList();
	}

	if(staffId == null){
		staffId = "";
	}
%>

<HTML>
	<HEAD>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>

		<script language="javascript">
			
			function fnClose() {
				window.parent.close();
			}
			
			function fnExcel() {
				document.listForm.formAction.value = "cert";
				document.listForm.command.value = "exportCert";
				document.listForm.submit();
			}
		</script>
	</HEAD>
	<BODY>
		<form name="listForm" action="skillAction.do" method="post">
			<input type="hidden" name="formAction" id="formAction" value="">
			<input type="hidden" name="command" id="command" value="">
			<input type="hidden" name="staffId" id="staffId" value="<%=staffId%>">
			<table width=102% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>List Personal Certification</CAPTION>
				<tr align="center">
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="75%">Professional Certification<br>(please input the name and level of the certification you have had)</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="25%">Date of Grant</td>
				</tr>
				<%
				if(certList != null && certList.size() > 0){
					for (int i =0; i < certList.size(); i++) {						
						SkillCert tmpValue = (SkillCert)certList.get(i);					
				%>
				<tr>
			        <td bgcolor="#e9eef9" align="center"><%=tmpValue.getCertDesc() == null ? "" : tmpValue.getCertDesc()%></td>
			    	<td bgcolor="#e9eef9" align="center"><%=tmpValue.getDateGrant() == null ? "" : dateFormater.format(tmpValue.getDateGrant())%></td>
			    </tr>
				<%
					}
				}
				%>
				<tr>
					<td colspan=2 valign="bottom"><hr color="#B5D7D6"></hr></td>
				</tr>
				<tr align="right">
					<td>&nbsp;</td>
					<td align="center">
						<input type="button" value="Export Excel" class="loginButton" onclick="javascript:fnExcel()">
						<input type="button" value="Close" class="loginButton" onclick="javascript:fnClose()">
					</td>
				</tr>
			</table>
		</form>
	</BODY>
</HTML>
<%	
	}else{
		out.println("!!你没有相关访问权限!!");
	}
%>