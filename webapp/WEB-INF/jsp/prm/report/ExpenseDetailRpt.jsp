<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="net.sf.hibernate.Session"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.core.persistence.hibernate.Hibernate2Session"%>
<%@ page import="com.aof.component.domain.party.Party"%>
<%@ page import="com.aof.component.domain.party.PartyHelper"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.util.Constants"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("EXPENSE_STATISTICS_RPT", "_VIEW", session)) {
	try{	
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String myString = df.format(Calendar.getInstance().getTime());
		StringTokenizer st=new StringTokenizer(myString,"-");
		int thisYear=Integer.parseInt(st.nextToken());
			
		NumberFormat numFormator = NumberFormat.getInstance();
		numFormator.setMaximumFractionDigits(2);
		numFormator.setMinimumFractionDigits(2);
		
		
		String year = request.getParameter("year");
		String monthStart = request.getParameter("monthStart");
		String monthEnd = request.getParameter("monthEnd");
		String expStatus = request.getParameter("expStatus");
		String deptId = request.getParameter("deptId");
		
		SQLResults summary = (SQLResults)request.getAttribute("summary");
		SQLResults detail = (SQLResults)request.getAttribute("detail");
		String mFlag = (String)request.getAttribute("mFlag");
		
		if (year == null) {
			year = "";
		}
		
		if(monthStart == null){
			monthStart = "0";
		}
		if (monthEnd == null) {
			monthEnd = "0";
		}
		if(expStatus == null){
			expStatus = "";
		}
		if(mFlag == null){
			mFlag = "";
		}
		
		List partyList_dep = null;
		Session hs = Hibernate2Session.currentSession();
		
		PartyHelper ph = new PartyHelper();
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
		if (partyList_dep == null) partyList_dep = new ArrayList();
		partyList_dep.add(0,ul.getParty());
		
		
		int ms = Integer.parseInt(monthStart);
		int me = Integer.parseInt(monthEnd);
		
		double expCompSub[] = new double[12];
		double expCustSub[] = new double[12];
		double allowCustSub[] = new double[12];
		double total[] = new double[12];
		
		double allExpCompSub = 0.0;
		double allExpCustSub = 0.0;
		double allAllowCustSub = 0.0;
		
		double allTotal = 0.0;
%>
<script language="javascript">

	function fnDetail(m) {
		
		var formObj = document.iForm;
	
		if(!checkDeciNumber2(formObj.year,1,1,'Year',-9999999999,9999999999)){
			return;
		}
		
		var s = parseInt(formObj.monthStart.value);
		var e = parseInt(formObj.monthEnd.value);
		
		if(s > e){
			alert("The end month can not be earlier than start month!");
			return;
		}
	
		formObj.formAction.value = "query";
		formObj.month.value = m;
		formObj.offSet.value = 0;
		formObj.submit();
	}
	
	function fnDetail1(start){
		
		var formObj = document.iForm;
	
		if(!checkDeciNumber2(formObj.year,1,1,'Year',-9999999999,9999999999)){
			return;
		}
		
		var s = parseInt(formObj.monthStart.value);
		var e = parseInt(formObj.monthEnd.value);
		
		if(s > e){
			alert("The end month can not be earlier than start month!");
			return;
		}
	
		formObj.formAction.value = "query";
		formObj.month.value = "<%=mFlag%>";
		formObj.offSet.value=start;
		formObj.submit();
	}

	function fnQuery() {
	
		var formObj = document.iForm;
		
		if(!checkDeciNumber2(formObj.year,1,1,'Year',-9999999999,9999999999)){
			return;
		}
		
		var s = parseInt(formObj.monthStart.value);
		var e = parseInt(formObj.monthEnd.value);
		
		if(s > e){
			alert("The end month can not be earlier than start month!");
			return;
		}
		
		formObj.formAction.value = "query";
		formObj.target = "_self";
		formObj.offSet.value = 0;
		formObj.submit();
	}

	function fnExport(){
	
		var formObj = document.iForm;
		
		if(!checkDeciNumber2(formObj.year,1,1,'Year',-9999999999,9999999999)){
			return;
		}
		
		var s = parseInt(formObj.monthStart.value);
		var e = parseInt(formObj.monthEnd.value);
		
		if(s > e){
			alert("The end month can not be earlier than start month!");
			return;
		}
		
		formObj.formAction.value = "export";
		formObj.target = "_self";
		formObj.submit();
	}

</script>

<form name="iForm" action="pas.report.ExpenseDetailRpt.do" method="post">
	
	<input type="hidden" name="formAction" id="formAction">
	<input type="hidden" name="month" id="month">
	
	<table width=1000>
		<caption class="pgheadsmall">Expense Detail Analysis Report</caption> 
		<tr>
			<td colspan=18 valign="bottom"><hr color=red></hr></td>
		</tr>
		<tr>
			
			<td class="lblbold" align="right">Year&nbsp;:&nbsp;</td>
			<td class="lblLight" align="left">
				<select name="year">
					<%
					for(int i = 5; i > 0; i--){
					%>
	       			<option value="<%=thisYear - i%>" <%=year.equals(String.valueOf(thisYear - i)) ? "selected" : ""%>><%=thisYear - i%></option>
	       			<%}%>
	       			<option value="<%=thisYear%>" <%=(year.equals("") || year == null || year.equals(String.valueOf(thisYear))) ? "selected" : ""%>><%=thisYear%></option>
	       		</select>
			</td>
			<td class="lblbold" align="right">Month&nbsp;:&nbsp;</td>
			<td class="lblLight" align="left">
				&nbsp;From&nbsp;
	       		<select name="monthStart">
	       			<%
	       			for(int i = 1; i <= 12; i++){
	       				if(monthStart.equals(String.valueOf(i))){
	       			%>
	       			<option value="<%=i%>" selected><%=i%></option>
	       			<%
	       				} else {
	       			%>
	       			<option value="<%=i%>"><%=i%></option>
	       			<%
	       				}
	       			}
	       			%>
	       		</select>
	       		&nbsp;To&nbsp;
	       		<select name="monthEnd">
	       			<%
	       			for(int i = 1; i <= 12; i++){
	       				if(monthEnd.equals(String.valueOf(i))){
	       			%>
	       			<option value="<%=i%>" selected><%=i%></option>
	       			<%
	       				} else {
	       			%>
	       			<option value="<%=i%>"><%=i%></option>
	       			<%
	       				}
	       			}
	       			%>
	       		</select>
	       	</td>
			<td class="lblbold"  align="right">Department:&nbsp;</td>
			<td class="lblbold"  align="left">
				<select name="deptId">
					<option value="">--------ALL--------</option>
				<%
					Iterator itd = partyList_dep.iterator();
					while(itd.hasNext()){
						Party p = (Party)itd.next();
						if (p.getPartyId().equals(deptId)) {%>
						<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
						<%
						} else {
						%>
						<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
						<%
						}
					}
				%>
				</select>
			</td>
	       	<td class="lblbold" align="right">By&nbsp;:&nbsp;</td>
			<td class="lblLight" align="left">
	       		<select name="expStatus">
	       			<option value="Submitted" <%=expStatus.equals("Submitted")? "selected" : ""%>>Expense Date</option>
	       			<option value="Approved" <%=expStatus.equals("Approved")? "selected" : ""%>>Approval Date</option>
	       			<option value="Claimed" <%=expStatus.equals("Claimed")? "selected" : ""%>>Claimed Date</option>
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
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<tr>
			<td>
				<table width="100%">
					<tr>
    					<td align=left colspan="40" width='100%' class="wpsPortletTopTitle">Expense Summary</td>
  					</tr>
  					<%
  					if(summary == null || summary.getRowCount() <= 0){
  					%>
  					<tr>
  						<td colspan='21' class=lblerr align='center'>No Record Found.</td>
  					</tr>
  					<%
  					} else {
  					%>
					<tr bgcolor="#e9eee9">
						<td class="lblbold" align="center" width="10%">&nbsp;</td>
						<%
						for(int i = ms; i <= me; i++ ){
							String strM = "";
							if( i == 1) strM = "Jan";
							if( i == 2) strM = "Feb";
							if( i == 3) strM = "Mar";
							if( i == 4) strM = "Apr";
							if( i == 5) strM = "May";
							if( i == 6) strM = "Jun";
							if( i == 7) strM = "Jul";
							if( i == 8) strM = "Aug";
							if( i == 9) strM = "Sep";
							if( i == 10) strM = "Oct";
							if( i == 11) strM = "Nov";
							if( i == 12) strM = "Dec";
						%>
						<td colspan="3" class="lblbold" align="center"><%=strM%></td>
						<%}%>
						<td colspan="3" class="lblbold" align="center">Total</td>
					</tr>
					<tr bgcolor="#e9eee9">
						<td class="lblbold" align=right>&nbsp;</td>
						<%
						for(int i = ms; i <= me + 1; i++ ){
						%>
						<td colspan="2" class="lblbold" align="center">Company</td>
						<td rowspan="2" class="lblbold" align="center">Customer</td>
						<%}%>
					</tr>	
					<tr bgcolor="#e9eee9">
						<td class="lblbold" align=right>&nbsp;</td>
						<%
						for(int i = ms; i <= me + 1; i++ ){
						%>
						<td class="lblbold" align="center">Total Expense by company</td>
						<td class="lblbold" align="center">Allowance by customer</td>
						<%}%>
					</tr>
					<%	
						int size = me - ms + 1;
						
						for(int row = 0; row < summary.getRowCount(); row++){
						
							double expCompTotal = 0.0;
							double expCustTotal = 0.0;
							double allowCustTotal = 0.0;
					%>
					<tr bgcolor="#e9eee9">
						<td class="lblbold" align="center"><%=summary.getString(row,"p_desc")%></td>
						<%
							for(int i = ms; i <= me; i++ ){
							
								double expComp = summary.getDouble(row,"exp_comp" + i);
								double expCust = summary.getDouble(row,"exp_cust" + i);
								double allowCust = summary.getDouble(row,"allow_cust" + i);
								
								expCompTotal += expComp;
								expCustTotal += expCust;
								allowCustTotal += allowCust;
								
								expCompSub[i-1] += expComp;
								expCustSub[i-1] += expCust;
								allowCustSub[i-1] += allowCust;
								
								total[i-1] = expCompSub[i-1] - allowCustSub[i-1];
						%>
						<td class="lblLight" align="right"><%=expComp == 0 ? "" : numFormator.format(expComp)%></td>
						<td class="lblLight" align="right"><%=allowCust == 0 ? "" : numFormator.format(allowCust)%></td>
						<td class="lblLight" align="right"><%=expCust == 0 ? "" : numFormator.format(expCust)%></td>
						<% } %>
						<td class="lblLight" align="right"><%=expCompTotal == 0 ? "" : numFormator.format(expCompTotal)%></td>
						<td class="lblLight" align="right"><%=allowCustTotal == 0 ? "" : numFormator.format(allowCustTotal)%></td>
						<td class="lblLight" align="right"><%=expCustTotal == 0 ? "" : numFormator.format(expCustTotal)%></td>
					</tr>
					<%
							allExpCompSub += expCompTotal;
							allExpCustSub += expCustTotal;
							allAllowCustSub += allowCustTotal;
						}
						allTotal = allExpCompSub - allAllowCustSub;
					%>
					<tr bgcolor="#b0c4de">
						<td class="lblbold" align="center">Subtotal</td>
						<%
						for(int i = ms; i<= me; i++){
						%>
						<td class="lblLight" align="right"><%=expCompSub[i-1] == 0 ? "" : numFormator.format(expCompSub[i-1])%></td>
						<td class="lblLight" align="right"><%=allowCustSub[i-1] == 0 ? "" : numFormator.format(allowCustSub[i-1])%></td>
						<td class="lblLight" align="right"><%=expCustSub[i-1] == 0 ? "" : numFormator.format(expCustSub[i-1])%></td>
						<%
						}
						%>
						<td class="lblLight" align="right"><%=allExpCompSub == 0 ? "" : numFormator.format(allExpCompSub)%></td>
						<td class="lblLight" align="right"><%=allAllowCustSub == 0 ? "" : numFormator.format(allAllowCustSub)%></td>
						<td class="lblLight" align="right"><%=allExpCustSub == 0 ? "" : numFormator.format(allExpCustSub)%></td>
					</tr>
					
					<tr bgcolor="#9999ff">
						<td class="lblbold" align="center" nowrap>Total Paid By Company</td>
						<%
						for(int i = ms; i<= me; i++){
						%>
						<td class="lblbold" align="center" colspan="3"><%=total[i-1] == 0 ? "" : numFormator.format(total[i-1])%></td>
						<%
						}
						%>
						<td class="lblbold" align="center" colspan="3"><%=allTotal == 0 ? "" : numFormator.format(allTotal)%></td>
					</tr>
					<%
					}
					%>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan=18 valign="bottom"><hr color=red></hr></td>
		</tr>
	</table>
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<tr>
			<td>
				<table width="100%">
					<%
					if(summary != null && summary.getRowCount() > 0){
					%>
  					<tr>
    					<td>
    						<table width="100%">
    							<tr>
    								<td>
	    								<%
	    								for(int i = ms; i <= me; i++){
	    									String strM = "";
											if( i == 1) strM = "Jan";
											if( i == 2) strM = "Feb";
											if( i == 3) strM = "Mar";
											if( i == 4) strM = "Apr";
											if( i == 5) strM = "May";
											if( i == 6) strM = "Jun";
											if( i == 7) strM = "Jul";
											if( i == 8) strM = "Aug";
											if( i == 9) strM = "Sep";
											if( i == 10) strM = "Oct";
											if( i == 11) strM = "Nov";
											if( i == 12) strM = "Dec";
	    								%>
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							<nobr>
		    							<%
			    							if (mFlag.equals(String.valueOf(i))) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px"><%=strM%></font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="fnDetail('<%=i%>');"><font size="2px"><%=strM%></font></a>
			    						<%
			    							}
			    						%>
										<font size='1px' <%=total[i-1] == 0 ? "color='red'" : ""%>>(<%=numFormator.format(total[i-1])%>)</font>
										</nobr>
										<%
										}
										%>
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    						</td>
  								</tr>
  							</table>
          				</td>
  					</tr>
  					<%}%>
  					<tr>
			    		<td>
				    		<table>
	    						<tr>
	    							<td align=left colspan="18" width='100%' class="wpsPortletTopTitle">Expense Detail</td>
  								</tr>
  								<%
  								if(detail == null || detail.getRowCount() <= 0){
  								%>
  								<input type="hidden" name="offSet" Id="offset" value="0">
  								<tr>
			  						<td colspan='21' class=lblerr align='center'>No Record Found.</td>
			  					</tr>
  								<%
  								} else {
  								
								String offSetStr = request.getParameter("offSet");
												
								int offSet = 0;
								if (offSetStr != null && offSetStr.trim().length() != 0) {
									offSet = Integer.parseInt(offSetStr);
								}
								
								int i = offSet+1;
								
								final int recordPerPage = 50;
								
								%>
								<tr align="center" bgcolor="#4682b4">
									<td align="center" class="lblbold" nowrap>&nbsp;Project Code&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Expense Form Code&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Employee&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Department&nbsp;</td>
									<td align="center" class="lblbold" nowrap>&nbsp;Total Amount&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Hotel&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Meal&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Transport&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Allowance&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Telephone&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Misc&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Currency&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Paid By&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Status&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Entry Date&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Expense Date&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Approval Date&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Claimed Date&nbsp;</td>
								</tr>
								<%
								for (int row = offSet; (row < (offSet + recordPerPage)) && (row < detail.getRowCount()); row++) {
									String color = "#e9eee9";
									if(row%2 == 1){
										color = "#b0c4de";
									}
								%>
								<tr align="center" bgcolor="<%=color%>">
									<td align="left" nowrap>&nbsp;<%=detail.getString(row,"proj_code") == null ? "" : detail.getString(row,"proj_code")%>&nbsp;</td>
									<td align="left" nowrap>&nbsp;<%=detail.getString(row,"em_code") == null ? "" : detail.getString(row,"em_code")%>&nbsp;</td>
									<td align="left" nowrap>&nbsp;<%=detail.getString(row,"employee") == null ? "" : detail.getString(row,"employee")%>&nbsp;</td>
									<td align="left" nowrap>&nbsp;<%=detail.getString(row,"p_desc") == null ? "" : detail.getString(row,"p_desc")%>&nbsp;</td>
									<td align="right" nowrap>&nbsp;<%=detail.getDouble(row,"total") == 0 ? "" : numFormator.format(detail.getDouble(row,"total"))%>&nbsp;</td>
									<td align="right" nowrap>&nbsp;<%=detail.getDouble(row,"hotel") == 0 ? "" : numFormator.format(detail.getDouble(row,"hotel"))%>&nbsp;</td>
									<td align="right" nowrap>&nbsp;<%=detail.getDouble(row,"meal") == 0 ? "" : numFormator.format(detail.getDouble(row,"meal"))%>&nbsp;</td>
									<td align="right" nowrap>&nbsp;<%=detail.getDouble(row,"trans") == 0 ? "" : numFormator.format(detail.getDouble(row,"trans"))%>&nbsp;</td>
									<td align="right" nowrap>&nbsp;<%=detail.getDouble(row,"allow") == 0 ? "" : numFormator.format(detail.getDouble(row,"allow"))%>&nbsp;</td>
									<td align="right" nowrap>&nbsp;<%=detail.getDouble(row,"tel") == 0 ? "" : numFormator.format(detail.getDouble(row,"tel"))%>&nbsp;</td>
									<td align="right" nowrap>&nbsp;<%=detail.getDouble(row,"misc") == 0 ? "" : numFormator.format(detail.getDouble(row,"misc"))%>&nbsp;</td>
									<td align="left" nowrap>&nbsp;<%=detail.getString(row,"curr") == null ? "" : detail.getString(row,"curr")%>&nbsp;</td>
									<%
										String paidBy = "";
										String tmp = detail.getString(row,"claim_type");
										if(tmp.equals("CN")){
											paidBy = "Company";
										}
										if(tmp.equals("CY")){
											paidBy = "Customer";
										}
									%>
									<td align="left" nowrap>&nbsp;<%=paidBy%>&nbsp;</td>
									<td align="left" nowrap>&nbsp;<%=detail.getString(row,"status") == null ? "" : detail.getString(row,"status")%>&nbsp;</td>
									<td align="left" nowrap>&nbsp;<%=detail.getString(row,"entry_date") == null ? "" : detail.getString(row,"entry_date")%>&nbsp;</td>
									<td align="left" nowrap>&nbsp;<%=detail.getString(row,"exp_date") == null ? "" : detail.getString(row,"exp_date")%>&nbsp;</td>
									<td align="left" nowrap>&nbsp;<%=detail.getString(row,"app_date") == null ? "" : detail.getString(row,"app_date")%>&nbsp;</td>
									<td align="left" nowrap>&nbsp;<%=detail.getString(row,"claim_date") == null ? "" : detail.getString(row,"claim_date")%>&nbsp;</td>
								</tr>
								<%	
									}
								%>
								<tr>
									<td width="1000" colspan="14" align="right" class=lblbold>Pages&nbsp;:&nbsp;
										<input type="hidden" name="offSet" Id="offset" value="<%=offSet%>">
										<%
										if (detail != null && detail.getRowCount() > 0) {
											int recordSize = detail.getRowCount();
											int l = 0;
											while ((l * recordPerPage) < recordSize) {
												if (offSet == l * recordPerPage) {
										%>
										<font size="2px">&nbsp;<%= l+1 %>&nbsp;</font>
										<%
												} else {
										%>
											&nbsp;<a href="javascript:fnDetail1(<%=l*recordPerPage%>)" title="Click here to view next set of records"><%= l+1 %></a>&nbsp;
										<%
												}
												l++;
											}
										}
										%>
									</td>
									<td colspan="4" align="right" class=lblbold>&nbsp;
									</td>
								</tr>
  								<%
  								}
  								%>
  							</table>
			          	</td>
			  		</tr>
  				</table>
  			</td>
  		</tr>
  	</table>
</form>
<%
	} catch(Exception e) {
		e.printStackTrace();
	}
}else{
	out.println("没有访问权限.");
}
%>