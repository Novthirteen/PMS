<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.component.domain.module.*"%>
<%@ page import="com.aof.component.prm.master.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.util.PageKeys"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<SCRIPT>
function FnUpdate() {
     if (document.editUserLogin.userLoginId.value == 0){
     alert("User Login id cannot be ignored ");
     document.editUserLogin.userLoginId.focus();
     }
     else if (document.editUserLogin.name.value == 0){
     alert("User Login  name cannot be ignored ");
     document.editUserLogin.name.focus();
     }
     else if (document.editUserLogin.password.value == 0){
     alert("User Login  password cannot be ignored ");
     document.editUserLogin.password.focus();
     }
     else if (document.editUserLogin.email_addr.value == 0){
     alert("User Login  email address cannot be ignored ");
     document.editUserLogin.email_addr.focus();
     }
     else{
	document.editUserLogin.action.value = "create";
	document.editUserLogin.submit();
	}
}

function showDialog_staff() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.editUserLogin.reportToId.value=v.split("|")[0];
			document.editUserLogin.reportToName.value=v.split("|")[1];	
			labelRP.innerHTML=document.editUserLogin.reportToName.value;	
	}
}
function onSelect() {
	//var formObj = document.forms["editUserLogin"];
	if (document.forms["editUserLogin"].elements["action"].value == "update"){
	document.forms["editUserLogin"].submit();
	}
}

function fnSave(){
	if(document.editUserLogin.enable.value == "N"){
	
		var leavDay = document.editUserLogin.leaveDay.value;
		var joinDay = document.editUserLogin.joinDay.value;
		
		if(leavDay == null || leavDay == ""){
			alert("The leave day can not be blank!");
			return;
		}
		
		if(leavDay<=joinDay){
			alert("The leave day can not be earlier than join day!");
			return;
		}
	}
	document.editUserLogin.submit();
}

function fnRightSecurity(){
	var oSelectFrom = document.getElementsByName("AvailSecurity");
	var oSelectTo = document.getElementsByName("GrantSecurity");
	var oOption ;
	var newOption ;
	for(var i=0;i<oSelectFrom[0].options.length;i++){
		oOption = oSelectFrom[0].options[i];
		if(oOption.selected==true){
			newOption = new Option(oOption.innerText,oOption.value);
			oSelectFrom[0].options.remove(i);
			oSelectTo[0].add(newOption);
			newOption.selected = true;
			i = i-1;
		}
	}
}

function fnLeftSecurity(){
	var oSelectFrom = document.getElementsByName("GrantSecurity");
	var oSelectTo = document.getElementsByName("AvailSecurity");
	var oOption ;
	var newOption ;
	for(var i=0;i<oSelectFrom[0].options.length;i++){
		oOption = oSelectFrom[0].options[i];
		if(oOption.selected==true){
			newOption = new Option(oOption.innerText,oOption.value);
			oSelectFrom[0].options.remove(i);
			oSelectTo[0].add(newOption);
			newOption.selected = true;
			i = i-1;
		}
	}
}

function fnAllRightSecurity(){
	var oSelectFrom = document.getElementsByName("AvailSecurity");
	var oSelectTo = document.getElementsByName("GrantSecurity");
	var oOption ;
	var newOption ;
	for(var i=0;i<oSelectFrom[0].options.length;)	{
		oOption = oSelectFrom[0].options[0];
		newOption = new Option(oOption.innerText,oOption.value);
		oSelectFrom[0].options.remove(0);
		oSelectTo[0].add(newOption);
	}
}

function fnAllLeftSecurity(){
	var oSelectFrom = document.getElementsByName("GrantSecurity");
	var oSelectTo = document.getElementsByName("AvailSecurity");
	var oOption ;
	var newOption ;
	for(var i=0;i<oSelectFrom[0].options.length;){
		oOption = oSelectFrom[0].options[0];
		newOption = new Option(oOption.innerText,oOption.value);
		oSelectFrom[0].options.remove(0);
		oSelectTo[0].add(newOption);
	}
}

////////////////

