<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%> 
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="http://www.zknic.com/struts/page-taglib" prefix="page" %>


<script language="javascript">
        
    	function showCategoryDialog() {
		    with(document.KnowledgeBaseQueryForm) {	
		    	v = window.showModalDialog(
		    		"helpdesk.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&helpdesk.showSLACategoryTreeDialog.do" ,
		    		 null,
		    		 'dialogWidth:310px;dialogHeight:335px;status:no;help:no;scroll:no'
		    	);
		    	if (v != null) 
		    	{
		    		if(categoryid.value!=v[0]) {
						categoryid.value=v[0];
						categorydesc.value=v[1];
						labelCategory.innerText=v[1];
						clearCategoryButton.style.visibility = 'visible';
		    		}
			    }
			 }
    	}
    	
    	function clearCategory() {
	    	with (document.KnowledgeBaseQueryForm) {
	    		categoryid.value='';
	    		categorydesc.value='';
		    	labelCategory.innerText = '';
				clearCategoryButton.style.visibility = 'hidden';
			}
    	}
    	
</script> 
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr height="20">
    <td>
    	<html:form method="post" action="helpdesk.listKnowledgeBase.do" >
     	<table width='100%' border='0' cellpadding='0' cellspacing='1'>
     	<tr>
      	<td><bean:message key="helpdesk.kb.search.label" />&nbsp;&nbsp;
       		<html:text  property="searchword" maxlength="255" size="15"/>&nbsp;
       		
       		<bean:message key="helpdesk.kb.category.label"/>:&nbsp;
			<html:hidden property="categorydesc" />
       		<span id="labelCategory"><bean:write name="KnowledgeBaseQueryForm" property="categorydesc"/></span>
	        <img align="absmiddle" style="cursor:hand" src="images/select.gif" border="0" alt="<bean:message key="helpdesk.kb.selectbutton.title"/>" onclick="showCategoryDialog();"/>
	        <img id="clearCategoryButton" align="absmiddle" style="cursor:hand;visibility:hidden" src="images/deleteMe.gif" border="0" alt="<bean:message key="helpdesk.kb.clearbutton.title"/>" onclick="clearCategory();"/>
	        <html:hidden  property="categoryid"/>     
	        <bean:message key="helpdesk.kb.published.label"/>:&nbsp;
       		<html:select  property="select">
       		    <html:option value="all" key="helpdesk.kb.published.choice.all"/>
       		    <html:option value="yes" key="helpdesk.kb.published.choice.yes"/>
       		    <html:option value="no" key="helpdesk.kb.published.choice.no"/>
       		    
       		 </html:select>
       		<input type="submit" value="<bean:message key="button.search" />"/>&nbsp;
       		<input type="button" value="<bean:message key="button.add" />" onclick="window.location.href='helpdesk.newKnowledgeBase.do'"/>
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
	          <bean:message key="helpdesk.kb.list.title" />
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
              <p align="left">&nbsp;<bean:message key="helpdesk.kb.seq.label" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.kb.subject.label" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.kb.category.label" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.kb.published.label" />
            </td>
            <td align="left" class="bottomBox"> 
              <p align="left">&nbsp;<bean:message key="helpdesk.kb.action.label" />
            </td>
            </tr>
			<logic:iterate id="KBList" name="results" >                
			<tr height="18">  
              <td><bean:write name="KnowledgeBaseQueryForm" property="pageNextSeq"/></td>
              <td><bean:write name="KBList" property="subject"/></td>
              <td><bean:write name="KBList" property="category.desc"/></td>
              <td>
                <logic:equal name="KBList" property="published" value="true"><bean:message key="helpdesk.kb.published.choice.yes"/></logic:equal>
                <logic:notEqual name="KBList" property="published" value="true"><bean:message key="helpdesk.kb.published.choice.no"/></logic:notEqual>
              </td>
              <td><a href="helpdesk.viewKnowledgeBase.do?id=<bean:write name="KBList" property="id"/>"><bean:message key="helpdesk.kb.action.view.label"/></a></td>
			</tr>
			</logic:iterate> 
			<tr class="bottomBox">
			  <td colspan="5">
				<page:form action="helpdesk.listKnowledgeBase.do" method="post">			
					<table width='100%' border='0' cellpadding='0' cellspacing='0'>
					<tr>
					<td class="pageinfobold"  align="right">
							<bean:message key="page.total" />
							<page:pageCount />
                    <logic:greaterThan name="KnowledgeBaseQueryForm" property="pageCount" value="1"><bean:message key="page.pages"/></logic:greaterThan>
                    <logic:lessEqual name="KnowledgeBaseQueryForm" property="pageCount" value="1"><bean:message key="page.page"/></logic:lessEqual>
		            <bean:message key="page.now"/>
                    <page:select styleClass="pageinfo" format="page.format"  resource="true"/>
                    <page:noPrevious><img align="absmiddle" alt="<bean:message key="page.prevpage"/>" src="images/noprev.gif" border=0/></page:noPrevious>
                    <page:previous><img align="absmiddle" alt="<bean:message key="page.prevpage"/>" src="images/prev2.gif" border=0/></page:previous>
                    <page:next><img align="absmiddle" alt="<bean:message key="page.nextpage"/>" src="images/next2.gif" border=0/></page:next>
                    <page:noNext><img align="absmiddle" alt="<bean:message key="page.nextpage"/>" src="images/nonext.gif" border=0/></page:noNext>
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