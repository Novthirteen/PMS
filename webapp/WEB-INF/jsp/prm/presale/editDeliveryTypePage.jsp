<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.master.*"%>
<%@ page import="com.aof.component.prm.presale.*"%>
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
try{
if (AOFSECURITY.hasEntityPermission("DELIV_TYPE", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();

net.sf.hibernate.Transaction tx =null;

hs.flush();   
PreSaleDeliveryType EditDataInfo = null;
String TypeIdStr = request.getParameter("TypeId");

Long TypeId = null;
if (!(TypeIdStr == null || TypeIdStr.length()<1)) TypeId= new Long(TypeIdStr);

String FormAction = request.getParameter("FormAction");

if (TypeIdStr!=null){
	EditDataInfo = (PreSaleDeliveryType)hs.load(PreSaleDeliveryType.class,TypeId);
	
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
            Pre-Sale Deliveriable Type Maintenance
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
	<form Action="EditDeliveryType.do" method="post" name="EditForm">
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
           <span class="tabletext"><%=EditDataInfo.getTypeId()%>&nbsp;</span><input type="hidden" class="inputBox" name="TypeId" id="TypeId" value="<%=EditDataInfo.getTypeId()%>">
        </td>
      </tr>
      <tr>  
        <td align="right">
          <span class="tabletext">Deliveriable Type Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="Description" value="<%=EditDataInfo.getDescription()%>" size="30">
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
		<form action="ListDeliveryType.do">
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
	<form Action="EditDeliveryType.do" method="post">
    <input type="hidden" name="FormAction" id="FormAction" value="<%=FormAction%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr> 
        <td align="right">
          <span class="tabletext">Deliveriable Type Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="Description" size="30">
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
		<form action="ListDeliveryType.do">
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
}catch (Exception e){
	e.printStackTrace();
	}
%>
