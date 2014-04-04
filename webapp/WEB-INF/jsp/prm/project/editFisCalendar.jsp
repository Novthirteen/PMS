<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>

<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("FISCAL_CALENDAR", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();   
FMonth EditDataInfo = null;
int flag=0;
String DataStr = request.getParameter("year");
Integer DataId = null;
if (DataStr == null || DataStr.length()<1) {
	
} else {
	DataId = new Integer(DataStr);					
}
String year=request.getParameter("year");
String FormAction1 = request.getParameter("FormAction1");
String FormAction = request.getParameter("FormAction");
String StartDate=request.getParameter("startDate1");
				String EndDate = request.getParameter("endDate1");
				String CloseDate=request.getParameter("closeDate1"); 
				String Desc=request.getParameter("description1");
Date Dyear=new Date();
int Nyear=Dyear.getYear()+1900;

//if (DataId!=null){
//	EditDataInfo = (FMonth)hs.load(FMonth.class,DataId);
//}
List monthList=null;
try{
	monthList = (List)request.getAttribute("monthList");
	flag=monthList.size();
	
}catch(Exception e){
	out.println(e.getMessage());
}		

if(FormAction == null){
	FormAction = "view";
}
	
%>

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

<script language="javascript">
function FnDelete() {
	
	document.EditForm.FormAction.value = "delete";
	document.EditForm.submit();
}
function FnUpdate() {
	
	document.EditForm.FormAction1.value = "save";
	document.EditForm.FormAction.value = " ";
	document.EditForm.submit();
}
function FnDetail() {
	
	
	document.EditForm.submit();
}
</script>

<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> Fiscal Calendar Maintenance </caption> 
<tr>
<td>
<%
    if(FormAction.equals("update")){
    	//FormAction="update";
%>
<form Action="editFisCalendar.do" method="post" name="EditForm">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<input type="hidden" name="FormAction1" id="FormAction1" >
<input type="hidden" name="FormAction" id="FormAction" value="update">
<input type="hidden" name="flag" id="flag" value="<%=flag%>">
<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
<tr>
	<td>
		<table cellspacing="5" cellpadding="5" width=100%>
			<tr>
				<td class="lblbold">Year :</td>
				<td align="left">
				<select name="year">
				<%
			    if(year.equals(String.valueOf(Nyear-1))){
			    %>   
			       <option value="<%=Nyear-1%>" selected><%=Nyear-1%></option>
			      <option value="<%=Nyear%>"><%=Nyear%></option>
			       <option value="<%=Nyear+1%>"><%=Nyear+1%></option>
			    <%
			    }
			    else if(year.equals(String.valueOf(Nyear))){
			    %>
			        <option value="<%=Nyear-1%>" ><%=Nyear-1%></option>
			       <option value="<%=Nyear%>" selected><%=Nyear%></option>
			       <option value="<%=Nyear+1%>"><%=Nyear+1%></option>
			    <%
			    }
			    else{
			    %>
			         <option value="<%=Nyear-1%>" ><%=Nyear-1%></option>
			      <option value="<%=Nyear%>"><%=Nyear%></option>
			       <option value="<%=Nyear+1%>" selected><%=Nyear+1%></option>
			    <%
			    }   
			    %>        
			   
			    </select> 
                </td>
				<td class="lblbold"><input type="button" value="Detail Information" class="loginButton" onclick="javascript:FnDetail();"/></td>
				</td>
			
			</tr>
			
        
         
		</table>
	</td>
</tr>	
<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
<TR>
    <td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr bgcolor="#e9eee9">
				<td class="lblbold">&nbsp;Period&nbsp;</td>
				<td class="lblbold">&nbsp;Start Date&nbsp;</td>
				<td class="lblbold">&nbsp;End Date&nbsp;</td>
				<td class="lblbold">&nbsp;Close Date&nbsp;</td>
				<td class="lblbold">&nbsp;Total Working Hours&nbsp;</td>
				
			</tr>
			<%
			int i=1;
			
			Iterator it= monthList.iterator();
			while(i<=12){
			if(it.hasNext()){
			FMonth fm=(FMonth)it.next();
			%>
			<tr bgcolor="#e9eee9">
     			<td class="lblbold"><input type="hidden" name="Mon<%=i%>"  id="Mon<%=i%>" value="<%=fm.getMonthSeq()%>"><%=fm.getMonthSeq()+1%></td>
				<td class="lblbold"><input type="text" name="startDate<%=i%>" id="startDate<%=i%>"  value="<%=fm.getDateFrom()%>">             
				<A href="javascript:ShowCalendar(document.EditForm.dimg<%=i%>,document.EditForm.startDate<%=i%>,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg<%=i%> src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
                </td>
				<td class="lblbold"><input type="text" name="endDate<%=i%>" id="endDate<%=i%>"  value="<%=fm.getDateTo()%>">
				<A href="javascript:ShowCalendar(document.EditForm.dim<%=i%>,document.EditForm.endDate<%=i%>,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dim<%=i%> src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
               
				</td>
				<td class="lblbold"><input type="text" name="closeDate<%=i%>" id="closeDate<%=i%>"  value="<%=fm.getDateFreeze()%>">
				<A href="javascript:ShowCalendar(document.EditForm.img<%=i%>,document.EditForm.closeDate<%=i%>,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=img<%=i%> src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
               
				</td>
				<td class="lblbold"><input type="text" name="description<%=i%>" id="description<%=i%>" value="<%=fm.getDescription()%>"></td>
				<input type="hidden" name="Id<%=i%>" id="Id<%=i%>" value="<%=fm.getId()%>">
			</tr>
			 
			 
			
			<%}
			else{
			%>
			<tr bgcolor="#e9eee9">
     			<td class="lblbold"><input type="hidden" name="Mon<%=i%>" id="Mon<%=i%>"  value="<%=i-1%>"><%=i%></td>
				<td class="lblbold"><input type="text" name="startDate<%=i%>" id="startDate<%=i%>"  >             
				<A href="javascript:ShowCalendar(document.EditForm.dimg<%=i%>,document.EditForm.startDate<%=i%>,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg<%=i%> src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
                </td>
				<td class="lblbold"><input type="text" name="endDate<%=i%>" id="endDate<%=i%>" >
				<A href="javascript:ShowCalendar(document.EditForm.dim<%=i%>,document.EditForm.endDate<%=i%>,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dim<%=i%> src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
                
				</td>
				<td class="lblbold"><input type="text" name="closeDate<%=i%>" id="closeDate<%=i%>">
				<A href="javascript:ShowCalendar(document.EditForm.img<%=i%>,document.EditForm.closeDate<%=i%>,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=img<%=i%> src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
                
				</td>
				<td class="lblbold"><input type="text" name="description<%=i%>" id="description<%=i%>"></td>
				<input type="hidden" name="Id<%=i%>" id="Id<%=i%>"  value="0">
			</tr>
			<%}
			i++;
			}%>
            

			
<tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<input type="reset" value="Cancel" class="loginButton"/>
		
        </td>
      </tr>  
</form>        			
<%
	}else{
%>

<form Action="editFisCalendar.do" method="post" name="EditForm">
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<input type="hidden" name="FormAction" id="FormAction" value="update">
<tr>
	<td>
		<table cellspacing="5" cellpadding="5" width=100%>
			<tr>
				<td class="lblbold">Year :</td>
				<td align="left">
				<select name="year">
			    <option value="<%=Nyear-1%>"><%=Nyear-1%></option>
			    <option value="<%=Nyear%>" selected><%=Nyear%></option>
			    <option value="<%=Nyear+1%>"><%=Nyear+1%></option>
			    </select>           
				
                </td>
				<td class="lblbold"><input type="button" value="Detail Information" class="loginButton" onclick="javascript:FnDetail();"/></td>
				
                </td>
			
			</tr>
			
        
		</table>
	</td>
</tr>

</form>
<%
	}
%> 	
  </td>
  </tr>
    <tr><td>&nbsp;</td></tr>
</table> 
  

<%
Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
