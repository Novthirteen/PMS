<%@ page contentType="text/html;charset=gb2312"%> 
<%@ page language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>

<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="org.apache.struts.action.ActionForm"%>
<%@ page import="org.apache.struts.action.ActionForward"%>
<%@ page import="org.apache.struts.action.ActionMapping"%>

<%@ page import="com.aof.webapp.action.BaseAction"%>
<%@ page import="com.aof.webapp.action.party.ListPartyAction"%>
<%@ page import="com.aof.webapp.action.helpdesk.puquery.PartyResult"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>
<%
	int i = 1;
%>
<%
  		String spartyid,spartyname;
		spartyid=request.getParameter("partyid");
		spartyname=request.getParameter("partyname");
%>
<%
	String stype;
	stype=request.getParameter("type");
	if (stype==null) stype="";
	//stype=(String) request.getAttribute("type");
%>
<script language="JavaScript1.3">
	function selectPriorityItem(id) {
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
			//window.parent.returnValue = new Array(obj._id, obj._desc, obj._restime, obj._soltime, obj._clstime,  obj._reswtime, obj._solwtime, obj._clswtime);
			window.parent.returncode.value = obj._partyid+"*%#@$@"+obj._desc+"*%#@$@";
			window.parent.returnuser.value = obj._id+"*%#@$@"+obj._name+"*%#@$@"+"*%#@$@"+obj._telecode+"*%#@$@"+obj._mobilecode+"*%#@$@"+obj._email;
		}
		//window.parent.close();
	}

function selectuser(con){
	parent.returnuser.value=con.value;
	parent.returncode.value=con.id;
//	parent.returncode.value="";

}

<%if (stype.equals("")){%>
function selectdyn(){
	parent.returnuser.value="";
//	parent.returnuser.value="*%#@$@"+dynname.value+"*%#@$@"+"*%#@$@"+"*%#@$@";
//	parent.returncode.value="";

}
function nameclick(){
//	opt.checked=true;
//	if (dynname.value==""){
//		parent.returnuser.value=""
//	}
	parent.returnuser.value="*%#@$@"+dynname.value+"*%#@$@"+"*%#@$@"+"*%#@$@";
//	parent.returnuser.value="*%#@$@"+dynname.value+"*%#@$@"+"*%#@$@"+"*%#@$@";
//	parent.returncode.value="";

}
function namechange(){
//	opt.checked=true;
	parent.returnuser.value="*%#@$@"+dynname.value+"*%#@$@"+"*%#@$@"+"*%#@$@";
	QQ._name=dynname.value;
//	alert("dd");
//	parent.returncode.value="";

}
<%}%>
function init(){
	parent.returncode.value="<%=spartyid%>*%#@$@<%=spartyname%>*%#@$@";
}

function backform(){
	parent.returnuser.value="";
	parent.returncode.value="";
	window.location="PartyCondition.do<%if (stype!="") out.print("?type=1");%>";
}
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html:html locale="true">
  <head>
   
    <title>FindParty.jsp</title>
    
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
	<LINK href="/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
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
		  border:1px solid lightgrey;
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
	</style>  
  </head>

  <body  bgcolor="#DEEBEB" onload="init()">
  	<center>(<%=spartyname%>)<font size="2">公司用户</font></center>
	<br>
	<div style="margin:10px;width:100%;overflow:auto;scrollbar-base-color:#CCCCCC;scrollbar-3dlight-color:#CCCCCC;scrollbar-darkshadow-color:#CCCCCC">
	  <div class="clsPriorityHead">
	  	<span style="width:30px">No.</span>
	    <span style="width:70px">LoginID</span>
	    <span style="width:150px">Name</span>
	    <span style="width:50px">Note</span>
	  </div>	
<%
		Logger log = Logger.getLogger(ListPartyAction.class.getName());
		//Locale locale = getLocale(request);
		try{
			List result = new ArrayList();
			PartyResult mPs= new PartyResult();
			result=mPs.getPartyUser(spartyid);
			request.setAttribute("custusers",result);
		}catch(Exception e){
			
			//log.error(e.getMessage());
		}finally{
		}
%>	      
		<%if (stype.equals("")){%>
		  <div class="clsNormalPriorityContent" 
		    onclick="selectPriorityItem('QQ');"
		    onmouseover="mouseoverPriorityItem('QQ');"
		    onmouseout="mouseoutPriorityItem('QQ');"
		    onmousedown="mousedownPriorityItem('QQ');"
		    id="QQ"
		    _id=""
		    _name=""
		    _partyid="<%=spartyid%>"
	   	    _desc="<%=spartyname%>"
		    _telecode=""
		    _mobilecode=""
	   	    _email=""
		  >
		    <span style="width:30px"><%=i++%></span>
		    <span style="width:70px">Custom</span>
		    <span style="width:150px"><input id="dynname" name="dynname" type='text' size="20" maxlength="255"  onkeyup="namechange()" onclick="nameclick()"/></span>
		    <span style="width:50px"></span>
		  </div>		
		<%}%>
		  <logic:iterate id="p" name="custusers" type="com.aof.component.domain.party.UserLogin">
		  <div class="clsNormalPriorityContent" 
		    onclick="selectPriorityItem('P<bean:write name="p" property="userLoginId"/>');"
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
		  >
		    <span style="width:30px"><%=i++%></span>
		    <span style="width:70px"><bean:write name="p" property="userLoginId"/></span>
		    <span style="width:150px"><bean:write name="p" property="name"/></span>
		    <span style="width:50px"><bean:write name="p" property="note"/></span>
		  </div>
		  </logic:iterate>
	</div>
  </body>
</html:html>
