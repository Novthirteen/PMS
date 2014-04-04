 
<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@page import="java.util.Date,com.aof.component.helpdesk.CallMaster" %>
<%@page import="com.aof.core.persistence.jdbc.SQLExecutor" %>
<%@page import="com.aof.core.persistence.util.EntityUtil" %>
<%@page import="com.aof.core.persistence.Persistencer" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.sql.ResultSet" %>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.util.*"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%> 
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://www.zknic.com/struts/page-taglib" prefix="page" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>
<%
String by_assignee = request.getParameter("grp_by_asnee");
String status = request.getParameter("status");
%>
<%!
	String getDiffHour(Date srcdate,Date targetDate)
	{
		if(targetDate==null||srcdate==null)
		{
			return "N/A";
		}
		else
		{
			long now=new Date().getTime();
			if (srcdate !=null) now = srcdate.getTime();
			long targetTime=targetDate.getTime();
			if(now<=targetTime)
			{
				return "N/A";
			}
			else
			{					
				// Modification : addition of code , by Bill Yu , 2005/11/21
				try{
					SQLExecutor sqlExec = new SQLExecutor(
					Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
						
					SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
					
					StringBuffer statement = new StringBuffer("");
					statement.append("	select count(*)	as freeDays");
					statement.append("	from proj_calendar	");
					statement.append("	where convert(varchar(10),PC_Date,(126))>'"+formater.format(targetDate)+"'	");
					statement.append("	and   convert(varchar(10),PC_Date,(126))<'"+formater.format(srcdate)+"'	");
					statement.append("	and   PC_Hours=0	");
					ResultSet rs = sqlExec.runQueryStreamResults(statement.toString());		
					rs.next();
				
					// free days (weekends or public holidays)
					int freeDays = rs.getInt("freeDays");
					
					sqlExec.closeConnection();				
						
					int accross_hours = (int)((now-targetTime)/1000/3600);
				//	System.out.println("Accross_hours:"+accross_hours);
				//	System.out.println("FreeDays:"+freeDays);
					
					// 9 hours a working day , 15 free hours
					int accross_days = 0;
					accross_days = accross_hours/24;
					int scattered_hours = 0;
					scattered_hours = accross_hours%24;
					
					// sum of days needed to be subtracted(only free hours which is 15)
					int substractedDays = 0;
					substractedDays = accross_days;
					if(scattered_hours > 9){
						substractedDays++;
					}
				//	System.out.println("SubstractedDays:"+substractedDays);		
			
				//  replace code below : modification by Bill Yu , 2005/11/21
				//  previous caculated hours should be substracted with free days and free hours in a day
				//	return String.valueOf((now-targetTime)/1000/3600);
			//		System.out.println("Result:"+String.valueOf((now-targetTime)/1000/3600-freeDays*24-(substractedDays-freeDays)*15));
				//	System.out.println("");
					return String.valueOf((now-targetTime)/1000/3600-freeDays*24-(substractedDays-freeDays)*15);
					
				}catch(Exception ex){
					ex.printStackTrace();
					return String.valueOf(-1); // error sign
				}			
				// Modification ends
			}
		}
	}
%>
<%try{%>
<html> 
	<head>
		<title>JSP for callQueryForm form</title>
		<html:javascript formName="callQueryForm"/> 
		<script language="JavaScript" src="includes/date/date.js"></script>
		<script >
			function setDivLabel(o,v)
	    	{
	    		o.innerHTML=getHTML(v);
	    	}
	    	function setDivLabel2(o,v)
	    	{
	    		o.innerHTML=getHTML2(v);
	    	}
	    	
	    	function setLabelRequestType(v)
	    	{
	   			setDivLabel(labelRequestType,v);
	   			with(document.callQueryForm)
		    	{
		    		requestType_desc.value=v;
		    	}
	    	}
	    	function setLabelPriority(v)
	    	{
				setDivLabel(labelPriority,v);
				with(document.callQueryForm)
		    	{
					priority_desc.value=v;
				}
	    	}
	    	function setLabelCompany(v)
	    	{
	    		setDivLabel2(labelCompany,v);
	    		with(document.callQueryForm)
		    	{
					company_name.value=v;
				}
	    	}
	    	function setLabelContact(v)
	    	{
	    		setDivLabel(labelContact,v);
	    		with(document.callQueryForm)
		    	{
					contact_name.value=v;
				}
	    	}
	    	function setLabelParty(v)
	    	{
	    		setDivLabel2(labelParty,v);
	    		with(document.callQueryForm)
		    	{
		    		party_name.value=v;
		    	}
	    	}
	    	function setLabelUser(v)
	    	{
	    		setDivLabel(labelUser,v);
	    		with(document.callQueryForm)
		    	{
		    		user_name.value=v;
		    	}
	    	}
	    	
	    	function getHTML2(v)
	    	{
	    		if(v=="") return v;
	    		else return v+"&nbsp;/&nbsp;";
	    	}
	   	
	    	function getHTML(v)
	    	{
	    		if(v=="") return v;
	    		else return v+"&nbsp;";
	    	}
			
			function showRequestTypeDialog()
	    	{
		    	with(document.callQueryForm)
		    	{
			    	v = window.showModalDialog(
			    		"helpdesk.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&helpdesk.showSLACategoryTreeDialog.do?"+
			    		"&activeid="+requestType_id.value,
			    		 null,
			    		 'dialogWidth:310px;dialogHeight:335px;status:no;help:no;scroll:no'
			    	);			    		//"partyid="+	company_partyId.value+
			    	if (v != null) 
			    	{
			    		if(requestType_id.value!=v[0])
			    		{
							clearPriority();
							requestType_id.value=v[0];
							setLabelRequestType(v[1]);
			    		}
				    }
				 }
	    	}
	    	function clearRequestType()
	    	{
	    		with(document.callQueryForm)
		    	{
		    		requestType_id.value="";
		    		setLabelRequestType("");
		    	}
		    	clearPriority();
	    	}
	    	function clearPriority()
	    	{
	    		with(document.callQueryForm)
		    	{
					priority_id.value="";
					setLabelPriority("");
		    	}
	    	}
	    	function clearCompany()
	    	{
	    		with(document.callQueryForm)
		    	{
					company_id.value="";
					setLabelCompany("");
					clearContact();
		    	}
	    	}
	    	function clearContact()
	    	{
	    		with(document.callQueryForm)
		    	{
					contact_id.value="";
					setLabelContact("");
		    	}
	    	}
	    	function showCompanyDialog(tab)
	    	{
	    		with(document.callQueryForm)
		    	{
			    	v = window.showModalDialog(
			    		"helpdesk.EnterQuery.do?style=1&tab="+tab,//query=1
			    		 null,
			    		 'dialogWidth:428px;dialogHeight:597px;status:no;help:no;scroll:no'
			    	);
			    	if (v != null) 
			    	{
			    		if(company_id.value!=v["party"]["partyid"])
			    		{
			    			clearRequestType();
			    		}
						company_id.value=v["party"]["partyid"];
						setLabelCompany(v["party"]["description"]);
						
						if(v["user"]["name"]!="")
						{
							contact_id.value=v["user"]["user_login_id"];
							setLabelContact(v["user"]["name"]);
						}
				    }
				 }
	    	}
	    	
	    	function setDisplay(o1,o2)
	    	{
	    		 o1.style.setExpression("display",
	    			"document.callQueryForm."+o2+".value==''?'none':'inline'")
	    	}
	    	
	    	function init()
	    	{
	    		with(document.callQueryForm)
	    		{
		    		/*requestType_desc.setExpression("title",
				      "this.value"
				    );
				    priority_desc.setExpression("title",
				      "this.value"
				    );
				    company_name.setExpression("title",
				      "this.value"
				    );*/
				    setDisplay(cmdClearCompany,"company_id");
				    setDisplay(cmdClearContact,"contact_id");
				    setDisplay(cmdClearRequestType,"requestType_id");
				    setDisplay(cmdClearPriority,"priority_id");
				    setDisplay(cmdClearParty,"party_id");
				    setDisplay(cmdClearUser,"user_id");
				    
				    labelCompany.style.setExpression("color",
				      "document.callQueryForm.company_id.value==''?'red':'black'"
				    );
				    labelContact.style.setExpression("color",
				      "document.callQueryForm.contact_id.value==''?'red':'black'"
				    );
				    
				    
				    /*contact_name.setExpression("title",
				      "this.value"
				    );
				    party_name.setExpression("title",
				      "this.value"
				    );
				    user_name.setExpression("title",
				      "this.value"
				    );*/
				}
	    	}
	    	function showPriorityDialog()
	    	{
				with(document.callQueryForm)
				{
					if(requestType_id.value=="")
					{
						alert("Please select request type first.");
						return ;
					}
		    		v = window.showModalDialog(
		    			"helpdesk.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&helpdesk.showSLAPriorityDialog.do?"+
		    			"categoryid="+requestType_id.value+
		    			"&activeid="+priority_id.value, 
		    			null,
		    			'dialogWidth:760px;dialogHeight:340px;status:no;help:no;scroll:no');
			    	if (v != null) 
			    	{
			    		priority_id.value=v[0];
			    		setLabelPriority(v[1]);
				    }
				}
	    	}
			function showPartyDialog(tab)
    		{
	    		with(document.callQueryForm)
		    	{
			    	v = window.showModalDialog(
			    		"helpdesk.EnterQuery.do?type=1&tab="+tab,
			    		 null,
			    		 'dialogWidth:428px;dialogHeight:597px;status:no;help:no;scroll:no'
			    	);
			    	
			    	if (v != null) 
			    	{
			    		//if(party_id.value!=v["party"]["partyid"])//change
			    		{
			    			clearParty();
			    		}

						party_id.value=v["party"]["partyid"];
			    		setLabelParty(v["party"]["description"]);
			    		
						if(v["user"]["name"]!="")
						{
							user_id.value=v["user"]["user_login_id"];
							setLabelUser(v["user"]["name"]);
						}
				    }
				 }
    		}
    		function clearParty()
    		{
    			with(document.callQueryForm)
		    	{
		    		party_id.value="";
		    		setLabelParty("");
		    	}
		    	clearUser();
    		}
    		function clearUser()
    		{
    			with(document.callQueryForm)
		    	{
		    		user_id.value="";
		    		setLabelUser("");
		    	}
    		}
    		function resetAll()
    		{
    			with(document.callQueryForm)
		    	{
					ticketNo.value="";
					callType.selectedIndex=0;
					status.selectedIndex=0;
					clearParty();
					clearCompany();
					clearRequestType();	
					solveHour.value="";
					closeHour.value="";
					responseHour.value="";
					requestDate1.value="";
					requestDate2.value="";
					requestType2.selectedIndex=0;
					
						    		
		    	}
    		}
    		function changeCallType()
    		{
    			document.callQueryForm.action='helpdesk.queryCall.do';
				var command;
				command="document.callQueryForm.submit()";
				setTimeout(command,10);
    		}
    		
			function ExportAllDay() {
				var formObj = document.callQueryForm;
				formObj.issue.value="";
				formObj.action = "helpdesk.reportCall.do";
				formObj.allday.value="y";
				formObj.target = "_blank";
			}
    		
			function ExportIssueLog() {
				var formObj = document.callQueryForm;
				formObj.action = "helpdesk.reportCall.do";
				formObj.issue.value="y";
				formObj.target = "_blank";
			}

			function ExportExcel() {
				var formObj = document.callQueryForm;
				formObj.issue.value="";
				formObj.allday.value="n";
				formObj.action = "helpdesk.reportCall.do";
				formObj.target = "_blank";
				formObj.submit();
			}
			function FnQuery() {
				var formObj = document.callQueryForm;
				formObj.action = "helpdesk.findCall.do";
				formObj.target = "_self";
				formObj.submit();
			}
			function onlyMyself(){
				<%
					UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				%>
				with(document.callQueryForm){
					party_id.value="<%=ul.getParty().getPartyId()%>";
			    	setLabelParty("<%=ul.getParty().getDescription()%>");
			    	user_id.value="<%=ul.getUserLoginId()%>";
					setLabelUser("<%=ul.getName()%>");
				}
			}
		</script>
	</head>
	<body onload="init()">
		<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
			marginWidth=0 noResize 
			scrolling=no src="includes/date/calendar.htm" 
			style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
		</IFRAME>
		<html:form action="/helpdesk.findCall.do" focus="ticketNo" >
			<input type="hidden" name="allday" id = "allday">
			<input type="hidden" name="issue" id = "issue">
			<html:hidden property="pageSize"/>
			<html:hidden property="order"/>
			<html:hidden property="descend"/>
			<table>	
				<tr>
							
				</tr>
				<tr height="25">
					<td ><bean:message key="helpdesk.call.type" /> :</td>
					<td>
						<html:select property = "callType"  onchange="changeCallType()">
				        <html:options collection = "queryCall_callTypeList" property = "type" labelProperty = "typedesc"/>
				     	</html:select>
				     </td>
					<td width="10">&nbsp;</td>
					<td ><bean:message key="helpdesk.call.number.full" /> :</td>
					<td><html:text property="ticketNo" size="13" maxlength="9"/></td>
					<td width="10">&nbsp;</td>
					<td >
						<bean:message key="helpdesk.call.requestType" />:
					</td>
					<td  >
						<html:select property = "requestType2" >
							<option value="">&nbsp;</option>
			                <html:options collection = "queryCall_requestTypeList" property = "id" labelProperty = "description"/>
				         </html:select>
					</td>

					<td width="10">&nbsp;</td>
					<td><bean:message key="helpdesk.call.actionTrack.status" />:</td>
					<td>
						<html:select property = "status">
						<option value="">&nbsp;</option>
						<!-- value 99 means status "unclosed" -->
						<option value="99" <%=status!=null&&status.equals("99")?"selected":""%> onclick="find_unclosed();">UnClosed</option>
						<html:options collection = "queryCall_statusTypes" property = "id" labelProperty = "desc"/>
    			        </html:select>
					</td>
					
				</tr>
				<tr height="25">
					<td><bean:message key="helpdesk.call.customer" />/<bean:message key="helpdesk.call.contact" />:</td>
					<td colspan="4" align="left"  valign="middle">
						<div id="labelCompany" style="display:inline"><bean:write name="callQueryForm" property="company_name"/><logic:notEmpty name="callQueryForm" property="company_name">&nbsp;/&nbsp;</logic:notEmpty></div><div id="labelContact" style="display:inline"><bean:write name="callQueryForm" property="contact_name"/><logic:notEmpty name="callQueryForm" property="contact_name">&nbsp;</logic:notEmpty></div>
						<a href="javascript:void(0)" onclick="showCompanyDialog(1);event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						<a id="cmdClearCompany" href="javascript:void(0)" onclick="clearCompany();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.clear" /><bean:message key="helpdesk.call.customer" />" src="images/deleteParty.gif" border="0" /></a>
						<a id="cmdClearContact" href="javascript:void(0)" onclick="clearContact();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.clear" /><bean:message key="helpdesk.call.contact" />" src="images/deleteUser.gif" border="0" /></a>
						<html:hidden property="company_id"/>
						<html:hidden property="contact_id"/>
						<html:hidden property="company_name"/>
						<html:hidden property="contact_name"/>
						
					</td>
					
					<td width="10">&nbsp;</td>
					<td >
						<bean:message key="helpdesk.call.assignmentGroup" />/<bean:message key="helpdesk.call.assignee" />:
					</td>
					<td  colspan="10">
						<div style="display:inline" id="labelParty"><bean:write name="callQueryForm" property="party_name"/><logic:notEmpty name="callQueryForm" property="party_name">&nbsp;/&nbsp;</logic:notEmpty></div><div style="display:inline" id="labelUser"><bean:write name="callQueryForm" property="user_name"/><logic:notEmpty name="callQueryForm" property="user_name">&nbsp;</logic:notEmpty></div>
						<a href="javascript:void(0)" onclick="showPartyDialog(1);event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						<a id="cmdClearParty" href="javascript:void(0)" onclick="clearParty();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.clear" /><bean:message key="helpdesk.call.assignmentGroup" />" src="images/deleteParty.gif" border="0" /></a>
						<a id="cmdClearUser" href="javascript:void(0)" onclick="clearUser();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.clear" /><bean:message key="helpdesk.call.assignee" />" src="images/deleteUser.gif" border="0" /></a>
						&nbsp;<a href="#" onclick="onlyMyself();">myself</a>
						<html:hidden property="party_name"/>
						<html:hidden property="party_id"/>
						<html:hidden property="user_name"/>
						<html:hidden property="user_id"/>
					</td>
				</tr>
				<tr height="25">
					<td><bean:message key="helpdesk.call.category" />:</td>
					<td colspan="4"><div style="display:inline" id="labelRequestType"><bean:write name="callQueryForm" property="requestType_desc" /><logic:notEmpty name="callQueryForm" property="requestType_desc" >&nbsp;</logic:notEmpty></div>
						<a href="javascript:void(0)" onclick="showRequestTypeDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						<a id="cmdClearRequestType" href="javascript:void(0)" onclick="clearRequestType();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.clear" />" src="images/deleteMe.gif" border="0" /></a>
						<html:hidden property="requestType_id" />
						<html:hidden property="requestType_desc" />
					</td>
					<td width="10">&nbsp;</td>
					<td><bean:message key="helpdesk.call.priority" />:</td>
					<td ><div style="display:inline" id="labelPriority"><bean:write name="callQueryForm" property="priority_desc" /><logic:notEmpty name="callQueryForm" property="priority_desc" >&nbsp;</logic:notEmpty></div>
						<a href="javascript:void(0)" onclick="showPriorityDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						<a id="cmdClearPriority" href="javascript:void(0)" onclick="clearPriority();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.clear" />" src="images/deleteMe.gif" border="0" /></a>
						<html:hidden property="priority_id" />
						<html:hidden property="priority_desc" />
					</td>
				</tr>
				<tr height="25">
					
				</tr>
				<tr height="25">
					<td><bean:message key="helpdesk.call.query.header.requestDate" />:</td>
					<td colspan="4">
						<html:text property="requestDate1" maxlength="10" size="13"/>&nbsp;<A href="javascript:ShowCalendar(document.callQueryForm.dimg1,document.callQueryForm.requestDate1,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align="absMiddle" border="0" id="dimg1" src="images/datebtn.gif" ></A>
						--&gt;
						<html:text property="requestDate2" maxlength="10" size="13"/>&nbsp;<A href="javascript:ShowCalendar(document.callQueryForm.dimg2,document.callQueryForm.requestDate2,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align="absMiddle" border="0" id="dimg2" src="images/datebtn.gif" ></A>							
					</td>
					<td width="10">&nbsp;</td>
					<td>Problem Type:</td>
					<td>
						<html:select property = "problemType">
							<option value="">&nbsp;</option>
							<html:options collection = "queryCall_problemTypeList" property = "id" labelProperty = "desc"/>
						</html:select>
					</td>
				</tr>
				<tr height="25">

					<td >
						<bean:message key="helpdesk.call.exceed.response" />:
					</td>
					<td  >
						<html:text property="responseHour" maxlength="3" size="3"/>
					</td>
					<td width="10">&nbsp;</td>
					<td >
						<bean:message key="helpdesk.call.exceed.solved" />:
					</td>
					<td  >
						<html:text property="solveHour" maxlength="3" size="3"/>
					</td>
					<td width="10">&nbsp;</td>
					<td >
						<bean:message key="helpdesk.call.exceed.close" />:
					</td>
					<td  >
						<html:text property="closeHour" maxlength="3" size="3"/>
					</td>
				</tr>
				<tr height="25">
					<td>Group by Assignee:</td>
					<td colspan="6"><input type="checkbox" name="grp_by_asnee" class="checkboxstyle" <%=by_assignee==null?"":"checked"%>>&nbsp;<font color="red">This checkbox only affects the result when exporting to excel</font></td>
				</tr>	
				<tr>
					<td colspan="6" align="right"><input type="button" value="<bean:message key="helpdesk.call.submit"/>" onclick="FnQuery()"/>&nbsp;<input type="button" value="<bean:message key="helpdesk.call.reset"/>" onclick="resetAll()"/>&nbsp;
					<input type="button" value="ExportToExcel" onclick="ExportExcel()"/>&nbsp;
					<input type="submit" value="Export 24Hours" onclick="ExportAllDay()"/>&nbsp;
					<input type="submit" value="Export ServiceLine Issue Log" onclick="ExportIssueLog()"/>
					</td>
				</tr>
			</table>			
			
			<br>
			
		</html:form><br>
		<html:errors />
		<html:messages id="msg" message="true">
			<li><bean:write name="msg" /></li>
		</html:messages>
		<logic:notEmpty name="results" >
			<page:form action="/helpdesk.findCall.do" method="post">
			<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
			  <TR  height="18">
			    <TD width='100%'>
			      <table height="18" width='100%' border='0' cellspacing='0' cellpadding='0'>
			        <tr>
			          <TD align=left width='90%' class="topBox">
				          <bean:message key="helpdesk.call.query.result" />
			          </TD>
			        </tr>
			      </table>
			    </TD>
			  </TR>
			  <TR>
			    <TD width='100%'>
			<table border='0' cellpadding='0' cellspacing='1' width='100%'>
				<thead>
				<tr height="18">
					<td class="bottomBox"><page:order order="call.contactInfo.companyName" style="text-decoration : none"><bean:message key="helpdesk.call.customer" />&nbsp;<page:desc><img src="images/down.gif" border="0"/></page:desc><page:asc><img src="images/up.gif" border="0"/></page:asc></page:order></td>
					<td class="bottomBox"><page:order order="call.contactInfo.contactName" style="text-decoration : none"><bean:message key="helpdesk.call.query.header.customerContact" />&nbsp;<page:desc><img src="images/down.gif" border="0"/></page:desc><page:asc><img src="images/up.gif" border="0"/></page:asc></page:order></td>
					<td class="bottomBox"><bean:message key="helpdesk.call.confirm.contactNumber" /></td>
					<td class="bottomBox"><page:order order="call.ticketNo" style="text-decoration : none"><bean:message key="helpdesk.call.number.full" />&nbsp;<page:desc><img src="images/down.gif" border="0"/></page:desc><page:asc><img src="images/up.gif" border="0"/></page:asc></page:order></td>
					<td class="bottomBox"><page:order order="call.acceptedDate" style="text-decoration : none"><bean:message key="helpdesk.call.query.header.requestDate" />&nbsp;<page:desc><img src="images/down.gif" border="0"/></page:desc><page:asc><img src="images/up.gif" border="0"/></page:asc></page:order></td>
					<td class="bottomBox"><page:order order="call.subject" style="text-decoration : none"><bean:message key="helpdesk.call.query.header.subject" />&nbsp;<page:desc><img src="images/down.gif" border="0"/></page:desc><page:asc><img src="images/up.gif" border="0"/></page:asc></page:order></td>
					
					<td class="bottomBox"><page:order order="call.sumCost" style="text-decoration : none"><bean:message key="helpdesk.call.query.header.workingHours" />&nbsp;<page:desc><img src="images/down.gif" border="0"/></page:desc><page:asc><img src="images/up.gif" border="0"/></page:asc></page:order></td>
					
					
					<td class="bottomBox"><bean:message key="helpdesk.call.category" /></td>
					
					<td class="bottomBox"><bean:message key="helpdesk.call.query.header.problemType"/></td>
					
					<td class="bottomBox">Assignee</td>
					
					<td class="bottomBox"><bean:message key="helpdesk.call.query.header.solvedBy" /></td>

					<td class="bottomBox"><page:order order="call.solvedDate" style="text-decoration : none"><bean:message key="helpdesk.call.query.header.solvedDate" />&nbsp;<page:desc><img src="images/down.gif" border="0"/></page:desc><page:asc><img src="images/up.gif" border="0"/></page:asc></page:order></td>					
					
					<td class="bottomBox"><page:order order="call.status.desc" style="text-decoration : none"><bean:message key="helpdesk.call.actionTrack.status" />&nbsp;<page:desc><img src="images/down.gif" border="0"/></page:desc><page:asc><img src="images/up.gif" border="0"/></page:asc></page:order></td>
					
					<td class="bottomBox" width="55"><bean:message key="helpdesk.call.query.header.missedResponse" /></td>
					
					<td class="bottomBox" width="55"><bean:message key="helpdesk.call.query.header.missedSolve" /></td>
					
					<td class="bottomBox" width="55"><bean:message key="helpdesk.call.query.header.missedClose" /></td>
					
					
					<td class="bottomBox"><bean:message key="helpdesk.call.edit" /></td>
				</tr>
				</thead>
				<logic:iterate id="call" name="results">
					<tr>
						<td><bean:write name="call" property="contactInfo.companyName"/></td>
						<td><bean:write name="call" property="contactInfo.contactName"/></td>
						<td><logic:notEmpty name="call" property="company"><bean:write name="call" property="company.note"/></logic:notEmpty></td>
						
						<td><bean:write name="call" property="ticketNo"/></td>
						<td><bean:write name="call" property="acceptedDate" format="yyyy-MM-dd"/></td>
						<td><bean:write name="call" property="subject"/></td>
						
						<td><bean:write name="call" property="sumCost"/></td>
						
						<td><bean:write name="call" property="requestType.engDesc"/></td>
						
						<td><bean:write name="call" property="problemType.desc"/></td>
						
						<td><bean:write name="call" property="assignedUser.name"/></td>
						
						<td><logic:empty name="call" property="solveUser">N/A</logic:empty><logic:notEmpty name="call" property="solveUser"><bean:write name="call" property="solveUser.name"/></logic:notEmpty></td>
						
						<td><logic:empty name="call" property="solvedDate">N/A</logic:empty><bean:write name="call" property="solvedDate" format="yyyy-MM-dd"/></td>
						
						<td><bean:write name="call" property="status.desc"/></td>

						<%CallMaster aCall=(CallMaster)pageContext.getAttribute("call");%>						

						<%String hour=getDiffHour(aCall.getResponseDate(),aCall.getTargetResponseDate());%>
						<td style="<%=hour.equals("N/A")?"":"color:red"%>"><%=hour%></td>
						<%hour=getDiffHour(aCall.getSolvedDate(),aCall.getTargetSolvedDate());%>
						<td style="<%=hour.equals("N/A")?"":"color:red"%>"><%=hour%></td>
						<%hour=getDiffHour(aCall.getClosedDate(),aCall.getTargetClosedDate());%>
						<td style="<%=hour.equals("N/A")?"":"color:red"%>"><%=hour%></td>
						
						
						
						
						<td><a target="_blank" href="helpdesk.edit<bean:write name="call" property="type.name"></bean:write>.do?id=<bean:write name="call" property="callID"/>"><bean:message key="helpdesk.call.edit" /></a></td>
					</tr>
				</logic:iterate>
				<tr class="bottomBox">
					<td colspan="16" >
									
							<table width='100%' border='0' cellpadding='0' cellspacing='0'>
							<tr>
								<td class="pageinfobold"  align="right">
									<bean:message key="page.total" />&nbsp;<page:pageCount />&nbsp;
									<bean:message key="page.pages" />&nbsp;&nbsp;
									<bean:message key="page.now" />&nbsp;<page:select  styleClass="pageinfo" format="page.format" resource="true"/>
									<page:noPrevious><image align="absmiddle" alt="<bean:message key="page.prevpage" />" src="images/noprev.gif" border=0/></page:noPrevious>
									<page:previous><image align="absmiddle" alt="<bean:message key="page.prevpage" />" src="images/prev2.gif" border=0/></page:previous>
									<page:next><image align="absmiddle" alt="<bean:message key="page.nextpage" />" src="images/next2.gif" border=0/></page:next>
									<page:noNext><image align="absmiddle" alt="<bean:message key="page.nextpage" />" src="images/nonext.gif" border=0/></page:noNext>&nbsp;
								</td>
							</tr>
							</table>
						      
					</td>
				</tr>
			</table>
			</td>
		<tr>	
		</table>
		</page:form>		
		</logic:notEmpty>
	</body>
</html>
<%}catch(Exception e)
{out.println("error in jsp");e.printStackTrace();}
%>

