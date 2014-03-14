<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<% try{ 
	if (AOFSECURITY.hasEntityPermission("SALES_STEPS", "_CREATE", session)) {
		SalesStep step = (SalesStep)request.getAttribute("SalesStep");
		String stepGroupId = (String)request.getParameter("stepGroupId");
		String stepOption = (String)request.getParameter("stepOption");
		String stepCreateFlag = (String)request.getParameter("stepCreateFlag");
		String maxStepSeqNo = (String)request.getAttribute("maxSeqNo");
		if(maxStepSeqNo == null){
			maxStepSeqNo = "0";
		}
		if ("createFlag".equals(stepCreateFlag)) {
			step = null;
		}
	
%>
<script language="javascript">
	function editActivity(option,stepId,activityId,formAction) {
	    
		var param = "?formAction=" + formAction;
		param += "&option=" + option;
		if (stepId != null) {
			param += "&stepId="+stepId;
		}
		if (activityId != null) {
			param += "&id="+activityId;
		}
		
		with(document.editForm) {
			v = window.showModalDialog(
				"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&EditStepActivity.do"+param,
				null,
				'dialogWidth:500px;dialogHeight:200px;status:no;help:no;scroll:no');
			if(v == "Refresh"){
				document.editForm.formAction.value = "view";
				document.editForm.submit();
			}
		}

	}
	
	function deleteActivity(activityId,formAction) {
		if (confirm("Do you want delete this sales activity?")) {
			//alert(formAction);
			document.editForm.formAction.value = formAction;
			document.editForm.activityId.value = activityId;
			document.editForm.submit();
		}
	}
	
	function onClose() {
		window.parent.returnValue = "refresh";
		window.parent.close();
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
	function onCreate() {
		var errormessage= validate();
		if (errormessage != "") {
			alert(errormessage);
		}
		else
		{
			document.editForm.stepCreateFlag.value = "createFlag";
			document.editForm.submit();
		}
	}
	function validate(){
		var errormessage="";
   		var seqNo = document.editForm.seqNo.value;
   		var description = document.editForm.description.value;
   		var percentage = document.editForm.percentage.value;
   		
		if(seqNo == "")
		{
			errormessage="You must input a Sequence No.";
			document.editForm.seqNo.focus();
			return errormessage;
   		}
   		
   		if(seqNo != null){
   			if((seqNo.length< 0) || (seqNo.length>3)){
				errormessage="Incorrect Sequence No. ";
				document.editForm.seqNo.focus();
				return errormessage;
			}
			for (var i = 0;i <seqNo.length ;i++){
		     if((seqNo.charAt(i)< '0')||(seqNo.charAt(i)> '9')){
		       errormessage="Incorrect Sequence No. ";
		       document.editForm.seqNo.focus();
		       return errormessage;
		     }
		   }
			var seqNo1 = parseInt(seqNo,'10');
			if((seqNo1<1) || (seqNo1>100)){
				errormessage="Incorrect Sequence No.";
				document.editForm.seqNo.focus();
				return errormessage;
			}
   		}
   		
   		if(percentage == null || percentage == "")
		{
			errormessage="You must input a percentage";
			document.editForm.percentage.focus();
			return errormessage;
   		}
   		
   		if(percentage != null){
   			if((percentage.length< 0) || (percentage.length>3)){
				errormessage="Incorrect Percentage. ";
				document.editForm.percentage.focus();
				return errormessage;
			}
			for (var i = 0;i <percentage.length ;i++){
		     if((percentage.charAt(i)< '0')||(percentage.charAt(i)> '9')){
		       errormessage="Incorrect Percentage ";
		       document.editForm.percentage.focus();
		       return errormessage;
		     }
		   }
			var percentage = parseInt(percentage,'10');
			if((percentage<0) || (percentage>100)){
				errormessage="Incorrect Percentage";
				document.editForm.percentage.focus();
				return errormessage;
			}
   		}
   		
		if(description == "")
		{
			errormessage="You must input Description";
			document.editForm.description.focus();
			return errormessage;
    	}	
    	if(percentage != "")
		{
			if((percentage.length<0) || (percentage.length>3)){
				errormessage="Incorrect Percentage Format";
				document.editForm.percentage.focus();
			}
			for (var i = 0;i <percentage.length ;i++){
		     if((percentage.charAt(i)< '0')||(percentage.charAt(i)> '9')){
		       errormessage="Incorrect Percentage Format";
		       document.editForm.percentage.focus();
		     }
		   }
			var percentage1 = parseInt(percentage,'10');
			if((percentage1<0) || (percentage1>100)){
				errormessage="Incorrect Percentage Format";
				document.editForm.percentage.focus();
			}
    	}     
    	return errormessage;
	}
</script>
<HTML>
	<HEAD>
	
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>

	<BODY>
<form name="editForm" action="EditStep.do" method="post">
	<input type="hidden" name="formAction" value="edit">
	<input type="hidden" name="id" value="<%= step != null ? String.valueOf(step.getId()) : ""%>">
	<input type="hidden" name="activityId" value="">
	<input type="hidden" name="stepGroupId" value="<%=stepGroupId%>">
	<input type="hidden" name="stepOption" value="<%=stepOption%>">
	<input type="hidden" name="stepCreateFlag">
	<table border=0 width='100%' cellspacing='0' cellpadding='0' align="center">
		<CAPTION align=center class=pgheadsmall>Sales Step Maintenance</CAPTION>
		<tr>
	  		<td width='100%' height='20'>
	    		<table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
				    <tr>
					 	<td align=left class="wpsPortletTopTitle">Sales Step Information</td>
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
										      	<td class="lblBold">Seq. No.:&nbsp;</td>
										      	<td>
										      	<%	String no = "";
										      		if(step != null ){
										      			no = String.valueOf(step.getSeqNo());
										      	%>
										      		<input type="text" name="seqNo" value="<%=no%>"  >
										      	<%	}else{
										      		no = String.valueOf(Integer.parseInt(maxStepSeqNo) + 1 ); 
										      	%>
										      		<input type="text" name="seqNo" value="<%=no%>"  >
										      	<%	}
										      	%>
											      	
										      	</td>
										    </tr>
	      									<tr>
										      	<td class="lblBold">Description:&nbsp;</td>
										      	<td>
											      	<textarea name="description" cols="70" rows="3"><%= step != null ? step.getDescription() : ""%></textarea>
										      	</td>
										    </tr>
      										<tr>
										      	<td class="lblBold">Percentage:&nbsp;</td>
										      	<td>
											      	<input type="text" name="percentage" value="<%=step != null ? String.valueOf(step.getPercentage()): ""%>"  >
											      	
										      	</td>
										    </tr>
											<tr>
										      	<td colspan="2">
										      		<%
														if (stepOption != null && stepOption.equalsIgnoreCase("edit")) {
													%>
												    	<input type=button class="loginButton" value="Save" onclick="doSave();">&nbsp;&nbsp;
												    <%
												    	} else {
												    %>
												    	<input type=button  class="loginButton" value="Save & Add Next" onclick="onCreate();">&nbsp;&nbsp;
												    <%
												    	}
												    %>
										      		
									
											      	<%
											      		if (step != null) {
											      	%>
											      	<input type="button" class="loginButton" value="Add New Activity" onclick="editActivity('new',<%= step != null ? String.valueOf(step.getId()) : ""%>,'','view');">
											      	
											      	<%
											      		}
											      	%>
											      	<input type="button" class="loginButton" value="Back & Refresh" onclick="javascript:onClose()">
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
					 	<td align=left class="wpsPortletTopTitle">Sales Activity List</td>
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
												
												<td align="center" class="lblbold">Action</td>
											</TR>
											<%
											if (AOFSECURITY.hasEntityPermission("SALES_STEPS", "_ALL", session)) {
												if (step != null && step.getActivities() != null ) {
													Set activitis = step.getActivities();
													if (activitis != null) {
														Iterator iterator = activitis.iterator();
														while (iterator.hasNext()) {
															SalesActivity activity = (SalesActivity)iterator.next();
											%>
											<tr>
												<td align="center"  class="lbllight"><%=activity.getSeqNo()%></td>
												<td align="center"  class="lbllight"><%=activity.getDescription()%></td>
												<td align="center"  class="lbllight">
													<a href="#" onclick="editActivity('edit',<%= step != null ? String.valueOf(step.getId()) : ""%>,<%=String.valueOf(activity.getId())%>,'view');">Edit</a>
													<a href="#" onclick="deleteActivity(<%=String.valueOf(activity.getId())%>,'deleteActivity');">Delete</a>
												</td>
											</tr>
											<%
														}
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
	</body>
</html>
<%
	} else {
	out.println("!!你没有相关访问权限!!");
	}
	}catch(Exception e){
	e.printStackTrace();
}
%>