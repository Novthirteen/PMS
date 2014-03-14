<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%> 
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic"%>
	<html:javascript formName="tableTypeForm"/>
	<html:form action="<%="/"+request.getParameter("action")%>" method="post" onsubmit="return validateTableTypeForm(this)" >		
	<bean:parameter id="action" name="action" value="" />
	<table border=0 width='98%' cellspacing='0' cellpadding='0' align="center">
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.custconfig.tabletype.title" /></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr height=6><td bgcolor='#deebeb'></td></tr>
  <TR>
    <td width='100%' bgcolor='#deebeb'>
		
    <html:errors />
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td colspan="4">
      <html:hidden property="id"/>
      </td>
      </tr>
      <tr>
        <td align="right" class="text13blackbold">
          <bean:message key="helpdesk.custconfig.tabletype.name" />:&nbsp;
        </td>
        <td>
          <html:text property="name" size="30" maxlength="255"/>
        </td>
        <td align="right" class="text13blackbold">
          <bean:message key="helpdesk.custconfig.tabletype.disabled" />:&nbsp;
        </td>
        <td align="left">
          <html:checkbox property="disabled" style="border-style:none;background-Color:transparent;" />
        </td>
      </tr>
      <tr>
        <td align="right" class="text13blackbold">
          <bean:message key="helpdesk.custconfig.tabletype.para" /> 01:&nbsp;
        </td>
        <td>
        	<html:text property="columns[0]" size="30" maxlength="255"/>
        </td>
        <td align="right" class="text13blackbold">
          <bean:message key="helpdesk.custconfig.tabletype.para" /> 02:&nbsp;
        </td>
        <td align="left" class="text13blackbold">
          &nbsp;<html:text property="columns[1]" size="30" maxlength="255"/>
        </td>
      </tr>
      <tr>
        <td align="right" class="text13blackbold">
          <bean:message key="helpdesk.custconfig.tabletype.para" /> 03:&nbsp;
        </td>
        <td>
          <html:text property="columns[2]" size="30" maxlength="255"/>
        </td>
        <td align="right" class="text13blackbold">
          <bean:message key="helpdesk.custconfig.tabletype.para" /> 04:&nbsp;
        </td>
        <td align="left">
          &nbsp;<html:text property="columns[3]" size="30" maxlength="255"/>
        </td>
      </tr>
      <tr>
        <td align="right" class="text13blackbold">
          <bean:message key="helpdesk.custconfig.tabletype.para" /> 05:&nbsp;
        </td>
        <td>
          <html:text property="columns[4]" size="30" maxlength="255"/>
        </td>
        <td align="right" class="text13blackbold">
          <bean:message key="helpdesk.custconfig.tabletype.para" /> 06:&nbsp;
        </td>
        <td align="left">
          &nbsp;<html:text property="columns[5]" size="30" maxlength="255"/>
        </td>
      </tr>
      <tr>
        <td align="right" class="text13blackbold">
          <bean:message key="helpdesk.custconfig.tabletype.para" /> 07:&nbsp;
        </td>
        <td>
          <html:text property="columns[6]" size="30" maxlength="255"/>
        </td>
        <td align="right" class="text13blackbold">
          <bean:message key="helpdesk.custconfig.tabletype.para" /> 08:&nbsp;
        </td>
        <td align="left">
          &nbsp;<html:text property="columns[7]" size="30" maxlength="255"/>
        </td>
      </tr>
      <tr>
        <td align="right" class="text13blackbold">
         <bean:message key="helpdesk.custconfig.tabletype.para" /> 09:&nbsp;
        </td>
        <td>
          <html:text property="columns[8]" size="30" maxlength="255"/>
        </td>
        <td align="right" class="text13blackbold">
         <bean:message key="helpdesk.custconfig.tabletype.para" /> 10:&nbsp;
        </td>
        <td align="left">
          &nbsp;<html:text property="columns[9]" size="30" maxlength="255"/>
        </td>
      </tr>
      
      
        
      <tr>
        <td align="right">

        </td>
        <td align="left" colspan="3">
        <html:submit><bean:message key="button.save" /> </html:submit>&nbsp;
        <input type="button" value="<bean:message key="button.list" />" onClick="window.location='helpdesk.listTableType.do'"></input>&nbsp;
	      <input type="button" value="<bean:message key="button.add" />" onClick="window.location='helpdesk.newTableType.do'"></input>
        </td>
      </tr>      
      
    </table>
   
 	
  </td>
  </tr>
  <tr height=6><td bgcolor='#deebeb'></td></tr>
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
  
  <tr height="10"><td></td></tr>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.custconfig.tabletype.modifyLog" /></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
  <TR>
    <td width='100%' bgcolor='#deebeb'>
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
  	<tr height=8><td colspan=6></td></tr>
		<tr>
			<td class="text13blackbold" width=20% align="right"><bean:message key="all.createDate" />&nbsp;&nbsp;</td>
			<td class="text13blackbold" width=30% align="left"><bean:write name="tableTypeForm" property="createDate"/>&nbsp;</td>
			<td class="text13blackbold" width=20% align="right"><bean:message key="all.createUser" />&nbsp;&nbsp;</td>
			<td class="text13blackbold" width=30% align="left"><bean:write name="tableTypeForm"  property="createUser"/>&nbsp;</td>
		</tr>
		<tr>
			<td class="text13blackbold" width=20% align="right"><bean:message key="all.modifyDate" />&nbsp;&nbsp;</td>
			<td class="text13blackbold" width=30% align="left"><bean:write name="tableTypeForm"  property="modifyDate"/>&nbsp;</td>
			<td class="text13blackbold" width=20% align="right"><bean:message key="all.modifyUser" />&nbsp;&nbsp;</td>
			<td class="text13blackbold" width=30% align="left"><bean:write name="tableTypeForm"  property="modifyUser"/>&nbsp;</td>
		</tr>

		<tr height="8">
			<td colspan=6></td>
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
  
  
  <tr><td>&nbsp;</td></tr>
</table>  
</html:form>