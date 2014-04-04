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
<%if (AOFSECURITY.hasEntityPermission("PAS_REVENUE_REPORT", "_VIEW", session)) {%>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat numFormat1 = NumberFormat.getInstance();
numFormat1.setMaximumFractionDigits(0);
numFormat1.setMinimumFractionDigits(0);
NumberFormat numFormat2 = NumberFormat.getInstance();
numFormat2.setMaximumFractionDigits(1);
numFormat2.setMinimumFractionDigits(1);

String SrcYear = (String)request.getAttribute("SrcYear");
String SrcMonth = (String)request.getAttribute("SrcMonth");
int srcYR = 0;
int srcM = 0;
srcYR = new Integer(SrcYear).intValue();
srcM = new Integer(SrcMonth).intValue();

String departmentId = request.getParameter("departmentId");
if (departmentId == null) departmentId = "";

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
	formObj.elements["FormAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	formObj.elements["FormAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
</script>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall">Revenue Report</caption> 
<tr>
	<td>
		<Form action="pas.report.ForecastVarianceRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction" id="FormAction">
		<table width=100%>
			<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Fiscal Month:</td>
				<td class="lblLight">
					<SELECT name=SrcYear>
					<%for (int i=(srcYR-1); i<= srcYR; i++) {%>
						<Option value='<%=i%>' <%if (i == srcYR) {%> Selected <%}%>><%=i%></OPTION>
					<%}%>
					</SELECT>
					-
					<SELECT name=SrcMonth>
					<%for (int i=0; i<12; i++) {%>
						<Option value='<%=i%>' <%if (i == srcM) {%> Selected <%}%>><%=i+1%></OPTION>
					<%}%>
					</SELECT>
				</td>
				<td class="lblbold">Department:</td>
				<td class="lblLight">
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
				<%boolean detailflag = false;
				if (request.getParameter("detailflag") != null) detailflag = true;%>
				<td align="left" class="lblbold"><input type=checkbox class="checkboxstyle" name=detailflag value="Y" <%if (detailflag) out.print("Checked");%>>Show Sub-Project Detail
				</td>
				<td class="lblbold">&nbsp;</td>
				<td class="lblLight">&nbsp;</td>
			</tr>
			<tr>
			     <td colspan=4 align="left"/>
				<td  align="left">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
				</td>
				
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
				<td rowspan=2 class="lblbold" align=center>&nbsp;Project Code&nbsp;</td>
				<td rowspan=2 class="lblbold" align=center>&nbsp;Project Name&nbsp;</td>			
				<td rowspan=2 class="lblbold" align=center>&nbsp;Project Manager&nbsp;</td>
				<td rowspan=2 class="lblbold" align=center>&nbsp;Customer&nbsp;</td>
				<td rowspan=2 class="lblbold" align=center>&nbsp;TCV&nbsp;</td>
				<td colspan=4 class="lblbold" align=center>&nbsp;Last Month Forecast&nbsp;</td>
				<td colspan=4 class="lblbold" align=center>&nbsp;Current Month Actual&nbsp;</td>
				<td colspan=2 class="lblbold" align=center>&nbsp;In-Month&nbsp;</td>
			</tr>
			<tr bgcolor="#e9eee9">
				<td align=center class="lblbold" align=center>&nbsp;Costs To-Date (RMB)&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Forecast to Comp (RMB)&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;% Comp&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Rev booked To-Date (RMB)&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Costs To-Date (RMB)&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Forecast to Comp (RMB)&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;% Comp &nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Rev to be booked To-Date (RMB)&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;% Comp&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Booked Revenue (RMB)&nbsp;</td>
			</tr>
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			Object resultSet_data;
			String OldPM = "";
			String NewPM = "";			String NewProject = "";
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='12' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				for (int row =0; row < sr.getRowCount(); row++) {
					NewPM = sr.getString(row,"name");

					double total_sales_value = sr.getDouble(row,"total_sales_value");
					double CurrCost = sr.getDouble(row,"CurrCost");
					double CurrCTC = sr.getDouble(row,"CurrCTC");
					double CurrComp = sr.getDouble(row,"CurrComp");
					double CurrRev = sr.getDouble(row,"CurrRev");
					double LastCost = sr.getDouble(row,"LastCost");
					double LastCTC = sr.getDouble(row,"LastCTC");
					double LastComp = sr.getDouble(row,"LastComp");
					double LastRev = sr.getDouble(row,"LastRev");
				%>
					<tr bgcolor="#e9eee9">
						<td class="lblbold" align=left><%=sr.getString(row,"proj_id")%></td>
						<td class="lblbold" align=left><%=sr.getString(row,"proj_name")%></td>
						<td class="lblbold" align=left><%=NewPM%></td>
						<td class="lblbold" align=left><%=sr.getString(row,"description")%></td>
						<td nowrap align=right><%=numFormat1.format(total_sales_value)%></td>
						<td nowrap align=right><%=numFormat1.format(LastCost)%></td>
						<td nowrap align=right><%=numFormat1.format(LastCTC)%></td>
						<td nowrap align=right><%=numFormat2.format(LastComp)%></td>
						<td nowrap align=right><%=numFormat1.format(LastRev)%></td>
						<td nowrap align=right><%=numFormat1.format(CurrCost)%></td>
						<td nowrap align=right><%=numFormat1.format(CurrCTC)%></td>
						<td nowrap align=right><%=numFormat2.format(CurrComp)%></td>
						<td nowrap align=right><%=numFormat1.format(CurrRev)%></td>
						<td nowrap align=right><%=numFormat2.format((CurrComp-LastComp))%></td>
						<td nowrap align=right><%=numFormat1.format(CurrRev-LastRev)%></td>
					</tr>
				<%}
			}%>
		</table>
	</td>
</tr>
</table>
<%
}else{
	out.println("没有访问权限.");
}
%>