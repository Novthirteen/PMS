<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="org.apache.commons.beanutils.RowSetDynaClass"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%try{%>
<%if (AOFSECURITY.hasEntityPermission("PERMISSION_QUERY", "_VIEW", session)) {
	
	String securityGroup =	request.getParameter("SecurityGroup");
	String securityPermission = request.getParameter("SecurityPermission");
	String userName = request.getParameter("UserName");
	String dep = request.getParameter("Department");
	if(userName == null)	userName = "";
	if(dep == null)	dep = "";
		if(securityGroup == null)	securityGroup = "";
		if(securityPermission == null)	securityPermission = "";

SecurityHelper sh = new SecurityHelper();
ArrayList groupList = (ArrayList)sh.listAllSecurityGroup();
ArrayList perList = (ArrayList)sh.listAllSecurityPermission();
List deptList = Hibernate2Session.currentSession().createQuery("select p from Party as p inner join p.partyRoles as pr where pr.roleTypeId = 'ORGANIZATION_UNIT' ").list();
Party chkParty = (Party)request.getAttribute("userParty");
if(chkParty == null) chkParty = new Party();
String userParty = "";
if (chkParty != null) 
   userParty = chkParty.getDescription();		
%>
<script language="javascript">

function ExportExcel() {
	var formObj = document.frm;
	formObj.elements["FormAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
</script>

<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> PAS Permissions Query </caption> 
<tr>
			<td colspan=6 valign="bottom"><hr color=red></hr></td>
</tr>
<tr>
	<td>		
		<table>
		<Form action="FindSecurityPermission.do" name="frm" method="post">
		<input type="hidden" name="FormAction" id="FormAction">
		<tr>
		<td width=15% class="lblbold">Staff:</td>
		<td width=35%><input type="text" name="UserName" length=16 value =<%=userName%>></td>
		
		<td  width=15% class="lblbold">Department:</td>

		<td class="lblLight">
			<select name="Department">
			<%
			
				Iterator itd = deptList.iterator();
				while(itd.hasNext()){
					Party p = (Party)itd.next();
					if (p.getPartyId().equals(dep)) {
			%>
					<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
			<%
					} else{
			%>
					<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
			<%
					}
				}

			%>
			</select>
		</td>
		</tr>
		<tr>		
		<td width=15% class="lblbold">SecurityGroup:</td>
		<td><select name="SecurityGroup">
	        <option value="<%=securityGroup%>"><%=securityGroup%></option>
	        <%
	        	groupList.add(0,"");
	        	for(int j=0; j<groupList.size(); j++){
	        		if(!securityGroup.equals(groupList.get(j)))
					out.println("<option value='"+groupList.get(j)+"'>"+ groupList.get(j) +"</option>");
				}
			%>				
			</select>
			</td>
		<td  class="lblbold">SecurityPermission:</td>
		<td><select name="SecurityPermission">
	        <option value="<%=securityPermission%>" ><%=securityPermission%></option>
	        <%
	        	perList.add(0,"");
	        	for(int j=0; j<perList.size(); j++){
	        		if(!securityPermission.equals(perList.get(j)))	        	
					out.println("<option value='"+perList.get(j)+"'>"+ perList.get(j) +"</option>");
				}
			%>				
			</select>
			</td>
		</tr>
		<tr>
		<td><input type="submit" name="Query" class="button" value="Query">		
		</form></td></tr>
		</table>
	</td>
</tr>
<tr>
	<td colspan=6 valign="bottom"><hr color=red></hr></td>
</tr>
<tr>
	<td>
		<div>
		<display:table name="requestScope.QryList.rows" export="true" class="ITS" requestURI="FindSecurityPermission.do" pagesize="15">
			<display:column property="uid" title="Staff Id" sortable="true" group="1"/>
			<display:column property="uname" title="Staff Name" sortable="true" group="2" />
			<display:column property="udesc" title="Department" group="3"/>	
			<display:column property="gid" title="Group" group="4"/>		
			<display:column property="gdesc" title="Group Description" group="5"/>
			<display:column property="pid" title="Permission" group="6"/>
			<display:column property="pdesc" title="Permission Description" group="7"/>				
		</display:table>
		</div>
	</td>
</tr>
</table>

<%
}else{
	out.println("没有访问权限.");
}
%>
<%}catch (Exception e){
			e.printStackTrace();
		}%>