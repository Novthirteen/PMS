<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.util.List"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.Party"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%if (AOFSECURITY.hasEntityPermission("PAS_UTL_REPORT", "_VIEW", session)) {%>

<%
	try{
		
		NumberFormat numFormator = NumberFormat.getInstance();
		numFormator.setMaximumFractionDigits(1);
		numFormator.setMinimumFractionDigits(1);
		
		
		String year = request.getParameter("iYear");
		String employeeId = request.getParameter("employeeId");
		String departmentId = request.getParameter("departmentId");
		String flag = request.getParameter("flag");
		
		if(year == null){
			year = "";
		}
		if (employeeId == null) {
			employeeId = "";
		}
		if(departmentId == null){
			departmentId = "";
		}

%>
<html>
	<head>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		
		<script language="javascript">
		
			function fnList() {
			
				var formObj = document.iForm;
				actionURL="<%= request.getContextPath() %>/pas.report.UtilizationByStaffRpt.do";
			    var param = "?formAction=list&iYear=<%=year%>&departmentId=<%=departmentId%>";
			    var flag = <%=flag%>;
			    if(flag != null && flag.length > 0){
			    	param += "&employeeId=<%=employeeId%>";
			    }
				iForm.action = actionURL + param;
				
				formObj.submit();
			}
		
			function fnExport() {
			
				var formObj = document.iForm;
			    
				formObj.formAction.value = "exportView";
				formObj.target = "_self";
				formObj.submit();
			}
		
		</script>
	</head>
	<body>
		<table width="102%" cellpadding="1" border="0" cellspacing="1">
			<br>
			<caption class="pgheadsmall"> Utilization Detail Report By Staff</caption> 
			<tr>
				<td colspan=8 valign="bottom"><hr color="red"></hr></td>
			</tr>
			<%
				UserLogin em = (UserLogin)request.getAttribute("employee");
				if(em == null){
					em = new UserLogin();
				}
			%>
			<tr>
				<td width="22%"/>
				<td class="lblbold" width="5%" align="right">Year:&nbsp;</td>
				<td class="lblLight" align="left"><%=year%></td>
				<td class="lblbold" align="right">Employee:&nbsp;</td>
				<td class="lblLight" align="left"><%=em.getUserLoginId()%>:<%=em.getName()%></td>
				<td class="lblbold" align="right">Department:&nbsp;</td>
				<td class="lblLight" align="left"><%=em.getParty().getDescription()%></td>
				<td width="22%"/>
			</tr>
			
			<tr>
				<td colspan=8 valign="top"><hr color="red"></hr></td>
			</tr>
			
			<tr>
				<td colspan=8>
					<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<%
				List result = (List)request.getAttribute("result");
				
				boolean findData =  true;
				if(result == null || result.size() <= 0){
					findData = false;
				}
				if(!findData){
					out.println("<br><tr><td colspan='21' class=lblerr align='center'>No Record Found.</td></tr>");
				} else {
			%>
						<tr bgcolor="#4682b4" height="25">
							<td align=center class="lblbold">&nbsp;Project&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Customer&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Jan&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Feb&nbsp;</td>
							<td align=center class="lblbold">&nbsp;March&nbsp;</td>
							<td align=center class="lblbold">&nbsp;April&nbsp;</td>
							<td align=center class="lblbold">&nbsp;May&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Jun&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Jul&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Aug&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Sep&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Oct&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Nov&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Dec&nbsp;</td>
						</tr>
				<%
					SQLResults sr = (SQLResults)result.get(0);
					double total[] = new double[12];
					if(sr == null || sr.getRowCount() <= 0){
				%>
						<tr bgcolor="#e9eee9"> 
							<td width="20%">&nbsp;</td>
							<td width="20%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
						</tr>
				<%
					}else{
						for (int row = 0; row < sr.getRowCount(); row++) {
							String bgcolor = "";
							if(row%2 == 1){
								bgcolor = "#b0c4de";
							}else{
								bgcolor = "#e9eee9";
							}
				%>
						<tr> 
							<td class="lblLight" align=left width="20%" bgcolor="<%=bgcolor%>"><%=(sr.getString(row,"proj_id"))%>:<%=(sr.getString(row,"proj_name"))%></td>
							<td class="lblLight" align=left width="20%" bgcolor="<%=bgcolor%>"><%=(sr.getString(row,"cust_id"))%>:<%=(sr.getString(row,"cust_name"))%></td>
				<%
							for(int i = 0; i<12; i++){
								
								double hrs = sr.getDouble(row,"m"+i);
								String tmpHrs = "";
								if(hrs != 0){
									tmpHrs = numFormator.format(hrs*100);
									total[i] += Double.valueOf(tmpHrs).doubleValue();
								}
				%>
							<td nowrap align=right width="5%" bgcolor="<%=bgcolor%>"><%=tmpHrs.equals("")? "" : (tmpHrs + "%")%></td>
						<%
							}
						%>
						</tr>
				<%
						}
					}
				%>
						<tr bgcolor="#4682b4" height="25">
							<td align=center class="lblbold">&nbsp;Pre-Sale Project&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Customer&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Jan&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Feb&nbsp;</td>
							<td align=center class="lblbold">&nbsp;March&nbsp;</td>
							<td align=center class="lblbold">&nbsp;April&nbsp;</td>
							<td align=center class="lblbold">&nbsp;May&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Jun&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Jul&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Aug&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Sep&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Oct&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Nov&nbsp;</td>
							<td align=center class="lblbold">&nbsp;Dec&nbsp;</td>
						</tr>
				<%
					SQLResults presale = (SQLResults)result.get(1);
					if(presale == null || presale.getRowCount() <= 0){
				%>
						<tr bgcolor="#e9eee9"> 
							<td width="20%">&nbsp;</td>
							<td width="20%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">&nbsp;</td>
						</tr>
				<%
					} else {
						for (int row =0; row < presale.getRowCount(); row++) {
							String color = "";
							if(row%2 == 1){
								color = "#b0c4de";
							}else{
								color = "#e9eee9";
							}
				%>
						<tr> 
							<td class="lblLight" align=left width="20%" bgcolor="<%=color%>"><%=(presale.getString(row,"proj_id"))%>:<%=(presale.getString(row,"proj_name"))%></td>
							<td class="lblLight" align=left width="20%" bgcolor="<%=color%>"><%=(presale.getString(row,"cust_id"))%>:<%=(presale.getString(row,"cust_name"))%></td>
				<%
							for(int i = 0; i<12; i++){
								//String tmpPresale = numFormator.format(presale.getDouble(row,"m"+i)*100);
								//total[i] += Double.valueOf(tmpPresale).doubleValue();
								
								double pre = presale.getDouble(row,"m"+i);
								String tmpPresale = "";
								if(pre != 0){
									tmpPresale = numFormator.format(pre*100);
									total[i] += Double.valueOf(tmpPresale).doubleValue();
								}
								
								
				%>
							<td nowrap align=right width="5%" bgcolor="<%=color%>"><%=tmpPresale.equals("")? "" : (tmpPresale + "%")%></td>
				<%}%>
						</tr>
				<%
						}
					}
				%>
				<tr bgcolor="#4682b4" height="25" align="right">
					<td>&nbsp;</td><td class="lblbold">Total:&nbsp;</td>
				<%
				for(int i=0;i<12;i++){
				%>
					<td><%=total[i]==0?"":numFormator.format(total[i]) + "%"%></td>
				<%}%>
				</tr>
				<%
				}
				%>
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>
<%
	}catch(Exception e){
		e.printStackTrace();
	}
}else{
	out.println("没有访问权限.");
}
%>