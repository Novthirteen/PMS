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
if (AOFSECURITY.hasEntityPermission("PO_PROFILE", "_VIEW", session)) {
	List result = null;
	result = (List)request.getAttribute("QryList");
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
    
    List partyList_dep=(List)request.getAttribute("PartyList");
    SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
    NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);
%>
<script language="Javascript">
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
</script>

<form name="frm" action="findPurchaseOrder.do" method="post">
<input type="hidden" name="formAction" id="formAction" value="view">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<CAPTION align=center class=pgheadsmall>Purchase Order List</CAPTION>
<tr>
	<td>
	<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
		<%
		
		String textContract = request.getParameter("textContract");
		String textVendor = request.getParameter("textVendor");
		String textContractType = request.getParameter("textContractType");
		String textStatus = request.getParameter("textStatus");
		String textdep = request.getParameter("textdep");
		String textSignDateFrom = request.getParameter("textSignDateFrom");
		String textSignDateTo = request.getParameter("textSignDateTo");
		String textCreateDateFrom = request.getParameter("textCreateDateFrom");
		String textCreateDateTo = request.getParameter("textCreateDateTo");
	    
		if (textContract == null) textContract ="";
		if (textVendor == null) textVendor ="";
		if (textContractType == null) textContractType ="";
		if (textStatus == null) textStatus ="";
		if (textdep == null) textdep ="";
		if (textSignDateFrom == null) textSignDateFrom = "";
		if (textSignDateTo == null) textSignDateTo = "";
		if (textCreateDateFrom == null) textCreateDateFrom = "";
		if (textCreateDateTo == null) textCreateDateTo = "";
		%>
		<tr>
			
			<td class="lblbold">PO No. or Description:</td>
			<td class="lblLight"><input type="text" name="textContract" size="15" value="<%=textContract%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
			
			<td class="lblbold">Vendor:</td>
			<td class="lblLight"><input type="text" name="textVendor" size="15" value="<%=textVendor%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
		    <td class="lblbold">PO Type:</td>
		    <td class="lblLight">
		    <select name="textContractType" >
    			<option value="" selected>ALL</option>	
				<option value="FP" <%if (textContractType.equals("FP")) out.print("selected");%>>Fixed Price</option>
				<option value="TM" <%if (textContractType.equals("TM")) out.print("selected");%>>Time & Material</option>
		    </select>
	     </td>
	    </tr>
	    <tr>
	   
	     <td class="lblbold">PO Status:</td>
		    <td class="lblLight">
		    <select name="textStatus" >
   	            <option value="" selected>ALL</option>
				<option value="Signed" <%if (textStatus.equals("Signed")) out.print("selected");%>>Signed</option>
				<option value="Unsigned" <%if (textStatus.equals("Unsigned")) out.print("selected");%>>Unsigned</option>
				<option value="Cancel" <%if (textStatus.equals("Cancel")) out.print("selected");%>>Cancel</option>
		    </select>
	     </td>
	     
	     <td class="lblbold">Department:</td>
			<td class="lblLight">
				<select name="textdep">
					
					<%
					if (AOFSECURITY.hasEntityPermission("PO_PROFILE", "_ALL", session)) {
						Iterator itd = partyList_dep.iterator();
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
			
	    </tr>
	    <tr>
	     <td class="lblbold">Sign Date Range :</td>
		 <td class="lblLight" colspan="2">
			<input  type="text" class="inputBox" name="textSignDateFrom" size="10" value="<%=textSignDateFrom%>"><A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.textSignDateFrom,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
			~
			<input  type="text" class="inputBox" name="textSignDateTo" size="10" value="<%=textSignDateTo%>"><A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.textSignDateTo,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
		 </td>
		 
		 <td class="lblbold">Create Date Range :</td>
		 <td class="lblLight" colspan="2">
			<input  type="text" class="inputBox" name="textCreateDateFrom" size="10" value="<%=textCreateDateFrom%>"><A href="javascript:ShowCalendar(document.frm.dimg3,document.frm.textCreateDateFrom,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg3 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
			~
			<input  type="text" class="inputBox" name="textCreateDateTo" size="10" value="<%=textCreateDateTo%>"><A href="javascript:ShowCalendar(document.frm.dimg4,document.frm.textCreateDateTo,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg4 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
		 </td>
	   </tr>
	    <tr>
	        <td colspan=4/>
	    	<td  align="middle" colspan=2>
				<input type="submit" value="Query" class="button">
			    <input type="button" value="New" class="button" onclick="location.replace('editPOProfile.do')">
			    <input type="button" value="Export Excel" class="button" onclick="exportExcel();">
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
  	<td class="lblbold">#&nbsp;</td>
  	<td align="center" class="lblbold">Vendor</td>
    <td align="center" class="lblbold">Contract No.</td>
    <td align="center" class="lblbold">Account Manager</td>
    <td align="center" class="lblbold">Total Contract Value</td>
    <td align="center" class="lblbold">Sign Date</td>
    <td align="center" class="lblbold">Create Date</td>
    <td align="center" class="lblbold">Legal Review Date</td>
  </tr>
  <%
  	String newVendor = "";
  	String oldVendor = "";
	%>
  <logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.contract.POProfile" >                
  <tr bgcolor="#e9eee9">  
    <td align="left"><%=i++%></td>
    <td align="left" class="lblbold">
        <div class="head4">
        <p >
        <%
        	newVendor =p.getVendor().getDescription();
        %>
        <%= newVendor%>
        </div>
    </td>
    
    <td align="left"> 
		<a href="editPOProfile.do?FormAction=view&contractId=<bean:write name="p" property="id"/>"><bean:write name="p" property="no"/></a> 
    </td>
    <td align="left" class="lblight">
        <div class="head4">
        <p >
        <%	String AMName = "";
        	if(p.getAccountManager()!=null)
        		AMName = p.getAccountManager().getName();;
        %>
        <%= AMName%>
        </div>
    </td>
    <td align="center"> 
      <div class="head4">                   
        <p ><%=p.getTotalContractValue() != null ? numFormater.format(p.getTotalContractValue()) : ""%>
      </div>
    </td>
    <td align="center"> 
      <div class="head4">                   
        <p ><%=p.getSignedDate() != null ? dateFormater.format(p.getSignedDate()) : ""%>
      </div>
    </td>
    <td align="center"> 
      <div class="head4">                   
        <p ><%=p.getCreateDate() != null ? dateFormater.format(p.getCreateDate()) : ""%>
      </div>
    </td>
    <td align="center"> 
      <div class="head4">                   
        <p ><%=p.getLegalReviewDate() != null ? dateFormater.format(p.getLegalReviewDate()) : ""%>
      </div>
    </td>
				</tr>
				</logic:iterate> 		
					 <tr>
				<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;
				<input type="hidden" name="offset" id="offset" value="<%=offset%>">
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
