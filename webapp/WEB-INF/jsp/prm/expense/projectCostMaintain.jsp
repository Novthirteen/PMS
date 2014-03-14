<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.component.prm.expense.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.crm.vendor.VendorProfile"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld"prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld"prefix="tiles"%>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/projectCostMaintain.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script>
function showVendorDialog()
{
	var code,desc;
	with(document.ProjectListForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payto.dialog.title&crm.dialogVendorList.do",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelPayFor.innerHTML=code+":"+desc;			
			document.ProjectCostMaintainForm.payFor.value=code;
		}
	}
}
function onCurrSelect() {
	var formObj = document.forms["ProjectCostMaintainForm"];
	formObj.elements["FormAction"].value = "currencySelect";
	formObj.submit();
}
function showDialog(i) {
	var code,desc;
	with(document.ProjectCostMaintainForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&projectList.do?",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelProject.innerHTML=code+":"+desc;
			projId.value=code;
			proj.value=code+":"+desc;
		}
	}
}
function showDialog_staff(i) {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	
	if (v != null ) {
	        document.getElementsByName("staffId")[i].value=v.split("|")[0];
	        document.getElementsByName("staffName")[i].value=v.split("|")[1];
	        document.getElementsByName("staff")[i].value=v.split("|")[0]+":"+v.split("|")[1];
	    
		}
	
}
/*function showDialog_staff(i) {
	var formObj = document.forms["ProjectCostMaintainForm"];
	formObj.elements["hiddenNumber"].value = i;
	openStaffSelectDialog("onCloseDialog_staff" ,"ProjectCostMaintainForm");
}*/

function onCloseDialog_staff() {
	var formObj = document.forms["ProjectCostMaintainForm"];
	var i = formObj.elements["hiddenNumber"].value;
	setValue_staff("hiddenStaffCode","staffId");
	setStaffValue("hiddenStaffCode","hiddenStaffName","staff");	
}

