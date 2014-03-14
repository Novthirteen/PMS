<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.util.Constants"%>
<table border="0" cellPadding="0" cellSpacing="0" width="100%">
  <tr>
    <td class="wpsPortalBanner" vAlign="center">
      <table border="0" cellPadding="0" cellSpacing="1" width="100%">
        <tbody>
          <tr>
  			<td align="left" class="wpsPortalBannerText" vAlign="center" width="90%">
			<img border="0" src="<%=request.getContextPath()%>/images/logo2.jpg" >
  			</td>
            <td align="right" background="<%=request.getContextPath()%>/images/dot.gif" class="wpsPortalBannerText"
             noWrap vAlign="center" width="10%">¡¡                  
            <%
            	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				out.print("Welcome: "+ul.getName()+"/"+ul.getParty().getDescription());
			%>
            </td>  
          </tr>
        </tbody>
      </table>
    </td>
  </tr>
  <tr >
    <td class="wpsNavbarSeparator" height="1"><img alt border="0" height="1" src="../../images/dot.gif" width="1"></td>
  </tr>
</table>
            
    