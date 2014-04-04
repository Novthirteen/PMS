<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
if (AOFSECURITY.hasEntityPermission("INTERNAL_DEPARMENT", "_VIEW", session)) {
	List result = null;	
	String text = request.getParameter("text");
	if(text!=null && text.length()>1){
		result = Hibernate2Session.currentSession().createQuery("select p from Party as p inner join p.partyRoles as pr where pr.roleTypeId = 'ORGANIZATION_UNIT' and (p.partyId like '%"+ text +"%' or p.description like '%"+ text +"%')").list();
		request.setAttribute("custPartys",result);	
	}else{
	
		result = Hibernate2Session.currentSession().createQuery("select p from Party as p inner join p.partyRoles as pr where pr.roleTypeId = 'ORGANIZATION_UNIT' ").list();
		request.setAttribute("custPartys",result);
		if(request.getAttribute("custPartys")==null){
			result = new ArrayList();
			request.setAttribute("custPartys",result);
		}
	}

	Integer offset = null;	
	if( request.getParameter("offset") == null || request.getParameter("offset").equals("") ){
		offset = new Integer(0);
	}else{
		offset = new Integer(request.getParameter("offset"));
	} 
	
	Integer length = new Integer(15);	

    request.setAttribute("offset", offset);
    request.setAttribute("length", length);	
    
    int i = offset.intValue()+1;
%>
<script language="JavaScript">
function OpenReqURL(ReqType, OrderNbr)
{
	var i;
	switch (ReqType) {
		case "ViewSingle":
			document.QueryList.target = "_self";
			document.QueryList.PartyId.value = OrderNbr ; 
			document.QueryList.submit();
			break;
		default:
	}
}

function fnSubmit1(start) {
	document.getElementById("offset").value=start;
	document.frm.submit();
}
</script>

<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Department List</CAPTION>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
<tr>
<form name="frm" action="listParty.do" method="post">
		<input type="hidden" name="offset" id="offset" value="<%=offset%>">
<table>
<tr>
	<td><bean:message key="System.Keyword.search"/> <bean:message key="System.Party.object1"/>:</td>
	<td>
		<input type="text" name="text" value="" class="">
	    <input type="submit" value="<bean:message key="button.query"/>" class="">
	    <input type="button" value="<bean:message key="button.new"/>" class="" onclick="location.replace('editParty.do')">
	</td>
</tr>
</table>
</form>
</tr>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
</table>	
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="topBox">
            <bean:message key="System.Party.object1"/> <bean:message key="System.Keyword.list"/>
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
            <table width='100%' border='0' cellspacing='0' cellpadding='0' >
              <tr>
                <td align="center" valign="center" width='100%'>
			<table width='100%' border='0' cellpadding='0' cellspacing='1'>
			  <tr >
                <td align="left" width="4%" class="bottomBox"> 
                  <p align="left"># 
                </td>
                <td align="left" width="8%" class="bottomBox"> 
                  <p align="left"><bean:message key="System.Party.partyId"/> 
                </td>
                <td align="left" width="15%" class="bottomBox">
                    <p align="left"><bean:message key="System.Party.description"/>
                </td>
                <td align="left" width="15%" class="bottomBox">
                    <p align="left"><bean:message key="System.Party.address1"/>
                </td>
                <td align="center" width="8%" class="bottomBox"> 
                  <p align="center"><bean:message key="System.Party.note1"/>
                </td>
              </tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="custPartys" type="com.aof.component.domain.party.Party" >                
			<tr>  
                <td align="left"><%= i++%></td>
                <td><a href="javascript:OpenReqURL('ViewSingle','<bean:write name="p" property="partyId"/>')"><bean:write name="p" property="partyId"/></a> 
                </td>
                <td><bean:write name="p" property="description"/></td>
                <td><bean:write name="p" property="address"/></td>
                <td><bean:write name="p" property="note"/></td>
			</tr>
			</logic:iterate> 
					 <tr>
			
				<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;

				<%
				int RecordSize = result.size();
				int l = 0;
				while ((l * length.intValue()) < RecordSize) {
					if (offset.intValue() == l*length.intValue()) {%>
					&nbsp;<%=l+1%>&nbsp;
					<%} else {%>
					&nbsp;<a href="javascript:fnSubmit1(<%=l*length.intValue()%>)" title="Click here to view next set of records"><%=l+1%></a>&nbsp;
					<%};
					l++;
				}%>
				</td>
				</tr>
                    </table>
                </td>
              </tr>
            </table>
         </td>
        </tr>
</table>
<form action="editParty.do" name="QueryList" method="post">
	<input type="hidden" name="PartyId" id="PartyId" value="">
</form>
<%
request.removeAttribute("custPartys");
}else{
	out.println("!!你没有相关访问权限!!");
}
		Hibernate2Session.closeSession();
%>
