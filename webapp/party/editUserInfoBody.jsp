<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.component.domain.module.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
 <script language="JavaScript">
 function checkrd(){
  if (document.form1.password .value=="")
 {alert("Please entry your Password！");
 return false;
 }
  if (document.form1.password2.value=="")
 {alert("Please confirm your password！");
 return false;
 }
  if (document.form1.password2.value!=document.form1.password.value)
 {alert("The password is different！");
 return false;
 }
  if (document.form1.password.value.length<6){
  alert("The password must include more than 6 charater");
  return false;
  }
 }
</script>
<%
if (!AOFSECURITY.hasEntityPermission("USER_LOGIN_PASSWORD", "_EDIT", session)) {
%>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Password Change
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
	<%
	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	hs.flush();
	
	net.sf.hibernate.Transaction tx =null;
	
	UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);   
	String action = request.getParameter("action");
	//out.println(action);
	if(action == null){
		action = "edit";
	}else if(action.equals("edit")){
		try{
				tx = hs.beginTransaction();
				String newPassword = request.getParameter("password");
				//out.println("新口令为:"+newPassword);
				ul.setCurrent_password(newPassword);
				Calendar c = Calendar.getInstance();
				ul.setLast_update_Date(c.getTime());
				hs.update(ul);
				tx.commit();
		}catch(Exception e){
				out.println("Error:"+e.getMessage());
		}
	}
	
	if(ul != null){
	 String overduePwd=(String)request.getAttribute("overduePwd");
	 if(overduePwd!=null&& overduePwd.length()>0){%>
	<form name="form1" action="./party/editUserInfo.jsp" method="post" onSubmit="return checkrd();">
	<%}else{%>
	<form name="form1" action="./editUserInfo.jsp" method="post" onSubmit="return checkrd();">
	<%}%>
    <input type="hidden" name="action" value="<%=action%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      <%
      	if(overduePwd!=null&& overduePwd.length()>0){%>
	<tr>
	<td  colspan="2" align="left" class=lblerr> Your Password has expired! Please change it .
	</td>
	</tr>
	<%}%>
      <tr>
        <td align="right">
          <span class="tabletext">User Login:&nbsp;</span>
        </td>
        <td>
          <span class="tabletext"><%=ul.getUserLoginId()%>&nbsp;</span><input type="hidden" name="userLoginId" value="<%=ul.getUserLoginId()%>">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Password:&nbsp;</span>
        </td>
        <td align="left">
          <input type="password" class="inputBox" name="password" value="<%=ul.getCurrent_password()%>" size="20"> 
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Confirm Password:&nbsp;</span>
        </td>
        <td align="left">
          <input type="password" class="inputBox" name="password2" value="<%=ul.getCurrent_password()%>" size="20"> 
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Name:&nbsp;</span>
        </td>
        <td align="left">
          <%=ul.getName()%>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="Save" class="loginButton"/>
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
