<%@ page contentType="text/html;charset=gb2312"%> 
<%@ page language="java"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%>
<%
  response.setHeader("Pragma","No-cache");
  response.setHeader("Cache-Control","no-cache");
  response.setDateHeader("Expires", 0);
%>
<%String stype=request.getParameter("type");
  if (request.getParameter("type")==null){
  	stype="";
  	}
  else{
  	stype=request.getParameter("type").trim();
  }
  String stab=request.getParameter("tab");
  if (request.getParameter("tab")==null){
  	stab="";
  	}
  else{
  	stab=request.getParameter("tab").trim();
  }
  
  String sstyle=request.getParameter("style");
  if (request.getParameter("style")==null){
  	sstyle="";
  	}
  else{
  	sstyle=request.getParameter("style").trim();
  }  
%>	
<script language="JavaScript1.3">


function retselect(){
	<%if (stype.equals("")){%>
	if (returncode.value==""){
		alert("请选择公司!");
		return false;
	}
	<% if (sstyle.equals("")){%>
		if (returnuser.value==""){
			alert("请选择或者输入人员!");
			return false;
		}
	<%	}%>
	<%}else{%>
	if (returncode.value==""){
		alert("请选择公司!");
		return false;
	}
	<%}	%>	
	
	//return false;
//	alert(self.frames["pat1"].title);
	var arcode=returncode.value.split('*%#@$@');
	var arreturncode= new Array();
	arreturncode["partyid"]=arcode[0];
	arreturncode["description"]=arcode[1];
	arreturncode["province"]=arcode[2];
	arreturncode["note"]=arcode[3];
	
	if (returnuser.value=="") {
		returnuser.value="*%#@$@"+"*%#@$@"+"*%#@$@"+"*%#@$@"+"*%#@$@";
	}
	var aruser=returnuser.value.split('*%#@$@');
	var arreturnuser=new Array();
	arreturnuser["user_login_id"]=aruser[0];
	arreturnuser["name"]=aruser[1];
	arreturnuser["tel"]=aruser[2];
	arreturnuser["mobile"]=aruser[3];
	arreturnuser["email"]=aruser[4];
	arreturnuser["fax"]=aruser[5];
	
	var retVal=new Array();
	retVal["party"]=arreturncode;
    retVal["user"]=arreturnuser;
    //alert(retVal["party"]["description"]);
	window.parent.returnValue = retVal;
	window.parent.close();
}

</script> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<style type="text/css">
	<!--
	.tabs {position:relative; height: 27px; margin: 0px; padding: 0px; background:url("../images/bar_off.gif") repeat-x; overflow:hidden}
	.tabs li {display:inline;}
	.tabs a:hover, .tabs a.tab-active {background:#fff url("../images/bar_on.gif") repeat-x; border-right: 1px solid #fff} 
	.tabs a  {height: 27px; font:12px verdana, helvetica, sans-serif;font-weight:bold;
	    position:relative; padding:5px 10px 10px 10px; margin: 0px -4px 0px 0px; color:#2B4353;text-decoration:none;border-left:1px solid #fff; border-right:1px solid #6D99B6;}
	.tab-container {background: #fff; border:1px solid #6D99B6;height: 400px;}
	.tab-panes { margin: 3px;}
	// -->
	</style>  
	<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
	<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
    
    <title>查询</title>
   
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
  </head>
  
<body topmargin="0" leftmargin="0">

<input type='hidden' name="returncode" value=""/>
<input type='hidden' name="returnuser" value=""/>

<!--
<input type='text' name="returncode" id="returncode" value=""/>
<input type='text' name="returnuser" id="returnuser" value=""/>
-->

<table border="0" width="400" cellspacing="0" cellpadding="0" height="300">
  <tr>
    <td width="2%" height="17" bgcolor="#B4D4D4" valign="top">
      <p align="left"><img border="0" src="images/conerLeft.bmp" width="4" height="4"></td>
    <td width="80%" height="17" bgcolor="#B4D4D4"></td>
    <td width="2%" height="17" bgcolor="#B4D4D4" valign="top">
      <p align="right"><img border="0" src="images/conerRight.bmp" width="4" height="4"></td>
  </tr>
 
  <tr>
    <td width="2%" height="150" bgcolor="#DEEBEB"></td>
    <td width="80%" height="150" bgcolor="#DEEBEB" valign="top">
      <table border="0" width="100%" cellspacing="0" cellpadding="0">
        <tr>
          <td width="98%" height="12">
			<p align="center"><font face="Arial" size="2"></font></td>
          <td width="2%" height="12"></td>
        </tr>
        
        <tr valign="top">
          <td width="98%" height="100" valign="top">
			<div class="tab-container" id="container1">
				<div id="pane1">
					<Iframe src="helpdesk.PartyCondition.do<%if (stype!="") out.print("?type=1");%>" scrolling="auto" frameborder="0" name="pat1" width="100%" height="120"></iframe>
				</div>
				<div id="pane2" style="width:410">
					<Iframe src="helpdesk.PUserlist.do?partyname=&username=<%if (stype!="") out.print("&type=1");%>" scrolling="auto" frameborder="0" name="pat2" width="100%" height="360"></iframe>
				</div>				
			</div>
			<br>
			<div style="float: right"><input type="button" value="  <bean:message key="helpdesk.puquery.ok" />" onclick="retselect()"> 
				<input type="reset" value="<bean:message key="helpdesk.puquery.cancel" /> " onclick="window.parent.close();">
			</div>
		  </td>
          <td width="2%"></td>
        </tr>
      </table>
    </td>
    <td width="2%" height="436" bgcolor="#DEEBEB"></td>
  </tr>
  <tr>
    <td width="2%" height="24" bgcolor="#DEEBEB" valign="bottom"><img border="0" src="images/conerLeftB.bmp" width="4" height="4"></td>
    <td width="80%" height="24" bgcolor="#DEEBEB"></td>
    <td width="2%" height="24" bgcolor="#DEEBEB" valign="bottom">
      <p align="right"><img border="0" src="images/conerRightB.bmp" width="4" height="4"></td>
  </tr>

</table>

</body>
</html>
