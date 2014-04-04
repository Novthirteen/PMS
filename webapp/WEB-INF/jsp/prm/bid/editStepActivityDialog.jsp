<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%  
	if (AOFSECURITY.hasEntityPermission("SALES_STEPS", "_CREATE", session)) {
		SalesActivity activity = (SalesActivity)request.getAttribute("SalesActivity");
		String stepId = (String)request.getParameter("stepId");
		String option = (String)request.getParameter("option");
		String createFlag = request.getParameter("createFlag");
		String maxStepSeqNo = (String)request.getAttribute("maxSeqNo");
		if(maxStepSeqNo == null){
			maxStepSeqNo = "0";
		}
		if ("createFlag".equals(createFlag)) {
			activity = null;
		}
%>
<script language="javascript">
function doSave(id,stepId) {
	var errormessage= validate();
	if (errormessage != "") {
		alert(errormessage);
	}
	else
	{	
    	document.editForm.id.value = id;
    	document.editForm.stepId.value = stepId;
		document.editForm.submit();
	}
}

function onClose() {
	window.parent.returnValue = "Refresh";
	window.parent.close();
}

function onCreate(id,stepId,createFlag){
	var errormessage= validate();
	if (errormessage != "") {
		alert(errormessage);
	}
	else
	{	
    	document.editForm.id.value = id;
    	document.editForm.stepId.value = stepId;
    	document.editForm.createFlag.value = "createFlag";
		document.editForm.submit();
	}
}

function validate(){
	var errormessage="";
   	var seqNo = document.editForm.seqNo.value;
   	var description = document.editForm.description.value;
	if(seqNo == "")
	{
		errormessage="You must input a Sequence No.";
		document.editForm.seqNo.focus();
		return errormessage;
    }
   	if(seqNo != null){
   		if((seqNo.length<0) || (seqNo.length>3)){
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
	if(description == "")
	{
		errormessage="You must input Description";
		document.editForm.description.focus();
		return errormessage;
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
<form name="editForm" action="EditStepActivity.do" method="post">
	<input type="hidden" name="formAction" id="formAction" value="edit">
	<input type="hidden" name="id" id="id" value="<%= activity != null ? String.valueOf(activity.getId()) : ""%>">
	<input type="hidden" name="stepId" id="stepId" value="<%=stepId%>">
	<input type="hidden" name="option" id="option" value="<%=option%>">
	<input type="hidden" name="createFlag" id="createFlag">
	
	<table border=0 width='100%' cellspacing='0' cellpadding='0' align="center">
		<CAPTION align=center class=pgheadsmall>Sales Activity Maintenance</CAPTION>
		<tr>
	  		<td width='100%' height='20'>
	    		<table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
				    <tr>
					 	<td align=left class="wpsPortletTopTitle">Sales Activity Information</td>
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
	      										<td class="lblBold" >Sequence No:&nbsp;</td>
	      										</td>
	      										<td>	
	      										<%
	      											String no = "";
	      											if(activity != null){
	      												no = String.valueOf(activity.getSeqNo());
	      											}else{
	      												no =  String.valueOf(Integer.parseInt(maxStepSeqNo) + 1 ); 
	      											}
	      										%>
	      										    <input type="text" name="seqNo" value="<%=no%>" />
											      	
	      										</td>
	      									</tr>
	      									<tr>
										      	<td class="lblBold">Description:&nbsp;</td>
										      	<td>
											      	<textarea name="description" cols="70" rows="3"><%=activity != null ? activity.getDescription() : ""%></textarea>
										      	</td>
										    </tr>
      										<tr>
										      	
										      	<td>
											      	<input type="hidden" name="criticalFlg" id="criticalFlg" value="<%=Constants.STEP_ACTIVITY_CRITICAL_FLAG_STATUS_YES%>" >
										      	</td>
										    </tr>
											<tr>
										      	<td colspan="2">
											      	
											      	<%
														if (option != null && option.equalsIgnoreCase("edit")) {
													%>
												    	<input type=button  class=button value="Save" onclick="doSave('<%= activity != null ? String.valueOf(activity.getId()) : ""%>','<%=stepId%>');">&nbsp;&nbsp;
												    <%
												    	} else {
												    %>
												    	<input type=button  class=button value="Save & Add Next" onclick="onCreate('<%= activity != null ? String.valueOf(activity.getId()) : ""%>','<%=stepId%>');">&nbsp;&nbsp;
												    <%
												    	}
												    %>
													<input type=button name="save1" class=button value="Back & Refresh" onclick="javascript:onClose()">
											      	
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
	</table>
</form>
	</body>
</html>
<%
	} else {
	out.println("!!你没有相关访问权限!!");
	}
%>