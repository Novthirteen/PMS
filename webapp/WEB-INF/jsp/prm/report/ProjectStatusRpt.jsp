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
<%if (AOFSECURITY.hasEntityPermission("PAS_PROJ_STATUS_REPORT", "_VIEW", session)) {%>
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
<caption class="pgheadsmall">Project Status by Project Manager</caption> 
<tr>
	<td>
		<Form action="pas.report.ProjectStatusRpt.do" name="frm" method="post">
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
				<td rowspan="2" colspan="2" class="lblbold" align=center>&nbsp;Project&nbsp;</td>
				<td rowspan="2" class="lblbold" align=center>&nbsp;Customer&nbsp;</td>
				<td rowspan="2" class="lblbold" align=center>&nbsp;TCV (RMB)&nbsp;</td>
				<td rowspan="2" class="lblbold" align=center>&nbsp;Service Value (RMB)&nbsp;</td>
				<td rowspan="2" class="lblbold" align=center>&nbsp;Budget (RMB)&nbsp;</td>
				<td colspan="2" class="lblbold" align=center>&nbsp;Projected Cost (RMB)&nbsp;</td>
				<td colspan="2" class="lblbold" align=center>&nbsp;Completion[%]&nbsp;</td>
				<td colspan="2" class="lblbold" align=center>&nbsp;Variance&nbsp;</td>
				<td colspan="4" class="lblbold" align=center>&nbsp;Profitability&nbsp;</td>
			</tr>
			<tr bgcolor="#e9eee9">
				<td align=center class="lblbold">&nbsp;Last Month&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Current&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Last Month&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Current&nbsp;</td>
				<td align=center class="lblbold">&nbsp;To Date&nbsp;</td>
				<td align=center class="lblbold">&nbsp;To Date%&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Budget&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Budget%&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Actual To Date&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Actual To Date%&nbsp;</td>
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
				out.println("<br><tr><td colspan='14' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				String oldPMId = "";
				String newPMId = "";
				String projectMangerNm = "";
				String projectId = "";
				String projectNm = "";
				String customerNm = "";
				double totalSalesVal = 0;
				double serviceValue = 0;
				double budget = 0;
				double costLastMth = 0;
				double costCurr = 0;
				double compLastMth = 0;
				double compCurr = 0;
				double budgetVariance = 0;
				double budgetVariancePercent = 0;
				double profitPlan = 0;
				double profitPlanPercent = 0;
				double profitActual = 0;
				double profitActualPercent = 0;
				
				double sumTotalSalesVal = 0;
				double sumServiceValue = 0;
				double sumBudget = 0;
				double sumCostLastMth = 0;
				double sumCostCurr = 0;
				double sumLastCTC = 0;
				double sumCurrCTC = 0;
				
				double totalSumTotalSalesVal = 0;
				double totalSumServiceValue = 0;
				double totalSumBudget = 0;
				double totalSumCostLastMth = 0;
				double totalSumCostCurr = 0;
				double totalSumLastCTC = 0;
				double totalSumCurrCTC = 0;
				
				for (int row =0; row < sr.getRowCount(); row++) {
					newPMId = sr.getString(row, "user_login_id");
					projectMangerNm = sr.getString(row, "name");
					projectId = sr.getString(row, "proj_id");
					projectNm = sr.getString(row, "proj_name");
					customerNm = sr.getString(row, "DESCRIPTION");
					totalSalesVal = sr.getDouble(row, "total_service_value") + sr.getDouble(row, "total_lics_value");
					serviceValue = sr.getDouble(row, "total_service_value");
					budget = sr.getDouble(row, "PSC_Budget") + sr.getDouble(row, "EXP_Budget") + sr.getDouble(row, "proc_budget");
					costLastMth = sr.getDouble(row, "LastCost");
					costCurr = sr.getDouble(row, "CurrCost");										
					if (costLastMth + sr.getDouble(row, "LastCTC") != 0) {
						compLastMth = (costLastMth / (costLastMth + sr.getDouble(row, "LastCTC"))) * 100;
					} else {
						compLastMth = 0;
					}
					if (costCurr + sr.getDouble(row, "CurrCTC") != 0) {
						compCurr = (costCurr / (costCurr + sr.getDouble(row, "CurrCTC"))) * 100;
					} else {
						compCurr = 0;
					}
					budgetVariance = costCurr - budget;
					
					if (budget != 0) {
						budgetVariancePercent = (budgetVariance / budget) * 100;
					} else {
						budgetVariancePercent = 0;
					}
					profitPlan = totalSalesVal - budget;
					if (totalSalesVal != 0) {
						profitPlanPercent = (profitPlan / totalSalesVal) * 100;
					} else {
						profitPlanPercent = 0;
					}
					profitActual = totalSalesVal - costCurr;
					if (totalSalesVal != 0) {
						profitActualPercent = (profitActual / totalSalesVal) * 100;
					} else {
						profitActualPercent = 0;
					}
					
					if (!oldPMId.equals(newPMId)) {
						oldPMId = newPMId;
				%>
				
				<%
						if  (row != 0) {
				%>
				<tr bgcolor="#e9eee9">
					<td colspan="3" class="lblbold" nowrap align=right>Grand Total:</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumTotalSalesVal)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumServiceValue)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumBudget)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumCostLastMth)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumCostCurr)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((sumCostLastMth + sumLastCTC) != 0 ?  (sumCostLastMth / (sumCostLastMth + sumLastCTC)) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((sumCostCurr + sumCurrCTC) != 0 ?  (sumCostCurr / (sumCostCurr + sumCurrCTC)) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumCostCurr - sumBudget)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumBudget != 0 ?  ((sumCostCurr - sumBudget) / sumBudget) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumTotalSalesVal - sumBudget)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((sumTotalSalesVal - sumBudget) != 0 ? ((sumTotalSalesVal - sumBudget) / sumTotalSalesVal) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumTotalSalesVal - sumCostCurr)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((sumTotalSalesVal - sumCostCurr) != 0 ? ((sumTotalSalesVal - sumCostCurr) / sumTotalSalesVal) * 100 : 0)%>%</td>
				</tr>
				
				<%
						}
					sumTotalSalesVal = 0;
					sumServiceValue = 0;
					sumBudget = 0;
					sumCostLastMth = 0;
					sumCostCurr = 0;
					sumLastCTC = 0;
					sumCurrCTC = 0;
				%>
				<tr bgcolor="#e9eee9">
					<td class="lblbold" colspan="2" align="left">
						<font size="2"><u><%=projectMangerNm%></u></font>
					</td>
					<td class="lblbold" colspan="14"></td>
				</tr>
				<%
					}
					
					sumTotalSalesVal += totalSalesVal;
					sumServiceValue += serviceValue;
					sumBudget += budget;
					sumCostLastMth += costLastMth;
					sumCostCurr += costCurr;
					sumLastCTC += sr.getDouble(row, "LastCTC");
					sumCurrCTC += sr.getDouble(row, "CurrCTC");
					
					totalSumTotalSalesVal += totalSalesVal;
				    totalSumServiceValue += serviceValue;
				    totalSumBudget += budget;
				    totalSumCostLastMth += costLastMth;
				    totalSumCostCurr += costCurr;
				    totalSumLastCTC += sr.getDouble(row, "LastCTC");
				    totalSumCurrCTC += sr.getDouble(row, "CurrCTC");
				%>
					<tr bgcolor="#e9eee9">
						<td nowrap align=left><%=projectId%></td>
						<td nowrap align="left"><%=projectNm%></td>
						<td nowrap align="left"><%=customerNm%></td>
						<td nowrap align=right><%=Num_formater.format(totalSalesVal)%></td>
						<td nowrap align=right><%=Num_formater.format(serviceValue)%></td>
						<td nowrap align=right><%=Num_formater.format(budget)%></td>
						<td nowrap align=right><%=Num_formater.format(costLastMth)%></td>
						<td nowrap align=right><%=Num_formater.format(costCurr)%></td>
						<td nowrap align=right><%=Num_formater.format(compLastMth)%>%</td>
						<td nowrap align=right><%=Num_formater.format(compCurr)%>%</td>
						<td nowrap align=right><%=Num_formater.format(budgetVariance)%></td>
						<td nowrap align=right><%=Num_formater.format(budgetVariancePercent)%>%</td>
						<td nowrap align=right><%=Num_formater.format(profitPlan)%></td>
						<td nowrap align=right><%=Num_formater.format(profitPlanPercent)%>%</td>
						<td nowrap align=right><%=Num_formater.format(profitActual)%></td>
						<td nowrap align=right><%=Num_formater.format(profitActualPercent)%>%</td>
					</tr>
					
				<%
					}
					
				%>
				<tr bgcolor="#e9eee9">
					<td colspan="3" class="lblbold" nowrap align=right>Sub Total:</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumTotalSalesVal)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumServiceValue)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumBudget)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumCostLastMth)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumCostCurr)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((sumCostLastMth + sumLastCTC) != 0 ?  (sumCostLastMth / (sumCostLastMth + sumLastCTC)) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((sumCostCurr + sumCurrCTC) != 0 ?  (sumCostCurr / (sumCostCurr + sumCurrCTC)) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumCostCurr - sumBudget)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumBudget != 0 ?  ((sumCostCurr - sumBudget) / sumBudget) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumTotalSalesVal - sumBudget)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((sumTotalSalesVal - sumBudget) != 0 ? ((sumTotalSalesVal - sumBudget) / sumTotalSalesVal) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(sumTotalSalesVal - sumCostCurr)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((sumTotalSalesVal - sumCostCurr) != 0 ? ((sumTotalSalesVal - sumCostCurr) / sumTotalSalesVal) * 100 : 0)%>%</td>
				</tr>
				
				<tr bgcolor="#e9eee9">
					<td colspan="3" class="lblbold" nowrap align=right>Grand Total:</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(totalSumTotalSalesVal)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(totalSumServiceValue)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(totalSumBudget)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(totalSumCostLastMth)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(totalSumCostCurr)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((totalSumCostLastMth + totalSumLastCTC) != 0 ?  (totalSumCostLastMth / (totalSumCostLastMth + totalSumLastCTC)) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((totalSumCostCurr + totalSumCurrCTC) != 0 ?  (totalSumCostCurr / (totalSumCostCurr + totalSumCurrCTC)) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(totalSumCostCurr - totalSumBudget)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(totalSumBudget != 0 ?  ((totalSumCostCurr - totalSumBudget) / totalSumBudget) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(totalSumTotalSalesVal - totalSumBudget)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((totalSumTotalSalesVal - totalSumBudget) != 0 ? ((totalSumTotalSalesVal - totalSumBudget) / totalSumTotalSalesVal) * 100 : 0)%>%</td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format(totalSumTotalSalesVal - totalSumCostCurr)%></td>
					<td class="lblbold" nowrap align=right><%=Num_formater.format((totalSumTotalSalesVal - totalSumCostCurr) != 0 ? ((totalSumTotalSalesVal - totalSumCostCurr) / totalSumTotalSalesVal) * 100 : 0)%>%</td>
				</tr>
				<%
				}
				%>
		</table>
	</td>
</tr>
</table>
<%
}else{
	out.println("没有访问权限.");
}
%>