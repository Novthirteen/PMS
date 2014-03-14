<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.aof.component.prm.bid.BidMaster"%>
<%@ page import="com.aof.component.prm.bid.BidUnweightedValue"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%	BidMaster bidMaster = (BidMaster)request.getAttribute("BidMaster");
%>
<script>

	function checkStartDate(sDate){
		var t = new Date(sDate.replace(/\-/g,"/"));
		var nowDate = new Date();
		var status = "<%=bidMaster!=null?bidMaster.getStatus():""%>";
		
		if(nowDate>t && status!="Won"){
			if (!confirm("Estimated Contract Start Date cannot be today or earlier! Do you want to continue?")){
				return false;
			}else{
			return true;
		}
			
		}else{
			return true;
		}
	}

	function validate(){
	   	var startDate = document.EditForm.estimateStartDate;
		var endDate = document.EditForm.estimateEndDate;
		if(startDate.value==""){
   			alert("Estimated Contract Start Date cannot be ignored!");
   			return false;
   		}
   		if(endDate.value==""){
   			alert("Estimated Contract End Date cannot be ignored!");
   			return false;
   		}
	    if (startDate.value.length>0 && endDate.value.length==0){
	      	if(dataOneCheck(startDate)){
	      		if(!checkStartDate(startDate.value))	return false;
	      	}else{
	      		return false;
	      	}
	    }
		if(document.getElementById("expectedEndDate").value == ""){
			alert("The Expected Contract Sign Date cannot be ignored!");
			return false;
		}
	    if ((document.getElementById("expectedEndDate").value != "")&(document.getElementById("expectedEndDate").value > document.getElementById("estimateStartDate").value)){
	    	if (!confirm("The Contract Sign Date should not be later than Contract Start Date! Do you want to continue?")){
	    		return false;
	    	}
	    }
		if(document.getElementById("PresalePMId").value == ""){
			alert("The presale manager cannot be ignored!");
			return false;
    	}
	    if((startDate.value.length>0 && endDate.value.length>0)){
	       	if(dataCheck(startDate,endDate)){
	       		if(!checkStartDate(startDate.value)){
	       			return false;
	       		}	
	       	}else{
	       		return false;
	       	}
	    }
	    if(startDate.value.length==0 && endDate.value.length>0){
	        alert("End Date cannot be earlier than Start Date!");
	        return false;
	    }
	    
	    var a = document.getElementsByName("unweightedValue");
	    if(a[0]==null){
	    	return true;
	    }
	    
		var estValueByYear = 0;
		for(i=0;i<a.length;i++){
			removeComma(a[i]);
			estValueByYear = estValueByYear+parseFloat(a[i].value);
		}

	   	a = document.getElementsByName("unweightedValueNew");
	    if(a[0]==null){
	    	return true;
	    }
	    
		for(i=0;i<a.length;i++){
			removeComma(a[i]);
			estValueByYear = estValueByYear+parseFloat(a[i].value.replace(/,/g, ""));
		}
		
		removeComma(document.EditForm.caculatedAmt);
		var estValue = parseFloat(document.EditForm.caculatedAmt.value.replace(/,/g, ""));
		addComma(document.EditForm.caculatedAmt, '.', '.', ',');
		
		if(estValueByYear-estValue > 1){
	    	alert("Yearly Amount must be less or equal to the Estimated Contract Value !");
	    	return false;
		}
		return true;
	}

	
	function addUnweightedValueList(){
	
		var errormessage= ValidateData();
	   	if (errormessage != "") {
			alert(errormessage);
			return ;
		}
	   	var year=document.EditForm.yearNew.value;
	   	var value=document.EditForm.unweightedValueNew.value;
	   	var tcv = parseFloat(document.getElementById("caculatedAmt").value.replace(/,/g, ""));
	   		   	
		if(!year) {
			alert("You must input the year!");
			return ;
		}
		if (!value) {
			alert("You must input the value!");
			return ;
		}
		
		if(value > tcv){
			alert("Unweighted Value cannot be bigger than Total Contract Value!");
			return;
		}
		
		var strP=/^\d+(\.\d+)?$/;
		if(!strP.test(year)){
			alert("Invalid year value!");
	   		return ;
		}else if(year.length !=4){
			alert("Invalid year value!");
	   		return ;
		}else if  (year.length<0){
	   		alert("Invalid year value!");
	   		return ;
	   	}
	   	if(!strP.test(value)){
	   		alert("Invalid amount value!");
	   		return ;
	   	}
		try{
	  		if(parseFloat(year)!=year) {
	  			alert("Invalid year value!");
	  			return ;
  			}
	  		if(parseFloat(value)!=value) {
	  			alert("Invalid amount value!");
	  			return ;
  			}
		}catch(ex){
	   		return ;
	  	}
	  	if(validate()){
	  	document.EditForm.formAction.value = "addUnweightedValueList";
	  	document.EditForm.submit();}
	}
	
	function recal()
	{
	  	document.EditForm.formAction.value = "recalUnweightedValue";
	  	if(validate())
		  	document.EditForm.submit();	
	}

	function deleteUnweightedValueList(year){
		if (confirm("Do you want delete this year unweighted value?")){
			document.EditForm.formAction.value = "deleteUnweightedValue";
			document.EditForm.yearAdd.value = year;
			document.EditForm.submit();
		}
	}
	
	

	
