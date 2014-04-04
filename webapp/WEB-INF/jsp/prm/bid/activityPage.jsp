<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="com.aof.component.prm.bid.BidMaster"%>
<%@ page import="com.aof.component.prm.bid.SalesStepGroup"%>
<%@ page import="com.aof.component.prm.bid.SalesStep"%>
<%@ page import="com.aof.component.prm.bid.SalesActivity"%>
<%@ page import="com.aof.component.prm.bid.BidActivity"%>
<%@ page import="com.aof.component.prm.bid.BidActDetail"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%
BidMaster bidMaster = (BidMaster)request.getAttribute("BidMaster");
ArrayList steps = (ArrayList)request.getAttribute("stepsList");
SalesStepGroup stepGroup = (SalesStepGroup)request.getAttribute("stepGroup");
Set BidActDetailList = (Set)request.getAttribute("BidActDetailList");
Set bidActivityObject = (Set)request.getAttribute("bidActivityObject");

String id =  bidMaster.getId().toString();

String stepGroupId = null;

if(BidActDetailList==null){
	BidActDetailList = new HashSet();
}
if(stepGroup != null){
	stepGroupId = stepGroup.getId() + "";
}
%>

<script>
	function showAction(bidActId, bidId){
		var param = "?FormAction=view";
		param += "&bidActId=" + bidActId;
		param += "&bidId=" + bidId;
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&EditBidActDet.do" + param,
			null,
			'dialogWidth:800px;dialogHeight:500px;status:no;help:no;scroll:no');

		if (v != null){
			var actListSize = v.split("|")[1];
			document.getElementById("actSize"+bidActId).innerHTML=actListSize;
			document.getElementById("actHr"+bidActId).innerHTML=v.split("|")[3];
			document.getElementById("currStep").innerHTML='<font color=red>'+v.split("|")[2];
			if (actListSize >0){
				document.getElementById("actCheckBox"+bidActId+"1").style.display="block";
				document.getElementById("actCheckBox"+bidActId+"2").style.display="none";
				document.getElementById("actCheckBox"+bidActId+"3").style.display="none";
			}else{
				document.getElementById("actCheckBox"+bidActId+"2").style.display="block";
				document.getElementById("actCheckBox"+bidActId+"1").style.display="none";
				document.getElementById("actCheckBox"+bidActId+"3").style.display="none";
			}
			
			//change status
			if(v.split("|")[2]==100){
				var oDiv = document.getElementById("other");
				oDiv.style.display="none";
			
				oDiv = document.getElementById("won");
				oDiv.style.display="block";
				
			}else{
				var oDiv = document.getElementById("other");
				oDiv.style.display="block";
			
				oDiv = document.getElementById("won");
				oDiv.style.display="none";
			
				var oSelect = document.getElementsByName("status");
				
			}
			var currentStatus = v.split("|")[4];
			document.EditForm.statusValue.value = currentStatus;
			if(currentStatus != "Won"){
				var otherStus = document.getElementById("otherStus");
				for(i=0; i<otherStus.options.length; i++){
					if(currentStatus == otherStus.options[i].value){
						otherStus.options[i].selected = true;
					}
				}
			}
		}
	}
</script>

