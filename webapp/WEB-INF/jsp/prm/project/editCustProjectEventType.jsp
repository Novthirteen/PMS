<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("PROJECT_EVENT_TYPE", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();   
ProjectEventType EditDataInfo = null;
String DataStr = request.getParameter("DataId");

int i=0;
List eventTypeList = null;
try{
	// ?ù???ú????±í
	ProjectHelper ph = new ProjectHelper();
	//获得工作类型
	eventTypeList = ph.getAllEventType(hs);
	
}catch(Exception e){
	out.println(e.getMessage());
}


Iterator it = eventTypeList.iterator();
	while(it.hasNext()){
	ProjectEventType pet = (ProjectEventType)it.next();
	i++;
    } 





Integer DataId = null;
if (DataStr == null || DataStr.length()<1) {
	
} else {
	DataId = new Integer(DataStr);					
}

String FormAction = request.getParameter("FormAction");

if (DataId!=null){
	EditDataInfo = (ProjectEventType)hs.load(ProjectEventType.class,DataId);
}
	
if(FormAction == null){
	FormAction = "create";
}


	
%>
<br>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Project Event Type Maintenance
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
<%
    if(EditDataInfo != null){
    	FormAction="update";
%>
	<form Action="editCustProjectEventType.do" method="post">
    <input type="hidden" name="FormAction" value="<%=FormAction%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Code:&nbsp;</span>
        </td>
        <td>
          <span class="tabletext"><%=EditDataInfo.getPetId()%>&nbsp;</span><input type="hidden" name="DataId" value="<%=EditDataInfo.getPetId()%>">
        </td>
        <td align="right">
          <span class="tabletext">Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" value="<%=EditDataInfo.getPetName()%>" size="30">
        </td>
      </tr>
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="save" class="loginButton"/>
        </td>
      </tr>    
        <tr><td>&nbsp;</td></tr>  
    </table>
 	</form>

<%
	}else{
%>
	<form Action="editCustProjectEventType.do" method="post">
    <input type="hidden" name="FormAction" value="<%=FormAction%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Code:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="DataId" size="30" value="<%=i+1%>">
        </td>
        <td align="right">
          <span class="tabletext">Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" size="30" >
        </td>
      </tr>
      <tr><td>&nbsp;</td><td><br></td></tr>  
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="保存" class="loginButton"/>
        </td>
      </tr>      
        <tr><td>&nbsp;</td></tr>
    </table>
 	</form>
<%
	}
%> 	
  </td>
  </tr>
    <tr><td>&nbsp;</td></tr>
</table> 
  

<%
Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
