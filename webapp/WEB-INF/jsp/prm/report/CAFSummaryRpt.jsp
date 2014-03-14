<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%try{%>
<%if (AOFSECURITY.hasEntityPermission("CAF_SUMMARY", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(1);
Num_formater.setMinimumFractionDigits(1);
Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();

List partyList_dep=null;
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
function SearchResult() {
	var formObj = document.frm;
	if (formObj.textcode.value==""){
		alert("Please select a project first.");
	}else{
		formObj.elements["FormAction"].value = "QueryForList";
		formObj.target = "_self";
		formObj.submit();
	}
}
function ExportExcel() {
	var formObj = document.frm;
	if (formObj.textcode.value==""){
		alert("Please select a project first.");
	}else{
		formObj.elements["FormAction"].value = "ExportToExcel";
		formObj.target = "_self";
		formObj.submit();
	}
}
function showProjctDialog() {
	var code,desc;
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.project.dialog.title&projectList.do?projProfileType=C",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null && v.length > 8) {
			projectCode=v.split("|")[0];
			projectName=v.split("|")[1];
			contractType=v.split("|")[2];
			departmentId=v.split("|")[3];
			departmentNm=v.split("|")[4];
			billToId=v.split("|")[5];
			billToNm=v.split("|")[6];
			pmId=v.split("|")[7];
			pmName=v.split("|")[8];
			//labelProject.innerHTML=projectCode+":"+projectName;

			textcode.value=projectCode;
			textname.value=projectName;
		}
	}
}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> CAF Checking Report</caption> 
<tr>
	<td>
		<Form action="pas.report.CAFSummaryRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction">
		<table width=100%>
			<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
			<%	String textcode = request.getParameter("textcode");
				if (textcode == null) textcode ="";
				String textname = request.getParameter("textname");
				if (textname == null) textname ="";
			%>
			<tr>
				<td width ="20%"></td>
				<td class="lblbold">Project:</td>
				<td class="lblLight" width="35%">
					<input type=hidden name="textname" value="<%=textname%>">
					<input type="text" name="textcode" size="25" value="<%=textcode%>" style="TEXT-ALIGN: right" class="lbllgiht">
					
					<a href="javascript:void(0)" onclick="showProjctDialog();event.returnValue=false;">
					<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
				</td>
				
			    <td  align="right">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
				</td>
				<td width ="20%"></td>
			</tr>
			<tr>
				<td colspan=6 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr bgcolor="#e9eee9">
				<td align=center class="lblbold">&nbsp;Project&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Contract No.&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Customer&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Line Type&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Plan Days&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Issued Days&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Remaining Days&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Consultant&nbsp;</td>
				<td align=center class="lblbold">&nbsp;CAF Date&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Entry Days&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Confirmed Days&nbsp;</td>
				<td align=center class="lblbold">&nbsp;CAF Price&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Batch No.&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Invoice No.&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Receipt No.&nbsp;</td>
			</tr>
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			Object resultSet_data;
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='15' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				String osc = "";
				String nsc = "";
				String pcode ="";
				String npcode ="";
				String oldReceipt="";
				String newReceipt="";
				String oldInvoice="";
				String newInvoice="";
				double totalDys = 0;
				double totalCDys = 0;
				double totalPrice = 0;
				Date oldDate = null;
				Date newDate = null;
				for (int row =0; row < sr.getRowCount(); row++) {
					double actualDay = 0;
					double budgetDay = 0;
					double remainDay = 0;
					actualDay = sr.getDouble(row,"issued_days")/8;
					budgetDay = sr.getDouble(row,"st_estDays");
					remainDay = budgetDay - actualDay;
					npcode = sr.getString(row,"proj_id");
					nsc = sr.getString(row,"st_desc");
					newReceipt = (sr.getString(row, "receipt_no") == null ) ? "" : sr.getString(row, "receipt_no");
					newInvoice = (sr.getString(row, "inv_code") == null ) ? "" : sr.getString(row, "inv_code");
					newDate = sr.getDate(row,"tsdate");

					if (!npcode.equals(pcode)){
					pcode = sr.getString(row,"proj_id") ;
				%>
					<tr bgcolor="#e9eee1"> 
						<td nowrap align=left class="lblbold"><%=pcode + ":"+sr.getString(row,"proj_name")%></td>
						<td nowrap align=left class="lblbold"><%=sr.getString(row,"proj_contract_no")%></td>
						<td nowrap align=left class="lblbold"><%=sr.getString(row,"description")%></td>
						<%if (!nsc.equals(osc)){
							osc = nsc;		
						%>
							<td nowrap align=center class="lblbold"><%=nsc%></td>
							<td nowrap align=right class="lblbold"><%=sr.getDouble(row,"st_estDays")%></td>
							<td nowrap align=right class="lblbold"> <%=sr.getDouble(row,"issued_days")/8%></td>
							<td nowrap align=right class="lblbold"> <%=remainDay%></td>
							<td nowrap align=left> <%=sr.getString(row,"username")%></td>
							<td nowrap align=left><%=Date_formater.format(sr.getDate(row,"tsdate"))%></td>
							<td nowrap align=right><%=sr.getDouble(row,"tshr")/8%></td>
							<td nowrap align=right><%=sr.getDouble(row,"tsconfim")/8%></td>
							<td nowrap align=right><%=sr.getDouble(row,"st_rate")*(sr.getDouble(row,"tsconfim")/8)%></td>
							<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"bill_code"))==null) ? "N/A":resultSet_data)%></td>
							<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"inv_code"))==null) ? "N/A":resultSet_data)%></td>
							<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"receipt_no"))==null) ? "N/A":resultSet_data)%></td>
							<%
								oldDate = newDate;
								oldInvoice = newInvoice;
								oldReceipt = newReceipt;
								totalDys = totalDys + sr.getDouble(row,"tshr")/8;
								totalCDys = totalCDys + sr.getDouble(row,"tsconfim")/8;
								totalPrice = totalPrice + sr.getDouble(row,"st_rate")*sr.getDouble(row,"tsconfim")/8;
							%>
						<%}else{%>
							<%if (newInvoice.equals(oldInvoice) && (newDate.equals(oldDate)) && !newReceipt.equals(oldReceipt)){
							%>
								<td colspan='11'></td> 
								<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"receipt_no"))==null) ? "N/A":resultSet_data)%></td>
							<%
								
							}else{%>
								<td colspan='4'></td>
								<td nowrap align=left> <%=sr.getString(row,"username")%></td>
								<td nowrap align=left><%=Date_formater.format(sr.getDate(row,"tsdate"))%></td>
								<td nowrap align=right><%=sr.getDouble(row,"tshr")/8%></td>
								<td nowrap align=right><%=sr.getDouble(row,"tsconfim")/8%></td>
								<td nowrap align=right><%=sr.getDouble(row,"st_rate")*(sr.getDouble(row,"tsconfim")/8)%></td>
								<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"bill_code"))==null) ? "N/A":resultSet_data)%></td>
								<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"inv_code"))==null) ? "N/A":resultSet_data)%></td>
								<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"receipt_no"))==null) ? "N/A":resultSet_data)%></td>
								
							<%
								totalDys = totalDys + sr.getDouble(row,"tshr")/8;
								totalCDys = totalCDys + sr.getDouble(row,"tsconfim")/8;
								totalPrice = totalPrice + sr.getDouble(row,"st_rate")*sr.getDouble(row,"tsconfim")/8;
							}
							%>
							<%
								oldDate = newDate;
								oldInvoice = newInvoice;
								oldReceipt = newReceipt;
								
							%>
						<%
							}
							
						%>
					</tr>
					<%}else{%>
					<tr bgcolor="#e9eee1"> 
						
						<%if (!nsc.equals(osc)){
							osc = nsc;%>
							<td nowrap colspan = '3'></td>
							<td nowrap align=center class="lblbold"><%=nsc%></td>
							<td nowrap align=right class="lblbold"><%=sr.getDouble(row,"st_estDays")%></td>
							<td nowrap align=right class="lblbold"> <%=sr.getDouble(row,"issued_days")/8%></td>
							<td nowrap align=right class="lblbold"> <%=remainDay%></td>
							<td nowrap align=left> <%=sr.getString(row,"username")%></td>
							<td nowrap align=left><%=Date_formater.format(sr.getDate(row,"tsdate"))%></td>
							<td nowrap align=right><%=sr.getDouble(row,"tshr")/8%></td>
							<td nowrap align=right><%=sr.getDouble(row,"tsconfim")/8%></td>
							<td nowrap align=right><%=sr.getDouble(row,"st_rate")*(sr.getDouble(row,"tsconfim")/8)%></td>
							<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"bill_code"))==null) ? "N/A":resultSet_data)%></td>
							<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"inv_code"))==null) ? "N/A":resultSet_data)%></td>
							<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"receipt_no"))==null) ? "N/A":resultSet_data)%></td>
							<%
								oldDate = newDate;
								oldInvoice = newInvoice;
								oldReceipt = newReceipt;
								totalDys = totalDys + sr.getDouble(row,"tshr")/8;
								totalCDys = totalCDys + sr.getDouble(row,"tsconfim")/8;
								totalPrice = totalPrice + sr.getDouble(row,"st_rate")*sr.getDouble(row,"tsconfim")/8;
							%>
						<%}else{%>
							<% 	
							if ((newInvoice.equals(oldInvoice)) && (newDate.equals(oldDate)) && (!newReceipt.equals(oldReceipt))){
							%>
								<td colspan='14'></td> 
								<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"receipt_no"))==null) ? "N/A":resultSet_data)%></td>	
							<%}else{%>
								<td colspan='7'></td>
								<td nowrap align=left> <%=sr.getString(row,"username")%></td>
								<td nowrap align=left><%=Date_formater.format(sr.getDate(row,"tsdate"))%></td>
								<td nowrap align=right><%=sr.getDouble(row,"tshr")/8%></td>
								<td nowrap align=right><%=sr.getDouble(row,"tsconfim")/8%></td>
								<td nowrap align=right><%=sr.getDouble(row,"st_rate")*(sr.getDouble(row,"tsconfim")/8)%></td>
								<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"bill_code"))==null) ? "N/A":resultSet_data)%></td>
								<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"inv_code"))==null) ? "N/A":resultSet_data)%></td>
								<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"receipt_no"))==null) ? "N/A":resultSet_data)%></td>
							<%
							totalDys = totalDys + sr.getDouble(row,"tshr")/8;
								totalCDys = totalCDys + sr.getDouble(row,"tsconfim")/8;
								totalPrice = totalPrice + sr.getDouble(row,"st_rate")*sr.getDouble(row,"tsconfim")/8;
							}%>
							<%
								oldDate = newDate;
								oldInvoice = newInvoice;
								oldReceipt = newReceipt;
							%>
						<%}%>
						</tr>
					<%}%>
				<%}%>
					<tr bgcolor="#e9eee1">
						<td colspan='8'></td>
						<td nowrap align=center class="lblbold"> Total :</td>
						<td nowrap align=right class="lblbold"> <%=Num_formater.format(totalDys)%></td>
						<td nowrap align=right class="lblbold"> <%=Num_formater.format(totalCDys)%></td>
						<td nowrap align=right class="lblbold"> <%=Num_formater.format(totalPrice)%></td>
						<td colspan='3'></td>
					</tr>
			<%}%>
		</table>
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