<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.skillset.SkillComment" %>

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
				if(document.editForm.iCommentDesc == null ||document.editForm.iCommentDesc.value == ""){
					alert("Please input your comment.");
					return;
				}
				
				document.editForm.command.value = "createComment";
				document.editForm.submit();
			}
			
			function onClose() {
				window.parent.close();
			}
		</script>
	</HEAD>
	<BODY>
		<form name="editForm" action="skillAction.do" method="post">
			<table width=100% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>Edit Comments or Suggestions</CAPTION>				
				<input type="hidden" name="formAction" id="formAction" value="comment">
				<input type="hidden" name="command" id="command" value="">
				
				<tr align="center">
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="60%">Your Suggestions or Comments</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="10%">Action</td>
				</tr>
				<%
				if(valueList != null || valueList.size() > 0){
					for (int i =0; i < valueList.size(); i++) {						
						SkillComment tmpValue = (SkillComment)valueList.get(i);					
				%>
				<tr>
					<input type="hidden" name="certId" id="certId" value="<%=tmpValue.getCommentId()%>">
					<td bgcolor="#e9eef9" align="center"><textarea rows="3" cols="90"  style="border:0px;background-color:#e9eef9" readonly><%=tmpValue.getCommentDesc() == null ? "" : tmpValue.getCommentDesc()%></textarea></td>
					<td bgcolor="#e9eef9" align="center">
						<a href="skillAction.do?formAction=comment&command=removeComment&commentId=<%=tmpValue.getCommentId()%>">Delete</a>
					</td>
			    </tr>
			    <tr></tr>
				<%
					}
				}
				%>
				<tr>
					<td colspan=8 valign="bottom"><hr color="#B5D7D6"></hr></td>
				</tr>
				<tr>
					<td align="center">						
						<textarea name="iCommentDesc" rows="3" cols="90" style="background-color:#ffffff"></textarea>
					</td>
			        <td align="center">
						<input type="button" value="Add" class="loginButton" onclick="javascript:fnAdd();"/>
			        </td>
				</tr>
				<tr>
					<td>&nbsp;</td>
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