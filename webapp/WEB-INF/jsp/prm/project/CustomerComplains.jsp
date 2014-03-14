<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.contract.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%try{
if (AOFSECURITY.hasEntityPermission("CUST_CMPLN_TO_PM", "", session)) {
	List result = null;
	result = (List)request.getAttribute("QryList");
	List  partyList = (List)request.getAttribute("PartyList");
	if(result ==null){
		result = new ArrayList();
		request.setAttribute("QryList",result);
	}
	
	Integer offset = null;	
	if( request.getParameter("offset") == null || request.getParameter("offset").equals("") ){
		offset = new Integer(0);
	}else{
		offset = new Integer(request.getParameter("offset"));
	} 
	Integer length = new Integer(30);	
    request.setAttribute("offset", offset);
    request.setAttribute("length", length);	
    int i = offset.intValue()+1;
    SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
    NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);
%>
<script language="Javascript">

function FnSubmit() {
var date1=document.frm.textCreateDateFrom.value;
var date2=document.frm.textCreateDateTo.value;
   if(date1!=null && date2!=null)
   {
	   if(date1>date2)
	   {
		    alert("Start date is earlier than End Date!");
		    return ;
	   }
   }
			document.frm.formAction.value = "query";
			document.frm.submit();
}

function showProjectDetail(DataId) {
	if (DataId == null) {
		if (document.EditForm.ParentProjectId != null && document.EditForm.ParentProjectId.options != null) {
			DataId = document.EditForm.ParentProjectId.options[document.EditForm.ParentProjectId.selectedIndex].value;
		}
	}
	if (DataId != null && DataId != "") {
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.project.projectDetail.title&editContractProject.do?FormAction=dialogView&DataId="+DataId,
			null,
			'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:no');
	}
}

function fnSubmit1(start) {
	with (document.frm) {
		offset.value=start;
		submit();
	}
}

function exportExcel() {
	document.frm.formAction.value = "exportExcel";
	document.frm.submit();
	document.frm.formAction.value = "view";
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
			//contractType=v.split("|")[2];
			departmentId=v.split("|")[3];
			departmentNm=v.split("|")[4];
			//billToId=v.split("|")[5];
			//billToNm=v.split("|")[6];
			pmId=v.split("|")[7];
			pmName=v.split("|")[8];
			//labelProject.innerHTML=projectCode+":"+projectName;

			ProjCode.value=projectCode;
			ProjName.value=projectName;
		}
	}
}

function showDialog_staff() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.frm.PM.value=v.split("|")[0];
			//document.editUserLogin.reportToName.value=v.split("|")[1];	
			//labelRP.innerHTML=document.editUserLogin.reportToName.value;	
	}
}
</script>

