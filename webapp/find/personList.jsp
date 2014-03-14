<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%
	UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
	Party party = ul.getParty();
	PartyHelper ph = new PartyHelper();  
	
	List list = ph.getPersonsByPartyId(Hibernate2Session.currentSession(),party);
	Hibernate2Session.closeSession();

	session.setAttribute("persons",list);
	Integer length = new Integer(15);	

	Integer offset = null;	
	if( request.getParameter("offset") == null || request.getParameter("offset").equals("") ){
		offset = new Integer(0);
	}else{
		offset = new Integer(request.getParameter("offset"));
	} 
	

    request.setAttribute("offset", offset);
    request.setAttribute("length", length);	

	

%>
<form name="" action="listUserLogin.do" method="post">
<table>
<tr> 
<td >搜索登陆用户:</td>
<td>
<input type="text" name="text" value="" class="">
<input type="submit" value="查询" class="">
</td>
<td align="right">
<div class='tabContainer'>
  <a href="editUserLogin.do" class="tabButton">新增系统用户</a>
</div>
</td>
</tr>  	   
</table>
</form> 
     
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="topBox">
            登陆用户列表
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
            <table width='100%' border='0' cellspacing='0' cellpadding='0' >
              <tr>
                <td align="center" valign="center" width='100%'>
                 
                    <table width='100%' border='0' cellpadding='0' cellspacing='1'>
                      <tr >
                        <td align="center" width="30%" class="bottomBox">
                            <p align="center">登陆编码
                        </td>
                        <td align="center" width="30%" class="bottomBox">
                            <p align="center">名称
                        </td>
                        <td align="center" width="20%" class="bottomBox">
                            <p align="center">状态
                        </td>
                        <td align="center" width="20%" class="bottomBox">
                            <p align="center">角色
                       </td>
                      </tr>
						<!--==================== 显示权限点列表 ====================-->
						<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="persons" type="com.aof.component.domain.party.UserLogin" > 
			                      <tr>
			                        <td align="center" width="30%">
			                        <p align="center"><a href="editUserLogin.do?userLoginId=<bean:write name="p" property="userLoginId"/>"><bean:write name="p" property="userLoginId"/></a>
			                        </td>
			                        <td align="center" width="30%">
			                            <div class="tabletext">
			                            <p align="center"><bean:write name="p" property="name"/>
			                            </div>   
			                        </td>
			                        <td align="center" width="20%">
			                            <div class="head4">
			                            <p align="center"><bean:write name="p" property="enable"/>
			                            </div>
			                        </td>
			                        <td align="center" width="20%">
			                            <div class="head4">
			                            <p align="center"><bean:write name="p" property="role"/>
			                            </div>
			                        </td>                        
								  </tr>
						</logic:iterate> 
                    </table>
                </td>
              </tr>
            </table>
         </td>
        </tr>
</table>            