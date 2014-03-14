<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
	if (AOFSECURITY.hasEntityPermission("SALES_STEPS", "_CREATE", session)) {
		SalesStepGroup stepGroup = (SalesStepGroup)request.getAttribute("SalesStepGroup");
		List partyList = (List)request.getAttribute("PartyList");
		int maxSeqNo = 1;
%>
<script language="javascript">
	function editStep(stepOption,stepId,stepGroupId) {
		var param = "?formAction=view";
		param += "&stepOption=" + stepOption;
		if (stepId != null) {
		   
			param += "&id="+stepId;
		}
		if (stepGroupId != null) {
		    
			param += "&stepGroupId="+stepGroupId;
		}
		
		with(document.editForm) {
			v = window.showModalDialog(
				"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&EditStep.do"+param,
				null,
				'dialogWidth:700px;dialogHeight:400px;status:no;help:no;scroll:no');
				
			if (v == "refresh") {	
				document.editForm.formAction.value = "view";
				document.editForm.submit();
			}
		}
		
		
	}
	
	function deleteStep(stepId,stepGroupId) {
		if (confirm("Do you want delete this sales step?")) {
			document.editForm.formAction.value = "delete";
			document.editForm.id.value = stepGroupId;
			document.editForm.stepId.value = stepId;
			document.editForm.submit();
		}
	}
	function doSave() {
		var errormessage= validate();
		if (errormessage != "") {
			alert(errormessage);
		}
		else
		{
			document.editForm.submit();
		}
	}
	function validate(){
		var errormessage="";
   		
   		var description = document.editForm.description.value;

		if(description == "")
		{
			errormessage="You must input Description";
			document.editForm.description.focus();
			return errormessage;
    	}	     
    	return errormessage;
	}
</script>
<form name="editForm" action="EditStepGroup.do" method="post">
	<input type="hidden" name="formAction" value="edit">
	<input type="hidden" name="id" value="<%= stepGroup != null ? String.valueOf(stepGroup.getId()) : ""%>">
	<input type="hidden" name="stepId">
	<table border=0 width='100%' cellspacing='0' cellpadding='0' align="center">
		<CAPTION align=center class=pgheadsmall>Step Group Maintenance</CAPTION>
		<tr>
	  		<td width='100%' height='20'>
	    		<table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
				    <tr>
					 	<td align=left class="wpsPortletTopTitle">Sales Step Group Information</td>
				    </tr>
				    <tr height=6>
				    	<td></td>
				    </tr>
  					<TR>
    					<td width='100%'>
    						<table width='100%' border='0' cellpadding='0' cellspacing='0'>
    							<tr>
								    <td width="10" >
								    &nbsp;
								    </td>
							   		<td width="300" valign="top">
	   					 				<table width='100%' border='0' cellpadding='0' cellspacing='2'>
	      									<tr>
	      										<td width="90" class="lblBold" >Department:&nbsp;</td>
	      										<td>
	      											<select name="departmentId">
	      												<%
															if (AOFSECURITY.hasEntityPermission("SALES_STEPS", "_ALL", session)) {
																Iterator itd = partyList.iterator();
																while(itd.hasNext()){
																	Party p = (Party)itd.next();
																	if (stepGroup != null && p.getPartyId().equals(stepGroup.getDepartment().getPartyId())) {
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
										      	<td class="lblBold">Description:&nbsp;</td>
										      	<td>
											      	<textarea name="description" cols="70" rows="3"><%=stepGroup != null ? stepGroup.getDescription() : ""%></textarea>
										      	</td>
										    </tr>
      										<tr>
										      	<td class="lblBold">Disabled:&nbsp;</td>
										      	<td>
											      	<input type="checkbox" name="disableFlag" value="<%=Constants.STEP_GROUP_DISABLE_FLAG_STATUS_YES%>" class="checkboxstyle" <%=stepGroup != null && stepGroup.getDisableFlag().equals(Constants.STEP_GROUP_DISABLE_FLAG_STATUS_YES) ? "checked" : ""%>>
										      	</td>
										    </tr>
											<tr>
										      	<td colspan="2">
											      	<input type="button" class="loginButton" name="save" value="Save" onclick="doSave();">
											      	<%
											      		if (stepGroup != null) {
											      	%>
											      	<input type="button" class="loginButton" value="Add New Step" onclick="editStep('new','',<%= stepGroup != null ? String.valueOf(stepGroup.getId()) : ""%>)">
											      	<%
											      		}
											      	%>
											      	
											      	<input type="button" value="Back To List" class="loginButton" onclick="location.replace('FindStepGroups.do')">
										      	</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
	  		<td width='100%' height='20'>
	    		<table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
				    <tr>
					 	<td align=left class="wpsPortletTopTitle">Sales Step  List</td>
				    </tr>
				    <TR>
    					<td width='100%'>
    						<table width='100%' border='0' cellpadding='0' cellspacing='0'>
    							<tr>
							   		<td valign="top">
	   					 				<table width='100%' border='0' cellpadding='0' cellspacing='2'>
	      									<TR bgcolor="#e9eee9">
											  	<td align="center"  class="lblbold">Seq No.&nbsp;</td>
											  	<td align="center" class="lblbold">Description</td>
												<td align="center" class="lblbold">Percentage</td>
												<td align="center" class="lblbold">Action</td>
											</TR>
											<%	
												if (stepGroup != null && stepGroup.getSteps() != null ) {
													Set steps = stepGroup.getSteps();
													if (steps != null) {
														Iterator iterator = steps.iterator();
														while (iterator.hasNext()) {
															SalesStep step = (SalesStep)iterator.next();
						
											%>
											<tr>
												<td align="center"  class="lbllight"><%=step.getSeqNo()%></td>
												<td align="center"  class="lbllight"><%=step.getDescription()%></td>
												<td align="center"  class="lbllight"><%=step.getPercentage()%></td>
												<td align="center"  class="lbllight">
													<a href="#" onclick="editStep('edit',<%=String.valueOf(step.getId())%>,<%= stepGroup != null ? String.valueOf(stepGroup.getId()) : ""%>);">Edit</a>
													<a href="#" onclick="deleteStep(<%=String.valueOf(step.getId())%>,<%= stepGroup != null ? String.valueOf(stepGroup.getId()) : ""%>);">Delete</a>
												</td>
											</tr>
											<%
														}
													}
												}
											%>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
<%
	} else {
	out.println("!!你没有相关访问权限!!");
	}
%>