<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{
if (AOFSECURITY.hasEntityPermission("USER_LOGIN", "_VIEW", session)) {

	List result = null;	
	String text = request.getParameter("text");
	if(text!=null && text.length()>1){
		result = Hibernate2Session.currentSession().createQuery("select ul from UserLogin as ul inner join ul.party as p inner join p.partyRoles as pr where pr.roleTypeId = 'ORGANIZATION_UNIT' and (ul.userLoginId like '%"+ text +"%' or ul.name like '%"+ text +"%')").list();
		request.setAttribute("userLogins",result);	
	}else{
		if(request.getAttribute("userLogins")==null){
			result = new ArrayList();
			request.setAttribute("userLogins",result);
		}else{
			result = (List)request.getAttribute("userLogins");
		}
	}
	
	if (text == null) text ="";
	Integer offset = null;	
	if( request.getParameter("offset") == null || request.getParameter("offset").equals("") ){
		offset = new Integer(0);
	}else{
		offset = new Integer(request.getParameter("offset"));
	} 
	
	Integer length = new Integer(20);	

    request.setAttribute("offset", offset);
    request.setAttribute("length", length);	
    
    int i = offset.intValue()+1;
    
    String textdep = request.getParameter("textdep");
	if (textdep == null) textdep ="";
		List partyList_dep=null;
	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	try{
		PartyHelper ph = new PartyHelper();
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
		if (partyList_dep == null) partyList_dep = new ArrayList();
		partyList_dep.add(0,ul.getParty());
	}catch(Exception e){
		e.printStackTrace();
	}
%>
<script language="Javascript">
function fnSubmit1(start) {
	with (document.frm) {
		offset.value=start;
		submit();
	}
}
</script>
<form name="frm" action="listUserLogin.do" method="post">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Login User List</CAPTION>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
<tr>
	<td class="lblbold">Staff:
		<input type="text" name="text" value="<%=text%>" class="lbllgiht">
	</td>
	<td width="5%"></td>
	<td class="lblbold">Department:
		<select name="textdep">
		<%
		if (AOFSECURITY.hasEntityPermission("PAS_PM_REPORT", "_ALL", session)) {
			Iterator itd = partyList_dep.iterator();
			while(itd.hasNext()){
				Party p = (Party)itd.next();
				if (p.getPartyId().equals(textdep)) {
		%>
				<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
		<%
				} else{
		%>
				<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
		<%
				}
			}
		}
		%>
		</select>
	</td>
	<td width ="60%"></td>
</tr>
<tr>
	<td>
		<input type="submit" value="<bean:message key="button.query"/>" class="">
		<input type="button" value="<bean:message key="button.new"/>" class="" onclick="location.replace('editUserLogin.do')">
	</td>
</tr>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
</table>
</form>

<table width=100%>
<tr>
	<td>
		<div>
		<display:table name="requestScope.userLogins" export="true" class="ITS" requestURI="listUserLogin.do" pagesize="15">
			<display:column property="userLoginId" title="User Id" sortable="true" href="editUserLogin.do" paramId="userLoginId" group="1"/>
			<display:column property="name" title="Staff Name" sortable="true" group="2" />
			<display:column property="party.description" title="Party" group="3"/>	
			<display:column property="enable" title="Enable" group="4"/>
			<display:column property="intern" title="Intern" group="4"/>		
			<display:column property="tele_code" title="Telephone" group="5"/>
			<display:column property="email_addr" title="Email Address" group="6"/>		
		</display:table>
		</div>
	</td>
</tr>
</table>	

<%
request.removeAttribute("userLogins");
}else{
	out.println("!!你没有相关访问权限!!");
}

		Hibernate2Session.closeSession();
}catch(Exception e )
{
e.printStackTrace();
}
%>
