<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.skillset.SkillComment" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{
	if (AOFSECURITY.hasEntityPermission("SKILL_SET", "_QUERY", session)) {
	
		List commentList = (List)request.getAttribute("commentList");
	
		if(commentList == null){
			commentList = new ArrayList();
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
		</script>

	</HEAD>
	<BODY>
		<table width=100% cellpadding="1" border="0" cellspacing="1">
			<CAPTION align=center class=pgheadsmall>List Comments</CAPTION>
			<tr align="center">
				<td align="center" class="lblbold" bgcolor="#e9eee9" width="78%">&nbsp;<br>Comments and Suggestions<br>&nbsp;</td>
				<td align="center" class="lblbold" bgcolor="#e9eee9" width="22%">Staff Name</td>
			</tr>
			<%
			if(commentList != null && commentList.size() > 0){
				for (int i =0; i < commentList.size(); i++) {						
					SkillComment tmpValue = (SkillComment)commentList.get(i);					
			%>
			<tr>
		        <td bgcolor="#e9eef9" align="center">
		        	<textarea rows="3" cols="90"  style="border:0px;background-color:#e9eef9" readonly><%=tmpValue.getCommentDesc() == null ? "" : tmpValue.getCommentDesc()%></textarea>
		        </td>
		    	<td bgcolor="#e9eef9" align="center">
		    		<%=tmpValue.getEmployee().getName() == null ? "" : tmpValue.getEmployee().getName()%>
		    	</td>
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
				<td align="right">
					<input type="button" value="Close" class="loginButton" onclick="javascript:fnClose()">
				</td>
			</tr>
		</table>
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