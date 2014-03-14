<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.contract.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>

<%
	POProfile poProfile = (POProfile)request.getAttribute("CustProject");
	
	String projectId = "";
	String projectName = "";
	ContractProfile contractProfile = poProfile.getLinkProfile();
	Set set = contractProfile.getProjects();
	Iterator iterator = set.iterator();
	while (iterator.hasNext()) {
		ProjectMaster pm = (ProjectMaster)iterator.next();
		if (projectId.trim().length() == 0) {
			projectId = pm.getProjId();
			projectName = pm.getProjName();
		} else {
			projectId = projectId + "$" + pm.getProjId();
			projectName = projectName + "$" + pm.getProjName();
		}
	}
	
	SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);
%>

<html>
	<head>
		<script language="javascript">
			window.parent.returnValue = 
							"<%=poProfile.getId()%>" + "|" +
							"<%=poProfile.getNo()%>" + "|" +
							"<%=poProfile.getDescription()%>" + "|" +
							"<%=poProfile.getDepartment().getPartyId()%>" + "|" +
							"<%=poProfile.getTotalContractValue() != null ? numFormater.format(poProfile.getTotalContractValue()) : ""%>" + "|" +
							"<%=poProfile.getContractType()%>" + "|" +
							"<%=dateFormater.format(poProfile.getStartDate())%>" + "|" +
							"<%=dateFormater.format(poProfile.getEndDate())%>" + "|" +
							"<%=poProfile.getCustPaidAllowance() != null ? numFormater.format(poProfile.getCustPaidAllowance()) : ""%>" + "|" +
							"<%=poProfile.getVendor().getPartyId()%>" + "|" +
							"<%=poProfile.getVendor().getDescription()%>" + "|" +
							"<%=projectId%>" + "|" +
							"<%=projectName%>";
							
			window.parent.close();
		</script>
	</head>
	<body>
	</body>
</html>