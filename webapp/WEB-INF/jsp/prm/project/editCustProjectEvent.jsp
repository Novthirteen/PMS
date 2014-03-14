<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.PageKeys"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("PROJECT_EVENT", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();   
ProjectEvent EditDataInfo = null;
String DataStr= request.getParameter("DataId");
Integer DataId = null;
if (DataStr == null || DataStr.length()<1) {
	
} else {
	DataId = new Integer(DataStr);					
}
int i=0;
List eventList = null;
List ProTypeList = null;
try{
	// ?ù???ú????±í
	ProjectHelper ph = new ProjectHelper();
	eventList=ph.getAllEvent(hs);
	ProTypeList = ph.getAllProjectType(hs);
}catch(Exception e){
	out.println(e.getMessage());
}
Iterator it = eventList.iterator();
while(it.hasNext()){
	ProjectEvent pe = (ProjectEvent)it.next();
    i++;
}


String FormAction = request.getParameter("FormAction");

if (DataId!=null){
	EditDataInfo = (ProjectEvent)hs.load(ProjectEvent.class,DataId);
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
            Project Event Maintenance
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
	<form Action="editCustProjectEvent.do" method="post" name="EditForm">
    <input type="hidden" name="FormAction" >
    <input type="hidden" name="DataId" value="<%=EditDataInfo.getPeventId()%>">
    <input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
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
          <input type="text" name="eName" class="inputBox" value="<%=EditDataInfo.getPeventCode()%>">
        </td>
        </tr>
        <tr>
        <td align="right">
          <span class="tabletext">Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" value="<%=EditDataInfo.getPeventName()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Event Category:&nbsp;</span>
        </td>
        <td align="left">
           <select name="proType">
			<%
			Iterator itpt = ProTypeList.iterator();
			while(itpt.hasNext()){
				ProjectType pt = (ProjectType)itpt.next();
				if( EditDataInfo.getPt().getPtId().equals(pt.getPtId())){
					out.println("<option value=\""+pt.getPtId()+"\" selected>"+pt.getPtName()+"</option>");
				}else{
					out.println("<option value=\""+pt.getPtId()+"\">"+pt.getPtName()+"</option>");
				}
			
			}
			%>
			</select>      
           </td>
      </tr>
     <tr>
        <td align="right">
          <span class="tabletext">Billable:&nbsp;</span>
        </td>
        <%String billable = EditDataInfo.getBillable().trim();%>
        <td align="left">
         <select name="billable">
		<option value="Yes" <%if(EditDataInfo.getBillable().trim().equals("Yes")){ out.println("selected");}%>>Yes</option>
        <option value="No" <%if(EditDataInfo.getBillable().trim().equals("No")) { out.println("selected");}%>>No</option>
        <option value="Other" <%if(EditDataInfo.getBillable().trim().equals("Other")) { out.println("selected");}%>>Other</option>
			</select>      
           </td>
       
      </tr>
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<input type="reset" value="Cancel" class="loginButton"/>
	    </form>
		</td>
		<td align="left">
		<form action="listCustProjectEvent.do">
	    <input type="submit" value="Back To List" class="loginButton" size="30" >
		</form>
		
		
        </td>

      </tr>    
        <tr><td>&nbsp;</td></tr>  
    </table>

<%
	}else{
%>
	<form Action="editCustProjectEvent.do" method="post">
    <input type="hidden" name="FormAction" value="<%=FormAction%>">
   <input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
	<table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
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
          <span class="tabletext">Event Category:&nbsp;</span>
        </td>
        <td align="left">
          <select name="proType">
			<%
			Iterator itpt = ProTypeList.iterator();
			while(itpt.hasNext()){
				ProjectType pt = (ProjectType)itpt.next();
			%>
			   <option value="<%=pt.getPtId()%>"><%=pt.getPtName()%></option>
			<%
			} 
			
			%>  
			</select> 
        </td>
      </tr>
     <tr>
        <td align="right">
          <span class="tabletext">Billable:&nbsp;</span>
        </td>
        <td align="left">
        <select name="billable">
         <option value="No" selected>No</option>
		<option value="Yes" >Yes</option>
        <option value="Other" >Other</option>
			</select>      
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
        </form>		
		</td>
		<td align="left">
		<form action="listCustProjectEvent.do">
	    <input type="submit" value="Back To List" class="loginButton" size="30" >
		</form>
		
		
        </td>
       
      </tr>      
        <tr><td>&nbsp;</td></tr>
    </table>
 	</form>
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
