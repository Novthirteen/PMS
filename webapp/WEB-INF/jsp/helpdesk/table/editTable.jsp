<%@ page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='100%' height="105" cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' height='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.table.insert.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td bgcolor='#deebeb' style="padding:5px">
	    <div style="margin:5px">
		  <html:messages id="msg" message="true">
		    <div style="color:red; padding:5px; background-Color:#eef3fa">
			  <li><bean:write name="msg" /></li>
		    </div>
		  </html:messages>
		</div>
		<logic:empty name="typeList">
	      <table border="0" cellpadding="2" cellspacing="0" width="100%">
	      <tr>
	        <td align='left'><bean:message key="helpdesk.table.setupAll"/></td>
	        <td align='right'><input type="button" onclick="window.parent.close()" value="<bean:message key="button.ok"/>"/></td>
	      </tr>
	      </table>
		</logic:empty>
		<logic:notEmpty name="typeList">
		  <html:form action="<%="/helpdesk."+request.getParameter("action")+"Table.do"%>" method="post" >
			<html:hidden property="id" />
			<html:hidden property="company_partyId" />
		    <table border="0" cellpadding="2" cellspacing="0" width="100%">
		    <tr>
		      <td nowrap><bean:message key="helpdesk.table.type" />:</td>
		      <td align="left">
		      	<html:select property = "tableType_id" >
		            <html:options collection = "typeList" property = "id" labelProperty = "name"/>
		        </html:select>
		      </td>
		      <td align="right"><html:submit ><bean:message key="helpdesk.call.submit" /></html:submit></td>
		    </tr>
		    </table>
		  </html:form>
		</logic:notEmpty>
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
