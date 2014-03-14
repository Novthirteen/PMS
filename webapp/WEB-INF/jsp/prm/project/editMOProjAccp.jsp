<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="net.sf.hibernate.type.*"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.component.prm.Bill.BillTransactionDetail"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="net.sf.hibernate.Query"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

<%try {
if (AOFSECURITY.hasEntityPermission("PROJECT_ACCP", "_CREATE", session)) {
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();
SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
NumberFormat nf = NumberFormat.getInstance();

SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
//String DataId = request.getParameter("DataId");
//if (DataId == null) DataId ="";

List partyList = null;
List partyList_dep = null;
List ptList = null;
List pcList = null;
List userLoginList = null;
String ProjId = "";
int i=1;
ProjectMaster CustProject = (ProjectMaster)request.getAttribute("CustProject");
if(CustProject!=null)
ProjId = CustProject.getProjId();
List MaterialList = (List)request.getAttribute("MaterialList");
if(MaterialList==null){
	MaterialList = new ArrayList();
}
try{
	PartyHelper ph = new PartyHelper();
	partyList = ph.getAllCustomers(hs);
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
	if (partyList_dep == null) partyList_dep = new ArrayList();
	partyList_dep.add(0,ul.getParty());
	UserLoginHelper ulh = new UserLoginHelper();
	userLoginList = ulh.getAllUser(hs);
	//get all project type
	ProjectHelper proh= new ProjectHelper();
	ptList=proh.getAllProjectType(hs);
	pcList=proh.getAllProjectCategory(hs);
}catch(Exception e){
	e.printStackTrace();
}

String action = request.getParameter("action");
if(action == null){
	action = "view";
}
String FreezeFlag = "";
String sFreezeFlag = "";
//String isChecked ="";
%>

<script language="javascript">
function showDialog(option) {
//	document.aform.FormAction.value = "action";
	var dataId = document.aform.DataId.value;
	var param = "option="+option+"&hiddenDataId="+dataId;
	param = param + "&formAction=add";
	v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectacceptence.addMaterial.title&addMaterial.do?"+param,
			null,
			'dialogWidth:900px;dialogHeight:550px;status:no;help:no;scroll:no');
	document.aform.FormAction.value="view";
	document.aform.submit();
}
function showEditDialog(indexid) {
	var dataId = document.aform.DataId.value;
	var param = "index="+parseInt(indexid)+"&hiddenDataId="+dataId;
	param = param + "&formAction=edit";
	v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectacceptence.addMaterial.title&addMaterial.do?"+param,
			null,
			'dialogWidth:900px;dialogHeight:550px;status:no;help:no;scroll:no');
	document.aform.FormAction.value="view";
	document.aform.submit();
}

function FnUpdate() {
	document.aform.FormAction.value = "update";
	document.aform.submit();
}

function checkchk() {
	
	if (isChecked="checked")  isChecked = "";

	if (isChecked="")  isChecked = "checked";
	
	}
	
function fnset(count)
{
//var oST = document.getElementsByName("btid"+count);
document.aform.tr.value = count;
document.aform.FormAction.value='delete';
document.aform.submit();
}
</script>

