<%@ page contentType="text/html;charset=gb2312"%> 
<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>
<script language="JavaScript1.3">
function keyin(con){
	parent.returnuser.value="*%#@$@"+username.value+"*%#@$@"+"*%#@$@"+"*%#@$@";
	parent.returncode.value="*%#@$@"+desc.value+"*%#@$@"+province.options[province.selectedIndex].text;
}
function backform(){

}
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html:html locale="true">
  <head>
    <html:base />
    
    <title>CustUser.jsp</title>
    
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
  </head>
  
<body>
		<table border="0" width="100%" cellspacing="0" cellpadding="0" height="100">
			<tr>
				<td width="20%"></td>
				<td width="20%" height="26"><font size="2">
				��˾����</font></td>
				<td width="40%" height="26"><font face="Arial" size="2">
				<input type='text' name="desc" size="13" maxlength="255" onkeyup="keyin(this)"/>
				</font></td>
				<td width="20%"></td>
			</tr>
			<tr>
				<td width="100"></td>
				<td width="50" height="26"><font size="2">
				����</font></td>
				<td width="171" height="26"><font face="Arial" size="2">
				<input type='text' name="username" id="username" size="13" maxlength="255"  onkeyup="keyin(this)"/>
				</font></td>
				<td width="271"></td>
			</tr>
			<tr>
				<td width="100"></td>
				<td width="50" height="26"><font size="2">
				ʡ</font></td>
				<td width="171" height="26"><font face="Arial" size="2">
				<select name=province onchange="keyin(this)">
			        <option value="-1" selected></option>
			        <option value="2">����</option>
			        <option value="0">�㶫</option>
			        <option value="1">����</option>
			        <option value="3">����</option>
			        <option value="4">����</option>
			        <option value="5">���</option>
			        <option value="6">����</option>
			        <option value="7">����</option>
			        <option value="8">����</option>
			        <option value="9">�ӱ�</option>
			        <option value="10">ɽ��</option>
			        <option value="11">ɽ��</option>
			        <option value="12">������</option>
			        <option value="13">����</option>
			        <option value="14">�Ϻ�</option>
			        <option value="15">����</option>
			        <option value="16">�ຣ</option>
			        <option value="17">�½�</option>
			        <option value="18">����</option>
			        <option value="19">����</option>
			        <option value="20">�Ĵ�</option>
			        <option value="21">����</option>
			        <option value="22">����</option>
			        <option value="23">���ɹ�</option>
			        <option value="24">����</option>
			        <option value="25">����</option>
			        <option value="26">����</option>
			        <option value="27">����</option>
			        <option value="28">����</option>
			        <option value="29">�㽭</option>
			        <option value="30">����</option>
			        <option value="31">����</option>
			        <option value="32">̨��</option>
			        <option value="33">���</option>
			        <option value="34">����</option>
			      </select>
				</font></td>
				<td width="271"></td>
			</tr>			
		</table>
    	<%String stype=request.getParameter("type");%>
    	<%
			  if (request.getParameter("type")==null){
			  	stype="";
			  	}
			  else{
			  	stype=request.getParameter("type").trim();
			  }
    	%>
    	<%if (stype!=""){%>
	    	<html:hidden property="type"  value="1"/>
	    <%}else{%>
	    	<html:hidden property="type"  value=""/>
	    <%}%>		
  </body>
</html:html>
