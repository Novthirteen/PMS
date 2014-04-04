<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="net.sf.hibernate.Session"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.core.persistence.hibernate.Hibernate2Session"%>
<%@ page import="com.aof.component.domain.party.Party"%>
<%@ page import="com.aof.component.domain.party.PartyHelper"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.util.UtilDateTime"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("PRESALE_UPDATE_RPT", "_VIEW", session)) {
	try{
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	
		NumberFormat numFormator = NumberFormat.getInstance();
		numFormator.setMaximumFractionDigits(0);
		numFormator.setMinimumFractionDigits(0);
	
		String year = request.getParameter("year");
		String week = request.getParameter("week");
		String deptId = request.getParameter("deptId");
		String tcvRange = request.getParameter("tcvRange");
		String status = request.getParameter("status");
		String col = request.getParameter("col");
		
		SQLResults statusResult = (SQLResults)request.getAttribute("statusResult");
		SQLResults detailResult = (SQLResults)request.getAttribute("detailResult");
		List deptList = (List)request.getAttribute("deptList");
				
		Calendar c = Calendar.getInstance();
		int thisYear = c.get(Calendar.YEAR);
		int thisweek = c.get(Calendar.WEEK_OF_YEAR);
		
		if(year == null || year.equals("")){
			year = String.valueOf(c.get(Calendar.YEAR));
		}
		
		if(week == null || week.equals("")){
			week = String.valueOf(c.get(Calendar.WEEK_OF_YEAR));
		}
		
		if(status == null){
			status = "";
		}
		
		if(col == null){
			col = "Q1";
		}
		
		if(tcvRange == null){
			tcvRange = "";
		}

		Date dayYearStart1 = UtilDateTime.toDate("1", "1", year, "0", "0", "0");
		Date dayYearStart2 = UtilDateTime.getThisWeekDay(dayYearStart1, 1);
		Date dayYearEnd1 = UtilDateTime.toDate("12", "31", year, "0", "0", "0");
		Date dayYearEnd2 = UtilDateTime.getThisWeekDay(dayYearEnd1, 7);
		String DisplayText = "";
		int weeksInYear = (int)UtilDateTime.getDayDistance(dayYearEnd2,dayYearStart2)/7;
		String strWeeksInYear = String.valueOf(weeksInYear);
%>

<script language="javascript">

	function fnDetail(m) {
		var formObj = document.iForm;
		formObj.col.value = m;
		formObj.formAction.value = "query";
		formObj.submit();
	}

	function fnQuery() {
		var formObj = document.iForm;
		formObj.formAction.value = "query";
		formObj.target = "_self";
		formObj.submit();
	}

	function fnExport(){
		var formObj = document.iForm;
		formObj.formAction.value = "export";
		formObj.target = "_self";
		formObj.submit();
	}

</script>

<form name="iForm" action="pas.report.APWeeklyRpt.do" method="post">
	
	<input type="hidden" name="formAction" id="formAction">
	<input type="hidden" name="col" id="col" value="<%=col%>">
	
	<table width=1000>
		<caption class="pgheadsmall">AP Weekly Report</caption> 
		<tr>
			<td colspan=18 valign="bottom"><hr color=red></hr></td>
		</tr>
		<tr>
			
			<td class="lblbold" align="right">Year&nbsp;:&nbsp;</td>
			<td class="lblLight" align="left">
				<select name="year">
					<%
					for(int i = 3; i > 0; i--){
					%>
	       			<option value="<%=thisYear - i%>" <%=year.equals(String.valueOf(thisYear - i)) ? "selected" : ""%>><%=thisYear - i%></option>
	       			<%}%>
	       			<option value="<%=thisYear%>" <%=(year.equals("") || year == null || year.equals(String.valueOf(thisYear))) ? "selected" : ""%>><%=thisYear%></option>
	       			<option value="<%=thisYear + 1%>" <%=year.equals(String.valueOf(thisYear + 1)) ? "selected" : ""%>><%=thisYear + 1%></option>
	       		</select>
			</td>
			<td class="lblbold" align="right">Week&nbsp;:&nbsp;</td>
			<td class="lblLight" align="left">
	       		<select name="week">
	       			<%
	       			for(int i = 1; i <= 53; i++){
	       				if(week.equals(String.valueOf(i))){
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
					Iterator itd = deptList.iterator();
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
		</tr>
		<tr>
	       	<td class="lblbold" align="right">TCV Range:&nbsp;</td>
			<td class="lblLight" align="left">
	       		<select name="tcvRange">
	       			<option value="">-----ALL-----</option>
	       			<option value="300000" <%=tcvRange.equals("300000") ? "selected" : ""%>>300,000</option>
	       			<option value="500000" <%=tcvRange.equals("500000") ? "selected" : ""%>>500,000</option>
	       			<option value="1000000" <%=tcvRange.equals("1000000") ? "selected" : ""%>>1,000,000</option>
	       		</select>
	       	</td>
	       	<td class="lblbold" align="right">Status:&nbsp;</td>
			<td class="lblLight" align="left">
	       		<select name="status">
	       			<option value="">------ALL------</option>
	       			<option value="Lost/Drop" <%=status.equalsIgnoreCase("Lost/Drop") ? "selected" : ""%>>Lost/Drop</option>
	       			<option value="Won" <%=status.equalsIgnoreCase("Won") ? "selected" : ""%>>Won</option>
	       			<option value="wol" <%=status.equalsIgnoreCase("wol") ? "selected" : ""%>>Won or Lost/Drop</option>
	       			<option value="Active" <%=status.equalsIgnoreCase("Active") ? "selected" : ""%>>Active</option>
	       			<option value="Suspect" <%=status.equalsIgnoreCase("Suspect") ? "selected" : ""%>>Suspect</option>
	       			<option value="Pending" <%=status.equalsIgnoreCase("Pending") ? "selected" : ""%>>Pending</option>
	       			<option value="Offer" <%=status.equalsIgnoreCase("offer") ? "selected" : ""%>>Offer</option>
					<option value="Prefer Supplier" <%=status.equalsIgnoreCase("prefer supplier") ? "selected" : ""%>>Prefer Supplier</option>
					<option value="abl" <%=status.equalsIgnoreCase("abl") ? "selected" : ""%>>All But Lost/Drop</option>
	       		</select>
	       	</td>
	       	<td></td><td></td>
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
    					<td align=left colspan="40" width='100%' class="wpsPortletTopTitle">Bid Status Change Report</td>
  					</tr>
  					<%
  					if(statusResult == null || statusResult.getRowCount() <= 0){
  					%>
  					<tr>
  						<td colspan='21' class=lblerr align='center'>No Record Found.</td>
  					</tr>
  					<%
  					} else {
  					%>
					<tr align="center" bgcolor="#4682b4">
						<td align="center" class="lblbold" nowrap>&nbsp;Customer&nbsp;</td>
						<td align="center" class="lblbold">&nbsp;Bid Name&nbsp;</td>
						<td align="center" class="lblbold">&nbsp;Lead Sales&nbsp;</td>
						<td align="center" class="lblbold">&nbsp;Department&nbsp;</td>
						<td align="center" class="lblbold" nowrap>&nbsp;TCV (Euro'K)&nbsp;</td>
						<td align="center" class="lblbold">&nbsp;<%=year%> Rev(Euro'K)&nbsp;</td>
						<td align="center" class="lblbold">&nbsp;Status&nbsp;</td>
						<td align="center" class="lblbold">&nbsp;Remarks / Help Needed&nbsp;</td>
					</tr>
						<%
						double totalTCV = 0.0;
						double totalRev = 0.0;
						for (int row = 0; row < statusResult.getRowCount(); row++) {
							String color = "#e9eee9";
							if(row%2 == 1){
								color = "#b0c4de";
							}
							
							int tmpTcv = (int) Math.round(statusResult.getDouble(row, "rev_value") / 10000);
							int tmpRev = (int) Math.round(statusResult.getDouble(row, "rev_value") / 10000);
							
							totalTCV += tmpTcv;
							totalRev += tmpRev;
						%>
					<tr align="center" bgcolor="<%=color%>">
						<td align="left">&nbsp;<%=statusResult.getString(row,"cust_desc") == null ? "" : statusResult.getString(row,"cust_desc")%>&nbsp;</td>
						<td align="left">&nbsp;<%=statusResult.getString(row,"bid_desc") == null ? "" : statusResult.getString(row,"bid_desc")%>&nbsp;</td>
						<td align="left" nowrap>&nbsp;<%=statusResult.getString(row,"sales") == null ? "" : statusResult.getString(row,"sales")%>&nbsp;</td>
						<td align="left" nowrap>&nbsp;<%=statusResult.getString(row,"dept_desc") == null ? "" : statusResult.getString(row,"dept_desc")%>&nbsp;</td>
						<td align="right" nowrap>&nbsp;<%=numFormator.format(tmpTcv)%>&nbsp;</td>
						<td align="right" nowrap>&nbsp;<%=numFormator.format(tmpRev)%>&nbsp;</td>
						<td align="center" nowrap>&nbsp;<%=statusResult.getString(row,"status") == null ? "" : statusResult.getString(row,"status")%>&nbsp;</td>
						<td align="left">&nbsp;<%=statusResult.getString(row,"reason") == null ? "" : statusResult.getString(row,"reason")%>&nbsp;</td>
					</tr>
					<%
						}
					%>
					<tr bgcolor="#9999ff" height="20">
						<td class="lblbold" align="right" colspan="4" nowrap>Total:&nbsp;</td>
						<td class="lblbold" align="right"><%=numFormator.format(totalTCV)%></td>
						<td class="lblbold" align="right"><%=numFormator.format(totalRev)%></td>
						<td class="lblbold" align="center" colspan="2" nowrap></td>
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
					
  					<tr>
    					<td>
    						<table width="100%">
    							<tr>
    								<td>
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							
		    							<nobr>
		    							<%
			    							if (col.equals("Q1")) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px">Quarter 1</font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="fnDetail('Q1');"><font size="2px">Quarter 1</font></a>
			    						<%
			    							}
			    						%>
										</nobr>
										
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							
		    							<nobr>
		    							<%
			    							if (col.equals("Q2")) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px">Quarter 2</font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="fnDetail('Q2');"><font size="2px">Quarter 2</font></a>
			    						<%
			    							}
			    						%>
										</nobr>
																				
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							
		    							<nobr>
		    							<%
			    							if (col.equals("Q3")) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px">Quarter 3</font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="fnDetail('Q3');"><font size="2px">Quarter 3</font></a>
			    						<%
			    							}
			    						%>
										</nobr>
																				
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							
		    							<nobr>
		    							<%
			    							if (col.equals("Q4")) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px">Quarter 4</font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="fnDetail('Q4');"><font size="2px">Quarter 4</font></a>
			    						<%
			    							}
			    						%>
										</nobr>
										
										<span style="color:#999999">&nbsp;|&nbsp;</span>
		    						</td>
  								</tr>
  							</table>
          				</td>
  					</tr>
  					
  					<tr>
			    		<td>
				    		<table>
	    						<tr>
	    							<td align=left colspan="18" width='100%' class="wpsPortletTopTitle">Bid Master Details</td>
  								</tr>
  								<%
  								if(detailResult == null || detailResult.getRowCount() <= 0){
  								%>
  								<input type="hidden" name="offSet" Id="offset" value="0">
  								<tr>
			  						<td colspan='21' class=lblerr align='center'>No Record Found.</td>
			  					</tr>
  								<%
  								} else {
								%>
								<tr align="center" bgcolor="#4682b4">
									<td align="center" class="lblbold" nowrap>&nbsp;Customer&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Bid Name&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Lead Sales&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Department&nbsp;</td>
									<td align="center" class="lblbold" nowrap>&nbsp;TCV (Euro'K)&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;<%=year%> Rev (Euro'K)&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Status&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Actions To Close / Help Needed&nbsp;</td>
									<td align="center" class="lblbold">&nbsp;Forcast Date&nbsp;</td>
								</tr>
								<%
								double detailTotalTCV = 0.0;
								double detailTotalRev = 0.0;
								for (int row = 0; row < detailResult.getRowCount(); row++) {
									String color = "#e9eee9";
									if(row%2 == 1){
										color = "#b0c4de";
									}
									
									int tmpDetailTcv = (int) Math.round(detailResult.getDouble(row, "tcv_value") / 10000);
									int tmpDetailRev = (int) Math.round(detailResult.getDouble(row, "rev_value") / 10000);
																		
									detailTotalTCV += tmpDetailTcv;
									detailTotalRev += tmpDetailRev;
									
								%>
								<tr align="center" bgcolor="<%=color%>">
									<td align="left">&nbsp;<%=detailResult.getString(row,"cust_desc") == null ? "" : detailResult.getString(row,"cust_desc")%>&nbsp;</td>
									<td align="left">&nbsp;<%=detailResult.getString(row,"bid_desc") == null ? "" : detailResult.getString(row,"bid_desc")%>&nbsp;</td>
									<td align="left" nowrap>&nbsp;<%=detailResult.getString(row,"sales") == null ? "" : detailResult.getString(row,"sales")%>&nbsp;</td>
									<td align="left">&nbsp;<%=detailResult.getString(row,"dept_desc") == null ? "" : detailResult.getString(row,"dept_desc")%>&nbsp;</td>
									<td align="right" nowrap>&nbsp;<%=numFormator.format(tmpDetailTcv)%>&nbsp;</td>
									<td align="right" nowrap>&nbsp;<%=numFormator.format(tmpDetailRev)%>&nbsp;</td>
									<td align="center" nowrap>&nbsp;<%=detailResult.getString(row,"status") == null ? "" : detailResult.getString(row,"status")%>&nbsp;</td>
									<td align="center" nowrap>&nbsp;</td>
									<td align="center" nowrap>&nbsp;<%=detailResult.getDate(row,"forcast_date") == null ? "" : df.format(detailResult.getDate(row,"forcast_date"))%>&nbsp;</td>
								</tr>
								<%	
									}
								%>
								<tr bgcolor="#9999ff" height="30">
									<td class="lblbold" align="right" colspan="4" nowrap>Total:&nbsp;</td>
									<td class="lblbold" align="right"><%=numFormator.format(detailTotalTCV)%></td>
									<td class="lblbold" align="right"><%=numFormator.format(detailTotalRev)%></td>
									<td class="lblbold" align="center" colspan="3" nowrap></td>
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