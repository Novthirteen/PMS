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
<SCRIPT>
function showDialog_staff() {
	var formObj = document.forms["EditForm"];
	openStaffSelectDialog("onCloseDialog_staff","EditForm");
}

function onCloseDialog_staff() {
	var formObj = document.forms["EditForm"];
	setStaffValue("hiddenStaffName","projectManagerName","EditForm");	
	setStaffValue("hiddenStaffCode","projectManagerId","EditForm");
}
</SCRIPT>
<%
if (AOFSECURITY.hasEntityPermission("CUST_SUPP_PROJECT", "_CREATE", session)) {
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();
SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");

String DataId = request.getParameter("DataId");
if (DataId == null) DataId ="";

List partyList = null;
List partyList_dep=null;
List ptList=null;
List pcList=null;
List userLoginList=null;


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
	action = "create";
}
%>
<script language="javascript">
function FnDelete() {
	if (confirm("Do you want delete this project?")) {
		document.EditForm.FormAction.value = "delete";
		document.EditForm.submit();
	}
}
function FnUpdate() {
	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}
	else
	{
		document.EditForm.FormAction.value = "update";
		document.EditForm.submit();
	}
}
function FnCreate() {
	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}
	else
	{
		document.EditForm.submit();
	}
}
function ValidateData() {
	var errormessage="";
	if(document.EditForm.startDate.value > document.EditForm.endDate.value)
	{
		errormessage="The end date is earlier than the start date";
		return errormessage;
    }
	if(document.EditForm.customerId.value == "")
	{
		errormessage="You must select a customer";
		return errormessage;
    }
	if(document.EditForm.projectManagerId.value == "")
	{
		errormessage="You must select a project manager";
		return errormessage;
    }
	return errormessage;
}
function showCustomerDialog()
{
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelCustomer.innerHTML=code+":"+desc;
			customerId.value=code;
		}
	}
}
</script>
<Form action="userList.do" name="UserListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
</Form>
<Form action="custList.do" name="CustListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
</Form>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            System Project Maintenance
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
	<TD width='100%'>
