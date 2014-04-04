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
<%if (AOFSECURITY.hasEntityPermission("PAS_COST_VS_BUDGET_REPORT", "_VIEW", session)) {%>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);

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
<caption class="pgheadsmall">Project Status Report</caption> 
<tr>
	<td>
		<Form action="pas.report.ProjectOverBudgetRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction" id="FormAction">
		<table width=100% >
			<tr>
				<td colspan=7 valign="bottom"><hr color=red></hr></td>
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
				<td colspan=7 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr bgcolor="#e9eee9">
				<td  class="lblbold" align=center>&nbsp;Project Code&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Project Name&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Project Manager&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Customer&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;TCV (RMB)&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Total Ops. Budget (RMB)&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Total Subcontract Budget (RMB)&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;In-Month Costs(RMB)&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;In-Month sub contract Costs(RMB)&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Total Costs To-Date (RMB)&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Forecast to Completion (RMB)&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Cost Variance To-Date (RMB)&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Completion %&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Cost Variance To End of Project (RMB)&nbsp;</td>
				<td  class="lblbold" align=center>&nbsp;Forecasted Variance % Over Budget&nbsp;</td>
			</tr>
			
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			Object resultSet_data;
			String OldPM = "";
			String NewPM = "";			
			String PCode = "";
			String PName = "";
			String Cust = "";
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='26' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				for (int row =0; row < sr.getRowCount(); row++) {
					PCode = sr.getString(row,"proj_id");
					PName = sr.getString(row,"proj_name");
					NewPM = sr.getString(row,"user_login_id");
					if (!OldPM.equals(NewPM)) {
						OldPM = NewPM;
						NewPM = NewPM + ":" + sr.getString(row,"name");
					} else {
						NewPM = "&nbsp;";
					}
					Cust = sr.getString(row,"c_name");
					double total_service_value = sr.getDouble(row,"total_sales_value");
					double total_budget = sr.getDouble(row,"total_budget");
					double CurrCost = sr.getDouble(row,"CurrCost");
					double AllCost = sr.getDouble(row,"TotalCost");
					double CurrCTC = sr.getDouble(row,"CurrCTC");
					double Budget_Variance_Todate = AllCost - total_budget;
					double Budget_Variance_Toend = Budget_Variance_Todate + CurrCTC;
					double P_Comp = 0;
					if ((AllCost+CurrCTC) != 0) P_Comp = AllCost/(AllCost+CurrCTC)*100;
					double P_Forecast_OB = 0;
					if (total_budget != 0) P_Forecast_OB = Budget_Variance_Toend/total_budget*100;
				%>
					<tr bgcolor="#e9eee9">
						<td class="lblbold"><%=PCode%></td>
						<td nowrap align=left><%=PName%></td>
						<td nowrap align=left><%=NewPM%></td>
						<td nowrap align=left><%=Cust%></td>
						<td nowrap align=right><%=Num_formater.format(total_service_value)%></td>
						<td nowrap align=right><%=Num_formater.format(total_budget)%></td>
						<td nowrap align=right><%=Num_formater.format(sr.getDouble(row, "proc_budget"))%></td>
						<td nowrap align=right><%=Num_formater.format(CurrCost)%></td>
						<td nowrap align=right><%=Num_formater.format(sr.getDouble(row,"SubCon_CurrCost"))%></td>
						<td nowrap align=right><%=Num_formater.format(AllCost)%></td>
						<td nowrap align=right><%=Num_formater.format(CurrCTC)%></td>
						<td nowrap align=right><%=Num_formater.format(Budget_Variance_Todate)%></td>
						<td nowrap align=right><%=Num_formater.format(P_Comp)%></td>
						<td nowrap align=right><%=Num_formater.format(Budget_Variance_Toend)%></td>
						
						<td nowrap align=right><%=Num_formater.format(P_Forecast_OB)%></td>
						
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