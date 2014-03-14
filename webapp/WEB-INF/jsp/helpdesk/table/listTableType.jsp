 
<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%> 
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://www.zknic.com/struts/page-taglib" prefix="page" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>

<% try {%>
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr height="20">
    <td>
    	<html:form method="post" action="/helpdesk.listTableType.do" >
     	<table width='100%' border='0' cellpadding='0' cellspacing='1'>
     	<tr>
      	<td>
	     		<bean:message key="helpdesk.custconfig.tabletype.search" />&nbsp;
       		<html:text property="desc" maxlength="255" size="15" />&nbsp;&nbsp;
       		<bean:message key="helpdesk.statusType.list.disabled" />&nbsp;
	        <html:select property = "disabledTableType" >
	        	<option value="">&nbsp;</option>
	        	<option value="1" 
	        	<logic:equal name="tableTypeQueryForm" property="disabledTableType" value="1">
	        	selected="selected"</logic:equal>
	        	><bean:message key="helpdesk.custconfig.tabletype.list.search.disabled.true" /></option>
	        	<option value="0"
	        	<logic:equal name="tableTypeQueryForm" property="disabledTableType" value="0">
	        	selected="selected"</logic:equal>
	        	><bean:message key="helpdesk.custconfig.tabletype.list.search.disabled.false" /></option>
	        </html:select>
       		<input type="submit" value="<bean:message key="button.search" />" />
       		<input type="button" value="<bean:message key="button.add" />" onClick="window.location='helpdesk.newTableType.do'" />
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
	          <bean:message key="helpdesk.custconfig.tabletype.list" />
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
              <p align="left">&nbsp;<bean:message key="helpdesk.custconfig.tabletype.list.seq" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.custconfig.tabletype.list.desc" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.custconfig.tabletype.list.disabled" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.custconfig.tabletype.list.action" />
            </td>
            </tr>
						<logic:iterate id="tableList" name="results" >                
						<tr height="18">  
                <td> 
                  &nbsp;<bean:write name="tableTypeQueryForm" property="pageNextSeq"/>
                </td>
			                        
                <td> 
                  &nbsp;<bean:write name="tableList" property="name"/>
                </td>
                <td>
                	<logic:equal name="tableList" property="disabled" value="true">&nbsp;<bean:message key="helpdesk.custconfig.tabletype.list.search.disabled.true" /></img></logic:equal>
                	<logic:equal name="tableList" property="disabled" value="false">&nbsp;<bean:message key="helpdesk.custconfig.tabletype.list.search.disabled.false" /></img></logic:equal>
                </td>
                <td>
                	&nbsp;<a href="helpdesk.editTableType.do?id=<bean:write name="tableList" property="id"/>"><bean:message key="helpdesk.custconfig.tabletype.list.edit" /></a>
                </td>
						</tr>
						</logic:iterate> 
						<tr class="bottomBox">
						<td colspan="4" >
							<page:form action="/helpdesk.listTableType.do" method="post">			
								<table width='100%' border='0' cellpadding='0' cellspacing='0'>
								<tr>
									<td class="pageinfobold"  align="right">
										<bean:message key="page.total"/>
				            <page:pageCount/>
				            <logic:greaterThan name="tableTypeQueryForm" property="pageCount" value="1"><bean:message key="page.pages"/></logic:greaterThan>
				            <logic:lessEqual name="tableTypeQueryForm" property="pageCount" value="1"><bean:message key="page.page"/></logic:lessEqual>
										&nbsp;
				            <bean:message key="page.now"/>
				            <page:select styleClass="pageinfo"  format="page.format" resource="true"/>
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