<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.LinkedList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.aof.component.prm.bid.BidMaster"%>
<%@ page import="com.aof.component.prm.bid.BMHistory"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<script>

	function addContactList(){
		var errormessage= "";
		if(document.EditForm.description.value == 0){
			errormessage="You must input the description";
			document.EditForm.description.focus();
	    }
	    
	    if(document.EditForm.name.value == 0){
			errormessage="You must input the Prospect Company Name";
			document.EditForm.name.focus();
	    }
	    
		if(document.EditForm.clname1.value == 0){
			errormessage="You must input the Contact List";
		}
		
		if (errormessage != "") {
			alert(errormessage);
		}else{   
			if(validate()&& validatePostDate()){
	      		document.EditForm.formAction.value = "addContact";
		  		document.EditForm.submit();
		  	}
		}
	}
	
	function deleteContactList(contactId){
		if (confirm("Do you want delete this Contact?")){
			document.EditForm.formAction.value = "deleteContact";
			document.EditForm.contactId.value = contactId;
			document.EditForm.submit();
		}
	}
</script>
<%
SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");

BidMaster bidMaster = (BidMaster)request.getAttribute("BidMaster");
//Set bmhistoryList = (Set)bidMaster.getBmhistory();

List bmhistoryList = (List)request.getAttribute("bidmasterhistory");

if(bmhistoryList==null){
	bmhistoryList = new LinkedList();
}
%>
<form name="EditForm" action="editBidMaster.do" method="post">
	<input type="hidden"  name="yearAdd" value="">
	<table border=0 width='100%' cellspacing='0' cellpadding='1'>
		<tr>
			<td align=left width='100%' class="wpsPortletTopTitle" colspan=8>Bid Master History</td>
		</tr>
		<tr>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="2%"># </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Modify Date </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Modify User </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Contract Start Date </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Contract End Date </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Contract Sign Date </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Status </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Reason </td>
		</tr>
		<%
		if (bmhistoryList != null && bmhistoryList.size() > 0) {
			Iterator it = bmhistoryList.iterator();
			int v=1;
			while (it.hasNext()) {
				BMHistory bmh = (BMHistory) it.next();
		%>
		<tr>
			<td align ="center"><%=v%></td>
			<td align ="center"><%=formater.format(bmh.getModify_date())%></td>
			<td align ="center"><%=bmh.getUser_id().getName()%></td>
			<td align ="center"><%=formater.format(bmh.getCon_st_date())%></td>
			<td align ="center"><%=formater.format(bmh.getCon_ed_date())%></td>
			<td align ="center"><%=formater.format(bmh.getCon_sign_date())%></td>
			<td align ="center"><%=bmh.getStatus()%></td>
			<td align ="center"><%=bmh.getReason() == null ? "" : bmh.getReason()%></td>
		</tr>
		<%
				v++;
			}
			
		} else {
		%>
		<tr><td>&nbsp;</td></tr>
		<%
		}
		%>
	</table>
</form>