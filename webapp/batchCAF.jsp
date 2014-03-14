<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.TimeSheet.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
	String projectId = request.getParameter("projectId");
	if (projectId == null) projectId = "";
%>
<html>
	<head>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</head>
	<body>
		<table width=100% cellpadding="1" border="0" cellspacing="1">
			<CAPTION align=center class=pgheadsmall>Batch CAF</CAPTION>
			<form action="batchCAF.jsp" method="post">
				<TABLE width="100%">
					<tr>
						<td colspan=8><hr color=red></hr></td>
					</tr>
					<tr>
						<td class="lblbold">Project Id:</td>
						<td class="lblLight">
							<input type="text" name="projectId" size="15" value="<%=projectId%>" style="TEXT-ALIGN: left" class="lbllgiht">
						</td>						
					</tr>
					<tr>
						<td colspan=8><hr color=red></hr></td>
					</tr>
					<tr>
				    	<td>
							<input type="submit" value="Excute" class="button">
						</td>
					</tr>
				</table>
			</form>
		</table>
	
<%
			if (projectId != null && projectId.trim().length() != 0) {
				Transaction transaction = null; 
				
				try {
					Session sess = Hibernate2Session.currentSession();
					transaction = sess.beginTransaction();
					
					ProjectMaster pm = (ProjectMaster)sess.load(ProjectMaster.class, projectId);
					UserLogin ul = (UserLogin)sess.load(UserLogin.class, "CN01294");
					
					if (pm != null) {
						String sqlStr = "from TimeSheetDetail as td where td.Project.projId = ? ";
						net.sf.hibernate.Query query = sess.createQuery(sqlStr);
						query.setString(0, projectId);
						
						List result = query.list();
						
						int counter = 0;
						
						List unconfirmedList = new ArrayList();
						TransactionServices service = new TransactionServices();
						for (int i0 = 0; i0 < result.size(); i0++) {
							TimeSheetDetail tsd = (TimeSheetDetail)result.get(i0);
			
							if ("draft".equals(tsd.getConfirm()) 
							&& tsd.getTsHoursUser() != null
							&& tsd.getTsHoursUser().floatValue() != 0L) {
								tsd.setCAFStatusConfirm("Y");
								tsd.setTsConfirmDate(tsd.getTsDate());
								tsd.setConfirm("Confirmed");
								if (tsd.getTsHoursConfirm() == null 
								|| tsd.getTsHoursConfirm().floatValue() == 0L) {
									tsd.setTsHoursConfirm(tsd.getTsHoursUser());
								}
								if (pm.getPaidAllowance() != null
									&& tsd.getTsHoursConfirm().floatValue() == 8L
									&& (tsd.getTSAllowance() == null || tsd.getTSAllowance().floatValue() == 0L)) {
									tsd.setTSAllowance(new Float(8));
								}
								
								if (pm.getPaidAllowance() == null 
								|| pm.getPaidAllowance().doubleValue() == 0L
								|| tsd.getTsHoursConfirm().floatValue() == 8L) {
									counter++;
									sess.save(tsd);
									
									service.insert(tsd, ul);
								} else {
									unconfirmedList.add(tsd);
								}
							} else {
								
							}
						}
%>
	<table width=100% cellpadding="1" border="0" cellspacing="1">
			<CAPTION align=center class=pgheadsmall>There are <%=counter%> records have been CAFed</CAPTION>
	</table>
<%
						if (unconfirmedList.size() > 0) {
							DateFormat dateFormater = new SimpleDateFormat("yyyy/MM/dd");
							NumberFormat formater = NumberFormat.getInstance();
							formater.setMaximumFractionDigits(2);
							formater.setMinimumFractionDigits(2);
%>
		
		<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
			<CAPTION align=center class=pgheadsmall>These record below can not be batch CAFed, Plz check it manually</CAPTION>
		 	<TR bgcolor="#e9eee9">		 		
			  	<td align="center">#&nbsp;</td>
			  	<td align="center" class="lblbold">Staff ID</td>
			    <td align="center" class="lblbold">Staff Name</td>
				<td align="center" class="lblbold">Project ID</td>
			    <td align="center" class="lblbold">Project Name</td>
			    <td align="center" class="lblbold">Project Event</td>
			    <td align="center" class="lblbold">Service Type</td>
			    <td align="center" class="lblbold">Working Date</td>
			    <td align="center" class="lblbold">Staff Entry Hours</td>
			    <td align="center" class="lblbold">CAF Hours</td>
		  	</tr>
<%
							for (int i0 = 0; i0 < unconfirmedList.size(); i0 ++) {
								TimeSheetDetail tsd = (TimeSheetDetail)unconfirmedList.get(i0);
%>
			<TR bgcolor="#e9eee9">		 		
			  	<td align="center"><%=i0 + 1%></td>
			  	<td align="left"><%=tsd.getTimeSheetMaster().getTsmUser().getUserLoginId()%></td>
			    <td align="left"><%=tsd.getTimeSheetMaster().getTsmUser().getName()%></td>
				<td align="left"><%=tsd.getProject().getProjId()%></td>
			    <td align="left"><%=tsd.getProject().getProjName()%></td>
			    <td align="left"><%=tsd.getProjectEvent().getPeventName()%></td>
			    <td align="left"><%=tsd.getTSServiceType().getDescription()%></td>
			    <td align="center"><%=dateFormater.format(tsd.getTsDate())%></td>
			    <td align="right"><%=formater.format(tsd.getTsHoursUser())%></td>
			    <td align="right"><%=formater.format(tsd.getTsHoursConfirm())%></td>
		  	</tr>
<%
							}
						}
					}
				} catch(Exception e) {
					try {
						if (transaction != null) {
							transaction.rollback();
						}
					} catch (HibernateException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					e.printStackTrace();
				} finally {
					try {
						if (transaction != null) {
							transaction.commit();
						}
						Hibernate2Session.closeSession();
					} catch (HibernateException e1) {
						e1.printStackTrace();
					} catch (SQLException e1) {
						e1.printStackTrace();
					}
				}
			}
%>
	</body>
</html>