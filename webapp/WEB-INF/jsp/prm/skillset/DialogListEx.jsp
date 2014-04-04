<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.skillset.SkillEx" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{
	if (AOFSECURITY.hasEntityPermission("SKILL_SET", "_QUERY", session)) {
		
		List exList = (List)request.getAttribute("exList");
		String staffId = (String)request.getAttribute("staffId");
	
		if(exList == null){
			exList = new ArrayList();
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
				document.listForm.formAction.value = "ex";
				document.listForm.command.value = "exportEx";
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
				<CAPTION align=center class=pgheadsmall>List Projects Experience</CAPTION>
				<tr align="center">
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="50%">&nbsp;<br>Project Description<br>&nbsp;</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="50%">Project Experience</td>
				</tr>
				<%
				if(exList != null && exList.size() > 0){
					for (int i =0; i < exList.size(); i++) {						
						SkillEx tmpValue = (SkillEx)exList.get(i);					
				%>
				<tr>
			        <td bgcolor="#e9eef9" align="center"><textarea rows="3" cols="55"  style="border:0px;background-color:#e9eef9" readonly><%=tmpValue.getExDesc() == null ? "" : tmpValue.getExDesc()%></textarea></td>
			    	<td bgcolor="#e9eef9" align="center"><textarea rows="3" cols="60"  style="border:0px;background-color:#e9eef9" readonly><%=tmpValue.getExExp() == null ? "" : tmpValue.getExExp()%></textarea></td>
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
}catch(Exception e){
	e.printStackTrace();
}
%>