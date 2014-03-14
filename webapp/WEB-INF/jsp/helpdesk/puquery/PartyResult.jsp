<%@ page contentType="text/html;charset=gb2312"%> 
<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://www.zknic.com/struts/page-taglib" prefix="page" %>
<%try{%>
<%
	int i = 1;
%>
<%
	String stype=request.getParameter("type");
	if (stype==null){stype="";}
//	String sdesc=request.getParameter("desc");
//	if (sdesc==null){sdesc="";}	
%>
<script language="JavaScript1.3">
	function EnterPriorityItem(id) {
		obj = document.getElementById(id);
		if (obj == null) return;
		setActivePriorityItem(obj);
		returnValue();	
		//window.location="Userlist.do?type=<%=stype%>&partyid="+obj._id+"&partyname="+obj._desc;
		//parent.frames["pat1"].document.forms[0].desc.value=obj._desc;
		parent.frames["pat1"].location="helpdesk.EnterSelAction.do?type=<%=stype%>&partyid="+obj._id+"&partyname="+obj._desc+"&note="+obj._note+"&desc="+parent.frames["pat1"].document.forms[0].desc.value;
		window.location="helpdesk.GetUserAction.do?type=<%=stype%>&partyid="+obj._id+"&partyname="+obj._desc+"&note="+obj._note+"&username=";
	}
	
	function selectPriorityItem(id) {
		clickname.value=id;
		obj = document.getElementById(id);
		if (obj == null) return;
		setActivePriorityItem(obj);
		returnValue();
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
			window.parent.returncode.value = obj._id+"*%#@$@"+obj._desc+"*%#@$@"+"*%#@$@"+obj._note;
			<%if (stype.equals("")){%>
			parent.returnuser.value="";
			<%}else{%>
			window.parent.returnuser.value="*%#@$@"+"*%#@$@"+"*%#@$@"+"*%#@$@";
			<%}%>			
		}
	}
	
	function selectparty(con){
		parent.returncode.value=con.value;
		<%if (stype.equals("")){%>
		parent.returnuser.value="";
		<%}else{%>
		parent.returnuser.value="*%#@$@"+"*%#@$@"+"*%#@$@"+"*%#@$@";
		<%}%>
	}

	function inittext(){
		parent.returnuser.value="";
		parent.returncode.value="";
	}
	function backform(){
		//window.location="PartyCondition.do";
	//	window.history.back();
		parent.returnuser.value="";
		parent.returncode.value="";
		window.location=document.referrer;
	}
</script> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html:html locale="true">
  <head>
    
    <title>²éÑ¯½á¹û</title>
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
  
  <body  bgcolor="#FFFFFF" onload="inittext()">
  	<html:hidden property="clickname" value="" />
	<div style="margin:3px;width:100%;height:270;overflow:auto;scrollbar-base-color:#CCCCCC;scrollbar-3dlight-color:#CCCCCC;scrollbar-darkshadow-color:#CCCCCC">
	  <div class="clsPriorityHead">
	  	<span style="width:30px" class="labeltext"><bean:message key="helpdesk.puquery.party.title.no" /></span>
	    <span style="width:70px" class="labeltext"><bean:message key="helpdesk.puquery.party.title.code" /></span>
	    <span style="width:100px" class="labeltext"><bean:message key="helpdesk.puquery.party.title.name" /></span>
	    <span style="width:130px" class="labeltext"><bean:message key="helpdesk.puquery.party.title.address" /></span>
	  </div>	
	  <logic:iterate id="p" name="custPartys" type="com.aof.component.domain.party.Party">
	  <div class="clsNormalPriorityContent" 
	    onclick="selectPriorityItem('P<bean:write name="p" property="partyId"/>');"
	    ondblclick="EnterPriorityItem('P<bean:write name="p" property="partyId"/>');"
	    onmouseover="mouseoverPriorityItem('P<bean:write name="p" property="partyId"/>');"
	    onmouseout="mouseoutPriorityItem('P<bean:write name="p" property="partyId"/>');"
	    onmousedown="mousedownPriorityItem('P<bean:write name="p" property="partyId"/>');"
	    id="P<bean:write name="p" property="partyId"/>"
	    _id="<bean:write name="p" property="partyId"/>"
   	    _desc="<bean:write name="p" property="description"/>"
   	    _address="<bean:write name="p" property="address"/>"
   	    _note="<bean:write name="p" property="note"/>"
	  >
	    <span style="width:30px"><%=i++%></span>
	    <span style="width:70px"><bean:write name="p" property="partyId"/></span>
	    <span style="width:100px"><bean:write name="p" property="description"/></span>
	    <span style="width:130px"><bean:write name="p" property="note"/></span>
	  </div>
	  </logic:iterate>
	</div>	  
	<table width="100%" border="1" cellspacing="0" cellpadding="0" rules="rows" frame="hsides">
	<tr><td></td></tr>
	</table> 
	<div class="clsNormalPriorityContent" id="custenter">
		<span>&nbsp;</span>
		<br>
		<span>&nbsp;</span>
	</div>
	<div>
		<center>
		<logic:notEmpty name="custPartys" >
			<page:form action="/helpdesk.Parlist.do" method="post">
				<bean:message key="page.total" />&nbsp;<page:pageCount />&nbsp;<bean:message key="page.page" />
				&nbsp;&nbsp;<bean:message key="page.now" />&nbsp;<page:select  styleClass="pageinfo"  format="page.format" resource="true"/>
				<page:noPrevious><image align="absmiddle" alt="<bean:message key="page.prevpage" />" src="images/noprev.gif" border=0/></page:noPrevious>
				<page:previous><image align="absmiddle" alt="<bean:message key="page.prevpage" />" src="images/prev2.gif" border=0/></page:previous>
				<page:next><image align="absmiddle" alt="<bean:message key="page.nextpage" />" src="images/next2.gif" border=0/></page:next>
				<page:noNext><image align="absmiddle" alt="<bean:message key="page.nextpage" />" src="images/nonext.gif" border=0/></page:noNext>&nbsp;
				<html:hidden property="desc"  />
				<html:hidden property="relation"  />
				<html:hidden property="addr"  />
				<html:hidden property="type"  />
	  		</page:form>
		</logic:notEmpty>	  
	</div>		

  </body>
</html:html>
<%}catch(Throwable e) {out.print("error occurs");e.printStackTrace();};%>