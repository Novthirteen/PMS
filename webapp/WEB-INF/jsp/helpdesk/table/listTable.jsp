<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>
<script>
	function showTable(id,me)
	{
		var tablePage;
		tablePage=document.all["iframe"+id];
		if(tablePage.style.display=="none")
		{
    		tablePage.style.display="block";
    		if(tablePage.src=="about:blank")
    		{
    			tablePage.src="helpdesk.viewTable.do?table="+id;
    		}
    		me.value="<bean:message key="helpdesk.table.collpase" />";
    	}
    	else
    	{
    		tablePage.style.display="none";
    		me.value="<bean:message key="helpdesk.table.expand" />";
    	}
	}
	function add()
	{
		v = window.showModalDialog(
    		"helpdesk.showDialog.do?title=helpdesk.table.insert.title&helpdesk.newTable.do?"+
    		"company="+	"<%=java.net.URLEncoder.encode(request.getParameter("company"))%>",
    		 null,
    		 'dialogWidth:260px;dialogHeight:145px;status:no;help:no;scroll:no'
    	);
    	window.setTimeout("window.location.href=window.location.href",10);
	}
	function deleteTable(tableID)
	{
		if(confirm("<bean:message key="helpdesk.table.delete.sure" />"))
		{
			if(confirm("<bean:message key="helpdesk.table.delete.sure2" />"))
			{
				var command;
				command="window.location.href='helpdesk.deleteTable.do?table="+tableID+"'";    			
				window.setTimeout(command,10);
			}
		}
	}
	function showCompanyDialog(tab)
	{
		with(document.tableQueryForm)
    	{
	    	v = window.showModalDialog(
	    		"helpdesk.EnterQuery.do?style=1&tab="+tab,//query=1
	    		 null,
	    		 'dialogWidth:428px;dialogHeight:597px;status:no;help:no;scroll:no'
	    	);
	    	
	    	if (v != null) 
	    	{
	    		if(v["party"]["partyid"]!="")
	    		{
		    		company.value=v["party"]["partyid"];
		    		var command;
		    		command="document.tableQueryForm.submit()"; 
		    		window.setTimeout(command,10);   			
		    	}
		    }
		 }
	}
    	
</script>

<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 cellspacing='2' cellpadding='2'>
<tr>
<td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
<td >
	<bean:message key="helpdesk.call.customer" />:
</td>
<td>
<html:form action="/helpdesk.listTable.do" method="post">
	<div id="labelCompany" style="display:inline"><logic:notEmpty name="company"><bean:write name="company" property="description"/></logic:notEmpty></div>
	<!--<a href="javascript:void(0)" onclick="showCompanyDialog(1);event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
	<html:hidden property="company"/>-->
</html:form>
</td></tr>
<tr height="6"><td colspan="3"></td></tr>
</table>

<logic:notEmpty name="company">
<table border=0 width='767' cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table width="762" border='0' cellspacing='0' cellpadding='0'>
		<tr>
			<td>
				<table width="100%" border='0' cellspacing='0' cellpadding='0'  height='20'>
			    	<tr>
					     <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
					     <td align=left class="wpsPortletTopTitle"><img src="images/greendot.gif"/>&nbsp;&nbsp;<bean:message key="helpdesk.table.information" /> <!--<bean:write name="company" property="description"/>--></td>
					     <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" align="left" bgcolor="#deebeb" >
				<div style="margin:5px">
				<table width='100%' border='0' cellpadding='0' cellspacing='2'>
			    <tr>
			      <td align="left" width="5%" class="labeltext"><bean:message key="helpdesk.table.information.id" />:</td>
			      <td align="left" width="28%"><bean:write name="company" property="partyId"/></td>
			      <td align="left" width="5%" class="labeltext"><bean:message key="helpdesk.table.information.desc" />:</td>
			      <td align="left" width="28%"><bean:write name="company" property="description"/></td>
			      <td align="left" width="5%" class="labeltext"><bean:message key="helpdesk.table.information.note" />:</td>
			      <td align="left" width="249%"><bean:write name="company" property="note"/></td>
			    </tr>
			    </table>
			    </div>
			</td>
		</tr>
		<tr>
			<td width="100%" align="right" bgcolor="#deebeb" >
				<logic:notEmpty name="typeList">
				  <html:form action="/helpdesk.insertTable.do" method="post" >
					<html:hidden property="id" />
					<html:hidden property="company_partyId" />
				    <table border="0" cellpadding="2" cellspacing="0">
				    <tr>
				      <td nowrap><bean:message key="helpdesk.table.type" />:</td>
				      <td align="left">
				      	<html:select property = "tableType_id" >
				            <html:options collection = "typeList" property = "id" labelProperty = "name"/>
				        </html:select>
				      </td>
				      <td align="right"><html:submit ><bean:message key="helpdesk.table.addConfiguration" /></html:submit></td>
				    </tr>
				    </table>
				  </html:form>
				</logic:notEmpty>
			</td>
		</tr>
		<tr height="10"><td></td></tr>
		<logic:iterate id="table" name="tables">
		<tr>
			<td>
				<table width="100%" border='0' cellspacing='0' cellpadding='0' height='25'>
			    	<tr>
					     <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
					     <td align=left class="wpsPortletTopTitle">
					     	<table border='0' cellspacing='0' cellpadding='0' width="100%">
					     		<tr>
					     			<td align="left" class="labeltext">
					     				<img src="images/greendot.gif"/>&nbsp;&nbsp;<bean:write name="table" property="tableType.name" />
					     			</td>
					     			<td align="right">
					     				<input type="button" value="<bean:message key="helpdesk.table.expand" />" onclick="showTable(<bean:write name="table" property="id" />,this)"/>
										<input type="button" value="<bean:message key="helpdesk.table.delete" />" onclick="deleteTable(<bean:write name="table" property="id" />)"/>&nbsp;
					     			</td>
					     		</tr>
					     	</table>
					     </td>
					     <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
					</tr>
				</table>
				    	
			</td>
		</tr>
		<!--<tr>
			<td width="100%" align="right" bgcolor="#deebeb" >
				<div style="margin:5px">
					<input type="button" value="expand" onclick="showTable(<bean:write name="table" property="id" />,this)"/>
					<input type="button" value="delete" onclick="deleteTable(<bean:write name="table" property="id" />)"/><br>
				</div>
			</td>
		</tr>-->
		<tr>
			<td bgcolor="#deebeb">
				<iframe src="about:blank" width="100%" height="337" frameborder="0" id="iframe<bean:write name="table" property="id" />" style="display:none" ></iframe>
			</td>
		</tr>
		<tr height="10"><td></td></tr>
	    </logic:iterate>
	</table>
  </td>
</tr>
</table>
</logic:notEmpty>
