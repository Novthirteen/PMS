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
<%if (AOFSECURITY.hasEntityPermission("PAS_EXP_ANALYSIS_REPORT", "_VIEW", session)) {%>
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
<caption class="pgheadsmall">Expense Analysis Report </caption> 
<tr>
	<td>
		<Form action="pas.report.ExpenseAnalysisRpt.do" name="frm" method="post">
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
						<option value="">(All Related to You)</option>
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
				<td class="lblbold">&nbsp;</td>
				<td class="lblLight">&nbsp;</td>
			</tr>
			<tr>
				<td colspan=5 align="left">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
				</td>
				<%boolean detailflag = false;
				if (request.getParameter("detailflag") != null) detailflag = true;%>
				<td align="left" class="lblbold"><input type=checkbox class="checkboxstyle" name=detailflag value="Y" <%if (detailflag) out.print("Checked");%>>Show Sub-Project Detail
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
				<td align=center class="lblbold" align=center>&nbsp;Projcode&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Type&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Name&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Entry Date&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Exps Date&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Curr&nbsp;</td>
				<td align=center class="lblbold" align=center>&nbsp;Claim Value&nbsp;</td>
			</tr>
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			Object resultSet_data;		
			String newProject = "";
			String oldproject = "";
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='7' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				Date_formater = new SimpleDateFormat("dd/MM/yyyy");
				double totalValue = 0;
				for (int row =0; row < sr.getRowCount(); row++) {
					newProject = sr.getString(row, "Projcode");
					String projectName = sr.getString(row, "ProjName");
					if (projectName == null) projectName = "";
					if (!oldproject.equals(newProject)) {
						oldproject = newProject;
				%>
				<%
					if (row != 0) {
				%>
					<tr bgcolor="#e9eee9">
						<td ></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td class="lblbold" align=right>Project Total:</td>
						<td class="lblbold" align=right><%= Num_formater.format(totalValue) %></td>
					</tr>
				<%
						totalValue = 0;
					}
				%>
				
				<tr bgcolor="#e9eee9">
					<td class="lblbold"><%=oldproject%>:<%=projectName%></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<%
					}
					
					String type = sr.getString(row, "Type");
					String name = sr.getString(row, "Name");
					java.util.Date entryDate = sr.getDate(row, "EntryDate");
					java.util.Date expsDate = sr.getDate(row, "ExpsDate");
					String curr = sr.getString(row, "Curr");
					double claimValue = sr.getDouble(row, "ClaimValue");
					totalValue = totalValue + claimValue;
				%>
					<tr bgcolor="#e9eee9">
						<td></td>
						<td nowrap align=left><%=type%></td>
						<td nowrap align=left><%=name%></td>
						<td nowrap align=center><%= entryDate != null ? Date_formater.format(entryDate) : "" %></td>
						<td nowrap align=center><%= expsDate != null ? Date_formater.format(expsDate) : "" %></td>
						<td nowrap align=center><%=curr%></td>
						<td nowrap align=right><%= Num_formater.format(claimValue) %></td>
					</tr>
				<%
				}
				%>
				
				<tr bgcolor="#e9eee9">
					<td ></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td class="lblbold" align=right>Project Total:</td>
					<td class="lblbold" align=right><%= Num_formater.format(totalValue) %></td>
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