<form name="frm" action="CustomerComplains.do" method="post">
<input type="hidden" name="formAction" value="view">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<CAPTION align=center class=pgheadsmall>Customer Complains to SL Manager</CAPTION>
<tr>
	<td>
	<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
		<%
		
		
		String textdep = request.getParameter("textdep");
		if (textdep==null||textdep.trim().equals(""))
		{
		 UserLogin ul=(UserLogin)request.getAttribute("userlogin");
		 textdep=ul.getParty().getPartyId();
		}
		String textCreateDateFrom = request.getParameter("textCreateDateFrom");
		String textCreateDateTo = request.getParameter("textCreateDateTo");
		String PM=request.getParameter("PM");
		String ProjName=request.getParameter("ProjName");
		String ProjCode=request.getParameter("ProjCode");
		String type=request.getParameter("type");
		String solved=request.getParameter("solved");
	    
		if (solved == null) solved ="";
		if (type == null) type ="";
		if (ProjCode == null) ProjCode ="";
		if (ProjName == null) ProjName ="";
		if (textdep == null) textdep ="";
		if (textCreateDateFrom == null) textCreateDateFrom = "";
		if (textCreateDateTo == null) textCreateDateTo = "";
		if (PM == null) PM ="";
		%>
		<tr>
				     <td class="lblbold">Department:</td>
			         <td class="lblLight">
				<select name="textdep">
					<%
					  if (partyList!=null){
						Iterator itd = partyList.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();
							if (p.getPartyId().equals(textdep)) {
					%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
					<%
							} else{
					%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
					<%
							}
						}
					}
					%>
				</select>
			</td>
			<td class="lblbold"  >PM.:</td>
				<td class="lblLight"  ><input name="PM" value="<%=PM%>" >
			    <a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" />
			    </a></td>
			  <td class="lblbold">Project:</td>
				<td class="lblLight" >
					<input  name="ProjName" value="<%=ProjName%>">
					<input type=hidden type="text" name="ProjCode" size="25" value="<%=ProjCode%>" style="TEXT-ALIGN: right" class="lbllgiht">
					
					<a href="javascript:void(0)" onclick="showProjctDialog();event.returnValue=false;">
					<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
				</td>
	   <td class="lblbold" >Type:</td>
				<td class="lblLight" >
					<select name="type">
					<option value="">(All)</option>
					<option value="PA Related" <%if (type.equals("PA Related")) out.print("selected");%>>PA Related</option>
					<option value="Technical Issue" <%if (type.equals("Technical Issue")) out.print("selected");%>>Technical Issue</option>
					<option value="Consultant Related" <%if (type.equals("Consultant Related")) out.print("selected");%>>Consultant Related</option>
					<option value="PM Related" <%if (type.equals("PM Related")) out.print("selected");%>>PM Related</option>
					<option value="Department Related" <%if (type.equals("Department Related")) out.print("selected");%>>Department Related</option>
					<option value="Sales Related" <%if (type.equals("Sales Related")) out.print("selected");%>>Sales Related</option>
					</select>
				</td>
	    </tr>	    
	   <tr>
		 <td class="lblbold">Create Date Range :</td>
		 <td class="lblLight" colspan="2">
			<input  type="text" class="inputBox" name="textCreateDateFrom" size="10" value="<%=textCreateDateFrom%>"><A href="javascript:ShowCalendar(document.frm.dimg3,document.frm.textCreateDateFrom,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg3 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
			~
			<input  type="text" class="inputBox" name="textCreateDateTo" size="10" value="<%=textCreateDateTo%>"><A href="javascript:ShowCalendar(document.frm.dimg4,document.frm.textCreateDateTo,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg4 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
		 </td>
	      <td class="lblbold"  colspan=2>Solved:
					<select name="solved">
					<option value="">(All)</option>
					<option value="YES" <%if (solved.equals("YES")) out.print("selected");%>>YES</option>
					<option value="NO" <%if (type.equals("NO")) out.print("selected");%>>NO</option>
					</select>
				</td>
	    	<td  align="middle" colspan=3>
				<input type="button" value="Query" class="button"  onclick="javascript:FnSubmit();">
			    <input type="button" value="New" class="button" onclick="location.replace('editCustComplains.do')">
			    <input type="button" value="Export Excel" class="button" onclick="" >  
			</td>
		</tr>
		<tr>
				<td colspan=8 valign="top"><hr color=red></hr></td>
		</tr>
	</table>
	</td>
</tr>
<tr>
	<td>
