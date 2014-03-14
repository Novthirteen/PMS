<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.PageKeys"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunctions.js'></script>

<%
try {
//if (true) {
SalaryLevel sl = (SalaryLevel)request.getAttribute("SalaryLevel");
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
List allEnabledList=sl.getAllEnabledSalaryLevel(hs);
List partyList = null;
//hs.flush();
PartyHelper ph = new PartyHelper();
partyList = ph.getAllOrgUnits(hs);
ProjectHelper projHelper = new ProjectHelper();
List currencyList = projHelper.getAllCurrency(hs);
if(currencyList==null){
	currencyList = new ArrayList();
}
Iterator itCurr = currencyList.iterator();

if (AOFSECURITY.hasEntityPermission("SALARY_LEVEL", "_CREATE", session)) {
%>
<script language="javascript">
function FnDelete() {
	document.EditForm.formAction.value = "delete";
	document.EditForm.submit();
}
function FnUpdate() {
     if (document.EditForm.level.value == 0){
     alert("Level id cannot be ignored ");
     }
     else{
	document.EditForm.formAction.value = "edit";
	document.EditForm.submit();
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
            Salary Level Maintenance
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
	<form Action="editSalaryLevel.do" method="post" name="EditForm">
    <input type="hidden" name="formAction" >
    <input type="hidden" name="id" value="<%=sl != null && sl.getId() != null ? sl.getId().toString() : "" %>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      
        <tr>
        <td align="right">
          <span class="tabletext">Level:&nbsp;</span>
        </td>
        <td>
          <input type="text" name="level" class="inputBox" value="<%=sl != null && sl.getLevel() != null ? sl.getLevel().toString() : "" %>">
        </td>
        </tr>
        <tr>
        <td align="right">
          <span class="tabletext">Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" value="<%=sl != null && sl.getDescription() != null ? sl.getDescription().toString() : "" %>" size="30">
        </td>
      </tr>
      
      <tr>
       <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.party"/>:&nbsp;</span>
        </td>
        <td align="left">
		     <select name="partyId">
			<%
			Iterator it = partyList.iterator();
			while(it.hasNext()){
				Party p = (Party)it.next();
				   if(sl.getParty() != null){
				   if( p.getPartyId().equals(sl.getParty().getPartyId())){
							%>
								<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
						<%}%>
							<%  }else{%>
								<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%}
										}
			%>
			</select>         	
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Rate:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="rate" value="<%=sl != null && sl.getRate() != null ? sl.getRate().toString() : ""%>" size="30"  
          onblur="checkDeciNumber2(this,1,1,'estimateAmount',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
        </tr>
        <tr>
        <td align="right">
          					<span class="tabletext">Currency:&nbsp;</span>
        				</td>

				        <td>
				          <select name="currencyId">
						  <%						
						      for (int i0 = 0; i0 < currencyList.size(); i0++) {
								CurrencyType curr = (CurrencyType)currencyList.get(i0);
								if(sl != null && curr.getCurrId().equals(sl.getCurr())){
							%>
								<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
							<%  }else{%>
								<option value="<%=curr.getCurrId()%>"><%=curr.getCurrName()%></option>
							<%}}%>
						  </select>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Status:&nbsp;</span>
        </td>
        <td align="left">
			<select name="status">
				<option value="1" <%=sl == null || sl.getStatus() == null || "1".equals(sl.getStatus().toString()) ? "selected" : ""%>>Enabled</option>
				<option value="0" <%=sl != null && sl.getStatus() != null && "0".equals(sl.getStatus().toString()) ? "selected" : ""%>>Disabeld</option>
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
		<%
			if (sl != null && sl.getId() != null) {
		%>
		<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete();"/>
		<%
			}
		%>
		 <input type="button" value="Back To List" class="loginButton" onclick="document.backform.submit();">
		</form>
		</td>
		<td align="left">
		<form name="backform" action="findSalaryLevel.do">
		</form>
		
        </td>

      </tr>    
        <tr><td>&nbsp;</td></tr>  
    </table>
  </td>
  </tr>

  <tr><td>&nbsp;</td></tr>
</table>  
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
} catch (Exception ex) {
	ex.printStackTrace();
}
%>