</script>
<%
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
NumberFormat Num_formater2 = NumberFormat.getInstance();
Num_formater2.setMaximumFractionDigits(5);
Num_formater2.setMinimumFractionDigits(2);

List unweightedList=(List)request.getAttribute("BidUnweightedValueList");
%>
<form name="EditForm" action="editBidMaster.do" method="post">
<input type="hidden"  name="yearAdd" value="">
<table border=0 width='100%' cellspacing='0' cellpadding='1'>
	<tr>
    	<td width='100%'>
      		<table width='100%' border='0' cellspacing='0' cellpadding='0'>
        		<tr>
          			<td align=left width='90%' class="wpsPortletTopTitle">&nbsp;&nbsp; Unweighted Value List</td>
        		</tr>
      		</table>
    	</td>
	</tr>
	<tr>
		<td width='100%'colspan=4>
			<table border=0 width='100%'>
				<tr bgcolor="#e9eee9">
				  	<td align="center" class="lblbold">year</td>
				  	<td align="center" class="lblbold">Amount (RMB)</td>
					<td align="center" class="lblbold">Action</td>
				</tr>
				<%
				if (unweightedList != null){
					Iterator tmpIt = unweightedList.iterator();
					while (tmpIt.hasNext()) {
						String year = "";
						double value = 0;
						BidUnweightedValue bv = (BidUnweightedValue)tmpIt.next();
						year = bv.getYear();
						value = bv.getValue().doubleValue();
				%>
  				<tr>
					<td align="center">
  						<input type="text" class="inputBox" style="text-align:center"  style="border:0px" readonly name="year" value="<%=year%>" size="20">
  					</td>
  					<td align="center">
  						<input type="text" class="inputBox" style="text-align:right" style="border:0px" readonly name="unweightedValue" value="<%=Num_formater.format(value)%>" size="20">
  					</td>
  					
  					<td align="center" colspan=2>
  						<a href="javascript:deleteUnweightedValueList(<%=year%>)">Delete</a>
  					</td>
  				</tr>
  				<%
  					}
  				} else {
  				%>
  				<tr><td>&nbsp;</td></tr>
  				<%
  				}
  				%>
  				<tr><td colspan=5 valign="bottom"><hr color="#B5D7D6"></hr></td></tr>
  				<tr>
					<td align="center"><input type="text" class="inputBox" name="yearNew" value="" size="20"></td>
  					<td align="center"><input type="text" class="inputBox" name="unweightedValueNew" value="" size="20" style="text-align:right"/></td>
  					<td align="center"><a href="javascript:addUnweightedValueList()">Add</a></td>
  				</tr>
  				<tr><td colspan=3 align="left"><input type="button" class="button" name="" value="ReCalculate" onclick="javascrip:recal()"></td>
  				</tr>
  			</table>
  		</td>
  	</tr>
</table>
</form>
