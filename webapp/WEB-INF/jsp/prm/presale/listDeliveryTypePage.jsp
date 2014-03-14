<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.master.*"%>
<%@ page import="com.aof.component.prm.presale.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="net.sf.hibernate.*"%>

<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("DELIV_TYPE", "_VIEW", session)) {

	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
%>

<form name="frm" action="ListDeliveryType.do" method="post">
<input type="hidden" name="FormAction" value="batchUpdate">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Pre-Sale Deliveriable Type List</CAPTION>
	<tr>
		<td>
		<TABLE width="100%">
				<tr>
					<td colspan=8><hr color=red></hr></td>
				</tr>
			<%
			String textcode = request.getParameter("textcode");
			if (textcode == null) textcode ="";
			%>
			<tr>
				<td class="lblbold" width="15%">Deliverable Type Name:</td>
				<td class="lblLight" width="15%"><input type="text" name="textcode" size="15" value="<%=textcode%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td></td>
			</tr>
		    <tr>
		    	<td>
					<input type="submit" value="Query" class="button">
				    <input type="button" value="New" class="button" onclick="location.replace('EditDeliveryType.do')">
				</td>
			</tr>
			<tr>
				<td colspan=8 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</td>
	</tr>
	  
	<tr>
		<td>
			<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
				<TR bgcolor="#e9eee9">
				  	<td class="lblbold">#&nbsp;</td>
				  	<td class="lblbold">Code&nbsp;</td>
				    <td align="left" class="lblbold">Description</td>
			  	</tr>
			  	<%
					SQLResults sr = (SQLResults)request.getAttribute("QryList");
					Object resultSet_data;
					boolean findData =  true;
					int i =0;
					if(sr == null){
						findData = false;
					} else if (sr.getRowCount() == 0) {
						findData = false;
					}
					if(!findData){
						out.println("<br><tr><td colspan='12' class=lblerr align='center'>No Record Found.</td></tr>");
					} else {
						for (int row =0; row < sr.getRowCount(); row++) {
							i=row+1;
				%>
						  	<tr bgcolor="#e9eee9">  
							    <td align="left"><%=i%></td>
							    <td align="left"> 
									<a href="EditDeliveryType.do?TypeId=<%=(((resultSet_data = sr.getObject(row,"Delivery_Type_Id"))==null) ? "":resultSet_data)%>&Description=<%=(((resultSet_data = sr.getObject(row,"Delivery_Type_desc"))==null) ? "":resultSet_data)%>"><%=(((resultSet_data = sr.getObject(row,"Delivery_Type_Id"))==null) ? "":resultSet_data)%></a> 
							    </td>
							    <td align="left"> 
									<%=(((resultSet_data = sr.getObject(row,"Delivery_Type_desc"))==null) ? "":resultSet_data)%>
							    </td>
							</tr>
						<%}%>
					<%}%>		
			</table>
	 	</td>
	</tr>
</table>
</form>
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}
		Hibernate2Session.closeSession();

				%>
