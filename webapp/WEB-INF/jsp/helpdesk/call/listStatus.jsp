 
<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%> 
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://www.zknic.com/struts/page-taglib" prefix="page" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>

<% try {%>

<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr height="25">
    <td>
    	<html:form method="post" action="/helpdesk.listStatusType.do" >
     	<table width='100%' border='0' cellpadding='0' cellspacing='1'>
     	<tr>
      	<td>
	     		<bean:message key="helpdesk.statusType.list.search.callType" />&nbsp;
       		<html:select property = "callType" >
						<option value="">&nbsp;</option>
						<html:options collection = "callTypes" property = "type" labelProperty = "typedesc"/>
	        </html:select>&nbsp;&nbsp;
	        <bean:message key="helpdesk.statusType.list.search.disabled" />&nbsp;
	        <html:select property = "disabledStatus" >
	        	<option value="">&nbsp;</option>
	        	<option value="1" 
	        	<logic:equal name="statusTypeQueryForm" property="disabledStatus" value="1">
	        	selected="selected"</logic:equal>
	        	><bean:message key="helpdesk.statusType.list.search.disabled.true" /></option>
	        	<option value="0"
	        	<logic:equal name="statusTypeQueryForm" property="disabledStatus" value="0">
	        	selected="selected"</logic:equal>
	        	><bean:message key="helpdesk.statusType.list.search.disabled.false" /></option>
	        </html:select>
       		<input type="submit" value="<bean:message key="button.search" />" />
       		<input type="button" value="<bean:message key="button.add" />" onClick="window.location='helpdesk.newStatusType.do'" />
      	</td>
     	</tr>
     	</table>
     	</html:form>
    </td>
  </tr>
</table>  

<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
	
  <TR  height="18">
    <TD width='100%'>
      <table height="18" width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="topBox">
	          <bean:message key="helpdesk.statusType.list" />
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
	    <table width='100%' border='0' cellspacing='0' cellpadding='0' >
	    
      <tr>
        <td align="center" valign="center" width='100%'>
					
        	<table width='100%' border='0' cellpadding='0' cellspacing='1'>
            <tr height="18">
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.statusType.list.seq" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.statusType.list.callType" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.statusType.list.level" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.statusType.list.desc" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.statusType.list.disabled" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.statusType.list.action" />
            </td>
            </tr>
						<logic:iterate id="statusList" name="results">                
						<tr height="18">  
                <td> 
                  &nbsp;<bean:write name="statusTypeQueryForm" property="pageNextSeq"/>
                </td>
                <td> 
                  &nbsp;<bean:write name="statusList" property="callType.typedesc"/>
                </td>
                <td> 
                  &nbsp;<bean:write name="statusList" property="level"/>
                </td>
                <td> 
                  &nbsp;<bean:write name="statusList" property="desc"/>
                </td>
                <td>
                	<logic:equal name="statusList" property="disabled" value="true">&nbsp;<bean:message key="helpdesk.statusType.list.search.disabled.true" /></logic:equal>
                	<logic:equal name="statusList" property="disabled" value="false">&nbsp;<bean:message key="helpdesk.statusType.list.search.disabled.false" /></logic:equal>
                </td>
                <td>
                	&nbsp;<a href="helpdesk.editStatusType.do?id=<bean:write name="statusList" property="id"/>"><bean:message key="helpdesk.statusType.list.edit" /></a>
                </td>
						</tr>
						</logic:iterate> 
						<tr class="bottomBox">
						<td colspan="6" >
								<page:form action="/helpdesk.listStatusType.do" method="post">		
								<table width='100%' border='0' cellpadding='0' cellspacing='0'>
								<tr>
									<td class="pageinfobold"  align="right">
										<bean:message key="page.total"/>
				            <page:pageCount/>
				            <logic:greaterThan name="statusTypeQueryForm" property="pageCount" value="1"><bean:message key="page.pages"/></logic:greaterThan>
				            <logic:lessEqual name="statusTypeQueryForm" property="pageCount" value="1"><bean:message key="page.page"/></logic:lessEqual>
										&nbsp;
				            <bean:message key="page.now"/>
				            <page:select styleClass="pageinfo" format="page.format" resource="true"/>
										<page:noPrevious><image align="absmiddle" alt="<bean:message key="page.prevpage" />" src="images/noprev.gif" border=0/></page:noPrevious>
										<page:previous><image align="absmiddle" alt="<bean:message key="page.prevpage" />" src="images/prev2.gif" border=0/></page:previous>
										<page:next><image align="absmiddle" alt="<bean:message key="page.nextpage" />" src="images/next2.gif" border=0/></page:next>
										<page:noNext><image align="absmiddle" alt="<bean:message key="page.nextpage" />" src="images/nonext.gif" border=0/></page:noNext>&nbsp;
									</td>
								</tr>
								</table>
					      </page:form>									      
						</td>
						</tr>
		      </table>
		
      	</td>
      </tr>

    	</table>
		</td>
	</tr>
</table>
<% } catch (Throwable e) {
e.printStackTrace();
	}

%>