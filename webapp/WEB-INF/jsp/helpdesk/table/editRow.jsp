<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ page import="com.aof.component.helpdesk.*"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<bean:parameter name="action" id="action"/>
<script>
	function validateForm(form)
	{
		with (form) 
		{
    		for (o in elements.tags('INPUT')) 
    		{
	            control = elements[o];
	            if(control.value!=null)
	            {
					if(control.value.length>300)
					{
						control.focus();
						alert("<bean:message key="helpdesk.row.maxLength" />");
						return false;
					}
				}
			}
			return true;
    	}
	}
</script>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='100%' height=350 cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' height='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle">
	      	<logic:equal name="action" value="insert"><bean:message key="helpdesk.row.insert.title"/>--<bean:write name="tableType" property="name" /></logic:equal>
	      	<logic:notEqual name="action" value="insert"><bean:message key="helpdesk.row.update.title"/>--<bean:write name="tableType" property="name" /></logic:notEqual>
	      </td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td bgcolor='#deebeb' style="padding:5px" valign="top">
	    <div style="margin:5px">
		  <html:messages id="msg" message="true">
		    <div style="color:red; padding:5px; background-Color:#eef3fa">
			  <li><bean:write name="msg" /></li>
		    </div>
		  </html:messages>
		</div>
	    <html:form action="<%="/helpdesk."+request.getParameter("action")+"Row.do"%>" method="post" onsubmit="return validateForm(this)">
	      <html:hidden property="rowID"/>
	      <html:hidden property="tableID"/>
	      <table border="0">
	      <logic:iterate id="column" name="tableType" property="columns">
			<tr>
<%
	CustConfigColumn currentCol=(CustConfigColumn) pageContext.getAttribute("column");
	String propName="items("+currentCol.getId()+")";
%>		
	    	   <td class="labeltext"><bean:write name="column" property="name"/>:</td>
	           <td><html:text property="<%=propName%>" maxlength="300"/></td>
	        </tr>
		  </logic:iterate>
		  <html:hidden property="closeMe"/>
		  <tr><td colspan="3" align="right">
		  	<input type="button" onclick="document.rowForm.closeMe.value='no';document.rowForm.submit();" value="<bean:message key="helpdesk.call.submit" />" /> 
		  	<input type="button" onclick="document.rowForm.closeMe.value='yes';document.rowForm.submit();" value="<bean:message key="helpdesk.row.submitAndClose" />" />
		  	<input type="button" onclick="window.parent.close()" value="<bean:message key="helpdesk.row.cancel" />" />
		  </td></tr>
	      </table>
	    </html:form>
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
	    