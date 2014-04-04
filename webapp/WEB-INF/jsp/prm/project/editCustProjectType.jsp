<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("PROJECT_TYPE", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();   
ProjectType EditDataInfo = null;
String DataId = request.getParameter("DataId");



int i=0;

//List eventTypeList = null;
try{
	// ?ù???ú????±í
	//ProjectHelper ph = new ProjectHelper();
	//eventTypeList = ph.getAllEventType(hs);
	
}catch(Exception e){
	out.println(e.getMessage());
}


//Iterator it = eventTypeList.iterator();
//while(it.hasNext()){
//  ProjectEventType pet = (ProjectEventType)it.next();
//  i++;
//}



String FormAction = request.getParameter("FormAction");

if (DataId!=null){
	EditDataInfo = (ProjectType)hs.load(ProjectType.class,DataId);
}
	
if(FormAction == null){
	FormAction = "create";
}


	
%>
<script language="javascript">
function FnDelete() {
	
	document.EditForm.FormAction.value = "delete";
	document.EditForm.submit();
}
function FnUpdate() {
	
	document.EditForm.FormAction.value = "update";
	document.EditForm.submit();
}
</script>
<br>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Event Category Maintenance 
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
<%
    if(EditDataInfo != null){
    	FormAction="update";
%>
	<form Action="editCustProjectType.do" method="post" name="EditForm">
    <input type="hidden" name="FormAction" id="FormAction" >
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Code:&nbsp;</span>
        </td>
        <td>
           <span class="tabletext"><%=EditDataInfo.getPtId()%>&nbsp;</span><input type="hidden" class="inputBox" name="DataId" id="DataId" value="<%=EditDataInfo.getPtId()%>">
        </td>
        </tr>
        <tr>
          <td align="right">
          <span class="tabletext">Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" value="<%=EditDataInfo.getPtName()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">OpenProject:&nbsp;</span>
        </td> 
        
		 <td align="left">
         <%
			String open = EditDataInfo.getOpenProject().trim();

			if(EditDataInfo.getOpenProject().trim().equals("Yes")){
				out.println("<input TYPE=\"RADIO\" NAME=\"openProject\" VALUE=\"Yes\" CHECKED>Yes");
				out.println("<input TYPE=\"RADIO\" NAME=\"openProject\" VALUE=\"No\">No");
               
			}else{
                out.println("<input TYPE=\"RADIO\" NAME=\"openProject\" VALUE=\"Yes\" >Yes");
				out.println("<input TYPE=\"RADIO\" NAME=\"openProject\" VALUE=\"No\" checked>No");
                              
			}
            
		  %>
		 </td>
		 
          
      
      </tr>  
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();""/>
		<input type="reset" value="Cancel" class="loginButton"/>
        
        </form>
		</td>
		<td>
		<form action="listCustProjectType.do">
	    <input type="submit" value="Back To List" class="loginButton" size="30" >
		</form>
		</td>
      </tr>    
        <tr><td>&nbsp;</td></tr>  
    </table>
 	
<%
	}else{
%>
	<form Action="editCustProjectType.do" method="post">
    <input type="hidden" name="FormAction" id="FormAction" value="<%=FormAction%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Code:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="DataId" size="30" >
        </td>
        </tr>
        <tr>
        <td align="right">
          <span class="tabletext">Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" size="30">
        </td>
      </tr>
      <tr>
      <td align="right">
          <span class="tabletext">OpenProject:&nbsp;</span>
        </td>
        <td align="left">
            <input TYPE="RADIO" NAME="openProject" VALUE="Yes" CHECKED>Yes
			<input TYPE="RADIO" NAME="openProject" VALUE="No">No
		
        </td>
      </tr>
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="Save" class="loginButton"/>
        <input type="reset" value="Cancel" class="loginButton"/>
        </td>
      </form>
	     <td >
		<form action="listCustProjectType.do">
	    <input type="submit" value="Back To List" class="loginButton" size="30" >
		</form>
		</td>
      </tr>      
        <tr><td>&nbsp;</td></tr>
    </table>
 	
<%
	}
%> 	
  </td>
  </tr>
    <tr><td>&nbsp;</td></tr>
</table> 
  

<%
Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