function fnRightModule(){
	var oSelectFrom = document.getElementsByName("AvailModule");
	var oSelectTo = document.getElementsByName("GrantModule");
	var oOption ;
	var newOption ;
	for(var i=0;i<oSelectFrom[0].options.length;i++){
		oOption = oSelectFrom[0].options[i];
		if(oOption.selected==true){
			newOption = new Option(oOption.innerText,oOption.value);
			oSelectFrom[0].options.remove(i);
			oSelectTo[0].add(newOption);
			newOption.selected = true;
			i = i-1;
		}
	}
}

function fnLeftModule(){
	var oSelectFrom = document.getElementsByName("GrantModule");
	var oSelectTo = document.getElementsByName("AvailModule");
	var oOption ;
	var newOption ;
	for(var i=0;i<oSelectFrom[0].options.length;i++){
		oOption = oSelectFrom[0].options[i];
		if(oOption.selected==true){
			newOption = new Option(oOption.innerText,oOption.value);
			oSelectFrom[0].options.remove(i);
			oSelectTo[0].add(newOption);
			newOption.selected = true;
			i = i-1;
		}
	}
}

function fnAllRightModule(){
	var oSelectFrom = document.getElementsByName("AvailModule");
	var oSelectTo = document.getElementsByName("GrantModule");
	var oOption ;
	var newOption ;
	for(var i=0;i<oSelectFrom[0].options.length;)	{
		oOption = oSelectFrom[0].options[0];
		newOption = new Option(oOption.innerText,oOption.value);
		oSelectFrom[0].options.remove(0);
		oSelectTo[0].add(newOption);
	}
}

function fnAllLeftModule(){
	var oSelectFrom = document.getElementsByName("GrantModule");
	var oSelectTo = document.getElementsByName("AvailModule");
	var oOption ;
	var newOption ;
	for(var i=0;i<oSelectFrom[0].options.length;){
		oOption = oSelectFrom[0].options[0];
		newOption = new Option(oOption.innerText,oOption.value);
		oSelectFrom[0].options.remove(0);
		oSelectTo[0].add(newOption);
	}
}
/////////////////

function selectAllModule(){
	var oSelectTo = document.getElementsByName("GrantModule");
	
	for(var i=0;i<oSelectTo[0].options.length;i++){
		oSelectTo[0].options[i].selected = true;
	}
	with(document.aForm)
	{
		add.value = "updatemodule";
		submit();
	}
}
function selectAllSecurity(){
	var oSelectTo = document.getElementsByName("GrantSecurity");
	
	for(var i=0;i<oSelectTo[0].options.length;i++){
		oSelectTo[0].options[i].selected = true;
	}
		with(document.aForm)
	{
		add.value = "updatesecurity";
		submit();
	}
	
}