<form name="EditForm" action="editBidMaster.do" method="post">
<input type="hidden" name="stepGroupId" id = "stepGroupId"	value="<%=stepGroupId !=null ? stepGroupId : "" %>">
<table border=0 width='100%' cellspacing='0' cellpadding='1'>
	<tr>
		<td width='100%'>
			<table width='100%' border='0' cellspacing='0' cellpadding='0'>
				<tr>
					<td align=left width='90%' class="wpsPortletTopTitle">Sales Phases Tracking</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%" align="center"><table><tr>
		<td align="right" class="lblbold" width="58%"><span class="tabletext"><font color="red">Bid Current WIN %:</span></td>
		<%
		int curr = 0;
		if(bidMaster.getCurrentStep()!=null){
			curr = (bidMaster.getCurrentStep().getPercentage().intValue());
		}
		%>
		<td align="left" class="lblbold"><span class="tabletext"><font color="red"><div style="display:inline" id="currStep"><%=curr%></div>%</span></td>
	</tr></table></td>
	</tr>
	<%	
	if(steps != null){
		Iterator it = steps.iterator();
		while (it.hasNext()) {
			SalesStep step = (SalesStep)it.next();
			String description1 = step.getDescription();
			Integer percentage = step.getPercentage();			
	%>		
	<tr>
    	<td width='100%'>
			<table border=0 width='100%'  >
				<tr>
					<td colspan = 5 align ="center" bgcolor="#e9eee9">
						<b><%=description1%>&nbsp;&nbsp;&nbsp;<%=percentage%>%</b>
					</td>
				</tr>
			  	<tr>
				  	<td align="center" class="lblbold" width='20%'>Activity No.</td>
				  	<td align="center" class="lblbold" width='40%'>Description</td>
					<td width='2%'></td>
					<td width='20%'></td>
					<td align="center" class="lblbold" width='8%'>Status</td>
				</tr>
				<%
				Set activities = null;
				if(step.getActivities()!=null && step.getActivities().size()>0){
					activities = step.getActivities();
					
					ArrayList activityList = new ArrayList();
					Object[] activityArray = activities.toArray();
					for(int i = 0;i<activities.size();i++){
						Integer seqNo1= ((SalesActivity)activityArray[i]).getSeqNo();
						for(int j=i+1;j<activities.size();j++){
							Integer seqNo2 = ((SalesActivity)activityArray[j]).getSeqNo();
							seqNo1= ((SalesActivity)activityArray[i]).getSeqNo();
							if(seqNo1.intValue()>seqNo2.intValue()){
								Object temp = activityArray[i];
								activityArray[i] = activityArray[j];
								activityArray[j] = temp;
							}
						}
						activityList.add(activityArray[i]);
					}				
					Iterator itActi = activityList.iterator();
					while(itActi.hasNext()){
						SalesActivity activity = (SalesActivity)itActi.next();
						String description2 = activity.getDescription();
						Integer seqNoActivity = activity.getSeqNo(); 
						Long ida = activity.getId();
				%>
				<tr>			
					<td align="center" class="lblight"><%=seqNoActivity.intValue()%></td>
					<td align="center" class="lblight"><%=description2%></td>
						<%
						String ck = "";
						String bidActId = "";
						BidActivity bidtempt1 = null;
						if(bidActivityObject != null){
							Iterator itBid = bidActivityObject.iterator();
							while(itBid.hasNext()){
								bidtempt1 = (BidActivity)itBid.next();
								if(bidtempt1.getActivity().getId().equals(ida)){
									bidActId = String.valueOf(bidtempt1.getId());
									break;
								}
							}
						}
						%>
					<input type="hidden" name="bidActId" id = "bidActId" value="<%=bidActId%>">
						<%			
						String actName = "actSize"+bidActId;
						String HrName = "actHr"+bidActId;
						String actCheckBox = "actCheckBox"+bidActId;
						Set ba = bidMaster.getBidActivities();
						Iterator i1 = ba.iterator();
						int ss =0;
						int hr = 0;
						while(i1.hasNext()){
							BidActivity bidActivity = (BidActivity)i1.next();
							if((bidActivity.getActivity().getId()==ida)&& (bidActivity.getBidActDetails()!=null)){
								ss = bidActivity.getBidActDetails().size();
								if (ss!= 0){ 
									ck="checked";
								}
								Iterator actSet = bidActivity.getBidActDetails().iterator();
								while(actSet.hasNext()){
									BidActDetail bad = (BidActDetail)actSet.next();
									hr=bad.getHours().intValue()+hr;
								}
							}
						}
						%>
					<td></td>
					<td align="left">
						<a href="javascript:showAction(<%=bidActId%>,<%=id%>)">Your Efforts (<div style="display:inline" id="<%=actName%>"><%=ss%></div>&nbsp;,&nbsp;<div style="display:inline" id="<%=HrName%>"><%=hr%></div>&nbsp;Hrs) </a>&nbsp;&nbsp;
					</td>		
					<td align="center">
						<div style="display:none" id="<%=actCheckBox%>1"> 
						<input type="checkbox" name="bidActivitieId0" value="<%=String.valueOf(ida)%>"  Disabled class="checkboxstyle" checked>
						&nbsp;<font color =red>*</font>
						</div>
						<div style="display:none" id="<%=actCheckBox%>2"> 
						<input type="checkbox" name="bidActivitieId1" value="<%=String.valueOf(ida)%>"  Disabled class="checkboxstyle" >
						&nbsp;<font color =red>*</font>
						</div>
						<div style="display:block" id="<%=actCheckBox%>3"> 
						<input type="checkbox" name="bidActivitieId2" value="<%=String.valueOf(ida)%>"  Disabled class="checkboxstyle" <%=ck%>>
						&nbsp;<font color =red>*</font>
						</div>
					</td>									
				</tr>				
				<%
					}
				}
				%>		
			</table>
		</td>
	</tr>
<%
		}
	}
%>
</table>
</form>