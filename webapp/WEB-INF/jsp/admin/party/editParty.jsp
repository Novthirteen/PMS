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

<%
if (AOFSECURITY.hasEntityPermission("INTERNAL_DEPARMENT", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();   
Party CustParty = null;
String PartyId = request.getParameter("PartyId");
List partyList = null;
String SLParentpartyId = "None";
String LocParentpartyId = "None";
List ParentPartyList = null;
try{
	// 所有机构列表
	PartyHelper ph = new PartyHelper();
	partyList = ph.getAllOrgUnits(hs);
	
	if (PartyId!=null && !PartyId.equals("")){
		CustParty = (Party)hs.load(Party.class,PartyId);
		ParentPartyList = ph.getAllParentPartysByPartyId(hs,PartyId,"GROUP_ROLLUP");
		Iterator prit = ParentPartyList.iterator();
		if (prit.hasNext()) SLParentpartyId = ((Party)(prit.next())).getPartyId();
		ParentPartyList = ph.getAllParentPartysByPartyId(hs,PartyId,"LOCATION_ROLLUP");
		prit = ParentPartyList.iterator();
		if (prit.hasNext()) LocParentpartyId = ((Party)(prit.next())).getPartyId();
		
	} 
}catch(Exception e){
	out.println(e.getMessage());
}

String action = request.getParameter("action");
if(action == null){
	action = "create";
}
%>
<br>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            <bean:message key="System.Party.PageTitle1"/>
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
	<form action="editParty.do" method="post">
    <input type="hidden" name="action" id="action" value="<%=action%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.partyId"/>:&nbsp;</span>
        </td>
        <td>
          <span class="tabletext"><%=CustParty.getPartyId()%>&nbsp;</span><input type="hidden" name="PartyId" id="PartyId" value="<%=CustParty.getPartyId()%>">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.description"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" value="<%=CustParty.getDescription()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.SLParentPartyId"/>:&nbsp;</span>
        </td>
        <input type="hidden" name="OldSLParentpartyId" id="OldSLParentpartyId" value="<%=SLParentpartyId%>">
        <td align="left">
			<select name="SLParentpartyId">
			<option value="None">None</option>
			<%
			Iterator it = partyList.iterator();
			while(it.hasNext()){
				Party p = (Party)it.next();
				if(PartyId.equals(p.getPartyId())){
				} else {
					if(SLParentpartyId.equals(p.getPartyId()) ){
						out.println("<option value=\""+p.getPartyId()+"\" selected>"+p.getDescription()+"</option>");
					}else{
						out.println("<option value=\""+p.getPartyId()+"\">"+p.getDescription()+"</option>");
					}
				}
			}
			%>
			</select>
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.LocParentPartyId"/>:&nbsp;</span>
        </td>
        <input type="hidden" name="OldLocParentpartyId" id="OldLocParentpartyId" value="<%=LocParentpartyId%>">
        <td align="left">
			<select name="LocParentpartyId">
			<option value="None">None</option>
			<%
			it = partyList.iterator();
			while(it.hasNext()){
				Party p = (Party)it.next();
				if(PartyId.equals(p.getPartyId())){
				} else {
					if(LocParentpartyId.equals(p.getPartyId()) ){
						out.println("<option value=\""+p.getPartyId()+"\" selected>"+p.getDescription()+"</option>");
					}else{
						out.println("<option value=\""+p.getPartyId()+"\">"+p.getDescription()+"</option>");
					}
				}
			}
			%>
			</select>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.address1"/>:&nbsp;</span>
        </td>
        <td align="left">
        	<%String address = CustParty.getAddress();
        	if (address == null) address = "N";%>
        	<select name="address">
			<option value="Y" <%if (address.equals("Y")) out.print("selected");%>>Yes</option>
			<option value="N" <%if (address.equals("N")) out.print("selected");%>>No</option>
			</select>
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.note1"/>:&nbsp;</span>
        </td>
        <td align="left">
        	<input type="text" class="inputBox" name="note" value="<%=CustParty.getNote()%>" size="30">
        </td>
      </tr>
	  <input type="hidden" name="role" id="role" value="ORGANIZATION_UNIT">
	  <tr>
	  <td/>
	  		<td class="lblbold" align="left">
				<input type="checkbox" class="checkboxstyle" name="isSalesTeam" value="Y" <%=CustParty.getIsSales()!=null && CustParty.getIsSales().equals("Y") ? "checked" : "" %> style="background-color:#ffffff">
		    	IS SALES TEAM</span>
			</td>
	  </tr>
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="<bean:message key="button.save"/>" class="loginButton">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listParty.do')">
        </td>
      </tr>    
        <tr><td>&nbsp;</td></tr>  
    </table>
 	</form>

<%
	}else{
%>
	<form action="editParty.do" method="post">
    <input type="hidden" name="action" id="action" value="<%=action%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.partyId"/>:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="PartyId" size="30">
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.description"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.SLParentPartyId"/>:&nbsp;</span>
        </td>
        <td align="left">
			<select name="SLParentpartyId">
			<option value="None">None</option>
			<%
			Iterator it = partyList.iterator();
			while(it.hasNext()){
				Party p = (Party)it.next();
				out.println("<option value=\""+p.getPartyId()+"\">"+p.getDescription()+"</option>");
			}
			%>
			</select>
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.LocParentPartyId"/>:&nbsp;</span>
        </td>
        <td align="left">
			<select name="LocParentpartyId">
			<option value="None">None</option>
			<%
			it = partyList.iterator();
			while(it.hasNext()){
				Party p = (Party)it.next();
				out.println("<option value=\""+p.getPartyId()+"\">"+p.getDescription()+"</option>");
			}
			%>
			</select>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.address1"/>:&nbsp;</span>
        </td>
        <td align="left">
        	<select name="address">
			<option value="Y">Yes</option>
			<option value="N" selected>No</option>
			</select>
        </td>
        <td align="right">
          <span class="tabletext"><bean:message key="System.Party.note1"/>:&nbsp;</span>
        </td>
        <td align="left">
			<input type="text" class="inputBox" name="note" size="30">
        </td>
      </tr>
	  <input type="hidden" name="role" id="role" value="ORGANIZATION_UNIT">
	  <tr>
      <td/>
      	<td class="lblbold" align="left">
			<input type="checkbox" class="checkboxstyle" name="isSalesTeam" value="Y" style="background-color:#ffffff">
				    	IS SALES TEAM
		</td>
      </tr>
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
      
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="<bean:message key="button.save"/>" class="loginButton">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listParty.do')">
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
