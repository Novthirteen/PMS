<%@ page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='325' cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.customer.import.title"/> - <span style="font-weight:normal"><bean:message key="helpdesk.attachment.upload.maxFileSize"/> <span style="color:red;">3000K</span>.</span></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' height='117' bgcolor='#deebeb'>
		<html:form action="helpdesk.insertUploadExcel.do" enctype="multipart/form-data" method="post" >
      <table border='0' cellpadding='0' cellspacing='2' style="margin:5px">
      <html:hidden property="partyId"/>
		  <html:messages id="msg" message="false">
		  <tr>
			<td colspan="2" style="color:red; padding:5px; background-Color:#eef3fa"><bean:write name="msg"/></td>
		  </tr>
		  </html:messages>
		  <html:messages id="msg" message="true">
	      <tr>
			<td colspan="2" style="color:blue padding:5px; background-Color:#eef3fa"><bean:write name="msg"/></td>
		  </tr>
		  </html:messages>
      <tr>
      	<td colspan="2"  height="3"><img src="images/spacer.gif" width="1" height="1"/></td>
      </tr>
      <tr>
	      <td nowrap><span class="labeltext"><bean:message key="helpdesk.attachment.uploadExcel.import"/>:</span></td>
	      <td>
		      <html:select property = "importCustomer" >
						<option value="0"><bean:message key="helpdesk.attachment.uploadExcel.import.only"/> <bean:write name="uploadExcelForm" property="partyId"/></option>
						<option value="1"><bean:message key="helpdesk.attachment.uploadExcel.import.all"/></option>
	        </html:select>
	      </td>
	    </tr>
		  <tr>
			<td nowrap><span class="labeltext"><bean:message key="helpdesk.attachment.upload.file"/>:</span></td>
			<td><html:file property="file" size="30"/></td>
		  </tr>
		  <tr>
			<td align="right" colspan="2">
			  <html:submit><bean:message key="helpdesk.attachment.button.upload.title"/></html:submit>
			  <input type="button" value="<bean:message key="button.cancel"/>" onclick="window.parent.close();"/>
			</td>
		  </tr>
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