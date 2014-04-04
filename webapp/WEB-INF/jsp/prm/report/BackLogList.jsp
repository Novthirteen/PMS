<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.ProjectMaster"%>
<%@ page import="com.aof.component.prm.report.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.report.ProjectBean"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.Math"%>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language="javascript">

function fnHide(focus)
{
var obj = focus;//current td
if( obj.value==0)//ready to hide
{
	obj.bgColor='#b4d4d4';
}
else//ready to show
{
	obj.bgColor='#ffffff';
}
var root = document.getElementById("root");//table root
var oTBODY = root.firstChild;//tbody object
var oTR = oTBODY.firstChild ;// tr object
var arr ;//all td belongs to oTR

for(var i=0;i<oTBODY.children.length;i++)
{	
	if(oTR.nodeName=='TR'){
	arr = oTR.children;
	if(obj.value==0){
		arr[obj.id].style.display = "none";
	}else{
		arr[obj.id].style.display = "block";
	}
	oTR = oTR.nextSibling;
	}	
}
	if(obj.value==0){
		obj.value=1;}
	else{
		obj.value=0;
	}

}
function requery()
{

document.frm1.action="viewBackLog.do"
document.frm1.formaction.value = "requery"
document.frm1.submit()
}

function split(deptcount,gcount)
{
	
	var m=0;
	var purevalue = 0;
	var enter =0;
	m=parseInt(document.frm1.cmonth.value);
	var temp="RecordVal"+gcount;
	var records=document.getElementsByName(temp);
	for(var v=0;v<m;v++)
	{
		purevalue = records[v].value.replace(/,/g, "");
		enter = enter+parseInt(purevalue);
	}

	var revenuename=document.getElementsByName("yt"+gcount);
	var pmonthname=document.getElementsByName("pmonth"+temp);
	var remainmonth=document.getElementsByName("remainmonth"+temp);
	var month=parseInt(remainmonth[0].value);//all remain month
	var pmonth=parseInt(pmonthname[0].value);//start month
	var revenue=0;
	purevalue = revenuename[0].value.replace(/,/g, "");
	revenue=Math.round(parseFloat(purevalue))-enter;//this year value
	//set the old value in order to get the gap between new and old

	if(month>0){//not exceeds end date
			if(pmonth+month>13)
			{
				month=13-pmonth;
//				alert(month);
			}
		
			if(month>0)
			{
				for(var i=pmonth-1;i<pmonth+month-1;i++)
					{
						if(i<12){
						records[i].value=Math.round(revenue/(month));}
					}
			}
}
	if(month==0){//exceeds end date
				if(m<11)
					{
						records[m].value=Math.round(revenue);
					}
	}
}

function ResetRevenue(enter,deptcount,gcount)
{
//*****enter:the value  entered in the textbox
//*****deptcount: department count
//*****gcount: record's global count
//*****monthcount: records monthly count
//*****oldvalue: old value for this textbox

	if(isNaN(enter)){
		alert("not a number");
		}
	else if(enter.length<1)
	{
	alert("can't be blank");
	}
	else{
//*****do the split to the month
	split(deptcount,gcount);
//*****recalculate the month total and year total for all

//*****get the yearly record gap
	var gap=0;
	var yeartotal=document.getElementsByName("yt"+gcount);
	var oMark;
	var oText;
	var dept=parseInt(deptcount);
	var purevalue = 0;
	purevalue = yeartotal[0].value.replace(/,/g, "");
	gap=parseInt(purevalue)-parseInt(yeartotal[0].oldvalue);
	var oTdtot=document.getElementById("yTCV"+dept);
	oTdtot.innerHTML=parseInt(oTdtot.innerHTML)+gap;
	oTdtot=document.getElementById("ayTCV");
	oTdtot.innerHTML=parseInt(oTdtot.innerHTML)+gap;
	yeartotal[0].oldvalue=purevalue;
	
	//get the monthly record gap
	var v=parseInt(document.frm1.cmonth.value)-1;
	var ytot=0;
	yeartotal=document.getElementsByName("RecordVal"+gcount);
	for(var i=0;i<12;i++)
	{
		purevalue = yeartotal[i].value.replace(/,/g, "");
		if(i>=v){
		gap=parseInt(purevalue)-parseInt(yeartotal[i].oldvalue);
		oTdtot=document.getElementById("tSubTot"+dept+i);
		oTdtot.innerHTML=parseInt(oTdtot.innerHTML)+gap;
		oTdtot=document.getElementById("atSubTot"+i);
		oTdtot.innerHTML=parseInt(oTdtot.innerHTML)+gap;
		}
		yeartotal[i].oldvalue=purevalue;
		ytot = ytot + parseInt(purevalue);
				
	}
		yeartotal=document.getElementsByName("yt"+gcount);
		oMark=document.getElementById("mark"+gcount);
		purevalue = yeartotal[0].value.replace(/,/g, "");
		if(Math.round(purevalue)==parseInt(ytot)){
		oMark.innerHTML="OK";
			}
		else
			{
		oMark.innerHTML=parseInt(ytot);
			}		
	}	
}
</script>