</SCRIPT>
<%
try{
if (AOFSECURITY.hasEntityPermission("USER_LOGIN", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

UserLogin ul = null;   
String reportToId = "";
String reportToName = "";
String userLoginId = request.getParameter("userLoginId");
if (userLoginId == null || userLoginId.trim().length() == 0) {
	userLoginId = (String)request.getAttribute("userLoginId");
}

if(userLoginId!=null && !userLoginId.equals("")){
	ul = (UserLogin)hs.load(UserLogin.class,userLoginId);
	//ul = (UserLogin)request.getAttribute("userlogin");
}

String action = request.getParameter("action");
//String  = request.getParameter("action");
if(action == null){
	action = "create";
}

String securityGroupId = request.getParameter("securityGroupId");
String moduleGroupId = request.getParameter("moduleGroupId");
String add = request.getParameter("add");

List type = (List)request.getAttribute("TypeList");
//List level = (List)request.getAttribute("LevelList");

/////////////////////////////////////////////////////
//以下代码处理系统模块和权限的增加工作
/////////////////////////////////////////////////////
/*
try{
	// 增加用户权限
	if(add !=null && add.equals("add")){
		if(securityGroupId != null && !securityGroupId.equals("")){
			tx = hs.beginTransaction();
			Set mset = ul.getSecurityGroups();
			if(mset==null){
				mset = new HashSet();
			}
			mset.add((SecurityGroup)hs.load(SecurityGroup.class,securityGroupId));
			ul.setSecurityGroups(mset);
			hs.update (ul);
			//hs.flush();
			tx.commit();
		}
		
		// 增加用户模块
		if(moduleGroupId != null && !moduleGroupId.equals("")){
			tx = hs.beginTransaction();
			Set mset = ul.getModuleGroups();
			if(mset==null){
				mset = new HashSet();
			}
			mset.add((ModuleGroup)hs.load(ModuleGroup.class,moduleGroupId));
			ul.setModuleGroups(mset);
			hs.update (ul);
			//hs.flush();
			tx.commit();
		}
	}else if(add !=null && add.equals("delete")){
		/////////////////////////////////////////////////////
		//一下代码处理系统模块和权限的删除工作
		/////////////////////////////////////////////////////
		// 删除用户权限		
		if(securityGroupId != null && !securityGroupId.equals("")){
			tx = hs.beginTransaction();
			Set mset = ul.getSecurityGroups();
			mset.remove((SecurityGroup)hs.load(SecurityGroup.class,securityGroupId));
			hs.update (ul);
			//hs.flush();
			tx.commit();
		}
		// 删除用户模块
		if(moduleGroupId != null && !moduleGroupId.equals("")){
			//out.println("==="+moduleGroupId);
			tx = hs.beginTransaction();
			Set mset = ul.getModuleGroups();
			mset.remove((ModuleGroup)hs.load(ModuleGroup.class,moduleGroupId));
			hs.update (ul);
			//hs.flush();
			tx.commit();
		}
	}
}catch(Exception e){
		out.println("Error:"+e.getMessage());
}
*/
List partyList = null;
List slList=new  ArrayList();
hs.flush();
try{
// 所有机构列表
PartyHelper ph = new PartyHelper();
partyList = ph.getAllOrgUnits(hs);

//所有salary level列表
String newPartyId = request.getParameter("partyId");
slList = hs.createQuery("from SalaryLevel s where s.party='"+ul.getParty().getPartyId()+"'").list();
//request.setAttribute("rateList",slList);

// 所有权限组列表
List securityAllList = new ArrayList();
securityAllList = hs.createQuery("Select sg from SecurityGroup sg, UserLogin as ul where sg not in elements(ul.securityGroups) and ul.userLoginId='"+userLoginId+"'").list();
request.setAttribute("securityAllList",securityAllList);

// 所有模块组列表
List moduleAllList = new ArrayList();
moduleAllList = hs.createQuery("Select mg from ModuleGroup mg, UserLogin as ul where mg not in elements(ul.moduleGroups) and ul.userLoginId='"+userLoginId+"'").list();
request.setAttribute("moduleAllList",moduleAllList);


}catch(Exception e){
		System.out.println(e.getMessage());
}
%>
<br>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            <bean:message key="System.UserLogin.PageTitle1"/>
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
<%
    if(ul != null){
    	action="update";
%>
	<form action="editUserLogin.do" method="post" name="editUserLogin">
    <input type="hidden" name="action" value="<%=action%>">
	<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
	<table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.userLoginId"/>:&nbsp;</span>
        </td>
        <td>
          <span class="tabletext"><%=ul.getUserLoginId()%>&nbsp;</span><input type="hidden" name="userLoginId" value="<%=ul.getUserLoginId()%>">
        </td>
		<td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.password"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="password" class="inputBox" name="password" value="<%=ul.getCurrent_password()%>" size="20">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.name"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="name" value="<%=ul.getName()%>" size="20">
        </td>
		<td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.party"/>:&nbsp;</span>
        </td>
        <td align="left">
			<select name="partyId" onchange="javascript:onSelect()">
			<%
			Iterator it = partyList.iterator();
			while(it.hasNext()){
				Party p = (Party)it.next();
				if( ul.getParty().getPartyId().equals(p.getPartyId()) ){
					out.println("<option value=\""+p.getPartyId()+"\" selected>"+p.getDescription()+"</option>");
				}else{
					out.println("<option value=\""+p.getPartyId()+"\">"+p.getDescription()+"</option>");
				}
			}
			%>
			</select>          
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.email_addr"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="email_addr" value="<%=ul.getEmail_addr()%>" size="20">
        </td>
		<td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.enable"/>:&nbsp;</span>
        </td>
			<td align="left">
			<select name="enable">
			<%
			String enable = ul.getEnable();

			if(enable.equals("Y")){%>
				<option value="Y" selected><bean:message key="System.UserLogin.enableY"/></option>
				<option value="N"><bean:message key="System.UserLogin.enableN"/></option>
			<%}else{%>
				<option value="Y"><bean:message key="System.UserLogin.enableY"/></option>
				<option value="N" selected><bean:message key="System.UserLogin.enableN"/></option>
			<%}
			%>
			</select>        
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.note1"/>:&nbsp;</span>
        </td>
        <td align="left">
			<select name="note">
			<%if (ul.getNote().equals("EXT")) {%>
			<option value="INT">Internal</option>
			<option value="EXT" selected>External</option>
			<%} else {%>
			<option value="INT" selected>Internal</option>
			<option value="EXT">External</option>
			<%}%>
			</select>
        </td>
		<td align="right">
          <span class="tabletext">Calendar Type:&nbsp;</span>
        </td>
        <td align="left">
			<select name="TypeId">
			<%
				String tId = "";
				if (ul.getProjectCalendarType()!= null){
					tId = ul.getProjectCalendarType().getTypeId();
				}
				for (int i0 = 0; type != null && i0 < type.size(); i0++) {
					ProjectCalendarType projectCalendarType = (ProjectCalendarType)type.get(i0);
			%>
			<option value="<%=projectCalendarType.getTypeId()%>" <%=projectCalendarType.getTypeId().equals(tId) ? "selected" : ""%>	>
			<%=projectCalendarType.getDescription()%></option>
			<%
				}
			%>
			</select>          
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Intern:&nbsp;</span>
        </td>
        <td align="left">
			<select name="intern">
			
			<option value="Y" <%if (ul.getIntern().equals("Y")) { out.println("selected");}%>>Yes</option>
			<option value="N" <%if (ul.getIntern().equals("N")) { out.println("selected");}%>>No</option>
		
			</select>
        </td>
		<td align="right">
          <span class="tabletext">Type:&nbsp;</span>
        </td>
        <td align="left">
			<select name="type">
			
			<option value="other" <%if (ul.getType().equals("other")) { out.println("selected");}%>>Normal Staff</option>
			<option value="slmanager" <%if (ul.getType().equals("slmanager")) { out.println("selected");}%>>SL Manager</option>
			<option value="FTE" <%if (ul.getType().equals("FTE")) { out.println("selected");}%>>FTE</option>
			<option value="support" <%if (ul.getType().equals("support")) { out.println("selected");}%>>Support</option>
		
			</select>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Report To:&nbsp;</span>
        </td>
        <td align="left">
        	
			<%
			if (ul.getReporToPerson()!= null) {
				reportToId = ul.getReporToPerson().getUserLoginId();
				reportToName = ul.getReporToPerson().getName();
			}
			%>
			<div style="display:inline" id="labelRP"><%=reportToName%>&nbsp;</div>
			<input type="hidden" name="reportToName" maxlength="100" value="<%=reportToName%>">
			<input type="hidden" name="reportToId" value="<%=reportToId%>">
			<a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
        </td>
        <td align="right">
          <span class="tabletext">Rate Level:&nbsp;</span>
        </td>
       
        <td align="left">
         <%
			 if (slList.size()<=0){
            out.println("<font color = red>Please assign rate level for this party !</font>");
           
            }
           
            else{
           out.println(" <select  name=\"LevelId\">");
			Iterator it2= slList.iterator();
			while(it2.hasNext()){
				SalaryLevel sl = (SalaryLevel)it2.next();
				if( ul.getSalaryLevel()!=null&&ul.getSalaryLevel().getId().equals(sl.getId()) ){
					out.println("<option value=\""+sl.getId().toString()+"\" selected>"+sl.getLevel()+"</option>");
				}else{
					out.println("<option value=\""+sl.getId().toString()+"\">"+sl.getLevel()+"</option>");
				}
			}
			out.println(" </select>");
			 if (ul.getSalaryLevel()== null||ul.getSalaryLevel().getId().toString()== ""){
           out.println("<font color = red>Please assign rate level for this person ! </font>");
        }
        }%>       
        </td>
        </tr>
       <tr>
        <td align="right">
          <span class="tabletext">Join Day:&nbsp;</span>
        </td>
        <td align="left">
        	<input type="text" class="inputBox" name="joinDay" value="<%=ul.getJoinDay()!=null?dateFormat.format(ul.getJoinDay()):""%>" size="10"><A href="javascript:ShowCalendar(document.editUserLogin.dimg1,document.editUserLogin.joinDay,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A></td>
        </td>
        <td align="right">
          <span class="tabletext">Leave Day:&nbsp;</span>
        </td>
        <td align="left">
        	<input type="text" class="inputBox" name="leaveDay" value="<%=ul.getLeaveDay()!=null?dateFormat.format(ul.getLeaveDay()):""%>" size="10"><A href="javascript:ShowCalendar(document.editUserLogin.dimg2,document.editUserLogin.leaveDay,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A></td>
        </td>
       </tr>
	  	  <input type="hidden" name="role" value="<%=ul.getRole()%>">
	  	  
      <tr><td align="right">
          <span class="tabletext">Account Type:&nbsp;</span>
        </td>
        <td align="left">
			<select name="acctType">
			<option value="direct" <%if (ul.getAccountType().equals("direct")) { out.println("selected");}%>>Direct</option>
			<option value="indirect" <%if (ul.getAccountType().equals("indirect")) { out.println("selected");}%>>Indirect</option>
			</select>
        </td>

		<td>&nbsp;</td><td></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="<bean:message key="button.save"/>" class="loginButton"  onclick="fnSave()">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listUserLogin.do')">
        </td>
		<td>&nbsp;</td><td></td>
      </tr>    
        <tr><td>&nbsp;</td><td>&nbsp;</td><td></td></tr>  
    </table>
 	</form>

<%
	}else{
%>
	<form action="editUserLogin.do" method="post" name="editUserLogin">
    <input type="hidden" name="action" value="<%=action%>">
	<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.userLoginId"/>:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="userLoginId" size="20">
        </td>
		<td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.password"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="password" class="inputBox" name="password" value="" size="20">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.name"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="name" value="" size="20">
        </td>
		<td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.party"/>:&nbsp;</span>
        </td>
        <td align="left">
			<select name="partyId"  onchange="javascript:onSelect()">
			<%
			Iterator it = partyList.iterator();
			while(it.hasNext()){
				Party p = (Party)it.next();
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
          <span class="tabletext"><bean:message key="System.UserLogin.email_addr"/>:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="email_addr" value="" size="20">
        </td>
		<td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.enable"/>:&nbsp;</span>
        </td>
        <td align="left">
			<select name="enable">
				<option value="Y"><bean:message key="System.UserLogin.enableY"/></option>
				<option value="N"><bean:message key="System.UserLogin.enableN"/></option>
			</select>        
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext"><bean:message key="System.UserLogin.note1"/>:&nbsp;</span>
        </td>
        <td align="left">
			<select name="note">
			<option value="INT">Internal</option>
			<option value="EXT">External</option>
			</select>
        </td>
       
        <td align="right">
          <span class="tabletext">Calendar Type:&nbsp;</span>
        </td>
		<td align="left">
			<select name="TypeId">
			<%
				String tId = "";
				if (ul!= null){
					tId = ul.getProjectCalendarType().getTypeId();
				}
				for (int i0 = 0; type != null && i0 < type.size(); i0++) {
					ProjectCalendarType projectCalendarType = (ProjectCalendarType)type.get(i0);
			%>
			<option value="<%=projectCalendarType.getTypeId()%>" <%=projectCalendarType.getTypeId().equals(tId) ? "selected" : ""%>	>
			<%=projectCalendarType.getDescription()%></option>
			<%
				}
			%>
			</select>          
        </td>
      </tr>
       <tr>
        <td align="right">
          <span class="tabletext">Intern:&nbsp;</span>
        </td>
        <td align="left">
			<select name="intern">
			<option value="Y">Yes</option>
			<option value="N" selected>No</option>
			</select>
        </td>
        <td align="right">
          <span class="tabletext">Type:&nbsp;</span>
        </td>
        <td align="left">
			<select name="type">
			
			<option value="other" selected>other</option>
			<option value="slmanager" >SL Manager</option>
			<option value="FTE" >FTE</option>
			<option value="support">support</option>
		
			</select>
        </td>
       </tr>
        <tr>
        <td align="right">
          <span class="tabletext">Report To:&nbsp;</span>
        </td>
        <td align="left">
        	
			
			<div style="display:inline" id="labelRP"><%=reportToName%>&nbsp;</div>
			<input type="hidden" name="reportToName" maxlength="100" value="<%=reportToName%>">
			<input type="hidden" name="reportToId" value="<%=reportToId%>">
			<a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
        </td>
        
        </tr>
        <tr>
        <td align="right">
          <span class="tabletext">Join Day:&nbsp;</span>
        </td>
        <td align="left">
        	<input type="text" class="inputBox" name="joinDay" value="" size="10"><A href="javascript:ShowCalendar(document.editUserLogin.dimg1,document.editUserLogin.joinDay,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A></td>
        </td>
        <td align="right">
          <span class="tabletext">Leave Day:&nbsp;</span>
        </td>
        <td align="left">
        	<input type="text" class="inputBox" name="leaveDay" value="" size="10"><A href="javascript:ShowCalendar(document.editUserLogin.dimg2,document.editUserLogin.leaveDay,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A></td>
        </td>
       </tr>
       <tr><td align="right">
          <span class="tabletext">Account Type:&nbsp;</span>
        </td>
        <td align="left">
			<select name="acctType">
			<option value="direct" selected>Driect</option>
			<option value="indirect" >Indirect</option>
			</select>
        </td>
        <td>&nbsp;</td><td></td></tr>  
        <input type="hidden" name="role" value="STAFF">
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listUserLogin.do')">
        </td>
      </tr>      
        <tr><td>&nbsp;</td></tr>
    </table>
 	</form>
<%
	}
%> 	
  </td>
  </tr>
  <tr>
  <td>
  
<%
if(ul!=null){
 %>  
<!--======================			登陆用户权限		========================-->
<form action="editUserLogin.do" name = "aForm" method="post">
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
	 <input type="hidden" name="action" value="other">
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            User-Permissions List
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
            <table width='100%' border='0' cellspacing='0' cellpadding='0' >
              <tr>
                <td align="center" valign="center" width='100%'>
                 
                    <table width='100%' border='0' cellpadding='0' cellspacing='1'>
                      <tr >
                        <td align="left" width="40%" class="bottomBox">
                        Permissions Group Name(Avaiblable)
                        </td>
                        <td align="center" width="15%" class="bottomBox">
                         Action
                        </td>
                        <td align="left" width="40%" class="bottomBox">
                        Permissions Group Name(Granted)
                       </td>
                      </tr>
						<%
						if(ul!=null){
							
							tx = hs.beginTransaction();
							Set userSecuritys=ul.getSecurityGroups();
							tx.commit();
							if (userSecuritys!=null){
								request.setAttribute("userSecuritys",userSecuritys);
								
						%>
						<!--==================== 显示权限点列表 ====================-->

					    	<!-- =================================== -->
						
								<td width='30%'>
							    <select name="AvailSecurity" multiple size="20" style="width:100%;" class="blueselectbox">
								<%
								List securityAllList = (List)request.getAttribute("securityAllList");
								Iterator it = securityAllList.iterator();
								while(it.hasNext())
								{
									SecurityGroup per = (SecurityGroup)it.next();
								%>
									<option value="<%=per.getGroupId()%>"><%=per.getDescription()%>			
								<%}%>    
								</select>
					    	</td>
						    <td width='10%' align="center" valign="middle">
						    	<table width="100%">
						    		<tr>
						    		<td align="center"  width="100%">
						    		<input type="button" name=""  value="   >   " onclick="javascript:fnRightSecurity()" class="button" > </td>
						    		</tr>
						    		<tr>
						    		<td  align="center" valign="middle" width="100%">
						    		 <input type="button" name="" value="  >>  " onclick="javascript:fnAllRightSecurity()" class="button" > </td>
						    		</tr>
						    		<tr>
						    		<td  align="center" valign="middle" width="100%">
						    		 <input type="button"  name="" value="   <   " onclick="javascript:fnLeftSecurity()" class="button" > </td>
						    		</tr>
						    		<tr>
						    		<td  align="center" valign="middle" width="100%">
						    		 <input type="button"  name="" value="  <<  " onclick="javascript:fnAllLeftSecurity()" class="button" > </td>
						    		</tr>
						    	</table>
						    </td>
					    	<td width='30%'>
							    <select name="GrantSecurity" multiple size="20" style="width:100%;" class="blueselectbox">
								<%
								 it = userSecuritys.iterator();
								while(it.hasNext())
								{
									SecurityGroup per = (SecurityGroup)it.next();
								%>
									<option value="<%=per.getGroupId()%>"><%=per.getDescription()%>			
								<%}%>    
								</select>
					    	</td>
					    	<!-- =================================== -->

						<%
							}
						}
						%>
						<tr><td>&nbsp;</td></tr>
						<tr><td colspan=3><hr size="1">
 						<input type="button" class="inputBox" value="Save Permissions" size="20" onclick="selectAllSecurity()"> 
					    <input type="hidden" value="<%=userLoginId%>" name="userLoginId">
					    <input type="hidden"   name="add">																		          
						</td></tr>
                    </table>
                    
                </td>
              </tr>
            </table>
         </td>
        </tr>
        
</table>
  </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
  <td>

<!--======================			登陆用户菜单		========================-->  
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            User-Modules List
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
            <table width='100%' border='0' cellspacing='0' cellpadding='0' >
              <tr>
                <td align="center" valign="center" width='100%'>
                 
                    <table width='100%' border='0' cellpadding='0' cellspacing='1'>
                      <tr >
                        <td align="left" width="40%" class="bottomBox">
                            <p align="left">Module Name(Available)
                        </td>
                        <td align="center" width="15%" class="bottomBox">
                            <p align="left">Action
                        </td>
                        <td align="left" width="40%" class="bottomBox">
                            <p align="left">Module Name(Granted)
                       </td>
                      </tr>
						<%
						if(ul!=null){
							Set userModules=ul.getModuleGroups();
							if (userModules!=null){
								request.setAttribute("userModules",userModules);
						%>
						<!--==================== 显示模块组列表 ====================-->
						
						<!-- ==================================================== -->
						<tr>
							<td width='30%'>
							    <select name="AvailModule" multiple size="10" style="width:100%;" class="blueselectbox">
								<%
								List moduleAllList = (List)request.getAttribute("moduleAllList");
								Iterator it = moduleAllList.iterator();
								while(it.hasNext())
								{
									ModuleGroup per = (ModuleGroup)it.next();
								%>
									<option value="<%=per.getModuleGroupId()%>"><%=per.getDescription()%>			
								<%}%>    
								</select>
					    	</td>
						    <td width='10%' align="center" valign="middle">
						    	<table width="100%">
						    		<tr>
						    		<td align="center"  width="100%">
						    		<input type="button" name=""  value="   >   " onclick="javascript:fnRightModule()" class="button" > </td>
						    		</tr>
						    		<tr>
						    		<td  align="center" valign="middle" width="100%">
						    		 <input type="button" name="" value="  >>  " onclick="javascript:fnAllRightModule()" class="button" > </td>
						    		</tr>
						    		<tr>
						    		<td  align="center" valign="middle" width="100%">
						    		 <input type="button"  name="" value="   <   " onclick="javascript:fnLeftModule()" class="button" > </td>
						    		</tr>
						    		<tr>
						    		<td  align="center" valign="middle" width="100%">
						    		 <input type="button"  name="" value="  <<  " onclick="javascript:fnAllLeftModule()" class="button" > </td>
						    		</tr>
						    	</table>
						    </td>
					    	<td width='30%'>
							    <select name="GrantModule" multiple size="10" style="width:100%;" class="blueselectbox">
								<%
								 it = userModules.iterator();
								while(it.hasNext())
								{
									ModuleGroup per = (ModuleGroup)it.next();
								%>
									<option value="<%=per.getModuleGroupId()%>"><%=per.getDescription()%>			
								<%}%>    
								</select>
					    	</td>
					    </tr>	
						<!-- ==================================================== -->
						<%	
							}
						}
						%>                      
						<tr><td>&nbsp;</td></tr>
						<tr><td><hr size="1"></td></tr>
						<tr><td>
					          <input type="button" class="inputBox" value="Save Module" size="20" onclick="selectAllModule()">
					        <input type="hidden" value="<%=userLoginId%>" name="userLoginId">
				
						</td>	
						</tr>						
                    </table>
                </td>
              </tr>
            </table>
         </td>
        </tr>
</table>
</form>
<%
}%>
  </td>
  </tr>
    <tr><td>&nbsp;</td></tr>
</table>
<script language="javascript">
<%
String errormsg = (String)request.getAttribute("errormsg");

if(errormsg!=null){%>
alert("<%=errormsg%>")
<%}%>
</script>  
<%
Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
}catch (Exception e){
	e.printStackTrace();
	}
%>
