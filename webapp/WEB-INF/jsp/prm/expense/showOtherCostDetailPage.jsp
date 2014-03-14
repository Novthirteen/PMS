<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.component.prm.expense.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld"prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld"prefix="tiles"%>
<%
try {
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd");
	ProjectCostMaster findmaster = (ProjectCostMaster)request.getAttribute("findmaster");
	String DataId=request.getParameter("DataId");
	if(DataId == null ) DataId = "";
	if (findmaster != null) DataId = findmaster.getCostcode().toString();

	String FreezeFlag = (String)request.getAttribute("FreezeFlag");
	if (FreezeFlag == null) FreezeFlag = "N";
	
	String Type=request.getParameter("Type");
    if (Type == null) Type = "";
%>
<HTML>
	<HEAD>
		<title>AO-SYSTEM</title>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
		<table width=100% cellpadding="1" border="0" cellspacing="1" >
			<CAPTION align=center class=pgheadsmall>Other Cost Detail</CAPTION>
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold" align=right><bean:message key="prm.projectCostMaintain.refNoLable"/>:&nbsp</td>
				<td class="lblLight">&nbsp;
					<%=findmaster.getRefno() != null ? findmaster.getRefno() : ""%>
				</td>
				<td class="lblbold" align=right><bean:message key="prm.projectCostMaintain.costDescriptionLable"/>:&nbsp</td>
				<td class="lblLight">&nbsp;
					<%=findmaster.getCostdescription() != null ? findmaster.getCostdescription() : ""%>
				</td>
			</tr>
			<%
				List DetResult = (List)request.getAttribute("QryDetail");
				if(DetResult==null){
					DetResult = new ArrayList();
				}
				Iterator it = DetResult.iterator();
				String pcdId[] = request.getParameterValues("pcdId");
				String projId[] = request.getParameterValues("projId");
				String proj[] = request.getParameterValues("proj");
				String staffId[] = request.getParameterValues("staffId");
				String staff[] = request.getParameterValues("staff");
				if (pcdId == null) pcdId = new String[1];
				if (projId == null) projId = new String[1];
				if (proj == null) proj = new String[1];
				if (staffId == null) staffId = new String[1];
				if (staff == null) staff = new String[1];
				for (int i = 0; i < 1 ; i++) {
					if (it.hasNext()){
						ProjectCostDetail pcd = (ProjectCostDetail)it.next();
						if (proj[i] == null) proj[i] = pcd.getProjectMaster().getProjId()+":"+pcd.getProjectMaster().getProjName();
						pcdId[i] = new Integer(pcd.getPcdid()).toString();
						if (projId[i] == null) projId[i] = pcd.getProjectMaster().getProjId();
						UserLogin ul =pcd.getUserLogin();
						if (ul == null) {
							if (staffId[i] == null) staffId[i] = "";
							if (staff[i] == null) staff[i] = "";
						} else {
							if (staffId[i] == null) staffId[i] = ul.getUserLoginId();
							if (staff[i] == null) staff[i] = ul.getUserLoginId()+":"+ul.getName();
						}
					}else{
						if (proj[i] == null) proj[i] = "";
						if (pcdId[i] == null) pcdId[i] = "";
						if (projId[i] == null) projId[i] = "";
						if (staffId[i] == null) staffId[i] = "";
						if (staff[i] == null) staff[i] = "";
					}
			%>
			<tr>
				<td class="lblbold" align=right><bean:message key="prm.timesheet.projectLable"/>:&nbsp</td>
				<td class="lblLight" nowrap>&nbsp;
					<%=proj[i]%>
				</td>
				<td class="lblbold" align=right><bean:message key="prm.projectCostMaintain.staffNameLable"/>:&nbsp</td>
				<td class="lblLight">&nbsp;
					<%=staff[i]%>
				</td>
			</tr>
			<%}%>
			<tr>
				<td class="lblbold" align=right>Cost <bean:message key="prm.projectCostMaintain.typeLable"/>:&nbsp</td>
				<td class="lblLight" nowrap>&nbsp;
					<%=findmaster.getProjectCostType().getTypename()%>
				</td>
				<td class="lblbold" align=right>Paid By:&nbsp</td>
				<td class="lblLight" nowrap>&nbsp;
					<%
						if (findmaster.getClaimType().equals("CN")) {
					%>
						Company
					<%
						} else {
					%>
						Customer
					<%
						}
					%>
				</td>
			</tr>
			<tr>
				<td class="lblbold" align=right><bean:message key="prm.projectCostMaintain.PayForLable"/>:&nbsp</td>
				<td class="lblLight" nowrap>&nbsp;
					<%=findmaster.getPayFor()%>
				</td>
				<td class="lblbold" align=right>&nbsp</td>
				<td class="lblLight">&nbsp;
				</td>
			</tr>
			<tr>
				<td class="lblbold" align=right><bean:message key="prm.projectCostMaintain.currencyLable"/>:&nbsp</td>
				<td class="lblLight" nowrap>&nbsp;
					<%=findmaster.getCurrency().getCurrName()%>
				</td>
				<td class="lblbold" align=right><bean:message key="prm.projectCostMaintain.exchangeRateLable"/>(RMB):&nbsp</td>
				<td class="lblLight">&nbsp;
					<%=findmaster.getExchangerate()%>
				</td>
			</tr>
			<tr>
				<td class="lblbold" align=right><bean:message key="prm.projectCostMaintain.totalValueLable"/> (RMB) :&nbsp</td>
				<td class="lblLight">&nbsp;
					<%=findmaster.getTotalvalue()%>
				</td>
				<td class="lblbold" align=right><bean:message key="prm.projectCostMaintain.costDateLable"/>(YYYY-MM-DD):&nbsp</td>
				<td class="lblLight">&nbsp;
					<%=format.format(findmaster.getCostdate())%>
				</td>
			</tr>
			<tr>
				<td class="lblbold" align=right><bean:message key="prm.projectCostMaintain.createDateLable"/>:&nbsp</td>
				<td class="lblLight">&nbsp;
					<bean:write name="createDate"/></td>
				<td class="lblbold" align=right><bean:message key="prm.projectCostMaintain.approvalDateLable"/>:&nbsp</td>
				<td class="lblLight">&nbsp;
					<bean:write name="approvalDate"/></td>
			</tr>
			
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
			<tr>
				<td align="left" colspan="8">
					<input type="button" class="button" name="close" value="Close" onclick="window.parent.close();">
				</td>
			</tr>	
		</table>
	</body>
</html>
<%
	} catch(Exception ex) {
		ex.printStackTrace();
	}
%>