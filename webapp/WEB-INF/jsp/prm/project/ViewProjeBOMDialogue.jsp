<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
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
List list  = (List)request.getAttribute("bomDetail");
if(list==null)
	list = new ArrayList();
ProjPlanBomMaster master = (ProjPlanBomMaster)request.getAttribute("master");
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
            Project BOM Detail
          </TD>
        </tr>
      </table>
    </TD>
     </TR>
      <tr>
      <%if(master.getBid()!=null){%>
        <td align="right">
          <span class="tabletext">Bid :&nbsp;</span>
        </td>

        <td align="left">
          <span class="tabletext" ><%=master.getBid().getNo()%>&nbsp;</span>
        </td>
        <td align="right">
          <span class="tabletext" >Bid Description:&nbsp;</span>
        </td>
        <td align="left">
          <span class="tabletext" ><%=master.getBid().getDescription()%>&nbsp;</span>
        </td>
        <%}%>
        <%if(master.getProject()!=null){%>
        <td align="right">
          <span class="tabletext">Project Code:&nbsp;</span>
        </td>
        <td>
          <span class="tabletext"><%=master.getProject().getProjId()%>&nbsp;</span>
        </td>
        <td align="right">
          <span class="tabletext">Project Description:&nbsp;</span>
        </td>
        <td align="left"><span class="tabletext"><%=master.getProject().getProjName()%>&nbsp;</span>
        </td>
        <%}%>
      </tr>
</table>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
<%for(int i=0;i<list.size();i++){
	ProjPlanBom bom = (ProjPlanBom)list.get(i);
%>
	<tr>
		<td>&nbsp;</td>
		<td>
		<input size="1" type="text" style="background-color:#ffffff;margin-left:<%=(bom.getRanking().length()/3)*15%>px;border:0px">
		<%=bom.getStepdesc()%>
		</td>
	</tr>
<%}%>
</table>
<table>
	<TR>
		<TD>
		<INPUT TYPE="BUTTON" VALUE="Close" onClick="javascript:window.close()" class="button">
		</TD>
	</TR>
</table>
</body>
</html>
<%

}catch(Exception e){
	e.printStackTrace();
}
%>