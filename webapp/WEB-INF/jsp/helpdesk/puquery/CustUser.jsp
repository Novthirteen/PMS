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
				公司描述</font></td>
				<td width="40%" height="26"><font face="Arial" size="2">
				<input type='text' name="desc" size="13" maxlength="255" onkeyup="keyin(this)"/>
				</font></td>
				<td width="20%"></td>
			</tr>
			<tr>
				<td width="100"></td>
				<td width="50" height="26"><font size="2">
				姓名</font></td>
				<td width="171" height="26"><font face="Arial" size="2">
				<input type='text' name="username" id="username" size="13" maxlength="255"  onkeyup="keyin(this)"/>
				</font></td>
				<td width="271"></td>
			</tr>
			<tr>
				<td width="100"></td>
				<td width="50" height="26"><font size="2">
				省</font></td>
				<td width="171" height="26"><font face="Arial" size="2">
				<select name=province onchange="keyin(this)">
			        <option value="-1" selected></option>
			        <option value="2">北京</option>
			        <option value="0">广东</option>
			        <option value="1">广西</option>
			        <option value="3">海南</option>
			        <option value="4">福建</option>
			        <option value="5">天津</option>
			        <option value="6">湖南</option>
			        <option value="7">湖北</option>
			        <option value="8">河南</option>
			        <option value="9">河北</option>
			        <option value="10">山东</option>
			        <option value="11">山西</option>
			        <option value="12">黑龙江</option>
			        <option value="13">辽宁</option>
			        <option value="14">上海</option>
			        <option value="15">甘肃</option>
			        <option value="16">青海</option>
			        <option value="17">新疆</option>
			        <option value="18">西藏</option>
			        <option value="19">宁夏</option>
			        <option value="20">四川</option>
			        <option value="21">云南</option>
			        <option value="22">吉林</option>
			        <option value="23">内蒙古</option>
			        <option value="24">陕西</option>
			        <option value="25">安徽</option>
			        <option value="26">贵州</option>
			        <option value="27">江苏</option>
			        <option value="28">重庆</option>
			        <option value="29">浙江</option>
			        <option value="30">江西</option>
			        <option value="31">国外</option>
			        <option value="32">台湾</option>
			        <option value="33">香港</option>
			        <option value="34">澳门</option>
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
