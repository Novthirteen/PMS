<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.skillset.Skill" %>
<%@ page import="com.aof.component.domain.party.UserLogin" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{
	if (AOFSECURITY.hasEntityPermission("SKILL_SET", "_QUERY", session)) {
	
		List valueList = (List)request.getAttribute("valueList");
		if(valueList == null){
			valueList = new ArrayList();
		}
%>
<html>
	<head>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		<script language="javascript">
			function fnExprot(){
				document.listForm.formAction.value = "export";
				document.listForm.submit();
			}
			
			function fnClose(){
				window.parent.close();
			}
			
			function fnViewCert(id){
			
				var param = "?formAction=cert&command=queryCert&staffId=" + id;
				
				v = window.showModalDialog(
					"system.showDialog.do?title=prm.cert.dialog.title&skillAction.do" + param,
					null,
					'dialogWidth:650px;dialogHeight:400px;status:no;help:no;scroll:no');
			}
			
			function fnViewEx(id){
			
				var param = "?formAction=ex&command=queryEx&staffId=" + id;
				
				v = window.showModalDialog(
					"system.showDialog.do?title=prm.experience.dialog.title&skillAction.do" + param,
					null,
					'dialogWidth:660px;dialogHeight:400px;status:no;help:no;scroll:no');
			}
		</script>
	</head>
	<body>
		<form name="listForm" action="skillAction.do" method="post">
			<input type="hidden" name="formAction" value="">
			<input type="hidden" name="catId" value="<%=(String)request.getAttribute("catId")%>">
			<input type="hidden" name="levelId" value="<%=(String)request.getAttribute("levelId")%>">
			<table width=102% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>Staff List</CAPTION>
				<tr align="center">
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="15%">Dept.</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="8%">Staff ID</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="18%">Name</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="8%">Type</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="8%">Tel</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="28%">E-Mail</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="25%">Certification</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="25%">Projects Experience</td>
				</tr>
				<%
				if(valueList != null && valueList.size() > 0){
					for (int i =0; i < valueList.size(); i++) {
						UserLogin tmpValue = ((Skill)valueList.get(i)).getEmployee();
				%>
				<tr>
				<%
						String dept = tmpValue.getParty().getDescription();
						if(dept == null || dept.length() <= 0){
							dept = "";
						}
						
						String userId = tmpValue.getUserLoginId();
						if(userId == null || userId.length() <= 0){
							userId = "";
						}
						
						String userName = tmpValue.getName();
						if(userName == null || userName.length() <= 0){
							userName = "";
						}
						
						String userType = tmpValue.getType();
						if(userType == null || userType.length() <= 0){
							userType = "";
						}
						
						String userTel = tmpValue.getTele_code();
						if(userTel == null || userTel.length() <= 0){
							userTel = "";
						}
						
						String userEmail = tmpValue.getEmail_addr();
						if(userEmail == null || userEmail.length() <= 0){
							userEmail = "";
						}
				%>
			        <td bgcolor="#e9eef9" align="center"><%=dept%></td>
			    	<td bgcolor="#e9eef9" align="center"><%=userId%></td>
					<td bgcolor="#e9eef9" align="center"><%=userName%></td>
					<td bgcolor="#e9eef9" align="center"><%=userType%></td>
					<td bgcolor="#e9eef9" align="center"><%=userTel%></td>
					<td bgcolor="#e9eef9" align="center"><%=userEmail%></td>
					<td bgcolor="#e9eef9" align="center"><a style="cursor:hand" onclick="fnViewCert('<%=userId%>')">View</a></td>
					<td bgcolor="#e9eef9" align="center"><a style="cursor:hand" onclick="fnViewEx('<%=userId%>')">View</a></td>
			    </tr>
				<%
					}
				}
				%>
				<tr>
					<td colspan=8 valign="bottom"><hr color="#B5D7D6"></hr></td>
				</tr>
				<tr>
					<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
					<td align="right">
						<input type="button" value="Export Excel" class="loginButton" onclick="fnExprot()">
					</td>
					<td align="left">
						<input type="button" value="Close" class="loginButton" onclick="fnClose()">
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
<%	
	}else{
		out.println("!!你没有相关访问权限!!");
	}
}catch(Exception e){
	e.printStackTrace();
}
%>