<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{
	Log log = LogFactory.getLog("findStepGroup.jsp");
	long timeStart = System.currentTimeMillis();   //for performance test
	
	if (AOFSECURITY.hasEntityPermission("PROJ_PRESALE", "_CREATE", session)) {
	
		String qryDepartmentId = request.getParameter("qryDepartmentId");
		String qryDisableFlg = request.getParameter("qryDisableFlg");
		String status = request.getParameter("status");
		String description = request.getParameter("desc");
		String custdesc = request.getParameter("pros");
		String bno = request.getParameter("bno");
		NumberFormat numFormater = NumberFormat.getInstance();
		numFormater.setMaximumFractionDigits(0);
		numFormater.setMinimumFractionDigits(0);
		
		if(description == null)description="";
		if(status == null)status="";
		if(custdesc == null) custdesc = "";
		if(bno == null) bno = "";
		
		SQLResults result = (SQLResults)request.getAttribute("QryList");
		
		List partyList = (List)request.getAttribute("PartyList");
		
		String offSetStr = request.getParameter("offSet");
		int offSet = 0;
		if (offSetStr != null && offSetStr.trim().length() != 0) {
			offSet = Integer.parseInt(offSetStr);
		}
		
		request.setAttribute("offSet", offSetStr);
		
		int i = offSet+1;
		
		final int recordPerPage = 10;
%>
<HTML>
	<HEAD>
	
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		
		<script language="javascript">
		function doSelect() {
			var contracts = document.getElementsByName("contract");
			for (var i = 0; i < contracts.length; i++) {
				if (contracts[i].checked) {
					window.parent.returnValue = document.getElementsByName("bidMasterId")[i].value + "|" +
												document.getElementsByName("description2")[i].value + "|" +
												document.getElementsByName("salePersonId")[i].value + "|" +
												document.getElementsByName("salesPersonName")[i].value + "|" +
												document.getElementsByName("estimateAmount")[i].value + "|" +
												document.getElementsByName("exchangeRate")[i].value + "|" +
												document.getElementsByName("startDate")[i].value + "|" +
												document.getElementsByName("endDate")[i].value + "|" +
												document.getElementsByName("currencyId")[i].value + "|" +
												document.getElementsByName("departmentId")[i].value + "|" +
												document.getElementsByName("no")[i].value + "|" +
												document.getElementsByName("currency")[i].value + "|" +
												document.getElementsByName("prospectCompany")[i].value + "|" +
												document.getElementsByName("contrType")[i].value + "|" +
												document.getElementsByName("bidStatus")[i].value + "|" +
												document.getElementsByName("department")[i].value + "|" +
												document.getElementsByName("secondSalesId")[i].value + "|" +
												document.getElementsByName("secondSalesName")[i].value + "|" +
												document.getElementsByName("prospectCompanyId")[i].value;
					window.parent.close();
				}
			}
		}
		
		function fnSubmit1(start) {
			with (document.queryForm) {
				offSet.value=start;
				submit();
			}
		}
					
		</script>
	</HEAD>

	<BODY>
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<CAPTION align=center class=pgheadsmall>Bid Master List</CAPTION>
	<tr>
		<td>
			<form name="queryForm" action="ListSalesBid.do" method="post">
				<input type="hidden" name="formAction" value="dialogView">
				<TABLE width="100%">
					
					<tr>
						<td colspan=6><hr color=red></hr></td>
					</tr>
					<tr>
						<td align="right">
          					<span class="lblbold">Bid No. :&nbsp;</span>
       	 				</td>
        				<td>
						<input type="text" class="inputBox" name="bno" value="<%=bno%>" size="30" />
        				</td>
						<td align="right">
          					<span class="lblbold">Bid Desprition:&nbsp;</span>
       	 				</td>
        				<td>
						<input type="text" class="inputBox" name="desc" value="<%=description%>" size="30" />
        				</td>
						<td class="lblbold">Sales Status:</td>
					    <td class="lblLight">
					    <select name="status">
							 <option value="" >ALL</option>
						    <option value="Lost/Drop" <%if (status.equalsIgnoreCase("lost/drop")) out.println("selected");%>>Lost/Drop</option>
							<option value="Suspect" <%if (status.equalsIgnoreCase("suspect")) out.println("selected");%>>Suspect</option>
							<option value="Pending" <%if (status.equalsIgnoreCase("pending")) out.println("selected");%>>Pending</option>								
							<option value="Active" <%if (status.equalsIgnoreCase("active")) out.println("selected");%>>Active</option>
							<option value="Offer" <%if (status.equalsIgnoreCase("offer")) out.println("selected");%>>Offer</option>
							<option value="Prefer Supplier" <%if (status.equalsIgnoreCase("prefer supplier")) out.println("selected");%>>Prefer Supplier</option>	
							<option value="Won" <%if (status.equalsIgnoreCase("won")) out.println("selected");%>>Won</option>														
							<option value="abl" <%if (status.equalsIgnoreCase("abl")) out.println("selected");%>>ALL But Lost/Drop</option>
						</select>
	     				</td>
	     			</tr>
	     			<tr>
	     			<td class="lblbold" align="right">Customer:</td>
	     			<td class="lblLight">
	     			<input type="text" name="pros" size="30" value="<%=custdesc%>" class="inputbox">
	     			</td>
					<td class="lblbold">Department:</td>
					<td class="lblLight">
							<select name="qryDepartmentId">
							<option value="self">All Related To You</option>
							<%
							if (AOFSECURITY.hasEntityPermission("PROJ_PRESALE", "_ALL", session)) {
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if (p.getPartyId().equals(qryDepartmentId)) {
							%>
									<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%
									} else {
							%>
									<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%
									}
								}
							}
							%>
							</select>
						</td>
	     				<td colspan=2/>
					</tr>
					<tr>
					<td colspan=4/>
					   	<td colspan=2 align="middle">
							<input type="submit" value="Query" class="button">
						</td>
					
					</tr>
					<tr>
						<td colspan=6 valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td>
				<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
  					<TR bgcolor="#e9eee9">
					  	<td align="center"  class="lblbold">#&nbsp;</td>
					  	<td align="left" class="lblbold">bid No.</td>
					  	<td align="left" class="lblbold">Description</td>
					  	<td align="left" class="lblbold">Department</td>
						<td align="left" class="lblbold">ProspectCompany</td>
						<td align="left" class="lblbold">Status</td>
					</TR>
					<%
						//int count = 0;
						if (result != null && result.getRowCount() > 0) {
							for(int row = offSet; (row < (offSet + recordPerPage)) && (row < result.getRowCount()); row++){
						
					%>
		  			<tr bgcolor="#e9eee9"> 
		  				<td align="center">
		  					<input type="radio" class="radiostyle" name="contract" value="<%=i++%>">
		  				</td>
		  				<td><%=result.getString(row,"bid_no")%></td>
		  				<td><%=result.getString(row,"bid_description") == null ? "" : result.getString(row,"bid_description")%></td>
		  				<td align="left"><%=result.getString(row,"dep")%></td>
	  					<td align="left"><%=result.getString(row,"custId")%>:<%=result.getString(row,"prospect")%></td>
	  					<td align="left"><%=result.getString(row,"bid_status")%></td>
	  				</tr>
  					<input type="hidden" name="bidMasterId" value="<%=numFormater.format(result.getDouble(row,"id"))%>">
  					<input type="hidden" name="description2" value="<%=result.getString(row,"bid_description")%>">
  					<input type="hidden" name="salePersonId" value="<%=result.getString(row,"sales_id") == null ? "" : result.getString(row,"sales_id")%>">
  					<input type="hidden" name="salesPersonName" value="<%=result.getString(row,"sales") == null ? "" : result.getString(row,"sales")%>">
  					<input type="hidden" name="estimateAmount" value="<%=result.getString(row,"bid_est_amt") == null ? "" : result.getString(row,"bid_est_amt")%>" >
  					<input type="hidden" name="exchangeRate"  value="<%=String.valueOf(result.getDouble(row,"exchange_rate")) %>">
  					<input type="hidden" name="startDate" value="<%=result.getString(row,"start_date") == null ? "" : result.getString(row,"start_date")%>">
		  			<input type="hidden" name="endDate" value="<%=result.getString(row,"end_date") == null ? "" : result.getString(row,"end_date")%>">
		  			<input type="hidden" name="currencyId" value="<%=result.getString(row,"currency_id") == null ? "" : result.getString(row,"currency_id")%>">
		  			<input type="hidden" name="departmentId" value="<%=result.getString(row,"dep_id") == null ? "" : result.getString(row,"dep_id")%>">
  					<input type="hidden" name="no" value="<%=result.getString(row,"bid_no") == null ? "" : result.getString(row,"bid_no")%>">
  					<input type="hidden" name="currency" value="<%=result.getString(row,"currency_name") == null ? "" : result.getString(row,"currency_name")%>">
  					<input type="hidden" name="prospectCompanyId" value="<%=result.getString(row,"custId") == null ? "" : result.getString(row,"custId")%>">
  					<input type="hidden" name="prospectCompany" value="<%=result.getString(row,"prospect") == null ? "" : result.getString(row,"prospect")%>">
  					<input type="hidden" name="secondSalesId" value="<%=result.getString(row,"second_sales_id") == null ? "" : result.getString(row,"second_sales_id")%>">
  					<input type="hidden" name="secondSalesName" value="<%=result.getString(row,"second_sales") == null ? "" : result.getString(row,"second_sales")%>">
  					<%
  						String contractType = "";
  						String contrType = "";
  						String tmpType = result.getString(row,"contract_type");
  						if( tmpType != null){
  							contrType = tmpType;
  							if(tmpType.equals("FP")){
  								contractType = "Fixed Price";
  							}
  							if(tmpType.equals("TM")){
  								contractType = "Time & Material";
  							}
  						}
  					%>
  					<input type="hidden" name="contractType" value="<%=contractType%>">
  					<input type="hidden" name="contrType" value="<%=contrType%>">
  					<input type="hidden" name="bidStatus" value="<%=result.getString(row,"bid_status")%>">
  					<input type="hidden" name="department" value="<%=result.getString(row,"dep")%>">
	  				<%
	  				}
	  				%>
	  				<tr>
	  					<td align="left" class="lblerr" colspan="2">
	  						<input type="button" class="button" name="select" value="Select" onclick="doSelect();">
						</td>
						<td width="100%" colspan="4" align="right" class=lblbold>Pages&nbsp;:&nbsp;
							<input type=hidden name="offSet" value="<%=offSet%>">
							<%
							int RecordSize = result.getRowCount();
							int l = 0;
							while ((l * recordPerPage) < RecordSize) {
								if (offSet == l * recordPerPage) {
							%>
							&nbsp;<%= l+1 %>&nbsp;
							<%
								} else {
							%>
							&nbsp;<a href="javascript:fnSubmit1(<%=l*recordPerPage%>)" title="Click here to view next set of records"><%= l+1 %></a>&nbsp;
							<%
								}
								l++;
							}
							%>
						</td>
					</tr>
					<%
					} else {
					%>
	  				<tr bgcolor="#e9eee9">
				    	<td align="center" class="lblerr" colspan="6">
				    		No Record Found.
				    	</td>
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
	}else{
		out.println("!!你没有相关访问权限!!");
	}
}catch(Exception e){
	e.printStackTrace();
}
%>