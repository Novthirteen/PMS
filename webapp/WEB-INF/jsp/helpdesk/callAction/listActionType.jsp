<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%
int i=1;
%>
<script language="javascript">
	function addActionType() {
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.call.actiontype.new.title&helpdesk.newActionType.do', null, 'dialogWidth:500px;dialogHeight:165px;status:no;help:no;scroll:no');
		if(v == null)return;
		window.location.href=window.location.href;	
	}
	function editActionType(a){
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.call.actiontype.edit.title&helpdesk.editActionType.do?id='+a, null, 'dialogWidth:500px;dialogHeight:183px;status:no;help:no;scroll:no');
		if(v == null)return;
		window.location.href=window.location.href;	
	}
</script>
<form action="helpdesk.listActionType.do" method="post">
<table>
<tr>
	<td><bean:message key="helpdesk.call.actiontype.show.title"/></td>
	<td>
	  <input type="button" value="<bean:message key="button.add"/>" onclick="addActionType();"/>
	</td>
</tr>
</table>
</form>

<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="topBox">
            <bean:message key="helpdesk.call.actiontype.list.title"/>
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0' >
      <tr>
        <td width="5%" class="bottomBox"><bean:message key="helpdesk.call.actiontype.seq.label"/></td>         
        <td width="20%" class="bottomBox"><bean:message key="helpdesk.call.actiontype.calltype.label"/></td>                      
        <td width="45%" class="bottomBox"><bean:message key="helpdesk.call.actiontype.desc.label"/></td>
        <td width="10%" class="bottomBox"><bean:message key="helpdesk.call.actiontype.actiondisabled.label"/></td>       
        <td width="20%" class="bottomBox"><bean:message key="helpdesk.call.actiontype.action.label"/></td>       
      </tr>
	  <logic:iterate id="p" indexId="indexId" name="X_actiontypelist" type="com.aof.component.helpdesk.ActionType" >                
	  <tr>  
        <td><%= i++%></td>
        <td><bean:write name="p" property="callType.typedesc"/></td>           
        <td><bean:write name="p" property="actiondesc"/></td>  
        <td>
          <logic:equal name="p" property="actiondisabled" value="true">
            <bean:message key="helpdesk.call.actiontype.actiontypedisabled.choice.yes"/>
          </logic:equal>
          <logic:equal name="p" property="actiondisabled" value="false">
            <bean:message key="helpdesk.call.actiontype.actiontypedisabled.choice.no"/>
          </logic:equal>
        </td>         
        <td><a href="javascript:void(0)" onclick="editActionType(<%=p.getActionid()%>); event.returnValue = false;"><bean:message key="helpdesk.call.actiontype.action.edit.label"/></a></td>  
	  </tr>
	  </logic:iterate> 
      </table>
    </td>
  </tr>
</table>