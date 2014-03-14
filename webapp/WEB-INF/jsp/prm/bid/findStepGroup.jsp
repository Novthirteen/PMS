<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
	Log log = LogFactory.getLog("findStepGroup.jsp");
	long timeStart = System.currentTimeMillis();   //for performance test
	
	if (AOFSECURITY.hasEntityPermission("SALES_STEPS", "_VIEW", session)) {
		String qryDepartmentId = request.getParameter("qryDepartmentId");
		String qryDisableFlg = request.getParameter("qryDisableFlg");
		List result = (List)request.getAttribute("QryList");
		List partyList = (List)request.getAttribute("PartyList");
		
		String offSetStr = request.getParameter("offSet");
		int offSet = 0;
		if (offSetStr != null && offSetStr.trim().length() != 0) {
			offSet = Integer.parseInt(offSetStr);
		}
		if (result.size() < offSet) {
			offSet = 0;
		}
		
		request.setAttribute("offSet", offSetStr);
   
		final int recordPerPage = 10;
		int i = offSet+1;
%>
<script language="javascript">
	function fnSubmit1(start) {
			with (document.queryForm) {
				offSet.value=start;
				submit();
			}
		}
	function doNew() {
		document.queryForm.action="EditStepGroup.do";
		document.queryForm.formAction.value="view";
		document.queryForm.submit();
	}
</script>
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<CAPTION align=center class=pgheadsmall>Sales Funnel Step Group List</CAPTION>
	<tr>
		<td>
			<form name="queryForm" action="FindStepGroups.do" method="post">
				<input type="hidden" name="formAction" value="query">
				
				<TABLE width="100%">
					<tr>
						<td colspan=4><hr color=red></hr></td>
					</tr>
					<tr>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="qryDepartmentId">
							<%
							if (AOFSECURITY.hasEntityPermission("SALES_STEPS", "_ALL", session)) {
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if (p.getPartyId().equals(qryDepartmentId)) {
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
						<td class="lblbold">
							<input type="checkbox" class="checkboxstyle" name="qryDisableFlg" value="1" <%="1".equals(qryDisableFlg) ? "checked" : ""%>>
					    	Include Disabled Group
						</td>
				    	<td  align="middle">
							<input type="submit" value="Query" class="button">
							<input type="button" value="New" class="button" onclick="doNew();">
						</td>
					</tr>
					<tr>
						<td colspan=4 valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td>
				<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
  					<TR bgcolor="#e9eee9">
					  	<td align="center"  class="lblbold">#&nbsp;</td>
					  	<td align="center" class="lblbold">Department</td>
						<td align="center" class="lblbold">Description</td>
						<td align="center" class="lblbold">Status</td>
					</TR>
					<%
						if (result != null && result.size() > 0) {
					%>
					<logic:iterate id="stepGroup" indexId="indexId" offset="<%=String.valueOf(offSet)%>" length="<%=String.valueOf(recordPerPage)%>" name="QryList" type="SalesStepGroup" >
		  			<tr bgcolor="#e9eee9"> 
		  				<td align="center">
		  					<a href="EditStepGroup.do?DataId=<bean:write name="stepGroup" property="id"/>"><%=i++%></a> 
		  				</td>
		  				<td align="center">
	  						<bean:write name="stepGroup" property="department.description"/>
	  					</td>
		  				<td align="center">
		  					<a href="EditStepGroup.do?DataId=<bean:write name="stepGroup" property="id"/>"><bean:write name="stepGroup" property="description"/></a>
	  					</td>
	  					<td align="center">
	  					   <% if(stepGroup !=null && stepGroup.getDisableFlag()!=null){
	  					         if(stepGroup.getDisableFlag().equals(Constants.STEP_GROUP_DISABLE_FLAG_STATUS_YES)){%>
	  					            Disabled
	  					         <%}else{%>
	  					            Enabled
	  					         <%}
	  					      }
	  					   %>
	  					</td>
	  				</tr>
	  				</logic:iterate>
	  				<tr>
						<td width="100%" colspan="4" align="right" class=lblbold>Pages&nbsp;:&nbsp;
						<input type=hidden name="offSet" value="<%=offSet%>">
							<%
								int RecordSize = result.size();
								int l = 0;
								while ((l * recordPerPage) < RecordSize) {
									if (offSet == l * recordPerPage) {
							%>
									&nbsp;<%=l+1%>&nbsp;
							<%
									} else {
							%>
									&nbsp;<a href="javascript:fnSubmit1(<%=l*recordPerPage%>)" title="Click here to view next set of records"><%=l+1%></a>&nbsp;
							<%		
									};
									l++;
								}
							%>
						</td>
					</tr>
					<%
	  					} else {
	  				%>
	  				<tr bgcolor="#e9eee9">
				    	<td align="center" class="lblerr" colspan="4">
				    		No Record Found.
				    	</td>
				    </tr>
	  				<%
	  					}
	  				%>
				</table>
			</form>
		</td>
	</tr>
</table>
<%
	}else{
		out.println("!!你没有相关访问权限!!");
	}
%>