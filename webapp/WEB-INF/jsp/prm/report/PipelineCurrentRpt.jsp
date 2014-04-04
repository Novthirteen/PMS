<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.prm.report.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
try {
if (true || AOFSECURITY.hasEntityPermission("SALES_PIPELINE_RPT", "_SALES", session)) {
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	List bidMasterList = (List)request.getAttribute("QryList");
	List partyList = (List)request.getAttribute("PartyList");
	Hashtable hash=(Hashtable)request.getAttribute("hash");
	String department = request.getParameter("department");
	String persontype = request.getParameter("persontype"); 
	if(persontype == null)
		persontype = "0";
	if(hash==null)
	hash=new Hashtable();
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<%
%>
<script language="javascript">
	function clearUser() {
		with(document.frm) {
//			var tmpName = document.getElementById("userDesc");
//			tmpName.innerHTML = "";
			sales.value="";
			hid_id.value="";
    	}
	}

function SearchResult() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
function showStaff() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.frm.hid_id.value=v.split("|")[0];
			document.frm.sales.value=v.split("|")[1];
	}
}

function showBidMaster(id) {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.bidmaster.detail&dialogBidMaster.do?id="+id,
	null,
	'dialogWidth:900px;dialogHeight:700px;status:no;help:no;scroll:no');
}

</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>