<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall>  Service Delivery Acceptance Update </CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
	<TR>
		<TD width='100%'>
			<form action="editMOProjAccp.do" method="POST" name="aform">
			<input type="hidden" name="FormAction">
			
				<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
							marginWidth=0 noResize 
							scrolling=no src="includes/date/calendar.htm" 
							style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
				</IFRAME>
				<table width='100%' border='0' cellpadding='0' cellspacing='2'>
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Project Code :&nbsp;</span>
						</td>
						<td>
							<span class="tabletext"><%=CustProject.getProjId()%>&nbsp;</span>	
							<input type="hidden" name="DataId" value="<%=CustProject.getProjId()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Project Description :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><%=CustProject.getProjName()%>&nbsp;</span>
							<input type="hidden" name="projName" value="<%=CustProject.getProjName()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Project Status :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><%=CustProject.getProjStatus()%>&nbsp;</span>
							<input type="hidden" name="projectStatus" value="<%=CustProject.getProjStatus()%>">
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Contract No :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><%=CustProject.getContractNo()%>&nbsp;</span>
							<input type="hidden" name="contractNo" value="<%=CustProject.getContractNo()%>">
						</td>
						<%if (CustProject.getProjectCategory().getId().equals("C")){%>
						<td align="right" class="lblbold">
							<span class="tabletext">Customer :&nbsp;</span>
						</td>
						<td>
							<span class="tabletext"><%=CustProject.getCustomer().getPartyId()%>:<%=CustProject.getCustomer().getDescription()%>&nbsp;</span>
							<input type="hidden" name="customerId" value="<%=CustProject.getCustomer().getPartyId()%>:<%=CustProject.getCustomer().getDescription()%>">
						</td>
						<%}%>
						<%if (CustProject.getProjectCategory().getId().equals("P")){%>
						<td align="right" class="lblbold">
							<span class="tabletext">Supplier :&nbsp;</span>
						</td>
						<td>
							<span class="tabletext"><%=CustProject.getVendor().getPartyId()%>:<%=CustProject.getVendor().getDescription()%>&nbsp;</span>
						</td>
						<%}%>
						<td align="right" class="lblbold">
							<span class="tabletext">Department :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><%=CustProject.getDepartment().getDescription()%>&nbsp;</span>
							<input type="hidden" name="departmentId" value="<%=CustProject.getDepartment().getDescription()%>">
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Project Manager :&nbsp;</span>
						</td>
						<td align="left">
							<%String PMId = "";
							String PMName = "";
							if (CustProject.getProjectManager() != null) {
							PMId = CustProject.getProjectManager().getUserLoginId();
							PMName = CustProject.getProjectManager().getName();
							}
							%>
							<span class="tabletext"><%=PMName%>&nbsp;</span>
							<input type="hidden" name="projectManagerId" value="<%=PMId%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext"> Open for All :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><% if (CustProject.getPublicFlag().equals("N")) out.print("NO"); else out.print("YES"); %>&nbsp;</span>
							<input type="hidden" name="PublicFlag" value="<%=CustProject.getPublicFlag()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Contract Type :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><% if (CustProject.getContractType().equals("FP")) out.print("Fixed Price"); else out.print("Time & Material");%>&nbsp;</span>
							<input type="hidden" name="ContractType" value="<%=CustProject.getContractType()%>">
						</td>
					</tr>	 
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Total Service Value(RMB) :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><%=Num_formater.format(CustProject.gettotalServiceValue())%>&nbsp;</span>
							<input type="hidden" name="totalServiceValue" value="<%=CustProject.gettotalServiceValue()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Total Proc./Sub Value(RMB) :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><%=Num_formater.format(CustProject.gettotalLicsValue())%>&nbsp;</span>
							<input type="hidden" name="totalLicsValue" value="<%=CustProject.gettotalLicsValue()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Service Budget(RMB) :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><%=Num_formater.format(CustProject.getPSCBudget())%>&nbsp;</span>
							<input type="hidden" name="PSCBudget" value="<%=CustProject.getPSCBudget()%>">
						</td>
					</tr> 
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Expense Budget(RMB) :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><%=Num_formater.format(CustProject.getEXPBudget())%>&nbsp;</span>
							<input type="hidden" name="EXPBudget" value="<%=CustProject.getEXPBudget()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Proc./Sub Budget(RMB) :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><%=Num_formater.format(CustProject.getProcBudget())%>&nbsp;</span>
							<input type="hidden" name="procBudget" value="<%=CustProject.getProcBudget()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Need CAF :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><% if (CustProject.getCAFFlag().equals("N")) out.print("NO"); else out.print("YES");%>&nbsp;</span>
							<input type="hidden" name="CAFFlag" value="<%=CustProject.getCAFFlag()%>">
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Parent Project :&nbsp;</span>
						</td>
						<td align="left">
							<%
							String ProjName = "";
							if (CustProject.getParentProject() != null) {
							ProjId = CustProject.getParentProject().getProjId();
							ProjName = CustProject.getParentProject().getProjName();
							}%>
							<div style="display:inline" id="labelParentProject"><%=ProjId%>:<%=ProjName%>&nbsp;</div>
							<input type=hidden name="ParentProjectId" Value="<%=ProjId%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Start Date :&nbsp;</span>
						</td>
						<td>
							<span class="tabletext"><%=formater.format((java.util.Date)CustProject.getStartDate())%>&nbsp;</span>
							<input type="hidden" name="startDate" value="<%=formater.format((java.util.Date)CustProject.getStartDate())%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">End Date :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><%=formater.format((java.util.Date)CustProject.getEndDate())%>&nbsp;</span>
							<input type="hidden" name="endDate" value="<%=formater.format((java.util.Date)CustProject.getEndDate())%>">
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Allowance Rate :&nbsp;</span>
						</td>
						<td>
							<span class="tabletext"><%=Num_formater.format(CustProject.getPaidAllowance())%>&nbsp;</span>
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Project Category :&nbsp;</span>
						</td>
						<%if (CustProject.getProjectCategory().getId().equals("C")){%>
						<td>
							<span class="tabletext">Contract&nbsp;</span>
						</td>
						<%}%>
						<%if (CustProject.getProjectCategory().getId().equals("P")){%>
						<td>
							<span class="tabletext">PO&nbsp;</span>
						</td>
						<%}%>
					</tr>
				</table>
		</TD>
	</TR>
