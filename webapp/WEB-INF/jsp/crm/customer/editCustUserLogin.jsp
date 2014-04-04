<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.component.domain.module.*"%>
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
<%try {%>
<%
if (AOFSECURITY.hasEntityPermission("CUST_CONTACT", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();

net.sf.hibernate.Transaction tx =null;

hs.flush();   

UserLogin ul = (UserLogin)request.getAttribute("userLogin");;   

String userLoginId = request.getParameter("userLoginId");

String action = request.getParameter("action");
if(action == null){
	action = "create";
}
List partyList = null;

PartyHelper ph = new PartyHelper();
partyList = ph.getAllCustomers(hs);
if (partyList == null)
	partyList = new ArrayList();
Iterator it = partyList.iterator();
%>
<br>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            <bean:message key="System.UserLogin.PageTitle2"/>
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
<%
    if(ul != null){
    	action="update";
%>
	<form action="editCustUserLogin.do" method="post">
    <input type="hidden" name="action" id = "action" value="<%=action%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.userLoginId"/>:&nbsp;</span>
        </td>
        <td>
          <span class="tabletext"><%=ul.getUserLoginId()%>&nbsp;</span><input type="hidden" name="userLoginId" id = "userLoginId" value="<%=ul.getUserLoginId()%>">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.name"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="name" value="<%=ul.getName()%>" size="30">
        </td>
      </tr>
      <tr>
         <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.enable"/>:&nbsp;</span>
        </td>
		<td align="left">
			<select name="enable">
			<%
			String enable = ul.getEnable();
			if (enable == null) enable = "N";
			if(enable.equals("Y")){%>
				<option value="Y" selected><bean:message key="System.UserLogin.enableY"/></option>
				<option value="N"><bean:message key="System.UserLogin.enableN"/></option>
			<%}else{%>
				<option value="Y"><bean:message key="System.UserLogin.enableY"/></option>
				<option value="N" selected><bean:message key="System.UserLogin.enableN"/></option>
			<%}
			%>
			</select>
        </td>
		<td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.party"/>:&nbsp;</span>
        </td>
        <td align="left">
			<select name="partyId">
			<%
			while(it.hasNext()){
				Party p = (Party)it.next();
				if( ul.getParty().getPartyId().equals(p.getPartyId()) ){
					out.println("<option value=\""+p.getPartyId()+"\" selected>"+p.getDescription()+"</option>");
				}else{
					out.println("<option value=\""+p.getPartyId()+"\">"+p.getDescription()+"</option>");
				}
			}
			%>
			</select>          
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.tele_code"/>:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="tele_code" value="<%=ul.getTele_code()%>" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.email_addr"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="email_addr" value="<%=ul.getEmail_addr()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.mobile_code"/>:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="mobile_code" value="<%=ul.getMobile_code()%>" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.note1"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="note" value="<%=ul.getNote()%>" size="30">
        </td>
      </tr>
	  	  <input type="hidden" name="role" id = "role" value="<%=ul.getRole()%>">
     <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="<bean:message key="button.save"/>" class="loginButton">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listCustUserLogin.do')">
        </td>
      </tr>    
        <tr><td>&nbsp;</td></tr>  
    </table>
 	</form>

<%
	}else{
%>
	<form action="editCustUserLogin.do" method="post">
    <input type="hidden" name="action" id = "action" value="<%=action%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.userLoginId"/>:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="userLoginId" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.name"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="name" value="" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.enable"/>:&nbsp;</span>
        </td>
        <td align="left">
			<select name="enable">
				<option value="Y"><bean:message key="System.UserLogin.enableY"/></option>
				<option value="N" selected><bean:message key="System.UserLogin.enableN"/></option>
			</select>        
        </td>
		<td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.party"/>:&nbsp;</span>
        </td>
        <td align="left">
			<select name="partyId">
			<%
			while(it.hasNext()){
				Party p = (Party)it.next();
			%>
			<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
			<%
			}
			%>
			</select>          
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.tele_code"/>:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="tele_code" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.email_addr"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="email_addr" ize="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.mobile_code"/>:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="mobile_code" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.note2"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="note" size="30">
        </td>
	  <input type="hidden" name="role" id = "role" value="CUSTOMER">
      <tr>
      </tr>
      <tr>
      </tr>      
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="<bean:message key="button.save"/>" class="loginButton">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listCustUserLogin.do')">
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
<%
} catch (Exception e) {
	e.printStackTrace();
}
%>