<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">Sales Pipeline Report</caption> 
	<tr>
		<td>
			<form action="pas.report.PipelineCurrentRpt.do" name="frm" method="post">
				<input type="hidden" name="formAction" id="formAction">
				<table width=1000>
					<tr>
						<td colspan="8" valign="bottom"><hr color=red></hr></td>
					</tr>
					<tr>
					    <td class="lblbold" align="center" colspan="1">Year:</td>
						<td align="left"><select name="year" class="inputbox">
						<%
							UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
							String selectyear=(String)request.getParameter("year");	
							SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
							String now = formatter.format(Calendar.getInstance().getTime());
							StringTokenizer st=new StringTokenizer(now,"-");
							String currentYear = st.nextToken();
							if (selectyear ==null) selectyear = currentYear;
							int nowyear=Integer.parseInt(currentYear);

							for(int n=-1;n<2;n++)
							{
							int temp=nowyear+n;
							if(temp==Integer.parseInt(selectyear)){
							%>
						<option value="<%=temp%>" selected><%=temp%>
							<%}
							else{%>
						<option value="<%=temp%>"><%=temp%>							
							<%	}
							}
							%>
						</select>
						</td>						
						</tr>
				    <tr>
						<td class="lblbold" align="center" colspan="1">Month:</td>
						<td align="left">
						<select name="month" class="inputbox">
						<%
						String selectmonth=(String)request.getParameter("month");	
						String currMonth = st.nextToken();
						if( selectmonth==null) selectmonth = currMonth;
						int nowmonth = Integer.parseInt(currMonth);
							for(int n=1;n<13;n++)
							{
							int temp=n;
							if((temp<13) && (temp >0)){
							if(temp==Integer.parseInt(selectmonth)){
							%>
						<option value="<%=temp%>" selected><%=temp%>
							<%}
							else{%>
						<option value="<%=temp%>"><%=temp%>							
							<%	}
							}
						}%>
						</select>
						</td>								    
					    <%
					    String zeroFlag = (String)request.getParameter("zeroFlag");
					    if(zeroFlag == null){
					    	zeroFlag = "";
					    }
					    %>
						<td colspan="2">
							<input type="checkbox" name="zeroFlag" value="y" <%= zeroFlag.equals("y") ? "checked" : ""%> style="border:0px;background-color:#ffffff">Include 0% deals
						</td>
					</tr>					
					<tr>
					<%
						if(ul.getParty().getIsSales().equalsIgnoreCase("Y")){
//						if (AOFSECURITY.hasEntityPermission("SALES_PIPELINE_RPT", "_SALES", session)) {
					%>				
						<td class="lblbold" align="center" colspan="1">Department By Salesperson:</td>
						<input type="hidden" name="viewType" id="viewType" value="sales">
					<%}else{%>
						<td class="lblbold" align="center" colspan="1">Department By Bid:</td>
						<input type="hidden" name="viewType" id="viewType" value="bid">
					<%}%>
						<td class="lblLight" colspan="1" >
							<select name="department" class="inputbox">
							<option value="-1" >All Related To You</option>
							<%
							String dept = (String)request.getAttribute("department");
							if (AOFSECURITY.hasEntityPermission("SALES_PIPELINE_RPT", "_ALL", session)) {
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if(dept!=null)
									{
									if (p.getPartyId().equals(dept)) {
							%>
									<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%
									} else{
							%>
									<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%
									}			}
									else{
									if (p.getPartyId().equals(department)) {
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
						}
							%>
							</select>
						</td>
					    <%
					    String wonFlag = (String)request.getParameter("wonFlag");
					    if(wonFlag == null){
					    	wonFlag = "";
					    }
					    %>
						<td colspan="2">
							<input type="checkbox" name="wonFlag" value="y" <%= wonFlag.equals("y") ? "checked" : ""%> style="border:0px;background-color:#ffffff">Include 100% won deals
						</td>

					   	<td colspan=4></td>
					</tr>
					<tr>
					    <td class="lblbold" align="center">Salesperson:</td>
					    <td class="lblbold" >
					   <%
					   String salseid=(String)request.getAttribute("sales");
					   String salesname=(String)request.getAttribute("salesname");
					   if(salseid==null){
					   salseid="";
					   salesname="";}
					   %>
					    <input type="text" name="sales" value="<%=salesname%>"  class="inputbox" readonly>
					    <input type="hidden" name="hid_id" id="hid_id" value="<%=salseid%>">
					    <a href='javascript: showStaff()'><img align="absmiddle" alt="select" src="images/select.gif" border="0" /></a>
						<a href="javascript:void(0)" onclick="clearUser();event.returnValue=false;"><img align="absmiddle" alt="Clear Employee" src="images/deleteParty.gif" border="0" /></a>
					    </td>
					   	<td colspan=4></td>
					</tr>
					<tr>
					    <%if(ul.getParty().getIsSales().equals("N")){%>
					  <td class="lblbold" align="center">Option: </td>
					  <td>
					    <select name="persontype" class="inputbox">
					    <option value="0">(All)
					    <option value="1" <%if(persontype.endsWith("1")) out.print("selected");%> >Only Sales
					    <option value="2" <%if(persontype.endsWith("2")) out.print("selected");%> >Only SL Sales
					    </select>
					    <%}%>
					    </td>
					</tr>
					<tr>
					<td colspan=2 />
					<td class="lblbold" align="center" colspan="6">
							<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
							<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
						</td>
					</tr>
					<tr>
						<td colspan="18" valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
</table>

<table width="100%" cellpadding="1" border="0" cellspacing="1">
	<tr>
		<td>
			<table border="0" cellpadding="2" cellspacing="2" width=100%>
				<tr bgcolor="#e9eee9">
					<td class="lblbold" align="center" rowspan="2">Client Name</td>
					<td class="lblbold" align="center" rowspan="2">Sector</td>
					<td class="lblbold" align="center" rowspan="2">Short Description</td>
					<td class="lblbold" align="center" rowspan="2">Sales Person</td>
					<td class="lblbold" align="center" rowspan="2">Secondary Sales Person</td>
					<td class="lblbold" align="center" rowspan="2">Type</td>
					<td class="lblbold" align="center" rowspan="2">Bid Code</td>
					<td class="lblbold" align="center" rowspan="2">TCV UnW(K)</td>
					<td class="lblbold" align="center" rowspan="2">Win%</td>																				
					<td class="lblbold" align="center" rowspan="2">StartDate</td>
					<td class="lblbold" align="center" rowspan="2">EndDate</td>
					<td class="lblbold" align="center" rowspan="2">This Year UnW(K)</td>
					<td class="lblbold" align="center" rowspan="2">Weighted This Year(K)</td>	
					<%Integer pipeYear = (Integer)request.getAttribute("pipeYear");
					%>
					<td class="lblbold" align="center" colspan="12"><font color='red'><%if(pipeYear!=null)out.print(pipeYear);%></font> Months(K)</td>
					<td class="lblbold" align="center" rowspan="2">Acc Manager</td>
					<td class="lblbold" align="center" rowspan="2">SL Rep</td>					
				</tr>
				<tr bgcolor="#e9eee9">
					<td class="lblbold" align="center">Jan</td>
					<td class="lblbold" align="center">Feb</td>
					<td class="lblbold" align="center">Mar</td>
					<td class="lblbold" align="center">Apr</td>
					<td class="lblbold" align="center">May</td>
					<td class="lblbold" align="center">Jun</td>
					<td class="lblbold" align="center">Jul</td>
					<td class="lblbold" align="center">Aug</td>
					<td class="lblbold" align="center">Sep</td>
					<td class="lblbold" align="center">Oct</td>
					<td class="lblbold" align="center">Nov</td>
					<td class="lblbold" align="center">Dec</td>
				</tr>

				<%
				if(bidMasterList == null){
					out.println("<br><tr><td colspan='56' class=lblerr align='center'>No Record Found.</td></tr>");
				} else {
				%>
					<tr bgcolor='#e9bbb9'>
					<td class="lblbold" align="center">
					<td class="lblbold" align="center">
					<td class="lblbold" align="center">
					<td class="lblbold" align="center">
					<td class="lblbold" align="center">
					<td class="lblbold" align="center">
					<td class="lblbold" align="center">
					<td class="lblbold" id="tot0" align="center">
					<td class="lblbold" align="center">
					<td class="lblbold" align="center">
					<td class="lblbold" align="center">
					<td class="lblbold" id="tot1" align="center">
					<td class="lblbold" id="tot2" align="center">
					<td class="lblbold" id="tot3" align="center">Jan</td>
					<td class="lblbold" id="tot4" align="center">Feb</td>
					<td class="lblbold" id="tot5" align="center">Mar</td>
					<td class="lblbold" id="tot6" align="center">Apr</td>
					<td class="lblbold" id="tot7" align="center">May</td>
					<td class="lblbold" id="tot8" align="center">Jun</td>
					<td class="lblbold" id="tot9" align="center">Jul</td>
					<td class="lblbold" id="tot10" align="center">Aug</td>
					<td class="lblbold" id="tot11" align="center">Sep</td>
					<td class="lblbold" id="tot12" align="center">Oct</td>
					<td class="lblbold" id="tot13" align="center">Nov</td>
					<td class="lblbold" id="tot14" align="center">Dec</td>
					<td class="lblbold" align="center" rowspan="1">
					<td class="lblbold" align="center" rowspan="1">
				</tr><%
					NumberFormat numFormat = NumberFormat.getInstance();
					numFormat.setMaximumFractionDigits(0);
					numFormat.setMinimumFractionDigits(0);
					DecimalFormat decFormat = (DecimalFormat)DecimalFormat.getNumberInstance();
					decFormat.setMaximumFractionDigits(0);
					decFormat.setGroupingUsed(false);					
					Calendar calendar = Calendar.getInstance();
					int year=Integer.parseInt(st.nextToken());
					int queryYear = Integer.parseInt(request.getParameter("year"));
					int queryMonth = Integer.parseInt(request.getParameter("month"));
//					if(queryMonth==12)
//					{
//						queryYear +=1;
//						queryMonth =0;
//					}
//					calendar.set(queryYear,queryMonth,1);
					calendar.set(queryYear,queryMonth-1,1);
					Date nowDate = calendar.getTime();
					
					Calendar.getInstance().clear();		
					for (int row =0; row < bidMasterList.size(); row++) {
						BidMaster bm = (BidMaster)bidMasterList.get(row);
						BidUnweightedValue un=(BidUnweightedValue)hash.get(bm.getId().toString().trim());
						String recval="rec"+row;

						calendar.set(queryYear, 11, 31);
						Date thisyearEnd = calendar.getTime();
						 calendar.set(queryYear, 0, 1);
						Date thisyearStart = calendar.getTime();

						 if(nowDate.after(thisyearStart)&&nowDate.before(thisyearEnd))
						 	thisyearStart = nowDate;

						java.util.Date startDate = bm.getEstimateStartDate();
						java.util.Date endDate = bm.getEstimateEndDate();
						calendar.clear();
						int totalMonth = 0;
						 year = endDate.getYear() - startDate.getYear();
						if (year < 1) {
							totalMonth = endDate.getMonth() - startDate.getMonth();
						} else {
							totalMonth = endDate.getMonth() - startDate.getMonth()
									+ year * 12;
						}
						if (totalMonth < 1)
							totalMonth = 1;
						int thisYearStartMonth = 0;
						int thisYearEndMonth = 0;
						
						
					if (endDate.before(thisyearEnd)&&endDate.after(thisyearStart)) {
						thisYearEndMonth = endDate.getMonth();
					} 
					else
						thisYearEndMonth = thisyearEnd.getMonth();
						
					if (startDate.after(thisyearStart)&&startDate.before(thisyearEnd)) {
						thisYearStartMonth = startDate.getMonth();
					} else {
						thisYearStartMonth = thisyearStart.getMonth();
						if(endDate.before(thisyearStart))
							thisYearEndMonth = thisYearStartMonth;
					}
/*					if (endDate.before(thisyearEnd)&&endDate.after(thisyearStart)) {
							thisYearEndMonth = endDate.getMonth();
						} else
							thisYearEndMonth = thisyearEnd.getMonth();
							
						if (startDate.after(thisyearStart)&&startDate.before(thisyearEnd)) {
							thisYearStartMonth = startDate.getMonth();
						} else
							thisYearStartMonth = thisyearStart.getMonth();
*/							
						int thisYearMonth = thisYearEndMonth - thisYearStartMonth
								+ 1;
						if (thisYearMonth < 1)
							thisYearMonth = 1;
						double thisYearUnW;
						if(un!=null){
						thisYearUnW =Math.round( un.getValue().doubleValue()/1000);}
						else{
						thisYearUnW = Math.round((thisYearMonth
								/ new Double(totalMonth).doubleValue()
								* bm.getEstimateAmount().doubleValue())/1000);
								}
						double weightedThisYear = 0;
						if (bm.getPercentage() != null
								&& !bm.getPercentage().trim().equals("")) {
							weightedThisYear = Math.round(thisYearUnW
									* ((new Double(bm.getPercentage())).intValue())
									/ 100);

						}
						int startMonth = thisYearStartMonth+1;
						int endMonth = thisYearEndMonth+1;
															
						double amountPerMonth = Math.round(weightedThisYear / thisYearMonth);
						
						int mark=0;
						int percent	 = 0;
						if((bm.getPercentage()!=null)&&(bm.getPercentage().length()>0))
						percent	= Integer.parseInt(bm.getPercentage());
						if((nowDate.after(bm.getEstimateStartDate()))&&(percent<=90))
							mark=1;		
				%>
				<tr bgcolor="#e9eee1"> 
					<td class='lblbold'  align="left">
					<input type="hidden" name="company" id="company">
					<%=bm.getProspectCompany().getDescription()%>
					</td>
					<td  class='lblbold' align="left">
					<%=bm.getProspectCompany().getIndustry().getDescription()%>
					</td>
					
					<td  class='lblbold'  align="left">
					<%=bm.getDescription()%>
					</td>
					<td class='lblbold'  align="left">
					<%if((bm.getSalesPerson()!=null)&&(bm.getSalesPerson().getName()!=null))
						out.print(bm.getSalesPerson().getName());%>
					</td>
					<td  class='lblbold'  align="left">
					<%if(bm.getSecondarySalesPerson()!=null)out.print(bm.getSecondarySalesPerson().getName());%>
					</td>
					<td  class='lblbold'    align="left">
					<%=bm.getContractType()%>
					</td>
					<td  class='lblbold'   align="left">
					<a href="javascript:showBidMaster(<%=bm.getId().longValue()%>)"><%=bm.getNo()%></a>
					</td>
					<td   class='lblbold'   align="left">
					<input type="hidden" value="<%=decFormat.format(Math.round((bm.getEstimateAmount().doubleValue())/1000))%>" name="<%=recval%>" id="<%=recval%>">
					<%=numFormat.format(Math.round((bm.getEstimateAmount().doubleValue())/1000))%>
					</td>
					<td   class='lblbold'  align="left">
					<%if(mark==1){%>
					<font color="red"><%=(bm.getPercentage()==null||bm.getPercentage()=="")? "0%":bm.getPercentage()+"%"%></font>
					<%}else{%>
					<%=(bm.getPercentage()==null||bm.getPercentage()=="")? "0%":bm.getPercentage()+"%"%>
					<%}%>
					</td>
					<td  class='lblbold'   align="left">
					<%=bm.getEstimateStartDate()%>
					</td>
					<td  class='lblbold'  align="left">
					<%=bm.getEstimateEndDate()%>
					</td>
					<td  class='lblbold'   align="left">
					<input type="hidden" value="<%=decFormat.format(thisYearUnW)%>" name="<%=recval%>" id="<%=recval%>">
					<%=numFormat.format(thisYearUnW)%>					
					</td>
					<td  class='lblbold'   align="left">
					<input type="hidden" value="<%=decFormat.format(weightedThisYear)%>" name="<%=recval%>" id="<%=recval%>">
					<%=numFormat.format(weightedThisYear)%>
					</td>
					<%
					for(int x=1;x<13;x++)
					{
					double tempamount;
					if (x >= startMonth && x <= endMonth){
					tempamount=amountPerMonth;
					}
					else
					tempamount=0;
					%>
					<td  class='lblbold'  align="right" ><input type="hidden" value="<%=tempamount%>" name="<%=recval%>" id="<%=recval%>"><% if((x >= startMonth && x <= endMonth)&&(amountPerMonth!=0)) out.print(numFormat.format(amountPerMonth));%></td>
					<%
					}
					%>
					<td class='lblbold'  align="left">
					<%
					if((bm.getSalesPerson()!=null)&&(bm.getSalesPerson().getName()!=null))
					out.println(bm.getSalesPerson().getName());
					%>
					</td>
					<td class='lblbold'   align="left">
					<%
					  if(bm.getDepartment().getDescription().equals("AS")) out.print("Hao Li");
					  if(bm.getDepartment().getDescription().equals("QAD")) out.print("Zoe Wu");
					  if(bm.getDepartment().getDescription().equals("SAP")) out.print("Eng Khoon");
					%>
					
				</tr>
				<%
					}
				}
				%>
				<script language="javascript">
function CalcTot()
{
var oRec=document.getElementsByName("company");
var oTot;
var oAmount;
var oMonth = new Array(15);
var amount=0.00;
for(var v=0;v<15;v++)
{
oMonth[v]=0;
}
	for(var i=0;i<oRec.length;i++)
	{
		oAmount=document.getElementsByName("rec"+i);
		for(var a=0;a<15;a++)
		{
		amount=parseFloat(oAmount[a].value);
			if(isNaN(amount))
			{
			amount=0.00;
			}
		oMonth[a]=oMonth[a]+amount;	
		amount=0.00;	
		}
	}
	oTot=document.getElementById("tot"+1);
	if(oTot!=null){
	for(var r=0;r<15;r++)
	{
	oTot=document.getElementById("tot"+r);
	oTot.innerHTML=oMonth[r];
	}
	}
}


CalcTot();
</script>
			</table>	
		</td>
	</tr>
</table>

<%
}
else{
	out.println("没有访问权限.");
}
} catch(Exception ex) {
	ex.printStackTrace();
}
%>



