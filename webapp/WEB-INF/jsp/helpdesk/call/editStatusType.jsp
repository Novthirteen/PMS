<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%> 
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%try {%>
<html:javascript formName="statusTypeForm"/>
<script type="text/javascript" language="Javascript1.1">
function showCallType(index) {
	for (i=0;i<document.all.statusList.length;i++) {
		if (i==index) {
			eval("document.all.statusList["+i+"].style.display='block'");
		} else {
			eval("document.all.statusList["+i+"].style.display='none'");
		}
	}
}
function initShowCallType() {
	if (document.all.statusList.length>0) {
		showCallType(document.all.callType_type.selectedIndex);
	}
}
function initUpdateShowCallType() {
	if (document.all.statusList.length>0) {
		showCallType(document.all.callType_type[1].selectedIndex);
	}
}

</script>

	<html:form action="<%="/"+request.getParameter("action")%>" method="post" onsubmit="return validateStatusTypeForm(this)" >		
	<bean:parameter id="action" name="action" value="" />
	<table border=0 width='98%' cellspacing='0' cellpadding='0' align="center">
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.statusType.title" /></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr height=6><td bgcolor='#deebeb'></td></tr>
  <TR>
    <td width='100%' bgcolor='#deebeb'>
		
    <html:errors />
    <table width='100%' border='0' cellpadding='0' cellspacing='0'>
    <tr>
    <td width="10" >
    &nbsp;
    </td>
    <td width="300" valign="top">
	    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
	      <tr>
		      <td colspan="2">
		      <html:hidden property="id"/>
		      <html:hidden property="flag"/>
		      </td>
	      </tr>
	      <tr>
	      	<td width="90" class="text13blackbold" ><bean:message key="helpdesk.statusType.callType" />:&nbsp;</td>
	      	
	      	<td width="210">
	      	<logic:equal name="action" value="helpdesk.updateStatusType.do">
						<html:hidden property="callType_type"/>
						&nbsp;<html:select property = "callType_type" onchange="showCallType(this.selectedIndex)" disabled="true">
	          	<html:options collection = "callTypes" property = "type" labelProperty = "typedesc"/>
	          </html:select>
	        </logic:equal>
					<logic:notEqual name="action" value="helpdesk.updateStatusType.do">    	
	      		&nbsp;<html:select property = "callType_type" onchange="showCallType(this.selectedIndex)" >
	          	<html:options collection = "callTypes" property = "type" labelProperty = "typedesc"/>
	          </html:select>
	        </logic:notEqual>
	        </td>
	      </tr>
	      <tr>
	      	<td class="labeltext"><bean:message key="helpdesk.statusType.disabled" />:&nbsp;</td>
	      	<td>
		      	<html:checkbox property="disabled" style="border-style:none;background-Color:transparent;" />
	      	</td>
	      </tr>
	      <tr>
	      	<td class="labeltext"><bean:message key="helpdesk.statusType.level" />:&nbsp;</td>
	      	<td>&nbsp;<html:text property="level" size="6" maxlength="3"/></td>
	      </tr>
	      <tr>
	      	<td class="labeltext"><bean:message key="helpdesk.statusType.desc" />:&nbsp;</td>
	      	<td>&nbsp;<html:text property="desc" size="30" maxlength="255"/></td>
	      </tr>
	      
	        
	      <tr>
	        <td align="left" colspan="2">
	        <html:submit><bean:message key="button.save" /></html:submit>&nbsp;
	        <input type="button" value="<bean:message key="helpdesk.statusType.listStatus" />" onClick="window.location='helpdesk.listStatusType.do'"></input>&nbsp;
	        <input type="button" value="<bean:message key="button.add" />" onClick="window.location='helpdesk.newStatusType.do'"></input>
	        </td>
	      </tr>      
	    </table>
	  <td>  
	  <td width="310" valign="top">
	  
   	<table width='100%' border='0' cellpadding='0' cellspacing='2'>
   	<tr>
   		<td align="left">
   		<table width='100%' border='0' cellpadding='0' cellspacing='0' >
   		<tr><td  class="labeltext"><bean:message key="helpdesk.statusType.originalStatusTypes" /></td></tr>
   		<logic:iterate id="statusList" name="statusTypes">
   			<tr id="statusList" style="display:none" >
		 			<td>
		 				<table width='100%' border='0' cellpadding='0' cellspacing='1'  class='boxoutside'>
			   		<tr height="18" class="bottomBox">
			   			<td><bean:message key="helpdesk.statusType.list.level" /></td>
				   		<td><bean:message key="helpdesk.statusType.list.desc" /></td>
				   		<td><bean:message key="helpdesk.statusType.list.disabled" /></td>
				   		<td><bean:message key="helpdesk.statusType.list.action" /></td>
				   	</tr>
		   			<logic:iterate id="status" name="statusList">
		   			
		   			<tr height="18" <logic:greaterEqual name="status" property="flag" value="1">style="color:#FF66CC"</logic:greaterEqual>>
	   			
		   				<td bgcolor='#deebeb' width="30">
		   					<bean:write name="status"  property="level"/>
		   				</td>
		   				<td bgcolor='#deebeb' width="220">
		   					<bean:write name="status"  property="desc"/>
		   				</td>
		   				<td bgcolor='#deebeb' width="30" align="center">
		   					<logic:equal name="status" property="disabled" value="true"><bean:message key="helpdesk.statusType.list.search.disabled.true" /></logic:equal>
		   					<logic:equal name="status" property="disabled" value="false"><bean:message key="helpdesk.statusType.list.search.disabled.false" /></logic:equal>
		   				</td>
		   				<td bgcolor='#deebeb' width="30">
		   					<a href="helpdesk.editStatusType.do?id=<bean:write name="status" property="id"/>"><bean:message key="helpdesk.statusType.list.edit" /></a>
		   				</td>
		   			</tr>
		   			</logic:iterate>
   					</table>
   				</td>		
   			</tr>
 			</logic:iterate> 
<!-- to make sure document.all.statusList is an array -->  		
 				<tr id="statusList" style="display:none" >
		 			<td>
		 				<table width='100%' border='0' cellpadding='0' cellspacing='1'  class='boxoutside'>
		 				<tr><td></td></tr>
   					</table>
   				</td>		
   			</tr>
   		</table>
   		</td>
   	</tr>
   	</table>
 		</td>
 		<td width="200" >
    &nbsp;
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
 
  
  
  <tr><td>&nbsp;</td></tr>
</table>  
</html:form>		
<script language="JavaScript">
<% if (request.getParameter("action").equals("helpdesk.updateStatusType.do")) { %>
	initUpdateShowCallType();
<% } else {%>
	initShowCallType();
<% } %>
</script>		
		
		
		
<% } catch (Throwable e) {
e.printStackTrace();
	}

%>
