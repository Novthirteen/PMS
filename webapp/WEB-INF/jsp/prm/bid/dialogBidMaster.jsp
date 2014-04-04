<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>


<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
ProjectHelper projHelper = new ProjectHelper();
List currencyList = projHelper.getAllCurrency(hs);
if(currencyList==null){
	currencyList = new ArrayList();
}
Iterator itCurr = currencyList.iterator();
String rateStr = "";
while(itCurr.hasNext()){
	com.aof.component.prm.project.CurrencyType curr = (com.aof.component.prm.project.CurrencyType)itCurr.next();
	rateStr = rateStr+curr.getCurrRate().toString()+"$";
}
try{
    NumberFormat Num_formater = NumberFormat.getInstance();
    Num_formater.setMaximumFractionDigits(2);
	Num_formater.setMinimumFractionDigits(2);
	NumberFormat Num_formater2 = NumberFormat.getInstance();
	Num_formater2.setMaximumFractionDigits(5);
	Num_formater2.setMinimumFractionDigits(2);
	SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
	
	BidMaster bidMaster = (BidMaster)request.getAttribute("BidMaster");
	List partyList = (List)request.getAttribute("PartyList");
	List slList = (List)request.getAttribute("slList");
	if(slList == null) slList = new ArrayList();
	
	String dept = (String)request.getAttribute("dept");
	String offSet = "";
	if((String)request.getAttribute("offSet") != null){
		offSet = (String)request.getAttribute("offSet");
	}
	
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	
	CurrencyType currency = null;
	String startDateStr = "";
	String endDateStr = "";
	String postDateStr = "";
	String expectedEndDate="";
	String createDateStr = "";
	String estimateAmountStr = "";
	String exchangeRateStr = "";
	String description = "";
	String status = "";
	String departmentId = "";
	String currencyId = "";
	
	String id = null;
	String no = "";
	String contractType = "";
		
	if (bidMaster!=null){
    	no = bidMaster.getNo();
    	contractType = bidMaster.getContractType();
    	currency = bidMaster.getCurrency();
    	description = bidMaster.getDescription();

    	id = bidMaster.getId() + "";
    	if(bidMaster.getDepartment() != null){
    		departmentId = bidMaster.getDepartment().getPartyId() + "";
    	}
    	if(bidMaster.getCurrency() != null){
    		currencyId = bidMaster.getCurrency().getCurrId() + "";
    	}
		java.util.Date startdate = bidMaster.getEstimateStartDate();
		if(startdate!=null){
	    	startDateStr=formater.format(startdate);
	    }
	    
		java.util.Date endDate = bidMaster.getEstimateEndDate();
		if(endDate!=null){
	    	endDateStr=formater.format(endDate);
		}
		
		java.util.Date createDate = bidMaster.getCreateDate();
		if(createDate!=null){
	    	createDateStr=formater.format(createDate);
		}
		
		java.util.Date postDate = bidMaster.getPostDate();
		if(postDate!=null){
	    	postDateStr=formater.format(postDate);
		}
		java.util.Date expectedDate = bidMaster.getExpectedEndDate();
		if(expectedDate!=null){
	    	expectedEndDate=formater.format(expectedDate);
		}
		if(bidMaster.getEstimateAmount()!=null){
			estimateAmountStr = Num_formater.format(bidMaster.getEstimateAmount());
		}
		if(bidMaster.getExchangeRate()!=null){
			exchangeRateStr = Num_formater.format(bidMaster.getExchangeRate());
		}
		if(bidMaster.getDescription()!=null){
			description = bidMaster.getDescription();
		}
		if(bidMaster.getStatus()!=null){
			status = bidMaster.getStatus();
		}
			
	}
	String action = request.getParameter("formAction");
	if(action == null){
		action = "update";
	}

	String column = request.getParameter("column");
	if (column == null || column.equals("")) {
		column = "Prospect";
	}
%>
<script language="javascript">
		function changeColumn(column) {
		document.EditForm.formAction.value = "view";
		document.EditForm.column.value = column;
		document.EditForm.submit();
	}
	
</script>
<form action="dialogBidMaster.do" method="post" name="EditForm">
	<IFRAME
		frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize
		scrolling=no src="includes/date/calendar.htm"
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
	<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id = "<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">

	<table width=100% cellpadding="1" border="0" cellspacing="1">	
		<tr>
			<td align=left width='90%' class="wpsPortletTopTitle" colspan=6>Bid Master Maintenance</td>
		</tr>
		<tr>
			<td width='100%'>
				<input type="hidden" name="formAction" id = "formAction" value="">
				<input type="hidden" name="id" id = "id" value="<%=id != null ? id : ""%>">
				<input type="hidden" name="offSet" id = "offSet" value="<%=offSet%>">
				<input type="hidden" name="column" id = "column" value="<%=column%>">
				
				<table width='100%' border='0' cellspacing='2' cellpadding='0'>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Bid No.:&nbsp;</span></td>
						<td colspan=2><%=no%></td>
						<td align="right" class="lblbold"><span class="tabletext">Bid Description:&nbsp;</span></td>
						<td colspan=2><%=description%></td>
					</tr>
					<tr>
						<td align="right" class="lblbold">Department:&nbsp;</td>
						<td class="lblLight" colspan=2><%=bidMaster.getDepartment().getDescription()%>
						</td>
						<td align="right" class="lblbold"><span class="tabletext">Presale PM:&nbsp;</span></td>
						<td align="left" colspan=2><%=bidMaster.getPresalePM().getName()%>
						</td>	
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Sales Person:&nbsp;</span></td>
						<td align="left" colspan=2>
							<%
							if(bidMaster != null){
								if (bidMaster.getSalesPerson() != null) {
//									spId = bidMaster.getSalesPerson().getUserLoginId();
									out.print(bidMaster.getSalesPerson().getName());
								}
							}
							%>
						</td>
						<td align="right" class="lblbold"><span class="tabletext">Secondary Sales Person:&nbsp;</span></td>
						<td align="left" colspan=2>
							<%
							if(bidMaster != null){
								if (bidMaster.getSecondarySalesPerson()!= null) {
//									spId2= bidMaster.getSecondarySalesPerson().getUserLoginId();
									out.print(bidMaster.getSecondarySalesPerson().getName());
								}
							}
							%>
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Currency:&nbsp;</span></td>
						<td colspan=2><%=bidMaster.getCurrency().getCurrName()%>
						</td>
						<td align="right" class="lblbold">
          					<span class="tabletext">Total Contract Value:&nbsp;</span>
       	 				</td>
        				<td colspan=2><%=estimateAmountStr%></td>
					</tr>
					<tr>		
						<td align="right" class="lblbold">
          					<span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
       	 				</td>
        				<td colspan=2><%if(exchangeRateStr !=null) out.print(exchangeRateStr); %>
						</td>
						<td align="right" class="lblbold">
          					<span class="tabletext">Total Contract Value(RMB):&nbsp;</span>
       	 				</td>
        				<td colspan=2><%=bidMaster!=null?Num_formater.format(bidMaster.getEstimateAmount().doubleValue()*bidMaster.getExchangeRate().floatValue()):""%>
        				</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
          					<span class="tabletext">Estimated Start Date:&nbsp;</span>
       	 				</td>
        				<td colspan=2>
        				<%
        				if(startDateStr!=null && startDateStr.length()>0){
        				%>
						    <%=startDateStr%>
          				<%
          				}
          				%>
						</td>
						<td align="right" class="lblbold">
          					<span class="tabletext">Contract Type:</span>
       	 				</td>
						<td colspan=2 align="left">
							<%if(contractType.equals("FP")){out.print("Fixed Price");}
							else
							{out.print("Time & Material");}
							%>
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
          					<span class="tabletext">Estimated End Date:&nbsp;</span>
       	 				</td>
        				<td colspan=2>
        				<input type="hidden" name="hid_estimateEndDate" id = "hid_estimateEndDate" value="no">
        				<%
        				if(endDateStr!=null && endDateStr.length()>0){
        				%><%=endDateStr%>
          				<% }%>
						</td>
						<td align="right" class="lblbold"><span class="tabletext">Status:&nbsp;</span></td>
						<td align="left" colspan=2><%=bidMaster.getStatus()%></td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
          					<span class="tabletext">Expected Sign Date:</span>
       	 				</td>
        				<td colspan=2>
        				<%
        				if(expectedEndDate!=null && expectedEndDate.length()>0){
        				out.print(expectedEndDate);
          				}
          				%>	
						</td>
						<td align="right" class="lblbold">
          					<span class="tabletext">Bid Current WIN %:</span>
       	 				</td>       	 				
						<td  colspan=2><%=bidMaster.getCurrentStep().getPercentage().intValue()%>%</td>
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Bid Create Date:</span></td>
        				<%
        				if(createDateStr!=null && createDateStr.length()>0){
        				%>
        				<td  colspan=2><%=createDateStr%></td>
          				<%
          				}
          				%>
						<td colspan="3" align="right">
							<input type="button" value="Close" class="button" onclick="window.close()"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<table width=100%><tr><td><hr color=red></hr></td></tr></table>
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<tr>
			<td>
				<table width=100% cellpadding="1" border="0" cellspacing="1">
					<tr><td class="lblLight">
						<span style="color:#999999">&nbsp;|&nbsp;</span>
						<nobr>
						<%
						if (column.equals("Prospect")) {
						%>
							<span style="color:#1E90FF"><font size="4px">Prospect Company Details</font></span>
						<%	
						} else {
						%>
							<a href="#" onclick="changeColumn('Prospect');"><font size="2px">Prospect Company Details</font></a>
						<%
						}
						%>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
						<nobr>
						<%
						if (column.equals("Unweighted")) {
						%>
							<span style="color:#1E90FF"><font size="4px">Unweighted Value List</font></span>
						<%	
						} else {
						%>
							<a href="#" onclick="changeColumn('Unweighted');"><font size="2px">Unweighted Value List</font></a>
						<%
						}
						%>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
						<nobr>
						<%
						if (column.equals("Contact")) {
						%>
							<span style="color:#1E90FF"><font size="4px">Contact List</font></span>
						<%	
						} else {
						%>
							<a href="#" onclick="changeColumn('Contact');"><font size="2px">Contact List</font></a>
						<%
						}
						%>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
						<nobr>
						<%
						if (column.equals("Activity")) {
						%>
							<span style="color:#1E90FF"><font size="4px">Sales Phases Tracking</font></span>
						<%	
						} else {
						%>
							<a href="#" onclick="changeColumn('Activity');"><font size="2px">Sales Phases Tracking</font></a>		
						<%
						}
						%>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
						<nobr>
						<%
						if (column.equals("History")) {
						%>
							<span style="color:#1E90FF"><font size="4px">Bid Master History</font></span>
						<%	
						} else {
						%>
							<a href="#" onclick="changeColumn('History');"><font size="2px">Bid Master History</font></a>
						<%
						}
						%>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
					</td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%">
					<tr><td>
					<%
					if (column.equals("Prospect")) {
					%>
						<jsp:include page="dialogprospect.jsp"/>
					<%
					}
					if (column.equals("Unweighted")) {
					%>
						<jsp:include page="dialogunweighted.jsp"/>
					<%
					}
					if (column.equals("Contact")) {
					%>
						<jsp:include page="dialogcontact.jsp"/>
					<%
					}
					if (column.equals("Activity")) {
					%>
						<jsp:include page="dialogactivity.jsp"/>
					<%
					}
					if (column.equals("History")) {
					%>
						<jsp:include page="dialoghistory.jsp"/>
					<%
					}
					%>
					</td></tr>
				</table>
			</td>
		</tr>
	</table>
</form>

<%	
	Hibernate2Session.closeSession();

	}catch(Exception e){
		e.printStackTrace();
	}
%>