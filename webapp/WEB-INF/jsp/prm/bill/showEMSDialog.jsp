<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
Log log = LogFactory.getLog("findEMSList.jsp");
try {
long timeStart = System.currentTimeMillis();   //for performance test
if (AOFSECURITY.hasEntityPermission("PROJ_EMS", "_VIEW", session)) {
	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	
	String emsInvoiceId = request.getParameter("emsInvoiceId");
	String qryEMSType = request.getParameter("qryEMSType");
	String qryEMSNo = request.getParameter("qryEMSNo");
	//String qryEMSDateStart = request.getParameter("qryEMSDateStart");
	//String qryEMSDateEnd = request.getParameter("qryEMSDateEnd");
	String qryDepartment = request.getParameter("qryDepartment");
	if (qryDepartment == null) {
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			qryDepartment = userLogin.getParty().getPartyId();
		}
	}
	
	//Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
	
	if (qryEMSType == null || qryEMSType.trim().length() == 0) qryEMSType =  Constants.EMS_TYPE_EMS_DELIVER;
	//if (qryEMSDateStart == null || qryEMSDateStart.trim().length() == 0) qryEMSDateStart = Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
	//if (qryEMSDateEnd == null || qryEMSDateEnd.trim().length() == 0) qryEMSDateEnd = Date_formater.format(nowDate);

	//Date dayStart = UtilDateTime.toDate2(qryEMSDateStart + " 00:00:00.000");
	//Date dayEnd = UtilDateTime.toDate2(qryEMSDateEnd + " 23:59:59.000");

	SQLResults sqlResult = (SQLResults)request.getAttribute("QueryList");
	List partyList = (List)request.getAttribute("PartyList");
	
	String offSetStr = request.getParameter("offSet");
	int offSet = 0;
	if (offSetStr != null && offSetStr.trim().length() != 0) {
		offSet = Integer.parseInt(offSetStr);
	}
	
	final int recordPerPage = 10;
%>
<HTML>
	<HEAD>
		<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
		<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
		<script language="javascript">
			function turnPage(offSet) {
				document.queryForm.offSet.value = offSet;
				document.queryForm.submit();
			}
			
			function doSelect() {
				var ems = document.getElementsByName("ems");
				for (var i = 0; ems != null && i < ems.length; i++) {
					if (ems[i].checked) {
						window.parent.returnValue  = ems[i].value;
						window.parent.close();
					}
				}
			}
			
			function doEdit() {
				document.queryForm.action = "editEMS.do";
				document.queryForm.submit();
			}
		</script>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
		<table width=100% cellpadding="1" border="0" cellspacing="1">
			<CAPTION align=center class=pgheadsmall>Deliver List</CAPTION>
			<tr>
				<td>
					<form name="queryForm" action="findEMS.do" method="post">
						<input type="hidden" name="formAction" value="dialogView">
						<input type="hidden" name="emsId" value="">
						<input type="hidden" name="offSet" value="0">
						<input type="hidden" name="emsInvoiceId" value="<%=emsInvoiceId%>">
						
						<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
							marginWidth=0 noResize 
							scrolling=no src="includes/date/calendar.htm" 
							style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
						</IFRAME>
						<TABLE width="100%">
							<tr>
								<td colspan="10"><hr color=red></hr></td>
							</tr>
							
							<tr>
								<td class="lblbold">Deliver Type:</td>
								<td class="lblLight">
									<input type="radio" name="qryEMSType" value="<%=Constants.EMS_TYPE_EMS_DELIVER%>" <%=Constants.EMS_TYPE_EMS_DELIVER.equals(qryEMSType) ? "checked" : ""%>><%=Constants.EMS_TYPE_EMS_DELIVER%>&nbsp;
									<input type="radio" name="qryEMSType" value="<%=Constants.EMS_TYPE_OTHER_DELIVER%>" <%=Constants.EMS_TYPE_OTHER_DELIVER.equals(qryEMSType) ? "checked" : ""%>><%=Constants.EMS_TYPE_OTHER_DELIVER%>
								</td>
								<td class="lblbold">EMS No/Contactor:</td>
								<td class="lblLight">
									<input type="text" name="qryEMSNo" size="30" value="<%=qryEMSNo != null ? qryEMSNo : ""%>" style="TEXT-ALIGN: left" class="lbllgiht">
								</td>
								<td class="lblbold">Department:</td>
								<td class="lblLight">
									<select name="qryDepartment">
									<%
									if (AOFSECURITY.hasEntityPermission("PROJ_EMS", "_ALL", session)) {
										Iterator itd = partyList.iterator();
										while(itd.hasNext()){
											Party p = (Party)itd.next();
											if (p.getPartyId().equals(qryDepartment)) {
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
						    	<td colspan="8">
									<input type="submit" value="Query" class="button">
									<input type="button" value="New" class="button" onclick="doEdit();">
								</td>
							</tr>
							<tr>
								<td colspan="10" valign="top"><hr color=red></hr></td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>
		
		<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
		 	<TR bgcolor="#e9eee9">
			  	<td align="center" class="lblbold">#&nbsp;</td>
			  	<td align="center" class="lblbold">Deliver Type</td>
			  	<td align="center" class="lblbold">EMS No/Contactor</td>	    
			    <td align="center" class="lblbold">Department</td>
			    <td align="center" class="lblbold">Deliver Date</td>
				<td align="center" class="lblbold">Create Date</td>
		  	</tr>
		  	
		 	<%
		 		DateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
			
				if(sqlResult != null && sqlResult.getRowCount() > 0){
					for (int row = offSet; row < sqlResult.getRowCount() && row < offSet + recordPerPage; row++) {
		 	%>
		 	<tr bgcolor="#e9eee9">  
		    	<td align="center">
		    		<input type="radio" name="ems" value="<%=sqlResult.getLong(row, "ems_id") + "|" + sqlResult.getString(row, "ems_type") + "|" + sqlResult.getString(row, "ems_no")%>">
		    	</td>
		    	<td align="left"> 
		    		<%=sqlResult.getString(row, "ems_type")%>		   
		    	</td>
		    	<td align="left"> 
					<%=sqlResult.getString(row, "ems_no")%>
		    	</td>
		    	<td align="left">                 
		       		<%=sqlResult.getString(row, "description")%>
		        </td>
		        <td align="center">                 
		            <%=dateFormater.format(sqlResult.getDate(row, "ems_date"))%>
		        </td>
		        <td align="center">                 
		            <%=dateFormater.format(sqlResult.getDate(row, "ems_create_date"))%>
		        </td>
		    </tr>
		   
			<%
					}
			%>
			<tr>
				<td width="100%" colspan="16" align="right" class=lblbold>Pages&nbsp;:&nbsp;
					<%
					int recordSize = sqlResult.getRowCount();
					for (int j0 = 0; j0 < Math.ceil((double)recordSize / recordPerPage); j0++) {
						if (j0 == offSet / recordPerPage) {
					%>
					&nbsp;<font size="3"><%=j0 + 1%></font>&nbsp;
					<%
						} else {
					%>
					&nbsp;<a href="javascript:turnPage('<%=j0 * recordPerPage%>')" title="Click here to view next set of records"><%=j0 + 1%></a>&nbsp;
					<%
						}
					}
					%>
				</td>
			</tr>
			<tr>
		    	<td align="left" class="lblerr" colspan="12">
		    		<input type="button" class="button" name="select" value="Select" onclick="doSelect();">
		    	</td>
		    </tr>
			<%
				} else {
		 	%>
		 	<tr bgcolor="#e9eee9">
		    	<td align="center" class="lblerr" colspan="12">
		    		No Record Found.
		    	</td>
		    </tr>
		 	<%
		 		}
		 	%>
		</table>
	</body>
</html>
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
long timeEnd = System.currentTimeMillis();       //for performance test
log.info("it takes " + (timeEnd - timeStart) + " ms to dispaly...");
} catch(Exception e) {
	e.printStackTrace();
}
%>
