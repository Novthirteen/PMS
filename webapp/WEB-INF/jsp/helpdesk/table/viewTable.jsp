<%@ page contentType="text/html;charset=gb2312" language="java" %>
<%@ page import="com.aof.component.helpdesk.*"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>
<script>
	function add()
	{
		v = window.showModalDialog(
    		"helpdesk.showDialog.do?title=helpdesk.row.insert.title&helpdesk.newRow.do?"+
    		"tableID="+	"<c:out value='${param.table}'/>",
    		 null,
    		 'dialogWidth:300px;dialogHeight:390px;status:no;help:no;scroll:no'
    	);
    	window.setTimeout("window.location.href=window.location.href",10);
	}
	function deleteRow(rowID)
	{
		if(confirm("<bean:message key="helpdesk.row.delete.sure" />"))
		{
			var command;
			command="window.location.href='helpdesk.deleteRow.do?rowID="+rowID+"'";    			
			window.setTimeout(command,10);
		}
	}
	function edit(rowID)
	{
		v = window.showModalDialog(
    		"helpdesk.showDialog.do?title=helpdesk.row.update.title&helpdesk.editRow.do?"+
    		"rowID="+	rowID,
    		 null,
    		 'dialogWidth:300px;dialogHeight:390px;status:no;help:no;scroll:no'
    	);
    	window.setTimeout("window.location.href=window.location.href",10);
	}
</script>
<table width="755" border='0' cellspacing='0' cellpadding='0' bgcolor="#deebeb">
   	<tr height="2"><td colspan="3"></td></tr>
   	<tr>
   		<td width="5">&nbsp;</td>
   		<td align="right" colspan="2">
			<input type="button" value="<bean:message key="heldpdesk.row.appendRow" />" onclick="add()"/>
		</td>
   	</tr>
   	<tr height="2"><td colspan="2"></td></tr>
   	<tr>
   		<td width="5"></td>
   		<td width="745">
   			<div  style="overflow : auto;height:300;width=740;scrollbar-base-color:#b4d4d4;scrollbar-3dlight-color:#deebeb;scrollbar-darkshadow-color:#deebeb">
   				<table width="100%" border='0' cellspacing='1' cellpadding='0' bgcolor="white">
  				<TR height="18" >
		    		<!--<td width="1" style="background-color:#c2dada;color:black"></td> -->
	    		<logic:iterate id="column" name="tableType" property="columns">
					<td class="labeltext" style="background-color:#c2dada;color:black" >&nbsp;<bean:write name="column" property="name"/>&nbsp;</td>
				</logic:iterate>
					<td nowrap class="labeltext" style="background-color:#c2dada;color:black" width="45" align="center">&nbsp;<bean:message key="helpdesk.row.edit" />&nbsp;</td>
					<td nowrap class="labeltext" style="background-color:#c2dada;color:black" width="45" align="center">&nbsp;<bean:message key="helpdesk.row.delete" />&nbsp;</td>
		    	</TR>
		    	<logic:iterate id="row" name="rows">
		    	<tr>
    				<!--<td width="1" ></td>-->
				<logic:iterate id="column" name="tableType" property="columns">
<%
	CustConfigColumn currentCol=(CustConfigColumn) pageContext.getAttribute("column");
	CustConfigRow currentRow= (CustConfigRow) pageContext.getAttribute("row");
	CustConfigItem currentItem=(CustConfigItem)currentRow.getItems().get(currentCol.getId());
	String value="&nbsp;";
	if(currentItem!=null)
	{
		value=currentItem.getContent();
	}
	if(value==null) value="&nbsp;";
%>
					<td style="background-color:#deebeb">&nbsp;<%=value%>&nbsp;</td>
		   		</logic:iterate>
   					<td  nowrap style="background-color:#deebeb" align="center" width="45">&nbsp;<a style="color:#333300;" href="javascript:void(0)" onclick="edit(<bean:write name="row" property="id"/>)" ><bean:message key="helpdesk.row.edit" /></a>&nbsp;</td>
			   		<td  nowrap style="background-color:#deebeb" align="center" width="45">&nbsp;<a style="color:#333300;" href="javascript:void(0)" onclick="deleteRow(<bean:write name="row" property="id"/>)"><bean:message key="helpdesk.row.delete" /></a>&nbsp;</td>
		    	</tr>
				</logic:iterate>
				</table>
			</div>
		</td>
		<td width="5"></td>
	</tr>
	<tr height="100%"><td colspan="3"></td></tr>
</table>