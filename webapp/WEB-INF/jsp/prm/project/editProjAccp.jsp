<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="net.sf.hibernate.type.*"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
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

String DataId = request.getParameter("DataId");
if (DataId == null) DataId ="";

List partyList = null;
List partyList_dep = null;
List ptList = null;
List pcList = null;
List userLoginList = null;

int i=1;
ProjectMaster CustProject = (ProjectMaster)request.getAttribute("CustProject");
List ServiceTypeList = (List)request.getAttribute("ServiceTypeList");
if(ServiceTypeList==null){
	ServiceTypeList = new ArrayList();
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

function FnUpdate() {
	document.aform.FormAction.value = "update";
	document.aform.submit();
}

function checkchk() {
	
	if (isChecked="checked")  isChecked = "";

	if (isChecked="")  isChecked = "checked";
	
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
			<form action="editProjAccp.do" method="POST" name="aform">
			<input type="hidden" name="FormAction" id="FormAction">
			<input type="hidden" name="DataId" id="DataId" value="<%=DataId%>">
			
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
							<input type="hidden" name="DataId" id="DataId" value="<%=CustProject.getProjId()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Project Description :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><%=CustProject.getProjName()%>&nbsp;</span>
							<input type="hidden" name="projName" id="projName" value="<%=CustProject.getProjName()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Project Status :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><%=CustProject.getProjStatus()%>&nbsp;</span>
							<input type="hidden" name="projectStatus" id="projectStatus" value="<%=CustProject.getProjStatus()%>">
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Contract No :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><%=CustProject.getContractNo()%>&nbsp;</span>
							<input type="hidden" name="contractNo" id="contractNo" value="<%=CustProject.getContractNo()%>">
						</td>
						<%if (CustProject.getProjectCategory().getId().equals("C")){%>
						<td align="right" class="lblbold">
							<span class="tabletext">Customer :&nbsp;</span>
						</td>
						<td>
							<span class="tabletext"><%=CustProject.getCustomer().getPartyId()%>:<%=CustProject.getCustomer().getDescription()%>&nbsp;</span>
							<input type="hidden" name="customerId" id="customerId" value="<%=CustProject.getCustomer().getPartyId()%>:<%=CustProject.getCustomer().getDescription()%>">
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
							<input type="hidden" name="departmentId" id="departmentId"  value="<%=CustProject.getDepartment().getDescription()%>">
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
							<input type="hidden" name="projectManagerId" id="projectManagerId" value="<%=PMId%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext"> Open for All :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><% if (CustProject.getPublicFlag().equals("N")) out.print("NO"); else out.print("YES"); %>&nbsp;</span>
							<input type="hidden" name="PublicFlag" id="PublicFlag" value="<%=CustProject.getPublicFlag()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Contract Type :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><% if (CustProject.getContractType().equals("FP")) out.print("Fixed Price"); else out.print("Time & Material");%>&nbsp;</span>
							<input type="hidden" name="ContractType" id="ContractType" value="<%=CustProject.getContractType()%>">
						</td>
					</tr>	 
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Total Service Value(RMB) :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><%=Num_formater.format(CustProject.gettotalServiceValue())%>&nbsp;</span>
							<input type="hidden" name="totalServiceValue" id="totalServiceValue" value="<%=CustProject.gettotalServiceValue()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Total Proc./Sub Value(RMB) :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><%=Num_formater.format(CustProject.gettotalLicsValue())%>&nbsp;</span>
							<input type="hidden" name="totalLicsValue" id="totalLicsValue" value="<%=CustProject.gettotalLicsValue()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Service Budget(RMB) :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><%=Num_formater.format(CustProject.getPSCBudget())%>&nbsp;</span>
							<input type="hidden" name="PSCBudget" id="PSCBudget" value="<%=CustProject.getPSCBudget()%>">
						</td>
					</tr> 
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Expense Budget(RMB) :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><%=Num_formater.format(CustProject.getEXPBudget())%>&nbsp;</span>
							<input type="hidden" name="EXPBudget" id="EXPBudget" value="<%=CustProject.getEXPBudget()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Proc./Sub Budget(RMB) :&nbsp;</span>
						</td>
						<td  align="left">
							<span class="tabletext"><%=Num_formater.format(CustProject.getProcBudget())%>&nbsp;</span>
							<input type="hidden" name="procBudget" id="procBudget" value="<%=CustProject.getProcBudget()%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Need CAF :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><% if (CustProject.getCAFFlag().equals("N")) out.print("NO"); else out.print("YES");%>&nbsp;</span>
							<input type="hidden" name="CAFFlag" id="CAFFlag" value="<%=CustProject.getCAFFlag()%>">
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
							<span class="tabletext">Parent Project :&nbsp;</span>
						</td>
						<td align="left">
							<%String ProjId = "";
							String ProjName = "";
							if (CustProject.getParentProject() != null) {
							ProjId = CustProject.getParentProject().getProjId();
							ProjName = CustProject.getParentProject().getProjName();
							}%>
							<div style="display:inline" id="labelParentProject"><%=ProjId%>:<%=ProjName%>&nbsp;</div>
							<input type="hidden" name="ParentProjectId" Id="ParentProjectId" Value="<%=ProjId%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">Start Date :&nbsp;</span>
						</td>
						<td>
							<span class="tabletext"><%=formater.format((java.util.Date)CustProject.getStartDate())%>&nbsp;</span>
							<input type="hidden" name="startDate" id="startDate" value="<%=formater.format((java.util.Date)CustProject.getStartDate())%>">
						</td>
						<td align="right" class="lblbold">
							<span class="tabletext">End Date :&nbsp;</span>
						</td>
						<td align="left">
							<span class="tabletext"><%=formater.format((java.util.Date)CustProject.getEndDate())%>&nbsp;</span>
							<input type="hidden" name="endDate" id="endDate" value="<%=formater.format((java.util.Date)CustProject.getEndDate())%>">
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
					<td rowspan=2 class="lblbold" width=1%>&nbsp;#&nbsp</td>
					<td rowspan=2 class="lblbold" width=5%>&nbsp;Phase&nbsp;</td>
					<%if (CustProject.getProjectCategory().getId().equals("C")){%>
					<td rowspan=2 class="lblbold" width=5%>&nbsp;Contracted Service Value (RMB)&nbsp;</td>
					<%}%>
					<%if (CustProject.getProjectCategory().getId().equals("P")){%>
					<td rowspan=2 class="lblbold" width=10%>&nbsp;Sub-Contract Value (RMB)&nbsp;</td>
					<%}%>
					<td rowspan=2 class="lblbold" width=10%>&nbsp;Estimated Man Days&nbsp;</td>
					<td rowspan=2 class="lblbold" width=5%>&nbsp;Estimated Close Date&nbsp;</td>
					<%if (CustProject.getProjectCategory().getId().equals("C")){%>
					<td align=center colspan=2 class="lblbold" width=5%>&nbsp;Customer Acceptance&nbsp;</td>
					<%}%>
					<%if (CustProject.getProjectCategory().getId().equals("P")){%>
					<td align=center colspan=2 class="lblbold" width=5%>&nbsp;Acceptance for Supplier&nbsp;</td>
					<%}%>
				</tr>
				<tr bgcolor="#e9eee9">
					<td class="lblbold" align=center width=5%>&nbsp;Status&nbsp;</td>
					<td class="lblbold" align=center width=5%>&nbsp;Date&nbsp;</td>
				</tr>
					<%
						Iterator itst = ServiceTypeList.iterator();
						for (int j = 0; j < ServiceTypeList.size() ; j++) {
							String StId = "";
							String STDescription = "";
							double STRate = 0;
							double SubContractRate = 0;
							String EstimateManDays = "0";
							String EstimateDate = formater.format((java.util.Date)UtilDateTime.nowTimestamp());
							String CurrentDate = formater.format((java.util.Date)UtilDateTime.nowTimestamp());
							String SuppAccpDate = "";
							String CustAccpDate = "";
							String stbillid ="";
							String stpayid ="";
							String isChecked = "";		
							String iChecked = "";					
							if (itst.hasNext()){
								ServiceType st = (ServiceType)itst.next();
								StId = st.getId().toString();
								STDescription = st.getDescription();
								STRate = st.getRate().doubleValue();
								SubContractRate = st.getSubContractRate().doubleValue();
								EstimateManDays = st.getEstimateManDays().toString();
							//	stbillid = st.getProjBill().getId().toString();
							//	stpayid = st.getProjPayment();
								if (st.getEstimateAcceptanceDate() != null) {EstimateDate = formater.format(st.getEstimateAcceptanceDate());}
								if (st.getCustAcceptanceDate() != null) {
									CustAccpDate = formater.format(st.getCustAcceptanceDate());
									isChecked = "checked";}
								if (st.getVendAcceptanceDate() != null) {
									SuppAccpDate = formater.format(st.getVendAcceptanceDate());
									iChecked = "checked";}
					%>
				<tr>
					<%
							if (st.getProjBill()== null) {
								FreezeFlag = "N";
							} else {
								FreezeFlag = "Y";
							}
							if  (st.getProjPayment() == null)  {
								sFreezeFlag = "N";
							} else {
								sFreezeFlag = "Y";
							}
							
						String fRead = "";
						String fck = "";
						
						if  (FreezeFlag.equals("Y")) {
							 fRead=" ReadOnly Style='background-color:#A9A9A9'";
							 fck=" disabled";
						}%>
					<%
						String sfRead = "";
						String sfck = "";
						if  (sFreezeFlag.equals("Y")){
						 	 sfRead=" ReadOnly Style='background-color:#A9A9A9'";
							 sfck=" disabled";
						 }
					%>
					<td width=1%  nowrap>&nbsp;
						<%=j+1%> 
						<input type = "hidden" name = "StId" value="<%=StId%>">
					</td>
					<td width=10% nowrap>&nbsp;
						<%=STDescription%>
						<input type = "hidden" name = "STDescription" value="<%=STDescription%>">
					</td>
					<%if (CustProject.getProjectCategory().getId().equals("C")){%>
					<td width=10%  nowrap>&nbsp;
						<%=Num_formater.format(st.getRate())%>
						<input type = "hidden" name = "STRate" value="<%=STRate%>">
					</td>
					<%}%>
					<%if (CustProject.getProjectCategory().getId().equals("P")){%>
					<td width=10% nowrap>&nbsp;
						<%=Num_formater.format(st.getSubContractRate())%>
						<input type = "hidden" name = "SubContractRate" value="<%=SubContractRate%>">
					</td>
					<%}%>
					<td width=10% nowrap>&nbsp;
						<%=Num_formater.format(st.getEstimateManDays())%>
						<input type = "hidden" name = "EstimateManDays" value="<%=EstimateManDays%>">
					</td>
					<td width=10% nowrap>&nbsp;
						<%=EstimateDate%>
						<input type = "hidden" name = "EstimateDate" value="<%=EstimateDate%>">
					</td>
					<%if (CustProject.getProjectCategory().getId().equals("C")){%>
					<td align=center width=10% nowrap>&nbsp;
						<input type="checkbox" class="checkboxstyle" name="CustAccp" value="<%=j%>" <%=isChecked%> <%=fck%>>
					</td>
					<td width=10% class="lblbold" nowrap>&nbsp;
						<input type = "text" name = "CustAccpDate" Id="CustAccpDate<%=j%>" maxlength="100" size="15" value="<%=CustAccpDate%>" <%=fRead%>>
						<% if (fRead.equals("")) { %>
						<A href="javascript:ShowCalendar(document.aform.dimdBill<%=j%>,document.aform.CustAccpDate<%=j%>,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimdBill<%=j%> src="<%=request.getContextPath()%>/images/datebtn.gif" >
						</A>
						<%}%>
					</td>
					<% }%> 	
					<%if (CustProject.getProjectCategory().getId().equals("P")){%>	
					<td align=center width=10%  nowrap>&nbsp;
						<input type="checkbox" class="checkboxstyle" name="SuppAccp" value="<%=j%>" <%=iChecked%> <%=sfck%>>
					</td>
					<td width=10% class="lblbold" nowrap>&nbsp;
						<input type = "text" name = "SuppAccpDate" Id="SuppAccpDate<%=j%>" maxlength="100" size="15" value="<%=SuppAccpDate%>" <%=sfRead%>>
						<% if (sfRead.equals("")) { %>
						<A href="javascript:ShowCalendar(document.aform.dimdPay<%=j%>,document.aform.SuppAccpDate<%=j%>,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimdPay<%=j%> src="<%=request.getContextPath()%>/images/datebtn.gif" >
						</A>
						<%}%>
					</td>	
					<% }%> 
				<% }%> 
				</tr>
				<%}%> <!--end for loop-->
				
				</table>
					<tr>
						
						<td align="left">
	<!-- Save Button-->		<input type="button" name="save" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
	<!-- Back Button-->		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('findProjAccpPage.do')">
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
