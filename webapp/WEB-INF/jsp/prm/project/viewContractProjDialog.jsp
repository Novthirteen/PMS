<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="net.sf.hibernate.type.*"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="net.sf.hibernate.Query"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
try{
if (AOFSECURITY.hasEntityPermission("CUST_CONT_PROJECT", "_VIEW", session)) {
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
NumberFormat Num_formater2 = NumberFormat.getInstance();
Num_formater2.setMaximumFractionDigits(5);
Num_formater2.setMinimumFractionDigits(2);

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();
SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");


ProjectMaster CustProject = (ProjectMaster)request.getAttribute("CustProject");
List ServiceTypeList = (List)request.getAttribute("ServiceTypeList");
if(ServiceTypeList==null){
	ServiceTypeList = new ArrayList();
}
List partyList = null;
List partyList_dep=null;
List ptList=null;
List pcList=null;
List userLoginList=null;
List costCenterList=null;

    PartyHelper ph = new PartyHelper();
	partyList = ph.getAllCustomers(hs);
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
	if (partyList_dep == null) partyList_dep = new ArrayList();
	partyList_dep.add(0,ul.getParty());
	UserLoginHelper ulh = new UserLoginHelper();
	userLoginList = ulh.getAllUser(hs);
	//get all project type
	ProjectHelper proh= new ProjectHelper();
	ptList=proh.getAllProjectType(hs);
	pcList=proh.getAllProjectCategory(hs);
%>

<html>
<HEAD>
<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
</HEAD>
<body>
   <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <TR>
    <TD width='100%' colspan="4">
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Contract Project Detail
          </TD>
        </tr>
      </table>
    </TD>
     </TR>
      <tr>
        <td align="right">
          <span class="tabletext">Project Code:&nbsp;</span>
        </td>
        <td>
          <span class="tabletext"><%=CustProject.getProjId()%>&nbsp;</span>
        </td>
        <td align="right">
          <span class="tabletext">Project Description:&nbsp;</span>
        </td>
        <td align="left"><span class="tabletext"><%=CustProject.getProjName()%>&nbsp;</span>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Project Status:&nbsp;</span>
        </td>
        <td align="left">
            <%if (CustProject.getProjStatus().equals("WIP")){%>WIP
            <%}
             if (CustProject.getProjStatus().equals("Close")){%>Close
             <%}%>
        </td>
		<td align="right">
          <span class="tabletext">Contract No:&nbsp;</span>
        </td>
        <td align="left"><%=CustProject.getContractNo()%>&nbsp;
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Customer:&nbsp;</span>
        </td>
        <td align="left">
        <% if(CustProject.getCustomer() !=null){
        %>
        <%=CustProject.getCustomer().getPartyId()%>:<%=CustProject.getCustomer().getDescription()%>
        <%}%>
         </td>
        <td align="right">
          <span class="tabletext">Department:&nbsp;</span>
        </td>
        <td align="left">
			<%
			Iterator itd = partyList_dep.iterator();
			while(itd.hasNext()){
				Party p = (Party)itd.next();
				String chk ="";
				if (p.getPartyId().equals(CustProject.getDepartment().getPartyId())){%>
					<%=p.getDescription()%>
				<%}
				}%>
        </td>
      </tr>
         <tr>
        <td align="right">
          <span class="tabletext">Project Manager:&nbsp;</span>
        </td>
        <td align="left">
        <% if(CustProject.getProjectManager() != null){
        %>
        	<%=CustProject.getProjectManager().getUserLoginId()%>:<%=CustProject.getProjectManager().getName()%>
        <%}
        %>
        </td>
        
         <td align="right">
          <span class="tabletext"> Open for All:&nbsp;</span>
        </td>
		<td border='0' align="left">
         <%	String PublicFlag = CustProject.getPublicFlag();
			if(PublicFlag.equals("Y")){
				out.println("Yes");
				
			}else{
               
				out.println("No");
			}
		  %>
		 </td>
	  </tr>	 
      <tr>
        <td align="right">
          <span class="tabletext">Total Service Value(RMB):&nbsp;</span>
        </td>
        <td>
          <%=Num_formater.format(CustProject.gettotalServiceValue().doubleValue())%>
        </td>
		<td align="right">
          <span class="tabletext">Total Proc./Sub Value(RMB):&nbsp;</span>
        </td>
        <td>
          <%=Num_formater.format(CustProject.gettotalLicsValue().doubleValue())%>
        </td>
      </tr> 
      <tr>
        <td align="right">
          <span class="tabletext">Service Budget(RMB):&nbsp;</span>
        </td>
        <td>
          <%=Num_formater.format(CustProject.getPSCBudget().doubleValue())%>
        </td>
        <td align="right">
          <span class="tabletext">Expense Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <%=Num_formater.format(CustProject.getEXPBudget().doubleValue())%>
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Proc./Sub Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <%=Num_formater.format(CustProject.getProcBudget().doubleValue())%>
        </td>
		<td align="right">
          <span class="tabletext">Contract Type:&nbsp;</span>
        </td>
		<td align="left">
			<%String ContractType = CustProject.getContractType();
			if(ContractType.equals("FP")){
				out.println("Fixed Price");
			}else{
				out.println("Time & Material");
			}
			%>
		 </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Need CAF:&nbsp;</span>
        </td>
        <td align="left">
        	<%String CAFFlag = CustProject.getCAFFlag();
        	  if(CAFFlag.equals("Y")){%>
        	     Yes
        	  <%}
        	  if(CAFFlag.equals("N")){%>
        	     No
        	   <%}%>  
			 </td>
        <td align="right">
          <span class="tabletext">Parent Project:&nbsp;</span>
        </td>
        <% if(CustProject.getParentProject() != null){
        %>
		<td align="left"><%=CustProject.getParentProject().getProjId()%>:<%=CustProject.getParentProject().getProjName()%>
		</td>
		<%}
		%>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Start Date:&nbsp;</span>
        </td>
        <td align="left">
          <%=formater.format((java.util.Date)CustProject.getStartDate())%>
         </td>
        <td align="right">
          <span class="tabletext">End Date:&nbsp;</span>
        </td>
        <td align="left">
          <%=formater.format((java.util.Date)CustProject.getEndDate())%>
         </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Customer Paid Allowance Rate:&nbsp;</span>
        </td>
     	 <td align="left">
          <%=Num_formater.format(CustProject.getPaidAllowance())%>
        </td>
        <td align="right">
          <span class="tabletext">Project Type:&nbsp;</span>
        </td>
        <td align="left">
			<%
			Iterator itPt = ptList.iterator();
			while(itPt.hasNext()){
				ProjectType pp = (ProjectType)itPt.next();
				String chk ="";
				if (CustProject.getProjectType()!= null){
					if(CustProject.getProjectType().getPtId().equals(pp.getPtId()) ) {%>
					<%=pp.getPtId()%>:<%=pp.getPtName()%>
				<%}
				}
			}%>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Bill To Address:&nbsp;</span>
        </td>
     	<td align="left">
          <%=CustProject.getBillTo().getPartyId()%>:<%=CustProject.getBillTo().getDescription()%>
        </td>
        
        <td align="right">
          <span class="tabletext">Project Assistant:&nbsp;</span>
        </td>
        <td align="left">
			<%
			String PAId = "";
			String PAName = "";
			if (CustProject.getProjAssistant() != null) {
				PAId = CustProject.getProjAssistant().getUserLoginId();
				PAName = CustProject.getProjAssistant().getName();
			}
			%>
			<%=PAId%>:<%=PAName%>
        </td>
      </tr>
      <tr>
        <td  align=right>
          Customer Paid Expense Type:&nbsp;
        </td>
        <td colspan=3>
        <%
        	List exTypeList = hs.createQuery("select et from ExpenseType as et order by et.expSeq ASC").list();
        	java.util.Set set = CustProject.getExpenseTypes();
			if(exTypeList==null)	exTypeList = new ArrayList();
			for(int j=0; j<exTypeList.size(); j++){
			ExpenseType et = (ExpenseType)exTypeList.get(j);
			boolean checked = (set.contains(et)==true)?true:false;
			if(et.getExpAccDesc().equalsIgnoreCase("CY")){
				if(checked)
				out.println("<input type='checkbox' class='checkboxstyle' name='exTypeChk' disabled checked='"+checked+"' value='"+et.getExpId()+"'>"+et.getExpDesc()+"&nbsp;&nbsp;");
				else
				out.println("<input type='checkbox' class='checkboxstyle' name='exTypeChk' disabled value='"+et.getExpId()+"'>"+et.getExpDesc()+"&nbsp;&nbsp;");
				}
			}
        %>
        </td>
      </tr>
      <tr>
      	<td align=right>
      		Notes for Customer Claimed Expense:
      	</td>
      	<td colspan=3>
      		<TEXTAREA NAME="expenseNote" ROWS="3" COLS="60" readonly ><%if (CustProject.getExpenseNote()!= null) out.print(CustProject.getExpenseNote());%></TEXTAREA>
      	</td>
      </tr> 
</table>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='50%' class="wpsPortletTopTitle">
          <%if (ContractType.equals("TM")) {
          	out.println("Project Service Type List");
          } else {
          	out.println("Project Payment Schedule List");
          }
          %>
          </TD>
          <TD align="right" valign="center" class="wpsPortletTopTitle">
          <%
          	int rows = ServiceTypeList.size();
          %>
          	
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
	<TD width='100%'>
		<%if (ContractType.equals("TM")) {%>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
			<tr>
				<td class="lblbold" nowrap width=1%>&nbsp;#&nbsp</td>
				<td class="lblbold" nowrap width=25%>&nbsp;Name&nbsp;</td>
				<td class="lblbold" nowrap width=25%>&nbsp;Rate (RMB/DAY)&nbsp;</td>
				<td class="lblbold" nowrap width=25%>&nbsp;Sub Contract Rate (RMB/DAY)&nbsp;</td>	
				<td class="lblbold" nowrap width=25%>&nbsp;Estimated Man Days&nbsp;</td>
			</tr>
			<%
			Iterator itst = ServiceTypeList.iterator();
			for (int j = 0; j < rows ; j++) {
				String StId = "";
				String STDescription = "";
				double STRate = 0;
				double SubContractRate = 0;
				String EstimateManDays = "0";
				String EstimateDate = formater.format((java.util.Date)UtilDateTime.nowTimestamp());
				if (itst.hasNext()){
					ServiceType st = (ServiceType)itst.next();
					StId = st.getId().toString();
					STDescription = st.getDescription();
					STRate = st.getRate().doubleValue();
					SubContractRate = st.getSubContractRate().doubleValue();
					EstimateManDays = st.getEstimateManDays().toString();
					if (st.getEstimateAcceptanceDate() != null) EstimateDate = formater.format(st.getEstimateAcceptanceDate());
				}%>
			<tr>
				<td class="lbllight" nowrap>&nbsp;<%=j+1%></td>
				<td class="lbllight" nowrap>&nbsp;<%=STDescription%>
				</td>
				<td class="lbllight" nowrap>&nbsp;<%=Num_formater2.format(STRate)%>
				</td>
				<td class="lbllight" nowrap>&nbsp;<%=Num_formater2.format(SubContractRate)%>
				</td>	
				<td class="lbllight" nowrap>&nbsp;<%=EstimateManDays%>
				</td>
			</tr>
			<%}%>
		</table>
		<%} else {%>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
			<tr>
				<td class="lblbold" nowrap width=1%>&nbsp;#&nbsp</td>
				<td class="lblbold" nowrap width=20%>&nbsp;Phase&nbsp;</td>
				<td class="lblbold" nowrap width=20%>&nbsp;Contracted Service Value (RMB)&nbsp;</td>
				<td class="lblbold" nowrap width=20%>&nbsp;Contracted Sub Contract Value (RMB)&nbsp;</td>	
				<td class="lblbold" nowrap width=20%>&nbsp;Estimated Man Days&nbsp;</td>
				<td class="lblbold" nowrap width=20%>&nbsp;Estimated Close Date&nbsp;</td>
			</tr>
			<%
			Iterator itst = ServiceTypeList.iterator();
			for (int j = 0; j < rows ; j++) {
				String StId = "";
				String STDescription = "";
				double STRate = 0;
				double SubContractRate = 0;
				String EstimateManDays = "0";
				String EstimateDate = formater.format((java.util.Date)UtilDateTime.nowTimestamp());
				if (itst.hasNext()){
					ServiceType st = (ServiceType)itst.next();
					StId = st.getId().toString();
					STDescription = st.getDescription();
					STRate = st.getRate().doubleValue();
					SubContractRate = st.getSubContractRate().doubleValue();
					EstimateManDays = st.getEstimateManDays().toString();
					if (st.getEstimateAcceptanceDate() != null) EstimateDate = formater.format(st.getEstimateAcceptanceDate());
				}%>
			<tr>
				<td class="lbllight" nowrap>&nbsp;<%=j+1%></td>
				<td class="lbllight" nowrap>&nbsp;<%=STDescription%>
				</td>
				<td class="lbllight" nowrap>&nbsp;<%=Num_formater2.format(STRate)%>
				</td>
				<td class="lbllight" nowrap>&nbsp;<%=Num_formater2.format(SubContractRate)%>
				</td>	
				<td class="lbllight" nowrap>&nbsp;<%=EstimateManDays%>
				</td>
				<td class="lbllight" nowrap>&nbsp;<%=EstimateDate%>
				</td>
			</tr>
			<%}%>
		</table>
		<%}%>
	</td>
  </tr>
</table>
</body>
</html>
<%
}else{
	out.println("你没有权限访问!");
}
}catch(Exception e){
	e.printStackTrace();
}
%>