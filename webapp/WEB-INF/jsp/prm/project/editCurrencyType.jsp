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
if (AOFSECURITY.hasEntityPermission("ADMIN_CURRENCY", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();   
CurrencyType EditDataInfo = null;
String DataId = request.getParameter("DataId");






String FormAction = request.getParameter("FormAction");

if (DataId!=null){
	EditDataInfo = (CurrencyType)hs.load(CurrencyType.class,DataId);
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
            Currency Exchange Rate Maintenance
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
	<form Action="editCurrencyType.do" method="post" name="EditForm">
    <input type="hidden" name="FormAction" >
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Currency Code:&nbsp;</span>
        </td>
        <td>
           <span class="tabletext"><%=EditDataInfo.getCurrId()%>&nbsp;</span><input type="hidden" class="inputBox" name="DataId" value="<%=EditDataInfo.getCurrId()%>">
        </td>
      </tr>
      <tr>  
        <td align="right">
          <span class="tabletext">Currency Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" value="<%=EditDataInfo.getCurrName()%>" size="30">
        </td>
      </tr>
      <tr>  
        <td align="right">
          <span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="rate" value="<%=EditDataInfo.getCurrRate()%>" size="30">
        </td>
      </tr>
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<input type="reset" value="Cancel" class="loginButton"/>
		<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete();"/>
        </td>
      </form>
	     <td >
		<form action="listCurrencyType.do">
	    <input type="submit" value="Back To List" class="loginButton" size="30" >
		</form>
		</td>
      </tr>    
        <tr><td>&nbsp;</td></tr>  
    </table>
 	</form>

<%
	}else{
%>
	<form Action="editCurrencyType.do" method="post">
    <input type="hidden" name="FormAction" value="<%=FormAction%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Currency Code:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="DataId" size="30" >
        </td>
       </tr>
       <tr> 
        <td align="right">
          <span class="tabletext">Currency Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" size="30">
        </td>
      </tr>
      <tr> 
        <td align="right">
          <span class="tabletext">Currency Rate(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="rate" size="30">
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
	     <td >
		<form action="listCurrencyType.do">
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
