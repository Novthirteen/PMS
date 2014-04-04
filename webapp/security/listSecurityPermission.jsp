<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
if (AOFSECURITY.hasEntityPermission("SECURITY_PERMISSION", "_VIEW", session)) {

	Integer offset = null;	
	if( request.getParameter("offset") == null || request.getParameter("offset").equals("") ){
		offset = new Integer(0);
	}else{
		offset = new Integer(request.getParameter("offset"));
	}
	
	Integer length = new Integer(15);	

    request.setAttribute("offset", offset);
    request.setAttribute("length", length);
	
	 
%>
<br>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0' >
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            新增系统权限点
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0' class='boxbottom'>
        <tr>
          <td>
            <table border="0" width="100%">
              <tr>
                <td width="100%">
                <form action="editSecurityPermission.do" method="post">
                    <table border="0" width="100%">
                      <tr> 
                        <td width="100%" colspan="4"> 
                          <hr size="1" width="95%">
                        </td>
                      </tr>
                      <tr> 
                        <td width="10%" align="right"><span class="tabletext"><b>权限点编码:&nbsp;</b></span> 
                        </td>
                        <td width="10%">
                          <input type="text" class="inputBox" name="permissionId" size="30">
                        </td>
                       
                        <td width="25%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="10%" align="right"><b><span class="tabletext">描述:</span></b></td>
                        <td width="10%"> 
                          <input type="text" class="inputBox" name="description" size="30">
                        </td>
                        <td width="25%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="10%" align="right">&nbsp;</td>
                        <td width="10%"> 
                          <input type="submit" class="inputBox" value="新增" name="submit">
                        </td>
                        <td width="25%">&nbsp; </td>
                      </tr>
                    </table>
                </form>
                </td>
              </tr>
              <tr>
              <td width="100%">
       <table border='0' width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
        <tr>
          <td width='100%'>
            <table width='100%' border='0' cellspacing='0' cellpadding='0' class='boxtop'>
              <tr>
                <td valign='middle' align='center' class="wpsPortletTopTitle">
                    <p align="left">权限点列表
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td width='100%'>
            <table width='100%' border='0' cellspacing='0' cellpadding='0' class='boxbottom'>
              <tr>
                <td align="center" valign="center" width='100%'>
                 
                    <table width='100%' border='0' cellpadding='0' cellspacing='1'>
                      <tr >
                        <td align="center" width="40%" class="wpsPortletBottomTitle">
                            <div class="head3">
                            <p align="center">权限点编码
                            </div>
                        </td>
                        <td align="center" width="40%" class="wpsPortletBottomTitle">
                            <div class="head3">
                            <p align="center">权限点功能描述
                            </div>
                        </td>
                        <td align="center" width="10%" class="wpsPortletBottomTitle">
                            <div class="head3">
                            <p align="center">
                            </div>
                        </td>
                        <td align="center" width="10%" class="wpsPortletBottomTitle">
                            <div class="head3">
                            <p align="center">
                            </div>
                        </td>
                      </tr>
			<!--==================== 显示权限点列表 ====================-->
			<logic:iterate id="sp" indexId="indexId" offset="offset" length="length" name="securityPermisssions" type="com.aof.component.domain.security.SecurityPermission" > 
                      <tr>
                        <td align="center" width="40%">
                        <p align="right"><a href="editSecurityPermission.do?action=edit&permissionId=<bean:write name="sp" property="permissionId"/>"><bean:write name="sp" property="permissionId"/></a>
                        </td>
                        <td align="center" width="40%">
                            <div class="tabletext">
                            <p align="center"><bean:write name="sp" property="description"/>
                            </div>   
                        </td>
                        <td align="center" width="10%">
                            <div class="tabletext">
                            <p align="center">
                            </div>   
                        </td>
                        <td align="center" width="10%">
                            <div class="tabletext">
                            <p align="center">
                            </div>   
                        </td>
					  </tr>
			</logic:iterate> 
                      <tr>
                        <td colspan="5" align="right" width="100%">
                        <br>
							<%if(offset.intValue()>0){%>
							<image src="<%=request.getContextPath()%>/images/pre.gif"><a href="listSecurityPermission.do?offset=<%=offset.intValue()-length.intValue()%>">上一页</a>
							<%}%>
							<image src="<%=request.getContextPath()%>/images/next.gif"><a href="listSecurityPermission.do?offset=<%=offset.intValue()+length.intValue()%>">下一页</a>                      
                        </td>
                      </tr>
                    </table>

                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </TD>
  </TR>
</TABLE>
<%
}else{
	out.println("你没有相应的访问权限");
}
%>