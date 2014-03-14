<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />


<%
try{
	Log log = LogFactory.getLog("findStepGroup.jsp");
	long timeStart = System.currentTimeMillis();   //for performance test
	
	if (AOFSECURITY.hasEntityPermission("PRESALE_UPDATE_RPT", "_VIEW", session)) {
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
		String qryDepartmentId = request.getParameter("qryDepartmentId");
		String qrySalesPerson = request.getParameter("qrySalesPerson");
		String description = request.getParameter("description");
		String strStatus = request.getParameter("status");
		
		NumberFormat Num_formater = NumberFormat.getInstance();
    	Num_formater.setMaximumFractionDigits(2);
		Num_formater.setMinimumFractionDigits(2);
		if(description == null)description="";
		if(qryDepartmentId == null)qryDepartmentId="";
		if(qrySalesPerson == null)qrySalesPerson="";
		if(strStatus == null) strStatus = "";
		
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

<script language="javascript">
	function showDialog_account()
	{
		var code,desc;
		with(document.queryForm)
		{
			v = window.showModalDialog(
				"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&userList.do?openType=showModalDialog",
				null,
				'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
			if (v != null) {
				code=v.split("|")[0];
				desc=v.split("|")[1];
				qrySalesPerson.value=code;
			} else {
				qrySalesPerson.value="";
			}
		}
	}
	function ExportExcel() {
		var formObj = document.queryForm;
		formObj.formAction.value = "ExportToExcel";
		formObj.target = "_self";
		formObj.submit();
	}
</script>
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<CAPTION align=center class=pgheadsmall>Sales Funnel Status Report</CAPTION>
	<form name="queryForm" action="pas.report.PresaleUpdateRpt.do" method="post">
	<tr>
		<td>
				<input type="hidden" name="formAction" value="query">
				<TABLE width="100%">
					
					<tr>
						<td colspan=6><hr color=red></hr></td>
					</tr>
					<tr>
						<td align="left">
          					<span class="lblbold">Customer Description:&nbsp;</span>
       	 				</td>
        				<td>
						<input type="text" class="inputBox" name="description" value="<%=description%>" size="20" />
        				</td>
        				
        				<%
						UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
						if(ul.getParty().getIsSales().equalsIgnoreCase("Y")){
						%>				
							<td class="lblbold" align="left" colspan="1">Department By Salesperson:</td>
							<input type="hidden" name="viewType" value="sales">
						<%}else{%>
							<td class="lblbold" align="center" colspan="1">Department By Bid:</td>
							<input type="hidden" name="viewType" value="bid">
						<%}%>
        				
						<td class="lblLight">
							<select name="qryDepartmentId">
								<option value="">All related to you</option>
							<%
							if (AOFSECURITY.hasEntityPermission("PRESALE_UPDATE_RPT", "_ALL", session)) {
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
						<td align="left" >
				          <span class="lblbold">Sales Person:&nbsp;</span>
				        </td>
				        <td align="left">
				        	<input type="text" class="inputBox" name="qrySalesPerson" size="12" value="<%=qrySalesPerson%>">
							<a href="javascript:showDialog_account()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
				        </td>
	     			</tr>
	     			<tr>
	     				<td align="left">
          					<span class="lblbold">Bid Status:&nbsp;</span>
       	 				</td>
						<td class="lblLight" align="left">
						    <select name="status" class="selectbox">
			   	                <option value="" >ALL</option>
							    <option value="Lost/Drop" <%if (strStatus.equalsIgnoreCase("lost/drop")) out.println("selected");%>>Lost/Drop</option>
								<option value="Suspect" <%if (strStatus.equalsIgnoreCase("suspect")) out.println("selected");%>>Suspect</option>
								<option value="Pending" <%if (strStatus.equalsIgnoreCase("pending")) out.println("selected");%>>Pending</option>								
								<option value="Active" <%if (strStatus.equalsIgnoreCase("active")) out.println("selected");%>>Active</option>
								<option value="Offer" <%if (strStatus.equalsIgnoreCase("offer")) out.println("selected");%>>Offer</option>
								<option value="Prefer Supplier" <%if (strStatus.equalsIgnoreCase("prefer supplier")) out.println("selected");%>>Prefer Supplier</option>	
								<option value="Won" <%if (strStatus.equalsIgnoreCase("won")) out.println("selected");%>>Won</option>														
								<option value="abl" <%if (strStatus.equalsIgnoreCase("abl")) out.println("selected");%>>ALL But Lost/Drop</option>
							</select>
        				</td>
        				<td/>
	     			<%
	     			boolean includeflag = false; 
	     			if(((String)request.getAttribute("includecheck"))!=null)
	     				includeflag=true;
	     			%>	   
	     				<td align="left">
	     				<INPUT type=checkbox class="checkboxstyle" name="includecheck" <%if(includeflag)out.print("checked");%>>
	     				Show all funnels including no activities updated
       	 				</td>
	     				
				    	<td colspan=2 align="middle">
							<input type="submit" value="Query" class="button">
							<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
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
					  	<td align="center" rowspan="2" class="lblbold">#&nbsp;</td>
					  	<td align="left" rowspan="2" class="lblbold">Description</td>
					  	<td align="left" rowspan="2" class="lblbold">Sales Person</td>
					  	<td align="left" rowspan="2" class="lblbold">Department</td>
						<td align="left" rowspan="2" class="lblbold">ProspectCompany</td>
						<td align="left" rowspan="2" class="lblbold">Total Amount</td>
						<td align="left" rowspan="2" class="lblbold">Status</td>
						<td align="left" rowspan="2" class="lblbold">Start Date</td>
						<td align="left" rowspan="2" class="lblbold">End Date</td>
						<td align="left" rowspan="2" class="lblbold">Contract Type</td>
						<td align="left" rowspan="2" class="lblbold">Percentage</td>
			<%
				SQLResults sr = (SQLResults)request.getAttribute("QryList");
				if(sr == null || sr.getRowCount() == 0){%>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan='31' class=lblerr align='center'>No Record Found.</td>
		</tr>
			<%	} else {
					String bidid = sr.getString(0, "bidid");
					ArrayList bidList = new ArrayList();
					for (int row =1; row < sr.getRowCount(); row++) {
						if(!bidid.equals(sr.getString(row,"bidid"))){
							bidList.add(new Integer(row-1));
						}
						if((row+1) == sr.getRowCount()){
							bidList.add(new Integer(row));
						}
						bidid = sr.getString(row,"bidid");
					}
					
					//set activities
					String stepId = sr.getString(0,"stepId");
					ArrayList stepList = new ArrayList();
					int start = 0;
	
					for(int row =0;row <= ((Integer)bidList.get(0)).intValue();row++){
						if(!stepId.equals(sr.getString(row,"stepId"))){
							stepList.add(new Integer(row-start));
							start = row;
						}
						if(row == ((Integer)bidList.get(0)).intValue()){
							stepList.add(new Integer(((Integer)bidList.get(0)).intValue()-start + 1));
						}
						stepId = sr.getString(row,"stepId");
					}
					
					//set steps
					int startline = 0;
					Iterator stepIt = stepList.iterator();

					while(stepIt.hasNext()){//step
						int length = ((Integer)stepIt.next()).intValue();
						String stepDes = sr.getString(startline,"stepDes");
						String percentage = sr.getString(startline,"percentage");%>
						
					<td  align="middle" class="lblbold" colspan="<%=length%>"> <%=percentage + "%" + "    " + stepDes  %> </td>
					
					<%
						startline = startline + length;
					}%>
				</tr>
			 	<tr  bgcolor="#e9eee9">
			 		<%
			 			for(int row =0;row <= ((Integer)bidList.get(0)).intValue();row++){
							String actDes = sr.getString(row,"actDes");%>
						
					<td  align="middle" class="lblbold"> <%=actDes%> </td>
						
					<%	
					 }
			 		%>
			 	</tr>
  				
					<%Iterator it = bidList.iterator();
					int startRow = 0;
					int ExcelRow = 0;
					String record;
					boolean showflag = false;
					while(it.hasNext()){// a bid
						int endRow = ((Integer)it.next()).intValue();
						String biddescription = sr.getString(endRow,"biddescription");
						String deparment = sr.getString(endRow,"department");
						String salesPerson = sr.getString(endRow,"salesperson");
						String company = sr.getString(endRow,"company");
						String contractType = sr.getString(endRow,"contractType");
						Date startDate = sr.getDate(endRow,"startDate");
						Date endDate = sr.getDate(endRow,"endDate");
						double totalAmt = sr.getDouble(endRow,"totalAmt");
						int currentPercent = sr.getInt(endRow,"currentPercent");
						String status = sr.getString(endRow,"status");
						
						String startDateStr = "";
						String endDateStr = "";
						String totalAmtStr = "";
						
						if(startDate != null && !startDate.equals("null")){
							startDateStr = df.format(startDate);
						}
						if(endDate != null && !endDate.equals("null")){
							endDateStr = df.format(endDate);
						}
						
						//String used to show one record
						record ="<tr  bgcolor='#e9eee9'>"+  //reset
						"<td align='left' class='lblight'>"+(ExcelRow +1)+"</td>"+
						"<td align='left' class='lblight'>"+biddescription+"</td>"+
						"<td align='left' class='lblight'>"+salesPerson+"</td>"+
						"<td align='left' class='lblight'>"+deparment+"</td>"+
						"<td align='left' class='lblight'>"+company+"</td>"+
						"<td align='left' class='lblight'>"+Num_formater.format(totalAmt)+"</td>"+
						"<td align='left' class='lblight'>"+status+"</td>"+
						"<td align='left' class='lblight'>"+startDateStr+"</td>"+
						"<td align='left' class='lblight'>"+endDateStr+"</td>"+
						"<td align='left' class='lblight'>"+contractType+"</td>"+
						"<td align='left' class='lblight'>"+currentPercent+"%</td>";
						%>
						<%
					//set steps
					Iterator stepIts = stepList.iterator();
					showflag = false; //reset
					while(stepIts.hasNext()){//step
						int length = ((Integer)stepIts.next()).intValue();
						String stepDes = sr.getString(startRow,"stepDes");
						String percentage = sr.getString(startRow,"percentage");%>
						<%//activity
						for(int row = startRow;row <= startRow+length-1 ;row ++){
							String actDes = sr.getString(row,"actDes");
							if(sr.getString(row,"bidAct_id")!=null ){
								showflag = true;
								record=record+"<td align='left' class='lblight'>&radic;</td>";
								}else{
								record = record +"<td align='left' class='lblight'>&nbsp;</td>";
								}
							}
						startRow = startRow + length;
					}
				ExcelRow ++;
				startRow = endRow + 1;
				record +="</tr>";
				out.print(record);
					}
				}
			%>
 	</form>
</table>
<%
	}else{
		out.println("!!你没有相关访问权限!!");
	}
 }catch (Exception e) {
			e.printStackTrace();
		}
%>