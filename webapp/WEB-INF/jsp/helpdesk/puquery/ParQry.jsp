<%@ page contentType="text/html;charset=gb2312"%> 
<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>
<%String stype=request.getParameter("type");
  if (stype==null) {stype="";} else{	stype=stype.trim(); }
  String sdesc=request.getParameter("desc");
  if (sdesc==null) {sdesc="";} else{	sdesc=sdesc.trim(); }
  
%>

<script language="JavaScript1.3">
function initset(){
	<%if (!stype.equals("")){%>
		document.forms[0].cmdcust.disabled=true;
	<%}%>
	document.forms[0].desc.value="<%=sdesc%>";
	//setDivLabel(tipcaption,'ddd');
}

function formsubmit(schoice){
//	parent.frames["pat2"].location="helpdesk.Parlist.do?type=<%=stype%>&desc="+document.forms[0].desc.value+"&link="+document.forms[0].relation.value+"&addr="+ document.forms[0].address.value;
	window.parent.returncode.value="";
	window.parent.returnuser.value="";
	if (schoice=="1"){
		parent.frames["pat2"].location="helpdesk.PUserlist.do?type=<%=stype%>&partyname="+document.forms[0].desc.value+"&username="+document.forms[0].name.value;
	}
	if (schoice=="2"){
		parent.frames["pat2"].location="helpdesk.Custom.do";
	}
	if (schoice=="3"){
		parent.frames["pat2"].location="helpdesk.Parlist.do?type=<%=stype%>&desc="+document.forms[0].desc.value;
	}
}
function ClearLabel(o)
{
	o.innerHTML="";
}
function setDivLabel(o,v)
{
	o.innerHTML=(v);
}
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>ParQry.jsp</title>
    
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
	<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
	<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
  </head>
  
  <body onload="initset()">
  	<html:form action="/helpdesk.Partysub.do" method="post">
  		<html:hidden property="choice"  value="1"/>
      	<table border="0" width="100%" cellspacing="0" cellpadding="0" height="50">
    		<tr height="10"><TD></td><td></td><td></td>
    		</tr>
			<tr>
				<td width="20%"></td>
				<td width="20%" height="26">
				<%if (stype.equals("")){%>
					<bean:message key="helpdesk.puquery.choice.desc" />
				<%}else{%>
					<bean:message key="helpdesk.puquery.choice.desc1" />				
				<%}%>
				</td>
				<td width="40%" height="26">
				<html:text property="desc" size="13" maxlength="255" />
				</td>
				<td width="20%"></td>
			</tr>
			<tr>
				<td width="100"></td>
				<td width="50" height="26">
				<%if (stype.equals("")){%>
					<bean:message key="helpdesk.puquery.choice.link" />
				<%}else{%>
					<bean:message key="helpdesk.puquery.choice.link1" />				
				<%}%>
				</td>
				<td width="171" height="26">
				<html:text property="name" size="13" maxlength="255"/>
				</td>
				<td width="271"></td>
			</tr>
		</table>
		<table border="0" width="100%" cellspacing="0" cellpadding="0" height="50">
			<tr>
				<td width="50"></td>
				<td height="28" align="center">
				<%if (stype.equals("")){%>
					<input type="button" name="cmduser"  value="<bean:message key="helpdesk.puquery.button.queryuser" />" onclick="formsubmit('1');setDivLabel(tipcaption,'<bean:message key="helpdesk.puquery.tips.usertip" />')"> &nbsp;&nbsp;
					<input type="button" name="cmdcust" id="cmdcust" value="<bean:message key="helpdesk.puquery.button.custom" />" onclick="formsubmit('2');setDivLabel(tipcaption,'<bean:message key="helpdesk.puquery.tips.customtip" />')"> &nbsp;&nbsp;
					<input type="button" name="cmdparty" value="<bean:message key="helpdesk.puquery.button.queryparty" />"  onclick="formsubmit('3');setDivLabel(tipcaption,'<bean:message key="helpdesk.puquery.tips.partytip" />')"> 
				<%}else{%>	
					<input type="button" name="cmduser"  value="<bean:message key="helpdesk.puquery.button.queryuser1" />" onclick="formsubmit('1');setDivLabel(tipcaption,'<bean:message key="helpdesk.puquery.tips.usertip1" />')"> &nbsp;&nbsp;
					<input type="button" name="cmdcust" id="cmdcust" value="<bean:message key="helpdesk.puquery.button.custom1" />" onclick="formsubmit('2')"> &nbsp;&nbsp;
					<input type="button" name="cmdparty" value="<bean:message key="helpdesk.puquery.button.queryparty1" />"  onclick="formsubmit('3');setDivLabel(tipcaption,'<bean:message key="helpdesk.puquery.tips.partytip1" />')"> 
				<%}%>
				</td>
				<td width="50"></td>
			</tr>			
			<tr><td colspan=3><center><font color="#3190CA"><div id='tipcaption'><bean:message key="helpdesk.puquery.tips.usertip" /></div></font></center></td>
			</tr>
		</table>
	
    	<%if (!stype.equals("")){%>
	    	<html:hidden property="type"  value="1"/>
	    <%}else{%>
	    	<html:hidden property="type"  value=""/>
	    <%}%>	
		
	 </html:form>	
  </body>
</html>