<%
    if(CustProject != null){
    	action="Update";
%>
<form action="editSupportProject.do" method="post" name="EditForm">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
    <input type="hidden" name="FormAction">
    <input type="hidden" name="Id" value=<%=DataId%>>
    <input type="hidden" name="add">
	<input type="hidden" name="projectType" value=<%=CustProject.getProjectType().getPtId()%>>
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
        <td align="right">
          <span class="tabletext">Project Code:&nbsp;</span>
        </td>
        <td>
          <span class="tabletext"><%=CustProject.getProjId()%>&nbsp;</span><input type="hidden" name="DataId" value="<%=CustProject.getProjId()%>">
        </td>
        <td align="right">
          <span class="tabletext">Project Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="projName" value="<%=CustProject.getProjName()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Project Status:&nbsp;</span>
        </td>
        <td align="left">
          <select name="projectStatus">
			<option value="WIP" <%if (CustProject.getProjStatus().equals("WIP")) out.println("selected");%>>WIP</option>
			<option value="Close" <%if (CustProject.getProjStatus().equals("Close")) out.println("selected");%>>Close</option>
			
		  </select>
        </td>
		<td align="right">
          <span class="tabletext">Contract No:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="contractNo" value="<%=CustProject.getContractNo()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Customer:&nbsp;</span>
        </td>
        <td align="left"><input type=hidden name="customerId" value="<%=CustProject.getCustomer().getPartyId()%>"><%=CustProject.getCustomer().getPartyId()%>:<%=CustProject.getCustomer().getDescription()%>
        </td>
        <td align="right">
          <span class="tabletext">Department:&nbsp;</span>
        </td>
        <td align="left"><%=CustProject.getDepartment().getDescription()%></td>
      </tr>
         <tr>
        <td align="right">
          <span class="tabletext">Project Manager:&nbsp;</span>
        </td>
        <td align="left">
			<%String PMId = "";
			String PMName = "";
			if (CustProject.getProjectManager() != null) {
				PMId = CustProject.getProjectManager().getUserLoginId();
				PMName = CustProject.getProjectManager().getName();
			}
			%>
			<input type="text" readonly="true" name="projectManagerName" maxlength="100" value="<%=PMName%>">
			<input type="hidden" name="projectManagerId" value="<%=PMId%>">
			<a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
        </td>
         <td align="right">
          <span class="tabletext">Open for All:&nbsp;</span>
        </td>
		<td align="left">
         <%	String PublicFlag = CustProject.getPublicFlag();
			if(PublicFlag.equals("Y")){
				out.println("<input TYPE=\"RADIO\" NAME=\"PublicFlag\" VALUE=\"Y\" CHECKED>Yes");
				out.println("<input TYPE=\"RADIO\" NAME=\"PublicFlag\" VALUE=\"N\">No");
			}else{
                out.println("<input TYPE=\"RADIO\" NAME=\"PublicFlag\" VALUE=\"Y\" >Yes");
				out.println("<input TYPE=\"RADIO\" NAME=\"PublicFlag\" VALUE=\"N\" checked>No");
			}
		  %>
		 </td>
	  </tr>	 
      <tr>
        <td align="right">
          <span class="tabletext">Total Service Value:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalServiceValue" value="<%=CustProject.gettotalServiceValue()%>" size="30">
        </td>
		<td align="right">
          <span class="tabletext">Total Lics Value:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalLicsValue" value="<%=CustProject.gettotalLicsValue()%>" size="30">
        </td>
      </tr> 
      <tr>
        <td align="right">
          <span class="tabletext">PSC Budget:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="PSCBudget" value="<%=CustProject.getPSCBudget()%>" size="30">
        </td>
        <td align="right">
          <span class="tabletext">Expense Budget:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="EXPBudget" value="<%=CustProject.getEXPBudget()%>" size="30">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Procument Budget:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="procBudget" value="<%=CustProject.getProcBudget()%>" size="30">
        </td>
		<td align="right">
          <span class="tabletext">Contract Type:&nbsp;</span>
        </td>
		<td align="left">
			<%	String ContractType = CustProject.getContractType();
			if(PublicFlag.equals("FP")){
				out.println("<input TYPE=\"RADIO\" NAME=\"ContractType\" VALUE=\"FP\" CHECKED>Fixed Price");
				out.println("<input TYPE=\"RADIO\" NAME=\"ContractType\" VALUE=\"TM\">Time & Material");
			}else{
                out.println("<input TYPE=\"RADIO\" NAME=\"ContractType\" VALUE=\"FP\" >Fixed Price");
				out.println("<input TYPE=\"RADIO\" NAME=\"ContractType\" VALUE=\"TM\" checked>Time & Material");
			}
			%>
		 </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Start Date:&nbsp;</span>
        </td>
        <td><input type="hidden" name="startDate" value="<%=formater.format((java.util.Date)CustProject.getStartDate())%>"><%=formater.format((java.util.Date)CustProject.getStartDate())%>
        </td>
        <td align="right">
          <span class="tabletext">End Date:&nbsp;</span>
        </td>  
        <td align="left">
          <input type="text" class="inputBox" name="endDate" value="<%=formater.format((java.util.Date)CustProject.getEndDate())%>" size="30">
          <A href="javascript:ShowCalendar(document.EditForm.dimg2,document.EditForm.endDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
      </tr> 
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete();"/>
		</td>      
		<td></td>
	    <td align="center">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listSupportProject.do')">
		</td>
      </tr> 
    </table>
	</td>
  </tr>
</table>
</form>
<%
	}else{
%>
	<form action="editSupportProject.do" method="post" name="EditForm">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
		marginWidth=0 noResize 
		scrolling=no src="includes/date/calendar.htm" 
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
    <input type="hidden" name="FormAction" value="<%=action%>">
	<input type="hidden" name="projectType" value="Service">
	<INPUT TYPE="hidden" name="projectCategory" value="S">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
	<tr>
        <td align="right">
          <span class="tabletext">Project Code:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="DataId" size="30">
        </td>
        <td align="right">
          <span class="tabletext">Project Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="projName" size="30">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Project Status:&nbsp;</span>
        </td>
        <td align="left">
          <select name="projectStatus">
			<option value="WIP">WIP</option>
			<option value="Close">Close</option>
		  </select>
        </td>
		<td align="right">
          <span class="tabletext">Contract No:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="contractNo" size="30">
        </td>
      </tr>
       <tr>
        <td align="right">
          <span class="tabletext">Customer:&nbsp;</span>
        </td>
		<td align="left"><div style="display:inline" id="labelCustomer">&nbsp;</div><input type=hidden name="customerId"><a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
		</td>
        <td align="right">
          <span class="tabletext">Department:&nbsp;</span>
        </td>
        <td align="left">
          <select name="departmentId">
			<%
			Iterator itd = partyList_dep.iterator();
			while(itd.hasNext()){
				Party p = (Party)itd.next();
			%>
			<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
			<%
			}
			%>
		  </select>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Project Manager:&nbsp;</span>
        </td>
        <td align="left">
			<input type="text" readonly="true" name="projectManagerName" maxlength="100" value="">
			<input type="hidden" name="projectManagerId" value=""><a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>  
        </td>
        <td align="right">
          <span class="tabletext">Open for All:&nbsp;</span>
        </td>
		<td align="left">
            <input TYPE="RADIO" NAME="PublicFlag" VALUE="Y">Yes
			<input TYPE="RADIO" NAME="PublicFlag" VALUE="N" CHECKED>No
		 </td>
	  </tr>	
	  <tr>
        <td align="right">
          <span class="tabletext">Total Service Value:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalServiceValue"  size="30" value="0">
        </td>
        <td align="right">
          <span class="tabletext">Total Lics Value:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalLicsValue"  size="30" value="0">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">PSC Budget:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="PSCBudget"  size="30" value="0">
        </td>
        <td align="right">
          <span class="tabletext">Expense Budget:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="EXPBudget" size="30" value="0">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Procument Budget:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="procBudget" size="30" value="0">
        </td>
        <td align="right">
          <span class="tabletext">Contract Type:&nbsp;</span>
        </td>
		<td align="left">
            <input TYPE="RADIO" NAME="ContractType" VALUE="FP" CHECKED>Fixed Price
			<input TYPE="RADIO" NAME="ContractType" VALUE="TM">Time & Material
		 </td>
      </tr>
       <tr>
        <td align="right">
          <span class="tabletext">Start Date:&nbsp;</span>
        </td>
        <td><input type="hidden" name="startDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>"><%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>
        </td>
        <td align="right">
          <span class="tabletext">End Date:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="endDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>">
          <A href="javascript:ShowCalendar(document.EditForm.dimg4,document.EditForm.endDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg4 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        
        </td>
      </tr>   
	  <tr><td>&nbsp;</td></tr>
	  <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();"/>
        </td>
       </form>
		<td></td>
	    <td align="center">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listSupportProject.do')">
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<%
	}
	Hibernate2Session.closeSession();
}else{
	out.println("你没有权限访问!");
}
%>
