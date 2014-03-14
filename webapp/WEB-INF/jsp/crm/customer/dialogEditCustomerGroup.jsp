<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="com.aof.util.PageKeys"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language="javascript">
function fnClose()
{
	var desc = "";
	var id = "";
	with(EditForm)
	{
		id = DataId.value
		desc = description.value;
		window.parent.returnValue = id+"|"+desc;
	}
	
		window.close();	
}

</script>

<%
//if (AOFSECURITY.hasEntityPermission("PROSPECT_PARTY", "_CREATE", session)) {

CustomerAccount EditDataInfo = null;
EditDataInfo = (CustomerAccount)request.getAttribute("EditDataInfo");

if(EditDataInfo != null){
%>
<HTML>
	<HEAD>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
		<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  			<TR>
    			<TD width='100%'>
      				<table width='100%' border='0' cellspacing='0' cellpadding='0'>
        				<tr>
          					<TD align=left width='90%' class="wpsPortletTopTitle">
           	 					Customer Group Maintenance
          					</TD>
        				</tr>
      				</table>
    			</TD>
  			</TR>
  			
  			<TR>
    			<TD width='100%'>
    				<table>
						<form Action="editCustomerGroup.do" method="post" name="EditForm">
							<input type="hidden" name="FormAction" value="update">
							<input type="hidden" name="DataId" value="<%=EditDataInfo.getAccountId().longValue()%>">
							<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
							<input type="hidden" name="openType" value="dialogView">
							<table width='100%' border='0' cellpadding='0' cellspacing='2'>
								<tr>
									<td align="right">
										<span class="tabletext">Code:&nbsp;</span>
									</td>
									<td><%=EditDataInfo.getAccountId()%></td>
								</tr>
								<tr>
									<td align="right">
										<span class="tabletext">Name:&nbsp;</span>
									</td>
									<td align="left">
										<input type="text" class="inputBox" name="description" value="<%=EditDataInfo.getDescription()%>" size="30">
									</td>
								</tr>
								<tr>
									<td align="right">
										<span class="tabletext">Abbreviation:&nbsp;</span>
									</td>
									<td align="left">
										<input type="text" class="inputBox" name="Abbreviation" value="<%=EditDataInfo.getAbbreviation()%>" size="30">
									</td>
								</tr>
								<tr>
									<td align="right">
										<span class="tabletext">Type:&nbsp;</span>
									</td>
									<td align="left">
										<select name="Type">
										<option value="G" <%if(EditDataInfo.getType().equalsIgnoreCase("G"))out.print("selected");%> >Global</option>
										<option value="L" <%if(EditDataInfo.getType().equalsIgnoreCase("L"))out.print("selected");%>>Local</option>
										</select>
									</td>
								</tr>
								<tr>
									<td align="right">
										<span class="tabletext"></span>
									</td>
									<td align="left">
										<input type="submit" value="Save" class="loginButton">
									
										<input type="button" value="Close" class="loginButton" onclick="javascript:fnClose();">
									
									</td>
								</tr>
							</table>
						</form>
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>
<%
	} else {
%>
<HTML>
	<HEAD>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
		<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  			<TR>
    			<TD width='100%'>
      				<table width='100%' border='0' cellspacing='0' cellpadding='0'>
        				<tr>
          					<TD align=left width='90%' class="wpsPortletTopTitle">
           	 					Customer Group Maintenance
          					</TD>
        				</tr>
      				</table>
    			</TD>
  			</TR>
  			
  			<TR>
    			<TD width='100%'>
    				<table>
						<form Action="editCustomerGroup.do" method="post" name="EditForm">
							<input type="hidden" name="FormAction" value="create">
							<input type="hidden" name="DataId" value="">
							<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
							<input type="hidden" name="openType" value="dialogView">
							<table width='100%' border='0' cellpadding='0' cellspacing='2'>
								<tr>
									<td align="right">
										<span class="tabletext">Code:&nbsp;</span>
									</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="right">
										<span class="tabletext">Name:&nbsp;</span>
									</td>
									<td align="left">
										<input type="text" class="inputBox" name="description" value="" size="30">
									</td>
								</tr>
								<tr>
									<td align="right">
										<span class="tabletext">Abbreviation:&nbsp;</span>
									</td>
									<td align="left">
										<input type="text" class="inputBox" name="Abbreviation" value="" size="30">
									</td>
								</tr>
								<tr>
									<td align="right">
										<span class="tabletext">Type:&nbsp;</span>
									</td>
									<td align="left">
										<select name="Type">
										<option value="G">Global</option>
										<option value="L" selected>Local</option>
										</select>
									</td>
								</tr>
								<tr>
									<td align="right">
										<span class="tabletext"></span>
									</td>
									<td align="left">
										<input type="submit" value="Save" class="loginButton">
									
										<input type="button" value="Close" class="loginButton" onclick="javascript:fnClose();">
									
									</td>
								</tr>
							</table>
						</form>
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>
<%
}
//}else{
//	out.println("!!你没有相关访问权限!!");
//}
%>
