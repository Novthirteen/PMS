<%@ page language="java" contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<link rel="stylesheet" type="text/css" href="includes/tree/xmlTree.css"/>
<script type="text/javascript" src="includes/tree/xmlTree.js"></script>
<xml id="xmlDoc">
  <bean:write name="X_xml" filter="false"/>
</xml>
<xml id="xslDoc">
  <jsp:include page="/includes/tree/xmlTree.xsl"/>
</xml>
<script type="text/javascript">

	function onLoad() {
		
		var source = new ActiveXObject("Microsoft.XMLDOM");
		var stylesheet = new ActiveXObject("Microsoft.XMLDOM");
		source.loadXML(xmlDoc.innerHTML);
		stylesheet.loadXML(xslDoc.innerHTML);

		document.getElementById("tree").innerHTML = source.transformNode(stylesheet);
	}
	
	function returnValue() {
		if (window.activeNode) {
			var r = new Array(window.activeNodeID, window.activeNodePathDesc);
			//r['id'] = window.activeNodeID;
			//r['desc'] = window.activeNodePathDesc;
			window.parent.returnValue = r;
		}
		window.parent.close();
	}
	
</script>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='295' cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.category.dialog.title"/></td>
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
	        <div id="tree" style="margin:5px;width:100%;height:231;overflow-X:auto;overflow-Y:scroll;scrollbar-base-color:#b4d4d4;scrollbar-3dlight-color:#deebeb;scrollbar-darkshadow-color:#deebeb">
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
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<script language="javascript">
	onLoad(); 
	setActiveItem(<%=request.getParameter("activeid")%>);
</script>