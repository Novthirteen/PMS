<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.component.crm.customer.*"%>
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
if (AOFSECURITY.hasEntityPermission("CUST_PARTY", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();

net.sf.hibernate.Transaction tx =null;

hs.flush();   
CustomerProfile CustParty = (CustomerProfile)request.getAttribute("CustParty");
String PartyId = request.getParameter("PartyId");
Object hasError = request.getAttribute("errorSign");
String action = request.getParameter("action");
if(action == null){
	action = "create";
}
List industryList = null;
List accountList = null;
List T2List = null;
try{
	// 所有机构列表
	CustomerHelper ph = new CustomerHelper();
	industryList = ph.getAllIndustry(hs);
	accountList = ph.getAllAccounts(hs);
	T2List = ph.getAllT2Code(hs);
}catch(Exception e){
	out.println(e.getMessage());
}
%>
<script language="javascript">
	function whenDelete(){
		with(document.frm){
			action.value="delete";
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
            <bean:message key="System.Party.PageTitle2"/>
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
<%
    if(CustParty != null){
    	action="update";
%>
	<form action="editProspect.do" method="post" name="frm">
    <input type="hidden" name="action" id = "action" value="<%=action%>">
	<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id = "<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.partyId2"/>:&nbsp;</span>
        </td>
        <td>
          <span class="tabletext"><%=CustParty.getPartyId()%>&nbsp;</span><input type="hidden" name="PartyId" id = "PartyId" value="<%=CustParty.getPartyId()%>">
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
          <input type="text" class="inputBox" name="description" value="<%=CustParty.getDescription()%>" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.cndescription2"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="ChineseName" value="<%=CustParty.getChineseName()%>" size="30">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.account"/>:&nbsp;</span>
        </td>
		<td align="left">
			<select name="AccountId">
			<%
			Iterator itAcc = accountList.iterator();
			while(itAcc.hasNext()){
				CustomerAccount p = (CustomerAccount)itAcc.next();
				String chk ="";
				if(CustParty.getAccount().getAccountId().equals(p.getAccountId()) ) chk = " selected";
				out.println("<option value=\""+p.getAccountId()+"\""+chk+">"+p.getDescription()+"</option>");
			}
			%>
			</select>
        </td>
		<td align="right">
          <span class="tabletext"><bean:message key="System.Party.industry"/>:&nbsp;</span>
        </td>
		<td align="left">
			<select name="IndustryId">
			<%
			Iterator itInd = industryList.iterator();
			while(itInd.hasNext()){
				Industry p = (Industry)itInd.next();
				String chk ="";
				if(CustParty.getIndustry().getId().equals(p.getId()) ) chk = " selected";
				out.println("<option value=\""+p.getId()+"\""+chk+">"+p.getDescription()+"</option>");
			}
			%>
			</select>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.address"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="address" value="<%=CustParty.getAddress()%>" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.postCode"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="postcode" value="<%=CustParty.getPostCode()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.teleCode"/>:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="telecode" value="<%=CustParty.getTeleCode()%>" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.note2"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="note" value="<%=CustParty.getNote()%>" size="30">
        </td>
      </tr>
      <tr>
      	<td align="right">
          <span class="tabletext">T2 Code:&nbsp;</span>
        </td>
		<td align="left">
			<select name="t2code">
			<%
			Iterator itT2 = T2List.iterator();
			while(itT2.hasNext()){
				CustT2Code p = (CustT2Code)itT2.next();
				String chk ="";
				if (CustParty.getT2Code()!= null){
					if(CustParty.getT2Code().getT2Code().equals(p.getT2Code()) ) chk = " selected";
				}
				out.println("<option value=\""+p.getT2Code()+"\""+chk+">"+p.getT2Code()+"</option>");
			}
			%>
			</select>
        </td>
        <td align="right">
          <span class="tabletext">Account Code:&nbsp;</span>
        </td>
     <td align="left">
          <input type="text" class="inputBox" name="AccountCode" value="<%=CustParty.getAccountCode()==null?
          "":CustParty.getAccountCode()%>" size="30">
        </td>
      </tr>
            <%if(request.getAttribute("deleteErrorString") != null)
				{
			%>
				<tr><td align="middle" colspan="4" class="lblbold"><font color=red><%=(String)request.getAttribute("deleteErrorString")%></font></td></tr>
			<%
				}
			%>
	  <input type="hidden" name="role" id = "role" value="CUSTOMER">
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="<bean:message key="button.save"/>" class="loginButton"/>
		<input type="button" value="Delete" class="loginButton" onclick="whenDelete();"/>
		<input type="button" value="Create Customer Group" class="loginButton" onclick="location.replace('editCustomerAccount.do')">
		<input type="button" value="Create Customer Industry" class="loginButton" onclick="location.replace('editIndustry.do')">
        </td>
		<td>&nbsp;</td>
		<td><input type="button" value="Back To List" class="loginButton" onclick="location.replace('listCustParty.do')"></td>
      </tr>
    </table>
 	</form>

<%
	}else{
%>
	<form action="editCustParty.do" method="post">
    <input type="hidden" name="action" id = "action" value="<%=action%>">
	<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id = "<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.partyId2"/>:&nbsp;</span>
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
          <span class="tabletext"><bean:message key="System.Party.account"/>:&nbsp;</span>
        </td>
		<td align="left">
			<select name="AccountId">
			<%
			Iterator itAcc = accountList.iterator();
			while(itAcc.hasNext()){
				CustomerAccount p = (CustomerAccount)itAcc.next();
				out.println("<option value=\""+p.getAccountId()+"\">"+p.getDescription()+"</option>");
			}
			%>
			</select>
        </td>
		<td align="right">
          <span class="tabletext"><bean:message key="System.Party.industry"/>:&nbsp;</span>
        </td>
		<td align="left">
			<select name="IndustryId">
			<%
			Iterator itInd = industryList.iterator();
			while(itInd.hasNext()){
				Industry p = (Industry)itInd.next();
				out.println("<option value=\""+p.getId()+"\">"+p.getDescription()+"</option>");
			}
			%>
			</select>
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
          <span class="tabletext">T2 Code:&nbsp;</span>
        </td>
		<td align="left">
			<select name="t2code">
			<%
			Iterator itT2 = T2List.iterator();
			while(itT2.hasNext()){
				CustT2Code p = (CustT2Code)itT2.next();
				out.println("<option value=\""+p.getT2Code()+"\">"+p.getT2Code()+"</option>");
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
	  <input type="hidden" name="role" id = "role" value="CUSTOMER">
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
		<input type="button" value="Create Customer Group" class="loginButton" onclick="location.replace('editCustomerAccount.do')">
		<input type="button" value="Create Customer Industry" class="loginButton" onclick="location.replace('editIndustry.do')">
        </td>
		<td>&nbsp;</td>
		<td><input type="button" value="Back To List" class="loginButton" onclick="location.replace('listCustParty.do')"></td>
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
%>