</TABLE>
<tr>
				<td colspan=6 valign="top"><hr color=red></hr></td>
			</tr>
<TABLE border=0 width='100%' cellspacing='1' cellpadding='1' >

	<TR>
		<TD width='100%'>
			<table width='100%' border='0' cellspacing='0' cellpadding='0'>
				<tr>
					<TD align=left width='90%' class="wpsPortletTopTitle">Project Billing/Payment Schedule List</TD>
				</tr>
			</table>
		</TD>
	</TR>
	
	<TR>
		<TD width='100%'>
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr bgcolor="#e9eee9">	
					<td class="lblbold">&nbsp;#&nbsp</td>
					
					<td  class="lblbold">&nbsp;Description&nbsp;</td>
					<td  class="lblbold">&nbsp;Total&nbsp;</td>
					<td class="lblbold">&nbsp;Action&nbsp;</td>
				</tr>
								<input type='hidden' name='trid' >
					<%
					if(MaterialList.size()>0){
					for (int j = 0; j < MaterialList.size() ; j++) {
						System.out.println(ProjId);
						Hashtable record = (Hashtable)MaterialList.get(j);
						Long trid = (Long)record.get("id");
						Long index = (Long)record.get("index");
						double amount = ((Double)record.get("amount")).doubleValue();
						String desc = (String)record.get("desc");
						int mstrid = ((Integer)record.get("mstrid")).intValue();
//						String btid="btid"+(j+1);
						System.out.println(index);
					%>
				<tr>
				<td id='index'><%=nf.format(index.intValue())%></td>				
				
				<td><%=desc%></td>
				<td><a href="javascript:void(0)" onclick="showEditDialog('<%=index%>');event.returnValue=false;">
				<%=Num_formater.format(amount)%></a>
				</td>
				<%if(mstrid==0){%>
				<td><input type="button" class="button" value='Delete' onClick="javascript:fnset('<%=trid.longValue()%>')"></td>
				<%}else{%>
				<td>&nbsp;</td>
				<%}%>
				</tr>
				<%}}
				else
				{
				%>
				<tr>
					<td colspan="5" align="center">
						<font color="red">
				<%
				out.println("no records");
				%>
						</font>
					</td>
				</tr>
				<%
				}%> <!--end for loop-->
				</table>
					<tr>
						
						<td align="left">
	<!--Add Button-->		<input type="button" name="add" value="Add Item" class="loginButton" onclick="javascript:showDialog('add');"/>
							<input type="hidden" name="tr">
						</td>
					</tr> 
					<tr>
						
						<td align="left">
	<!-- Back Button-->		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('findMOProjAccpPage.do')">
						</td>
					</tr> 
		</TD>
	</TR>
</TABLE>
</form>

<%
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
}catch (Exception e){
e.printStackTrace();
}
%>