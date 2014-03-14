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
<%try{%>
<%if (AOFSECURITY.hasEntityPermission("PAS_CAF_REPORT", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(1);
Num_formater.setMinimumFractionDigits(1);
Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
String dateStart = request.getParameter("dateStart");
String dateEnd = request.getParameter("dateEnd");
String EmployeeId = request.getParameter("EmployeeId");
if (EmployeeId == null) EmployeeId = "";
String category = request.getParameter("category");
if (category == null) category = "";
String departmentId = request.getParameter("departmentId");
if (departmentId == null) departmentId = "";
String project = request.getParameter("project");
if (project == null) project = "";
if (dateStart==null) dateStart=Date_formater.format(UtilDateTime.toDate(01,01,2005,0,0,0));
//if (dateStart==null) dateStart=Date_formater.format("2004-01-01 00:00:00.000");
if (dateEnd==null) dateEnd=Date_formater.format(nowDate);
Date dayStart;
if ( dateStart != null){
	dayStart = UtilDateTime.toDate2(dateStart + " 00:00:00.000");
}else{
	dayStart = UtilDateTime.toDate(01,01,2005,0,0,0);
}
Date dayEnd = UtilDateTime.toDate2(dateEnd + " 00:00:00.000");
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
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
	formObj.elements["FormAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
	formObj.elements["FormAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}

function fnEmail() {
	var formObj = document.frm;
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
	formObj.elements["FormAction"].value = "email";
	formObj.target = "_self";
	formObj.submit();
}

function mailStatus(){
	var status = "<%=(String)request.getAttribute("emailFlag")%>";
	//alert(status);
	if(status != null || status!=""){
		if(status == "emailSucess"){
			alert("Emails have been sended sucessed!");		
		}else if(status == "emailFalse"){
			alert("Sending emails  falsely! There was an error occured during sending emails.");
		}else if(status == "emailEmpty"){
			alert("There is no employee needs to send email.");
		}
	}
	status = null;
}

mailStatus();
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> Outstanding CAF Status Report </caption> 
<tr>
	<td>
		<Form action="pas.report.CAFStatusRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction">
		<table width=100%>
			<tr>
				<td colspan=8 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold" >&nbsp;Employee:&nbsp;</td>
				<td class="lblbold" ><input  type="text" class="inputBox" name="EmployeeId" size="12" value="<%=EmployeeId%>"></td>
				<td class="lblbold" >&nbsp;project:&nbsp;</td>
				<td class="lblbold" ><input  type="text" class="inputBox" name="project" size="12" value="<%=project%>"></td>
				<td class="lblbold" >&nbsp;Date Range :&nbsp;
					<input  type="text" class="inputBox" name="dateStart" size="12" value="<%=Date_formater.format(dayStart)%>"><A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.dateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
					~
					<input  type="text" class="inputBox" name="dateEnd" size="12" value="<%=Date_formater.format(dayEnd)%>"><A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.dateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
				</td>
			</tr>
			<tr>
				<td class="lblbold" >Department:</td>
				<td class="lblbold" >
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
				<td class="lblbold" >Category: </td>
				<td class="lblbold" >
					<select name="category">
						<option value ="">All</option>
						<option value ="FP" <%if (category.equals("FP")) out.print("Selected");%>>Fixed Price</option>
						<option value ="TM" <%if (category.equals("TM")) out.print("Selected");%>>Time & Material</option>
					</select>
				</td>
			<%
				boolean zeroflag = false;
				if (request.getParameter("zeroflag") != null) zeroflag = true;
			%>
			<td align="left" class="lblbold" >
				<input type=checkbox class="checkboxstyle" name="zeroflag" value="Y" <%if (zeroflag) out.print("Checked");%>>
				Include Zero Outstanding Day Results
			</td>
			</tr>
		</table>
		<table width=100%>
			<tr>	
			    <td width="70%"></td>
				<td align="left">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult();return false">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel();return false">
					<input TYPE="button" class="button" name="btnEmail" value="Send Email" onclick="javascript:fnEmail();return false">
				</td>
			</tr>
			<tr>
				<td colspan=8 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr bgcolor="#e9eee9">
				<td align=center  class="lblbold">&nbsp;Employee ID&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Employee Name&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Project&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Project Manager&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Category&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Customer Name&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;CAF Date&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Event&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Service Type&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;CAF Hours&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Outstanding Days&nbsp;</td>
			</tr>
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='12' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				double thr = 0; 
				int daytotal =0;
				for (int row =0; row < sr.getRowCount(); row++) {
					double hrs = sr.getDouble(row,"hrs");
					thr = thr + hrs;
					int dc = 0;
					if (sr.getInt(row,"dc")>0){
						dc = sr.getInt(row,"dc");
					}
					daytotal = daytotal+dc;
				%>
				
						<tr bgcolor="#e9eee1"> 
						<td class="lblbold" nowrap align=center><%= sr.getString(row,"tsm_userlogin")%></td>
						<td class="lblbold" nowrap align=left><%=sr.getString(row,"name")%></td>
						<td nowrap align=left><%=sr.getString(row,"pid")%> : <%=sr.getString(row,"pname")%></td>
						<td nowrap align=left><%=sr.getString(row,"pmname")%></td>
						<td nowrap align=left><%=sr.getString(row,"contracttype")%></td>
						<td nowrap align=left><%=sr.getString(row,"cname")%></td>
						<td nowrap align=center><%=Date_formater.format(sr.getDate(row,"date"))%></td>	
						<td nowrap align=left><%=sr.getString(row,"event")%></td>
						<td nowrap align=left><%=sr.getString(row,"servicetype")%></td>
						<td nowrap align=right><%=Num_formater.format(sr.getDouble(row,"hrs"))%></td>
						<td nowrap align=right><%=sr.getInt(row,"dc")<=0 ? 0 :sr.getInt(row,"dc") %></td>
	            </tr>
				<%}%>
				<TR bgcolor="#e9eee1"><td colspan = 9 class="lblbold" nowrap align=right>Total :</td>
				<td class="lblbold" nowrap align=right><%=thr%></td>
				<td class="lblbold" nowrap align=right><%=daytotal%></td>
				</tr>
			<%}%>
		</table>
	</td>
</tr>
</table>

<%
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
<%}catch(Exception e){
			e.printStackTrace();
		}%>