function SaveRecords() {
	var formObj = document.forms["ProjectCostMaintainForm"];
	if (check(formObj)== false){
		return;
	}
	formObj.elements["FormAction"].value = "save";
	formObj.submit();	
}
function ConfirmRecords() {
	var formObj = document.forms["ProjectCostMaintainForm"];
	if (check(formObj)== false){
		return;
	}
	formObj.elements["FormAction"].value = "confirm";
	formObj.submit();	
}
function check(formObj) {
	var errorMessage = "";
	if(formObj.elements["totalValue"].value=="") {
		errorMessage = errorMessage + "<bean:message key="projectCostMaintain.errorMessage.totalValue"/>\n";
	}
	if (formObj.elements["costDate"].value=="") {
		errorMessage = errorMessage + "<bean:message key="projectCostMaintain.errorMessage.costDate"/>\n";
	}
	if (formObj.elements["projId"].value == "") {
		errorMessage = errorMessage + "<bean:message key="projectCostMaintain.errorMessage.projName"/>\n";
 	}
	if (errorMessage != "") {
		alert(errorMessage);
		return false;
	}
	return true;
	
}
function OnDelete() {
	var formObj = document.forms["ProjectCostMaintainForm"];
	formObj.elements["FormAction"].value = "delete";
	formObj.submit();
}
</script>
<%

	ProjectCostMaster findmaster = (ProjectCostMaster)request.getAttribute("findmaster");
	String DataId=request.getParameter("DataId");
	if(DataId == null ) DataId = "";
	if (findmaster != null) DataId = findmaster.getCostcode().toString();
	NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
	String FreezeFlag = (String)request.getAttribute("FreezeFlag");
	if (FreezeFlag == null) FreezeFlag = "N";
	
	String Type=request.getParameter("Type");
    if (Type == null) Type = "";
    String tt = "";
    if (Type.equals("Expense")) {
		tt = "OTHER_COST";
	}else{
		tt = "PROCU_SUB";
	}
		
    if (AOFSECURITY.hasEntityPermission(tt, "_CREATE", session)) {
%>

<Form action="projectList.do" name="ProjectListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
</Form>
<Form action="userList.do" name="UserListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
</Form>
<html:form action="projectCostMaintain.do"  method="post">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<input type="hidden" name="FormAction">
<input type="hidden" name="hiddenNumber">
<input type="hidden" name="Type" value="<%=Type%>">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table border="0" width="100%" cellspacing="0" cellpadding="0">
	<tr>
	<!-- Left Spacer -->
	<td width=1%>
	<img src="images/spacer.gif" width="2" height="1" border="0">
	</td>
	<td width="98%" valign="bottom" align="right">
		<!-- Contents -->
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<!-- Document Header Information -->
			<tr height="15">
				<td colspan=3><img src="images/spacer.gif" width="4" height="4" border="0"></td>
			</tr>
			<!-- Area Header Information -->
			<tr height="15">
				<td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/corner1black.gif" width="4" height="4" border="0"></td>
				<td class="lblbold" bgcolor="#b4d4d4"><bean:message key="prm.projectCostMaintain.title"/></td>
				<td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/corner2black.gif" width="4" height="4" border="0"></td>
			</tr>
			<!-- Area Contents Information -->
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
					<tr>
						<td class="lblbold" nowrap width=20%><bean:message key="prm.projectCostMaintain.refNoLable"/>:&nbsp</td>
						<td class="lblbold" nowrap width=30%>&nbsp;
							<html:text property="refNo" size="30"/></td>
						<td class="lblbold" nowrap width=20%><bean:message key="prm.projectCostMaintain.costDescriptionLable"/>&nbsp</td>
						<td class="lblbold" width=30%>&nbsp;
							<html:text property="costDescription" size="30"/>
						</td>
					</tr>
					<%
					//List DetResult = (List)request.getAttribute("QryDetail");
					//if(DetResult==null){
					//	DetResult = new ArrayList();
					//}
					//Iterator it = DetResult.iterator();
					//String pcdId = request.getParameter("pcdId");
					String projId = request.getParameter("projId");
					String proj = request.getParameter("proj");
					String staffId = request.getParameter("staffId");
					String staff = request.getParameter("staff");
					String payFor = null;
					String vendor = null;
							
					for (int i = 0; i < 1 ; i++) {
						if (findmaster != null){
						//	ProjectCostDetail pcd = (ProjectCostDetail)it.next();
							if (proj == null) proj = findmaster.getProjectMaster().getProjId()+":"+findmaster.getProjectMaster().getProjName();
							//pcdId[i] = new Integer(pcd.getPcdid()).toString();
							if (projId == null) projId = findmaster.getProjectMaster().getProjId();
							UserLogin ul = findmaster.getUserLogin();
							if(findmaster.getPayFor() != null)
								payFor = findmaster.getPayFor();
							else
							    payFor = "";
							    
							VendorProfile vp = findmaster.getVendor();
							if(vp != null)
								vendor = payFor+":"+vp.getDescription();
							else
								vendor = "";
								
							if (ul == null) {
								if (staffId == null) staffId = "";
								if (staff == null) staff = "";
							} else {
								if (staffId == null) staffId = ul.getUserLoginId();
								if (staff == null) staff = ul.getUserLoginId()+":"+ul.getName();
							}
							
						}else{
							if (proj == null) proj = "";
							//if (pcdId[i] == null) pcdId[i] = "";
							if (projId == null) projId = "";
							if (staffId == null) staffId = "";
							if (staff == null) staff = "";
							if (payFor == null) payFor = "";
							if (vendor == null) vendor = "";
							
						}
					%>
					<tr>
						<td class="lblbold" nowrap><bean:message key="prm.timesheet.projectLable"/>:&nbsp</td>
						<td class="lblbold" nowrap>&nbsp;
							<div style="display:inline" id="labelProject"><%=proj%></div>
							<a href="javascript:void(0)" onclick="showDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0" /></a>
							<input type = "hidden" name = "projId" value="<%=projId%>">
							<input type = "hidden" name = "proj" value="<%=proj%>">
						</td>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.staffNameLable"/>:&nbsp</td>
						<td class="lblbold">&nbsp;
							<input type = "text" readonly="true" name = "staff" size="30" value="<%=staff%>">
							<input type = "hidden" name = "staffId" value="<%=staffId%>">
							<input type = "hidden" name = "staffName">
							<a href='javascript: showDialog_staff(<%=i%>)'><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
						</td>
					</tr>
					<%}%>
					<tr>
						<td class="lblbold" nowrap>Cost <bean:message key="prm.projectCostMaintain.typeLable"/>:&nbsp</td>
						<td class="lblbold" nowrap>&nbsp;
							<html:select property = "typeSelect" size="1">
							<html:optionsCollection name="typeSelectArr" value="key" label="value" />
							</html:select>							
						</td>
				
					<%
						if (Type.equals("Expense"))
						{
					%>	
						<td class="lblbold" nowrap>Paid By:&nbsp</td>
						<td class="lblbold" nowrap>&nbsp;
							<html:select property = "ClaimTypeSelect" size="1">
								<html:optionsCollection name="ClaimTypeSelectArr" value="key" label="value" />
							</html:select>
						</td>
					</tr>
					<tr>
					<%}%>
					
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.PayForLable"/>:&nbsp</td>
						<td class="lblbold" nowrap>&nbsp;
							<div style="display:inline" id="labelPayFor">
								<%=vendor%>
							</div>
							<input type=hidden name="payFor" value="<%=payFor%>">
							<a href="javascript:void(0)" onclick="showVendorDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
							
						</td>
							
						<td class="lblbold" nowrap>&nbsp</td>
						<td class="lblbold">&nbsp;
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.currencyLable"/>:&nbsp</td>
						<td class="lblbold" nowrap>&nbsp;
							<html:select property = "currencySelect" onchange = "javascript:onCurrSelect()" size="1">
							<html:optionsCollection name="currencySelectArr" value="key" label="value" />
							</html:select>	
						</td>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.exchangeRateLable"/>(RMB):&nbsp</td>
						<td class="lblbold">&nbsp;
							<html:text property="exchangeRate" size="30"/>
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.totalValueLable"/> (RMB) :&nbsp</td>
						<td class="lblbold">&nbsp;
							<html:text property="totalValue" size="30" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999); addComma(this, '.', '.', ',');"/>
						</td>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.costDateLable"/>(YYYY-MM-DD):&nbsp</td>
						<td class="lblbold">&nbsp;
							<html:text property="costDate" size="30"/>
							<A href="javascript:ShowCalendar(document.ProjectCostMaintainForm.dimg,document.ProjectCostMaintainForm.costDate,null,0,330)" 
								onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.createDateLable"/>:&nbsp</td>
						<td class="lblbold">&nbsp;
							<bean:write name="createDate"/></td>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.approvalDateLable"/>:&nbsp</td>
						<td class="lblbold">&nbsp;
							<bean:write name="approvalDate"/></td>
					</tr>
					<tr>
						<td colspan=4>
						<%
							String approvalDate = (String)request.getAttribute("approvalDate");
						%>
							<%if (FreezeFlag.equals("N") && (approvalDate == null || approvalDate.trim().length() == 0)) {%>
							<%System.out.println("approval Date:"+approvalDate);%>
							<input TYPE="button" class="button" name="save" value="Save" onclick="javascript:SaveRecords()">&nbsp;&nbsp;
							<%}%>
							<%if (FreezeFlag.equals("N")) {%>
							<%System.out.println("FreezeFlag:"+FreezeFlag);%>
							<input TYPE="button" class="button" name="confirm" value="Confirm" onclick="javascript:ConfirmRecords()">&nbsp;&nbsp;
							<%}%>
							<%if (FreezeFlag.equals("N") && (approvalDate == null || approvalDate.trim().length() == 0)) {%>
							<input TYPE="button" class="button" name="delete" value="Delete" onclick="javascript:OnDelete()">&nbsp;&nbsp;
							<%}%>
							<input type="button" value="Back to List" name="Back" class="button" onclick="location.replace('findCostSelfPage.do?Type=<%=Type%>');">
						</td>
					</tr>
				</table>
				</td>
				<td></td>
			</tr>
			<!-- Area Footer Information -->
			<tr height="8">
				<td width="8" bgcolor="#deebeb" valign="bottom" align="left"><img src="images/corner3grey.gif" width="4" height="4" border="0"></td>
				<td bgcolor="#deebeb"><img src="images/spacer.gif" width="1" height="8" border="0"></td>
				<td width="8" bgcolor="#deebeb" valign="bottom" align="right"><img src="images/corner4grey.gif" width="4" height="4" border="0"></td>
			</tr>
		</table>
	</td>
	<!-- Right Spacer -->
	<td width=1%>
	<img src="images/spacer.gif" width="2" height="1" border="0">
	</td>
	</tr>
</table>
<input type="hidden" name="DataId" value="<%=DataId%>">
</html:form>
<%
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
