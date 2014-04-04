<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.TimeSheet.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
try {
if (AOFSECURITY.hasEntityPermission("TIME_SHEET", "_APPROVAL", session)) {
	
	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	String nowTimestampString = UtilDateTime.nowTimestamp().toString();
	DecimalFormat decFormat = (DecimalFormat)DecimalFormat.getNumberInstance();
	decFormat.setMaximumFractionDigits(1);
	decFormat.setMinimumFractionDigits(1);
	decFormat.setGroupingUsed(false);
	
	
	String UserId=request.getParameter("UserId");
	String DepartmentId=request.getParameter("DepartmentId");
	String DataPeriod=request.getParameter("DataId");
	String SelStatus = request.getParameter("SelStatus");
	
	if(UserId == null ) UserId = "";
	if(DepartmentId == null ) DepartmentId = "";
	if (SelStatus == null) SelStatus = "draft";
	String UserName = "";
	String UserParty = "";
	
	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	UserLogin ul = (UserLogin) hs.load(UserLogin.class, UserId);
	if (ul != null) UserName = ul.getName();
	Party up = (Party) hs.load(Party.class, DepartmentId);
	if (up != null) UserParty = up.getDescription();

	String DateStart = "";
	if (DataPeriod == null)  {
		DateStart = nowTimestampString;
	} else {
		DateStart = DataPeriod + " 00:00:00.000";
	}

	Date dayStart= UtilDateTime.toDate2(DateStart);
	String NextDataPeriod=Date_formater.format(UtilDateTime.getDiffDay(dayStart,7));
	String LastDataPeriod=Date_formater.format(UtilDateTime.getDiffDay(dayStart,-7));

	int i;
	int DayCount = 7;
	
	List QryList = (List)request.getAttribute("QryList");
	if(QryList==null){
		QryList = new ArrayList();
	}

	String FreezeFlag = (String)request.getAttribute("FreezeFlag");
	if (FreezeFlag == null) FreezeFlag = "N";

	String DayArray[];
	DayArray =  new String[DayCount];
	String[] WeekArray = { "Mon.", "Tue.", "Wed.", "Thur.", "Fri.", "Sat.", "Sun." };
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/projectSelect.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>

<script>
function gotoNeighberWeek(newData)
{
	document.EditTSApprovalForm.DataId.value =newData;
	document.EditTSApprovalForm.submit();
}
function Approval() {
	if(confirm("Do you really want to approve?")){
		var formObj = document.forms["EditTSApprovalForm"];
		formObj.elements["FormAction"].value = "Approval";
		formObj.submit();
	}
}
function Reject() {
	if(confirm("Do you really want to reject?")){
		var formObj = document.forms["EditTSApprovalForm"];
		formObj.elements["FormAction"].value = "Reject";
		formObj.submit();
	}
}
function BackToList() {
	var formObj = document.forms["EditTSApprovalForm"];
	formObj.elements["FormAction"].value = "Back";
	formObj.submit();
}
function On_StatusChange() {
	var formObj = document.forms["EditTSApprovalForm"];
	formObj.elements["FormAction"].value = "StatusChange";
	formObj.submit();
}
</script>
<Form action="editTSApproval.do" name="EditTSApprovalForm" method="post">
<input type="hidden" name="FormAction" id="FormAction">
<input type="hidden" name="hiddenProjectCode" id="hiddenProjectCode">
<input type="hidden" name="hiddenEventCode" id="hiddenEventCode">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall><bean:message key="prm.timesheet.approval.title"/></CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold"><bean:message key="prm.timesheet.departmentLable"/> :</td><td class="lblLight"><%=UserParty%></td>
				<td class="lblbold"><bean:message key="prm.timesheet.userLable"/> :</td><td class="lblLight"><%=UserName%></td>	
				<td class="lblbold"><bean:message key="prm.timesheet.entryPeriodLable"/> :</td><td class="lblLight"><%=DataPeriod%></td>
				<td class="lblbold">Status :</td>
				<td class="lblLight">
				<select name="SelStatus" onchange="javascript:On_StatusChange()">
					<option value='Submitted' <%if (SelStatus.equals("Submitted")) out.print("selected");%>>Submitted
					<option value='Approved' <%if (SelStatus.equals("Approved")) out.print("selected");%>>Approved
					<option value='Rejected' <%if (SelStatus.equals("Rejected")) out.print("selected");%>>Rejected
					<option value='' <%if (SelStatus.equals("")) out.print("selected");%>>All
				</select>
				</td>
			</tr>
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr bgcolor="#e9eee9">
				<td rowspan=2 class="lblbold" align="center" align=left><input type=checkbox  class="checkboxstyle" name=chkAll value="" onclick="javascript:checkUncheckAllBox(document.EditTSApprovalForm.chkAll,document.EditTSApprovalForm.chk)"></td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.projectLable"/></td>
				<td rowspan=2 class="lblbold" align="center">Customer</td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.staffLable"/></td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.eventLable"/></td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.servicetypeLable"/></td>
				<td rowspan=2 class="lblbold" align="center">Status</td>
				<td rowspan=2 class="lblbold" align="center">Need CAF</td>
				<%for (i=0;i < DayCount;i++) {
					DayArray[i] = Date_formater.format(UtilDateTime.getDiffDay(dayStart,i));
				%>
					<td class="lblbold" align="center" valign="top"><%=DayArray[i]%></td>
					<%
				}%>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.totalLable"/></td>
			</tr>
			<tr bgcolor="#e9eee9">
			<%for (i=0;i < DayCount;i++) {%>
				<td class="lblbold" align="center"><%=WeekArray[i]%></td>
			<%}%>
			</tr>
			<%
			Iterator it_ts = QryList.iterator();
			String CurrPart = "";
			String CurrProj = "";
			String CurrEvent = "";
			String CurrStaff = "";
			String DisplayText = "";
			String rowClass = "";
			String CAFDisplayText = "";
			String tsId = "";
			String CAFStatusUser = "";
			float rowCount = 0;
			float[] colCount = {0,0,0,0,0,0,0};
			Object[] findts = null;
			float totalCount = 0;
			int MaxCol = DayCount;
			int col = MaxCol;
			int row = 0;
			if (it_ts.hasNext()){
				while(it_ts.hasNext()){
					DisplayText = "";
					TimeSheetDetail ts = (TimeSheetDetail)it_ts.next();
					TimeSheetMaster tsm = (TimeSheetMaster)ts.getTimeSheetMaster();
					String NewPart = tsm.getTsmUser().getUserLoginId() + "$" + ts.getProject().getProjId() + "$" + ts.getProjectEvent().getPeventId().toString()+ "$" + ts.getTSServiceType().getId().toString();
					String NewProj = ts.getProject().getProjId();
					String NewEvent = ts.getProjectEvent().getPeventId().toString();
					String NewStaff = tsm.getTsmUser().getUserLoginId();
					String NewDate = Date_formater.format(ts.getTsDate());
					String tsStatus = null;
					if (!NewPart.equals(CurrPart)) {
						for (col=col; col < MaxCol; col++) {
							tsId = " ";
							DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId.toString()+"'>0</td>";
						}
						if (CurrPart != "" && col == MaxCol) {
							DisplayText = DisplayText+"<td>"+rowCount+"</td>";
						}
						rowClass = rowClass.equals("") ? "" : "";
						rowCount = 0;
						row++;
						tsStatus = ts.getStatus().trim();
						String DisableStr = "";
						//if (tsStatus.equals("Approved")) DisableStr = " disabled";
						if (NewProj.equals(CurrProj)) {
							DisplayText = DisplayText+"</tr><tr class='"+rowClass+"' align='right' bgcolor='#e9eee9'><td><input class=checkboxstyle type=checkbox name='chk' value='"+row+"' onclick='javascript:checkTopBox(document.EditTSApprovalForm.chkAll,document.EditTSApprovalForm.chk)'></td><td class='bottom' align='left'>&nbsp;</td><td class='bottom' align='left'>&nbsp;</td>";
							if (NewStaff.equals(CurrStaff)) {
								DisplayText = DisplayText+"<td class='bottom' align='left' nowrap>&nbsp;</td>";
								if (NewEvent.equals(CurrEvent)) {
									DisplayText = DisplayText+"<td class='bottom' align='left' nowrap>&nbsp;</td>";
								} else {
									DisplayText = DisplayText+"<td class='bottom' align='left' nowrap>"+ts.getProjectEvent().getPeventName()+"</td>";
								}
							} else {
								DisplayText = DisplayText+"<td class='bottom' align='left' nowrap>"+tsm.getTsmUser().getName()+"</td><td class='bottom' align='left' nowrap>"+ts.getProjectEvent().getPeventName()+"</td>";
							}
							DisplayText = DisplayText+"<td class='bottom' align='left' nowrap>"+ts.getTSServiceType().getDescription()+"</td><td class='bottom' align='center' nowrap>"+ts.getStatus()+"</td><td class='bottom' align='center' nowrap>"+ts.getProject().getCAFFlag()+"</td>";
						} else {
							DisplayText = DisplayText+"</tr><tr class='"+rowClass+"' align='right' bgcolor='#e9eee9'><td><input class=checkboxstyle type=checkbox name='chk' value='"+row+"' onclick='javascript:checkTopBox(document.EditTSApprovalForm.chkAll,document.EditTSApprovalForm.chk)'></td><td class='bottom' align='left' nowrap>"+ts.getProject().getProjId()+":"+ts.getProject().getProjName()+"</td><td class='bottom' align='left' nowrap>"+ts.getProject().getCustomer().getDescription()+"</td><td class='bottom' align='left' nowrap>"+tsm.getTsmUser().getName()+"</td><td class='bottom' align='left' nowrap>"+ts.getProjectEvent().getPeventName()+"</td><td class='bottom' align='left' nowrap>"+ts.getTSServiceType().getDescription()+"</td><td class='bottom' align='center' nowrap>"+ts.getStatus()+"</td><td class='bottom' align='center' nowrap>"+ts.getProject().getCAFFlag()+"</td>";
						}
						%>
						<input type="hidden" name="projId" id="projId" value = "<%=ts.getProject().getProjId()%>">
						<input type="hidden" name="PEventId" id="PEventId" value = "<%=ts.getProjectEvent().getPeventId()%>">
						<input type="hidden" name="PSTId" id="PSTId" value = "<%=ts.getTSServiceType().getId()%>">
						<%
						CurrPart = NewPart;
						CurrProj = NewProj;
						CurrEvent = NewEvent;
						CurrStaff = NewStaff;
						col = 0;
					}
					while (!DayArray[col].equals(NewDate)) {
						tsId = "";
						DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId+"'>0</td>";
						col++;
					}
					tsId = ts.getTsId().toString();
					DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId+"'>"+ts.getTsHoursUser().toString()+"</td>";
					totalCount = totalCount + ts.getTsHoursUser().floatValue();
					rowCount = rowCount + ts.getTsHoursUser().floatValue();
					colCount[col] = colCount[col] + ts.getTsHoursUser().floatValue();
					col++;
					out.println(DisplayText);
				}
				DisplayText ="";
				for (col=col; col < MaxCol; col++) {
					tsId = " ";
					DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId.toString()+"'>0</td>";
				}
				DisplayText = DisplayText+"<td>"+decFormat.format(rowCount)+"</td>";
				out.println(DisplayText);
			%>
			<tr align="center">
				<td align="left" colspan="8" class="lblbold"><bean:message key="prm.timesheet.totalLable"/>:</td>
				<td align="right" class="lblbold" id='tSubTot1'><%=decFormat.format(colCount[0])%></td>
				<td align="right" class="lblbold" id='tSubTot2'><%=decFormat.format(colCount[1])%></td>
				<td align="right" class="lblbold" id='tSubTot3'><%=decFormat.format(colCount[2])%></td>
				<td align="right" class="lblbold" id='tSubTot4'><%=decFormat.format(colCount[3])%></td>
				<td align="right" class="lblbold" id='tSubTot5'><%=decFormat.format(colCount[4])%></td>
				<td align="right" class="lblbold" id='tSubTot6'><%=decFormat.format(colCount[5])%></td>
				<td align="right" class="lblbold" id='tSubTot7'><%=decFormat.format(colCount[6])%></td>
				<td align="right" class="lblbold" id='tTot'><%=decFormat.format(totalCount)%></td>
			</tr>
			<%totalCount = 0;%>
			<%} else {
				DisplayText = "<tr><td colspan='14' align='center'>No Record Found.</td></tr>";
				out.println(DisplayText);
			}
			%>
			<tr align="center">
				<td align="left" colspan="14">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<!--
					<input TYPE="button" class="button" name="btnRow" value="Add Line" onclick="javascript: return fnRow()">&nbsp;&nbsp;
					-->
					<%
					if (FreezeFlag.equals("N")) {%>
						<input TYPE="button" class="button" name="Save" value="Approve selected" onclick="javascript:Approval()">&nbsp;&nbsp;
						<input TYPE="button" class="button" name="Save" value="Reject selected" onclick="javascript:Reject()">&nbsp;&nbsp;
					<%}%>
					<input TYPE="button" class="button" name="Back" value="Back" onclick="javascript:location.replace('listTSApproval.do')">
				   
				</td>
			</tr>
			<tr>
			<td></td>
			<td align="center"  >
			        	<a href="javascript:gotoNeighberWeek('<%=LastDataPeriod%>')"><image src="images/prev2.gif"  border="0"></a>  
			        	<a href="javascript:gotoNeighberWeek('<%=NextDataPeriod%>')"><image src="images/next.gif"  border="0"></a>  
			        </td>
			  <td colspan="10">  </td>      
			</tr>
		</table>
	</td>
</tr>
</table>
<input type="hidden" name="UserId" id="UserId" value="<%=UserId%>">
<input type="hidden" name="DepartmentId" id="DepartmentId" value="<%=DepartmentId%>">
<input type="hidden" name="DataId" id="DataId" value="<%=DataPeriod%>">
<input type="hidden" name="LastDataId" id="LastDataId" value="<%=LastDataPeriod%>">
<input type="hidden" name="NextDataId" id="NextDataId" value="<%=NextDataPeriod%>">
</form>
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}

		//Hibernate2Session.closeSession();
} catch(Exception ex) {ex.printStackTrace();}
%>