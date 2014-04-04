<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="java.util.List" %>

<%@ page import="com.aof.component.prm.skillset.SkillCategory" %>
<%@ page import="com.aof.component.prm.skillset.SkillLevel" %>
<%@ page import="com.aof.component.prm.skillset.Skill" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
	if (AOFSECURITY.hasEntityPermission("SKILL_SET", "_QUERY", session)) {
		List valueList = (List)request.getAttribute("valueList");
		List levelList = (List)request.getAttribute("levelList");
		List catList = (List)request.getAttribute("catList");
%>
<script language="javascript">

	function changeSubSkill(){
		
		changeInit();
	
		if(listForm.pCat.value == "001"){
	 		document.getElementById("skillDesc001").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	
	 	if(listForm.pCat.value == "002"){
	 		document.getElementById("sub002").style.display="block";
	 		if(listForm.subCat002.value == "002001"){			
		 		document.getElementById("skillDesc002001").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat002.value == "002002"){
		 		document.getElementById("skillDesc002002").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat002.value == "002003"){
		 		document.getElementById("skillDesc002003").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
	 	}
		
		if(listForm.pCat.value == "003"){
	 		document.getElementById("sub003").style.display="block";
	 		if(listForm.subCat003.value == "003001"){			
		 		document.getElementById("skillDesc003001").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat003.value == "003002"){
		 		document.getElementById("skillDesc003002").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat003.value == "003003"){
		 		document.getElementById("skillDesc003003").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat003.value == "003004"){
		 		document.getElementById("skillDesc003004").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		}
		
		if(listForm.pCat.value == "004"){
	 		document.getElementById("sub004").style.display="block";
	 		
	 		if(listForm.subCat004.value == "004001"){			
		 		document.getElementById("skillDesc004001").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat004.value == "004002"){
		 		document.getElementById("skillDesc004002").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat004.value == "004003"){
		 		document.getElementById("skillDesc004003").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat004.value == "004004"){
		 		document.getElementById("skillDesc004004").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat004.value == "004005"){			
		 		document.getElementById("skillDesc004005").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat004.value == "004006"){
		 		document.getElementById("skillDesc004006").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		 	if(listForm.subCat004.value == "004007"){
		 		document.getElementById("skillDesc004007").style.display="block";
		 		document.getElementById("selectall").style.display="none";
		 	}
		}
		
		if(listForm.pCat.value == "005"){
	 		document.getElementById("skillDesc005").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	
	 	if(listForm.pCat.value == "006"){
	 		document.getElementById("skillDesc006").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	}
	
	function changeDesc002(){
	
 		changeInit();
 		document.getElementById("sub002").style.display="block";
		
		if(listForm.subCat002.value == "002001"){			
	 		document.getElementById("skillDesc002001").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat002.value == "002002"){
	 		document.getElementById("skillDesc002002").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat002.value == "002003"){
	 		document.getElementById("skillDesc002003").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	}
	
	function changeDesc003(){
	
 		changeInit();
 		document.getElementById("sub003").style.display="block";
		
		if(listForm.subCat003.value == "003001"){			
	 		document.getElementById("skillDesc003001").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat003.value == "003002"){
	 		document.getElementById("skillDesc003002").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat003.value == "003003"){
	 		document.getElementById("skillDesc003003").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat003.value == "003004"){
	 		document.getElementById("skillDesc003004").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	}
	
	function changeDesc004(){
	
 		changeInit();
 		document.getElementById("sub004").style.display="block";
		
		if(listForm.subCat004.value == "004001"){			
	 		document.getElementById("skillDesc004001").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat004.value == "004002"){
	 		document.getElementById("skillDesc004002").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat004.value == "004003"){
	 		document.getElementById("skillDesc004003").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat004.value == "004004"){
	 		document.getElementById("skillDesc004004").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat004.value == "004005"){			
	 		document.getElementById("skillDesc004005").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat004.value == "004006"){
	 		document.getElementById("skillDesc004006").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	 	if(listForm.subCat004.value == "004007"){
	 		document.getElementById("skillDesc004007").style.display="block";
	 		document.getElementById("selectall").style.display="none";
	 	}
	}
	
	function changeInit(){
	
		document.getElementById("selectall").style.display="block";
		
		document.getElementById("sub002").style.display="none";
 		document.getElementById("sub003").style.display="none";
 		document.getElementById("sub004").style.display="none";
		
		document.getElementById("skillDesc001").style.display="none";
 		document.getElementById("skillDesc005").style.display="none";
 		document.getElementById("skillDesc006").style.display="none";
 		
 		document.getElementById("skillDesc002001").style.display="none";
 		document.getElementById("skillDesc002002").style.display="none";
 		document.getElementById("skillDesc002003").style.display="none";
 		
 		document.getElementById("skillDesc003001").style.display="none";
 		document.getElementById("skillDesc003002").style.display="none";
 		document.getElementById("skillDesc003003").style.display="none";
 		document.getElementById("skillDesc003004").style.display="none";
 		
 		document.getElementById("skillDesc004001").style.display="none";
 		document.getElementById("skillDesc004002").style.display="none";
 		document.getElementById("skillDesc004003").style.display="none";
 		document.getElementById("skillDesc004004").style.display="none";
 		document.getElementById("skillDesc004005").style.display="none";
 		document.getElementById("skillDesc004006").style.display="none";
 		document.getElementById("skillDesc004007").style.display="none";
	}
	
	function fnQuery(){
		listForm.submit();
	}

	function fnCommentQuery(){

		var param = "?formAction=comment&command=queryComment";

		v = window.showModalDialog(
			"system.showDialog.do?title=prm.comment.dialog.title&skillAction.do" + param,
			null,
			'dialogWidth:650px;dialogHeight:400px;status:no;help:no;scroll:no');
	}

	function showResult(catId,levelId){

		var param = "?formAction=query&catId=" + catId + "&levelId=" + levelId;

		v = window.showModalDialog(
			"system.showDialog.do?title=prm.skillset.dialog.title&skillAction.do" + param,
			null,
			'dialogWidth:800px;dialogHeight:500px;status:no;help:no;scroll:no');
	}

</script>

<table width=100% cellpadding="1" border="0" cellspacing="1">
	<caption align=center class=pgheadsmall>Skill Set View</caption>
	<tr><td>
		<form name="listForm" action="skillAction.do" method="post">
			<input type="hidden" name="formAction" id="formAction" value="list">
			<input type="hidden" name="command" id="command" value="">
			<table width="100%">
				<tr><td colspan=5><hr color=red></hr></td></tr>
				<tr>
					<td class=lblerr align="center" colspan=5>
						Click <a style="cursor:hand" onclick="fnCommentQuery()">here</a> to view comments and suggestions left by staff.
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>
						<div>
							<table border=0>
								<tr>
									<td width="120" class="lblbold">Skill Category:&nbsp;</td>
				    				<td class="lblLight">
				    					<select name="pCat" onchange="changeSubSkill()">
							                <option value="" selected>ALL</option>
							                <option value="001">Industrial Knowledge</option>
							                <option value="002">Technical Skills: Service Delivery</option>
							                <option value="003">Technical Skills: Systems Development and Maintenance</option>
							                <option value="004">Application Knowledge</option>
							                <option value="005">Project management</option>
							                <option value="006">Language</option>
							        	</select>
									</td>
								</tr>
							</table>
						</div>
					
						<div style="display:none" id="sub002">
							<table border=0>
								<tr>
									<td width="120" class="lblbold">Sub-Skill Category:&nbsp;</td>
									<td class="lblLight">
										<select name="subCat002" onchange="changeDesc002()">
											<option value="" selected>ALL</option>
											<option value="002001" >Networking operation</option>
				                			<option value="002002" >System Administration</option>
				                			<option value="002003" >Database Administration</option>
										</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="sub003">
							<table border=0>
								<tr>
									<td width="120" class="lblbold">Sub-Skill Category:&nbsp;</td>
									<td>
										<select name="subCat003" onchange="changeDesc003()">
											<option value="" selected>ALL</option>
											<option value="003001" >Application Platform</option>
				                			<option value="003002" >Database platform</option>
				                			<option value="003003" >Development platform</option>
				                			<option value="003004" >Data Warehouse</option>
										</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="sub004">
							<table border=0>
								<tr>
									<td width="120" class="lblbold">Sub-Skill Category:&nbsp;</td>
									<td>
										<select name="subCat004" onchange="changeDesc004()">
											<option value="" selected>ALL</option>
											<option value="004001" >ERP</option>
				                			<option value="004002" >Credit Cards Mgt System</option>
				                			<option value="004003" >Risk Management</option>
				                			<option value="004004" >Core Banking</option>
				                			<option value="004005" >SCADA</option>
				                			<option value="004006" >Business Intelligence(BI) product</option>
				                			<option value="004007" >Output Solution</option>
										</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:block" id="selectall">
							<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
				    				<td class="lblLight">
				    					<select name="selectall">
							                <option value="" selected>--------------</option>
							        	</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc001">
							<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
				    				<td class="lblLight">
				    					<select name="desc001">
				    						<option value="" selected>ALL</option>
							                <option value="001001" >Manufacturing: General</option>
							                <option value="001002" >Manufacturing: Automobile</option>
							                <option value="001003" >Manufacturing: Electronics</option>
							                <option value="001004" >Manufacturing: Pharmacy</option>
							                <option value="001005" >Manufacturing: Petro</option>
							                <option value="001006" >Retailer</option>
							                <option value="001007" >Banking: Credit Card</option>
							                <option value="001008" >Finance: Risk management</option>
							                <option value="001009" >Banking: Core Banking</option>
							                <option value="001010" >Banking: Timebargain</option>
							                <option value="001011" >Insurance</option>
							                <option value="001012" >Energy: Nuclear</option>
							                <option value="001013" >Oil and Gas</option>
							                <option value="001014" >Securities</option>
							        	</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc002001">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc002001">
				    						<option value="" selected>ALL</option>
				                			<option value="002001001" >WAN</option>
				                			<option value="002001002" >Lease Line</option>
				                			<option value="002001003" >Router Configuration</option>
				                			<option value="002001004" >Network Security</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc002002">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc002002">
				    						<option value="" selected>ALL</option>
				                			<option value="002002001" >Windows server(win 2000/2003)</option>
				                			<option value="002002002" >HP Unix</option>
				                			<option value="002002003" >Sun Solaris</option>
				                			<option value="002002004" >Linux</option>
				                			<option value="002002005" >IBM AS400</option>
				                			<option value="002002006" >IBM OS390</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc002003">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc002003">
				    						<option value="" selected>ALL</option>
				                			<option value="002003001" >Oracle</option>
				                			<option value="002003002" >DB2</option>
				                			<option value="002003003" >SQL Server</option>
				                			<option value="002003004" >QAD progress</option>
				                			<option value="002003005" >SAP Basis</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc003001">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc003001">
				    						<option value="" selected>ALL</option>
				                			<option value="003001001" >IBM Websphere</option>
				                			<option value="003001002" >Microsoft sharepoint</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc003002">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc003002">
				    						<option value="" selected>ALL</option>
				                			<option value="003002001" >Oracle</option>
				                			<option value="003002002" >DB2</option>
				                			<option value="003002003" >SQL</option>
				                			<option value="003002004" >QAD progress</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc003003">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc003003">
				    						<option value="" selected>ALL</option>
				                			<option value="003003001" >.net</option>
				                			<option value="003003002" >COBOL</option>
				                			<option value="003003003" >J2EE</option>
				                			<option value="003003004" >Progress for 4GL</option>
				                			<option value="003003005" >SAP ABAP4</option>
				                			<option value="003003006" >SMALLTALK</option>
				                			<option value="003003007" >Rule Engineer</option>
				                			<option value="003003008" >Workflow</option>
				                			<option value="003003009" >Report Engine</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc003004">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc003004">
				    						<option value="" selected>ALL</option>
				                			<option value="003004001" >ETC: Extract/Transfer/Load</option>
				                			<option value="003004002" >Modeling</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc004001">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc004001">
				    						<option value="" selected>ALL</option>
				                			<option value="004001001" >QAD</option>
				                			<option value="004001002" >BAAN</option>
				                			<option value="004001003" >SAP Basic</option>
				                			<option value="004001004" >SAP FI</option>
				                			<option value="004001005" >SAP CO</option>
				                			<option value="004001006" >SAP AM</option>
				                			<option value="004001007" >SAP SD</option>
				                			<option value="004001008" >SAP MM</option>
				                			<option value="004001009" >SAP PP</option>
				                			<option value="004001010" >SAP HR</option>
				                			<option value="004001011" >SAP PM</option>
				                			<option value="004001012" >SAP QM</option>
				                			<option value="004001013" >SAP PS</option>
				                			<option value="004001014" >SAP OC</option>
				                			<option value="004001015" >SAP IS</option>
				                			<option value="004001016" >Oracle: Distribution</option>
				                			<option value="004001017" >Oracle: Manufacturing</option>
				                			<option value="004001017" >Oracle: Finance</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc004002">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc004002">
				    						<option value="" selected>ALL</option>
				                			<option value="004002001" >Essentis</option>
				                			<option value="004002002" >Cardlink</option>
				                			<option value="004002003" >SemaCard</option>
				                			<option value="004002004" >COSES</option>
				                			<option value="004002005" >IST</option>
				                			<option value="004002006" >Switch</option>
				                			<option value="004002007" >Work Bench</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc004003">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc004003">
				                			<option value="004003001" selected>AXIOM</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc004004">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc004004">
				    						<option value="" selected>ALL</option>
				                			<option value="004004001" >C&W</option>
				                			<option value="004004002" >Siglo21</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc004005">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc004005">
				    						<option value="" selected>ALL</option>
				                			<option value="004005001" >HP Unix</option>
				                			<option value="004005002" >ADACS</option>
				                			<option value="004005003" >LYNX</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc004006">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc004006">
				    						<option value="" selected>ALL</option>
				                			<option value="004006001" >CorVu</option>
				                			<option value="004006002" >Business Object</option>
				                			<option value="004006003" >Cognos</option>
				                			<option value="004006004" >Crystal Report</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc004007">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc004007">
				                			<option value="004007001" selected>OPTIO</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc005">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc005">
				    						<option value="" selected>ALL</option>
				                			<option value="005001" >Project Administration/Officer</option>
				                			<option value="005002" >Project Manager</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
						
						<div style="display:none" id="skillDesc006">
	    					<table  border=0>
								<tr>
									<td width="120" class="lblbold">Skill Description:&nbsp;</td>
									<td class="lblLight">
				    					<select name="desc006">
				    						<option value="" selected>ALL</option>
				                			<option value="006001" >Chinese</option>
				                			<option value="006002" >English</option>
				                			<option value="006003" >Japanese</option>
				                			<option value="006004" >Korean</option>
				                			<option value="006005" >Cantonese</option>
				              			</select>
									</td>
								</tr>
							</table>
						</div>
					</td>
					<td align="center">
						<input type="button" name="btnAdd" value="Query" class="button" onclick="fnQuery()">
					</td>
				</tr>
				<tr><td colspan=5 valign="top"><hr color=red></hr></td></tr>
			</table>
			<table border="0" align="center" cellpadding="2" cellspacing="2" width=99%>
				<%
				// 没有找到符合条件的员工
				if( valueList == null || valueList.size() <= 0 ){
					out.println("<br><tr><td colspan='12' class=lblerr align='center'>No Record Found.</td></tr>");
				} else {
				
					int size = catList.size();
					for(int i = 0; i < size; i++){
					
						SkillCategory tmpCat = (SkillCategory)catList.get(i);
						String pCat = tmpCat.getPcatId();						
	        			
	        			// 如果pCat为空，则说明为顶级节点，构造表头，插入Level说明。
						if(pCat == null || pCat.equals("")){
				%>
				<tr bgcolor="#DBF0FF">
					<td align=left class="lblbold"><%=tmpCat.getCatId().substring(1,3)%>:&nbsp;<%=tmpCat.getCatName()%></td>
				<%
							// 插入Level描述
							for(int j = 0; j < levelList.size(); j++){
								SkillLevel level = (SkillLevel)levelList.get(j);
								if(level.getCatId().equals(tmpCat.getCatId())){
				%>
					<td align=center class="lblbold"><%=level.getLevelDesc()%></td>
	        	<%
	        					}
	        				}
	        	%>
	        	</tr>
	        	<%
	        			} else {
	        				
	        				String catId = tmpCat.getCatId();
	        				int indexSize = catId.length()/3;
	        				
	        				// 生成分类序列号，如："01-02-06"
	        				String catIndex = "";
	        				int beginIndex = 1;
							int endIndex = 3;
	        				for(int index = 0; index < indexSize; index++){
	        					String blank = "&nbsp;&nbsp;&nbsp;";
	        					if (catIndex.equals("")) {
									catIndex = blank + catIndex+ catId.substring(beginIndex, endIndex);
								} else {
									catIndex = blank + catIndex + "-" + catId.substring(beginIndex, endIndex);
								}
								beginIndex += 3;
								endIndex += 3;
	        				}
	        				
	        				//判断当前目录节点是否有子节点，如果有，该节点用不同颜色显示
	        				String b1 = "";
	        				if((i+1) >= catList.size()){
	        					b1="#e9eee9";
	        				}else{
	        					SkillCategory nextCat = (SkillCategory)catList.get(i+1);
		        				String nextCatId = nextCat.getCatId();
		        				if(nextCatId.length() > catId.length()){
		        					// 有子节点
		        					b1="#E4EAC1";
		        				} else {
		        					// 没有子节点
		        					b1="#e9eee9";
		        				}
	        				}
	        	%>
	        	<tr bgcolor=<%=b1%>>
	        		<td nowrap><%=catIndex%>:&nbsp;<%=tmpCat.getCatName()%></td>
	        		<%
	        				// 判断员工填写的Skill Set是否存在该技能
	        				boolean dataMeet = false;
	        				
	        				int level1Count = 0;
	        				int level2Count = 0;
	        				int level3Count = 0;
	        				int level4Count = 0;
	        				
	        				for(int row = 0; row < valueList.size(); row++){
	        				
	        					Skill tmpValue = (Skill)valueList.get(row);
	        					String valueCatId = tmpValue.getSkillCat().getCatId();
	        					
	        					// 存在，计数！
	        					if(valueCatId.equals(tmpCat.getCatId())){
	        						dataMeet = true;
	        						String valueLevel = tmpValue.getSkillLevel().getLevelId();
	        						int tmpSize = valueLevel.length();
	        						String subStr = valueLevel.substring(tmpSize-3,tmpSize);
	        						if("001".equals(subStr)){
	        							level1Count++;
	        						}
	        						if("002".equals(subStr)){
	        							level2Count++;
	        						}
	        						if("003".equals(subStr)){
	        							level3Count++;
	        						}
	        						if("004".equals(subStr)){
	        							level4Count++;
	        						}
	        					}
	        				}
	        				if(dataMeet){
	        					if(level1Count != 0){
	        						;
	        	%>
	        		<td nowrap align=center>
	        			<a style="cursor:hand" onclick="showResult('<%=tmpCat.getCatId()%>','<%=tmpCat.getCatId().substring(0,3)+"001"%>')">
	        				&nbsp;<%=level1Count%>&nbsp;
	        			</a>
	        		</td>
	        	<%
	        					}else{    	
	        	%>
	        		<td nowrap>&nbsp;</td>
	        	<%				}
	        					if(level2Count != 0){
	        	%>
	        		<td nowrap align=center>
	        			<a style="cursor:hand" onclick="showResult('<%=tmpCat.getCatId()%>','<%=tmpCat.getCatId().substring(0,3)+"002"%>')">
	        				&nbsp;<%=level2Count%>&nbsp;
	        			</a>
	        		</td>
	        	<%
	        					}else{
	        	%>
	        		<td nowrap>&nbsp;</td>
	        	<%				
	        					}
	        					if(level3Count != 0){
	        	%>
	        		<td nowrap align=center>
	        			<a style="cursor:hand" onclick="showResult('<%=tmpCat.getCatId()%>','<%=tmpCat.getCatId().substring(0,3)+"003"%>')">
	        				&nbsp;<%=level3Count%>&nbsp;
	        			</a>
	        		</td>
	        	<%
	        					}else{
	        	%>
	        		<td nowrap>&nbsp;</td>
	        	<%				
	        					}
	        					if(level4Count != 0){
	        	%>
	        		<td nowrap align=center>
	        			<a style="cursor:hand" onclick="showResult('<%=tmpCat.getCatId()%>','<%=tmpCat.getCatId().substring(0,3)+"004"%>')">
	        				&nbsp;<%=level4Count%>&nbsp;
	        			</a>
	        		</td>
	        	<%
	        					}else{
	        	%>
	        		<td nowrap>&nbsp;</td>
	        	<%
	        					}
	        				}else{
	        	%>
	        		<td nowrap>&nbsp;</td><td nowrap>&nbsp;</td><td nowrap>&nbsp;</td><td nowrap>&nbsp;</td>
	        	<%
	        				}
	        	%>
	        	</tr>
	        	<%
	        			}
	        		}
	        	}
	        	%>
			</table>
		</form>
	</td></tr>
</table>
<%
	}else{
		out.println("!!你没有相关访问权限!!");
	}
} catch(Exception ex) {
	ex.printStackTrace();
}
%>