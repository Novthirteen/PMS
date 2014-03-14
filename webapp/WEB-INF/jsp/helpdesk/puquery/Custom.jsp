<%@ page contentType="text/html;charset=gb2312"%>
<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
String sselparty=request.getParameter("selpar");
  if (sselparty==null) {sselparty="";} else{	sselparty=sselparty.trim(); }
%>
<html:html locale="true">
  <head>
	<script>
		function keyin(){
			//alert(province.selectedIndex);
			parent.returncode.value="*%#@$@"+spartyname.value+"*%#@$@"+province.options[province.selectedIndex].text+"*%#@$@";
		}	
		function keyuser(){
			parent.returnuser.value="*%#@$@"+susername.value+"*%#@$@"+sphone.value+"*%#@$@"+smobile.value+"*%#@$@"+semail.value+"*%#@$@"+sfax.value;
		}
		function inittext(){

		}
	</script>	   
    <title>Custom.jsp</title>
    
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
	<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
	<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>    
	<style>
		body { font:10pt; }
		div.clsPriorityHead {
		  margin:1px; 
		  padding-top:2px;
		  padding-bottom:1px;
		  padding-left:6px;
		  padding-right:4px;
		  background-color:#C0C0FF;
		  border:1px solid #C0C0FF;
		}
		div.clsActivePriorityContent {
		  cursor:hand;
		  margin:1px; 
		  padding-top:2px;
		  padding-bottom:1px;
		  padding-left:6px;
		  padding-right:4px;
		  background-color:#F1F1F1;
		  border:1px solid #999999;
		}
		div.clsNormalPriorityContent {
		  cursor:hand;
		  margin:1px; 
		  padding-top:2px;
		  padding-bottom:1px;
		  padding-left:6px;
		  padding-right:4px;
		  border:1px solid #FFFFFF ;
		}
		div.clsMouseOverPriorityContent {
		  cursor:hand;
		  margin:1px; 
		  padding-top:2px;
		  padding-bottom:1px;
		  padding-left:6px;
		  padding-right:4px;
		  background-color:#CCCCCC;
		  border:1px solid #999999;
		}
		div.clsMouseDownPriorityContent {
		  cursor:hand;
		  margin:1px; 
		  padding-top:2px;
		  padding-bottom:1px;
		  padding-left:6px;
		  padding-right:4px;
		  background-color:#999999;
		  border:1px solid #999999;
		}
		select {
			font-size: 9pt; 
			border: #000000; 
			border-style: solid;
			border-top-width: 1px;
			border-right-width: 1px; 
			border-bottom-width: 1px;
			border-left-width: 1px;
			background-color: #FCF5EF
		}
		
	</style>  	    
  </head>
  
  <body onload="inittext()">
	<div style="margin:3px;width:100%;height:270;overflow:auto;scrollbar-base-color:#CCCCCC;scrollbar-3dlight-color:#CCCCCC;scrollbar-darkshadow-color:#CCCCCC">
	  <div class="clsPriorityHead">
	  	<span style="width:30px" class="labeltext">&nbsp;</span>	  
	  </div>	
	  <br>
	  	<div class="clsNormalPriorityContent" id="custenter">
	  	<%
	  	if (sselparty.equals("")) {
	  	%>
		    <span style="width:100px" class="labeltext"><font color='#a90a08'><strong><bean:message key="helpdesk.puquery.party.cust" /></strong></font></span>
			<span style="width:100px"><input type='text' name='spartyname' id='spartyname' value='' size='25' onfocusout="keyin()"></span><br>
		    <span id="splpro" style="width:100px" class="labeltext" align='right'><font color='#a90a08'><strong><bean:message key="helpdesk.puquery.party.province" /></strong></font></span>
		    <span id="sptpro" style="width:100px"><select name=province onchange="keyin()">
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
				      </select></span>
			<br>			    
		<%}%>
		    <span id="splname" style="width:100px" class="labeltext"><font color='#a90a08'><strong><bean:message key="helpdesk.puquery.party.name" /></strong></font></span>
			<span id="sptname" style="width:100px"><input type='text' name='susername' value='' size='25' onfocusout="keyuser()"/></span><br>      
		    <span id="splname" style="width:100px" class="labeltext"><font color='#a90a08'><strong><bean:message key="helpdesk.puquery.party.phone" /></strong></font></span>
			<span id="sptname" style="width:100px"><input type='text' name='sphone' value='' size='25' onfocusout="keyuser()"/></span><br>      
		    <span id="splname" style="width:100px" class="labeltext"><font color='#a90a08'><strong><bean:message key="helpdesk.puquery.party.fax" /></strong></font></span>
			<span id="sptname" style="width:100px"><input type='text' name='sfax' value='' size='25' onfocusout="keyuser()"/></span><br>      
		    <span id="splname" style="width:100px" class="labeltext"><font color='#a90a08'><strong><bean:message key="helpdesk.puquery.party.email" /></strong></font></span>
			<span id="sptname" style="width:100px"><input type='text' name='semail' value='' size='25' onfocusout="keyuser()"/></span><br>      
		    <span id="splname" style="width:100px" class="labeltext"><font color='#a90a08'><strong><bean:message key="helpdesk.puquery.party.mobile" /></strong></font></span>
			<span id="sptname" style="width:100px"><input type='text' name='smobile' value='' size='25' onfocusout="keyuser()"/></span><br>      
			
		</div>	  
	</div>  
	
	<table width="100%" border="1" cellspacing="0" cellpadding="0" rules="rows" frame="hsides">
	<tr><td></td></tr>
	</table>   
  </body>
</html:html>
