<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>
<%@ page import="java.util.*" %>
<%@ page import="com.aof.core.persistence.jdbc.SQLExecutor" %>
<%@ page import="com.aof.core.persistence.util.EntityUtil" %>
<%@ page import="com.aof.core.persistence.Persistencer" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%
try{

%>
<html:javascript formName="callForm"/>

<html:form action="<%="/"+request.getParameter("action")%>" method="post" onsubmit="return validateCallForm(this)">
<%	com.shcnc.struts.form.BeanActionForm form =
		(com.shcnc.struts.form.BeanActionForm)pageContext.getAttribute(org.apache.struts.taglib.html.Constants.BEAN_KEY,  PageContext.REQUEST_SCOPE);
	final String callType_type=(String)form.get("type_type");
	final String callType_name=(String)form.get("type_name");
%>

<script>
    	function showCompanyDialog(tab)
    	{
    		with(document.callForm)
	    	{
		    	v = window.showModalDialog(
		    		"helpdesk.EnterQuery.do?tab="+tab,//query=1
		    		 null,
		    		 'dialogWidth:428px;dialogHeight:597px;status:no;help:no;scroll:no'
		    	);
		    	
		    	if (v != null) 
		    	{
		    	//	if(company_partyId.value!=v["party"]["partyid"])
		    	//	{
		    	//		clearRequestType();
		    	//	}
		    		
		    		company_partyId.value=v["party"]["partyid"];
			    	setLabelCompany(v["party"]["description"]);
			    		
					if(company_partyId.value=="")
					{
						contactInfo_province.value=v["party"]["province"];
						setLabelCompanyNote("");
					}
					else
					{
						setLabelCompanyNote(v["party"]["note"]);
					}
					
					//contact
					if(v["user"]["name"]!="")
					{
			    		contact_userLoginId.value=v["user"]["user_login_id"];
			    		setLabelContact(v["user"]["name"]);
						
						//contact info
						contactInfo_teleCode.value=v["user"]["tel"];
						contactInfo_email.value=v["user"]["email"];
						contactInfo_mobileCode.value=v["user"]["mobile"];
						if(contact_userLoginId.value!="")
						{
							contactInfo_fax.value="";
						}
						else
						{
							contactInfo_fax.value=v["user"]["fax"];
						}
					}
			    }
			 }
    	}
    	
    	
    	function setDivLabel(o,v)
    	{
    		o.innerHTML=(v);
    	}
    	/*function setDivLabel2(o,v)
    	{
    		o.innerHTML=getHTML2(v);
    	}*/
    	
    	function setLabelRequestType(v)
    	{
   			setDivLabel(labelRequestType,v);
   			with(document.callForm)
    		{
    			requestType_engDesc.value=v;
    		}
    	}
    	function setLabelPriority(v)
    	{
			setDivLabel(labelPriority,v);
			with(document.callForm)
    		{
    			priority_engDesc.value=v;
    		}
    	}
    	function setLabelCompany(v)
    	{
    		setDivLabel(labelCompany,v);
    		with(document.callForm)
    		{
    			contactInfo_companyName.value=v;
    		}
    	}
    	function setLabelContact(v)
    	{
    		setDivLabel(labelContact,v);
    		with(document.callForm)
    		{
    			contactInfo_contactName.value=v;
    		}
    	}
    	
    	function setLabelCompanyNote(v)
    	{
    		setDivLabel(labelCompanyNote,v);
    		with(document.callForm)
    		{
    			company_note.value=v;
    		}
    	}
    	function setLabelParty(v)
    	{
    		setDivLabel(labelParty,v);
    		with(document.callForm)
    		{
    			assignedParty_description.value=v;
    		}
    	}
    	function setLabelUser(v)
    	{
    		setDivLabel(labelUser,v);
    		with(document.callForm)
    		{
    			assignedUser_name.value=v;
    		}
    	}
    	
    	/*function getHTML2(v)
    	{
    		if(v=="") return v;
    		else return v+"&nbsp;/&nbsp;";
    	}*/
   	
    	/*function getHTML(v)
    	{
    		if(v=="") return v;
    		else return v+"&nbsp;";
    	}*/
    	
    	function clearPriority()
    	{
    		with(document.callForm)
    		{
	    		priority_id.value="";
	    		setLabelPriority("");
			}
    	}
    	
    	function clearRequestType()
    	{
    		with(document.callForm)
    		{
	    		requestType_id.value="";
	    		setLabelRequestType("");
				clearPriority();
			}
    	}
    	
    	function clearAssignedUser()
    	{
    		with(document.callForm)
	    	{
		    	assignedUser_userLoginId.value="";
		    	setLabelUser("");
	    	}
    	}
    	
    	function showPartyDialog(tab)
    	{
    		with(document.callForm)
	    	{
		    	v = window.showModalDialog(
		    		"helpdesk.EnterQuery.do?type=1&tab="+tab,
		    		 null,
		    		 'dialogWidth:428px;dialogHeight:597px;status:no;help:no;scroll:no'
		    	);
		    	
		    	if (v != null) 
		    	{
					//if(assignedParty_partyId.value!=v["party"]["partyid"])
					{
						clearAssignedUser();
					}
					
					assignedParty_partyId.value=v["party"]["partyid"];
					setLabelParty(v["party"]["description"]);
					
					if(v["user"]["name"]!="")
					{
						assignedUser_userLoginId.value=v["user"]["user_login_id"];
						setLabelUser(v["user"]["name"]);
					}
			    }
			 }
    	}
    	function showRequestTypeDialog()
    	{
	    	with(document.callForm)
	    	{
		    	v = window.showModalDialog(
		    		"helpdesk.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&helpdesk.showSLACategoryTreeDialog.do?"+
		    		"partyid="+	company_partyId.value+
		    		"&activeid="+requestType_id.value,
		    		 null,
		    		 'dialogWidth:310px;dialogHeight:335px;status:no;help:no;scroll:no'
		    	);
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
    	function showPriorityDialog()
    	{
			with(document.callForm)
			{
				if(requestType_id.value=="")
				{
					alert("<bean:message key="helpdesk.call.selectRequestTypeFirst"/>");
					return ;
				}
	    		v = window.showModalDialog(
	    			"helpdesk.showDialog.do?title=helpdesk.servicelevel.priority.dialog.title&helpdesk.showSLAPriorityDialog.do?"+
	    			"categoryid="+document.callForm.requestType_id.value+
	    			"&activeid="+priority_id.value, 
	    			null,
	    			'dialogWidth:760px;dialogHeight:340px;status:no;help:no;scroll:no');
		    	if (v != null) 
		    	{
					if(priority_id.value!=v[0])
		    		{
		    			var theDate=unFormatTime(acceptedDate.value);
		    			targetResponseDate.value=computeDate(theDate,v[2]);
		    			targetSolvedDate.value=computeDate(theDate,v[3]);
		    			targetClosedDate.value=computeDate(theDate,v[4]);
						syncValue();
		    		}
		    		priority_id.value=v[0];
		    		setLabelPriority(v[1]);
			    }
			}
    	}
    	/*function setTitleToValue(o)
    	{
    		o.setExpression("title","this.value");
    	}*/
    	function computeDate(theDate,hour)
    	{
    		if(hour==null||hour=="")
    		{
	    		return "";
	    	}
    		else
    		{
    			//how many days will be acrossed
				var accross_days = 0;
				//convert type from string to int
    			hour = hour/1;	
    			//9 hours one working day , from 9:00 to 18:00
    			var dayCount = hour/9;
    			var hourCount = hour%9;

    			//convert type of dayCount from float to integer
    			if(dayCount != Math.ceil(dayCount)){
    				dayCount = Math.ceil(dayCount)-1;
    			}
    			
    			//accross_days is equal to dayCount or dayCount + 1 , according to the other conditions
    			accross_days = dayCount;
    			
    			//reset hour which will be added
    			hour = 0;
    			hour = hour + dayCount*24;
    			//current time is in working hours
    			if(theDate.getHours()<=18 && theDate.getHours()>=9){
    				//expected time will be in the period out of work
    				if(hourCount+theDate.getHours()>=18){
    					hour = hour + 15 + hourCount;
    					accross_days++;
    				}else{
    					hour = hour + hourCount;
    				}
    			}else{
    				//when out of work , over_hour is the time period from 18:00 to current time
    				var over_hour = ((theDate.getHours()<9)?(theDate.getHours()+24):theDate.getHours()) - 18;
    				hour = hour + hourCount + (15 - over_hour);
    				accross_days++;
    			}
    		//-------------------------------------------------------------------------
	    		<%
					SQLExecutor sqlExec = new SQLExecutor(
					Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
						
					SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
					Calendar ca = Calendar.getInstance();
					ca.setTime(new java.util.Date());
					java.util.Date now = ca.getTime();
					//next month
					ca.add(2,1);
					java.util.Date month_later = ca.getTime();
					
					StringBuffer statement = new StringBuffer("");
					statement.append("	select PC_Hours	");
					statement.append("	from proj_calendar	");
					statement.append("	where convert(varchar(10),PC_Date,(126))>'"+formater.format(now)+"'	");
					statement.append("	and   convert(varchar(10),PC_Date,(126))<'"+formater.format(month_later)+"'	");
					ResultSet rs = sqlExec.runQueryStreamResults(statement.toString());
				%>
			
				//store one month 's records in 'every_day' array
				var every_day = new Array(31);
				var i = 0;
				<%while(rs.next()){%>
					every_day[i] = <%=rs.getDouble("PC_Hours")%>;
					i++;
				<%}%> 
				<%sqlExec.closeConnection();%>
				
				var n = accross_days;
				var m = 0;
				while(n>0){
					if(every_day[m]==0){						
						hour = hour + 24;
					}else{
						n--;
					}
					m++;
				}
    			return formatTime(addHour(theDate,hour));
    		}
    	}
    	
    	function setDisplay(o1,o2)
    	{
    		o1.style.setExpression("display",
	    			"document.callForm."+o2+".value==''?'none':'inline'");
    	}
    	
    	function init()
    	{
    		with(document.callForm)
    		{
	    		labelCompany.style.setExpression("color",
			      "document.callForm.company_partyId.value==''?'red':'black'"
			    );
			    labelContact.style.setExpression("color",
			      "document.callForm.contact_userLoginId.value==''?'red':'black'"
			    );
			    setDisplay(cmdShowCompanyInfo,"company_partyId");
			    setDisplay(cmdClearUser,"assignedUser_userLoginId");
	    		setDisplay(labelCompanyPost,"contactInfo_companyName");	
	    		setDisplay(labelCompanyNoteOutter,"company_partyId");	
	    		setDisplay(labelContactPost,"contactInfo_contactName");		
	    		setDisplay(labelPartyPost,"assignedParty_partyId");	
	    		setDisplay(labelUserPost,"assignedUser_userLoginId");	
	    		setDisplay(labelRequestTypePost,"requestType_id");	
	    		setDisplay(labelPriorityPost,"priority_id");	
	    		//setTitleToValue(requestType_engDesc);
	    		//setTitleToValue(priority_engDesc);
	    		/*setTitleToValue(contactInfo_companyName);
			    setTitleToValue(contactInfo_contactName);
			    setTitleToValue(assignedParty_description);
			    setTitleToValue(assignedUser_userLoginId);*/
			    /*setTitleToValue(targetResponseDate);
			    setTitleToValue(targetSolvedDate);
			    setTitleToValue(targetClosedDate);
			    setTitleToValue(acceptedDate);*/
			    /*labelAcceptedDate
				labelResponseDate
				labelSolvedDate
				labelClosedDate
				
				acceptedDate
				targetResponseDate
				targetSolvedDate
				targetClosedDate*/
				//labelAcceptedDate.innerHTML=acceptedDate.value;
				//syncValue();
				//labelAcceptedDate.setExpression("innerHTML","document.callForm.acceptedDate.value");
				//labelResponseDate.setExpression("innerHTML","document.callForm.targetResponseDate.value");
				//labelSolvedDate.setExpression("innerHTML","document.callForm.targetSolvedDate.value");
				//labelClosedDate.setExpression("innerHTML","document.callForm.targetClosedDate.value");
			}
    	}
    	function syncValue(){
    		with(document.callForm)
    		{
    			labelAcceptedDate.innerHTML=acceptedDate.value;
				labelResponseDate.innerHTML=targetResponseDate.value;
				labelSolvedDate.innerHTML=targetSolvedDate.value;
				labelClosedDate.innerHTML=targetClosedDate.value;
    		}
    	}
    	function addHour(date,hour)
		{
			return new Date(date.getTime() + hour*60*60*1000);
		}
		function formatTo2(i)
		{
			var s=""+i;
			if(s.length==1)
			{
				s="0"+s;
			}
			return s;
		}
		function formatTime(time)
		{
		   var hour = time.getHours();
		   var minute = time.getMinutes();
		   var year=time.getYear();
		   var month=time.getMonth();
		   var date=time.getDate();
		   if(year<1000)
		   {
		     year=1900+year;
		   }
		   var temp=""+(year)+"-";
		   temp+=formatTo2(month+1)+"-";
		   temp+=formatTo2(date)+" ";
		   temp+=formatTo2(hour)+":";
		   temp+=formatTo2(minute);
		   return temp;
		}
		function unFormatTime(s)
		{
		   //1999-04-13 12:12 
		   var year=s.substring(0,4);
		   var month=parseInt(s.substring(5,7)-1);
		   var date=s.substring(8,10);
		   var hour=s.substring(11,13);
		   var minute=s.substring(14,16);
		   return new Date(year,month,date,hour,minute);
		}
		var companyInfoDialog = null;
		function showCompanyInfo()
		{
			with(document.callForm)
    		{
    			if(company_partyId.value=="")
    			{
    				alert("The company has no info.");
    				return ;
    			}
    			sUrl = "helpdesk.listTable.do?company="+escape(company_partyId.value);
				if (companyInfoDialog && !companyInfoDialog.closed)	{
					companyInfoDialog.frames(0).navigate(sUrl);
					companyInfoDialog.focus();
					return;
				}
    			sFeature = "status:no;resizable:no;scroll:yes;help:no;dialogWidth:800px;dialogHeight:400px";
    			companyInfoDialog = window.showModelessDialog("helpdesk.showDialog.do?title=helpdesk.call.customerinfodialog.title&" + sUrl, null, sFeature);
    		}
		}
		/*function submitMe()
		{
    		if(validateCallForm(document.callForm))
    		{
	    		with(document.callForm)
	    		{
	    			if(requestType_id.value=="")
	    			{
	    				alert("<bean:message key="helpdesk.call.requestType.required" />");
	    				return ;
	    			}
	    			if(priority_id.value=="")
	    			{
	    				alert("<bean:message key="helpdesk.call.priority.required" />");
	    				return ;
	    			}
	    		}
	    		document.callForm.submit();
	    	}
		}*/
		function goEditCall(v)
		{
			//if(v!=""&&v.length==9)
			if(v!="")
			{
				//if(confirm('<bean:message key="helpdesk.call.confirm.discard.change" />'))
				{
					location='helpdesk.edit<%=callType_name%>.do?ticketNo='+v;
				}
			}
		}
		function newCall()
		{
			//if(confirm('<bean:message key="helpdesk.call.confirm.discard.change" />'))
			{
				location='helpdesk.new<%=callType_name%>.do';
			}
		}
    </script>
<table border="0" width="100%" cellspacing="0" cellpadding="0">
	<tr>
	<!-- Left Spacer -->
	<td width=1%>
	<img src="images/spacer.gif" width="2" height="1" border="0" />
	</td>
	<!-- Left Column -->
	<td width="20%" bgcolor="#F0F0F0" valign=top>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="5%" height="10">&nbsp;</td>
			<td width="90%">&nbsp;</td>
			<td width="5%">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="labeltext"><img border="0" src="images/fold_xp.gif" width="16" height="16">&nbsp;<bean:message key="helpdesk.call.number.full" />(<logic:notEmpty name="callForm" property="callID"><bean:write name="callForm" property="ticketNo" /></logic:notEmpty><logic:empty name="callForm" property="callID"><bean:message key="helpdesk.call.new" /></logic:empty>)&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<!--<tr>
			<td>&nbsp;</td>
			<td class="text13blackbold">2004-11-03 09:40:35&nbsp;</td>
			<td>&nbsp;</td>
		</tr>-->
		<tr>
			<td>&nbsp;</td>
			<td class="labeltext"><img border="0" src="images/branch.gif" width="16" height="16">&nbsp;<bean:message key="helpdesk.call.problemInfo"/>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<logic:notEmpty name="callForm" property="callID">
		<tr>
			<td>&nbsp;</td>
			<td class="labeltext"><img border="0" src="images/branch.gif" width="16" height="16">&nbsp;<a href="helpdesk.new<%=callType_name%>ActionTrack.do?callId=<bean:write name="callForm" property="callID" />"><bean:message key="helpdesk.call.actionTrack.actionTrack"/></a>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="labeltext"><img border="0" src="images/branch.gif" width="16" height="16">&nbsp;<a href="helpdesk.createKnowledgeBase.do?callid=<bean:write name="callForm" property="callID" />"><bean:message key="helpdesk.kb.create.title"/></a>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		</logic:notEmpty>
		<tr height="20">
			<td colspan="3"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="labeltext">
				<bean:message key="helpdesk.call.number" />
				<input type="text" name="query_ticketNo" maxlength="9" size="9"/>
				<input type="button" value="<bean:message key="helpdesk.call.go" />" onclick="goEditCall(document.callForm.query_ticketNo.value)"/>
				<input type="button" value="<bean:message key="helpdesk.call.new" />" onclick="newCall()"/>
			</td>
			<td>&nbsp;</td>
		</tr>
		<!--<tr>
			<td>&nbsp;</td>
			<td class="labeltext"><a href="helpdesk.new<%=callType_name%>.do"><bean:message key="helpdesk.call.new"/>&nbsp;<bean:message key="<%="helpdesk.call.title"+callType_type%>"/></a>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>-->
		
		</table>
	</td>
	<!-- Middle Spacer -->
	<td width=1%>
	<img src="images/spacer.gif" width="2" height="1" border="0">
	</td>
	<!-- Contents -->
	<td width="98%" valign="top" align="left">
		<!-- Contents -->
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<!-- Area Header Information -->
			<tr height="20">
				<td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/corner1black.gif" width="4" height="4" border="0"></td>
				<td class="wpsPortletTopTitle" bgcolor="#b4d4d4"><bean:message key="<%="helpdesk.call.title"+callType_type%>"/></td>
				<td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/corner2black.gif" width="4" height="4" border="0"></td>
			</tr>
			<!-- Area Contents Information -->
			<!-- Problem Information -->
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table border="0" cellpadding="0" cellspacing="2" width="100%" bgcolor="#DEEBEB">
					<tr><td colspan=4 style="padding:3px;"><html:errors /></td></tr>
					<tr bgcolor="#3190CA" height="20" class="labeltext" >
						<td colspan=4>&nbsp;<bean:message key="helpdesk.call.problemInfo" /></td>
					</tr>
					<tr>
						<td width=17%></td>
						<td width=25%></td>
						<td width=18%></td>
						<td width=40%><html:hidden property="callID"/></td>
					</tr>
					<tr>
						<td class="labeltext"><bean:message key="helpdesk.call.actionTrack.status"  />:</td>
						<td><bean:write name="callForm" property="status_desc" /></td>
						<td class="labeltext"><bean:message key="helpdesk.call.requestType"  />:</td>
						<td align="left">
<%
	String requestTypeList="requestTypeList"+form.get("type_type");
%>							
							<html:select property = "requestType2_id" >
				                <html:options collection = "<%=requestTypeList%>" property = "id" labelProperty = "description"/>
				            </html:select>

						</td>
					</tr>			
					<tr>
						<td class="labeltext">
							<bean:message key="helpdesk.call.customer" />/<bean:message key="helpdesk.call.contact" />:
						</td>
						<td align="left" colspan="3">
							<div id="labelCompany" style="display:inline"><bean:write name="callForm" property="contactInfo_companyName"/></div>
							<div id="labelCompanyPost" style="display:inline">&nbsp;/&nbsp;</div>
							<div id="labelContact" style="display:inline"><bean:write name="callForm" property="contactInfo_contactName"/></div>
							<div id="labelContactPost" style="display:inline">&nbsp;</div>
							<a href="javascript:void(0)" onclick="showCompanyDialog(1);event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a><!--<input type="button" value="<bean:message key="helpdesk.call.select" />" onclick="showCompanyDialog(1)" />-->
							<a id="cmdShowCompanyInfo" href="javascript:void(0)" onclick="showCompanyInfo();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.info" />" src="images/info.GIF" border="0" /></a>
							<div id="labelCompanyNoteOutter" style="display:inline"><bean:message key="helpdesk.call.serviceCode"/>:<div id="labelCompanyNote" style="display:inline"><bean:write name="callForm" property="company_note"/></div></div>
							<html:hidden property="company_partyId"/>
							<html:hidden property="company_note"/>
							<html:hidden property="contactInfo_province" />
							<html:hidden property="contact_userLoginId"/>
							<html:hidden property="contactInfo_companyName"/>
							<html:hidden property="contactInfo_contactName"/>

						</td>
									
				</tr>
					<tr>
						<td class="labeltext"><bean:message key="helpdesk.call.tele" />:</td>
						<td><html:text property="contactInfo_teleCode" size="13" maxlength="80"/></td>
						<td class="labeltext"><bean:message key="helpdesk.call.email" />:</td>
						<td><html:text property="contactInfo_email" size="13" maxlength="80"/></td>
					</tr>
					<tr>
						<td class="labeltext"><bean:message key="helpdesk.call.fax" />:</td>
						<td><html:text property="contactInfo_fax" size="13" maxlength="80" /></td>
						<td class="labeltext"><bean:message key="helpdesk.call.mobile" />:</td>
						<td><html:text property="contactInfo_mobileCode" size="13" maxlength="80" /></td>
					</tr>
					<tr height="25">
						<td class="labeltext"><bean:message key="helpdesk.call.category" />:</td>
						<td valign="middle"><div style="display:inline" id="labelRequestType"><bean:write name="callForm" property="requestType_engDesc" /></div>
						<div style="display:inlinde" id="labelRequestTypePost">&nbsp;</div>
						<a href="javascript:void(0)" onclick="showRequestTypeDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						<!--<input type="button" value="<bean:message key="helpdesk.call.select" />"  onClick="showRequestTypeDialog()" />-->
							<html:hidden property="requestType_id" />
							<html:hidden property="requestType_engDesc" />
						</td>
					</tr>
					<tr height="25">
						<td class="labeltext"><bean:message key="helpdesk.call.priority" />:</td>
						<td><div style="display:inline" id="labelPriority"><bean:write name="callForm" property="priority_engDesc" /></div>
						<div style="display:inlinde" id="labelPriorityPost">&nbsp;</div>
						<a href="javascript:void(0)" onclick="showPriorityDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						<!-- <input type="button" value="<bean:message key="helpdesk.call.select" />" onclick="showPriorityDialog()"/> -->
							<html:hidden property="priority_id" />
							<html:hidden property="priority_engDesc" />
						</td>
						<td class="labeltext"><bean:message key="helpdesk.call.problemtype" />:</td>
						<td align="left">
<%
	String problemTypeList="problemTypeList";
%>							
							<html:select property = "problemType_id" >
				                <html:options collection = "<%=problemTypeList%>" property = "id" labelProperty = "desc"/>
				            </html:select>
						</td>
					</tr>
					<tr>
						<td class="labeltext">
							<bean:message key="helpdesk.call.assignmentGroup" />/<bean:message key="helpdesk.call.assignee" />:
						</td>
						<td>
							<div style="display:inline" id="labelParty"><bean:write name="callForm" property="assignedParty_description"/></div>
							<div style="display:inlinde" id="labelPartyPost">&nbsp;/&nbsp;</div>
							<div style="display:inline" id="labelUser"><bean:write name="callForm" property="assignedUser_name"/></div>
							<div style="display:inlinde" id="labelUserPost">&nbsp;</div>
							<a href="javascript:void(0)" onclick="showPartyDialog(1);event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
							<!--<input type="button" value="<bean:message key="helpdesk.call.select" />"  onclick="showPartyDialog(1)">-->
							<a id="cmdClearUser" href="javascript:void(0)" onclick="clearAssignedUser();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.clearUser" />" src="images/deleteUser.gif" border="0" /></a>
							<!--<input type="button" onclick="clearAssignedUser()"  name="cmdClearUser" value="<bean:message key="helpdesk.call.clearUser"/>" />-->
							<html:hidden property="assignedUser_userLoginId"  />
							<html:hidden property="assignedParty_partyId"  />
							<html:hidden property="assignedParty_description"  />
							<html:hidden property="assignedUser_name"  />
						</td>
						<td class="labeltext"><bean:message key="helpdesk.call.notifyCustomer" />:
						</td>
						<td>
								<select name="notifyCustomer">
									<option value="N" <logic:equal name="callForm" property="notifyCustomer" value="N">selected</logic:equal>>No</option>
									<option value="Y" <logic:equal name="callForm" property="notifyCustomer" value="Y">selected</logic:equal>>Yes</option>
								</select>
						</td>
					</tr>
					<tr>
						<td class="labeltext"><bean:message key="all.createTime" />:</td>
						<td><div style="display:inline" id="labelAcceptedDate" ><bean:write name="callForm" property="acceptedDate" /></div><html:hidden property="acceptedDate" /></td>
						<td class="labeltext"><bean:message key="helpdesk.call.targetResponseTime" />:</td>
						<td><div style="display:inline" id="labelResponseDate" ><bean:write name="callForm" property="targetResponseDate" /></div><html:hidden property="targetResponseDate" /></td>
					</tr>
					<tr>
						<td class="labeltext"><bean:message key="helpdesk.call.targetSolveTime" />:</td>
						<td><div style="display:inline" id="labelSolvedDate"><bean:write name="callForm" property="targetSolvedDate" /></div><html:hidden property="targetSolvedDate" /></td>
						<td class="labeltext"><bean:message key="helpdesk.call.targetCloseTime" />:</td>
						<td><div style="display:inline" id="labelClosedDate"><bean:write name="callForm" property="targetClosedDate" /></div><html:hidden property="targetClosedDate" /></td>
					</tr>
					<tr height="8">
						<td colspan=4></td>
					</tr>
				</table>
				</td>
				<td></td>
			</tr>
			<!-- Description Information -->
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
					<tr height=8><td colspan=2></td></tr>
					<tr bgcolor="#3190CA" height='20' class="labeltext" >
						<td colspan=2>&nbsp;<bean:message key="helpdesk.call.requestDesc" /></td>
					</tr>
					<tr height=5><td colspan=2></td></tr>
					<tr>
						<td class="labeltext" width="8%"><bean:message key="all.subject" />:&nbsp;</td>
						<td class="labeltext" width="92%">&nbsp;<html:text maxlength="110" property="subject" size="106" /></td>
					</tr>
					<tr>
						<td class="labeltext" width="8%"><bean:message key="all.body" />:&nbsp;</td>
						<td class="labeltext" width="92%">&nbsp;</td>
					</tr>
					<tr>
						<td class="labeltext" colspan=2>
							<html:textarea property="desc" cols="120" rows="20"  />
						</td>
					</tr>
					<tr height="8">
						<td colspan=2></td>
					</tr>
					<tr>
						<td colspan="2" align="right" width="100%">
							<table width="100%">
								<tr>
									<td width="81%" align="left"><c:if test="${buttonEnabled}"><input type="submit" value="<bean:message key="helpdesk.call.submit" />"></input></c:if></td>
									<td width="19%" align="right"></td>
								</tr>	
							</table>
						</td>
					</tr>
					
				</table>
				</td>
				<td> </td>
			</tr>
			<!-- Description history -->
			<tr bgcolor="#DEEBEB">
				<td></td>
				<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
				<tr height=5><td></td></tr>
				<tr bgcolor="#3190CA" height="20" class="labeltext">
				<td>
				&nbsp;<bean:message key="helpdesk.call.attachmentsList" />
				</td>
				</tr>
				</table>
				</td>
				
				<td></td>
			</tr>
			<tr bgColor="#DEEBEB">
				<td>
				</td>
				<td style="padding-left:2px;padding-top:5px">
					<html:hidden property="attachGroupID" />
					<iframe FRAMEBORDER="0" width="700" src="helpdesk.listAttachment.do?<c:if test="${!(buttonEnabled)}">readonly=y&</c:if>groupid=<bean:write name="callForm" property="attachGroupID" />">
					</iframe>
				</td>
				<td></td>
			</tr>

			<!-- Change history -->
			<%
				String historyList="historyList"+ form.get("callID");
			%>

			<logic:notEmpty name="<%=historyList%>" >
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
					<tr height=8><td colspan=6></td></tr>
					<tr bgcolor="#3190CA" height="20"class="labeltext" >
						<td colspan=6>&nbsp;<bean:message key="helpdesk.call.changeHistoryList" /></td>
					</tr>
					<tr height=8><td colspan=6 height="2"></td></tr>
					<tr>
						<td class="labeltext" nowrap width=4%>&nbsp;</td>
						<td class="labeltext" nowrap width=22%><bean:message key="helpdesk.call.assignmentChange" />&nbsp;</td>
						<td class="labeltext" nowrap width=22%><bean:message key="helpdesk.call.requestTypeChange" />&nbsp;</td>
						<td class="labeltext" nowrap width=22%><bean:message key="helpdesk.call.priorityChange" />&nbsp;</td>
						<td class="labeltext" nowrap width=15%><bean:message key="all.modifyDate" />&nbsp;</td>
						<td class="labeltext" nowrap width=15%><bean:message key="all.modifier" />&nbsp;</td>
					</tr>
					<%int index=1;%>
					<logic:iterate id="history" name="<%=historyList%>">
					<tr>
						<td><%=index%></td>
						<td>
							<logic:notEmpty name="history" property="oldParty">
							<bean:write name="history"
							 property="oldParty.description" /><logic:notEmpty name="history" property="oldUser">:<bean:write name="history"
							 property="oldUser.name" /></logic:notEmpty><br>
							 <span style="font-family:MS Serif;font-size:10pt">===&gt;</span><br>
							 <bean:write name="history"
							 property="newParty.description" /><logic:notEmpty name="history" property="newUser">:<bean:write name="history"
							 property="newUser.name" /></logic:notEmpty>
							 </logic:notEmpty>
						</td>
						<td>
							<logic:notEmpty name="history" property="oldRequestType">
							<bean:write name="history"
							 property="oldRequestType.engDesc" /><br>
							 <span style="font-family:MS Serif;font-size:10pt">===&gt;</span><br>
							 <bean:write name="history"
							 property="newReqeustType.engDesc" />
							 </logic:notEmpty>
						</td>
						<td>
							<logic:notEmpty name="history" property="oldPriority">
							<bean:write name="history"
							 property="oldPriority.engDesc" /><br>
							 <span style="font-family:MS Serif;font-size:10pt">===&gt;</span><br>
							 <bean:write name="history"
							 property="newPriority.engDesc" />
							 </logic:notEmpty>
						</td>
						<td><bean:write name="history" property="modifyLog.createDate" format="yyyy-MM-dd"/>&nbsp;</td>
						<td><bean:write name="history" property="modifyLog.createUser.name" />&nbsp;</td>
					</tr>
					<tr height="3">
						<td colspan=6>&nbsp;</td>
					</tr>
					<%++index;%>
					</logic:iterate>
					
					<tr height="8">
						<td colspan=6></td>
					</tr>
				</table>
				</td>
				<td></td>
			</tr>
			</logic:notEmpty >
			<!-- Update history -->
			<logic:notEmpty name="callForm" property="modifyLog_createUser_name">
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
					<tr height=8><td colspan=6></td></tr>
					<tr bgcolor="#3190CA" height="20" class="labeltext">
						<td colspan=6>&nbsp;<bean:message key="all.updateInfomation" /></td>
					</tr>
					<tr height=8><td height="2" colspan=6></td></tr>
					<tr>
						<td class="labeltext" width=20%><bean:message key="all.createDate" />:</td>
						<td width=30%><bean:write name="callForm"
							 property="modifyLog_createDate" /></td>
						<td class="labeltext" width=20%><bean:message key="all.createUser" />:</td>
						<td width=30%><bean:write name="callForm"
							 property="modifyLog_createUser_name" /></td>
					</tr>
					<tr>
						<td class="labeltext" width=20%><bean:message key="all.modifyDate" />:</td>
						<td width=30%><bean:write name="callForm"
							 property="modifyLog_modifyDate" /></td>
						<td class="labeltext" width=20%><bean:message key="all.modifyUser" />:</td>
						<td width=30%><bean:write name="callForm"
							 property="modifyLog_modifyUser_name" /></td>
					</tr>
					<tr height="8">
						<td colspan=6></td>
					</tr>
				</table>
				</td>
				<td></td>
			</tr>
			</logic:notEmpty >
			<!-- Area Footer Information -->
			<tr height="8">
				<td width="8" bgcolor="#deebeb" valign="bottom" align="left"><img src="images/corner3grey.gif" width="4" height="4" border="0"></td>
				<td bgcolor="#deebeb"><img src="images/spacer.gif" width="1" height="8" border="0"></td>
				<td width="8" bgcolor="#deebeb" valign="bottom" align="right"><img src="images/corner4grey.gif" width="4" height="4" border="0"></td>
			</tr>
		</table>
	</td>
	<!-- Right Spacer -->
	<td width=3%>
	<img src="images/spacer.gif" width="6" height="1" border="0">
	</td>
	</tr>
</table>
</html:form>
<script language="javascript">
  if (init) init();
</script>
<%
}
catch(Throwable e)
{
	e.printStackTrace();
}
%>