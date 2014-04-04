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
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.EditForm.projectManagerId.value=v.split("|")[0];
			document.EditForm.projectManagerName.value=v.split("|")[1];			
	}
}
/*
function showDialog_staff() {
	var formObj = document.forms["EditForm"];
	openStaffSelectDialog("onCloseDialog_staff","EditForm");
}*/

function onCloseDialog_staff() {
	var formObj = document.forms["EditForm"];
	setStaffValue("hiddenStaffName","projectManagerName","EditForm");	
	setStaffValue("hiddenStaffCode","projectManagerId","EditForm");
}
</SCRIPT>
<%
try{
if (AOFSECURITY.hasEntityPermission("CUST_INT_PROJECT", "_CREATE", session)) {
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();
SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");

String DataId = request.getParameter("DataId");
if (DataId == null) DataId ="";

String repeatName =(String)request.getAttribute("repeatName");

List partyList = null;
List partyList_dep=null;
List ptList=null;
List pcList=null;
List userLoginList=null;
List costCenterList=null;

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
		document.EditForm.FormAction.value = "create";
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
function showProjectDialog()
{
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&projectList.do?projProfileType=I",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelParentProject.innerHTML=code+":"+desc;
			ParentProjectId.value=code;
		}
	}
}
</script>
<Form action="userList.do" name="UserListForm" method="post">
	<input type="hidden" name="CALLBACKNAME" id="CALLBACKNAME">
</Form>
<Form action="custList.do" name="CustListForm" method="post">
	<input type="hidden" name="CALLBACKNAME" id="CALLBACKNAME">
