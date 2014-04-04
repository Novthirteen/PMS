<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
if (AOFSECURITY.hasEntityPermission("CUST_PARTY", "_VIEW", session)) {
try{
	List result = null;
	result = (List)request.getAttribute("custPartys");
	String text = request.getParameter("text");
	if(text==null)text = "";
	String condition = "";
	if(text!=null && text.length()>1){
		condition += " and (p.partyId like '%"+ text +"%' or p.description like '%"+ text +"%')";
	}
		result = Hibernate2Session.currentSession().createQuery("select p from CustomerProfile as p "+
		"where p.type = 'p' "+condition).list();
		if(result!=null)
			request.setAttribute("custPartys",result);	
		else{
			result = new ArrayList();
			request.setAttribute("custPartys",result);
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

<script language="javascript">
function fnSubmit1(start) {
	with (document.frm) {
		offset.value=start;
		submit();
	}
}
</script>
<Form action="listProspect.do" name="frm" method="post">
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">Prospect Customer Verification List</caption> 
	<tr>
		<td>
				<table width=100% >
					<tr>
						<td colspan="8" valign="bottom"><hr color=red></hr></td>
					</tr>
					<tr>
						<td class="lblLight" width="20%">&nbsp;</td>
						<td class="lblbold" width="10%">Customer:</td>
						<td class="lblLight" width="20%">
							<input type="text" class="inputBox" name="text" size="50" value="<%if(!text.equals("")) out.print(text);%>" >
						</td>
						<td class="lblLight">
							<input type="submit" class="button" value="Query">
						</td>
					</tr>
					<tr>
						<td colspan="8" valign="top"><hr color=red></hr></td>
					</tr>
				</table>
		</td>
	</tr>
</table>
	
<TABLE border=0 width='100%' cellspacing='2' cellpadding='2'>
  <tr bgcolor="#e9eee9">
    <th align="left" width="2%"> 
      <p align="left"># 
    </th>
    <th align="left" width="8%"> 
      <p align="left"><bean:message key="System.Party.partyId2"/> 
    </th>
    <th align="left" width="10%">
        <p align="left"><bean:message key="System.Party.description2"/>
    </th>
    <th align="left" width="30%">
        <p align="left"><bean:message key="System.Party.address"/>
    </th>
    <th align="left" width="10%">
        <p align="left">T2 Code
    </th>
    <th align="left" width="10%">
        <p align="left"><bean:message key="System.Party.industry"/>
    </th>
    <th align="left" width="10%">
        <p align="left"><bean:message key="System.Party.account"/>
    </th>
    <th align="left" width="10%">
        <p align="left">Type
    </th>
  </tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="custPartys" type="com.aof.component.crm.customer.CustomerProfile" >                
		<tr bgcolor="#e9eee9">  
                <td align="left"> 
                 <div class="tabletext">
                  <p align="left"><%= i++%> 
                  </div>
                </td>
                <td><a href="verifyProspect.do?PartyId=<bean:write name="p" property="partyId"/>"><bean:write name="p" property="partyId"/></a>
                </td>
                <td><bean:write name="p" property="description"/>
                </td>            
                <td><bean:write name="p" property="address"/>
                </td>
                <td><%if(p.getT2Code()!=null) out.print(p.getT2Code().getT2Code());%>
                </td>
                <td><%=((CustomerProfile) p).getIndustry().getDescription()%>
                </td>
                <td><%=((CustomerProfile) p).getAccount().getDescription()%>
                </td>
                <td><%=((CustomerProfile) p).getType().equalsIgnoreCase("P")? "Prospect":"Customer" %>
                </td>
		</tr>
			</logic:iterate> 
			<tr>
				<td width="100%" colspan="7" align="right" class=lblbold>Pages&nbsp;:&nbsp;
				<input type="hidden" name="offset" id="offset" value="<%=offset%>">
				<%
				int RecordSize = 0;
				if(result != null)
					RecordSize = result.size();
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
</form>
<%
request.removeAttribute("custPartys");
}
catch(Exception e)
{
e.printStackTrace();
}
}else{
	out.println("!!你没有相关访问权限!!");
}
		Hibernate2Session.closeSession();
%>
