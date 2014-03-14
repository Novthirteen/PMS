<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("PROJECT_ACCP", "_VIEW", session)) {
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

ProjectMaster CustProject = (ProjectMaster)request.getAttribute("ProjectResult");;

String DataId = request.getParameter("DataId");
int i=1;

String textproj = request.getParameter("textproj");
String textcust = request.getParameter("textcust");
String textstatus = request.getParameter("textstatus");
String departmentId = request.getParameter("departmentId");
String texttype = request.getParameter("texttype");
String textsup = request.getParameter("textsup");
if (textproj == null) textproj = "";
if (textcust == null) textcust = "";
if (textstatus == null) textstatus = "";
if (departmentId == null) departmentId = "";
if (texttype == null) texttype = "";			
if (textsup == null) textsup = "";
	
List result = (List) request.getAttribute("ProjectList");
if(result ==null){
	result = new ArrayList();
	request.setAttribute("ProjectList",result);
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

int a = offset.intValue()+1;

%>
<script language="Javascript">
function fnSubmit1(start) {
	with (document.EditForm) {
		offset.value=start;
		submit();
	}
}
</script>
<form action="findProjAccpPage.do" method="post" name="EditForm">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall> Project List For Acceptance Update </CAPTION>
<form action="findProjAccpPage.do" method="post" name="EditForm">
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Project:</td>
				<td class="lblLight"><input type="text" name="textproj" value="<%=textproj%>"></td>
				<td class="lblbold">Project Status:</td>
				<td class="lblLight">
					<select name="textstatus">
				 <!--   <option value=""></option> -->
				    <option value="WIP" <%if (textstatus.equals("WIP")) out.print("selected");%>>WIP</option>
				    <option value="Close" <%if (textstatus.equals("Close")) out.print("selected");%>>Close</option>
				    </select>
				</td>
				<td class="lblbold">Customer:</td>
				<td class="lblLight"><input type="text" name="textcust" value="<%=textcust%>"></td>
				<td class="lblbold">Supplier:</td>
				<td class="lblLight"><input type="text" name="textsup" value="<%=textsup%>"></td>
				</tr>
				<tr>
				<td class="lblbold">Category:</td>
				<td class="lblLight">
					<select name="texttype">
				  	<option value="">ALL</option>
				    <option value="C" <%if (texttype.equals("C")) out.print("selected");%>>Contract</option>
				    <option value="P" <%if (texttype.equals("P")) out.print("selected");%>>PO</option>
				    </select>
				</td>
				<td class="lblbold">Department:</td>
				<td class="lblLight">
					<select name="departmentId">
					<option value="">All Related To You</option>	
					<%
					if (AOFSECURITY.hasEntityPermission("PROJECT_ACCP", "_ALL", session)) {
						UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
						PartyHelper ph = new PartyHelper();
						List partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
						if (partyList_dep == null) partyList_dep = new ArrayList();
						partyList_dep.add(0,ul.getParty());
						Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();
							if (p.getPartyId().equals(departmentId)) {%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%} else{%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%}
						}
					}%>
					</select>
				</td>
			    <td colspan=3 align="left">
				<td align="center">
					<input TYPE="submit" class="button" name="btnSearch" value="Query">
				</td>
			</tr>
			<tr>
				<td colspan=8 valign="top"><hr color=red></hr></td>
			</tr>
		</Table>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="1" width=100%>
			<tr bgcolor="#e9eee9">
				<td class="lblbold">#</td>
				<td class="lblbold">Project Code</td>
				<td class="lblbold">Project Name</td>
				<td class="lblbold">Project Category</td>
				<td class="lblbold">Project Manager</td>
				<td class="lblbold">Customer / Supplier</td>
				<td class="lblbold">Department</td>
				<td class="lblbold">Status</td>
				<td class="lblbold">Contract Type</td>
				<td class="lblbold">Start Date</td>
				<td class="lblbold">End Date</td>
			</tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="ProjectList" type="com.aof.component.prm.project.ProjectMaster">
            <%int c = a++; 
            if ((c%2) == 1){ %>
             <tr bgcolor="#FFFFFF"> 
             <% } else {%>
              <tr bgcolor="#EAF3E7"> 
              	<%}%>
           		<td><%=c%></td>
           		<td><a href="editProjAccp.do?DataId=<bean:write name="p" property="projId"/>"><bean:write name="p" property="projId"/></a></td>
           		<td><bean:write name="p" property="projName"/></td>
           		<td><%=p.getProjectCategory().getName()%></td>
           		<td><%=p.getProjectManager().getName()%></td>
           		<%if (p.getProjectCategory().getId().equals("C")){%>
           		<td><%=p.getCustomer().getDescription()%></td>
           		<%}else{%>
           		<td><%=p.getVendor().getDescription()%></td>
           		<%}%>
           		<td><%=p.getDepartment().getDescription()%></td>
           		<td><%=p.getProjStatus()%></td>
           		<td><% String NC = "";
				String OC = p.getContractType();
				if(OC.equals("TM")) NC = "Time & Material";
				if(OC.equals("FP")) NC = "Fixed Price";
				%>
				<%=NC%></td>
           		<td><%=p.getStartDate()%></td>
           		<td><%=p.getEndDate()%></td>
           	</tr>
           
				</logic:iterate> 		
					 <tr>
				<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;
				<input type=hidden name="offset" value="<%=offset%>">
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
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}
		Hibernate2Session.closeSession();
%>
