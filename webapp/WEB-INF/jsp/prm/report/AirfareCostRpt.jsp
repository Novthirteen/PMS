<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.crm.vendor.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.report.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
if (AOFSECURITY.hasEntityPermission("AIRFARE_COST_RPT", "_VIEW", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
String date_begin = request.getParameter("date_begin");
String date_end	= request.getParameter("date_end");
String staff = request.getParameter("staff");
String fli_no = request.getParameter("fli_no");
String tCode = request.getParameter("tCode");
String project = request.getParameter("project");
String status = request.getParameter("status");
String last_export = request.getParameter("last_export");
String vendor = request.getParameter("vendor");
String flag_ctrip = request.getParameter("flag_ctrip");
String flag_desc = request.getParameter("flag_desc");
String flag_export = request.getParameter("flag_export");

String offSetStr = request.getParameter("offSet");
	int offSet = 0;
	if (offSetStr != null && offSetStr.trim().length() != 0) {
		offSet = Integer.parseInt(offSetStr);
	}
	
	int i = offSet+1;
    
	final int recordPerPage = 20;

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

if (date_begin == null) {
	//date_begin = dateFormat.format(UtilDateTime.toDate(01,01,2005,0,0,0));
	date_begin = "";
}

if (date_end == null) {
	//date_end = dateFormat.format(new Date());
	date_end = "";
}

if (staff == null) {
	staff = "";
}

if(fli_no == null){
	fli_no = "";
}
if(tCode == null){
	tCode = "";
}

if (project == null) {
	project = "";
}

if(status == null){
	status = "";
}

if(last_export == null){
	last_export = "";
}

if (vendor == null) {
	vendor = "";
}

if(flag_ctrip == null){
	flag_ctrip = "";
}

if(flag_desc == null){
	flag_desc = "";
}

if(flag_export == null){
	flag_export = "";
}
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
%>

<script language="javascript">
function SearchResult() {
	var formObj = document.frm;
	formObj.formAction.value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportToExcel() {
	var formObj = document.frm;
	formObj.formAction.value = "ExportToExcel";
	formObj.submit();
}
function PayoutSelected() {
	var formObj = document.frm;
	formObj.formAction.value = "PayoutSelected";
	formObj.submit();
}
function ExportForFA() {
	var formObj = document.frm;
	formObj.formAction.value = "ExportForFA";
	formObj.submit();
}
function fnSubmit1(start) {
	with (document.frm) {
		formAction.value="QueryForList";
		offSet.value=start;
		submit();
	}
}
function showProjctDialog() {
	var code,desc;
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.project.dialog.title&projectList.do?projProfileType=C",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null && v.length > 8) {
			projectCode=v.split("|")[0];
			projectName=v.split("|")[1];
			contractType=v.split("|")[2];
			departmentId=v.split("|")[3];
			departmentNm=v.split("|")[4];
			billToId=v.split("|")[5];
			billToNm=v.split("|")[6];
			pmId=v.split("|")[7];
			pmName=v.split("|")[8];
			//labelProject.innerHTML=projectCode+":"+projectName;

			project.value=projectCode;
			//textname.value=projectName;
		}
	}
}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<Form action="pas.report.AirfareCostRpt.do" name="frm" method="post">
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">Airfare Cost Report</caption> 
	<tr>
		<td>
				<input type="hidden" name="formAction">
				<input type="hidden" name="recordPerPage" value="<%=recordPerPage%>">
				<input type="hidden" name="offSet" value="0">
				<table width=100% >
					<tr>
						<td colspan="16" valign="bottom"><hr color=red></hr></td>
					</tr>
					<tr>
						<td class="lblbold">Project:</td>
						<td class="lblLight">
							<!--<input type="text" class="inputBox" name="project" size="12" value="<%=project%>">-->
							<input type="text" name="project" size="25" value="<%=project%>" style="TEXT-ALIGN: right" class="lbllgiht">
							<a href="javascript:void(0)" onclick="showProjctDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						</td>
						<td class="lblbold">Status:</td>
						<td class="lblLight">
							<select name="status">
								<option value="posted" <%if(status.equals("posted")) out.print("selected");%>>Post to F&A</option>
								<option value="confirmed" <%if(status.equals("confirmed")) out.print("selected");%>>Confirmed</option>
								<option value="unconfirmed" <%if(status.equals("unconfirmed")) out.print("selected");%>>Not Confirmed</option>
								<option value="paid" <%if(status.equals("paid")) out.print("selected");%>>Paid</option>
								<option value="">All</option>
							</select>
						</td>
						<td class="lblbold">Last Export Date:</td>
						<td class="lblLight">
							<input  type="text" class="inputBox" name="last_export" size="12" value="<%=last_export%>">
							<A href="javascript:ShowCalendar(document.frm.dimg3,document.frm.last_export,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg3 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
					</tr>
			
					<tr>
						<td class="lblbold">Issue Date Range:</td>
						<td class="lblLight">
							<input  type="text" class="inputBox" name="date_begin" size="12" value="<%=date_begin%>">
							<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.date_begin,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
							&nbsp;~&nbsp;<input  type="text" class="inputBox" name="date_end" size="12" value="<%=date_end%>">
							<A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.date_end,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
						<td class="lblbold">Flight No. :</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="fli_no" size="12" value="<%=fli_no%>">
						</td>
						<td class="lblbold">Ticket Code :</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="formcode" size="12" value="<%=tCode%>">
						</td>
					</tr>
					<tr>						
						<td class="lblbold">Vendor:</td>
						<td class="lblLight">
							<!--two vendors only (for our company),
								if it is needed to list all vendors , please remove the annotation
							-->
							<select name="vendor">
								<option value="">All</option>
								<%
								/*	VendorService vs = new VendorService();
									Iterator vendor_ite = vs.getAllVendor(hs).iterator();
									while(vendor_ite.hasNext()){
										VendorProfile vp = (VendorProfile)vendor_ite.next();
								*/
								%>
												
						<!--	symbols "/" in the following line should be removed when listing all vendors 								
						<!--	<option value="</%=vp.getPartyId()%/>"></%=vp.getDescription()%/></option> -->
								
								<%
								//	}
								%>
								
								<!--two vendors-->
								<option value="V000061" <%if(vendor.equals("V000061")) out.print("selected");%>>ShanLian</option>
								
								<option value="V000068" <%if(vendor.equals("V000068")) out.print("selected");%>>ShengYuan</option>
							</select>
						</td>
						<td><input type="checkbox" class="checkboxstyle" name="flag_ctrip" value="Y" <%if(!flag_ctrip.equals("")) out.print("checked");%>>Show C-Trip price</td>
						<td><input type="checkbox" class="checkboxstyle" name="flag_desc" value="Y" <%if(!flag_desc.equals("")) out.print("checked");%>>Show Additional Cost Description</td>
						<td colspan="2"><input type="checkbox" class="checkboxstyle" name="flag_export" value="Y" <%if(!flag_export.equals("")) out.print("checked");%>>Including Exported Records</td>
						
					</tr>
					<tr>
						<td colspan="3"/>
						<td colspan="5">
							<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
							<input TYPE="button" class="button" name="btnExcel" value="Export To Excel" onclick="javascript: ExportToExcel()">
							<%if (AOFSECURITY.hasEntityPermission("AIRFARE_RPT_FA", "_VIEW", session)) {%>
							<input TYPE="button" class="button" name="btnPay" value="Pay Out" onclick="javascript: PayoutSelected()">
							<input TYPE="button" class="button" name="btnExcel" value="Export For FA" onclick="javascript: ExportForFA()">
							<%}%>
						</td>
					</tr>
					<tr>
						<td colspan="16" valign="top"><hr color=red></hr></td>
					</tr>
				</table>
		</td>
	</tr>
	<!---->
	<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr bgcolor="#e9eee9">
				<td class="lblbold" width="1%"><input type=checkbox class="checkboxstyle" name=chkAll value='' onclick="javascript:checkUncheckAllBox(document.frm.chkAll,document.frm.chk)">&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Ticket Code&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Project ID&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Staff&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Description &nbsp;</td>
				<td align=center class="lblbold">&nbsp;Create Date&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Flight No.&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Issue Date&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Confirm Date&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Price (RMB)&nbsp;</td>
			<%if(flag_ctrip.equals("Y")){%>
				<td align=center class="lblbold">&nbsp;C-trip Price (RMB)&nbsp;</td>
			<%}%>
				<td align=center class="lblbold">&nbsp;Vendor&nbsp;</td>
			<%if(flag_desc.equals("Y")){%>
				<td align=center class="lblbold">&nbsp;Description&nbsp;</td>
			<%}%>
				<td align=center class="lblbold">&nbsp;Status&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Last Export Date&nbsp;</td>
			</tr>
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			Object resultSet_data;
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='15' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				// define several string variables to make groups upon the record
					String newPid = "";
					String oldPid = "";
				for (int row=offSet; (row<offSet+recordPerPage) && (row<sr.getRowCount()); row++) {	
				%>
					<tr bgcolor="#e9eee1"> 
						<td align="center">
	                		<input type=checkbox class="checkboxstyle" name=chk value="<%=sr.getInt(row,"costcode")%>">
               		 	</td>
               		 	<td align=left><%= sr.getString(row,"formcode")%></td>
						<td align=left><%=(sr.getString(row,"proj_id") == null) ? "" : sr.getString(row,"proj_id")%></td>
						<td align=left><%=(sr.getString(row,"staff") == null) ? "" : sr.getString(row,"staff")%></td>
						<td align=left><%=(sr.getString(row,"payment_type") == null) ? sr.getString(row,"proj_name") : sr.getString(row,"payment_type")%></td>
						<td align=left><%=sr.getString(row,"cre_date")%></td>
						<td align=left><%=sr.getString(row,"fli_no")%></td>
						<td align=left><%=sr.getString(row,"fli_date")%></td>
						<td align=left><%=(((resultSet_data = sr.getObject(row,"confirm_date"))==null) ? "":resultSet_data)%></td>
						<td align=left><%=sr.getDouble(row,"price")%></td>
					<%if(flag_ctrip.equals("Y")){%>
						<td align=left><%=sr.getDouble(row,"c_trip_price")%></td>
					<%}%>
						<td align=left><%=sr.getString(row,"v_name")%></td>
					<%if(flag_desc.equals("Y")){%>
						<td align=left><%=sr.getString(row,"cost_desc")%></td>
					<%}%>
						<td align=left><%=sr.getString(row,"payment_status")%></td>
						<td align=left><%=(((resultSet_data = sr.getObject(row,"ex_date"))==null) ? "":resultSet_data)%></td>
					</tr>
				<%}
			}%>
			<tr>
				<td width="100%" colspan="17" align="right" class="lblbold">Pages&nbsp;:&nbsp;					
					<%
					int recordSize = 0;
					if(findData)
						recordSize = sr.getRowCount();
						
					for (int j0 = 0; j0 < Math.ceil((double)recordSize / recordPerPage); j0++) {
						if (j0 == offSet / recordPerPage) {
					%>
					&nbsp;<font size="3"><%=j0 + 1%></font>&nbsp;
					<%
						} else {
					%>
					&nbsp;<a href="javascript:fnSubmit1('<%=j0 * recordPerPage%>')" title="Click here to view next set of records"><%=j0 + 1%></a>&nbsp;
					<%
						}
					}
					%>
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</form>
<%
}else{
	out.println("没有访问权限.");
}
} catch(Exception ex) {
	ex.printStackTrace();
}
%>