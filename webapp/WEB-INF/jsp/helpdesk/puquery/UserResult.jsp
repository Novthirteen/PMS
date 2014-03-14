<%@ page contentType="text/html;charset=gb2312"%> 
<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://www.zknic.com/struts/page-taglib" prefix="page" %>
<%
	int i = 1;
	String stype=request.getParameter("type");
	if (stype==null){stype="";}	
%>
<script language="JavaScript1.3">

	function backform(){
		//window.location="PartyCondition.do";
	//	window.history.back();
		parent.returnuser.value="";
		parent.returncode.value="";
		window.location=document.referrer;
	}
	function selectPriorityItem(id) {
		obj = document.getElementById(id);
		if (obj == null) return;
		setActivePriorityItem(obj);
		returnValue();
	}
	
	function dblPriorityItem(id) {
		selectPriorityItem(id);
		parent.retselect();
	}
	
	function setActivePriorityItem(obj) {
		if (window.activePriorityItem != null) {
			window.activePriorityItem.className="clsNormalPriorityContent";
		}
		obj.className = "clsActivePriorityContent";
		window.activePriorityItem = obj;
	}
	
	function mouseoverPriorityItem(id) {
		obj = document.getElementById(id);
		if (obj == null) return;
		obj.className = "clsMouseOverPriorityContent";
	}

	function mouseoutPriorityItem(id) {
		obj = document.getElementById(id);
		if (obj == null) return;
		if (obj == window.activePriorityItem) {
			obj.className = "clsActivePriorityContent";
		} else {
			obj.className = "clsNormalPriorityContent";
		}
	}

	function mousedownPriorityItem(id) {
		obj = document.getElementById(id);
		if (obj == null) return;
		obj.className = "clsMouseDownPriorityContent";
	}

	function returnValue() {
		if (window.activePriorityItem != null) {
			obj = window.activePriorityItem;
			//window.parent.returnValue = new Array(obj._id, obj._desc, obj._restime, obj._soltime, obj._clstime,  obj._reswtime, obj._solwtime, obj._clswtime);
			window.parent.returncode.value = obj._partyid+"*%#@$@"+obj._desc+"*%#@$@"+"*%#@$@"+obj._note;
			window.parent.returnuser.value = obj._id+"*%#@$@"+obj._name+"*%#@$@"+obj._telecode+"*%#@$@"+obj._mobilecode+"*%#@$@"+obj._email+"*%#@$@";
		}
		//window.parent.close();
	}
	function selectuser(con){
		parent.returnuser.value=con.value;
		parent.returncode.value=con.id;
		selectPriorityItem('P<%=request.getParameter("activeid")%>');
	}
	function inittext(){
	//	parent.returnuser.value="";
	//	parent.returncode.value="";
		<%if (!stype.equals("")){%>
		custenter.style.visibility="hidden";
		<%}%>	
	}	
	function Customfocus() {
		if (window.activePriorityItem != null) {
			window.activePriorityItem.className="clsNormalPriorityContent";
		}	
	}	
	function keyin(){
		parent.returnuser.value="*%#@$@"+susername.value+"*%#@$@"+"*%#@$@"+"*%#@$@";
	}	
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html:html locale="true">
  <head>
   
    <title>FindUser.jsp</title>
    
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
		  border:1px solid #FFFFFF;
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
		.gridtext {
			font-size: 10pt;
			font-family: Verdana, Arial, Helvetica, sans-serif;
		}
	</style>  
 	
  </head>
 
  <body  bgcolor="#FFFFFF" onload="inittext()">
	<div style="margin:3px;width:100%;height:270;overflow:auto;scrollbar-base-color:#CCCCCC;scrollbar-3dlight-color:#CCCCCC;scrollbar-darkshadow-color:#CCCCCC">
	  <div class="clsPriorityHead">
	  	<span style="width:30px" class="labeltext"><bean:message key="helpdesk.puquery.user.title.no" /></span>
	    <span style="width:70px" class="labeltext"><bean:message key="helpdesk.puquery.user.title.code" /></span>
	    <span style="width:130px" class="labeltext"><bean:message key="helpdesk.puquery.user.title.name" /></span>
	    <span style="width:70px" class="labeltext"><bean:message key="helpdesk.puquery.user.title.party" />.</span>
	  </div>
	  <logic:iterate id="p" name="custusers" type="com.aof.component.domain.party.UserLogin">
	  <div class="clsNormalPriorityContent" 
	    onclick="selectPriorityItem('P<bean:write name="p" property="userLoginId"/>');"
	    ondblclick="dblPriorityItem('P<bean:write name="p" property="userLoginId"/>');"
	    onmouseover="mouseoverPriorityItem('P<bean:write name="p" property="userLoginId"/>');"
	    onmouseout="mouseoutPriorityItem('P<bean:write name="p" property="userLoginId"/>');"
	    onmousedown="mousedownPriorityItem('P<bean:write name="p" property="userLoginId"/>');"
	    id="P<bean:write name="p" property="userLoginId"/>"
	    _id="<bean:write name="p" property="userLoginId"/>"
	    _name="<bean:write name="p" property="name"/>"
	    _partyid="<bean:write name="p" property="party.partyId"/>"
   	    _desc="<bean:write name="p" property="party.description"/>"
	    _telecode="<bean:write name="p" property="tele_code"/>"
	    _mobilecode="<bean:write name="p" property="mobile_code"/>"
   	    _email="<bean:write name="p" property="email_addr"/>"
   	    _note="<bean:write name="p" property="party.note"/>"
	  >
	    <span style="width:30px" class="gridtext"><%=i++%></span>
	    <span style="width:70px" class="gridtext"><bean:write name="p" property="userLoginId"/></span>
	    <span style="width:100px" class="gridtext" ><bean:write name="p" property="name"/></span>
	    <span style="width:130px" class="gridtext"><bean:write name="p" property="party.description"/></span>
	  </div>
	  </logic:iterate>
	</div>
	<table width="100%" border="1" cellspacing="0" cellpadding="0" rules="rows" frame="hsides">
	<tr><td></td></tr>
	</table> 	
	<div class="clsNormalPriorityContent" id='custenter'>
		<span>&nbsp;</span>
		<br>
		<span>&nbsp;</span>
	</div>
	<div>
		<center>
		<logic:notEmpty name="custusers" >
			<page:form action="/helpdesk.PUserlist.do" method="post">
				<bean:message key="page.total" />&nbsp;<page:pageCount />&nbsp;<bean:message key="page.page" />
				&nbsp;&nbsp;<bean:message key="page.now" />&nbsp;<page:select  styleClass="pageinfo"  format="page.format" resource="true"/>
				<page:noPrevious><image align="absmiddle" alt="<bean:message key="page.prevpage" />" src="images/noprev.gif" border=0/></page:noPrevious>
				<page:previous><image align="absmiddle" alt="<bean:message key="page.prevpage" />" src="images/prev2.gif" border=0/></page:previous>
				<page:next><image align="absmiddle" alt="<bean:message key="page.nextpage" />" src="images/next2.gif" border=0/></page:next>
				<page:noNext><image align="absmiddle" alt="<bean:message key="page.nextpage" />" src="images/nonext.gif" border=0/></page:noNext>&nbsp;
				<html:hidden property="username"  />
				<html:hidden property="partyname"  />
				<html:hidden property="type"  />
	  		</page:form>
		</logic:notEmpty>	  
	</div>			
  </body>
</html:html>
