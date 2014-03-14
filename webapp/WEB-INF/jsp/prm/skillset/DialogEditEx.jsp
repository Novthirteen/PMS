<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.skillset.SkillEx" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{
	if (AOFSECURITY.hasEntityPermission("SKILL_SET", "_MAINTENANCE", session)) {
	
		List valueList = (List)request.getAttribute("valueList");
	
		if(valueList == null){
			valueList = new ArrayList();
		}
%>

<HTML>
	<HEAD>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>

		<script language="javascript">
			
			function fnAdd() {
				if(document.editForm.iExDesc == null ||document.editForm.iExDesc.value == ""){
					alert("Please input the description of project.");
					return;
				}
				
				if(document.editForm.iExExp == null ||document.editForm.iExExp.value == ""){
					alert("Please input the description of your project experience.");
					return;
				}
			   
				document.editForm.command.value = "createEx";
				document.editForm.submit();
			}
			
			function onClose() {
				var recordCount = document.editForm.recordCount.value;				
				window.parent.returnValue = recordCount;
				window.parent.close();
			}
			
			function loadParam() {
				var recordCount = document.editForm.recordCount.value;				
				window.parent.returnValue = recordCount;
			}
		</script>
	</HEAD>
	<BODY onunload="loadParam()">

		<form name="editForm" action="skillAction.do" method="post">
		
			<input type="hidden" name="formAction" value="ex">
			<input type="hidden" name="command" value="">
			<input type="hidden" name="recordCount" value="<%=valueList.size()%>">
			
			<table width=102% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>Edit Projects Experience</CAPTION>
				<tr align="center">
					<td align="center" class="lblbold" bgcolor="#e9eee9">Project Description<br>(Please input the information of project as detailed as you can)</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9">Project Experience<br>(Please input the description of the role you acted in project)</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="8%">Action</td>
				</tr>
				<%
				if(valueList != null || valueList.size() > 0){
					for (int i =0; i < valueList.size(); i++) {						
						SkillEx tmpValue = (SkillEx)valueList.get(i);					
				%>
				<tr>
					<input type="hidden" name="certId" value="<%=tmpValue.getExId()%>">
			        <td bgcolor="#e9eef9" align="center">
			        	<textarea rows="3" cols="60"  style="border:0px;background-color:#e9eef9" readonly><%=tmpValue.getExDesc() == null ? "" : tmpValue.getExDesc()%></textarea>
			        </td>
			    	<td bgcolor="#e9eef9" align="center">
			    		<textarea rows="3" cols="65"  style="border:0px;background-color:#e9eef9" readonly><%=tmpValue.getExExp() == null ? "" : tmpValue.getExExp()%></textarea></td>
					<td bgcolor="#e9eef9" align="center">
						<a href="skillAction.do?formAction=ex&command=removeEx&exId=<%=tmpValue.getExId()%>">Delete</a>
					</td>
			    </tr>
				<%
					}
				}
				%>
				<tr>
					<td colspan=8 valign="bottom"><hr color="#B5D7D6"></hr></td>
				</tr>
				<tr>
					<td align="center">
						<textarea name="iExDesc" rows="3" cols="60" style="background-color:#ffffff"></textarea>
					</td>
			        <td align="center">
			        	<textarea name="iExExp" rows="3" cols="65" style="background-color:#ffffff"></textarea>
					</td>
			        <td align="center">
						<input type="button" value="Add" class="loginButton" onclick="javascript:fnAdd();"/>
			        </td>
				</tr>
				<tr>
					<td>&nbsp;</td><td>&nbsp;</td>
					<td align="center"><input type="button" value="Close" class="loginButton" onclick="javascript:onClose()"></td>
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