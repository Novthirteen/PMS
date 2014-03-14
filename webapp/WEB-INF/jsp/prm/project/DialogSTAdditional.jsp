<%@ page contentType="text/html; charset=gb2312"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.project.ProjPlanType"%>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{
if (AOFSECURITY.hasEntityPermission("PMS", "_BOM_MAINTENANCE", session)) {

	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);
	
	String masterid = (String) request.getAttribute("masterid");
	List valueList = (List)request.getAttribute("valueList");

	if(valueList == null){
		valueList = new ArrayList();
	}
	
	String actionFlag = (String)request.getAttribute("actionFlag");
	if(actionFlag == null){
		actionFlag = "";
	}
%>
<HTML>
	<HEAD>
		
		<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		
		<script language="javascript">
		
			<%if(actionFlag != null && actionFlag.length() > 0){%>
			alert("updaate success!");
			<%}%>
		
			function fnSave() {
				document.iForm.command.value = "update";
				document.iForm.submit();
			}
			
			function onClose() {
				window.parent.close();
			}
			
		</script>
	</HEAD>
	<BODY>
		<form name="iForm" action="editProjBOMCost.do" method="post">
		
			<input type="hidden" name="formaction" value="dialog">
			<input type="hidden" name="command" value="">
			<input type="hidden" name="masterid" value="<%=masterid%>">
			
			<table border="0" cellpadding="4" cellspacing="0" align ="center" width="100%">
				<CAPTION class=pgheadsmall>Edit Service Type Additional Information</CAPTION>
			</table>
			<hr/>
			<br>
			<table width='100%' border='0' cellpadding='0' cellspacing='1'>
            	<tr>
		            <td align="left" class="topBox" width="25%"><p align="center">Service Type</td>
		            <td align="left" class="topBox" width="25%"><p align="center">Indirect Cost Rate(RMB)</td>
		            <td align="left" class="topBox" width="25%"><p align="center">Non-hour Revenue(RMB)</td>
		            <td align="left" class="topBox" width="25%"><p align="center">Coding Subcontract(RMB)</td>
      			</tr>
	          	<%
	          	for(int i = 0; i < valueList.size(); i++){
	          		ProjPlanType type = (ProjPlanType)valueList.get(i);
				%>
	          	<tr>
	          		<input type="hidden" name="stId" value="<%=type.getId()%>">
		          	<td class="bottomBox"><p align="center"><input type="text"  size="12" name="serviceType" value="<%=type.getDescription()%>" readonly style="text-align:center;background-color:#e9eee9;border=0px"></td>
		          	<td class="bottomBox"><p align="center"><input type="text"  size="12" name="indirectRate" value="<%=numFormater.format(type.getIndirectRate())%>" style="text-align:right;background-color:#ffffff"></td>
		          	<td class="bottomBox"><p align="center"><input type="text"  size="12" name="nhrRevenue" value="<%=numFormater.format(type.getNhrRevenue())%>" style="text-align:right;background-color:#ffffff"></td>
		          	<td class="bottomBox"><p align="center"><input type="text"  size="12" name="codingSubContr" value="<%=numFormater.format(type.getCodingSubContr())%>" style="text-align:right;background-color:#ffffff"></td>
		        </tr>
				<%
				}
     			%>
            </table>
            <br>
            <table width='100%' border='0'>
				<tr><td align="right">
					<input type="button" value="Save" onclick="fnSave()">
					<input type="button" value="Close" onclick="onClose()">
				</td></tr>
			</table>
		</form>
	</BODY>
</HTML>
<%	
	}else{
		out.println("!!你没有相关访问权限!!");
	}
}catch(Exception e){
	e.printStackTrace();
}
%>