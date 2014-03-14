<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%try {%>

    <script language="JavaScript" src="includes/date/date.js"></script>
		<html:javascript formName="callActionTrackForm"/>
<%//String action=(String)(((HttpServletRequest)request).getAttribute("action"));%>
<html:form action="<%="/"+request.getParameter("action")%>" focus="actionType_actionid" method="post" onsubmit="return validateCallActionTrackForm(this)">
<%
com.shcnc.struts.form.BeanActionForm form =
					(com.shcnc.struts.form.BeanActionForm)pageContext.getAttribute(org.apache.struts.taglib.html.Constants.BEAN_KEY,  PageContext.REQUEST_SCOPE);
final String statusChangeList="statusChange"+ form.get("callMaster_callID");
final String actionTrackList="callActionTracks"+ form.get("callMaster_callID");
final String statusTypesList="statusTypes"+form.get("callMaster_type_type").toString().trim();
final String actionTypesList="actionTypes"+form.get("callMaster_type_type").toString().trim();
final String callLink="helpdesk.edit"+form.get("callMaster_type_name")+".do?id="+form.get("callMaster_callID");
final String callActionTrackLink="helpdesk.new"+form.get("callMaster_type_name")+"ActionTrack.do?callId="+form.get("callMaster_callID");
final String getKBLink="helpdesk.createKnowledgeBase.do?callid="+form.get("callMaster_callID");
final String callType_name=(String)form.get("callMaster_type_name");
final String callType_type=(String)form.get("callMaster_type_type");

%>

<script language="JavaScript">		
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

<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table border="0" width="100%" cellspacing="0" cellpadding="0">
	<tr>
	<!-- Left Spacer -->
	<td width=1%>
	<img src="images/spacer.gif" width="2" height="1" border="0">
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
			<td class="labeltext"><img border="0" src="images/fold_xp.gif" width="16" height="16">&nbsp;Call No.(<bean:write name="callActionTrackForm" property="callMaster_ticketNo" />)&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="labeltext"><img border="0" src="images/branch.gif" width="16" height="16">&nbsp;<a href="<%=callLink%>"><bean:message key="helpdesk.call.actionTrack.problemInfo" /></a>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="labeltext"><img border="0" src="images/branch.gif" width="16" height="16">&nbsp;<a href="<%=callActionTrackLink%>"><bean:message key="helpdesk.call.actionTrack.actionTrack" /></a>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="labeltext"><img border="0" src="images/branch.gif" width="16" height="16">&nbsp;<a href="<%=getKBLink%>"><bean:message key="helpdesk.kb.create.title"/></a>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr height="20">
			<td colspan="3"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="labeltext">
				<bean:message key="helpdesk.call.number" />
				<input type="text" name="query_ticketNo" maxlength="9" size="9"/>
				<input type="button" value="<bean:message key="helpdesk.call.go" />" onclick="goEditCall(document.callActionTrackForm.query_ticketNo.value)"/>
				<input type="button" value="<bean:message key="helpdesk.call.new" />" onclick="newCall()"/>
			</td>
			<td>&nbsp;</td>
		</tr>
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
				<td  class="wpsPortletTopTitle" bgcolor="#b4d4d4"><bean:message key="helpdesk.call.actionTrack.title" /></td>
				<td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/corner2black.gif" width="4" height="4" border="0"></td>
			</tr>
			<!-- Area Contents Information -->
			<!-- Problem Information -->
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table border="0" cellpadding="0" cellspacing="2" width="760" bgcolor="#DEEBEB">
					<tr height=8>
						<td width="100"><html:hidden property="callMaster_callID" /><html:hidden property="id" /></td>
						<td width="200"></td>
						<td width="110"></td>
						<td width="350"></td>
					</tr>
					<tr bgcolor="#3190CA" height="20" class="labeltext" >
						<td colspan=4>&nbsp;<bean:message key="helpdesk.call.actionTrack.info" /></td>
					</tr>
					<tr><td colspan=4 style="padding:3px;"><html:errors /></td></tr>
					<tr>
						<td class="labeltext"><bean:message key="helpdesk.call.actionTrack.type" />:&nbsp;</td>
						<td class="labeltext" >
						<html:select property = "actionType_actionid" >
                <html:options collection = "<%=actionTypesList%>" property = "actionid" labelProperty = "actiondesc"/>
            </html:select>
						</td>
						<td class="labeltext" ><bean:message key="helpdesk.call.actionTrack.status" />:&nbsp;</td>
						<td class="labeltext" >
			<html:select property = "callMaster_status_id">
				<logic:iterate id="st" name="<%=statusTypesList%>" type="com.aof.component.helpdesk.StatusType">
					<logic:notEqual name="st" property="level" value="0">
						<option value="<bean:write name="st" property="id"/>" <logic:equal name="st" property="id" value="<%=form.get("callMaster_status_id").toString()%>">selected</logic:equal>>
							<bean:write name="st" property="desc"/>
						</option>
					</logic:notEqual>
				</logic:iterate>
            </html:select>
						</td>
					</tr>
					<tr>
						<td class="labeltext"><bean:message key="helpdesk.call.actionTrack.date" />:&nbsp;</td>
						<td class="labeltext"><html:text property="date" maxlength="10" size="13"/>&nbsp;<A href="javascript:ShowCalendar(document.callActionTrackForm.dimg1,document.callActionTrackForm.date,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align="absMiddle" border="0" id="dimg1" src="images/datebtn.gif" ></A></td>
						<td class="labeltext"><bean:message key="helpdesk.call.actionTrack.spentHours" />:&nbsp;</td>
						<td class="labeltext"><html:text property="cost" size="26"  maxlength="5" /></td>
					</tr>
					<tr>
						<td class="labeltext"><bean:message key="helpdesk.call.actionTrack.subject" />:&nbsp;</td>
						<td class="labeltext" colspan="3"><html:text property="subject" maxlength="255" size="88" /></td>
					</tr>
					<tr>
						<td class="labeltext"><bean:message key="helpdesk.call.actionTrack.body" />:&nbsp;</td>
						<td class="labeltext">&nbsp;</td>
						<td class="labeltext">&nbsp;</td>
						<td class="labeltext">&nbsp;</td>
					</tr>
					<tr>
						<td class="labeltext" colspan="4">
						<html:textarea property="desc" cols="109" rows="10" />
						</td>
					</tr>
					<tr>
						<td colspan="4"><c:if test="${buttonEnabled}"><html:submit><bean:message key="helpdesk.call.actionTrack.submit" /></html:submit></c:if></td>
					</tr>
					<tr height="8">
						<td colspan=4></td>
					</tr>
				</table>
				</td>
				<td></td>
			</tr>
			<!--Attachments -->
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
					<tr height=8><td></td></tr>
					<tr bgcolor="#3190CA" height="20" class="labeltext" >
						<td>&nbsp;<bean:message key="helpdesk.call.actionTrack.attachmentsList" /></td>
					</tr>
					<tr height=2><td></td></tr>
					<tr bgColor="#DEEBEB">
						<td>
							<html:hidden property="attachGroupID" />
							<iframe frameborder="0" width="700" src="helpdesk.listAttachment.do?<c:if test="${!(buttonEnabled)}">readonly=y&</c:if>groupid=<bean:write name="callActionTrackForm" property="attachGroupID" />">
							</iframe>
						</td>
					</tr>
					
					<tr height="8">
						<td></td>
					</tr>
				</table>
				</td>
				<td></td>
			</tr>
			<!-- Description history -->
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
					<tr height=8><td colspan=5></td></tr>
					<tr bgcolor="#3190CA" height="20" class="labeltext" >
						<td colspan=5>&nbsp;<bean:message key="helpdesk.call.actionTrack.actionList" /></td>
					</tr>
					<tr height=2><td colspan=5></td></tr>
					<logic:notEmpty name="<%=actionTrackList%>" >
					<tr>
						<td class="labeltext" nowrap width=5%>&nbsp;</td>
						<td class="labeltext" nowrap width=55%><bean:message key="helpdesk.call.actionTrack.subject" /></td>
						<td class="labeltext" nowrap width=15%><bean:message key="helpdesk.call.actionTrack.modifyDate" /></td>
						<td class="labeltext" nowrap width=15%><bean:message key="helpdesk.call.actionTrack.modifyUser" /></td>
						<td class="labeltext" nowrap width=10%><bean:message key="helpdesk.call.actionTrack.action" /></td>
					</tr>
					<%int index=1;%>
					<logic:iterate id="cat" name="<%=actionTrackList%>" type="com.aof.component.helpdesk.CallActionHistory" >
	        <TR>                    
		      	<td><%=index%></td>
						<td><bean:write name="cat"  property="subject"/></td>
						<td>
						<logic:notEmpty name="cat" property="modifyLog">
						<bean:write name="cat"  property="modifyLog.modifyDate" format="yyyy-MM-dd" />
						</logic:notEmpty>&nbsp;
						</td>
						<td>
						<logic:notEmpty name="cat" property="modifyLog">
						<bean:write name="cat"  property="modifyLog.modifyUser.name"/>
						</logic:notEmpty>&nbsp;
						</td>
						<td><a href="helpdesk.edit<bean:write name="callActionTrackForm"  property="callMaster_type_name"/>ActionTrack.do?id=<bean:write name="cat"  property="id"/>"><bean:message key="helpdesk.call.actionTrack.view" /></a>&nbsp;&nbsp;<!--<a href="helpdesk.deleteCallActionTrack.do?id=<bean:write name="cat"  property="id"/>&callId=<bean:write name="callActionTrackForm"  property="callMaster_callID"/>">delete</a>--></td>
						
	        </tr>
	        <%++index;%>
          </logic:iterate>         
          
          </logic:notEmpty>
					<tr height="8">
						<td colspan=5></td>
					</tr>
				</table>
				</td>
				<td></td>
			</tr>
			<!-- Change history -->
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
					<tr height=8><td colspan=5></td></tr>
					<tr bgcolor="#3190CA" height="20" class="labeltext" >
						<td colspan=5>&nbsp;<bean:message key="helpdesk.call.actionTrack.statusChangeList" /></td>
					</tr>
					<tr height=2><td colspan=5></td></tr>
					<logic:notEmpty name="<%=statusChangeList%>" >
					<tr>
						<td class="labeltext" nowrap width=5%>&nbsp;</td>
						<td class="labeltext" nowrap width=32%><bean:message key="helpdesk.call.actionTrack.oldStatus" /></td>
						<td class="labeltext" nowrap width=33%><bean:message key="helpdesk.call.actionTrack.newStatus" /></td>
						<td class="labeltext" nowrap width=15%><bean:message key="helpdesk.call.actionTrack.modifyDate" /></td>
						<td class="labeltext" nowrap width=15%><bean:message key="helpdesk.call.actionTrack.modifyUser" /></td>
					</tr>
					<% int indexStatusChange=1;%>
					<logic:iterate id="sc" name="<%=statusChangeList%>" type="com.aof.component.helpdesk.CallStatusHistory" >
					<tr>
						<td><%=indexStatusChange%></td>
						<td><bean:write name="sc"  property="statusOld.desc"/></td>
						<td><bean:write name="sc"  property="statusNew.desc"/></td>
						<td>
						<logic:notEmpty name="sc" property="modifyLog">
						<bean:write name="sc"  property="modifyLog.createDate" format="yyyy-MM-dd"/>
						</logic:notEmpty>&nbsp;
						</td>
						<td>
						<logic:notEmpty name="sc" property="modifyLog">
						<bean:write name="sc"  property="modifyLog.createUser.name"/>
						</logic:notEmpty>&nbsp;
						</td>
					</tr>
					<% ++indexStatusChange;%>
					</logic:iterate>
					</logic:notEmpty>
					<tr height="8">
						<td colspan=5></td>
					</tr>
				</table>
				</td>
				<td></td>
			</tr>
			<!-- Update history -->
			<logic:notEmpty name="callActionTrackForm" property="modifyLog_createUser_name">
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
					<tr height=8><td colspan=6></td></tr>
					<tr bgcolor="#3190CA" height="20" class="labeltext" >
						<td colspan=6>&nbsp;<bean:message key="helpdesk.call.actionTrack.updateInfo" /></td>
					</tr>
					<tr height=2><td colspan=6></td></tr>
					<tr>
						<td class="labeltext" width=20%><bean:message key="helpdesk.call.actionTrack.createDate" />:</td>
						<td width=30%><bean:write name="callActionTrackForm" property="modifyLog_createDate"/></td>
						<td class="labeltext" width=20%><bean:message key="helpdesk.call.actionTrack.createUser" />:</td>
						<td width=30%><bean:write name="callActionTrackForm"  property="modifyLog_createUser_name"/></td>
					</tr>
					<tr>
						<td class="labeltext" width=20%><bean:message key="helpdesk.call.actionTrack.modifyDate" />:</td>
						<td width=30%><bean:write name="callActionTrackForm"  property="modifyLog_modifyDate"/></td>
						<td class="labeltext" width=20%><bean:message key="helpdesk.call.actionTrack.modifyUser" />:</td>
						<td width=30%><bean:write name="callActionTrackForm"  property="modifyLog_modifyUser_name"/></td>
					</tr>

					<tr height="8">
						<td colspan=6></td>
					</tr>
				</table>
				</td>
				<td></td>
			</tr>
			</logic:notEmpty>
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
<% } catch(Throwable e)
{
	e.printStackTrace();
}
%>
