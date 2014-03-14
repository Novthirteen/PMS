<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.presale.*"%>
<%@ page import="com.aof.component.crm.customer.*"%>
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

<%
try{
if (AOFSECURITY.hasEntityPermission("PROJ_PRESALE", "_VIEW", session)) {
	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	String requestorid = request.getParameter("requestorid");
	String perspectiveid = request.getParameter("perspectiveid");
	
	if (requestorid == null) requestorid ="";
	if (perspectiveid == null) perspectiveid ="";
	String textdep = request.getParameter("textdep");
	if (textdep == null) textdep ="";
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
	
	Integer length = new Integer(10);	

    request.setAttribute("offset", offset);
    request.setAttribute("length", length);	
    
    int i = offset.intValue()+1;
//	List ptList=null;
	List partyList_dep=null;
	try{
		PartyHelper ph = new PartyHelper();
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
		if (partyList_dep == null) partyList_dep = new ArrayList();
		partyList_dep.add(0,ul.getParty());
	}catch(Exception e){
		e.printStackTrace();
	}
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/memberSelect.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunctions.js'></script>
<script language="Javascript">
function fnSubmit1(start) {
	with (document.frm) {
		offset.value=start;
		submit();
	}
}

function FnDelete() {
	document.frm.FormAction.value = "delete";
	document.frm.submit();
}
function ExportExcel() {
		document.rptForm.submit();
	}

</script>

<form name="rptForm" action="pas.report.Presaleprint.do" method="post">
	<input type="hidden" name="action" value="ExportToExcel">
	<input type="hidden" name="requestorid" value="<%=requestorid%>">
	<input type="hidden" name="perspectiveid" value="<%=perspectiveid%>">
	<input type="hidden" name="textdep" value="<%=textdep%>">
</form>

<form name="frm" action="ListPreSaleProject.do" method="post">
<input type="hidden" name="FormAction">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Pre-Sale Activity List</CAPTION>
	<tr>
		<td>
			<TABLE cellpadding="1" border="0" cellspacing="1" width="100%">
				<tr>
					<td colspan=8><hr color=red></hr></td>
				</tr>
				<tr>
					<td class="lblbold" >Bid No.:</td>
					<td class="lblLight" ><input type="text" name="requestorid" size="15" value="<%=requestorid%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
					<td class="lblbold" >Perspective:</td>
					<td class="lblLight" ><input type="text" name="perspectiveid" size="15" value="<%=perspectiveid%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
					<td class="lblbold" >Department:</td>	
					<td class="lblLight" >	
						<select name="textdep">	
							<option value="" selected>All Related To You</option>
							<%
							if (AOFSECURITY.hasEntityPermission("PROJ_PRESALE", "_ALL", session)) {
								Iterator itd = partyList_dep.iterator();
								while(itd.hasNext()){
									Party pp = (Party)itd.next();
									if (pp.getPartyId().equals(textdep)) {
							%>
									<option value="<%=pp.getPartyId()%>" selected><%=pp.getDescription()%></option>
							<%
									} else{
							%>
									<option value="<%=pp.getPartyId()%>"><%=pp.getDescription()%></option>	
							<%
									}
								}
							}
							%>
						</select>	
					</td>	
				</tr>
			</table>
		</td>
	</tr>
	<tr width="100%">
	    
    	<td  align="left" width="100%">
			<input type="submit" value="Query" class="button">
		    <input type="button" value="New" class="button" onclick="location.replace('EditPreSaleProject.do')">
		    &nbsp;&nbsp;&nbsp;&nbsp;
		    <input type="button" value="Delete Selected" class="button" onclick="javascript: FnDelete()">
		    &nbsp;&nbsp;
		    <input type="button" value="Export To Excel" name="Print" class="button" onclick="javascript:ExportExcel()">
		</td>
	</tr>
	<tr>
			<td colspan=8 valign="top"><hr color=red></hr></td>
	</tr>
	<tr>
		<td>
			<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
  				<TR bgcolor="#e9eee9">
				  	<td class="lblbold">&nbsp;</td>  
				    <td align="left" class="lblbold">BidNo</td>
				    <td align="left" class="lblbold">Sales Person</td>
				    <td align="left" class="lblbold">Perspective</td>
					<td align="left" class="lblbold">Deparment</td>
				    <td align="left" class="lblbold">Status</td>
				    <td class="lblbold">&nbsp;</td>	
					<td align="left" class="lblbold">Assignee</td>
				    <td align="left" class="lblbold">Action Date</td> 
				    <td align="left" class="lblbold">Hours</td> 
				    <td align="left" class="lblbold">Description</td>
				    <td align="left" class="lblbold">Activity</td>
				</tr>
				<%
					Long oldMstId = null;
					Long newMstId = null;
					int mstCount = -1;
				%>
  				<logic:iterate id="pd" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.presale.PreSaleDetail" > 
  					
  				<%
  					newMstId = pd.getPreSaleMaster().getPsId();
  				%>
  				
  				<tr bgcolor="#e9eee9">
  				<%
  					if (!newMstId.equals(oldMstId)) {
  						oldMstId = newMstId;
  						mstCount++;
  						
  				%>
  					<td align="left"> 
  						<input type="checkbox"  class="checkboxstyle" name="chkAll<%=mstCount%>"  value="" onclick="checkUncheckAllBox(document.frm.chkAll<%=mstCount%>, document.frm.chkOne<%=mstCount%>)">
  					</td>
  					<td align="left"> 
						<a href="EditPreSaleProject.do?PsId=<%=((PreSaleDetail) pd).getPreSaleMaster().getPsId()%>">
						<%
							String salesPerson = "";
							String perspective = "";
							String status = "";
							String department = "";
							String description = "";
							String no = "";
							com.aof.component.prm.bid.BidMaster bidMaster = null;
							if(((PreSaleDetail) pd).getPreSaleMaster().getBidMaster() != null){
								bidMaster = ((PreSaleDetail) pd).getPreSaleMaster().getBidMaster();
							}
							if(bidMaster != null){
								salesPerson = bidMaster.getSalesPerson().getName();
								perspective = bidMaster.getProspectCompany().getName();
								status = bidMaster.getStatus();
								department = bidMaster.getDepartment().getDescription();
								description = bidMaster.getDescription();
								no = bidMaster.getNo();
							}
							
						%>
						<%=no%></a> 
				    </td>
				    <td align="left">
				        <div class="tabletext">
				        <p >
				        <%=salesPerson%>
				        </div>   
				    </td>        
				    <td align="left"> 
				     	<div class="head4">                   
				        <p ><%=perspective%>
				        </div>
				    </td>    
				    <td align="left"> 
				     	<div class="head4">                   
				        <p ><%=department%>
				        </div>
				    </td>
					<td align="left"> 
				        <div class="head4">                   
				        <p ><%=status%>
				        </div>
				    </td>
  				<%
  					} else {
  				%>
  					<td></td>
  					<td></td>
  					<td></td>
  					<td></td>
  					<td></td>
  					<td></td>
  				<%
  					}
  				%>
  <!-- ------------------------------------------------------------------------------------------- -->			  
  					<td bgcolor="#e9eee9" align="left">
				    	<input type="checkbox"  class="checkboxstyle" name="chkOne<%=mstCount%>" value="<%=pd.getPdId()%>" onclick="checkTopBox(document.frm.chkAll<%=mstCount%>, document.frm.chkOne<%=mstCount%>)">	
				    </td>	
				    
				    <td bgcolor="#e9eee9" align="left">
				        <div class="head4">
				        <p ><%=((PreSaleDetail) pd).getAssignee().getName()%>
				        </div>
				    </td>
				    <td bgcolor="#e9eee9" align="left">
						<div class="head4">
						<p > <%=((PreSaleDetail) pd).getActionDate()%> 
						</div>
					</td>
					 <td bgcolor="#e9eee9" align="left">
						<div class="head4">
						<p > <%=((PreSaleDetail) pd).getHours()%> 
						</div>
					</td>
					<td bgcolor="#e9eee9" align="left"> 
						<div class="head4">                   
						<p ><%=((PreSaleDetail) pd).getDescription()%>
						</div>
					</td>
					<td bgcolor="#e9eee9" align="left"> 
						<div class="head4">     
						<%
							String activity = "";
							if(((PreSaleDetail) pd).getSalesActivity()!=null){
								activity = ((PreSaleDetail) pd).getSalesActivity().getDescription();
							}
						%>              
						<p ><%=activity%>
						</div>
					</td>
				</tr>
				</logic:iterate> 	
				<input type="hidden" name="i" value="<%=mstCount%>">	
				<tr>
					<td width="100%" colspan="12" align="right" class=lblbold>Pages&nbsp;:&nbsp;
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
		Hibernate2Session.closeSession();
}catch (Exception e){
	e.printStackTrace();
}
	%>
