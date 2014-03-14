<%@ page language="java" contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<style>
	div.clsPriorityHead {
	  margin:1px; 
	  padding-top:2px;
	  padding-bottom:1px;
	  padding-left:6px;
	  padding-right:4px;
	  background-color:#b4d4d4;
	  border:1px solid #b4d4d4;
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
	  border:1px solid #deebeb;
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
<script language="javascript">
	function selectPriorityItem() {
		obj = event.srcElement;
		if (obj.tagName != 'DIV') obj = obj.parentNode;
		setActivePriorityItem(obj);
	}
	
	function setActivePriorityItem(obj) {
		if (window.activePriorityItem != null) {
			window.activePriorityItem.className="clsNormalPriorityContent";
		}
		obj.className = "clsActivePriorityContent";
		window.activePriorityItem = obj;
	}
	
	function mouseoverPriorityItem() {
		obj = event.srcElement;
		if (obj.tagName != 'DIV') obj = obj.parentNode;
		obj.className = "clsMouseOverPriorityContent";
	}

	function mouseoutPriorityItem() {
		obj = event.srcElement;
		if (obj.tagName != 'DIV') obj = obj.parentNode;
		if (obj == window.activePriorityItem) {
			obj.className = "clsActivePriorityContent";
		} else {
			obj.className = "clsNormalPriorityContent";
		}
	}

	function mousedownPriorityItem() {
		obj = event.srcElement;
		if (obj.tagName != 'DIV') obj = obj.parentNode;
		obj.className = "clsMouseDownPriorityContent";
	}

	function returnValue() {
		if (window.activePriorityItem != null) {
			obj = window.activePriorityItem;
			window.parent.returnValue = new Array(obj._id, obj._desc, obj._restime, obj._soltime, obj._clstime,  obj._reswtime, obj._solwtime, obj._clswtime);
		}
		window.parent.close();
	}
</script>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='745' cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.priority.dialog.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td bgcolor='#deebeb'>
	    <div style="margin:5px">
	      <input type="button" value="<bean:message key="button.ok"/>" onclick="returnValue();"/>
	      <input type="button" value="<bean:message key="button.cancel"/>" onclick="window.parent.close();"/>
	    </div>
	    <table width='100%' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width='100%'>
	        <div style="margin:5px;width:100%;height:235;overflow-X:auto;overflow-Y:scroll;scrollbar-base-color:#b4d4d4;scrollbar-3dlight-color:#deebeb;scrollbar-darkshadow-color:#deebeb">
	          <div id="PHead" class="clsPriorityHead">
	            <span style="width:100px" class="labeltext"><bean:message key="helpdesk.servicelevel.priority.category.label"/></span>
	            <span style="width:250px" class="labeltext"><bean:message key="helpdesk.servicelevel.priority.description.label"/></span>
	            <span style="width:90px" class="labeltext"><bean:message key="helpdesk.servicelevel.priority.responseTime.label"/></span>
	            <span style="width:90px" class="labeltext"><bean:message key="helpdesk.servicelevel.priority.solveTime.label"/></span>
	            <span style="width:90px" class="labeltext"><bean:message key="helpdesk.servicelevel.priority.closeTime.label"/></span>
	          </div>
	          <logic:iterate id="p" name="X_priorities" type="com.aof.component.helpdesk.servicelevel.SLAPriority">
	          <div class="clsNormalPriorityContent" 
	            onclick="selectPriorityItem();"
	            onmouseover="mouseoverPriorityItem();"
	            onmouseout="mouseoutPriorityItem();"
	            onmousedown="mousedownPriorityItem();"
	            ondblclick="selectPriorityItem();returnValue();"
	            id="P<bean:write name="p" property="id"/>"
	            _id="<bean:write name="p" property="id"/>"
	            _desc="<bean:write name="p" property="desc"/>"
	            _restime="<bean:write name="p" property="responseTime"/>"
	            _soltime="<bean:write name="p" property="solveTime"/>"
	            _clstime="<bean:write name="p" property="closeTime"/>"
	            _reswtime="<bean:write name="p" property="responseWarningTime"/>"
	            _solwtime="<bean:write name="p" property="solveWarningTime"/>"
	            _clswtime="<bean:write name="p" property="closeWarningTime"/>"
	          >
	            <span id='C<bean:write name="p" property="category.id"/>' _id=<bean:write name="p" property="category.id"/> style="width:100px"><bean:write name="p" property="category.desc"/></span>
	            <span id='P<bean:write name="p" property="id"/>desc' style="width:250px"><bean:write name="p" property="desc"/></span>
	            <span id='P<bean:write name="p" property="id"/>response' style="width:90px"><bean:write name="p" property="responseWarningTime"/>/<bean:write name="p" property="responseTime"/></span>
	            <span id='P<bean:write name="p" property="id"/>solve' style="width:90px"><bean:write name="p" property="solveWarningTime"/>/<bean:write name="p" property="solveTime"/></span>
	            <span id='P<bean:write name="p" property="id"/>close' style="width:90px"><bean:write name="p" property="closeWarningTime"/>/<bean:write name="p" property="closeTime"/></span>
	          </div>
	          </logic:iterate>
	        </div>
	      </td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' height='4'>
	    <table width='100%' height='4' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="bottom" align="left" bgcolor="#deebeb"><img src="images/cornerLB.gif" width="4" height="4" border="0"></td>
	      <td bgcolor="#deebeb"><img src="images/spacer.gif" width="1" height="1"/></td>
	      <td width="8" valign="bottom" align="right" bgcolor="#deebeb"><img src="images/cornerRB.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	</table>
  </td>
</tr>
</table>
<script language="javascript">
	var _PO_ = document.getElementById('P<%=request.getParameter("activeid")%>');
	if (_PO_ != null) setActivePriorityItem(_PO_);
</script>
