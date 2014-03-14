<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="java.util.*"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />


<%try {
	Log log = LogFactory.getLog("findStepGroup.jsp");
	long timeStart = System.currentTimeMillis();   //for performance test
	
	if (AOFSECURITY.hasEntityPermission("SALES_FUNNEL", "_VIEW", session)) {
		String qryDepartmentId = request.getParameter("qryDepartmentId");
		String qryDisableFlg = request.getParameter("qryDisableFlg");
		String status = request.getParameter("status");
		String description = request.getParameter("desc");
		String qrySalesPerson = request.getParameter("qrySalesPerson");
		String bno = request.getParameter("bno");
		String pros = request.getParameter("pros");
		if(description == null)description="";
		if(status == null)status="Active";
		if(qrySalesPerson == null)qrySalesPerson="";
		if(bno == null)bno="";
		if(pros == null)pros="";
	
		List partyList = (List)request.getAttribute("PartyList");
		
		
%>

<script language="javascript">
	function doNew() {
		document.queryForm.action="editBidMaster.do";
		document.queryForm.formAction.value="view";
		document.queryForm.submit();
	}
	
//	function fnExport(){
//		document.queryForm.formAction.value="export";
//		document.queryForm.submit();
//	}
	
	function showDialog_account(){
		var code,desc;
		debugger;
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&SalesUserList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:550px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			document.getElementById("qrySalesPerson").value=code;
		} else {
			document.getElementById("qrySalesPerson").value="";
		}
	}
	function fnSubmit1(start) {
		with (document.queryForm) {
			offSet.value=start;
			submit();
		}
	}
	
	function fnQuery(){
		with (document.queryForm) {
	//		offSet.value= 0 ;
			submit();
		}
	}
</script>
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<form name="queryForm" action="ListSalesBid.do" method="post">
	<CAPTION align=center class=pgheadsmall>Sales Bid List</CAPTION>
	<tr>
		<td>
			<input type="hidden" name="formAction" value="query">
			<table width="100%">
				<tr><td colspan=6><hr color=red></hr></td></tr>
				<tr>
					<td align="right">
      					<span class="lblbold">Bid Description:&nbsp;</span>
   	 				</td>
    				<td>
					<input type="text" class="inputBox" name="desc" value="<%=description%>" size="20" />
    				</td>
					<td class="lblbold" align="right">Department:</td>
					<td class="lblLight">
						<select name="qryDepartmentId" class="selectbox">
						<option value="self">all relate to you</option>
						<%
						if (AOFSECURITY.hasEntityPermission("SALES_BID_VIEW_ALL", "", session)) {
							Iterator itd = partyList.iterator();
							
							while(itd.hasNext()){
								Party p = (Party)itd.next();
								if (p.getPartyId().equals(qryDepartmentId)) {
						%>
								<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
						<%
								} else{
						%>
								<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
						<%
								}
							}
						}
						%>
						</select>
					</td>
					<td align="right">
			          <span class="lblbold" >Sales Person:&nbsp;</span>
			        </td>
			        <td >
			        	<input type="text" class="inputBox" name="qrySalesPerson" size="12" value="<%=qrySalesPerson%>">
						<a href="javascript:showDialog_account()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
			        </td>
     			</tr>
     			<tr>
     				<td align="right">
      					<span class="lblbold">Bid No:&nbsp;</span>
   	 				</td>
    				<td>
					<input type="text" class="inputBox" name="bno" value="<%=bno%>" size="20" />
    				</td>
     				<td class="lblbold" align="right">Sales Status:</td>
				    <td class="lblLight" align="left">
				    <select name="status" class="selectbox">
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
     				<td align="right">
      					<span class="lblbold">Customer:&nbsp;</span>
   	 				</td>
    				<td>
					<input type="text" class="inputBox" name="pros" value="<%=pros%>" size="20" />
    				</td>
     			</tr>
     			<tr>
     				<td colspan=4></td> 
			    	<td colspan=2 align="middle">
						<input type="button" value="Query" class="button" onclick="fnQuery()">
						<input type="button" value="New" class="button" onclick="location.replace('editBidMaster.do?formAction=preCreate')">
	<!--					<input type="button" value="Export Excel" class="button" onclick="fnExport()"> -->
					</td>
				</tr>
				<tr>
					<td colspan=6 valign="top"><hr color=red></hr></td>
				</tr>
			</table>
		</td>
	</tr>
</table>

		<table width="100%">
				<%
		String con = "qryDepartmentId="+qryDepartmentId+"&status="+status+"&desc="+description+"&qrySalesPerson="
		+qrySalesPerson+"&bno="+bno+"&pros="+pros+"&formAction=query";
		if(request.getQueryString()!=null)
			con = request.getQueryString();
		request.getSession().setAttribute(("oldURL"),con);
		%>
		

<tr><td>
		<div >
		<display:table name="requestScope.QryList.rows" export="true" class="ITS" requestURI="ListSalesBid.do" pagesize="20">
			<display:column property="bid_no" title="Bid No." href="editBidMaster.do" paramId="id" paramProperty="id" sortable="true"/>
			<display:column property="prospect" title="Customer" sortable="true" />
			<display:column property="bid_description" title="Bid Description" sortable="true" />
			<display:column property="dep" title="Department" sortable="true" />
			<display:column property="sales" title="Sales Person"  sortable="true"/>
			<display:column property="second_sales" title="Secondary Sales"  sortable="true"/>
	 		<display:column property="bid_est_amt" title="Estimate Amount" align="right" sortable="true" decorator="com.aof.util.DisplayTagDecimalWrapper" />
			<display:column property="expected_end_date" title="Expected Contract Sign Date" sortable="true" />
			<display:column property="bid_status" title="Status" sortable="true" />
			<display:column property="step_percentage" title="Current WIN %" sortable="true"decorator="com.aof.util.DisplayTagNullFormatWrapper" />
		</display:table>
		</div>
</td></tr>
</table>
<%
	}else{
		out.println("!!你没有相关访问权限!!");
	}
	} catch(Exception ex) {
	ex.printStackTrace();
}
%>