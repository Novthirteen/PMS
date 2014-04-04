<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.contract.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
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
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
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

function showProjctDialog() {
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.project.dialog.title&projectList.do?projProfileType=C",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null && v.length > 8) {
			ProjCode.value=v.split("|")[0];
			ProjName.value=v.split("|")[1];
			contractType.value=v.split("|")[2];
			departmentId.value=v.split("|")[3];
			//departmentNm.value=v.split("|")[4];
			//billToId.value=v.split("|")[5];
			billToNm.value=v.split("|")[6];
			pmId.value=v.split("|")[7];
			pmName.value=v.split("|")[8];
		}
	}
}


function onCloseDialog_staff() {
	var formObj = document.forms["EditForm"];
	setStaffValue("hiddenStaffName","projectManagerName","EditForm");	
	setStaffValue("hiddenStaffCode","projectManagerId","EditForm");
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

function FnCancel() {
			document.EditForm.FormAction.value = "cancel";
			document.EditForm.type.value = "";
			document.EditForm.solved.value = "";
			document.EditForm.submit();
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
	
	if((document.EditForm.FormAction.value == "create")&&(document.EditForm.ProjCode.value == 0))
	{
		errormessage="You must input the Project Code Value!";
		return errormessage;
    }
	
	if(document.EditForm.type.value == "")
	{
		errormessage="You must select a problem type!";
		return errormessage;
    }
	if(document.EditForm.solved.value == "")
	{
		errormessage="You must select a solved status!";
		return errormessage;
    }
    
    return errormessage;
}



</script>
<%
try{
if (AOFSECURITY.hasEntityPermission("CUST_CMPLN_TO_PM", "", session)) {
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
NumberFormat Num_formater2 = NumberFormat.getInstance();
Num_formater2.setMaximumFractionDigits(5);
Num_formater2.setMinimumFractionDigits(2);
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
 
CustComplain cc = (CustComplain)request.getAttribute("CustComplain");

ProjectMaster proj = (ProjectMaster)request.getAttribute("CurrentProj");

UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);

PartyHelper ph = new PartyHelper();


UserLoginHelper ulh = new UserLoginHelper();


ProjectHelper phh = new ProjectHelper();

String startDate = "";
String endDate = "";
	
String action = request.getParameter("action");
if(action == null){
	action = "create";
}
%>

<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=center width='90%' class="wpsPortletTopTitle">
            Complain Detail
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
	<TD width='100%'>
	<form action="editCustComplains.do" method="post" name="EditForm">
	<table width='100%' border='0' cellpadding='0' cellspacing='2'>	

	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
		marginWidth=0 noResize 
		scrolling=no src="includes/date/calendar.htm" 
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
	    <input type="hidden" name="FormAction" id="FormAction" >
	    
	  <%
    if(cc!= null){
		action="Update";
		String textdep = cc.getDep_ID();
		 SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
		String CreateDate =dateFormater.format(cc.getCreate_Date());
		String CreateUser=cc.getCreate_User().getName();
		String PM=cc.getPM_ID().getName();
		String ProjName=proj.getProjName();
		String ProjCode=proj.getProjId();
		String type=cc.getType();
		String solved=cc.getSolved();
	    String billToNm=proj.getBillTo().getChineseName();
	    String desc=cc.getDescription();
	    String ContractType=proj.getContractType();
	    Long DataId =cc.getCC_Id();
		if (solved == null) solved ="";
		if (type == null) type ="";
		if (ProjCode == null) ProjCode ="";
		if (ProjName == null) ProjName ="";
		if (textdep == null) textdep ="";
		if (solved == null) solved = "";
		if (desc == null) desc = "";
		if (CreateUser == null) CreateUser = "";
		if (CreateDate == null) CreateDate = "";
		if (PM == null) PM ="";
		if (billToNm==null) billToNm="";
%>
	
	      <tr>
	        <td align="right">
	          <span class="lblbold">Project:&nbsp;</span>
	        </td>
	        <td align="left">  
	        <input  name="DataId" id="DataId"  type="hidden" value="<%= DataId.longValue()%>">     
	          <%=ProjName%>       
	        </td>
	        <td  align="right" >   
	          <span class="lblbold">PM:&nbsp;</span>   
	          </td>
	         <td  align="left" colspan=3>     
	          <%=PM%>       
	        </td>
	        </tr>
	        <tr>
	         <td align="right" >
	          <span class="lblbold">&nbsp; Contract Type:&nbsp;</span>
	          </td>
	          <td align="left" >
	          <%=ContractType%> 
	         </td>
		   <td align="right">
	          <span class="lblbold">Customer:&nbsp;</span>
	        </td>
	        <td  colspan=3 align="left">       
	         <%=billToNm%>    
	        </td>
	        </tr>
	        <tr>
	        <tr>
	         <td align="right" >
	          <span class="lblbold">&nbsp; Create Date:&nbsp;</span>
	          </td>
	          <td align="left" >
	          <%=CreateDate%> 
	         </td>
		   <td align="right">
	          <span class="lblbold">Create User:&nbsp;</span>
	        </td>
	        <td  colspan=3 align="left">       
	         <%=CreateUser%>    
	        </td>
	        </tr>
	         <td class="lblbold" align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					Solved: 
					</td>
				<td align="left">	
					<select name="solved">
					<option value="YES" <%if(solved.equals("YES")) out.print("selected");%>>YES </option>
					<option value="NO" <%if(solved.equals("NO")) out.print("selected");%>>NO</option>
					</select>
				</td>
	        <td align="right">
	          <span class="lblbold">Problem Type:&nbsp;</span>
	        </td>
	        <td class="lblLight" colspan="3" align="left">
					<select name="type">
					<option value="PA Related" <%if (type.equals("PA Related")) out.print("selected");%>>PA Related</option>
					<option value="Technical Issue" <%if (type.equals("Technical Issue")) out.print("selected");%>>Technical Issue</option>
					<option value="Consultant Related" <%if (type.equals("Consultant Related")) out.print("selected");%>>Consultant Related</option>
					<option value="PM Related" <%if (type.equals("PM Related")) out.print("selected");%>>PM Related</option>
					<option value="Department Related" <%if (type.equals("Department Related")) out.print("selected");%>>Department Related</option>
					<option value="Sales Related" <%if (type.equals("Sales Related")) out.print("selected");%>>Sales Related</option>
					</select>
				</td>
		  
	       
	        </tr>
	        <TR>
	        <td align="left" width="100%" colspan="6">
	          <span class="lblbold">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	          Description:&nbsp;</span>
	        </td>
	        </TR>
	        <TR>
	         <td align="center" width="100%" colspan="6">
	          <TEXTAREA name="Desc" rows="6" cols="160" ><%=desc%></TEXTAREA></td>
	        </TR>
	      <tr>
	        <td align="right" colspan="3">
	          <span class="tabletext"></span>
	        </td>
	        <td align="center" colspan="3">
			<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();return false"/>
			<input type="button" value="Cancel" class="loginButton" onclick="javascript:FnCancel();"/>
			<input type="button" value="Back To List" class="loginButton" onclick="location.replace('CustomerComplains.do')">
			</td>      
	  </tr>
	  </table>
	  </form>
	  </TD>
	</TR>	
	</table>
<%
	}else{
%>
 <tr>
	        <td class="lblbold" align="right">Project:</td>
				<td class="lblLight" align="left">
					<input  name="ProjName"  >
					<input type="hidden" type="text" name="ProjCode" id="ProjCode" size="25"  style="TEXT-ALIGN: right" class="lbllgiht">
					
					<a href="javascript:void(0)" onclick="showProjctDialog();event.returnValue=false;">
					<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
				</td>
	        <td align="right">
	          <span class="lblbold">PM:&nbsp;</span>
	          </td>
	           <td align="left" colspan="3">
	          <input type="text" name="pmName"  readonly >  
	          <input type="hidden" type="text" name="pmId" id="pmId">        
	        <input type="hidden" type="text" name="departmentId" id="departmentId">
	        </td>
	        </tr>
	        
	        <tr>
	         
		   <td align="right" >
	          <span class="lblbold">Contract Type:&nbsp;</span>
	          </td>
	         <td align="left">
	         <input type="text" name="contractType"  readonly>        
	        </td>
	         <td align="right">
	          <span class="lblbold">Customer:&nbsp;</span>
	        </td>
	        <td  colspan="3" align="left">       
	          <input type="text" name="billToNm"  readonly >        
	        </td>
	        </tr>
	        <tr>
	       
		   <td align="right">
	          <span class="lblbold">Sloved:&nbsp;</span>
	        </td>
	        <td class="lblbold"  align="left">
					<select name="solved">
					<option value="NO" selected>NO</option>
					<option value="YES"  >YES</option>
					</select>
				</td>
				 <td align="right">
	          <span class="lblbold">Problem Type:&nbsp;</span>
	        </td>
	        <td class="lblLight"  colspan="3" align="left">
					<select name="type">
					<option value="">-select-</option>
					<option value="PA Related" >PA Related</option>
					<option value="Technical Issue"  >Technical Issue</option>
					<option value="Consultant Related"  >Consultant Related</option>
					<option value="PM Related"  >PM Related</option>
					<option value="Department Related"  >Department Related</option>
					<option value="Sales Related"  >Sales Related</option>
					</select>
				</td>
	        </tr>
	        <TR>
	        <td align="left" width="100%" colspan="6">
	          <span class="lblbold">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	          Description:&nbsp;</span>
	        </td>
	        </TR>
	        <TR>
	         <td align="center" width="100%" colspan="6">
	          <TEXTAREA name="Desc" rows="6" cols="180" ></TEXTAREA></td>
	        </TR>
	        <tr>
	        <td align="right" colspan="3">
	          <span class="tabletext"></span>
	        </td>
	        <td align="center" colspan="3">
			<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();return false"/>
			<input type="button" value="Cancel" class="loginButton" onclick="javascript:FnCancel();"/>
			<input type="button" value="Back To List" class="loginButton" onclick="location.replace('CustomerComplains.do')">
			</td>      
	  </tr>
	        
	  </table>
	  </form>
	  </TD>
	</TR>	
	</table>	
   
<%
	}
	Hibernate2Session.closeSession();
}
else{
	out.println("你没有权限访问!");
}
}catch(Exception e){
	e.printStackTrace();
}
%>
