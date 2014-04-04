<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.component.crm.vendor.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.util.PageKeys"%>
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
if (AOFSECURITY.hasEntityPermission("PROJ_VENDOR", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();

net.sf.hibernate.Transaction tx =null;

hs.flush();   
VendorProfile VendorParty = (VendorProfile)request.getAttribute("VendorParty");
String PartyId = request.getParameter("PartyId");
List type = (List)request.getAttribute("TypeList");
Object hasError = request.getAttribute("errorSign");
String action = request.getParameter("action");
if(action == null){
	action = "create";
}

%>
<script language="javascript">
	function whenDelete(){
		with(document.frm){
			action.value = "delete";
			submit();
		}
	}
</script>
<br>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Supplier Maintenance
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
<%
    if(VendorParty != null){
    	action="update";
%>
	<form action="editVendorParty.do" method="post" name="frm">
    <input type="hidden" name="action" id = "action" value="<%=action%>">
	<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id = "<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Supplier Code:&nbsp;</span>
        </td>
        <td>
          <span class="tabletext"><%=VendorParty.getPartyId()%>&nbsp;</span><input type="hidden" name="PartyId" id = "PartyId" value="<%=VendorParty.getPartyId()%>">
        </td>
		<td align="right">
          <span class="tabletext">&nbsp;</span>
        </td>
        <td align="left">&nbsp;</td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.description2"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" value="<%=VendorParty.getDescription()%>" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.cndescription2"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="ChineseName" value="<%=VendorParty.getChineseName()%>" size="30">
        </td>
      </tr>
	
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.address"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="address" value="<%=VendorParty.getAddress()%>" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.postCode"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="postcode" value="<%=VendorParty.getPostCode()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.teleCode"/>:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="telecode" value="<%=VendorParty.getTeleCode()%>" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.note2"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="note" value="<%=VendorParty.getNote()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Bank Number:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="BankNo" value="<%=VendorParty.getBankNo()%>" size="30">
        </td>
        <td align="right">
          <span class="tabletext">Tax Number:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="TaxNo" value="<%=VendorParty.getTaxNo()%>" size="30">
        </td>
      </tr>
      <tr>
      	<td align="right">
          <span class="tabletext">Category Type:&nbsp;</span>
        </td>
        <td align="left">
          <select name="TypeId">
			<%
				Long tId = null;
				if (VendorParty.getCategoryType()!= null){
					tId = VendorParty.getCategoryType().getTypeId();
				}
				for (int i0 = 0; type != null && i0 < type.size(); i0++) {
					VendorType VendorType = (VendorType)type.get(i0);
			%>
			<option value="<%=VendorType.getTypeId()%>" <%if (VendorType.getTypeId()==(tId)) out.print("selected");%>	>
			<%=VendorType.getDescription()%></option>
			<%
				}
			%>
			</select>      
        </td>
      	<td align="right">
          <span class="tabletext">Account Code:&nbsp;</span>
        </td>
     <td align="left">
          <input type="text" class="inputBox" name="AccountCode" value="<%=VendorParty.getAccountCode()==null?
          "":VendorParty.getAccountCode()%>" size="30">
        </td>
      </tr>
	  <input type="hidden" name="role" id = "role" value="SUPPLIER">
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="<bean:message key="button.save"/>" class="loginButton"/>
        <input type="button" value="Delete" class="loginButton" onclick="whenDelete();"/>
        </td>
		<td>&nbsp;</td>
		<td><input type="button" value="Back To List" class="loginButton" onclick="location.replace('listVendorParty.do')"></td>
      </tr>
    </table>
 	</form>

<%
	}else{
%>
	<form action="editVendorParty.do" method="post">
    <input type="hidden" name="action" id = "action" value="<%=action%>">
	<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id = "<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Supplier Code:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="PartyId" size="30">
        </td>
        <td align="right">
          <span class="tabletext">&nbsp;</span>
        </td>
        <td align="left">&nbsp;</td>
      </tr>
	  <tr>
		<td align="right">
          <span class="tabletext"><bean:message key="System.Party.description2"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.cndescription2"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="ChineseName" size="30">
        </td>
      </tr>
	 
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.address"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="address" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.postCode"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="postcode" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.teleCode"/>:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="telecode" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.note2"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="note" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Bank Number:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="BankNo"  size="30">
        </td>
        <td align="right">
          <span class="tabletext">Tax Number:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="TaxNo"  size="30">
        </td>
      </tr>
      <tr>
      	<td align="right">
          <span class="tabletext">Category Type:&nbsp;</span>
        </td>
        <td align="left">
          <select name="TypeId">
			<%
				for (int i0 = 0; type != null && i0 < type.size(); i0++) {
					VendorType VendorType = (VendorType)type.get(i0);
			%>
			<option value="<%=VendorType.getTypeId()%>"><%=VendorType.getDescription()%></option>
			<%
				}
			%>
			</select>      
        </td>
      		<td align="right">
          <span class="tabletext">Account Code:&nbsp;</span>
        </td>
     <td align="left">
          <input type="text" class="inputBox" name="AccountCode"  size="30">
        </td>
      </tr>
	  <input type="hidden" name="role" id = "role" value="SUPPLIER">
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <%if(hasError!=null){%>
      	<tr><td colspan="4" align="center"><font color="red"><%=(String)hasError%></font></td></tr>
      <%}%>
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="<bean:message key="button.save"/>" class="loginButton"/>
		
        </td>
		<td>&nbsp;</td>
		<td><input type="button" value="Back To List" class="loginButton" onclick="location.replace('listVendorParty.do')"></td>
      </tr>
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