<%try{
if (AOFSECURITY.hasEntityPermission("BACKLOG_REPORT", "_VIEW", session)) {%>
<form name="frm1" action="updateBackLog.do" method="post" >
<table width="100%" cellpadding="1" border="0" cellspacing="1"	align="center">
	<caption class="pgheadsmall">BackLog Report</caption>
	<tr>
	<input type="hidden" name="type" id="type" value=<%=request.getAttribute("type")%>>
	<input type="hidden" name="cmonth" id="cmonth" value=<%=request.getAttribute("enter_month")%>>
	<input type="hidden" name="cyear" id="cyear" value=<%=request.getAttribute("enter_year")%>>
	<input type="hidden" name="departmentId" id="departmentId" value='<%=request.getAttribute("departmentId")%>'>
	<input type="hidden" name="status" id="status" value="draft">	
	<input type="hidden" name="formaction" id="formaction" value="formaction">	
	<td class="lblbold" align="left">Year:<%=request.getAttribute("enter_year")%>
	&nbsp;&nbsp;&nbsp;Month:<%=request.getAttribute("enter_month")%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type=checkbox name="recurringflag"  style="border:0px;background-color:#ffffff"
	<%
	if(request.getAttribute("recurringflag")!=null){
	System.out.println("test flag:"+request.getAttribute("recurringflag"));
	if(((String)request.getAttribute("recurringflag")).equalsIgnoreCase("y"))out.print("checked");}%> >
	only recurring&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
	<input type="button" value="go" onclick='javascript:requery()' class="button"></td>
	</tr>
	<tr>
		<td colspan=8 valign="bottom">
		<hr color=red></hr>
		</td>
	</tr>
</table>
<table>
<tr>
<td id=0 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Dep&nbsp;|</td>
<td id=1 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Client&nbsp;|</td>
<td id=2 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Sector&nbsp;|</td>
<td id=3 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Type&nbsp;|</td>
<td id=4 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Short&nbsp;|</td>
<td id=5 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Category&nbsp;|</td>
<td id=7 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Description|</td>
<td id=8 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Contract Type|</td>
<td id=14 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Jan&nbsp;|</td>
<td id=15 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Feb&nbsp;|</td>
<td id=16 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Mar&nbsp;|</td>
<td id=17 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Apr&nbsp;|</td>
<td id=18 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Jun&nbsp;|</td>
<td id=19 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;May&nbsp;|</td>
<td id=20 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;July&nbsp;|</td>
<td id=21 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Aug&nbsp;|</td>
<td id=22 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Sep&nbsp;|</td>
<td id=23 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Oct&nbsp;|</td>
<td id=24 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Nov&nbsp;|</td>
<td id=25 class="lblbold" align="center" nowrap value=0 onclick="javascript:fnHide(this);">&nbsp;Dec&nbsp;|</td>
</tr>
</table>
<br>
<table width="767" height="374" border="0" id="root">
	<tr bgcolor='#e9eee9' >
		<td scope="col" class="lblbold" align="center" width="4" nowrap>Department</td>
		<td scope="col" class="lblbold" align="center" nowrap>Clinet Name</td>
		<td scope="col" class="lblbold" align="center" nowrap>Sector</td>
		<td scope="col" class="lblbold" align="center" nowrap>Type</td>
		<td scope="col" class="lblbold" align="center" nowrap>Short Description</td>
		<td scope="col" class="lblbold" align="center" nowrap>Service Category</td>		
		<td scope="col" class="lblbold" align="center" nowrap>Project Code</td>
		<td scope="col" class="lblbold" align="center" nowrap>Description</td>
		<td scope="col" class="lblbold" align="center" nowrap>Contract Type</td>
		<td scope="col" style='text-align:right' class="lblbold" align="center" size="10" width="10" nowrap>TCV(K)</td>
		<td scope="col" class="lblbold" align="center"nowrap>Start Date</td>
		<td scope="col" class="lblbold" align="center"nowrap>End Date</td>
		<td scope="col" class="lblbold" align="center"nowrap>Status</td>
		<td scope="col" style='text-align:right' class="lblbold" align="right" width="10" nowrap>This Year(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Jan(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Feb(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Mar(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Apr(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>May(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Jun(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Jul(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Aug(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Sep(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Oct(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Nov(K)</td>
		<td scope="col" class="lblbold" width="10" align="right" nowrap>Dec(K)</td>
		<td scope="col" align="right"  width="10" class="lblbold">&nbsp;</td>
		
	</tr>
	<tr bgcolor='#e9eee9'>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" style='text-align:right' align="right" id="adTCV" size="10" width="10" class="lblbold"></td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" class="lblbold">&nbsp;</td>
		<td scope="col" style='text-align:right' align="right" id="ayTCV" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot0" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot1" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot2" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot3" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot4" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot5" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot6" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot7" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot8" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot9" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot10" width="10" class="lblbold">0</td>
		<td scope="col" style='text-align:right' align="right" id="atSubTot11"  width="10" class="lblbold">0</td>
		<td scope="col" align="right"   width="10" class="lblbold">&nbsp;</td>
	</tr>
	<%	
	long		start=System.currentTimeMillis();
	long		end=System.currentTimeMillis();
	int gcount=0;
	NumberFormat nf = NumberFormat.getInstance();
	nf.setMaximumFractionDigits(0);
	nf.setMinimumFractionDigits(0);
		String stname;
		String dtcv;//="dTCV"+gcount;
		String ytcv;//="yTCV"+gcount;
		String tSubTot;
		String stcv;
		String type;
		List securitylist=(List)request.getAttribute("securitylist");	
		List recordlist=null;	
		int d=0;
	for(int b=0;b<securitylist.size();b++){
		recordlist=null;
		recordlist = (List) request.getAttribute((String)securitylist.get(b));
		if((recordlist==null)||(recordlist.size()<=0))
		continue;
		else if ((recordlist!=null)&& (recordlist.size() >0)) {
		 dtcv="dTCV"+d;
		 ytcv="yTCV"+d;
		 tSubTot="tSubTot"+d;
		 stcv="sTCV"+d;
		 type="type"+d;
	%>
		<tr bgcolor='#b4d4d4'>
		<td scope="col"  align="center" class="lblbold"><input type="hidden" name="department" id="department" value='<%=(String)securitylist.get(b)%>'><%=(String)securitylist.get(b)%></td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col" style='text-align:right' id="<%=dtcv%>"  align="right" size="10" width="10" class="lblbold"></td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col"  align="center" class="lblbold">&nbsp;</td>
		<td scope="col" style='text-align:right' id="<%=ytcv%>"  align="right" width="10" class="lblbold">0</td>
			<%
			for (int i=0;i<12;i++)
			{
			String tstname=tSubTot+i;
			out.println("<td scope='col' style='text-align:right' id='"+tstname+"' class='lblbold' width='10' >0</td>");
			}		
			%>
		<td scope="col" align="right"   width="10" class="lblbold"></td>
		</tr>
			<%	String monthname=null;
				String yeartotal=null;	
				String mark=null;								
				String colour = "#e9eee9";
				for (int i = 0; i < recordlist.size(); i++) {
				BackLogBean bean=(BackLogBean)recordlist.get(i);
				ProjectBean pb=(ProjectBean)bean.getPb();
				if(bean!=null)
				{
				colour = "#e9eee9";
				yeartotal="yt"+gcount;
				monthname="RecordVal"+gcount;
				mark="mark"+gcount;
				String pmonthname="pmonth"+monthname;
				String remainrevenue="revenue"+monthname;
				String remainmonth="remainmonth"+monthname;
				String thisyearrevenue="thisyear"+monthname;
				if((pb.getProj_duration()!=null)&&(pb.getProj_duration().equalsIgnoreCase("recurring"))){
				out.println("<tr bgcolor='#e9bbb9'><td>&nbsp;</td>");
				colour = "#e9bbb9";
				}
				else 
				out.println("<tr bgcolor='#e9eee9'><td>&nbsp;</td>");
				out.println("<td  align='left' nowrap class='lblbold'>"+pb.getCustomer()+"</td>");				
				if(pb.getC2code()!=null)
				out.println("<td  align='left' nowrap class='lblbold'>"+pb.getC2code()+"</td>");				
				else 
				out.println("<td  align='center' nowrap>&nbsp;</td>");				
				if(pb.getProj_duration()!=null)
				out.println("<td  align='center' nowrap>"+pb.getProj_duration()+"</td>");				
				else
				out.println("<td  align='center' nowrap>&nbsp;</td>");								
				out.println("<td  align='left' nowrap class='lblbold'>"+pb.getProjName()+"</td>");				
				out.println("<td  align='center' nowrap>"+pb.getIndustry()+"</td>");				
				%>
				<td  align="center" class="lblbold" nowrap>
				<input type="hidden" name="<%=pmonthname%>" id="<%=pmonthname%>" value="<%=bean.getPmonth()%>">
 				<input type="hidden" name="<%=remainrevenue%>" id="<%=remainrevenue%>" value="<%=bean.getRemainrevenue()%>">
 				<input type="hidden" name="<%=remainmonth%>" id="<%=remainmonth%>" value="<%=bean.getRemainmonth()%>">
				<% 
				out.println("<input type='hidden' name='projId' id='projId' value='"+pb.getProjId()+"'>"+pb.getProjId()+"</td>");
				out.println("<td  style='text-align:left' align='left' nowrap>"+pb.getProjName()+"</td>");
				out.println("<td  align='center' nowrap><input type='hidden' name='"+type+"' id='"+type+"'>"+pb.getContractType()+"</td>");
				out.println("<td  align='right' nowrap size='10' width='10'><input type='hidden' size='10' width='10' value='"+(int)Math.round(pb.getTotalServiceValue().doubleValue()/1000)+"' style='border:0px' name='"+stcv+"' id='"+stcv+"' >"+nf.format((int)Math.round(pb.getTotalServiceValue().doubleValue()/1000))+"</td>");
				out.println("<td  align='center' nowrap>"+pb.getStartDate()+"</td>");
				out.println("<td  align='center' nowrap>"+pb.getEndDate()+"</td>");
				out.println("<td  align='center' nowrap>"+pb.getProjStatus()+"</td>");
				%><%
				if((pb.getContractType().equalsIgnoreCase("tm"))&& (pb.getCAFFlag().equalsIgnoreCase("y")))
				out.println("<td  align='center' nowrap><input readonly  style='border:0px;background-color:"+colour+";text-align:right' class='inputBox' type='text' size='10' value='"+(int)Math.round(bean.getThisyear().doubleValue())+"'  name='"+yeartotal+"'></td>");
				else
				out.println("<td  align='center' nowrap><input type='hidden' value='"+(int)Math.round(bean.getThisyear().doubleValue())+"'><input class='inputBox' type='text' size='10' style='text-align:right' oldvalue='"+(int)Math.round(bean.getThisyear().doubleValue())+"' value='"+nf.format((int)Math.round(bean.getThisyear().doubleValue()))+"' onchange='javascript:ResetRevenue(this.value,"+d+","+gcount+",13)' name='"+yeartotal+"' id='"+yeartotal+"'></td>");
				Double[][] temp=new Double[2][12];
				temp=bean.getMonth(); 
				for(int m=0;m<12;m++){
				if(temp[1][m].intValue()<20)
				out.println("<td nowrap align='right'><input align='right' class='inputBox' type='text' size='10' oldvalue='"+(int)Math.round(temp[0][m].doubleValue())+"'  style='text-align:right' value='"+(int)Math.round(temp[0][m].doubleValue())+"'  onchange='javascript:ResetRevenue(this.value,"+d+","+gcount+","+m+");' name='"+monthname+"'></td>");
				else if(temp[1][m].intValue()>20)
				out.println("<td nowrap align='right'><input align='right' type='text' width='10' size='10' oldvalue='"+(int)Math.round(temp[0][m].doubleValue())+"' value='"+(int)Math.round(temp[0][m].doubleValue())+"' readonly='true' style='border:0px;background-color:"+colour+";text-align:right' name='"+monthname+"'></td>");
				}
				}
				out.println("<td id='"+mark+"'></td></tr>");
				
				gcount++;
			}
		}
			d++;
	}%>	
		<%	
				end=System.currentTimeMillis();
				System.out.println("It takes "+(start-end)+" ms to set the jsp;");		
		%>
		</table>
		<table >
		<tr>
		<td ><input type="button" class="button" value="BacktoList" onclick="javascript:window.location='selectBackLog.do';">
	<%	if (AOFSECURITY.hasEntityPermission("BACKLOG_REPORT", "_CREATE", session)) {%>
		<input type="submit" class="button" value="Save" onclick="javascript:document.frm1.status.value='draft';document.frm1.action='updateBackLog.do'">
			<input type="submit" class="button" value="Confirm" onclick="javascript:document.frm1.status.value='confirm';document.frm1.action='updateBackLog.do'">
	<%}%>
		<input type="submit" class="button" value="Export Excel" onclick="javascript:document.frm1.status.value='export';document.frm1.formaction.value='export';document.frm1.action='viewBackLog.do';">
		</td>
		</tr>
			<script language="javascript">
			
			function CalcTot()
			{
				var oCust;
				var ytot=0;//this year revenue
				var gtot=0;
				var oText;
				oCust=document.getElementsByName("projId");//get the records number
				oText=document.getElementsByName("RecordVal0");//get the month number
				oDpt=document.getElementsByName("department");//get the cycle number
				var oMonth;
				var smonth = new Array(oText.length);//to store the month TCV
				var yeartotal;
				var amount=0;	
				var record;
				var TCV=0.0;
				var gamount=0;
				var gTCV=0;
				var dptrecord;
				var gnum=0;
				var stot = new Array(oText.length);
				var mutalTCV=0;
				var str="ok";
				var purevalue=0;
				for(var j=0;j<oText.length;j++)
				{
					stot[j] = 0;//initial the data for use 
					smonth[j] = 0;
				}
				for( var d=0;d<oDpt.length;d++)
				{
							for(var t=0;t<12;t++)
						{
							stot[t] = 0;//initial the data for use 
						}
						dptrecord=document.getElementsByName("type"+d);
						for(var i=0 ;i<dptrecord.length;i++)//set every record's this year's total
						{
							ytot=0;
							oText=document.getElementsByName("RecordVal"+gnum);
							for(var j=0;j<oText.length;j++)
							{
								purevalue = oText[j].value.replace(/,/g, "");
								stot[j] = parseInt(stot[j]) + parseInt(purevalue);
								ytot = ytot + parseInt(purevalue);
							}
							oText=document.getElementsByName("yt"+gnum);
							oMark=document.getElementById("mark"+gnum);
							purevalue = oText[0].value.replace(/,/g, "");
							if(Math.round(purevalue)==parseInt(ytot)){
							oMark.innerHTML="OK";
								}
							else
							{
							oMark.innerHTML=parseInt(ytot);
							}
							purevalue = oText[0].value.replace(/,/g, "");		
							amount=parseInt(amount)+Math.round(parseInt(purevalue));
			
							gnum=gnum+1;
						}
							for(var j=0;j<12;j++)//set every department's monthly total
						{
							oMonth=document.getElementById("tSubTot"+d+j);
							oMonth.innerHTML=stot[j];
							smonth[j]=parseInt(smonth[j])+parseInt(oMonth.innerHTML);//set total month TCV
						}
						oTdtot=document.getElementById("yTCV"+d);
						oTdtot.innerHTML=amount;//set the department's all records' this year total
						gamount=parseInt(gamount)+parseInt(amount);//add the global TCV
						amount=0;
						
						oTdtot=document.getElementById("dTCV"+d);//set department all project's TCV
						oText=document.getElementsByName("sTCV"+d);
						for(var v=0;v<oText.length;v++)
						{
						purevalue = oText[v].value.replace(/,/g, "");
						TCV=TCV+parseInt(purevalue);	
						}
						oTdtot.innerHTML=TCV;
						gTCV=parseInt(gTCV)+parseInt(TCV);
						TCV=0;
				}
						/***set the global amount*****/
						for(var i=0;i<12;i++){//global Month TCV
						yeartotal=document.getElementById("atSubTot"+i);
						yeartotal.innerHTML=smonth[i];
						}
						yeartotal=document.getElementById("ayTCV");
						yeartotal.innerHTML=gamount;
						yeartotal=document.getElementById("adTCV");
						yeartotal.innerHTML=gTCV;
			}
			
				CalcTot();
				</script>
</table>
</form>
<br>

<%
}else{
	out.println("!!你没有相关访问权限!!");
}	
}catch (Exception ex){
	ex.printStackTrace();
}
%>
