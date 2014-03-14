<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.bid.BidMaster"%>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{
	if (AOFSECURITY.hasEntityPermission("SALES_FUNNEL", "_CREATE", session)) {
		BidMaster mstr = (BidMaster)request.getAttribute("mstr");
		if (mstr == null) {
%>
		<%@ include file="newBidMaster.jsp" %>
<%		
		} else {
%>
		<%@ include file="updateBidMaster.jsp" %>
<%
		}
	}else{
%>
<table width=100% cellpadding="1" border="0" cellspacing="1"><tr><td align=center colspan=9 class=lblbold><font color='red'>No Permission!</font></td></tr></table>
<%
	}
} catch(Exception e){
	e.printStackTrace();
}
%>