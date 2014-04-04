<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="net.sf.hibernate.type.*"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language="javascript">
</script>
<%
    NumberFormat Num_formater = NumberFormat.getInstance();
    Num_formater.setMaximumFractionDigits(2);
	Num_formater.setMinimumFractionDigits(2);
	NumberFormat Num_formater2 = NumberFormat.getInstance();
	Num_formater2.setMaximumFractionDigits(5);
	Num_formater2.setMinimumFractionDigits(2);
	SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
	
	Log log = LogFactory.getLog("editBidMaster.jsp");
	long timeStart = System.currentTimeMillis();   //for performance test
	
	if (AOFSECURITY.hasEntityPermission("SALES_STEPS", "_VIEW", session)) {
		BidMaster bidMaster = (BidMaster)request.getAttribute("BidMaster");
		ProspectCompany prospectCompany = (ProspectCompany)request.getAttribute("prospectCompany");
		Set contactSet = (Set)request.getAttribute("contactList");
		SalesStepGroup stepGroup = (SalesStepGroup)request.getAttribute("stepGroup");
		ArrayList steps = (ArrayList)request.getAttribute("stepsList");
		ArrayList bidActivities = (ArrayList) request.getAttribute("bidActivities");
		List partyList = (List)request.getAttribute("PartyList");
		List currencyList = (List)request.getAttribute("CurrencyList");
	    
	    if(contactSet == null)contactSet = new HashSet();
	    
	    String startDateStr = "";
		String endDateStr = "";
		String postDateStr = "";
		String estimateAmountStr = "";
		String exchangeRateStr = "";
		String description = "";
		String status = "";
		String departmentId = "";
		String currencyId = "";
		String stepGroupId = "";
		String id = "";
		
		String prospectCompanyId = "";
		String name = "";
		String chineseName = "";
		String city = "";
		String address = "";
		String bankno = "";
		String industry = "";
		String custGroup = "";
		String postCode = "";
		String faxNo = "";
		String teleNo = "";
		if(prospectCompany !=null){
			prospectCompanyId = prospectCompany.getId()+"";
			name = prospectCompany.getName();
			chineseName = prospectCompany.getChineseName();
			city = prospectCompany.getCity();
			address = prospectCompany.getAddress();
			bankno = prospectCompany.getBankNo();
			industry = prospectCompany.getIndustry();
			custGroup = prospectCompany.getCustomerGroup();
			postCode = prospectCompany.getPostCode();
			faxNo = prospectCompany.getFaxNo();
			teleNo = prospectCompany.getTeleNo();
		}
		
		if(stepGroup != null){
			stepGroupId = stepGroup.getId() + "";
		}
		
	    if (bidMaster!=null){
	    	description = bidMaster.getDescription();
	    	id = bidMaster.getId() + "";
	    	if(bidMaster.getDepartment() != null){
	    		departmentId = bidMaster.getDepartment().getPartyId() + "";
	    	}
	    	if(bidMaster.getCurrency() != null){
	    		currencyId = bidMaster.getCurrency().getCurrId() + "";
	    	}
			java.util.Date startdate = bidMaster.getEstimateStartDate();
			if(startdate!=null){
		    	startDateStr=formater.format(startdate);
		    }
		    
			java.util.Date endDate = bidMaster.getEstimateEndDate();
			if(endDate!=null){
		    	endDateStr=formater.format(endDate);
			}
			
			java.util.Date postDate = bidMaster.getPostDate();
			if(postDate!=null){
		    	postDateStr=formater.format(postDate);
			}
			
			if(bidMaster.getEstimateAmount()!=null){
				estimateAmountStr = Num_formater.format(bidMaster.getEstimateAmount().doubleValue());
			}
			if(bidMaster.getExchangeRate()!=null){
				exchangeRateStr = Num_formater.format(bidMaster.getExchangeRate());
			}
			if(bidMaster.getDescription()!=null){
				description = bidMaster.getDescription();
			}
			if(bidMaster.getStatus()!=null){
				status = bidMaster.getStatus();
			}
			
		}
	String action = request.getParameter("formAction");
	if(action == null){
		action = "new";
	}
%>
<HTML>
	<HEAD>
	
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>

	<BODY>
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<CAPTION align=center class=pgheadsmall>Bid Master</CAPTION>
	<tr>
		<td>
				<input type="hidden" name="formAction" id="formAction" value="query">
				<input type="hidden" name="stepGroupId" id="stepGroupId" value="<%=stepGroupId%>">
				<input type="hidden" name="prospectCompanyId" id="prospectCompanyId" value="<%=prospectCompanyId%>">
				<input type="hidden" name="id" id="id" value="<%=id%>">
				<input type="hidden" name="offSet" id="offSet">
				<TABLE width="100%">
					<tr>
						<td align="right">
          					<span class="tabletext">Description:&nbsp;</span>
       	 				</td>
        				<td>
						<input type="text" class="inputBox" name="description" value="<%=description%>" size="30" />
        				</td>
					
						<td  align="right">Department:</td>
						<td class="lblLight">
							<%
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if (p.getPartyId().equals(departmentId)) {
							%>
									<%=p.getDescription()%>
							<%
									}
								}
							%>
						</td>
						<tr>
						<td align="right">
          					<span class="tabletext">Currency:</span>
        				</td>
						<td>
							<%
								Iterator itCurr = currencyList.iterator();
								while(itCurr.hasNext()) {
									com.aof.component.prm.project.CurrencyType curr = (com.aof.component.prm.project.CurrencyType)itCurr.next();
									if(curr.getCurrId().equals(currencyId)) {
										out.println(curr.getCurrName());
									}
								}
							%>
						</td>
						<td align="right">
 	 						<span class="tabletext">Status:&nbsp;</span>
						</td>
						<td align="left">
							<% 	status = "";
							    if(bidMaster != null && bidMaster.getStatus() != null){
									status = bidMaster.getStatus();
								}
							%>
  							<%=status%>
						</td>
					</tr>
					<tr>
						<td align="right">
          					<span class="tabletext">Estimate Amount(RMB):&nbsp;</span>
       	 				</td>
        				<td>
							<%=estimateAmountStr%>
        				</td>
					
						<td align="right">
          					<span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
       	 				</td>
        				<td>
							<%=exchangeRateStr%>
        				</td>
					</tr>
					<tr>
						<td align="right">
          					<span class="tabletext">Estimate Start Date:&nbsp;</span>
       	 				</td>
        				<td>
						    <%=startDateStr%>
          				</td>
					
						<td align="right">
          					<span class="tabletext">Estimate End Date:&nbsp;</span>
       	 				</td>
        				<td>
        					<%=endDateStr%>
          				</td>
					</tr>
					<tr>
						<td align="right">
          					<span class="tabletext">Post Date:&nbsp;</span>
       	 				</td>
        				<td>
							<%=postDateStr%>
						</td>
						
						<td align="right">
				          <span class="tabletext">Sales Person:&nbsp;</span>
				        </td>
				        <td align="left">
							<%String spId = "";
							String spName = "";
							if (bidMaster.getSalesPerson() != null) {
								spId = bidMaster.getSalesPerson().getUserLoginId();
								spName = bidMaster.getSalesPerson().getName();
							}
							%>
							<%=spName%>
						</td>
					</tr>
													
					<tr>
					   <td align="right">
          					<span class="tabletext">Prospect Company Name:&nbsp;</span>
       	 				</td>
        				<td>
							<%=name%>
						</td>
        				
        				<td align="right">
          					<span class="tabletext">Chinese Name:&nbsp;</span>
       	 				</td>
        				<td>
							<%=chineseName%>
        				</td>
					</tr>
					<tr>
					   <td align="right">
          					<span class="tabletext">City:&nbsp;</span>
       	 				</td>
        				<td>
							<%=city%>
        				</td>
        				
        				<td align="right">
          					<span class="tabletext">Address:&nbsp;</span>
       	 				</td>
        				<td>
							<%=address%>
        				</td>
					</tr>
					<tr>
					   <td align="right">
          					<span class="tabletext">Bank No.:&nbsp;</span>
       	 				</td>
        				<td>
							<%=bankno%>
        				</td>
        				
        				<td align="right">
          					<span class="tabletext">Industry:&nbsp;</span>
       	 				</td>
        				<td>
							<%=industry%>
        				</td>
					</tr>
					<tr>
					   <td align="right">
          					<span class="tabletext">Customer Group:&nbsp;</span>
       	 				</td>
        				<td>
							<%=custGroup%>
        				</td>
        				
        				<td align="right">
          					<span class="tabletext">Post Code:&nbsp;</span>
       	 				</td>
        				<td>
							<%=postCode%>
        				</td>
					</tr>
					<tr>
					   <td align="right">
          					<span class="tabletext">Fax No:&nbsp;</span>
       	 				</td>
        				<td>
							<%=faxNo%>
        				</td>
        				
        				<td align="right">
          					<span class="tabletext">Telephone No.:&nbsp;</span>
       	 				</td>
        				<td>
							<%=teleNo%>
        				</td>
					</tr>
	
					<tr>
						<td colspan=4>
							<TABLE border=0 width='100%'  class=''>
			  					<tr bgcolor="#e9eee9">
								  	<td align="left" class="lblbold">name</td>
								  	<td align="left" class="lblbold">chineseName</td>
									<td align="left" class="lblbold">teleNo</td>
									<td align="left" class="lblbold">email</td>
								</tr>
						<%
							Iterator itst = contactSet.iterator();
							for (int j = 0; j < 3 ; j++) {
								String clid = "";
								String clname = "";
								String clchinesename = "";
								String clteleno = "";
								String clemail = "";
					
								if(itst.hasNext()){
									ContactList contact = (ContactList)itst.next();
									clid = contact.getId() + "";
									clname = contact.getName();
									clchinesename = contact.getChineseName();
									clteleno = contact.getTeleNo();
									clemail = contact.getEmail();
						%>
								<tr>
									<td align="left">
				  						<%=clname%>
				  					</td>
				  					<td align="left">
				  						<%=clchinesename%>
				  					</td>
				  					<td align="left">
				  						<%=clteleno%>
				  					</td>
				  					<td align="left">
				  						<%=clemail%>
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
						if(steps != null){
							Iterator it = steps.iterator();
							while (it.hasNext()) {
								SalesStep step = (SalesStep)it.next();
								String description1 = step.getDescription();
								Integer seqNo = step.getSeqNo();			
					%>
								<tr>
									<td align="right">
          								<span class="tabletext"><%=seqNo.intValue()%>:<%=description1%>&nbsp;</span>
       	 							</td>
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
												String criticalFlg = activity.getCriticalFlg();%>
												<td>
													<%=seqNoActivity.intValue()%>:<%=description2%>
													<input type="checkbox" name="bidActivitieId" value="<%=String.valueOf(ida)%>" class="checkboxstyle" <%=bidActivities != null && bidActivities.contains(ida) ? "checked" : ""%>>
													<%
														if(criticalFlg.equals(Constants.STEP_ACTIVITY_CRITICAL_FLAG_STATUS_YES))
														out.println("MUST HAVE");
													%>
												</td>
											<%}
										} 
									%>
								</tr>
							<%}
						}
					%>
				</table>
			</td>
		</tr>
</table>
</body>
</html>
<%
	}else{
		out.println("!!你没有相关访问权限!!");
	}
%>