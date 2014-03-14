<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.expense.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/app.tld" prefix="app" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
try {
if (AOFSECURITY.hasEntityPermission("PROJ_EMS", "_CREATE", session)) {
	
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	NumberFormat numFormat = NumberFormat.getInstance();
	numFormat.setMaximumFractionDigits(2);
	numFormat.setMinimumFractionDigits(2);	
	
	ProjectEMS pe = (ProjectEMS)request.getAttribute("ProjectEMS");
	
	String emsInvoiceId = request.getParameter("emsInvoiceId");
	if (emsInvoiceId == null || emsInvoiceId.trim().length() == 0) {
		emsInvoiceId = "";
	}
	String qryEMSType = request.getParameter("qryEMSType");
	String qryEMSNo = request.getParameter("qryEMSNo");
	//String qryEMSDateStart = request.getParameter("qryEMSDateStart");
	//String qryEMSDateEnd = request.getParameter("qryEMSDateEnd");
	String qryDepartment = request.getParameter("qryDepartment");
	if (qryDepartment == null) {
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			qryDepartment = userLogin.getParty().getPartyId();
		}
	}
	
	//Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
	
	if (qryEMSType == null || qryEMSType.trim().length() == 0) qryEMSType =  Constants.EMS_TYPE_EMS_DELIVER;
	//if (qryEMSDateStart == null || qryEMSDateStart.trim().length() == 0) qryEMSDateStart = dateFormat.format(UtilDateTime.getDiffDay(nowDate,-30));
	//if (qryEMSDateEnd == null || qryEMSDateEnd.trim().length() == 0) qryEMSDateEnd = dateFormat.format(nowDate);

	//Date dayStart = UtilDateTime.toDate2(qryEMSDateStart + " 00:00:00.000");
	//Date dayEnd = UtilDateTime.toDate2(qryEMSDateEnd + " 23:59:59.000");
	
	if (pe == null) {
%>
	<%@ include file="newEMSPage.jsp" %>
<%
	} else {
		if (emsInvoiceId != null && emsInvoiceId.trim().length() != 0) {
%>
		<script language="javascript">
			window.parent.returnValue  = "<%=pe.getId()%>" + "|" + "<%=pe.getType()%>" + "|" + "<%=pe.getNo()%>";
			window.parent.close();
		</script>
<%
		}
%>
	<%@ include file="updateEMSPage.jsp" %>
<%
	}
}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception ex) {ex.printStackTrace();}
%>