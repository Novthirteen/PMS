<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="net.sf.hibernate.Session"%>
<%@ page import="com.aof.core.persistence.hibernate.Hibernate2Session"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.component.domain.party.Party"%>
<%@ page import="com.aof.component.domain.party.PartyHelper"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%if (AOFSECURITY.hasEntityPermission("PAS_UTL_REPORT", "_VIEW", session)) {%>

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunctions.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>

<%
	try{
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String myString = df.format(Calendar.getInstance().getTime());
		StringTokenizer st=new StringTokenizer(myString,"-");
		int thisYear=Integer.parseInt(st.nextToken());
		
		NumberFormat numFormator = NumberFormat.getInstance();
		numFormator.setMaximumFractionDigits(1);
		numFormator.setMinimumFractionDigits(1);
		
		
		String year = request.getParameter("iYear");
		String employeeId = request.getParameter("employeeId");
		String departmentId = request.getParameter("departmentId");
		
		if (departmentId == null) {
			departmentId = "";
		}
		
		if(year == null){
			year = "";
		}
		if (employeeId == null) {
			employeeId = "";
		}
		
		List partyList_dep = null;
		Session hs = Hibernate2Session.currentSession();
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
<script language="javascript">

	function fnQuery() {
	
		var formObj = document.iForm;
		
		if(!checkDeciNumber2(formObj.iYear,1,1,'Year',-9999999999,9999999999)){
			return;
		}
		
		formObj.formAction.value = "list";
		formObj.target = "_self";
		formObj.submit();
	}
	
	function fnExport() {
	
		var formObj = document.iForm;
		
		if(!checkDeciNumber2(formObj.iYear,1,1,'Year',-9999999999,9999999999)){
			return;
		}
	    
		formObj.formAction.value = "export";
		formObj.target = "_self";
		formObj.submit();
	}
	
	function fnView(id){
		
		var param = "?formAction=view&iYear=<%=year%>&employeeId=" + id;
		
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.report.util.dialog.title&pas.report.UtilizationByStaffRpt.do" + param,
			null,
			'dialogWidth:800px;dialogHeight:500px;status:no;help:no;scroll:no');
	}
	
	function showDialog_account(){
		var code,desc;
		
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&userList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			document.getElementById("employeeId").value=code;
		} else {
			document.getElementById("employeeId").value="";
		}
	}

</script>

<table width="100%" cellpadding="1" border="0" cellspacing="1">
	<caption class="pgheadsmall"> Utilization Summary Report By Staff</caption> 
	<tr>
		<td>
			<form action="pas.report.UtilizationByStaffRpt.do" name="iForm" method="post">
				<input type="hidden" name="formAction" id="formAction">
				<table width=100%>
					<tr>
						<td colspan=18 valign="bottom"><hr color=red></hr></td>
					</tr>
					<tr>
						<td width="5%"/>
						<td class="lblbold" width="10%" align="right">Year:&nbsp;</td>
						<td class="lblLight" width="10%" align="left">
							<select name="iYear">
								<%
								for(int i = 5; i > 0; i--){
								%>
				       			<option value="<%=thisYear - i%>" <%=year.equals(String.valueOf(thisYear - i))? "selected" : ""%>><%=thisYear - i%></option>
				       			<%}%>
				       			<option value="<%=thisYear%>" <%=(year.equals("") || year == null || year.equals(String.valueOf(thisYear)))? "selected" : ""%>><%=thisYear%></option>
				       		</select>
							
						</td>
						<td class="lblbold" width="10%" align="right">Employee ID:&nbsp;</td>
						<td class="lblLight" width="12%" align="left">
				        	<input type="text" class="inputBox" name="employeeId" id="employeeId" size="10" value="<%=employeeId%>">
							<a href="javascript:showDialog_account()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
				        </td>
				        <td class="lblbold"width="10%"  align="right">Department:&nbsp;</td>
						<td class="lblbold"width="10%"  align="left">
							<select name="departmentId">
							<%
							if (AOFSECURITY.hasEntityPermission("PAS_PM_REPORT", "_ALL", session)) {
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
						<td  align="center">
							<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="fnQuery()">
							<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="fnExport()">
						</td>
					</tr>
					<tr>
						<td colspan=18 valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellpadding="2" cellspacing="2" width=100%>
	<%
		SQLResults sr = (SQLResults)request.getAttribute("result");
		
		boolean findData =  true;
		if(sr == null || sr.getRowCount() <= 0){
			findData = false;
		}
		if(!findData){
			out.println("<br><tr><td colspan='21' class=lblerr align='center'>No Record Found.</td></tr>");
		} else {
	%>
				<tr bgcolor="#4682b4" height="25">
					<td align=center class="lblbold">Employee ID</td>
					<td align=center class="lblbold">Employee Name</td>
					<td align=center class="lblbold" width="10%">&nbsp;Jan&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;Feb&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;March&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;April&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;May&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;Jun&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;Jul&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;Aug&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;Sep&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;Oct&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;Nov&nbsp;</td>
					<td align=center class="lblbold" width="10%">&nbsp;Dec&nbsp;</td>
				</tr>
		<%
		
			for (int row = 0; row < sr.getRowCount(); row++) {
				String bgcolor = "";
				if(row%2 == 1){
					bgcolor = "#b0c4de";
				}else{
					bgcolor = "#e9eee9";
				}
		%>
				<tr>
					<td class="lblLight" align="center" width="20%" bgcolor="<%=bgcolor%>">
						<a style="cursor:hand" onclick="fnView('<%=sr.getString(row,"cn")%>')"><u><%=sr.getString(row,"cn")%></a>
					</td>
					<td class="lblLight" align="center" width="20%" bgcolor="<%=bgcolor%>"><%=(sr.getString(row,"name"))%></td>
		<%
				for(int i = 0; i<12; i++){
					double hrs = sr.getDouble(row,"m"+i);
					String tmpHrs = "";
					if(hrs != 0){
						tmpHrs = numFormator.format(hrs*100);
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
			</table>
		</td>
	</tr>
</table>

<%
	}catch(Exception e){
		e.printStackTrace();
	}
}else{
	out.println("没有访问权限.");
}
%>