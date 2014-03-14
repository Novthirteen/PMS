<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.contract.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.util.*"%>
<%
   try{
   String contractId = request.getParameter("contractId");
   
   net.sf.hibernate.Session session = Hibernate2Session.currentSession();
   Transaction tx = null;
   tx = hs.beginTransaction();
   POProfile poProfile = (POProfile)hs.load(POProfile,contractId);	
   String totalContractValue = poProfile.getTotalContractValue("totalContractValue");
   String contractType = poProfile.getContractType("contractType");
   	
   Set projects = poProfile.getLinkProfile().getProjects();	
   String projectIds = "";
   String projectNames = "";
   Iterator itd = projects.iterator();
   while(itd.hasNext()){
	  ProjectMaster p = (ProjectMaster)itd.next();
	  projectIds = p.getProjId()+"&";
	  projectNames = p.getProjName() + "*";
	  }
	  if(projectIds.length>0){
	    projectIds.subString(0,projectIds.length-1);
	    projectNames.subString(0,projectNames.length-1);
	  }
	}catch(Exception e){
		log.error(e.getMessage());
	}finally{
		try {
			Hibernate2Session.closeSession();
		} catch (HibernateException e1) {
			log.error(e1.getMessage());
			e1.printStackTrace();
		} catch (SQLException e1) {
			log.error(e1.getMessage());
			e1.printStackTrace();
		}
	}
%>

<script language="javascript">
  window.parent.returnValue = "<%=contractId%>" + "|" + "<%=contractNo%>" + "|" + 
                <%=contractType%> + "|" + "<%=totalContractValue%>" +
                "<%=projectIds%>" + "<%=projectNames%>";
</script>
<html>
<body>
   <input type="radio" class="radiostyle" name="contractId" value="<%=contractId%>">
   <input type="radio" class="radiostyle" name="contractNo" value="<%=contractNo%>">
   <input type="radio" class="radiostyle" name="projectDes" value="<%=projectDes%>">
</body>
</html>