</Form>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Internal Project Maintenance
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
<form action="editInternalProject.do" method="post" name="EditForm">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
    <input type="hidden" name="FormAction" id="FormAction">
    <input type="hidden" name="Id" id="Id" value=<%=DataId%>>
    <input type="hidden" name="add" id="add">
	<input type="hidden" name="projectType" id="projectType" value=<%=CustProject.getProjectType().getPtId()%>>
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
    <%
        if(repeatName != null && repeatName.equals("yes")){
     %>
     	<td align="left" class="lblerr" colspan="4" ><font size="3">Duplicate Contract No!!!</font></td>
     <%
     	}
     %>
      <tr>
        <td align="right">
          <span class="tabletext">Project Code:&nbsp;</span>
        </td>
        <td>
       <%
        if(repeatName != null && repeatName.equals("yes")){
     	%>
          <input type="text" class="inputBox" name="DataId" size="30" value="<%=CustProject.getProjId()%>">
         <%
         	}else{
         %>
          <span class="tabletext"><%=CustProject.getProjId()%>&nbsp;</span><input type="hidden" name="DataId" id="DataId" value="<%=CustProject.getProjId()%>">
        <%
        	}
        %>
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
        <td align="left">
        <%
        	String id = "";
			String name = "";
			if (CustProject.getCustomer() != null) {
				id = CustProject.getCustomer().getPartyId();
				name = CustProject.getCustomer().getDescription();
			}
			if(repeatName != null && repeatName.equals("yes")){
     	%>
          <div style="display:inline" id="labelCustomer"><%=name%>&nbsp;</div>
          <input type="hidden" name="customerId" id="customerId" value = "<%=id%>">
          <a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
         <%        	
         	}else{
         %>
          <input type="hidden" name="customerId" id="customerId" value="<%=id%>"><%=id%>:<%=name%>
        <%
        	}
        %>
        
        </td>
        <td align="right">
          <span class="tabletext">Department:&nbsp;</span>
        </td>
        <td align="left">
        <%
        	if(repeatName != null && repeatName.equals("yes")){
        %>
          <select name="departmentId">
			<%
			Iterator itd = partyList_dep.iterator();
			while(itd.hasNext()){
				Party p = (Party)itd.next();
				String chk ="";
				if (p.getPartyId().equals(CustProject.getDepartment().getPartyId())){
					chk = "selected";
				}
			%>
			<option value="<%=p.getPartyId()%>" <%=chk%> ><%=p.getDescription()%></option>
			<%
			}
			%>
		  </select>
		<%
			}else{		
		%>
			<%=CustProject.getDepartment().getDescription()%>
		<%
			}
		%>
        </td>
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
			<input type="hidden" name="projectManagerId" id="projectManagerId" value="<%=PMId%>">
			<a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
        </td>
         <td align="right">
          <span class="tabletext">Open for All:&nbsp;</span>
        </td>
		<td align="left">
         <%	String PublicFlag = CustProject.getPublicFlag();
			if(PublicFlag.equals("Y")){
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"PublicFlag\" VALUE=\"Y\" CHECKED>Yes");
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"PublicFlag\" VALUE=\"N\">No");
			}else{
                out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"PublicFlag\" VALUE=\"Y\" >Yes");
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"PublicFlag\" VALUE=\"N\" checked>No");
			}
		  %>
		 </td>
	  </tr>	 
      <tr>
        <td align="right">
          <span class="tabletext">Total Service Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalServiceValue" value="<%=Num_formater.format(CustProject.gettotalServiceValue().doubleValue())%>" size="30" onblur="checkDeciNumber2(this,1,1,'totalServiceValue',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
		<td align="right">
          <span class="tabletext">Total Proc./Sub Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalLicsValue" value="<%=Num_formater.format(CustProject.gettotalLicsValue().doubleValue())%>" size="30" onblur="checkDeciNumber2(this,1,1,'totalLicsValue',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
      </tr> 
      <tr>
        <td align="right">
          <span class="tabletext">Service Budget(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="PSCBudget" value="<%=Num_formater.format(CustProject.getPSCBudget().doubleValue())%>" size="30" onblur="checkDeciNumber2(this,1,1,'PSCBudget',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Expense Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="EXPBudget" value="<%=Num_formater.format(CustProject.getEXPBudget().doubleValue())%>" size="30" onblur="checkDeciNumber2(this,1,1,'EXPBudget',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Proc./Sub Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="procBudget" value="<%=Num_formater.format(CustProject.getProcBudget().doubleValue())%>" size="30" onblur="checkDeciNumber2(this,1,1,'procBudget',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
		<td align="right">
          <span class="tabletext">Contract Type:&nbsp;</span>
        </td>
		<td align="left">
			<%String ContractType = CustProject.getContractType();
			if(ContractType.equals("FP")){
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"FP\" checked>Fixed Price");
				if(repeatName != null && repeatName.equals("yes")){
				 	out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"TM\" >Time & Material");
				 }
			}else{
				if(repeatName != null && repeatName.equals("yes")){
                	out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"FP\" >Fixed Price");
                }
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"TM\" checked>Time & Material");
			}
			%>
		 </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Need CAF:&nbsp;</span>
        </td>
        <td align="left">
        	<%String CAFFlag = CustProject.getCAFFlag();%>
			<input TYPE="RADIO" class="radiostyle" NAME="CAFFlag" VALUE="Y" <%if(CAFFlag.equals("Y")) out.print("CHECKED");%>>Yes
			<input TYPE="RADIO" class="radiostyle" NAME="CAFFlag" VALUE="N" <%if(CAFFlag.equals("N")) out.print("CHECKED");%>>No
	    </td>
        <td align="right">
          <span class="tabletext">Parent Project:&nbsp;</span>
        </td>
		<td align="left">
		<%String ProjId = "";
		String ProjName = "";
		if (CustProject.getParentProject() != null) {
			ProjId = CustProject.getParentProject().getProjId();
			ProjName = CustProject.getParentProject().getProjName();
		}
		%>
			<div style="display:inline" id="labelParentProject"><%=ProjId%>:<%=ProjName%>&nbsp;</div><input type="hidden" name="ParentProjectId" id="ParentProjectId" Value="<%=ProjId%>"><a href="javascript:void(0)" onclick="showProjectDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
		</td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Start Date:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="startDate" value="<%=formater.format((java.util.Date)CustProject.getStartDate())%>" size="30">
          <A href="javascript:ShowCalendar(document.EditForm.dimg6,document.EditForm.startDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg6 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
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
        <td  align=right>
          Customer Paid Expense Type:&nbsp;
        </td>
        <td >
        <%
        	List exTypeList = hs.createQuery("select et from ExpenseType as et order by et.expSeq ASC").list();
        	java.util.Set set = CustProject.getExpenseTypes();
			if(exTypeList==null)	exTypeList = new ArrayList();
			for(int j=0; j<exTypeList.size(); j++){
			ExpenseType et = (ExpenseType)exTypeList.get(j);
			boolean checked = (set.contains(et)==true)?true:false;
			if(et.getExpAccDesc().equalsIgnoreCase("CY")){
				if(checked)
				out.println("<input type='checkbox' class='checkboxstyle' name='exTypeChk' checked='"+checked+"' value='"+et.getExpId()+"'>"+et.getExpDesc()+"&nbsp;&nbsp;");
				else
				out.println("<input type='checkbox' class='checkboxstyle' name='exTypeChk' value='"+et.getExpId()+"'>"+et.getExpDesc()+"&nbsp;&nbsp;");
				}
			}
        %>
        </td>
        <td align="right">
          <span class="tabletext">Internal General Expense:&nbsp;</span>
        </td>
        <td align="left">
        	<%String catgy = "N";
        	if( CustProject.getCategory()!=null){
        		if (CustProject.getCategory().equals("General Expense"))
        		catgy = "General Expense";
        	}
        	%>
			<input TYPE="RADIO" class="radiostyle" NAME="catgy" VALUE="General Expense" <%if(catgy.equals("General Expense")) out.print("CHECKED");%>>Yes
			<input TYPE="RADIO" class="radiostyle" NAME="catgy" VALUE="N" <%if(catgy.equals("N")) out.print("CHECKED");%>>No
	    </td>
        </tr>
         </tr>
      <tr>
      	<td align=right>
      		Notes for Customer Claimed Expense:
      	</td>
      	<td colspan=3>
      		<TEXTAREA NAME="expenseNote" ROWS="3" COLS="60"><%if (CustProject.getExpenseNote()!= null) out.print(CustProject.getExpenseNote());%></TEXTAREA>
      	</td>
      </tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
        <%
        	if(repeatName !=null && repeatName.equals("yes")){
        %>
        	<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();"/>
        <%
        	}else{
        %>
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete();"/>
		<%
			}
		%>
		
		</td>      
		<td></td>
	    <td align="center">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listInternalProject.do')">
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
	<form action="editInternalProject.do" method="post" name="EditForm">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
		marginWidth=0 noResize 
		scrolling=no src="includes/date/calendar.htm" 
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
    <input type="hidden" name="FormAction" id="FormAction" value="<%=action%>">
	<input type="hidden" name="projectType" id="projectType" value="AO-China">
	<INPUT TYPE="hidden" name="projectCategory" id="projectCategory" value="I">
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
		<td align="left"><div style="display:inline" id="labelCustomer">&nbsp;</div><input type="hidden" name="customerId" id="customerId"><a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
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
			<input type="hidden" name="projectManagerId" id="projectManagerId" value=""><a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>  
        </td>
         <td align="right">
          <span class="tabletext">Open for All:&nbsp;</span>
        </td>
		<td align="left">
            <input TYPE="RADIO" class="radiostyle" NAME="PublicFlag" VALUE="Y">Yes
			<input TYPE="RADIO" class="radiostyle" NAME="PublicFlag" VALUE="N" CHECKED>No
		 </td>
	  </tr>	
	  <tr>
        <td align="right">
          <span class="tabletext">Total Service Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalServiceValue"  size="30" value="0" onblur="checkDeciNumber2(this,1,1,'totalServiceValue',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Total Proc./Sub Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalLicsValue"  size="30" value="0" onblur="checkDeciNumber2(this,1,1,'totalLicsValue',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Service Budget(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="PSCBudget"  size="30" value="0" onblur="checkDeciNumber2(this,1,1,'PSCBudget',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Expense Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="EXPBudget" size="30" value="0" onblur="checkDeciNumber2(this,1,1,'EXPBudget',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Proc./Sub Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="procBudget" size="30" value="0" onblur="checkDeciNumber2(this,1,1,'procBudget',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Contract Type:&nbsp;</span>
        </td>
		<td align="left">
            <input type="hidden" name="ContractType" id="ContractType" value="FP">Fixed Price
		 </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Need CAF:&nbsp;</span>
        </td>
         <td align="left">
			<input TYPE="RADIO" class="radiostyle" NAME="CAFFlag" VALUE="Y">Yes
			<input TYPE="RADIO" class="radiostyle" NAME="CAFFlag" VALUE="N" CHECKED>No
	    </td>
        <td align="right">
          <span class="tabletext">Parent Project:&nbsp;</span>
        </td>
		<td align="left">
			<div style="display:inline" id="labelParentProject">&nbsp;</div><input type="hidden" name="ParentProjectId" id="ParentProjectId"><a href="javascript:void(0)" onclick="showProjectDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
		</td>
      </tr>
       <tr>
        <td align="right">
          <span class="tabletext">Start Date:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="startDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>" size="30">
          <A href="javascript:ShowCalendar(document.EditForm.dimg8,document.EditForm.startDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg8 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
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
            <tr>
        <td  align=right>
          Customer Paid Expense Type:&nbsp;
        </td>
        <td >
        <%
        	List exTypeList = hs.createQuery("select et from ExpenseType as et order by et.expSeq ASC").list();
			if(exTypeList==null)	exTypeList = new ArrayList();
			for(int j=0; j<exTypeList.size(); j++){
			if(((ExpenseType)exTypeList.get(j)).getExpAccDesc().equalsIgnoreCase("CY"))
			out.println("<input type='checkbox' class='checkboxstyle' name='exTypeChk' value='"+((ExpenseType)exTypeList.get(j)).getExpId()+"'>"+((ExpenseType)exTypeList.get(j)).getExpDesc()+"&nbsp;&nbsp;");
			}
        %>
        </td>
        <td align="right">
          <span class="tabletext">Internal General Expense:&nbsp;</span>
        </td>
         <td align="left">
			<input TYPE="RADIO" class="radiostyle" NAME="catgy" VALUE="General Expense">Yes
			<input TYPE="RADIO" class="radiostyle" NAME="catgy" VALUE="N" CHECKED>No
	    </td>
      </tr>
       <tr>
      	<td align=right>
      		Notes for Customer Claimed Expense:
      	</td>
      	<td colspan=3>
      		<TEXTAREA NAME="expenseNote" ROWS="3" COLS="60"></TEXTAREA>
      	</td>
      	        <td align="right">
	        	
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
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listInternalProject.do')">
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
}catch (Exception ex){
	ex.printStackTrace();
}
%>