<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
  <TR bgcolor="#e9eee9">
  	<td align="center" class="lblbold" width="10%"><P>&nbsp;Project code&nbsp;</P></td>
	<td align="center" class="lblbold" width="10%">&nbsp;Project desc.&nbsp;</td>
	<td align="center" class="lblbold" width="10%">&nbsp;Complain No.&nbsp;</td>
	<td align="center" class="lblbold"  width="10%">&nbsp;PM</td>
	<td align="center" class="lblbold"  width="10%">&nbsp;Type&nbsp;</td>
	<td align="center" class="lblbold"  width="10%">&nbsp;Solved&nbsp;</td>
	<td align="center" class="lblbold"  width="10%">&nbsp;Create Date&nbsp;</td>
	<td align="center" class="lblbold"  width="10%">&nbsp;Create User&nbsp;</td>
	<td align="center" class="lblbold"  colspan="3" width="50%">&nbsp;Description&nbsp;</td>
  </tr>
  <%
  if(result==null||result.size()==0){
  out.println("<br><tr><td colspan='8' class=lblerr align='center'>No Record Found.</td></tr>");
  }else{
  	String newProj = "";
  	String oldProj = "";
	%>
  <logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.project.CustComplain" >                
  <tr bgcolor="#e9eee9">  
    <%   
        	if(p.getProject()!=null){
        		newProj = p.getProject().getProjId();
        		}
        	 if (!oldProj.equals(newProj)){
        		   %>
        		   <td align="left" class="lblbold">
				    <a onclick="showProjectDetail('<%=newProj%>')">
				        <div class="head4">
				        <p >
				        <%= newProj%>
				        </div>
				        </a>
				    </td>
				    <td align="left" class="lblight">
				        <div class="head4">
				        <p >
				        <%	String projName = "";
				        	if(p.getProject()!=null)
				        		projName = p.getProject().getProjName();
				        %>
				        <%= projName%>
				        </div>
				    </td>
        		   <% 
        		   oldProj=newProj;
        		}
        		else{ %>
        		 <td align="left" class="lblbold">
				    </td>
				    <td align="left" class="lblight">
				    </td>
				        <%
        		}
        %>
    
     <td align="center" class="lblight">
        <div class="head4">
        <p >
        <%	String complainCode = "";
        	if(p.getCC_Id()!=null)
        		complainCode = p.getCC_Id().toString();
        %>
         <a href="editCustComplains.do?DataId=<%= p.getCC_Id()%>">
        <%= complainCode%>
        </a>
        </div>
    </td>
     <td align="left"> 
      <div class="head4">                   
        <p ><%=p.getPM_ID() != null ? p.getPM_ID().getName() : ""%>
      </div>
    </td>
      <td align="center"> 
      <div class="head4">                   
        <p ><%=p.getType() != null ? p.getType(): ""%>
      </div>
    </td>
    <td align="center"> 
      <div class="head4">                   
        <p ><%=p.getSolved() != null ? p.getSolved(): ""%>
      </div>
    </td>
    <td align="center"> 
      <div class="head4">                   
        <p ><%=p.getCreate_Date() != null ? dateFormater.format(p.getCreate_Date()) : ""%>
      </div>
    </td>
     <td align="center"> 
      <div class="head4">                   
        <p ><%=p.getCreate_User().getName() != null ? p.getCreate_User().getName() : ""%>
      </div>
    </td>
         <td align="center">
         <% String des=p.getDescription() != null ? p.getDescription() : "";
            if (des.length()>80){
            des=des.substring(0,80)+"......";
            }
         
         %>
     <div class="head4">                   
        <p ><%=des%>
      </div>
     </td>
				</tr>
				</logic:iterate> 	
				<%}%>
					 <tr>
				<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;
				<input type=hidden name="offset" value="<%=offset%>">
				<%
				int RecordSize = result.size();
				int l = 0;
				while ((l * length.intValue()) < RecordSize) {
					if (offset.intValue() == l*length.intValue()) {%>
					&nbsp;<%=l+1%>&nbsp;
					<%} else {%>
					&nbsp;<a href="javascript:fnSubmit1(<%=l*length.intValue()%>)" title="Click here to view next set of records"><%=l+1%></a>&nbsp;
					<%};
					l++;
				}%>
				</td>
			</tr>
          </table>
         </td>

        </tr>
</table>
</form>
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}
		}catch (Exception e) { e.printStackTrace();}
%>
