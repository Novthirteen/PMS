<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.aof.component.prm.bid.BidMaster"%>
<%@ page import="com.aof.component.prm.bid.ContactList"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

<%
BidMaster bidMaster = (BidMaster)request.getAttribute("BidMaster");
//Set contactSet = (Set)request.getAttribute("contactList");
Set contactSet = (Set)bidMaster.getContactList();
if(contactSet == null)contactSet = new HashSet();
%>
<form name="EditForm" action="dialogBidMaster.do" method="post">
<input type="hidden" name="contactId">
<table border=0 width='100%' cellspacing='0' cellpadding='1'>
	<tr><td align=left width='90%' class="wpsPortletTopTitle" colspan=4>Contact List</td></tr>
	<tr>
		<td width='100%'colspan=4>
			<table border=0 width='100%'  class=''>
				<tr bgcolor="#e9eee9">
				  	<td align="center" class="lblbold">name</td>
				  	<td align="center" class="lblbold">position</td>
				  	<td align="center" class="lblbold">chineseName</td>
					<td align="center" class="lblbold">teleNo</td>
					<td align="center" class="lblbold">email</td>
					<td align="center" class="lblbold">action</td>
				</tr>
				<%
				if(contactSet != null && contactSet.size() > 0){
					Iterator itst = contactSet.iterator();
				
					String clid = "";
					String clname = "";
					String clposition = "";
					String clchinesename = "";
					String clteleno = "";
					String clemail = "";
		
					while(itst.hasNext()){
						ContactList contact = (ContactList)itst.next();
						clid = contact.getId() + "";
						clname = contact.getName();
						clposition = contact.getPosition();
						clchinesename = contact.getChineseName();
						clteleno = contact.getTeleNo();
						clemail = contact.getEmail();
				%>
				<tr>
					<td align="center">
						<input type="hidden" class="inputBox" name="clid" value="<%=clid%>" size="30" />
  						<%=clname%>
  					</td>
  					<td align="center"><%=clposition%></td>
  					<td align="center"><%=clchinesename%></td>
  					<td align="center"><%=clteleno%></td>
  					<td align="center"><%=clemail%></td>
  					<td align="center">&nbsp;</td>
  				</tr>
	  			<%
	  				}
	  			}else {
  				%>
  				<tr><td>&nbsp;</td></tr>
  				<%
  				}
  				%>
			</table>
		</td>
	</tr>
</table>
</form>
