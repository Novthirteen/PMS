<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
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
if (AOFSECURITY.hasEntityPermission("PO_PROFILE", "_VIEW", session)) {
	
	String textContract = request.getParameter("textContract");
	String textVendor = request.getParameter("textVendor");
	String textContractType = request.getParameter("textContractType");
	String textStatus = request.getParameter("textStatus");
	String textdep = request.getParameter("textdep");
	String textHasProject = request.getParameter("textHasProject");
    
	if (textContract == null) textContract ="";
	if (textVendor == null) textVendor ="";
	if (textContractType == null) textContractType ="";
	if (textStatus == null) textStatus ="";
	if (textdep == null) textdep ="";
	if (textHasProject == null) textHasProject ="";

	List result = (List)request.getAttribute("QryList");
	
	int offset = 0;	
	if( request.getParameter("offset") == null || request.getParameter("offset").equals("") ){
	}else{
		offset = Integer.parseInt(request.getParameter("offset"));
	} 
	
	if (result.size() < offset) {
		offset = 0;
	}
	
	Integer length = new Integer(10);
    
    int i = offset + 1;
    
    List partyList_dep=(List)request.getAttribute("PartyList");
%>
<HTML>
	<HEAD>
	
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	
		<script language="Javascript">
		function fnSubmit1(start) {
			with (document.frm) {
				offset.value=start;
				submit();
			}
		}
		
		function doSelect() {
			var contracts = document.getElementsByName("contract");
			for (var i = 0; i < contracts.length; i++) {
				if (contracts[i].checked == true) {
					location.replace("editPOProfile.do?FormAction=dialogView&contractId=" + document.getElementsByName("contractId")[i].value);
				}
			}
		}
		</script>
	</HEAD>

	<BODY>
		<form name="frm" action="findPurchaseOrder.do" method="post">
			<input type="hidden" name="formAction" value="dialogView">
			<table width=100% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>PO Profile List</CAPTION>
				<tr>
					<td>
						<TABLE width="100%">
							<tr>
								<td colspan=10><hr color=red></hr></td>
							</tr>
							<tr>
								<td class="lblbold">PO:</td>
								<td class="lblLight">
									<input type="text" name="textContract" size="15" value="<%=textContract%>" style="TEXT-ALIGN: right" class="lbllgiht">
								</td>
								<td class="lblbold">PO Type:</td>
								<td class="lblLight">
									<select name="textContractType">
										<option value="" selected>Select All</option>
										<option value="FP" <%="FP".equals(textContractType) ? "selected" : ""%>>Fixed Price</option>
										<option value="TM" <%="TM".equals(textContractType) ? "selected" : ""%>>Time & Material</option>
									</select>
								</td>
							    <td class="lblbold">Vendor:</td>
							    <td class="lblLight">
							    	<input type="text" name="textVendor" size="15" value="<%=textVendor%>" style="TEXT-ALIGN: right" class="lbllgiht">
							    </td>
							</tr>
							<tr>
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
							    <td class="lblbold">Signed or Not:</td>
							    <td class="lblLight">
							    	<select name="textStatus" >
						   	            <option value="" selected>ALL</option>
										<option value="Signed" <%if (textStatus.equals("Signed")) out.print("selected");%>>Signed</option>
										<option value="Unsigned" <%if (textStatus.equals("Unsigned")) out.print("selected");%>>Unsigned</option>
								    </select>
							    </td>
							    <td class="lblbold" colspan="2">
							    	<input type="checkbox" class="checkboxstyle" name="textHasProject" value="1" <%="1".equals(textHasProject) ? "checked" : ""%>>
							    	Include PO Profile in Existing Projects:
							    </td>
						    </tr>
					    	<tr>
						        <td colspan=5/>
						    	<td  align="middle">
									<input type="submit" value="Query" class="button">
									<input type="button" value="Close" class="button" onclick="window.parent.close()">
								</td>
							</tr>
							<tr>
								<td colspan=10 valign="top"><hr color=red></hr></td>
							</tr>
						</table>
					</td>
				</tr>
				
				<tr>
					<td>
						<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
		  					<TR bgcolor="#e9eee9">
							  	<td align="center"  class="lblbold">#&nbsp;</td>
							    <td align="left" class="lblbold">PO No.</td>
							    <td align="left" class="lblbold">PO Type</td>
							    <td align="left" class="lblbold">Description</td>
							    <td align="left" class="lblbold">Vendor</td>
							    <td align="left" class="lblbold">Total Contract Value</td>
		  					</tr>
		  					<%
		  						int count = 0;
		  						SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
		  						NumberFormat formater = NumberFormat.getInstance();
								formater.setMaximumFractionDigits(2);
								formater.setMinimumFractionDigits(2);
		  					%>
		  					<logic:iterate id="p" indexId="indexId" offset="<%=String.valueOf(offset)%>" length="<%=String.valueOf(length)%>" name="QryList" type="com.aof.component.prm.contract.POProfile" >
		  					<tr bgcolor="#e9eee9">  
		  						<td align="center">
			  						<input type="radio" class="radiostyle" name="contract" value="<%=count++%>">
			  						<input type="hidden" name="contractId" value="<bean:write name="p" property="id"/>">			  						
			  					</td>
			  					
			  					<td align="left">
			  						<bean:write name="p" property="no"/>
			  					</td>
			  					<td align="left">
			  						<bean:write name="p" property="contractType"/>
			  					</td>
			  					<td align="left">
			  						<bean:write name="p" property="description"/>
			  					</td>
			  					<td align="left">
			  						<bean:write name="p" property="vendor.description"/>
			  					</td>
			  					<td align="right">
			  						<%=formater.format(p.getTotalContractValue())%>
			  					</td>
		  					</tr>
		  					</logic:iterate>	
							<tr>
						    	<td align="left" class="lblerr" colspan="2">
						    		<input type="button" class="button" name="select" value="Select" onclick="doSelect();">
						    	</td>
								<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;
									<input type=hidden name="offset" value="<%=offset%>">
									<%
										int RecordSize = result.size();
										int l = 0;
										while ((l * length.intValue()) < RecordSize) {
											if (offset == l * length.intValue()) {
									%>
											&nbsp;<%=l+1%>&nbsp;
									<%
											} else {
									%>
											&nbsp;<a href="javascript:fnSubmit1(<%=l*length.intValue()%>)" title="Click here to view next set of records"><%=l+1%></a>&nbsp;
									<%		
											};
											l++;
										}
									%>
								</td>
							</tr>
		          		</table>
		         	</td>
		        </tr>
			</table>
		</form>
	</body>
</html>
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
